class Program < ActiveRecord::Base
  has_many :trainings, inverse_of: :program
  has_one :questionnaire, inverse_of: :program
end
