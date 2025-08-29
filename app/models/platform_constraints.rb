# frozen_string_literal: true

class PlatformConstraints
  PLATFORMS = %w[
    Terra
    GMS
    DRAGEN
    GCP
  ]

  def self.pipelines_for(platform:)
    Pipeline.where(platform: platform).pluck(:name)
  end

  def self.id_format_for(platform:)
    ID_FORMATS.fetch(platform, [])
  end

  ID_FORMATS = {
    'Terra' => [/\A\d+\z/, 'Numeric'],
    'DRAGEN' => [/\A\d+\z/, 'Numeric'],
    'GMS' => [/\A[0-9a-f]{32}\z/i, 'UUID'],
    'GCP' => [/\A[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\z/i, 'UUID']
  }
end
