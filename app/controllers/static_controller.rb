class StaticController < ApplicationController
  skip_before_action :ensure_signed_in
  skip_after_action :verify_authorized

  def index
    render layout: false
  end
end
