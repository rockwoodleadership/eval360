require 'rails_helper'
require 'evaluation_emailer'

RSpec.describe Evaluation, :type => :model do
  

  describe 'validations and relationships' do
    before(:each) do
      allow_any_instance_of(Evaluation).to receive(:build_questions)
    end
    expect_it { to belong_to :evaluator }
    expect_it { to belong_to :participant }
    expect_it { to have_many :answers }
    expect_it { to validate_uniqueness_of :access_key }
    expect_it { to validate_presence_of :participant }
    expect_it { to validate_presence_of :evaluator }
    
    expect_it { to have_db_index(:access_key) }
    
  end

  describe 'callbacks' do
    expect_it { to callback(:build_questions).after(:create) }
    expect_it { to callback(:set_defaults).after(:create) }
    expect_it { to callback(:set_access_key).before(:validation).on(:create) }
  end

  describe "#eval_type_str" do
    context "for self evaluations" do
      it "returns the value 'Self Assessment'" do
        evaluation = build(:self_evaluation)
        expect(evaluation.eval_type_str).to eq 'Self Assessment'
      end
    end

    context "for peer evaluations" do
      it "returns the value 'Peer Assessment'" do
        evaluation = build(:evaluation)
        expect(evaluation.eval_type_str).to eq 'Peer Assessment'
      end
    end
  end

  describe ".create_self_evaluation" do
    it 'creates an evaluation where participant and evaluator are same' do
      participant = create(:participant)
      evaluation = Evaluation.create_self_evaluation(participant)
      expect(evaluation).to be_instance_of(Evaluation)
      expect(evaluation.evaluator_id).to eq evaluation.participant.evaluator.id 
    end
  end

  describe ".create_peer_evaluations" do
    it 'creates an evaluation where participant and evaluator are not the same' do
      participant = create(:participant)
      evaluators = []
      evaluators << create(:evaluator, email: "test1#{Time.now}@email.com")
      evaluators << create(:evaluator, email: "test2#{Time.now}@email.com")
      evaluations = Evaluation.create_peer_evaluations(evaluators, participant)
      expect(evaluations.first).to be_instance_of(Evaluation)
      expect(evaluations.first.evaluator_id).to_not eq evaluations.first.participant.evaluator.id
    end
  end

  describe "#title" do
    context "for self evaluations" do
      it "returns string 'Self Evaluation'" do
        evaluation = build(:self_evaluation)
        expect(evaluation.title).to eq 'Self Evaluation' 
      end
    end

    context "for peer evaluations" do
      it 'returns first name, last name, and preferred name of participant' do
        evaluation = build(:evaluation)
        expect(evaluation.title).to eq "Peer Evaluation for #{evaluation.participant.first_name} (#{evaluation.participant.preferred_name}) #{evaluation.participant.last_name}"
      end
    end
  end

  describe "#questionnaire" do
    it 'returns the questionnaire for the participants training program' do
      evaluation = build(:evaluation)
      expect(evaluation.questionnaire).to eq evaluation.participant.training.questionnaire
    end
  end

  describe "#mark_complete" do
    it 'sets evaluation status to completed' do
      evaluation = build(:evaluation)
      evaluation.mark_complete
      expect(evaluation.completed?).to eq true
    end
  end

  describe "#not_accessible?" do
    it 'returns true if evaluator has declined' do
      evaluator = build(:evaluator, declined: true) 
      evaluation = build(:evaluation, evaluator: evaluator)
      expect(evaluation.not_accessible?).to eq true
    end

    it 'returns true if training date has passed' do
      training = build(:training, end_date: Date.current - 1.day )
      participant = build(:participant, training: training)
      evaluation = build(:evaluation, participant: participant)
      expect(evaluation.not_accessible?).to eq true 
    end

    it 'returns false if evaluator is active and training is upcoming' do
      evaluation = build(:evaluation)
      expect(evaluation.not_accessible?).to eq false
    end
  end

end
