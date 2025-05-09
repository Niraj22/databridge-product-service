# config/initializers/rswag_ui.rb
Rswag::Ui.configure do |c|
    # List the Swagger endpoints that you want to be documented through the swagger-ui
    # The first parameter is the path (absolute or relative to the UI host) to the corresponding
    # JSON endpoint and the second is a title that will be displayed in the document selector
    c.swagger_endpoint '/api-docs/v1/swagger.yaml', 'API V1 Docs'
  end