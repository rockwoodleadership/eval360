require 'rails_helper'
require 'evaluation_emailer'

RSpec.describe SalesforceConnectorController, :type => :controller do

  describe "POST new_particpant" do

    context 'with valid parameters' do

      before(:each) do
        email = "email#{Time.now}@example.com"
        @participant_param = JSON.generate({ First_Name__c: 'Doris', Last_Name__c: 'Day', Email__c: email })
        @attributes = { :first_name=>"Doris", :last_name=>"Day", :email=> email }
        @participant = create(:participant)
        allow_any_instance_of(Evaluation).to receive(:build_questions).and_return([])
        allow(EvaluationEmailer).to receive(:send_invite_for_self_eval).and_return('sent')
      end 
      
      xit "creates a new participant" do
        expect(Participant).to receive(:create!).with(@attributes)
        post :new_participant, :participant => @participant_param
      end 

      xit "creates a self evaluation" do
        allow(Participant).to receive(:create!).and_return(@participant)
        expect(Evaluation).to receive(:create_self_evaluation).with(@participant)
        post :new_participant, :participant => @participant_param
      end

      xit "sends self evaluation" do
        allow(Participant).to receive(:create!).and_return(@participant)
        expect(EvaluationEmailer).to receive(:send_invite_for_self_eval).with(@participant)
        post :new_participant, :participant => @participant_param
      end
      
      xit "returns status code 200" do
        allow(Participant).to receive(:create!).and_return(@participant)
        post :new_participant, :participant => @participant_param
        expect(response.status).to eq 200
      end

    end

    context 'with invalid parameters' do

      xit "returns status code 422" do
        post :new_participant
        expect(response.status).to eq 422
      end

    end

  end
end
