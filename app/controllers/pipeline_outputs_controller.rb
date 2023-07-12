class PipelineOutputsController < ApplicationController
  include ApiKeyAuthenticatable

  skip_before_action :ensure_signed_in, only: [:create]

  protect_from_forgery except: :create
  prepend_before_action :authenticate_with_api_key!, only: [:create]

  before_action :set_project

  def new
  end

  def create
    head :ok
  end

  def show
  end 


  private
  def set_project
  end
end
