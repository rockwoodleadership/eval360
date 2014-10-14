class Questionnaire < ActiveRecord::Base
  has_many :questions, inverse_of: :questionnaire
  belongs_to :program, inverse_of: :questionnaire
end
