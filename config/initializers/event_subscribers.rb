# config/initializers/event_subscribers.rb
Rails.application.config.after_initialize do
    return if Rails.env.test? || !defined?(::Kafka)
    
    begin
      kafka_config = Rails.application.credentials.kafka
      
      subscriber = DataBridgeShared::Clients::EventSubscriber.new(
        seed_brokers: kafka_config[:brokers],
        client_id: kafka_config[:client_id],
        consumer_group: kafka_config[:consumer_group]
      )
      
      # Register event handlers
      # subscriber.subscribe('OrderCreated', Events::Subscribers::OrderCreatedEventHandler.new)
      # subscriber.subscribe('OrderStatusChanged', Events::Subscribers::OrderStatusChangedEventHandler.new)
      
      Rails.logger.info "Product Service event subscribers registered successfully"
    rescue => e
      Rails.logger.error "Failed to register event subscribers: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
    end
  end