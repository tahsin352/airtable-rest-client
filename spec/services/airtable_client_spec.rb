require 'rails_helper'

RSpec.describe "AirtableClient" do
  it "works! (now write some real specs)" do
    response = AirtableClient.new.copy_records.to_json
    expect(response).to include("records")
  end
end
