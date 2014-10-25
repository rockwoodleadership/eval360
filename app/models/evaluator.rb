class Evaluator < ActiveRecord::Base
  actable
  validates_presence_of :email
  validates_uniqueness_of :email
  has_one :evaluation
  has_one :participant, through: :evaluation
  
  def self.bulk_create(attributes)
    evaluators = []
    attributes.each_value do |attr|
      evaluators << Evaluator.create!(email: attr['email']) unless attr['email'].blank?
    end
    return evaluators
  end
end
