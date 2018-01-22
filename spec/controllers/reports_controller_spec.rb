require 'rails_helper'

RSpec.describe ReportsController, :type => :controller do
  describe "GET show" do

    let(:participant) { FactoryGirl.create(:participant) }
    let(:access_key) {  participant.access_key }

    it 'finds the participant' do
      expect(Participant).to receive(:find_by_access_key).with(access_key)
      get :show, participant_id: access_key
    end

    it 'creates a new report' do
      expect(Report).to receive(:new).with(participant)
      get :show, participant_id: access_key
    end

    it 'assigns the report' do
      get :show, participant_id: access_key
      expect(assigns(:report)).to_not be_nil
    end
    
    it 'renders report show page' do
      get :show, participant_id: access_key
      expect(response).to render_template('show')
    end
  end
end
