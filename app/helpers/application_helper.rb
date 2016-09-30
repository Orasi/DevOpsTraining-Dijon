module ApplicationHelper
  def present(model, presenter_class)
    klass = presenter_class
    presenter = klass.new(model)
    yield(presenter) if block_given?
  end

  def build_status(status)
    case status
      when 'pass'
        content_tag(:div, 'Passed', class: 'success-box text-center')
      when 'fail'
        content_tag(:div, 'Failed', class: 'danger-box text-center')
      when 'skip'
        content_tag(:div, 'Skipped', class: 'primary-box text-center')
      else
        content_tag(:div, 'Incomplete', class: 'primary-box text-center')
    end
  end
end
