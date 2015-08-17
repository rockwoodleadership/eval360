class QuestionnaireTemplate < ActiveRecord::Base
  belongs_to :questionnaire
  belongs_to :section
end
