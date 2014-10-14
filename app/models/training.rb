class Training < ActiveRecord::Base
  has_many :participants, inverse_of: :training
  belongs_to :program , inverse_of: :trainings
end
