class ApplicationController < ActionController::Base
  include Pagy::Backend
  include Authentication
  include Expandable
  include Pundit::Authorization

  after_action :verify_authorized, except: [:show, :index]
end
