require 'rails_helper'
require 'evaluation_emailer'

describe EvaluationEmailer do
  describe '#send_invite_for_self' do
    context 'when it successfully sends' do
      it "returns 'sent' as a status message" do
        participant = create(:participant)
        evaluation = Evaluation.new(participant_id: participant.id, access_key: "abcd")
        expect(EvaluationEmailer.send_invite_for_self(evaluation)).to eq 'sent'
      end
    end
  end
end
