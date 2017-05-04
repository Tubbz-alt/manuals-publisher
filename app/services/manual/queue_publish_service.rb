require "manual_publish_task"

class Manual::QueuePublishService
  def initialize(manual_id:, context:)
    @manual_id = manual_id
    @context = context
  end

  def call
    if manual.draft?
      task = create_publish_task(manual)
      PublishManualWorker.perform_async(task.to_param, govuk_header_params)
      manual
    else
      raise InvalidStateError.new(
        "The manual with id '#{manual.id}' could not be published as it was not in a draft state."
      )
    end
  end

private

  attr_reader(
    :manual_id,
    :context,
  )

  def create_publish_task(manual)
    ManualPublishTask.create!(
      manual_id: manual.id,
      version_number: manual.version_number,
    )
  end

  def manual
    @manual ||= Manual.find(manual_id, context.current_user)
  end

  def govuk_header_params
    {
      request_id: GdsApi::GovukHeaders.headers[:govuk_request_id],
      authenticated_user: GdsApi::GovukHeaders.headers[:x_govuk_authenticated_user],
    }
  end

  class InvalidStateError < StandardError
  end
end