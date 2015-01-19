require 'rails_helper'

RSpec.describe ParticipantsController, :type => :controller do

  before(:each) do
    @participant = create(:participant)
  end
  
  describe "GET invitations" do
    context 'when participant is found' do
      before(:each) do
        get :invitations, id: @participant.access_key
      end
      it 'renders invitations template' do
        expect(response).to render_template('invitations')
      end

      it 'renders http success' do
        expect(response).to be_success
      end
    end
  end

  describe "POST update" do
    context 'when participant is found' do
      context 'when update type is to invite peers' do
        before(:each) do
          @participant_attributes = {}
          @participant_attributes['evaluators_attributes'] = {"0"=>{"email"=>"test#{Time.now}@email.com"}, "1"=>{"email"=>"foo#{Time.now}@email.com"}}
          allow(Participant).to receive(:find_by_access_key) { @participant }
          
        end

        it 'creates evaluators' do
          allow(Evaluation).to receive(:create_peer_evaluations)
          allow(EvaluationEmailer).to receive(:send_peer_invites)
          expect(Evaluator).to receive(:bulk_create)

          post :update, id: @participant.access_key, commit: "Invite Peers", participant: @participant_attributes
        end

        it 'sends invites to evaluators' do
          expect(EvaluationEmailer).to receive(:send_peer_invites)

          post :update, id: @participant.access_key, commit: "Invite Peers", participant: @participant_attributes
        end
        it 'redirects to invitation page with a notice of number of invites sent' do

          post :update, id: @participant.access_key, commit: "Invite Peers", participant: @participant_attributes
          expect(response).to redirect_to(invitations_path(@participant))
        end

        it 'flashes an invitations sent message' do

          post :update, id: @participant.access_key, commit: "Invite Peers", participant: @participant_attributes
          expect(flash[:notice]).to match /invitation\(s\) have been sent/
        end
      end
    end
  end

  describe "POST send_reminders" do
    context 'when participant is found' do
      it 'sends peer reminders' do
        expect(EvaluationEmailer).to receive(:send_peer_reminders)
        post :send_reminders, id: @participant.access_key 
      end

      it 'flashes a reminders sent message' do
        allow(EvaluationEmailer).to receive(:send_peer_reminders)
        post :send_reminders, id: @participant.access_key
        expect(flash[:notice]).to match /peer reminder\(s\) have been sent/
      end

      it 'returns a status of success' do
        allow(EvaluationEmailer).to receive(:send_peer_reminders)
        post :send_reminders, id: @participant.access_key
        expect(response).to be_success
      end
    end
  end

  describe "GET evaluation report" do
    it 'creates a pdf report and downloads it' do
      expect(controller).to receive(:send_data)
      allow(controller).to receive(:render)
      get :evaluation_report, id: @participant.access_key, format: :pdf
       
    end
  end
  
end
