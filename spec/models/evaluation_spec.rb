require 'rails_helper'
require 'evaluation_emailer'

RSpec.describe Evaluation, :type => :model do
  expect_it { to validate_uniqueness_of :access_key }
  expect_it { to belong_to :participant }
  expect_it { to belong_to :evaluator }

end
