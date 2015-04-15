require 'rails_helper'

describe 'participants/invitations.html.slim' do

  it 'displays a form to collect email addresses to send invite for peer evaluations' do
    participant = create(:participant)
    assign(:participant, participant)
    render
    expect(rendered).to match /input/
  end

  context 'when evaluators have been previously invited' do
    before(:each) do
      @participant = create(:participant_with_peer_evaluation)
      declined_evaluator = create(:evaluator, declined: true)
      @participant.evaluations.create(evaluator_id: declined_evaluator.id)
      assign(:participant, @participant)
      render
    end
    it 'displays list of evaluators invited' do
      expect(rendered).to include @participant.invited_peers.first.email
    end

    it 'displays button to remind peers' do
      expect(rendered).to include "Remind Peers"
    end
  end
end
