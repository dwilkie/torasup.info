require "rails_helper"

describe "Home Page" do
  before do
    visit root_path
  end

  it { expect(current_path).to eq(root_path) }

  describe "searching" do
    before do
      fill_in("search_box", :with => search_term)
      click_button("Search")
    end

    it { expect() }
  end
end
