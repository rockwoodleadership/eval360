require 'rails_helper'
require 'evaluation_emailer'

RSpec.describe SalesforceConnectorController, :type => :controller do

  describe "POST new_particpant" do

    context 'with valid parameters' do

      before(:each) do
        email = "email#{Time.now}@example.com"
        @participant_param = JSON.generate({ First_Name__c: 'Doris', Last_Name__c: 'Day', Email__c: email })
        @attributes = { :first_name=>"Doris", :last_name=>"Day", :email=> email }
      end 
      
      it "creates a new participant" do
        expect(Participant).to receive(:create!).with(@attributes)
        post :new_participant, :participant => @participant_param
      end 

      it "creates a self evaluation" do
        participant = create(:participant)
        allow(Participant).to receive(:create!).and_return(participant)
        expect(participant.evaluations).to receive(:create).with(evaluator_id: participant.id)
        allow(EvaluationEmailer).to receive(:send_invite_for_self_eval).and_return('sent')
        post :new_participant, :participant => @participant_param
      end

      it "sends self evaluation" do
        participant = create(:participant)
        evaluation = create(:evaluation)
        allow(Participant).to receive(:create!).and_return(participant)
        expect(EvaluationEmailer).to receive(:send_invite_for_self_eval).with(participant)
        post :new_participant, :participant => @participant_param
      end
      
      it "returns status code 200" do
        post :new_participant, :participant => @participant_param
        expect(response.status).to eq 200
      end

    end

    context 'with invalid parameters' do

      it "returns status code 422" do
        post :new_participant
        expect(response.status).to eq 422
      end

    end

  end
end
