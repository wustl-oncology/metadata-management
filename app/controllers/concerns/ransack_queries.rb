module RansackQueries
  extend ActiveSupport::Concern

  def ransack_samples(base_query: nil)
    if base_query.present?
      @q = base_query
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
      link_extra: 'data-turbo-action="advance"'
    )
  end

  def ransack_sequence_products(base_query: nil)
    if base_query.present?
      @q = base_query
    else
      @q = SequencingProduct.ransack(params[:q])
    end

    @scope = @q.result(distinct: true).eager_load(:tags, :sample).select(
      :id,
      :library_prep,
      :flow_cell_id,
      :instrument,
      :unaligned_data_path,
      :strand,
      :kit,
      :targeted_capture,
      :paired_end,
      :batch,
      :sample_id,
      :notes,
      "samples.name"
    )

    @pagy, @sequencing_products = pagy(
      @scope,
      link_extra: 'data-turbo-action="advance"'
    )
  end

  def ransack_pipeline_outputs(base_query: nil)
    if base_query.present?
      @q = base_query
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
      link_extra: 'data-turbo-action="advance"'
    )
  end

  def ransack_projects(base_query: nil)
    if base_query.present?
      @q = base_query
    else
      @q = Project.ransack(params[:q])
    end

    @scope = @q.result(distinct: true)
      .includes(:tags, :user)
      .select(
        :id,
        :name,
        :lab,
        :notes,
        :created_at,
        :updated_at,
        :user_id,
      )

    @pagy, @projects = pagy(
      @scope,
      link_extra: 'data-turbo-action="advance"'
    )
  end
end
