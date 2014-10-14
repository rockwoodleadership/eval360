require 'rails_helper'

RSpec.describe Question, :type => :model do
  expect_it { to belong_to :questionnaire }
  expect_it { to have_many :answers }
  expect_it { to validate_presence_of :answer_type }
end
