class AdminController < ApplicationController
  skip_after_action :verify_authorized
  skip_after_action :verify_policy_scoped
  skip_before_action :ensure_signed_in

  before_action :ensure_admin
end
