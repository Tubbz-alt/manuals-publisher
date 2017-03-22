class ManualPublishingAPILinksExporter
  def initialize(organisation, manual)
    @organisation = organisation
    @manual = manual
  end

  def call
    Services.publishing_api_v2.patch_links(content_id, exportable_attributes)
  end

private

  attr_reader :organisation, :manual

  def content_id
    manual.id
  end

  def exportable_attributes
    {
      links: {
        organisations: [organisation["details"]["content_id"]],
        sections: manual.sections.map(&:id),
      },
    }
  end
end
