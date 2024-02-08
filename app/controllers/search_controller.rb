class SearchController < ApplicationController

  def index
    @query = params.permit(:query)[:query]

    if @query.present?
      wildcard = "%#{@query}%"
      projects = policy_scope(Project).basic_search(name: @query).limit(5).load_async
      samples = policy_scope(Sample).where('name ILIKE ?', wildcard).limit(5).load_async
      pos = policy_scope(PipelineOutput).where('data_location ILIKE ?', wildcard).limit(5).load_async
      sps = policy_scope(SequencingProduct).where('unaligned_data_path ILIKE ?', wildcard).limit(5).load_async

      @results = projects + samples + pos + sps
    else
      skip_policy_scope
    end
  end
end
