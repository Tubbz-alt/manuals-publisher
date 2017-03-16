require "forwardable"

class SectionViewAdapter < SimpleDelegator
  extend ActiveModel::Naming
  include ActiveModel::Conversion

  def initialize(manual, section)
    @manual = manual
    @section = section
    super(section)
  end

  def persisted?
    section.updated_at || section.published?
  end

  def minor_update
    section.draft? ? section.minor_update : false
  end

  def change_note
    section.draft? ? section.change_note : ""
  end

  def to_param
    section.id
  end

  def self.model_name
    ActiveModel::Name.new(self, nil, "Document")
  end

private

  attr_reader :manual, :section
end
