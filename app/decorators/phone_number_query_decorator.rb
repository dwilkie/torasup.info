class PhoneNumberQueryDecorator < Draper::Decorator
  def phone_number
    return if !model.phone_number
    formatted_number = phony_format(model.phone_number)
    (dt_tag("check", :text => model.class.human_attribute_name(:phone_number)) + dd_tag { h.link_to(formatted_number, tel_href(formatted_number)) }).html_safe
  end

  def phone_number_type
    return if !model.phone_number_type
    (dt_tag("info-circle", :text => model.class.human_attribute_name(:phone_number_type)) + dd_tag { model.phone_number_type.humanize }).html_safe
  end

  def operator
    operator_info = [operator_name, operator_contact_info].compact.join(" | ").html_safe.presence
    return if !operator_info
    (dt_tag("building", :text => model.class.human_attribute_name(:operator)) + dd_tag { operator_info }).html_safe
  end

  def operator_ceo
    ceo_info = [model.operator_ceo_name, operator_ceo_contact_info].compact.join(" | ").html_safe.presence
    return if !ceo_info
    (dt_tag("suitcase", :text => model.class.human_attribute_name(:operator_ceo)) + dd_tag { ceo_info }).html_safe
  end

  def location
    return if location_elements.empty?
    (dt_tag("location-arrow", :text => model.class.human_attribute_name(:location)) + dd_tag { location_link }).html_safe
  end

  private

  def operator_name
    model.operator_branding || model.operator_name
  end

  def operator_contact_info
    [operator_customer_service_phone, operator_facebook, operator_website].compact.join(" | ")
  end

  def operator_customer_service_phone
    (model.operator_customer_service_phone && h.link_to(h.fa_icon(:phone), tel_href(phony_format(model.operator_customer_service_phone)), :id => "operator_customer_service_phone")).presence
  end

  def operator_facebook
    (model.operator_facebook && h.link_to(h.fa_icon(:facebook), model.operator_facebook, :id => "operator_facebook")).presence
  end

  def operator_website
    (model.operator_website && h.link_to(h.fa_icon(:globe), model.operator_website, :id => "operator_website")).presence
  end

  def operator_ceo_contact_info
    [operator_ceo_phone, operator_ceo_email, operator_ceo_linked_in].compact.join(" | ")
  end

  def operator_ceo_phone
    (model.operator_ceo_phone && h.link_to(h.fa_icon(:phone), tel_href(phony_format(model.operator_ceo_phone)), :id => "operator_ceo_phone")).presence
  end

  def operator_ceo_email
    (model.operator_ceo_email && h.mail_to(model.operator_ceo_email, h.fa_icon(:envelope), :id => "operator_ceo_email")).presence
  end

  def operator_ceo_linked_in
    (model.operator_ceo_linked_in && h.link_to(h.fa_icon(:linkedin), model.operator_ceo_linked_in, :id => "operator_ceo_linked_in")).presence
  end

  def location_elements
    @location_elements ||= [model.location_area, model.location_country_name].compact
  end

  def location_link
    h.link_to(location_elements.join(", "), "http://maps.google.com?#{location_link_query}")
  end

  def location_link_query
    Rack::Utils.build_query(:q => location_elements.join(" "))
  end

  def tel_href(number)
    "tel:#{number}"
  end

  def phony_format(number)
    Phony.format(Phony.normalize(number))
  end

  def dt_tag(icon, options = {})
    h.content_tag(:dt) { h.fa_icon(icon, options) }
  end

  def dd_tag(&block)
    h.content_tag(:dd) { yield }
  end
end
