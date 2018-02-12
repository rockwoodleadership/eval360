require 'rails_helper'

RSpec.describe 'routes for participants', :type => :routing do
  describe 'route for participant report' do
    it 'routes to the report controller' do
      participant = FactoryBot.create(:participant)
      expect(get("/participants/#{participant.access_key}/report")).to route_to("reports#show", participant_id: participant.access_key)
    end
  end
end
