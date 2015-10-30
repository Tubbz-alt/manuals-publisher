When(/^I create a employment appeal tribunal decision$/) do
  @document_title = "Example employment appeal tribunal decision"
  @slug = "employment-appeal-tribunal-decisions/example-employment-appeal-tribunal-decision"
  @document_fields = employment_appeal_tribunal_decision_fields(title: @document_title)

  create_employment_appeal_tribunal_decision(@document_fields)
end

Then(/^the employment appeal tribunal decision has been created$/) do
  fields = @document_fields
  fields["Hidden indexable content"] = "## Header Praesent commodo cursus magna, vel scelerisque nisl consectetur et. Praesent commodo cursus magna, vel scelerisque nisl c..."

  check_employment_appeal_tribunal_decision_exists_with(fields)
end

When(/^I create a employment appeal tribunal decision with invalid fields$/) do
  @document_fields = employment_appeal_tribunal_decision_fields(
    title: "",
    summary: "",
    body: "<script>alert('Oh noes!)</script>",
    "Decision date" => "Bad data",
  )

  create_employment_appeal_tribunal_decision(@document_fields)
end

Then(/^the employment appeal tribunal decision should not have been created$/) do
  check_document_does_not_exist_with(@document_fields)
end

Given(/^two employment appeal tribunal decisions exist$/) do
  @document_fields = employment_appeal_tribunal_decision_fields(title: "employment appeal tribunal decision 1")
  create_employment_appeal_tribunal_decision(@document_fields)

  @document_fields = employment_appeal_tribunal_decision_fields(title: "employment appeal tribunal decision 2")
  create_employment_appeal_tribunal_decision(@document_fields)
end

Then(/^the employment appeal tribunal decisions should be in the publisher report index in the correct order$/) do
  visit employment_appeal_tribunal_decisions_path

  check_for_documents("employment appeal tribunal decision 2", "employment appeal tribunal decision 1")
end

Given(/^a draft employment appeal tribunal decision exists$/) do
  @document_title = "Example employment appeal tribunal decision"
  @slug = "employment-appeal-tribunal-decisions/example-employment-appeal-tribunal-decision"
  @document_fields = employment_appeal_tribunal_decision_fields(title: @document_title)
  @rummager_fields = employment_appeal_tribunal_decision_rummager_fields(title: @document_title)

  create_employment_appeal_tribunal_decision(@document_fields)
end

When(/^I edit a employment appeal tribunal decision$/) do
  @new_title = "Edited Example employment appeal tribunal decision"
  edit_employment_appeal_tribunal_decision(@document_title, title: @new_title)
end

When(/^I edit an employment appeal tribunal decision and remove required fields$/) do
  edit_employment_appeal_tribunal_decision(@document_title, summary: "")
end

Then(/^the employment appeal tribunal decision should not have been updated$/) do
  expect(page).to have_content("Summary can't be blank")
end

Then(/^the employment appeal tribunal decision should have been updated$/) do
  check_for_new_employment_appeal_tribunal_decision_title(@new_title)
end

Given(/^there is a published employment appeal tribunal decision with an attachment$/) do
  @document_title = "Example employment appeal tribunal decision"
  @attachment_title = "My attachment"

  @slug = "employment-appeal-tribunal-decisions/example-employment-appeal-tribunal-decision"
  @document_fields = employment_appeal_tribunal_decision_fields(title: @document_title)

  create_employment_appeal_tribunal_decision(@document_fields, publish: true)
  add_attachment_to_document(@document_title, @attachment_title)
end

Given(/^a published employment appeal tribunal decision exists$/) do
  @document_title = "Example employment appeal tribunal decision"
  @slug = "employment-appeal-tribunal-decisions/example-employment-appeal-tribunal-decision"
  @document_fields = employment_appeal_tribunal_decision_fields(title: @document_title)

  create_employment_appeal_tribunal_decision(@document_fields, publish: true)
end

When(/^I withdraw an employment appeal tribunal decision$/) do
  withdraw_employment_appeal_tribunal_decision(@document_fields.fetch(:title))
end

Then(/^the employment appeal tribunal decision should be withdrawn$/) do
  check_document_is_withdrawn(@slug, @document_fields.fetch(:title))
end

When(/^I am on the employment appeal tribunal decision edit page$/) do
  go_to_edit_page_for_employment_appeal_tribunal_decision(@document_fields.fetch(:title))
end

Then(/^the employment appeal tribunal decision should be in draft$/) do
  expect(page).to have_content("Publication state draft")
end

When(/^I publish the employment appeal tribunal decision$/) do
  go_to_show_page_for_employment_appeal_tribunal_decision(@document_title)
  publish_document
end

Then(/^the employment appeal tribunal decision should be published$/) do
  check_document_is_published(@slug, @rummager_fields)
end

When(/^I publish a new employment appeal tribunal decision$/) do
  @document_title = "Example employment appeal tribunal decision"
  @slug = "employment-appeal-tribunal-decisions/example-employment-appeal-tribunal-decision"
  @document_fields = employment_appeal_tribunal_decision_fields(title: @document_title)
  @rummager_fields = employment_appeal_tribunal_decision_rummager_fields(title: @document_title)

  create_employment_appeal_tribunal_decision(@document_fields, publish: true)
end
