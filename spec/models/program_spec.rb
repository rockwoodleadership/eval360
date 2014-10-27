require 'rails_helper'

RSpec.describe Program, :type => :model do
  expect_it { to have_many :trainings }
  expect_it { to have_one :questionnaire }
  expect_it { to validate_presence_of :name }
  expect_it { to validate_uniqueness_of :name }
end
