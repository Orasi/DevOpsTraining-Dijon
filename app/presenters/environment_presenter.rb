class EnvironmentPresenter < BasePresenter
  include ActionView::Helpers::TagHelper
  include ApplicationHelper

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

    display_icon_for type
  end
end