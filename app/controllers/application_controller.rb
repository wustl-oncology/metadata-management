class ApplicationController < ActionController::Base
  include Pagy::Backend
  include Authentication
end
