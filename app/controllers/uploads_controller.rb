class UploadsController < ApplicationController
  before_action :set_project
  skip_after_action :verify_policy_scoped

  def new
    @upload_type = params[:upload_type]
    @template_file = if params[:upload_type] == 'sample'
              "/sample-upload-template.tsv"
             else
              "/pipeline-output-upload-template.tsv"
             end
    authorize @project, policy_class: UploadPolicy
  end

  def create
    authorize @project, policy_class: UploadPolicy

    if params[:import]
      @upload = Upload.create!(
        project_id: params[:project_id],
        sample_file: params[:import]
      )

      upload_type = if params[:upload_type] == 'sample'
                      UploadedSampleRow
                    else
                      UploadedPipelineOutputRow
                    end

      ImportTsvData.set(wait: 2.seconds).perform_later(@upload, upload_type, current_user)
      redirect_to project_upload_path(@project, @upload), status: :see_other
    end
  end

  def show
    @upload = Upload.find(params[:id])
  end

  private
  def set_project
    @project = Project.find(params.permit(:project_id)[:project_id])
  end
end
