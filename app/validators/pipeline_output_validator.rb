class PipelineOutputValidator < ActiveModel::Validator
  PATH_REGEX = Regexp.new(%r{\A(/|[^/]+://[^/]).+\z})

  def validate(record)
    valid_pipelines = PlatformConstraints.pipelines_for(platform: record.platform)

    record.errors.add(:platform, "Unsupported platform #{record.platform}") if valid_pipelines.blank?

    if record.pipeline_name && !valid_pipelines.include?(record.pipeline_name)
      record.errors.add(:pipeline_name, ": #{record.pipeline_name} on #{record.platform} is not a known pipeline")
    end

    PlatformConstraints.id_format_for(platform: record.platform)

    # if record.platform_identifier.present? && !(record.platform_identifier =~ id_format_regex)
    #   record.errors.add(:platform_identifier, "isn't in the expected format: #{id_format_name}")
    # end

    return unless record.data_location.present? && !(record.data_location =~ PATH_REGEX)

    record.errors.add(:data_location, "doesn't look like a valid path")
  end
end
