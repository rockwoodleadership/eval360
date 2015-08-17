class Section < ActiveRecord::Base
  has_many :questions, -> { order "created_at ASC" }, dependent: :destroy
  has_many :questionnaire_templates
  has_many :questionnaires, through: :questionnaire_templates
  accepts_nested_attributes_for :questions


  def self.generate_from_parsed_yaml(yaml)
    s = Section.create(header: yaml["header"])
    yaml["questions"].each do |question|
      s.questions << Question.generate_from_parsed_yaml(question)
    end
    return s
  end
end
