# app/controllers/api/v1/products_controller.rb
module Api
    module V1
      class ProductsController < ::Api::BaseController
        before_action :set_product, only: [:show, :update, :destroy]
        before_action :authorize_admin, only: [:create, :update, :destroy]
        
        def index
          products = Product.all
          products = apply_filters(products)
          
          render json: paginate(products)
        end
        
        def show
          render json: @product.as_json(include: [:categories, :inventory])
        end
        
        def create
          product = Product.new(product_params)
          
          if product.save
            product.publish_created_event
            render json: product, status: :created
          else
            render json: { errors: product.errors.full_messages }, status: :unprocessable_entity
          end
        end
        
        def update
          if @product.update(product_params)
            @product.publish_updated_event
            render json: @product
          else
            render json: { errors: @product.errors.full_messages }, status: :unprocessable_entity
          end
        end
        
        def destroy
          @product.update(active: false)
          @product.publish_updated_event
          head :no_content
        end
        
        private
        
        def set_product
          @product = Product.find(params[:id])
        rescue ActiveRecord::RecordNotFound
          render json: { error: 'Product not found' }, status: :not_found
        end
        
        def product_params
          permitted = params.permit(:name, :description, :price, :active)
          permitted[:sku] = generate_sku unless params[:sku].present?
          permitted
        end
        
        
        def generate_sku
          "PRD-#{SecureRandom.hex(3).upcase}"
        end
        
        def authorize_admin
          unless current_user_role == 'admin'
            render json: { error: 'Unauthorized' }, status: :forbidden
          end
        end
        
        def apply_filters(products)
          products = products.where(active: true) unless params[:include_inactive]
          products = products.where(category_id: params[:category_id]) if params[:category_id].present?
          
          if params[:price_min].present? && params[:price_max].present?
            products = products.where(price: params[:price_min]..params[:price_max])
          elsif params[:price_min].present?
            products = products.where('price >= ?', params[:price_min])
          elsif params[:price_max].present?
            products = products.where('price <= ?', params[:price_max])
          end
          
          if params[:sort_by].present?
            direction = params[:sort_direction] == 'desc' ? :desc : :asc
            products = products.order(params[:sort_by] => direction)
          else
            products = products.order(created_at: :desc)
          end
          
          products
        end
        
        def paginate(products)
          page = (params[:page] || 1).to_i
          per_page = (params[:per_page] || 20).to_i
          
          products.page(page).per(per_page)
        end
      end
    end
  end