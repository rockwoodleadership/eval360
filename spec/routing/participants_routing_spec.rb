require 'rails_helper'

RSpec.describe 'routes for participants', :type => :routing do
  describe 'route for participant report' do
    it 'routes to the report controller' do
      participant = FactoryGirl.create(:participant)
      expect(get("/#{participant.access_key}/report")).to route_to("reports#show", participant_id: participant.access_key)
    end
  end
end
