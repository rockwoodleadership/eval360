class Training < ActiveRecord::Base
  has_many :participants, -> { order "first_name ASC" }, inverse_of: :training 
  accepts_nested_attributes_for :participants
  belongs_to :questionnaire

  validates_presence_of :questionnaire_id

end
