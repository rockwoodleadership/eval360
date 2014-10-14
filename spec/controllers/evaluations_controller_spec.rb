require 'rails_helper'

RSpec.describe EvaluationsController, :type => :controller do

  describe "GET edit" do
    
    context 'when access_key is found' do

      context 'and evaluation has never been taken' do
        it 'adds questions to the evaluation' do
          @evaluation = create(:evaluation)
          allow(Evaluation).to receive(:find_by_access_key).and_return(@evaluation)
          allow(@evaluation).to receive(:build_questions)
          expect(@evaluation).to receive(:build_questions)
          get :edit, id: @evaluation.access_key
        end 
      end

      it 'renders edit template' do
        @evaluation = create(:evaluation)
        allow(Evaluation).to receive(:find_by_access_key).and_return(@evaluation)
        allow(@evaluation).to receive(:build_questions)
        get :edit, id: @evaluation.access_key
        expect(response).to render_template(:edit)
      end

      it "returns http success" do
        @evaluation = create(:evaluation)
        allow(Evaluation).to receive(:find_by_access_key).and_return(@evaluation)
        allow(@evaluation).to receive(:build_questions)
        get :edit, id: @evaluation.access_key
        expect(response).to be_success
      end
    end
  end
end
