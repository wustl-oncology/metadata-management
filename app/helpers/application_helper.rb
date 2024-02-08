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

  def half_array(array)
    len = array.size
    first = (len/2.0).ceil
    [array.take(first), array.drop(first)]
  end

  def search_tag_class(elem)
    res = case elem
    when Sample
      "is-link"
    when Project
      "is-primary"
    when SequencingProduct
      "is-warning"
    when PipelineOutput
      "is-danger"
    end

    "#{res} is-light"
  end

  def search_result_url(elem)
    case elem
    when Sample
      sample_path(elem)
    when Project
      project_path(elem)
    when SequencingProduct
      sequencing_product_path(elem)
    when PipelineOutput
      pipeline_output_path(elem)
    end
  end
end
