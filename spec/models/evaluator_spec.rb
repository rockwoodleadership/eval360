require 'rails_helper'

RSpec.describe Evaluator, :type => :model do
  expect_it { to  validate_uniqueness_of :email }
end
