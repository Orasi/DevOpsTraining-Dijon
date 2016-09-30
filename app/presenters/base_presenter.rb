class BasePresenter < SimpleDelegator
  def initialize(model)
    # raise Exception unless model
    @model = model
    super(@model)
  end

  def method_missing(method, *opts)
    return super unless @model

    m = method.to_s
    if @model.has_key?(m)
      return @model[m]
    elsif @model.has_key?(m.to_sym)
      return @model[m.to_sym]
    end
    super
  end

  def updated_at
    if @model['updated_at']
      return DateTime.parse(@model['updated_at'])
    else
      return nil
    end
  end

  def created_at
    if @model['created_at']
      return DateTime.parse(@model['created_at'])
    else
      return nil
    end
  end

end
