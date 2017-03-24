class ManualPublicationLogFilter
  def initialize(manual_record)
    @manual_record = manual_record
    @manual_slug = manual_record.slug
  end

  def delete_logs_and_rebuild_for_major_updates_only!
    PublicationLog.with_slug_prefix(@manual_slug).destroy_all

    build_logs_for_all_first_section_editions_at_manual_edition_time
    build_logs_for_all_other_suitable_section_editions
  end

  class EditionOrdering
    def initialize(section_editions, document_ids)
      @section_editions = section_editions
      @document_ids = document_ids
    end

    def sort_by_document_ids_and_created_at
      editions_not_matching_supplied_sections = @section_editions.where(:document_id.nin => @document_ids)
      editions_matching_supplied_sections = @section_editions.where(:document_id.in => @document_ids)

      order_by_document_ids(editions_matching_supplied_sections).concat(editions_not_matching_supplied_sections.order_by(:created_at, :asc).to_a)
    end

  private

    def order_by_document_ids(section_editions)
      section_editions.to_a.sort do |a, b|
        a_index = @document_ids.index(a.document_id)
        b_index = @document_ids.index(b.document_id)

        a_index <=> b_index
      end
    end
  end

private

  def build_logs_for_all_first_section_editions_at_manual_edition_time
    section_editions_for_first_manual_edition.map do |section_edition|
      PublicationLog.create!(
        title: section_edition.title,
        slug: section_edition.slug,
        version_number: section_edition.version_number,
        change_note: section_edition.change_note,
        created_at: first_manual_edition.updated_at,
        updated_at: first_manual_edition.updated_at
      )

      section_edition.document_id
    end
  end

  def build_logs_for_all_other_suitable_section_editions
    edition_ordering = EditionOrdering.new(section_editions_for_rebuild, @manual_record.latest_edition.document_ids)

    edition_ordering.sort_by_document_ids_and_created_at.each do |edition|
      PublicationLog.create!(
        title: edition.title,
        slug: edition.slug,
        version_number: edition.version_number,
        change_note: edition.change_note,
        created_at: edition.exported_at || edition.updated_at,
        updated_at: edition.exported_at || edition.updated_at
      )
    end
  end

  def section_editions_for_first_manual_edition
    @section_editions_for_first_manual_edition ||= SectionEdition.where(:document_id.in => first_manual_edition.document_ids, :minor_update.nin => [true], version_number: 1).any_of({ state: "published" }, state: "archived")
  end

  def first_manual_edition
    @first_manual_edition ||= @manual_record.editions.where(version_number: 1).first
  end

  def section_editions_for_rebuild
    ids_to_ignore = section_editions_for_first_manual_edition.map(&:_id)

    SectionEdition.with_slug_prefix(@manual_slug).where(:minor_update.nin => [true], :_id.nin => ids_to_ignore).any_of({ state: "published" }, state: "archived")
  end
end
