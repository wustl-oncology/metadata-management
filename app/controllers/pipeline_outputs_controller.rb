class PipelineOutputsController < ApplicationController
  include RansackQueries

  def index
    ransack_pipeline_outputs
  end
end
