require 'rails_helper'

RSpec.describe Program, :type => :model do
  expect_it { to have_many :trainings }
  expect_it { to have_one :questionnaire }
end
