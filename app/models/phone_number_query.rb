class PhoneNumberQuery
  include ActiveModel::Model
  include ActiveModel::Validations::Callbacks

  DEFAULT_COUNTRY_CODE = "855"

  attr_accessor :phone_number

  validates :phone_number, :presence => true, :phony_plausible => true
  before_validation :normalize_phone_number

  delegate :operator, :location, :type, :to => :torasup_number, :allow_nil => true
  delegate :name, :facebook, :website, :branding, :customer_service_phone,
           :ceo_name, :ceo_email, :ceo_phone, :ceo_linked_in,
           :to => :operator, :prefix => true, :allow_nil => true

  delegate :area, :country_id, :to => :location, :prefix => true, :allow_nil => true
  delegate :name, :to => :location_country, :prefix => true, :allow_nil => true

  alias_method :phone_number_type, :type

  def initialize(phone_number)
    self.phone_number = phone_number
  end

  def execute
    phone_number? && !!torasup_number && @executed = true
  end

  def phone_number?
    phone_number.present?
  end

  def executed?
    !!@executed
  end

  def location_country
    @location_country ||= ISO3166::Country.new(location_country_id)
  end

  private

  def torasup_number
    @torasup_number ||= Torasup::PhoneNumber.new(phone_number) if valid?
  end

  def default_country_code
    DEFAULT_COUNTRY_CODE
  end

  def set_phone_number(number_to_set)
    Phony.plausible?(number_to_set) && (number_to_set = Phony.normalize(number_to_set)) && (self.phone_number = "+" + number_to_set)
  end

  def normalize_phone_number
    return if phone_number.blank?
    normalized_phone_number = phone_number.to_s.dup
    normalized_phone_number.gsub!(/\D/, "")                           # remove any non digits

    set_phone_number(normalized_phone_number) && return               # assume number international
    normalized_phone_number.gsub!(/\A#{default_country_code}/, "")    # remove default country code
    normalized_phone_number.gsub!(/^\A0+/, "")                        # remove any leading zeros
    set_phone_number(default_country_code + normalized_phone_number)  # add default country code
    true
  end
end
