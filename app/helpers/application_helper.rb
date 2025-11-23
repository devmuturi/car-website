module ApplicationHelper
  def component(name, *args, **kwargs, &block)
    component = name.to_s.camelize.constantize::Component
    render(component.new(*args, **kwargs), &block)
  end

  def component_identifier(name)
    component = "#{name.to_s.camelize}::Component".constantize
    component.identifier
  end
end
