require "rails_helper"

describe "'/'" do
  before do
    visit(root_path)
  end

  describe "Torasup Search" do
    let(:error_message) { "is an invalid number" }
    let(:result_selector) { "#result" }

    before do
      fill_in("phone_number_query_phone_number", :with => search_term)
      click_button("Torasup Search")
    end

    context "valid number" do
      let(:search_term) { "012 345 568" }
      it { expect(page).to have_css(result_selector) }
      it { expect(page).to have_no_content(error_message) }
    end

    context "invalid number" do
      let(:search_term) { "012 345 5689" }
      it { expect(page).to have_no_css(result_selector) }
      it { expect(page).to have_content(error_message) }
    end
  end
end
