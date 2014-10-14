class Answer < ActiveRecord::Base
  actable
  belongs_to :question
  belongs_to :evaluation
end
