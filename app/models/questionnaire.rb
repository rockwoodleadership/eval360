require 'yaml'
class Questionnaire < ActiveRecord::Base
  has_many :questions, inverse_of: :questionnaire
  belongs_to :program, inverse_of: :questionnaire

  def self.generate_from_yaml(filename, program)
    yaml = YAML.load_file(filename).first
    q = program.create_questionnaire(header: yaml["header"])
    yaml["questions"].each do |question|
      q.questions << Question.generate_from_parsed_yaml(question)
    end
    return q
  end

  def admin_title
    "#{program.name} Questionnaire"
  end
end
