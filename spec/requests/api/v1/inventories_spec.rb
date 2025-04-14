# spec/requests/api/v1/inventories_spec.rb
require 'swagger_helper'

RSpec.describe 'Inventories API', type: :request do
  path '/api/v1/products/{product_id}/inventory' do
    parameter name: :product_id, in: :path, type: :integer

    get 'Retrieves inventory for a product' do
      tags 'Inventories'
      produces 'application/json'
      security [bearer_auth: []]

      response '200', 'inventory found' do
        schema type: :object,
          properties: {
            id: { type: :integer },
            product_id: { type: :integer },
            quantity: { type: :integer },
            low_stock_threshold: { type: :integer },
            created_at: { type: :string, format: 'date-time' },
            updated_at: { type: :string, format: 'date-time' }
          }
        
        let(:product) { Product.create(name: 'Test Product', description: 'Test Description', sku: 'TST-001', price: 19.99, active: true) }
        let(:product_id) { product.id }
        run_test!
      end

      response '404', 'product not found' do
        schema type: :object,
          properties: {
            error: { type: :string }
          }
        
        let(:product_id) { 'invalid' }
        run_test!
      end
    end

    put 'Updates inventory for a product' do
      tags 'Inventories'
      consumes 'application/json'
      produces 'application/json'
      security [bearer_auth: []]
      parameter name: :inventory, in: :body, schema: {
        type: :object,
        properties: {
          quantity: { type: :integer, example: 100 },
          low_stock_threshold: { type: :integer, example: 10 }
        }
      }

      response '200', 'inventory updated' do
        schema type: :object,
          properties: {
            id: { type: :integer },
            product_id: { type: :integer },
            quantity: { type: :integer },
            low_stock_threshold: { type: :integer },
            created_at: { type: :string, format: 'date-time' },
            updated_at: { type: :string, format: 'date-time' }
          }
        
        let(:product) { Product.create(name: 'Test Product', description: 'Test Description', sku: 'TST-001', price: 19.99, active: true) }
        let(:product_id) { product.id }
        let(:inventory) { { quantity: 100, low_stock_threshold: 10 } }
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
        
        let(:product) { Product.create(name: 'Test Product', description: 'Test Description', sku: 'TST-001', price: 19.99, active: true) }
        let(:product_id) { product.id }
        let(:inventory) { { quantity: -10 } }  # Invalid quantity
        run_test!
      end
    end
  end

  path '/api/v1/inventories/batch' do
    post 'Updates inventory in batch' do
      tags 'Inventories'
      consumes 'application/json'
      produces 'application/json'
      security [bearer_auth: []]
      parameter name: :batch_params, in: :body, schema: {
        type: :object,
        properties: {
          inventories: {
            type: :array,
            items: {
              type: :object,
              properties: {
                product_id: { type: :integer },
                quantity: { type: :integer }
              },
              required: ['product_id', 'quantity']
            }
          }
        },
        required: ['inventories']
      }

      response '200', 'inventories updated' do
        schema type: :object,
          properties: {
            updated: {
              type: :array,
              items: {
                type: :object,
                properties: {
                  product_id: { type: :integer },
                  quantity: { type: :integer }
                }
              }
            }
          }
        
        let(:product1) { Product.create(name: 'Product 1', description: 'Description 1', sku: 'SKU-001', price: 19.99, active: true) }
        let(:product2) { Product.create(name: 'Product 2', description: 'Description 2', sku: 'SKU-002', price: 29.99, active: true) }
        let(:batch_params) { 
          { 
            inventories: [
              { product_id: product1.id, quantity: 50 },
              { product_id: product2.id, quantity: 75 }
            ] 
          } 
        }
        run_test!
      end

      response '422', 'invalid request' do
        schema type: :object,
          properties: {
            errors: {
              type: :array,
              items: {
                type: :object,
                properties: {
                  product_id: { type: :integer },
                  errors: {
                    type: :array,
                    items: { type: :string }
                  }
                }
              }
            }
          }
        
        let(:product) { Product.create(name: 'Test Product', description: 'Test Description', sku: 'TST-001', price: 19.99, active: true) }
        let(:batch_params) { 
          { 
            inventories: [
              { product_id: product.id, quantity: -10 },  # Invalid quantity
              { product_id: 999999, quantity: 75 }        # Invalid product
            ] 
          } 
        }
        run_test!
      end
    end
  end
end