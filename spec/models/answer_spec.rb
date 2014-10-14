require 'rails_helper'

RSpec.describe Answer, :type => :model do
  expect_it { to belong_to :question }
  expect_it { to belong_to :evaluation }
end
