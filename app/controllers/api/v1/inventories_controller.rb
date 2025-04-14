# app/controllers/api/v1/inventories_controller.rb
module Api
    module V1
      class InventoriesController < ::Api::BaseController
        before_action :set_product, except: [:batch_update]
        before_action :authorize_admin
        
        def show
          render json: @product.inventory
        end
        
        def update
          if @product.inventory.update(inventory_params)
            render json: @product.inventory
          else
            render json: { errors: @product.inventory.errors.full_messages }, status: :unprocessable_entity
          end
        end
        
        def batch_update
          results = { success: [], errors: [] }
          
          ActiveRecord::Base.transaction do
            params[:inventories].each do |inventory_params|
              product = Product.find_by(id: inventory_params[:product_id])
              
              if product && product.inventory.update(quantity: inventory_params[:quantity])
                results[:success] << { product_id: product.id, quantity: product.inventory.quantity }
              else
                results[:errors] << { 
                  product_id: inventory_params[:product_id], 
                  errors: product ? product.inventory.errors.full_messages : ['Product not found'] 
                }
              end
            end
            
            raise ActiveRecord::Rollback if results[:errors].any?
          end
          
          if results[:errors].any?
            render json: { errors: results[:errors] }, status: :unprocessable_entity
          else
            render json: { updated: results[:success] }
          end
        end
        
        private
        
        def set_product
          @product = Product.find(params[:product_id])
        rescue ActiveRecord::RecordNotFound
          render json: { error: 'Product not found' }, status: :not_found
        end
        
        def inventory_params
          params.permit(:quantity, :low_stock_threshold)
        end
        
        def authorize_admin
          unless current_user_role == 'admin'
            render json: { error: 'Unauthorized' }, status: :forbidden
          end
        end
      end
    end
  end