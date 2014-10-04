require 'rails_helper'

RSpec.describe Participant, :type => :model do

  expect_it { to validate_presence_of :email }

end
