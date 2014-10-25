require 'rails_helper'

RSpec.describe Answer, :type => :model do
  expect_it { to belong_to :question }
  expect_it { to belong_to :evaluation }
  expect_it { to validate_presence_of :evaluation }
  expect_it { to validate_presence_of :question }
  expect_it { to callback(:default_values).after(:create) } 
end
