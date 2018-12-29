class BasePresenter < SimpleDelegator

  def initialize(model, view)
    @view = view
    @model = model
    super(model)
  end

  def h
    @view
  end

end