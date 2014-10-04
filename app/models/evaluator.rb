class Evaluator < ActiveRecord::Base
  actable
  validates_presence_of :email
end
