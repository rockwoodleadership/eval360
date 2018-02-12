require 'rails_helper'

RSpec.describe Histogram, :type => :model do
  let(:participant) { FactoryBot.create(:participant) }
  let(:peer_evaluation_1) { FactoryBot.create(:evaluation,
                                                participant: participant,
                                                completed: true) }
  let(:peer_evaluation_2) { FactoryBot.create(:evaluation,
                                                participant: participant,
                                                completed: true) }
  let(:question) { FactoryBot.create(:question) }
  let(:numeric_answer_1) { rand(1..5) }
  let(:numeric_answer_2) { rand(6..10) }
  let!(:answer_1) { FactoryBot.create(:answer, evaluation: peer_evaluation_1,
                                       numeric_response: numeric_answer_1,
                                       question: question) }
  let!(:answer_2) { FactoryBot.create(:answer, evaluation: peer_evaluation_2,
                                       numeric_response: numeric_answer_2,
                                       question: question) }

  subject { Histogram.new(participant, question) }
  describe '#frequency' do
    it 'returns an array of frequency answer options 1 - 10' do
      expect(subject.frequency[numeric_answer_1]).to eq 1
      expect(subject.frequency[numeric_answer_2]).to eq 1
    end
  end

  describe '#mean' do
    it 'returns the average score for the given question' do
      avg = (numeric_answer_1 + numeric_answer_2).to_f/2
      expect(subject.mean).to eq avg
    end
  end

  describe '#self_score' do
    it 'returns the self score for the given question' do 
      self_score = rand(1..10)
      FactoryBot.create(:answer, evaluation: participant.self_evaluation, numeric_response: self_score, question: question)
      expect(subject.self_score).to eq self_score
    end
  end
end
