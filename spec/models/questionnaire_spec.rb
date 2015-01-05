require 'rails_helper'

RSpec.describe Questionnaire, :type => :model do
  expect_it { to have_many :sections }

  describe ".generate_from_yaml" do
    it 'creates a questionnaire' do
      questionnaire = Questionnaire.generate_from_yaml('config/questionnaires/Standalone.yml')
      expect(questionnaire).to be_instance_of(Questionnaire)
    end
  end
end
