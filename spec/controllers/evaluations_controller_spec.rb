require 'rails_helper'

RSpec.describe EvaluationsController, :type => :controller do

  
  describe "GET edit" do
    
    context 'when access_key is found' do

      before(:each) do
        @evaluation = build(:evaluation)
        allow(Evaluation).to receive(:find_by_access_key) { @evaluation }
      end
      

      it "returns http success" do
        get :edit, evaluation_id: @evaluation.access_key
        expect(response).to be_success
      end

      context 'when evaluation has not been completed' do
        it 'renders edit template' do
          get :edit, evaluation_id: @evaluation.access_key
          expect(response).to render_template(:edit)
        end
      end

      context 'when evaluation is completed' do
        before (:each) do
          allow(@evaluation).to receive(:completed?) { true }
        end
        context 'when evaluation is a self eval' do
          it 'redirects to invitations path' do
            allow(@evaluation).to receive(:self_eval?) { true }
            get :edit, evaluation_id: @evaluation.access_key
            expect(response).to redirect_to(invitations_path(@evaluation.participant))
          end
        end

        context 'when evaluation is a peer evaluation' do
          it 'redirects to thank you page' do
            get :edit, evaluation_id: @evaluation.access_key
            expect(response).to redirect_to(thank_you_path)
          end
        end
      end
    end
  end

  describe "POST update" do
    context "when access_key is found" do
      before(:each) do
        participant = create(:participant)
        @evaluation = participant.self_evaluation
        @evaluation.answers << create(:answer, evaluation_id: @evaluation.id) 
        @evaluation_attributes = {} 
        @evaluation_attributes["answers_attributes"] = {"0" => {"numeric_response" => 10, "id" => @evaluation.answers.first.id}} 
        allow(Evaluation).to receive(:find_by_access_key) { @evaluation }
        
      end

      it 'updates evaluation' do
        post :update, id: @evaluation.access_key, commit: "Submit", evaluation: @evaluation_attributes
        @evaluation.reload
        expect(@evaluation.answers.first.numeric_response).to eq 10
      end
      context "when commit type is Submit" do
        
        context "when self evaluation" do
          before(:each) do
            post :update, id: @evaluation.access_key, commit: "Submit", evaluation: @evaluation_attributes
          end 
          
          it 'completes evaluation' do
            @evaluation.reload
            expect(@evaluation.completed?).to eq true
          end

          it 'redirects to invitation page' do
            expect(response).to redirect_to(invitations_path(@evaluation.participant))
          end
          
        end
        context "when peer evaluation" do
          before(:each) do
            allow(@evaluation).to receive(:self_eval?) { false }
            post :update, id: @evaluation.access_key, commit: "Submit", evaluation: @evaluation_attributes
          end
          it 'redirects to thank you page' do
            expect(response).to redirect_to(thank_you_path)
          end
        end
      end
      context "when commit type is Save For Later" do
        before(:each) do
          post :update, id: @evaluation.access_key, commit: "Save For Later", evaluation: @evaluation_attributes
        end
        
        it 'redirects to evaluation edit page' do
          expect(response).to redirect_to(edit_evaluation_path(@evaluation))
        end
        it 'sets a saved reponses notifications' do
          expect(flash[:notice]).to match /Your responses have been saved/
        end 
      end
    end
  end
end
