module ApplicationHelper
  include Pagy::Frontend

  def input_error_class(model, field)
    if model.errors.include?(field)
      'is-danger'
    else
      ''
    end
  end

  def error_message(model, field)
    if model.errors.include?(field)
      tag.p(model.errors.full_messages_for(field).join(','), class: 'help is-danger')
    else
      nil
    end
  end

  def icon_for_status(status)
    if status == :success
      'check-circle'
    else
      'circle-slash'
    end
  end
end
