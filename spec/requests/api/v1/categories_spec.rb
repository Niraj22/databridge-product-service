# spec/requests/api/v1/categories_spec.rb
require 'swagger_helper'

RSpec.describe 'Categories API', type: :request do
  path '/api/v1/categories' do
    get 'Lists categories' do
      tags 'Categories'
      produces 'application/json'
      parameter name: :include_inactive, in: :query, type: :boolean, required: false
      parameter name: :parent_id, in: :query, type: :integer, required: false
      parameter name: :root, in: :query, type: :boolean, required: false

      response '200', 'categories found' do
        schema type: :array,
          items: {
            type: :object,
            properties: {
              id: { type: :integer },
              name: { type: :string },
              description: { type: :string },
              parent_id: { type: :integer, nullable: true },
              active: { type: :boolean },
              created_at: { type: :string, format: 'date-time' },
              updated_at: { type: :string, format: 'date-time' }
            }
          }
        
        let!(:category) { Category.create(name: 'Test Category', description: 'Test Description', active: true) }
        run_test!
      end
    end

    post 'Creates a category' do
      tags 'Categories'
      consumes 'application/json'
      produces 'application/json'
      security [bearer_auth: []]
      parameter name: :category, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string, example: 'New Category' },
          description: { type: :string, example: 'Category description' },
          parent_id: { type: :integer, example: 1, nullable: true },
          active: { type: :boolean, example: true }
        },
        required: ['name']
      }

      response '201', 'category created' do
        schema type: :object,
          properties: {
            id: { type: :integer },
            name: { type: :string },
            description: { type: :string },
            parent_id: { type: :integer, nullable: true },
            active: { type: :boolean },
            created_at: { type: :string, format: 'date-time' },
            updated_at: { type: :string, format: 'date-time' }
          }
        
        let(:category) { { name: 'New Category', description: 'Category description' } }
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
        
        let(:category) { { description: 'Missing name' } }  # Missing required name
        run_test!
      end
    end
  end

  path '/api/v1/categories/{id}' do
    parameter name: :id, in: :path, type: :integer

    get 'Retrieves a category' do
      tags 'Categories'
      produces 'application/json'

      response '200', 'category found' do
        schema type: :object,
          properties: {
            id: { type: :integer },
            name: { type: :string },
            description: { type: :string },
            parent_id: { type: :integer, nullable: true },
            active: { type: :boolean },
            created_at: { type: :string, format: 'date-time' },
            updated_at: { type: :string, format: 'date-time' },
            subcategories: {
              type: :array,
              items: {
                type: :object,
                properties: {
                  id: { type: :integer },
                  name: { type: :string },
                  description: { type: :string },
                  parent_id: { type: :integer },
                  active: { type: :boolean }
                }
              }
            }
          }
        
        let(:category) { Category.create(name: 'Test Category', description: 'Test Description', active: true) }
        let(:id) { category.id }
        run_test!
      end

      response '404', 'category not found' do
        schema type: :object,
          properties: {
            error: { type: :string }
          }
        
        let(:id) { 'invalid' }
        run_test!
      end
    end

    put 'Updates a category' do
      tags 'Categories'
      consumes 'application/json'
      produces 'application/json'
      security [bearer_auth: []]
      parameter name: :category_params, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string, example: 'Updated Category' },
          description: { type: :string, example: 'Updated description' },
          parent_id: { type: :integer, example: 2, nullable: true },
          active: { type: :boolean, example: true }
        }
      }

      response '200', 'category updated' do
        schema type: :object,
          properties: {
            id: { type: :integer },
            name: { type: :string },
            description: { type: :string },
            parent_id: { type: :integer, nullable: true },
            active: { type: :boolean },
            created_at: { type: :string, format: 'date-time' },
            updated_at: { type: :string, format: 'date-time' }
          }
        
        let(:category_record) { Category.create(name: 'Test Category', description: 'Test Description', active: true) }
        let(:id) { category_record.id }
        let(:category_params) { { name: 'Updated Category', description: 'Updated description' } }
        run_test!
      end

      response '404', 'category not found' do
        schema type: :object,
          properties: {
            error: { type: :string }
          }
        
        let(:id) { 'invalid' }
        let(:category_params) { { name: 'Updated Category' } }
        run_test!
      end
    end

    delete 'Deactivates a category' do
      tags 'Categories'
      security [bearer_auth: []]

      response '204', 'category deactivated' do
        let(:category) { Category.create(name: 'Test Category', description: 'Test Description', active: true) }
        let(:id) { category.id }
        run_test!
      end

      response '404', 'category not found' do
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