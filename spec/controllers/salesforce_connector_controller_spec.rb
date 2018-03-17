require 'rails_helper'
require 'evaluation_emailer'

RSpec.describe SalesforceConnectorController, :type => :controller do

  describe "POST new_particpant" do

    context 'with valid parameters' do

      before(:each) do
        email = "email#{Time.now}@example.com"
        @training = create(:training, sf_training_id: '123')
        allow(Training).to receive(:find_by) { @training }
        @participant_params = JSON.generate({ first_name: 'Doris', last_name: 'Day', email: email,
                                             sf_training_id: '123', sf_registration_id: '345', sf_contact_id: '678',
                                             api_key: ENV['INBOUND_SALESFORCE_KEY'] })
      end 

      after do
        post :new_participant, params: { :participant => @participant_params }
      end
      
      it "creates a new participant" do
        expect(@training).to receive_message_chain(:participants, :create)
      end 

      it "returns status code 200" do
        expect(response.status).to eq 200
      end

    end

    context 'with invalid parameters' do

      it "returns status code 422" do
        participant_params = JSON.generate({ first_name: 'Doris', last_name: 'Day',
                                             sf_training_id: '123', sf_registration_id: '345', sf_contact_id: '678'
                                             })
        post :new_participant, params: { :participant => participant_params }
        expect(response.status).to eq 422
      end

    end

  end

  describe "POST new_training" do

    context 'with valid parameters' do

      before(:each) do

        t_name = "Training#{Time.now}"
        q_name = create(:questionnaire).name
        @training_params = JSON.generate({ name: t_name, start_date: "12/2/2015", end_date: "12/3/2015",
                                           sf_training_id: '123', deadline: "9/2/2015", questionnaire_name: q_name,
                                           status: 'Planned', api_key: ENV['INBOUND_SALESFORCE_KEY'] })
      end 

      after do
        post :new_training, params: { :training => @training_params }
      end
      
      it "creates a new training" do
        expect(Training).to receive(:create!)
      end 

      it "returns status code 200" do
        expect(response.status).to eq 200
      end

    end

    context 'with questionnaire type StandaloneCustom' do 
      before(:each) do

        t_name = "Training#{Time.now}"
        create(:questionnaire, name: 'Standalone')
        @training_params = JSON.generate({ name: t_name, start_date: "12/2/2015", end_date: "12/3/2015",
                                           sf_training_id: '123', deadline: "9/2/2015",
                                           questionnaire_name: 'StandaloneCustom',
                                           status: 'Planned', api_key: ENV['INBOUND_SALESFORCE_KEY'] })
      end
      after do
        post :new_training, params: { :training => @training_params }
      end
      it 'creates a new training' do
        expect(Training).to receive(:create!)
      end

      it 'returns status code 200' do
        expect(response.status).to eq 200
      end
    end

    context 'with invalid parameters' do

      it "returns status code 422" do
        training_params = JSON.generate({ start_date: "12/2/2015", end_date: "12/3/2015",
                                           sf_training_id: '123', deadline: "9/2/2015",
                                           status: 'Planned', api_key: ENV['INBOUND_SALESFORCE_KEY'] })
        post :new_training, params: { :training => training_params }
        expect(response.status).to eq 422
      end

    end

  end

  describe "POST update_particpant" do

    context 'with valid parameters' do

      before(:each) do
        @participant = create(:participant, last_name: "Day", sf_contact_id: '123')
        allow(Participant).to receive(:find_by) { @participant }
        @participant_params = JSON.generate({ sf_contact_id: '123', last_name: "Night", changed_fields: [ 'last_name' ] ,
                                             api_key: ENV['INBOUND_SALESFORCE_KEY'] })
        post :update_participant, params: { :participant => @participant_params }
      end 

      
      it "updates the participant" do
        @participant.reload
        expect(@participant.last_name).to eq "Night" 
      end 

      it "returns status code 200" do
        expect(response.status).to eq 200
      end

    end

    context 'with invalid parameters' do

      it "returns status code 422" do
        participant_params = JSON.generate({ sf_contact_id: '123', last_name: "Night", 
                                             api_key: ENV['INBOUND_SALESFORCE_KEY'] })
        post :update_participant, params: { :participant => participant_params }
        expect(response.status).to eq 422
      end

    end

  end

  describe "POST update_training" do

    context 'with valid parameters' do

      before(:each) do
        @training= create(:training, sf_training_id: '123', city: "Philadelphia")
        allow(Training).to receive(:find_by) { @training }
        @training_params= JSON.generate({ sf_training_id: '123', city: "Miami", changed_fields: [ 'city' ] ,
                                             api_key: ENV['INBOUND_SALESFORCE_KEY'] })
        post :update_training, params: { :training => @training_params }
      end 

      
      it "updates the training" do
        @training.reload
        expect(@training.city).to eq "Miami" 
      end 

      it "returns status code 200" do
        expect(response.status).to eq 200
      end

    end

    context 'with invalid parameters' do

      it "returns status code 422" do
        training_params = JSON.generate({ city: "Miami", 
                                             api_key: ENV['INBOUND_SALESFORCE_KEY'] })
        post :update_training, params: { :training => training_params }
        expect(response.status).to eq 422
      end

    end

  end


end
