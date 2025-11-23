module ApplicationHelper
  def component(name, *args, **kwargs, &block)
    component = name.to_s.camelize.constantize::Component
    render(component.new(*args, **kwargs), &block)
  end

  def component_identifier(name)
    component = "#{name.to_s.camelize}::Component".constantize
    component.identifier
  end

  # Generates a WhatsApp link for inquiries
  # If a car is provided, the message includes make, model, year, price, and car URL
  def whatsapp_link(car = nil, phone_number = nil)
    # Use provided phone, environment variable, or default (with country code)
    phone = phone_number || ENV['WHATSAPP_PHONE'] || '254798749535'
    phone = phone.gsub(/[^0-9]/, '')  # strip non-digit characters

    if car
      car_url = url_for([:v1, car])
      message = "Hello, I'm interested in the #{car.make.name} #{car.model.name} (#{car.year}) - $#{number_with_delimiter(car.price)}. See details: #{v1_car_url(car)}"
    else
      message = "Hello, I'm interested in learning more about your services."
    end

    encoded_message = URI.encode_www_form_component(message)
    "https://wa.me/#{phone}?text=#{encoded_message}"
  end
end
