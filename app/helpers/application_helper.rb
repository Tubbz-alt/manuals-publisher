module ApplicationHelper
  def facet_options(facet)
    finder_schema.options_for(facet)
  end

  def document_state(document)
    state = document.publication_state

    if %w(published withdrawn).include?(state) && document.draft?
      state << ' with new draft'
    end

    state
  end

  def nav_link_to(text, href)
    link_to(text, href)
  end

  def bootstrap_class_for(flash_type)
    case flash_type
      when :success
        "alert-success" # Green
      when :error
        "alert-danger" # Red
      when :alert
        "alert-warning" # Yellow
      when :notice
        "alert-info" # Blue
      else
        flash_type.to_s
    end
  end
end
