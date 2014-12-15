class Evaluator < ActiveRecord::Base
  actable
  validates_presence_of :email
  has_one :evaluation, dependent: :destroy
  has_one :participant, through: :evaluation
  
  def self.bulk_create(emails)
    evaluators = []
    emails.each do |email|
      evaluators << Evaluator.create!(email: email)
    end
    return evaluators
  end

  def decline
    self.declined = true
    self.save
  end
end
