require 'rails_helper'
require 'evaluation_emailer'

RSpec.describe Evaluation, :type => :model do
  expect_it { to validate_uniqueness_of :access_key }
  expect_it { to validate_presence_of :participant_id }
  expect_it { to have_one :evaluator }

  describe '#create_and_send_self_eval' do
    before(:each) do
      @participant = create(:participant) 
    end
    
    it 'creates a new evaluation' do 
      eval_count = Evaluation.count + 1
      Evaluation.create_and_send_self_eval(@participant)
      expect(Evaluation.count).to eq eval_count
    end

    it 'sends evalution' do
      expect(EvaluationEmailer).to receive(:send_invite_for_self)
      Evaluation.create_and_send_self_eval(@participant)
    end
  end
end
