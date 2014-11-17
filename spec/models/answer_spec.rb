require 'rails_helper'

RSpec.describe Answer, :type => :model do
  expect_it { to belong_to :question }
  expect_it { to belong_to :evaluation }
  expect_it { to validate_presence_of :evaluation }
  expect_it { to validate_presence_of :question }
  
  describe '#response' do
    context 'when it is a numeric question' do
      before do
        @answer = create(:answer)
      end
      it 'returns not applicable for a non truthy values of numeric_response' do
        @answer.numeric_response = nil
        expect(@answer.response).to eq "not applicable"
      end

      it 'returns the value for truthy values of numeric_response' do
        @answer.numeric_response = 9
        expect(@answer.response).to eq 9
      end
    end

    context 'when it is a text question' do
      before do
        @answer = create(:text_answer)
      end
      it 'returns no response for non truthy values of text_Response' do
        @answer.text_response = nil
        expect(@answer.response).to eq "no response"
      end

      it 'returns the value for truthy values of text_response' do
        @answer.text_response = "great"
        expect(@answer.response).to eq "great"
      end
    end
  end

  describe "#set_default_values" do
    before do
      @answer = create(:answer)
      @answer.numeric_response = 9
      @answer.text_response = "great"
      @answer.set_default_values
    end
    it 'sets numeric_response to 0' do
      expect(@answer.numeric_response).to eq 0
    end

    it 'sets text_response blank' do
      expect(@answer.text_response).to eq ""
    end
  end
end
