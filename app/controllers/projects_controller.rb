class ProjectsController < ApplicationController
  include RansackQueries
  include TableDownloader

  before_action :set_project, only: [:show, :edit, :update]

  def index
    @q = Project.ransack(params[:q])

    scope = @q.result(distinct: true).includes(:tags, :lab).select(:id, :name, :notes, :lab_id)

    @pagy, @projects = pagy(
      scope,
      link_extra: 'data-turbo-action="advance"'
    )

    respond_to do |format|
      format.html
      format.turbo_stream
      format.tsv { stream_table(results: scope, filename: 'projects', formatter: TsvFormatters::Project.new)  }
    end
  end

  def show
    setup_table_queries
  end

  def edit
    authorize @project
  end

  def new
    @project = Project.new
    authorize @project
    @labs = LabMembership.where(user: current_user, permissions: 'write').includes(:lab).map(&:lab)
  end

  def create
    @project = Project.new(project_params.merge({user: current_user}))

    authorize @project

    if @project.save
      redirect_to @project
    else
      @labs = LabMembership.where(user: current_user, permissions: 'write').includes(:lab).map(&:lab)
      render :new
    end
  end

  def update
    authorize @project

    if @project.update(project_params)
      redirect_to @project
    else
      render :edit
    end
  end

  private
  def project_params
    params.require(:project).permit(:name, :lab_id, :notes)
  end

  def set_project
    @project = Project.includes(:tags, :user, :lab).find(params.permit(:id)[:id])
  end

  def setup_table_queries
    @table_name = if params[:display] == 'sequencing_products'
                    q = SequencingProduct
                      .joins(sample: [:projects])
                      .where(samples: { projects: { id: @project.id }})
                    ransack_sequence_products(base_query: q)
                    'projects/project_sequencing_products'
                  elsif params[:display] == 'pipeline_outputs'
                    q = PipelineOutput
                        .where(project_id: @project.id)
                    ransack_pipeline_outputs(base_query: q)
                    'projects/project_pipeline_outputs'
                  else
                    q = Sample.joins(:projects)
                      .where(projects: { id: @project.id  })
                    ransack_samples(base_query: q)
                    'projects/project_samples'
                  end
  end
end
