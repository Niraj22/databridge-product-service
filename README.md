# DataBridge Product Service

The Product Service is a key microservice in the DataBridge architecture, responsible for managing product catalog data across the platform. It provides APIs for product management, category organization, and inventory tracking.

## Overview

The Product Service is built using Ruby on Rails in API-only mode, implementing an event-driven architecture to notify other services of changes to product data. It's part of the larger DataBridge system which enables seamless data sharing across multiple applications.

## Features

- **Product Management**: Create, read, update, and deactivate products
- **Category Management**: Organize products into hierarchical categories
- **Inventory Tracking**: Monitor product stock levels
- **Price History**: Track product price changes over time
- **Event Publishing**: Publishes events when product data changes

## API Endpoints

### Products
- `GET /api/v1/products`: List all products with filtering options
- `GET /api/v1/products/:id`: Get a specific product
- `POST /api/v1/products`: Create a new product
- `PUT /api/v1/products/:id`: Update a product
- `DELETE /api/v1/products/:id`: Deactivate a product

### Categories
- `GET /api/v1/categories`: List all categories with filtering options
- `GET /api/v1/categories/:id`: Get a specific category with subcategories
- `POST /api/v1/categories`: Create a new category
- `PUT /api/v1/categories/:id`: Update a category
- `DELETE /api/v1/categories/:id`: Deactivate a category

### Inventories
- `GET /api/v1/products/:product_id/inventory`: Get product inventory
- `PUT /api/v1/products/:product_id/inventory`: Update product inventory
- `POST /api/v1/inventories/batch`: Batch update multiple product inventories

## Data Models

### Product
- `name`: Product name
- `description`: Detailed description
- `sku`: Stock keeping unit (unique identifier)
- `price`: Current price
- `active`: Whether the product is active

### Category
- `name`: Category name
- `description`: Category description
- `parent_id`: Parent category (for hierarchical structure)
- `active`: Whether the category is active

### Inventory
- `product_id`: Associated product
- `quantity`: Current stock quantity
- `low_stock_threshold`: Level at which low stock alerts are triggered

### PriceHistory
- `product_id`: Associated product
- `price`: Historical price
- `effective_from`: When this price became effective
- `effective_to`: When this price was superseded

### ProductCategory
- `product_id`: Associated product
- `category_id`: Associated category

## Event Publishing

The service publishes the following events to notify other services about changes:

- `ProductCreated`: When a new product is added
- `ProductUpdated`: When product details are modified
- `CategoryCreated`: When a new category is added
- `CategoryUpdated`: When category details are modified
- `InventoryChanged`: When product inventory levels change
- `InventoryLow`: When product inventory falls below threshold
- `PriceChanged`: When a product's price is updated

## Setup & Installation

### Prerequisites
- Ruby 3.2.2
- Rails 7.1
- PostgreSQL
- Kafka/RabbitMQ for event messaging

### Installation

1. Clone the repository:
   ```
   git clone https://github.com/your-org/databridge-product-service.git
   cd databridge-product-service
   ```

2. Install dependencies:
   ```
   bundle install
   ```

3. Setup the database:
   ```
   rails db:create db:migrate db:seed
   ```

4. Configure environment variables:
   ```
   cp .env.example .env
   # Edit .env with your configuration
   ```

5. Start the server:
   ```
   rails s -p 3002
   ```

## Testing

Run the test suite with:

```
rails spec
```

## Dependencies

- `databridge_shared`: Shared utilities for the DataBridge platform
- `jwt`: For JWT authentication
- `kafka-ruby`: For event publishing
- `kaminari`: For pagination

## Integration with Other Services

The Product Service interacts with other DataBridge services:
- **API Gateway**: Routes product-related requests to this service
- **Order Service**: Consumes product events to update order data
- **Analytics Service**: Consumes product events for reporting

## Event Subscriptions

The Product Service listens for these events from other services:
- `OrderCreated`: To update inventory and track product popularity
- `OrderCanceled`: To potentially restore inventory

## Development

### Adding a New Product Feature

1. Add the model and migrations
2. Create the controller and routes
3. Implement event publishing
4. Update the API documentation (Swagger)

### Creating New Event Types

1. Define the event schema in `databridge_shared` gem
2. Add the publishing code to the relevant model
3. Create handlers in consuming services

## Related Services

- [DataBridge API Gateway](https://github.com/Niraj22/databridge-api-gateway)
- [DataBridge Customer Service](https://github.com/Niraj22/databridge-customer-service)
- [DataBridge Order Service](https://github.com/Niraj22/databridge-order-service)
- [DataBridge Analytics Service](https://github.com/Niraj22/databridge-analytics-service)

## License

[MIT License](LICENSE)
