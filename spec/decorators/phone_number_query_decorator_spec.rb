require 'rails_helper'

describe PhoneNumberQueryDecorator do
  let(:phone_number_query) { double(PhoneNumberQuery) }

  def setup_double
    allow(phone_number_query).to receive(:class).and_return(PhoneNumberQuery)
  end

  before { setup_double }

  subject { described_class.new(phone_number_query) }

  def assert_description_list_item!(html)
    expect(html).to have_css("dt")
    expect(html).to have_css("dd")
  end

  describe "#phone_number" do
    let(:result) { subject.phone_number }

    before do
      allow(phone_number_query).to receive(:phone_number).and_return("85512222333")
    end

    it { expect(result).to have_link("+855 12 222 333") }
    it { assert_description_list_item!(result) }
  end

  describe "#phone_number_type" do
    let(:result) { subject.phone_number_type }
    let(:phone_number_type) { nil }

    def setup_double
      super
      allow(phone_number_query).to receive(:phone_number_type).and_return(phone_number_type)
    end

    it { expect(result).to eq(nil) }

    context "for mobile numbers" do
      let(:phone_number_type) { "mobile" }
      it { expect(result).to have_content("Mobile") }
      it { assert_description_list_item!(result) }
    end

    context "for landline numbers" do
      let(:phone_number_type) { "landline" }
      it { expect(result).to have_content("Landline") }
      it { assert_description_list_item!(result) }
    end
  end

  describe "#operator" do
    let(:result) { subject.operator }
    let(:operator_branding) { nil }
    let(:operator_name) { nil }
    let(:operator_facebook) { nil }
    let(:operator_website) { nil }
    let(:operator_customer_service_phone) { nil }

    def setup_double
      super
      allow(phone_number_query).to receive(:operator_branding).and_return(operator_branding)
      allow(phone_number_query).to receive(:operator_name).and_return(operator_name)
      allow(phone_number_query).to receive(:operator_facebook).and_return(operator_facebook)
      allow(phone_number_query).to receive(:operator_website).and_return(operator_website)
      allow(phone_number_query).to receive(:operator_customer_service_phone).and_return(operator_customer_service_phone)
    end

    it { expect(result).to eq(nil) }

    context "operator has a name" do
      let(:operator_name) { "Mobitel" }
      it { expect(result).to have_content("Mobitel") }
      it { assert_description_list_item!(result) }

      context "but different branding" do
        let(:operator_branding) { "Cellcard" }
        it { expect(result).to have_content("Cellcard") }
        it { expect(result).not_to have_content("Mobitel") }
      end
    end

    context "operator has a customer service phone" do
      let(:operator_customer_service_phone) { "85512202101" }
      it { expect(result).to have_link("operator_customer_service_phone", :href => "tel:+855 12 202 101") }
      it { assert_description_list_item!(result) }
    end

    context "operator has a facebook page" do
      let(:operator_facebook) { "https://facebook.com/cellcard" }
      it { expect(result).to have_link("operator_facebook", :href => operator_facebook) }
      it { assert_description_list_item!(result) }
    end

    context "operator has a website" do
      let(:operator_website) { "https://mobitel.com" }
      it { expect(result).to have_link("operator_website", :href => operator_website) }
      it { assert_description_list_item!(result) }
    end
  end

  describe "#operator_ceo" do
    let(:result) { subject.operator_ceo }
    let(:operator_ceo_name) { nil }
    let(:operator_ceo_phone) { nil }
    let(:operator_ceo_email) { nil }
    let(:operator_ceo_linked_in) { nil }

    def setup_double
      super
      allow(phone_number_query).to receive(:operator_ceo_name).and_return(operator_ceo_name)
      allow(phone_number_query).to receive(:operator_ceo_phone).and_return(operator_ceo_phone)
      allow(phone_number_query).to receive(:operator_ceo_email).and_return(operator_ceo_email)
      allow(phone_number_query).to receive(:operator_ceo_linked_in).and_return(operator_ceo_linked_in)
    end

    it { expect(result).to eq(nil) }

    context "operator CEO has a name" do
      let(:operator_ceo_name) { "Ian Watson" }
      it { expect(result).to have_content("Ian Watson") }
      it { assert_description_list_item!(result) }
    end

    context "operator CEO has a phone" do
      let(:operator_ceo_phone) { "85512202101" }
      it { expect(result).to have_link("operator_ceo_phone", :href => "tel:+855 12 202 101") }
      it { assert_description_list_item!(result) }
    end

    context "operator CEO has an email" do
      let(:operator_ceo_email) { "ian.watson@cellcard.com.kh" }
      it { expect(result).to have_link("operator_ceo_email", :href => "mailto:ian.watson@cellcard.com.kh") }
      it { assert_description_list_item!(result) }
    end

    context "operator CEO has a linked in profile" do
      let(:operator_ceo_linked_in) { "https://linkedin.com/ian_watson" }
      it { expect(result).to have_link("operator_ceo_linked_in", :href => "https://linkedin.com/ian_watson") }
      it { assert_description_list_item!(result) }
    end
  end

  describe "#location" do
    let(:result) { subject.location }
    let(:location_area) { nil }
    let(:location_country_name) { nil }

    def setup_double
      super
      allow(phone_number_query).to receive(:location_area).and_return(location_area)
      allow(phone_number_query).to receive(:location_country_name).and_return(location_country_name)
    end

    it { expect(result).to eq(nil) }

    context "location has a country" do
      let(:location_country_name) { "Cambodia" }
      it { expect(result).to have_link("Cambodia", :href => "http://maps.google.com?q=Cambodia") }
      it { assert_description_list_item!(result) }

      context "and an area" do
        let(:location_area) { "Phnom Penh" }
        it { expect(result).to have_link("Phnom Penh, Cambodia", :href => "http://maps.google.com?q=Phnom+Penh+Cambodia") }
      end
    end
  end
end
