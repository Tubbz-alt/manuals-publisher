require "duplicate_draft_deleter"

desc "Delete duplicate drafts"
task delete_duplicate_drafts: :environment do
  DuplicateDraftDeleter.new.call
end
