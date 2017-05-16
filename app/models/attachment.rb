require "services"

class Attachment
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title
  field :filename
  field :file_id, type: String
  field :file_url, type: String

  embedded_in :section_edition

  before_save :upload_file, if: :file_has_changed?

  def snippet
    "[InlineAttachment:#{filename}]"
  end

  def file
    raise ApiClientNotPresent unless Services.attachment_api
    unless file_id.nil?
      @attachments ||= {}
      @attachments[field] ||= Services.attachment_api.asset(file_id)
    end
  end

  def file=(file)
    @file_has_changed = true
    @uploaded_file = file
  end

  def file_has_changed?
    @file_has_changed
  end

  def upload_file
    raise ApiClientNotPresent unless Services.attachment_api
    begin
      if file_id.nil?
        response = Services.attachment_api.create_asset(file: @uploaded_file)
        self.file_id = response["id"].split("/").last
      else
        response = Services.attachment_api.update_asset(file_id, file: @uploaded_file)
      end
      self.file_url = response["file_url"]
    rescue GdsApi::HTTPNotFound => e
      raise "Error uploading file. Is the Asset Manager service available?\n#{e.message}"
    rescue StandardError
      errors.add(:file_id, "could not be uploaded")
    end
  end

  class ::ApiClientNotPresent < StandardError; end
end
