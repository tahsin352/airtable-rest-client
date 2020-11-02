require 'rails_helper'

RSpec.describe AirtableController do
  context 'without since' do
    it "request list of all records" do
      get :index
      expect(response).to be_successful
      expect(response.body).to include("records")
    end
  end
end
