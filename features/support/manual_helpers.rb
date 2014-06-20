module ManualHelpers
  def create_manual(fields)
    visit new_manual_path
    fill_in_fields(fields)

    save_as_draft
  end

  def create_manual_document(manual_title, fields)
    go_to_manual_page(manual_title)
    click_on "Add Section"

    fill_in_fields(fields)

    save_as_draft
  end

  def edit_manual(manual_title, new_fields)
    go_to_edit_page_for_manual(manual_title)
    fill_in_fields(new_fields)

    save_as_draft
  end

  def edit_manual_document(manual_title, section_title, new_fields)
    go_to_manual_page(manual_title)
    click_on section_title
    click_on "Edit"
    fill_in_fields(new_fields)

    save_as_draft
  end

  def save_as_draft
    click_on "Save as draft"
  end

  def publish_manual
    click_on "Publish"
  end

  def check_manual_exists_with(attributes)
    go_to_manual_page(attributes.fetch(:title))
    expect(page).to have_content(attributes.fetch(:summary))
  end

  def check_manual_document_exists_with(manual_title, attributes)
    go_to_manual_page(manual_title)
    click_on(attributes.fetch(:section_title))

    attributes.values.each do |attr_val|
      expect(page).to have_content(attr_val)
    end
  end

  def go_to_edit_page_for_manual(manual_title)
    go_to_manual_page(manual_title)
    click_on("Edit Manual")
  end

  def check_for_errors_for_fields(field)
    page.should have_content("#{field.titlecase} can't be blank")
  end

  def go_to_manual_page(manual_title)
    visit manuals_path
    click_link manual_title
  end

  def check_manual_slug_was_reserved(slug)
    expect(fake_panopticon).to have_received(:create_artefact!)
      .with(
        hash_including(
          slug: slug,
          kind: "manual",
          rendering_app: "manuals-frontend",
        )
      )
  end

  def check_manual_document_slug_was_reserved(slug)
    expect(fake_panopticon).to have_received(:create_artefact!)
      .with(
        hash_including(
          slug: slug,
          kind: "manual-section",
          rendering_app: "manuals-frontend",
        )
      )
  end

  def check_manual_was_published_to_panopticon(slug, attrs)
    expect(fake_panopticon).to have_received(:put_artefact!)
      .with(
        panopticon_id_for_slug(slug),
        hash_including(
          name: attrs.fetch(:title),
          slug: slug,
          state: "live",
          kind: "manual",
          rendering_app: "manuals-frontend",
        )
      ).at_least(:once)
  end

  def check_manual_section_was_published_to_panopticon(slug, attrs)
    expect(fake_panopticon).to have_received(:put_artefact!)
      .with(
        panopticon_id_for_slug(slug),
        hash_including(
          name: attrs.fetch(:title),
          slug: slug,
          state: "live",
          kind: "manual-section",
          rendering_app: "manuals-frontend",
        )
      ).at_least(:once)
  end

  def check_manual_is_published_to_content_api(manual_slug, manual_attrs, document_slug, document_attrs)
    rendered_manual = RenderedManual.find_by_slug(manual_slug)

    expect(rendered_manual.section_groups.first.fetch("sections")).to include(
      {
        "slug" => document_slug,
        "title" => document_attrs.fetch(:title),
        "summary" => document_attrs.fetch(:summary),
      }
    )

    rendered_section = RenderedSpecialistDocument.find_by_slug(document_slug)
    expect(rendered_section.title).to eq(document_attrs.fetch(:title))
    expect(rendered_section.summary).to eq(document_attrs.fetch(:summary))
  end

  def check_manual_document_is_published_to_content_api(attrs)
    check_for_published_document_with(attrs.except(:body))
  end

  def check_manual_and_documents_were_published(manual_slug, manual_attrs, document_slug, document_attrs)
    check_manual_was_published_to_panopticon(manual_slug, manual_attrs)
    check_manual_section_was_published_to_panopticon(document_slug, document_attrs)

    check_manual_is_published_to_content_api(manual_slug, manual_attrs, document_slug, document_attrs)
    check_manual_document_is_published_to_content_api(document_attrs)
    check_manual_change_note_is_set_to_default(manual_slug)
  end

  def create_manual_document_for_preview(manual_title, fields)
    go_to_manual_page(manual_title)
    click_on "Add Section"
    fill_in_fields(fields)
  end

  def check_for_document_body_preview(text)
    within(".preview") do
      expect(page).to have_css("p", text: text)
    end
  end

  def copy_embed_code_for_attachment_and_paste_into_manual_document_body(title)
    snippet = within(".attachments") do
      page
        .find("li", text: /#{title}/)
        .find("span.snippet")
        .text
    end

    body_text = find("#document_body").value
    fill_in("Section body", with: body_text + snippet)
  end

  def change_note_slug(manual_slug)
    change_note_slug = [manual_slug, "updates"].join("/")
  end

  def check_manual_change_note_exported(manual_slug, expected_note)
    slug = change_note_slug(manual_slug)

    exported_history = ManualChangeHistory
      .find_by_slug(slug)

    most_recent_section_update = exported_history.updates.last

    expect(most_recent_section_update.fetch("change_note"))
      .to eq(@change_note)
  end

  def check_manual_change_note_artefact_was_created(manual_slug)
    slug = change_note_slug(manual_slug)

    expect(fake_panopticon).to have_received(:create_artefact!).with(hash_including(slug: slug, state: "draft"))
  end

  def check_manual_change_note_is_set_to_default(manual_slug)
    slug = change_note_slug(manual_slug)

    change_history = ManualChangeHistory.find_by_slug(slug)

    expect(change_history.updates.first.fetch("change_note")).to eq("New section added.")
  end
end