 require 'rails_helper'

 RSpec.describe Report, :type => :model do

   let(:participant) { FactoryBot.create(:participant) }
   subject { Report.new(participant) }

   expect_it { to delegate_method(:full_name).to(:participant).with_prefix(true) }
   expect_it { to delegate_method(:access_key).to(:participant).with_prefix(true) }
   expect_it { to delegate_method(:text_answers_for_q).to(:results) }
   expect_it { to delegate_method(:self_answer_for_q).to(:results) }

   context 'when there is a self evaluation' do
     let(:question) { FactoryBot.create(:question, description: "Favorite Movie") }
     let!(:answer) { FactoryBot.create(:answer, question: question, evaluation: participant.self_evaluation) }
     describe '#training_name' do
       it 'returns the participant training name' do
       expect(subject.training_name).to eq participant.training.name
       end
     end

     describe '#questions' do
       it 'returns the assessment questions' do
         expect(subject.questions.first.description).to eq "Favorite Movie"
       end
     end
   end

  context 'when there is a peer evaluation' do
    let(:evaluation_1) { FactoryBot.create(:evaluation, participant: participant, completed: true) }

    before do
      5.times do |i|
        self_eval_question = FactoryBot.create(:question)
        participant.self_evaluation.questions << self_eval_question
        FactoryBot.create(:answer, evaluation: evaluation_1, numeric_response: 1+i, question: self_eval_question)
      end
    end

    describe '#top_4_scores' do
      it 'returns the top 4 scores' do
        expect(subject.top_4_scores).to include({:position=>5, :mean_score=>5.0, :description=>"Please rate yourself 1-4"})
        expect(subject.top_4_scores).not_to include({:position=>1, :mean_score=>1.0, :description=>"Please rate yourself 1-4"})
      end
    end

    describe '#bottom_4_scores' do
      it 'returns the bottom 4 scores' do
        expect(subject.bottom_4_scores).not_to include({:position=>5, :mean_score=>5.0, :description=>"Please rate yourself 1-4"})
        expect(subject.bottom_4_scores).to include({:position=>1, :mean_score=>1.0, :description=>"Please rate yourself 1-4"})

      end
    end
  end
end
