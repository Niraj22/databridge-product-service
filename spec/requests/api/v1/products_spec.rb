# spec/requests/api/v1/products_spec.rb
require 'swagger_helper'

RSpec.describe 'Products API', type: :request do
  path '/api/v1/products' do
    get 'Lists products' do
      tags 'Products'
      produces 'application/json'
      parameter name: :page, in: :query, type: :integer, required: false
      parameter name: :per_page, in: :query, type: :integer, required: false
      parameter name: :category_id, in: :query, type: :integer, required: false
      parameter name: :price_min, in: :query, type: :number, required: false
      parameter name: :price_max, in: :query, type: :number, required: false
      parameter name: :sort_by, in: :query, type: :string, required: false
      parameter name: :sort_direction, in: :query, type: :string, required: false, enum: ['asc', 'desc']
      parameter name: :include_inactive, in: :query, type: :boolean, required: false

      response '200', 'products found' do
        schema type: :array,
          items: {
            type: :object,
            properties: {
              id: { type: :integer },
              name: { type: :string },
              description: { type: :string },
              sku: { type: :string },
              price: { type: :number, format: 'float' },
              active: { type: :boolean },
              created_at: { type: :string, format: 'date-time' },
              updated_at: { type: :string, format: 'date-time' }
            }
          }
        
        let!(:product) { Product.create(name: 'Test Product', description: 'Test Description', sku: 'TST-001', price: 19.99, active: true) }
        run_test!
      end
    end

    post 'Creates a product' do
      tags 'Products'
      consumes 'application/json'
      produces 'application/json'
      security [bearer_auth: []]
      parameter name: :product, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string, example: 'New Product' },
          description: { type: :string, example: 'Product description' },
          sku: { type: :string, example: 'PRD-001' },
          price: { type: :number, format: 'float', example: 29.99 },
          active: { type: :boolean, example: true }
        },
        required: ['name', 'sku', 'price']
      }

      response '201', 'product created' do
        schema type: :object,
          properties: {
            id: { type: :integer },
            name: { type: :string },
            description: { type: :string },
            sku: { type: :string },
            price: { type: :number, format: 'float' },
            active: { type: :boolean },
            created_at: { type: :string, format: 'date-time' },
            updated_at: { type: :string, format: 'date-time' }
          }
        
        let(:product) { { name: 'New Product', sku: 'PRD-001', price: 29.99 } }
        run_test!
      end

      response '422', 'invalid request' do
        schema type: :object,
          properties: {
            errors: { 
              type: :array,
              items: { type: :string }
            }
          }
        
        let(:product) { { name: 'Invalid Product' } }  # Missing required fields
        run_test!
      end
    end
  end

  path '/api/v1/products/{id}' do
    parameter name: :id, in: :path, type: :integer

    get 'Retrieves a product' do
      tags 'Products'
      produces 'application/json'

      response '200', 'product found' do
        schema type: :object,
          properties: {
            id: { type: :integer },
            name: { type: :string },
            description: { type: :string },
            sku: { type: :string },
            price: { type: :number, format: 'float' },
            active: { type: :boolean },
            created_at: { type: :string, format: 'date-time' },
            updated_at: { type: :string, format: 'date-time' },
            categories: {
              type: :array,
              items: { 
                type: :object,
                properties: {
                  id: { type: :integer },
                  name: { type: :string }
                }
              }
            },
            inventory: {
              type: :object,
              properties: {
                id: { type: :integer },
                quantity: { type: :integer },
                low_stock_threshold: { type: :integer }
              }
            }
          }
        
        let(:product) { Product.create(name: 'Test Product', description: 'Test Description', sku: 'TST-001', price: 19.99, active: true) }
        let(:id) { product.id }
        run_test!
      end

      response '404', 'product not found' do
        schema type: :object,
          properties: {
            error: { type: :string }
          }
        
        let(:id) { 'invalid' }
        run_test!
      end
    end

    put 'Updates a product' do
      tags 'Products'
      consumes 'application/json'
      produces 'application/json'
      security [bearer_auth: []]
      parameter name: :product_params, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string, example: 'Updated Product' },
          description: { type: :string, example: 'Updated description' },
          price: { type: :number, format: 'float', example: 39.99 },
          active: { type: :boolean, example: true }
        }
      }

      response '200', 'product updated' do
        schema type: :object,
          properties: {
            id: { type: :integer },
            name: { type: :string },
            description: { type: :string },
            sku: { type: :string },
            price: { type: :number, format: 'float' },
            active: { type: :boolean },
            created_at: { type: :string, format: 'date-time' },
            updated_at: { type: :string, format: 'date-time' }
          }
        
        let(:product_record) { Product.create(name: 'Test Product', description: 'Test Description', sku: 'TST-001', price: 19.99, active: true) }
        let(:id) { product_record.id }
        let(:product_params) { { name: 'Updated Product', price: 39.99 } }
        run_test!
      end

      response '404', 'product not found' do
        schema type: :object,
          properties: {
            error: { type: :string }
          }
        
        let(:id) { 'invalid' }
        let(:product_params) { { name: 'Updated Product' } }
        run_test!
      end
    end

    delete 'Deactivates a product' do
      tags 'Products'
      security [bearer_auth: []]

      response '204', 'product deactivated' do
        let(:product) { Product.create(name: 'Test Product', description: 'Test Description', sku: 'TST-001', price: 19.99, active: true) }
        let(:id) { product.id }
        run_test!
      end

      response '404', 'product not found' do
        schema type: :object,
          properties: {
            error: { type: :string }
          }
        
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end
end