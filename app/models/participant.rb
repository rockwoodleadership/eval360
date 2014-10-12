class Participant < ActiveRecord::Base
  acts_as :evaluator
  has_many :evaluations
end
