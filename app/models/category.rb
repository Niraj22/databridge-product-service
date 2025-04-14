# app/models/category.rb
class Category < ApplicationRecord
    # Relationships
    belongs_to :parent, class_name: 'Category', optional: true
    has_many :subcategories, class_name: 'Category', foreign_key: 'parent_id'
    has_many :product_categories, dependent: :destroy
    has_many :products, through: :product_categories
    
    # Validations
    validates :name, presence: true
    
    # Scopes
    scope :active, -> { where(active: true) }
    scope :root, -> { where(parent_id: nil) }
    
    # Event publishing methods
    def publish_created_event
      event_data = {
        id: id,
        name: name,
        parent_id: parent_id,
        created_at: created_at.iso8601
      }
      
      publisher = DataBridgeShared::Clients::EventPublisher.new
      publisher.publish('CategoryCreated', event_data)
    end
    
    def publish_updated_event
      event_data = {
        id: id,
        name: name,
        parent_id: parent_id,
        updated_at: updated_at.iso8601
      }
      
      publisher = DataBridgeShared::Clients::EventPublisher.new
      publisher.publish('CategoryUpdated', event_data)
    end
  end