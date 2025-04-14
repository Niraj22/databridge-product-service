# app/events/subscribers/order_status_changed_event_handler.rb
module Events
    module Subscribers
      class OrderStatusChangedEventHandler
        def handle(event)
          Rails.logger.info("Received OrderStatusChanged event: #{event.inspect}")
  
          order_id     = event["id"]
          new_status   = event["status"]
          old_status   = event["previous_status"]
  
          return unless order_id.present? && new_status.present?
  
          # Only restore inventory if order is canceled and was previously processing or fulfilled
          if new_status == "canceled" && %w[processing fulfilled].include?(old_status)
            restore_inventory(order_id)
          else
            Rails.logger.info("No inventory update needed. From #{old_status} to #{new_status}")
          end
        end
  
        private
  
        def restore_inventory(order_id)
          order = Order.includes(:line_items).find_by(id: order_id)
          unless order
            Rails.logger.warn("Order not found for ID: #{order_id}")
            return
          end
  
          order.line_items.each do |item|
            product_id = item.product_id
            quantity   = item.quantity
  
            inventory = Inventory.find_by(product_id: product_id)
            if inventory
              new_quantity = inventory.quantity + quantity
              inventory.update(quantity: new_quantity)
  
              Rails.logger.info("Restored inventory for product #{product_id}: +#{quantity}, new quantity: #{new_quantity}")
            else
              Rails.logger.warn("Inventory not found for product #{product_id}")
            end
          end
        end
      end
    end
  end