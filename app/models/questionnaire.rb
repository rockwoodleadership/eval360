require 'yaml'
class Questionnaire < ActiveRecord::Base
  has_many :questionnaire_templates
  has_many :sections, -> { includes(:questions).order("created_at ASC") },
    through: :questionnaire_templates
  validates_uniqueness_of :name
  accepts_nested_attributes_for :sections

  #example from rails console
  #Questionnaire.generate_from_yaml('config/questionnaires/individual.yml')

  def self.generate_from_yaml(filename)
    yaml = YAML.load_file(filename)
    name = filename.split("/").last.split(".").first
    q = Questionnaire.create(name: name)
    yaml.each do |section|
      s = Section.generate_from_parsed_yaml(section)
      q.sections << s 
    end
    return q
  end

  def questions
    q = sections.map {|s| s.questions }
    q.flatten
  end

  def numeric_questions
    q = sections.map { |s| s.questions.where(answer_type: 'numeric') }
    q.flatten
  end

end
