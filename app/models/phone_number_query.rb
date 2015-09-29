class PhoneNumberQuery
  include ActiveModel::Model
  include ActiveModel::Validations::Callbacks
#  extend ActiveModel::Translation

  DEFAULT_COUNTRY_CODE = "855"

  attr_accessor :phone_number

  validates :phone_number, :presence => true, :phony_plausible => true
  before_validation :normalize_phone_number

  delegate :operator, :location, :type, :to => :torasup_number, :allow_nil => true
  delegate :name, :website, :branding, :ceo, :facebook, :to => :operator, :prefix => true, :allow_nil => true
  delegate :area, :country_id, :to => :location, :allow_nil => true
  delegate :name, :to => :country, :prefix => true, :allow_nil => true

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

  def country
    @country = ISO3166::Country.new(country_id)
  end

  private

  def torasup_number
    @torasup_number ||= Torasup::PhoneNumber.new(phone_number) if valid?
  end

  def default_country_code
    DEFAULT_COUNTRY_CODE
  end

  def normalize_phone_number
    return if phone_number.blank?
    normalized_phone_number = phone_number.to_s.dup
    normalized_phone_number.gsub!(/\D/, "")                        # remove any non digits
    normalized_phone_number.gsub!(/\A#{default_country_code}/, "") # remove default country code
    normalized_phone_number.gsub!(/^\A0+/, "")                     # remove any leading zeros

    normalized_phone_number_with_country_code = default_country_code + normalized_phone_number

    normalized_phone_number = Phony.plausible?(normalized_phone_number_with_country_code) ? normalized_phone_number_with_country_code : phone_number

    normalized_phone = Phony.normalize(normalized_phone_number) rescue nil
    self.phone_number = "+" + normalized_phone if normalized_phone && Phony.plausible?(normalized_phone)
  end
end
