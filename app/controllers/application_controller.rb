class ApplicationController < ActionController::API
    before_action :authenticate_request
    
    private
    
    def authenticate_request
      header = request.headers['Authorization']
      header = header.split(' ').last if header

      begin
        # Use the shared secret for decoding
        decoded = DataBridgeShared::Auth::JwtHelper.decode(header, Rails.application.credentials.jwt_secret_key)
        
        # Extract user details from token
        payload = decoded&.first
        @current_user_id = payload['user_id'] if payload
        @current_user_role = payload['role'] if payload && payload['role'].present?
      rescue JWT::DecodeError
        render json: { error: 'Unauthorized' }, status: :unauthorized
      end
    end
    
    def current_user_id
      @current_user_id
    end
    
    def current_user_role
      @current_user_role
    end
end