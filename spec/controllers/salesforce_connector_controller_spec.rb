require 'rails_helper'

RSpec.describe SalesforceConnectorController, :type => :controller do

  describe "POST new_particpant" do

    it "creates a new participant" do
      participant = { first_name: "Doris", last_name: "Day", email: "day@example.com" }
      expect(Participant).to receive(:create).with(participant)
      post :new_participant, :participant => participant
    end 


    it "returns status code 200" do
      post :new_participant
      expect(response.status).to eq 200
    end
  end
end
