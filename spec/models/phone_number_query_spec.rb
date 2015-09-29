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
    let(:result) { subject.execute }

    before { result }

    context "for a valid number" do
      let(:phone_number) { "012 236 139" }
      it { expect(result).to eq(true) }
    end

    context "for an invalid number" do
      let(:phone_number) { "012 236 1390" }
      it { expect(result).to eq(false) }
    end
  end

  describe "#to_hash" do
    let(:result) { subject.to_hash }
    let(:asserted_attributes) { [:operator_name, :area, :type] }
    it { expect(result.keys).to match_array(asserted_attributes) }

    describe "for a valid landline number" do
      let(:phone_number) { "855234532345" }

      it { expect(result[:area]).to eq("Phnom Penh") }
      it { expect(result[:operator_name]).to eq("Smart") }
      it { expect(result[:type]).to eq("landline") }
    end

    describe "for a valid mobile number" do
      let(:phone_number) { "012 236 139" }

      it { expect(result[:area]).to eq(nil) }
      it { expect(result[:operator_name]).to eq("Mobitel") }
      it { expect(result[:type]).to eq("mobile") }
    end
  end
end
