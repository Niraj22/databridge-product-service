# app/models/product.rb
class Product < ApplicationRecord
    # Relationships
    has_many :product_categories, dependent: :destroy
    has_many :categories, through: :product_categories
    has_one :inventory, dependent: :destroy
    has_many :price_histories, dependent: :destroy
    
    # Validations
    validates :name, presence: true
    validates :sku, presence: true, uniqueness: true
    validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
    
    # Scopes
    scope :active, -> { where(active: true) }
    
    # Callbacks
    after_create :create_inventory
    after_create :create_initial_price_history
    after_save :update_price_history, if: :saved_change_to_price?

    # Event publishing methods
    def publish_created_event
      event_data = {
        id: id,
        name: name,
        sku: sku,
        price: price,
        created_at: created_at.iso8601
      }
      
      publisher = DataBridgeShared::Clients::EventPublisher.new
      publisher.publish('ProductCreated', event_data)
    end
    
    def publish_updated_event
      event_data = {
        id: id,
        name: name,
        sku: sku,
        price: price,
        updated_at: updated_at.iso8601
      }
      
      publisher = DataBridgeShared::Clients::EventPublisher.new
      publisher.publish('ProductUpdated', event_data)
    end
    
    private
    
    def create_inventory
      build_inventory(quantity: 0, low_stock_threshold: 5).save
    end
    
    def create_initial_price_history
      price_histories.create(
        price: price,
        effective_from: created_at,
        effective_to: nil
      )
    end
    
    def update_price_history
      # Close the current price history record
      current_price_history = price_histories.where(effective_to: nil).first
      if current_price_history
        current_price_history.update(effective_to: Time.current)
      end
      
      # Create a new price history record
      price_histories.create(
        price: price,
        effective_from: Time.current,
        effective_to: nil
      )
      
      # Publish price change event
      publisher = DataBridgeShared::Clients::EventPublisher.new
      publisher.publish('PriceChanged', {
        product_id: id,
        old_price: current_price_history&.price,
        new_price: price,
        changed_at: Time.current.iso8601
      })
    end
  end