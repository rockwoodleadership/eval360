require 'rails_helper'

RSpec.describe Questionnaire, :type => :model do
  expect_it { to have_many :questions }
  expect_it { to belong_to :program }

  describe ".generate_from_yaml" do
    it 'creates a questionnaire' do
      program = create(:program)
      questionnaire = Questionnaire.generate_from_yaml('config/questionnaires/default.yml', program)
      expect(questionnaire).to be_instance_of(Questionnaire)
    end
  end
end
