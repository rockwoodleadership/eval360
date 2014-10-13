require 'rails_helper'
require 'evaluation_emailer'

describe EvaluationEmailer do
  describe '.send_invite_for_self_eval' do
    context 'when it successfully sends' do
      it "returns 'sent' as a status message" do
        participant = create(:participant_with_self_eval) 
        expect(EvaluationEmailer.send_invite_for_self_eval(participant)).to eq 'sent'
      end
    end
  end
end
