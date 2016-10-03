class EnvironmentPresenter < BasePresenter
  include ActionView::Helpers::TagHelper
  def display_icon()
    if self['environment_type']
      type = self['environment_type']
    else
      type = case true
               when uuid.downcase.include?('windows')
                 'Windows'
               when uuid.downcase.include?('mac')
                 'Mac'
               when uuid.downcase.include?('linux')
                 'Linux'
               when uuid.downcase.include?('android')
                 'Android'
               when uuid.downcase.include?('ios')
                 'iOS'
               else
                 'undefined'
             end
    end

    case type
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