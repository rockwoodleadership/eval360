require 'rails_helper'

RSpec.describe Questionnaire, :type => :model do
  expect_it { to have_many :questions }
  expect_it { to belong_to :program }
end
