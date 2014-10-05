require 'rails_helper'

RSpec.describe SalesforceConnectorController, :type => :controller do

  describe "POST new_particpant" do

    context 'valid parameters' do

      before(:each) do
        @participant = JSON.generate({ First_Name__c: 'Doris', Last_Name__c: 'Day', Email__c: 'day@example.com' })
        @attributes = {:first_name=>"Doris", :last_name=>"Day", :email=>"day@example.com"}
      end 
      
      it "creates a new participant" do
        expect(Participant).to receive(:create).with(@attributes)
        post :new_participant, :participant => @participant
      end 


      it "returns status code 200" do
        post :new_participant, :participant => @participant
        expect(response.status).to eq 200
      end

    end

    context 'invalid parameters' do

      it "returns status code 422" do
        post :new_participant
        expect(response.status).to eq 422
      end

    end

  end
end
