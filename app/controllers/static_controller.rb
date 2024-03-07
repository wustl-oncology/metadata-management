class StaticController < ApplicationController
  skip_before_action :ensure_signed_in
  skip_after_action :verify_authorized
  skip_after_action :verify_policy_scoped

  def index
    if current_user
      redirect_to projects_path
    else
      render layout: false
    end
  end
end
