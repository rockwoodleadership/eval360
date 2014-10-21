require 'rails_helper'
require 'evaluation_emailer'

describe EvaluationEmailer do
  describe '.send_invite_for_self_eval' do
    context 'when it successfully sends' do
      it "returns 'sent' as a status message" do
        participant = build(:participant) 
        evaluation = build(:self_evaluation)
        allow(participant).to receive(:self_evaluation) { evaluation }
        expect(EvaluationEmailer.send_invite_for_self_eval(participant)).to eq 'sent'
      end
    end
  end
end
