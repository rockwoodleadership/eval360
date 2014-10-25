require 'rails_helper'

RSpec.describe EvaluationsController, :type => :controller do

  describe "GET edit" do
    
    context 'when access_key is found' do

      before(:each) do
        @evaluation = build(:evaluation)
        allow(Evaluation).to receive(:find_by_access_key) { @evaluation }
        get :edit, evaluation_id: @evaluation.access_key
      end
      it 'renders edit template' do
        expect(response).to render_template(:edit)
      end

      it "returns http success" do
        expect(response).to be_success
      end
    end
  end

  describe "POST update" do
    context "when access_key is found" do
      context "when self evaluation" do
        context "when commit type is Submit" do
          before(:each) do
            @evaluation = create(:self_evaluation_with_answers)
            evaluation_attributes = {} 
            evaluation_attributes["answers_attributes"] = {"0" => {"numeric_response" => 10, "id" => @evaluation.answers.first.id}} 
            allow(Evaluation).to receive(:find_by_access_key) { @evaluation }
            post :update, id: @evaluation.access_key, commit: "Submit", evaluation: evaluation_attributes
          end
          it 'updates evaluation' do
            @evaluation.reload
            expect(@evaluation.answers.first.numeric_response).to eq 10
          end
          it 'completes evaluation' do
            expect(@evaluation.completed?).to eq true
          end
          it 'redirects to invitation page' do
            expect(response).to redirect_to(invitations_path(@evaluation.participant))
          end
          
        end
      end
    end
  end
end
