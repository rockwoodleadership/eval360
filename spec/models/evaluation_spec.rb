require 'rails_helper'
require 'evaluation_emailer'

RSpec.describe Evaluation, :type => :model do
  expect_it { to validate_uniqueness_of :access_key }
  expect_it { to belong_to :participant }
  expect_it { to belong_to :evaluator }
  expect_it { to have_many :answers }
  expect_it { to have_db_index(:access_key) }

  before(:each) do
    @questionnaire = create(:questionnaire_with_questions)
    @evaluation = create(:evaluation)
    allow(@evaluation).to receive_message_chain(:participant, :program, :questionnaire) { @questionnaire }
  end

  describe "#build_questions" do
    it 'creates new answers' do
      answer_count = @evaluation.answers.count
      @evaluation.build_questions
      expect(@evaluation.answers.count).to be > answer_count
    end
  end

  describe "#header" do
    it 'returns the header for associated questionnaire' do
      expect(@evaluation.header).to eq @questionnaire.header
    end
  end

  describe "#self_eval?" do
    it 'returns true if evaluator and participant are same' do
      evaluation = create(:self_evaluation)
      expect(evaluation.self_eval?).to eq true
    end
  end

end
