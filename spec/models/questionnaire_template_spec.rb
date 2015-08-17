require 'rails_helper'

RSpec.describe QuestionnaireTemplate, :type => :model do
  expect_it { to belong_to :questionnaire }
  expect_it { to belong_to :section }
end
