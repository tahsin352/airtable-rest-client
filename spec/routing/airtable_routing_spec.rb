require "rails_helper"

RSpec.describe AirtableController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/copy").to route_to("airtable#index")
    end

    it "routes to #show" do
      expect(:get => "/copy/greeting").to route_to("airtable#show", :key => "greeting")
    end

    it "routes to #refresh" do
      expect(:get => "/copy/refresh").to route_to("airtable#refresh")
    end
  end
end
