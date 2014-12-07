require 'rails_helper'

RSpec.describe Participant, :type => :model do
  before(:each) do
    allow_any_instance_of(Evaluation).to receive(:build_questions)
  end
  expect_it { to validate_presence_of :email }
  expect_it { to have_many :evaluations }
  expect_it { to have_many(:evaluators).through(:evaluations) }
  expect_it { to belong_to :training }
  expect_it { to validate_presence_of :training }
  expect_it { to validate_uniqueness_of :access_key }
  expect_it { to have_db_index(:access_key) }
  expect_it { to callback(:set_access_key).before(:validation).on(:create) }

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

  describe "#full_name" do
    it 'returns first and last name as a string' do
      participant = build(:participant)
      expect(participant.full_name).to eq "#{participant.first_name} #{participant.last_name}"
    end
  end

  describe "#peer_evaluators" do
    it 'returns the peer evaluators' do
      participant = create(:participant_with_self_and_peer_eval)
      expect(participant.peer_evaluators.count).to eq 1
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


end
