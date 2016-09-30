class CurrentUserPresenter < BasePresenter

  def display_name
    return "#{self['first_name']} #{self['last_name']}"
  end

  def first_name
    self['first_name']
  end

  def last_name
    self['last_name']
  end

end