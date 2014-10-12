class Evaluator < ActiveRecord::Base
  actable
  validates_presence_of :email
  validates_uniqueness_of :email
end
