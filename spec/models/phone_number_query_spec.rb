require 'rails_helper'

describe PhoneNumberQuery do
  subject { described_class.new(params) }
  let(:params) { {:phone_number => phone_number} }
  let(:phone_number) { nil }

  describe "validations" do
    it { is_expected.to validate_presence_of(:phone_number) }
    it { is_expected.to allow_value("012 236 139").for(:phone_number) }
    it { is_expected.to allow_value("000012 236 139").for(:phone_number) }
    it { is_expected.to allow_value("12 236 139").for(:phone_number) }
    it { is_expected.to allow_value("85512 236 139").for(:phone_number) }
    it { is_expected.to allow_value("855-012 236 139").for(:phone_number) }
    it { is_expected.not_to allow_value("85512 236 1397").for(:phone_number) }
    it { is_expected.not_to allow_value("12 236 1397").for(:phone_number) }
    it { is_expected.not_to allow_value("012 236 1397").for(:phone_number) }
    it { is_expected.to allow_value("+84 8 3827 9666").for(:phone_number) }
  end

  describe "ActiveModel" do
    include ActiveModel::Lint::Tests

    def model
      subject
    end

    ActiveModel::Lint::Tests.public_instance_methods.map{|m| m.to_s}.grep(/^test/).each do |m|
      example m.gsub('_',' ') do
        send(m)
      end
    end
  end

  describe "#execute" do
    before { subject.execute }

    context "for a valid number" do
      let(:phone_number) { "012 236 139" }
      it { expect(subject).to be_executed }
    end

    context "for an invalid number" do
      let(:phone_number) { "012 236 1390" }
      it { expect(subject).not_to be_executed }
    end
  end

  describe "#location_country_name" do
    context "Local Number" do
      let(:phone_number) { "012 236 139" }
      it { expect(subject.location_country_name).to eq("Cambodia") }
    end

    context "International Number" do
      let(:phone_number) { "+84 8 3827 9666" }
      it { expect(subject.location_country_name).to eq("Vietnam") }
    end
  end
end
