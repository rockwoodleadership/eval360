class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :evaluation

  validates_presence_of :question
  validates_presence_of :evaluation

  after_create :default_values


  private
    def default_values
      self.numeric_response = 0
    end
end
