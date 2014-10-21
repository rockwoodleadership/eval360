require 'rails_helper'

RSpec.describe EvaluationsController, :type => :controller do

  describe "GET edit" do
    
    context 'when access_key is found' do

      before(:each) do
        @evaluation = build(:evaluation)
        allow(Evaluation).to receive(:find_by_access_key) { @evaluation }
        get :edit, id: @evaluation.access_key
      end
      it 'renders edit template' do
        expect(response).to render_template(:edit)
      end

      it "returns http success" do
        expect(response).to be_success
      end
    end
  end
end
