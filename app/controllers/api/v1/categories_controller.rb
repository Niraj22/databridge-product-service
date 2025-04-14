# app/controllers/api/v1/categories_controller.rb
module Api
    module V1
      class CategoriesController < ::Api::BaseController
        before_action :set_category, only: [:show, :update, :destroy]
        before_action :authorize_admin, only: [:create, :update, :destroy]
        
        def index
          categories = Category.all
          categories = categories.where(active: true) unless params[:include_inactive]
          
          if params[:parent_id].present?
            categories = categories.where(parent_id: params[:parent_id])
          elsif params[:root].present?
            categories = categories.root
          end
          
          render json: categories
        end
        
        def show
          render json: @category.as_json(include: :subcategories)
        end
        
        def create
          category = Category.new(category_params)
          
          if category.save
            category.publish_created_event
            render json: category, status: :created
          else
            render json: { errors: category.errors.full_messages }, status: :unprocessable_entity
          end
        end
        
        def update
          if @category.update(category_params)
            @category.publish_updated_event
            render json: @category
          else
            render json: { errors: @category.errors.full_messages }, status: :unprocessable_entity
          end
        end
        
        def destroy
          @category.update(active: false)
          @category.publish_updated_event
          head :no_content
        end
        
        private
        
        def set_category
          @category = Category.find(params[:id])
        rescue ActiveRecord::RecordNotFound
          render json: { error: 'Category not found' }, status: :not_found
        end
        
        def category_params
          params.permit(:name, :description, :parent_id, :active)
        end
        
        def authorize_admin
          unless current_user_role == 'admin'
            render json: { error: 'Unauthorized' }, status: :forbidden
          end
        end
      end
    end
  end