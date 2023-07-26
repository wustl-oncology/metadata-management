module RansackQueries
  extend ActiveSupport::Concern

  def ransack_samples(project_id: nil)
    if project_id
      @q = Sample.joins(:projects)
        .where(projects: { id: @project.id  })
        .ransack(params[:q])
    else
      @q = Sample.ransack(params[:q])
    end

    @scope = @q.result(distinct: true).includes(:tags).select(
      :id,
      :name,
      :species,
      :disease_status,
      :individual,
      :timepoint,
      :notes
    )

    @pagy, @samples = pagy(
      @scope,
      link_extra: 'data-turbo-frame="projects_table" data-turbo-action="advance"'
    )
  end

  def ransack_sequence_products(project_id: nil)
    if project_id
      @q = SequencingProduct
        .joins(sample: [:projects])
        .where(samples: { projects: { id: project_id }})
        .ransack(params[:q])
    else
      @q = SequencingProduct.ransack(params[:q])
    end

    @scope = @q.result(distinct: true).includes(:tags, :sample).select(
      :id,
      :library_prep,
      :flow_cell_id,
      :instrument,
      :unaligned_data_path,
      :sample_id,
      :notes
    )

    @pagy, @sequencing_products = pagy(
      @scope,
      link_extra: 'data-turbo-frame="projects_table" data-turbo-action="advance"'
    )
  end

  def ransack_pipeline_outputs(project_id: nil)
    if project_id
      @q = PipelineOutput
        .where(project_id: project_id)
        .ransack(params[:q])
    else
      @q = PipelineOutput.ransack(params[:q])
    end

    @scope = @q.result(distinct: true)
      .includes(:tags, :project, :user, :sequencing_products)
      .select(
        :id,
        :platform,
        :pipeline_name,
        :pipeline_version,
        :platform_identifier,
        :data_location,
        :project_id,
        :user_id,
        :notes
      )

    @pagy, @pipeline_outputs = pagy(
      @scope,
      link_extra: 'data-turbo-frame="projects_table" data-turbo-action="advance"'
    )
  end
end
