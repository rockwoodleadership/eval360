require 'rails_helper'

RSpec.describe LOIReport, :type => :model do
  let(:section1) { FactoryBot.create(:section, header: 'Eagles') }
  let(:section2) { FactoryBot.create(:section, header: 'Patriots') }
  let(:questionnaire) { FactoryBot.create(:questionnaire) }
  let!(:questionnaire_template1) { FactoryBot.create(:questionnaire_template,
                                                      questionnaire: questionnaire,
                                                      section: section1) }
  let!(:questionnaire_template2) { FactoryBot.create(:questionnaire_template,
                                                      questionnaire: questionnaire,
                                                      section: section2) }
  let(:training) { FactoryBot.create(:training, questionnaire: questionnaire,
                                      name: 'SuperBowl') }
  let(:participant) { FactoryBot.create(:participant, training: training) }

  subject { LOIReport.new(participant) }

  it { expect(subject.class).to be < Report }

  describe '#sections' do
    it 'returns all the sections on the questionnaire' do
      expect(subject.sections.count).to eq 2
      expect(subject.sections.first.header).to eq 'Eagles'
    end
  end

  describe '#average_section_score' do
    let(:question) { FactoryBot.create(:question, section: section1) }
    let(:evaluation1) { FactoryBot.create(:evaluation, participant: participant,
                                          self_eval: false, completed: true) }
    let(:evaluation2) { FactoryBot.create(:evaluation, participant: participant,
                                          self_eval: false, completed: true) }
    let!(:answer1) { FactoryBot.create(:answer, numeric_response: 4,
                                      question: question, evaluation: evaluation1) }
    let!(:answer2) { FactoryBot.create(:answer, numeric_response: 10,
                                      question: question, evaluation: evaluation2) }

    it 'returns the average score for the section' do
      expect(subject.average_section_score(section1)).to eq 7
    end
  end

  context 'where there is a peer evaluation' do
    let(:evaluation_1) { FactoryBot.create(:evaluation, participant: participant, completed: true) }

    before do
      9.times do |i|
        self_eval_question = FactoryBot.create(:question)
        participant.self_evaluation.questions << self_eval_question
        FactoryBot.create(:answer, evaluation: evaluation_1, numeric_response: 1+i, question: self_eval_question)
      end
    end

    describe '#top_8_scores' do
      it 'returns the top 8 scores' do
        expect(subject.top_8_scores).to include({:position=>9, :mean_score=>9.0, :description=>"Please rate yourself 1-4"})
        expect(subject.top_8_scores).not_to include({:position=>1, :mean_score=>1.0, :description=>"Please rate yourself 1-4"})
        expect(subject.top_8_scores.count).to eq 8
      end
    end

    describe '#bottom_8_scores' do
      it 'returns the bottom 8 scores' do
        expect(subject.bottom_8_scores).to include({:position=>1, :mean_score=>1.0, :description=>"Please rate yourself 1-4"})
        expect(subject.bottom_8_scores).not_to include({:position=>9, :mean_score=>9.0, :description=>"Please rate yourself 1-4"})
        expect(subject.bottom_8_scores.count).to eq 8
      end
    end
  end
end
