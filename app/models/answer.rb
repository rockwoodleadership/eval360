class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :evaluation

  validates_presence_of :question
  validates_presence_of :evaluation

  after_create :default_values

  def response
    if question.answer_type == "numeric"
      if numeric_response.nil? || numeric_response.zero?
        "not applicable"
      else
        numeric_response
      end
    else
      if text_response.nil? || text_response.empty? 
        "no response"
      else
        text_response
      end
    end

  end


  private
    def default_values
      self.numeric_response = 0
      self.save
    end
end
