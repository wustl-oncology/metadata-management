class UploadsController < ApplicationController
  before_action :set_project

  def new
  end

  def create
    if params[:import]
      @upload = Upload.create!(
        project_id: params[:project_id],
        sample_file: params[:import]
      )

      ImportSampleData.set(wait: 2.seconds).perform_later(@upload)
      redirect_to project_upload_path(@project, @upload), status: :see_other
    end
  end

  def show
    @upload = Upload.find(params[:id])
  end 


  private
  def set_project
    @project = Project.find(params[:project_id])
  end
end
