require 'rails_helper'

RSpec.describe Participant, :type => :model do

  expect_it { to validate_presence_of :email }
  expect_it { to have_many :evaluations }

end
