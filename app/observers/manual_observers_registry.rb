require 'publication_logger'
require 'publishing_api_draft_manual_with_sections_exporter'
require 'publishing_api_manual_with_sections_publisher'
require 'rummager_manual_with_sections_exporter'
require 'rummager_manual_with_sections_withdrawer'
require 'publishing_api_manual_with_sections_withdrawer'

class ManualObserversRegistry
  def publication
    # The order here is important. For example content exporting
    # should happen before publishing to search.
    #
    # A draft export step follows publication logging as this ensures that
    # change notes that relate to the current draft are pushed straight to the
    # publishing API rather than on the subsequent draft-publish cycle.
    [
      PublicationLogger.new,
      PublishingApiDraftManualWithSectionsExporter.new,
      PublishingApiManualWithSectionsPublisher.new,
      RummagerManualWithSectionsExporter.new,
    ]
  end

  def republication
    # Note that these should probably always be called with the :republish
    # action as 2nd argument, but we have to leave that up to the calling
    # service, rather than being able to encode it explicitly here.
    [
      PublishingApiDraftManualWithSectionsExporter.new,
      PublishingApiManualWithSectionsPublisher.new,
      RummagerManualWithSectionsExporter.new,
    ]
  end

  def update
    [
      PublishingApiDraftManualWithSectionsExporter.new
    ]
  end
  alias_method :update_original_publication_date, :update

  def creation
    [
      PublishingApiDraftManualWithSectionsExporter.new
    ]
  end

  def withdrawal
    [
      PublishingApiManualWithSectionsWithdrawer.new,
      RummagerManualWithSectionsWithdrawer.new,
    ]
  end
end
