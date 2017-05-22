class ManualsRepublisher
  attr_reader :logger

  def initialize(logger)
    @logger = logger
  end

  def execute(manuals)
    count = manuals.count

    logger.info "Republishing #{count} manuals..."

    manuals.to_a.each.with_index do |manual, i|
      begin
        logger.info("[ #{i} / #{count} ] id=#{manual.id} slug=#{manual.slug}]")
        service = Manual::RepublishService.new(
          manual_id: manual.id,
          user: User.gds_editor,
        )
        service.call
      rescue Manual::RemovedSectionIdNotFoundError => e
        logger.error("Did not publish manual with id=#{manual.id} slug=#{manual.slug}. It has at least one removed document which was not found: #{e.message}")
        next
      end
    end

    logger.info "Republishing of #{count} manuals complete."
  end
end
