require 'rails_helper'
require 'evaluation_emailer'

RSpec.describe Evaluation, :type => :model do
  expect_it { to validate_uniqueness_of :access_key }
  expect_it { to belong_to :participant }
  expect_it { to belong_to :evaluator }
  expect_it { to have_many :answers }
  expect_it { to have_db_index(:access_key) }

  describe "#build_questions" do
    it 'creates new answers' do
      questionnaire = create(:questionnaire_with_questions)
      evaluation = create(:evaluation)
      answer_count = evaluation.answers.count
      evaluation.stub_chain(:participant, :program, :questionnaire).and_return(questionnaire)
      evaluation.build_questions
      expect(evaluation.answers.count).to be > answer_count
    end

  end

end
