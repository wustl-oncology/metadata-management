class NotesController < ApplicationController
  after_action :verify_authorized, except: [:preview]

  def preview
    @note = find_note
  end

  private
  def find_note
    @@notables.dig(params[:subject])
      &.select(:id, :notes, :updated_at)
      &.find(params[:id])
  end

  @@notables = {
    'project' => Project,
    'sample' => Sample,
    'sequencing_product' => SequencingProduct,
    'pipeline_output' => PipelineOutput
  }
end
