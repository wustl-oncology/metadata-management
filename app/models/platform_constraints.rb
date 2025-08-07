# frozen_string_literal: true

class PlatformConstraints
  PLATFORMS = %w[
    Terra
    GMS
    DRAGEN
    GCP
  ]

  def self.pipelines_for(platform:)
    PIPELINES.fetch(platform, [])
  end

  def self.id_format_for(platform:)
    ID_FORMATS.fetch(platform, [])
  end

  # TODO: - make this configurable externally
  PIPELINES = {
    'Terra' => [
      'RnaSeq',
      'Somatic Variant',
      'Vaccine Trial'
    ],
    'GMS' => [
      'ClinSeq',
      'ReferenceAlignment',
      'RnaSeq',
      'SomaticVariation',
      'June 2019 RNAseq HISAT StringTie Kallisto QC ParamFix'
    ],
    'DRAGEN' => [
      'Somatic Variant'
    ],
    'GCP' => [
      'Some WDL'
    ]
  }

  ID_FORMATS = {
    'Terra' => [/\A\d+\z/, 'Numeric'],
    'DRAGEN' => [/\A\d+\z/, 'Numeric'],
    'GMS' => [/\A[0-9a-f]{32}\z/i, 'UUID'],
    'GCP' => [/\A[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\z/i, 'UUID']
  }
end
