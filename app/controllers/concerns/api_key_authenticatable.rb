module ApiKeyAuthenticatable
  extend ActiveSupport::Concern

  include ActionController::HttpAuthentication::Basic::ControllerMethods
  include ActionController::HttpAuthentication::Token::ControllerMethods

  attr_reader :current_user

  def authenticate_with_api_key!
    @current_user = authenticate_or_request_with_http_token &method(:authenticator)
  end

  def authenticate_with_api_key
    @current_user = authenticate_with_http_token &method(:authenticator)
  end

  private

  attr_writer :current_user

  def authenticator(http_token, options)
    User.find_by(api_key: http_token)
  end
end

