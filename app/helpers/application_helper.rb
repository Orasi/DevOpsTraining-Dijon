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

  include ActionView::Helpers::TagHelper
  def display_icon_for(env_type)

    case env_type
      when 'Apple'
        content_tag(:i, nil, class: 'fa fa-apple', style: 'font-size: 16px;')
      when 'Mac'
        content_tag(:i, nil, class: 'fa fa-apple', style: 'font-size: 16px;')
      when 'iOS'
        content_tag(:i, nil, class: 'fa fa-apple', style: 'font-size: 16px;')
      when 'Windows'
        content_tag(:i, nil, class: 'fa fa-windows', style: 'font-size: 16px;')
      when 'Windows Phone'
        content_tag(:i, nil, class: 'fa fa-windows', style: 'font-size: 16px;')
      when 'Linux'
        content_tag(:i, nil, class: 'fa fa-linux', style: 'font-size: 16px;')
      when 'Unix'
        content_tag(:i, nil, class: 'fa fa-linux', style: 'font-size: 16px;')
      when 'Android'
        content_tag(:i, nil, class: 'fa fa-android', style: 'color:#a4c639; font-size: 16px;')
      when 'undefined'
        content_tag(:i, nil, class: 'fa fa-question-circle', style: 'color:grey; font-size: 16px;')
    end
  end

end
