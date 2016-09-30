class UserPresenter < BasePresenter

  def display_name
    return "#{self['first_name']} #{self['last_name']}"
  end

end