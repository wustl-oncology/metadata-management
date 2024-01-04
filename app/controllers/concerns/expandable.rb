module Expandable
  extend ActiveSupport::Concern

  included do
    before_action :set_expanded
    helper_method :expand_toggle_path
    helper_method :show_expand_controls?
  end

  def set_expanded
    @expanded = ActiveRecord::Type::Boolean.new.deserialize(params[:expanded])
  end

  def expand_toggle_path(current_val)
    current_params = if request.params[:q]
                       { q: request.params[:q] }
                     else
                       {}
                     end
    current_params[:expanded] = !current_val

    "#{request.path}?#{current_params.to_query}"
  end

  def show_expand_controls?
    true
  end
end
