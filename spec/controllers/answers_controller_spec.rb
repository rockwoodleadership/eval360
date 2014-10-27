require 'rails_helper'

RSpec.describe AnswersController, :type => :controller do
  describe "POST update" do
    before(:each) do
      @answer = create(:answer)
      allow(Answer).to receive(:find) { @answer }
      post :update, id: @answer.id, answer: { "numeric_response" => "10" }
    end

    it 'updates answer' do
      @answer.reload
      expect(@answer.numeric_response).to eq 10
    end

    it "returns http success" do
      expect(response).to be_success
    end
  end
end
