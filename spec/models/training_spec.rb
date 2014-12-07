require 'rails_helper'

RSpec.describe Training, :type => :model do
  expect_it { to have_many :participants }
  expect_it { to belong_to :questionnaire }
  expect_it { validate_presence_of :questionnaire }
end
