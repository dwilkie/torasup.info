class PhoneNumberQueryDecorator < Draper::Decorator
  def phone_number
    return if !model.phone_number
    formatted_number = Phony.format(Phony.normalize(model.phone_number))
    (dt_tag("check", :text => model.class.human_attribute_name(:phone_number)) + dd_tag { h.link_to(formatted_number, "tel:#{formatted_number}") }).html_safe
  end

  def phone_number_type
    return if !model.phone_number_type
    (dt_tag("phone", :text => model.class.human_attribute_name(:phone_number_type)) + dd_tag { model.phone_number_type.humanize }).html_safe
  end

  def operator
    company_info = [operator_name, operator_facebook, operator_website].compact.join(" | ").html_safe.presence
    return if !company_info
    (dt_tag("building", :text => model.class.human_attribute_name(:operator)) + dd_tag { company_info }).html_safe
  end

  def operator_ceo
    return if !model.operator_ceo
    (dt_tag("suitcase", :text => model.class.human_attribute_name(:operator_ceo)) + dd_tag { model.operator_ceo }).html_safe
  end

  def location
    return if location_elements.empty?
    (dt_tag("location-arrow", :text => model.class.human_attribute_name(:location)) + dd_tag { location_link }).html_safe
  end

  private

  def dt_tag(icon, options = {})
    h.content_tag(:dt) { h.fa_icon(icon, options) }
  end

  def dd_tag(&block)
    h.content_tag(:dd) { yield }
  end

  def operator_facebook
    (model.operator_facebook && h.link_to(h.fa_icon(:facebook), model.operator_facebook)).presence
  end

  def operator_website
    (model.operator_website && h.link_to(h.fa_icon(:globe), model.operator_website)).presence
  end

  def operator_name
    model.operator_branding || model.operator_name
  end

  def location_elements
    @location_elements ||= [model.area, model.country_name].compact
  end

  def location_link
    h.link_to(location_elements.join(", "), "http://maps.google.com?#{location_link_query}")
  end

  def location_link_query
    Rack::Utils.build_query(:q => location_elements.join(" "))
  end
end
