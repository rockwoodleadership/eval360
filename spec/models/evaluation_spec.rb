require 'rails_helper'
require 'evaluation_emailer'

RSpec.describe Evaluation, :type => :model do
  

  describe 'validations and relationships' do
    before(:each) do
      allow_any_instance_of(Evaluation).to receive(:build_questions)
    end

    expect_it { to validate_uniqueness_of :access_key }
    expect_it { to validate_presence_of :participant }
    expect_it { to validate_presence_of :evaluator }
    expect_it { to belong_to :participant }
    expect_it { to belong_to :evaluator }
    expect_it { to have_many :answers }
    expect_it { to have_db_index(:access_key) }
    
  end

  describe 'callbacks' do
    expect_it { to callback(:build_questions).after(:create) }
    expect_it { to callback(:set_defaults).after(:create) }
    expect_it { to callback(:set_access_key).before(:validation).on(:create) }
  end

  
  describe "#header" do
    it 'returns the header for associated questionnaire' do
      allow_any_instance_of(Evaluation).to receive(:build_questions)
      evaluation = create(:evaluation)
      questionnaire = create(:questionnaire_with_questions)
      allow(evaluation).to receive_message_chain(:participant, :program, :questionnaire) { questionnaire }
      expect(evaluation.header).to eq questionnaire.header
    end
  end

  describe "#self_eval?" do
    it 'returns true if evaluator and participant are same' do
      allow_any_instance_of(Evaluation).to receive(:build_questions)
      evaluation = create(:self_evaluation)
      expect(evaluation.self_eval?).to eq true
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

  describe "#completed?" do
    it 'returns true if status is completed' do
      evaluation = build(:evaluation)
      evaluation.status = 'completed'
      expect(evaluation.completed?).to eq true
    end
  end

  describe "#mark_complete" do
    it 'sets evaluation status to completed' do
      evaluation = build(:evaluation)
      evaluation.mark_complete
      expect(evaluation.status).to eq 'completed'
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
      it 'returns first and last name of participant' do
        evaluation = build(:evaluation)
        expect(evaluation.title).to eq "Peer Evaluation for #{evaluation.participant.first_name} #{evaluation.participant.last_name}"
      end
    end
  end

  describe "#intro_text" do
    context "for self evaluations" do
      it 'returns the self intro text for its questionnaire' do
        evaluation = build(:self_evaluation) 
        expect(evaluation.intro_text).to eq evaluation.questionnaire.self_intro_text
      end
    end

    context "for peer evaluations" do
      it 'returns the peer intro text for its questionnaire' do
        evaluation = build(:evaluation)
        expect(evaluation.intro_text).to eq evaluation.questionnaire.intro_text
      end
    end
  end

  describe "#questionnaire" do
    it 'returns the questionnaire for the participants training program' do
      evaluation = build(:evaluation)
      expect(evaluation.questionnaire).to eq evaluation.participant.training.program.questionnaire
    end
  end

end
