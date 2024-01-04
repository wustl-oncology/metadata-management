class UsersController < ApplicationController
  before_action :set_user
  skip_after_action :verify_authorized, :verify_policy_scoped

  def show
  end

  def refresh_token
    @user.generate_api_key(force: true)
    @user.save!
  end

  private
  def set_user
    @user = current_user
  end
end
