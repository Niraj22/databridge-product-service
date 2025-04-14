# app/models/inventory.rb
class Inventory < ApplicationRecord
  # Relationships
  belongs_to :product
  
  # Validations
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :low_stock_threshold, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  
  # Callbacks
  after_save :check_low_stock
  after_save :publish_inventory_changed_event, if: :saved_change_to_quantity?
  
  # Methods
  def update_quantity(amount)
    update(quantity: quantity + amount)
  end
  
  def low_stock?
    quantity <= low_stock_threshold
  end
  
  private
  
  def check_low_stock
    if low_stock?
      kafka_config = Rails.application.credentials.kafka
      publisher = DataBridgeShared::Clients::EventPublisher.new(
        seed_brokers: kafka_config[:brokers],
        client_id: kafka_config[:client_id]
      )
      publisher.publish('InventoryLow', {
        product_id: product_id,
        quantity: quantity,
        threshold: low_stock_threshold,
        detected_at: Time.current.iso8601
      })
    end
  end
  
  def publish_inventory_changed_event
    kafka_config = Rails.application.credentials.kafka
    publisher = DataBridgeShared::Clients::EventPublisher.new(
      seed_brokers: kafka_config[:brokers],
      client_id: kafka_config[:client_id]
    )
    publisher.publish('InventoryChanged', {
      product_id: product_id,
      old_quantity: quantity_before_last_save,
      new_quantity: quantity,
      changed_at: Time.current.iso8601
    })
  end
end