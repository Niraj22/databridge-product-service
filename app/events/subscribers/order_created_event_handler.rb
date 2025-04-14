# app/events/subscribers/order_created_event_handler.rb
module Events
  module Subscribers
    class OrderCreatedEventHandler
        def handle(event)
          Rails.logger.info("Received OrderCreated event: #{event.inspect}")
          
          # Process the order items to update inventory
          return unless event["line_items"].present?
          
          event["line_items"].each do |item|
            product_id = item["product_id"]
            quantity = item["quantity"]
            
            inventory = Inventory.find_by(product_id: product_id)
            if inventory
              new_quantity = [0, inventory.quantity - quantity].max
              inventory.update(quantity: new_quantity)
              
              Rails.logger.info("Updated inventory for product #{product_id}: #{inventory.quantity} -> #{new_quantity}")
            else
              Rails.logger.warn("Could not find inventory for product #{product_id}")
            end
          end
        end
      end
    end
  end