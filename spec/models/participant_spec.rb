require 'rails_helper'

RSpec.describe Participant, :type => :model do
  before(:each) do
    allow_any_instance_of(Evaluation).to receive(:build_questions)
  end
  #validates emai through acts_as for evaluator
  expect_it { to validate_presence_of :email }
  expect_it { to have_many :evaluations }
  expect_it { to have_many(:evaluators).through(:evaluations) }
  expect_it { to belong_to :training }
  expect_it { to validate_presence_of :training }
  expect_it { to validate_uniqueness_of :access_key }
  
  expect_it { to have_db_index(:access_key) }
  expect_it { to callback(:set_access_key).before(:validation).on(:create) }
  expect_it { to callback(:create_self_evaluation).after(:create) }

  describe '#self_evaluation' do
    it 'returns the self evaluation' do
      participant = create(:participant_with_self_eval)
      self_evaluation = participant.self_evaluation
      expect(self_evaluation.evaluator_id).to eq participant.evaluator.id
    end
  end

  describe "#peer_evaluation_status" do
    it 'returns the status of peer evaluations as formatted text' do
      participant = create(:participant)
      expect(participant.peer_evaluation_status).to eq "#{participant.completed_peer_evaluations} of #{participant.total_peer_evaluations}" 
    end
  end

  describe "#completed_peer_evaluations" do
    it 'returns the number of completed peer evaluations' do
      participant = create(:participant)
      evaluation = create(:evaluation, participant_id: participant.id, completed: true)
      expect(participant.completed_peer_evaluations).to eq 1
    end
  end

  describe "#total_peer_evaluations" do
    it 'returns the number of peer evaluations' do
      participant = create(:participant_with_peer_evaluation)
      expect(participant.total_peer_evaluations).to eq 1
    end
  end

  describe "#peer_evaluations" do
    it 'returns all the peer evaluations where the peer has not declined' do
      accepted_evaluator = create(:evaluator, declined: false)
      declined_evaluator = create(:evaluator, declined: true)
      participant = create(:participant)
      participant.evaluations.create(evaluator_id: accepted_evaluator.id)
      participant.evaluations.create(evaluator_id: declined_evaluator.id) 
      expect(participant.peer_evaluations.length).to eq 1
    end
  end

  
  describe "#full_name" do
    it 'returns first name, last name, and preferred name as a string' do
      participant = build(:participant)
      expect(participant.full_name).to eq "#{participant.first_name} (#{participant.preferred_name}) #{participant.last_name}"
    end
  end

  describe "#peer_evaluators" do
    it 'returns the peer evaluators who have not declined' do
      accepted_evaluator = create(:evaluator, declined: false)
      declined_evaluator = create(:evaluator, declined: true)
      participant = create(:participant)
      participant.evaluations.create(evaluator_id: accepted_evaluator.id)
      participant.evaluations.create(evaluator_id: declined_evaluator.id) 
      expect(participant.peer_evaluators.length).to eq 1 
    end
  end

  describe "#invited_peers" do
    it 'returns all invited peers' do
      accepted_evaluator = create(:evaluator, declined: false)
      declined_evaluator = create(:evaluator, declined: true)
      participant = create(:participant)
      participant.evaluations.create(evaluator_id: accepted_evaluator.id)
      participant.evaluations.create(evaluator_id: declined_evaluator.id) 
      expect(participant.invited_peers.length).to eq 2 
    end
  end

  describe "#declined_peers" do
    it 'returns all peers who have declined' do
      accepted_evaluator = create(:evaluator, declined: false)
      declined_evaluator = create(:evaluator, declined: true)
      participant = create(:participant)
      participant.evaluations.create(evaluator_id: accepted_evaluator.id)
      participant.evaluations.create(evaluator_id: declined_evaluator.id) 
      expect(participant.declined_peers.length).to eq 1 
    end
  end

  describe "#peer_evals_not_completed" do
    it 'returns the peer evaluations not completed' do
      participant = create(:participant)
      create(:evaluation, participant_id: participant.id, completed: true)
      evaluation = create(:evaluation, participant_id: participant.id)
      expect(participant.peer_evals_not_completed.first).to eq evaluation
    end
  end

  describe "#invite" do
    it 'sends invite to participant' do
      participant = build(:participant)
      expect(EvaluationEmailer).to receive(:send_to_participant)
      participant.invite
    end

    context 'training no invite is true' do
      it 'does not send invite to participant' do
        training = build(:training, no_invite: true)
        participant = build(:participant, training: training)
        expect(EvaluationEmailer).to_not receive(:send_to_participant)
        participant.invite
      end
    end
  end

  describe "#remind" do
    it 'sends reminder for self evaluation' do
      participant = build(:participant)
      expect(EvaluationEmailer).to receive(:send_to_participant)
      participant.remind
    end
  end

  describe "#remind_to_add_peers" do
    it 'sends reminder to add peers' do
      participant = build(:participant)
      expect(EvaluationEmailer).to receive(:send_to_participant)
      participant.remind_to_add_peers
    end
  end

  describe "#remind_to_remind_peers" do
    it 'sends reminder to remind peers' do
      participant = build(:participant)
      expect(EvaluationEmailer).to receive(:remind_peers_reminder)
      participant.remind_to_remind_peers
    end
  end

end
