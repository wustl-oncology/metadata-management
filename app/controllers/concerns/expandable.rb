module Expandable
  extend ActiveSupport::Concern

  included do
    before_action :set_expanded
  end

  def set_expanded
    @expanded = if params[:expanded]
                  true
                else
                  false
                end
  end

end
