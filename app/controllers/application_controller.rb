class ApplicationController < ActionController::Base
  include Pagy::Backend
  include Authentication
  include Expandable
  include Pundit::Authorization

  after_action :verify_authorized, except: [:index]
  after_action :verify_policy_scoped, only: [:index, :show]
end
