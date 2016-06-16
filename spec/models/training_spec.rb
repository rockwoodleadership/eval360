require 'rails_helper'

RSpec.describe Training, :type => :model do
  expect_it { to have_many :participants }
  expect_it { to belong_to :questionnaire }
  expect_it { validate_presence_of :questionnaire }
  
  describe "reminders" do
    before(:each) do
      training = create(:training, start_date: Date.today + 10.days)
      @participant = create(:participant_with_self_eval, training_id: training.id )
      @participant2 = create(:participant_with_self_eval, training_id: training.id, do_not_remind: true )
      allow(Training).to receive_message_chain(:includes, :where) { [training] }
      allow(training).to receive(:participants) { [@participant, @participant2] }
    end

    describe ".send_self_eval_reminders" do
      it 'reminds participants to completed self eval' do
        expect(@participant).to receive(:remind)
        Training.send_self_eval_reminders
      end
    end

    describe ".send_add_peer_reminders" do
      it 'reminds participants to remind peers' do
        expect(@participant).to receive(:remind_to_add_peers)
        allow(@participant).to receive_message_chain(:self_evaluation, :completed?) { true }
        Training.send_add_peers_reminders
      end
    end

    describe ".send_remind_peers_reminders" do
      it 'reminds participants to remind peers' do
        expect(@participant2).not_to receive(:remind_to_remind_peers)
        evaluator = create(:evaluator)
        @participant2.evaluations.create(evaluator_id: evaluator.id) 
        Training.send_remind_peers_reminders
      end
    end
    context "when participant has reminders turned off" do
      describe ".send_self_eval_reminders" do
        it 'does not send a reminder' do
          expect(@participant2).not_to receive(:remind)
          Training.send_self_eval_reminders
        end
      end

      describe ".send_add_peer_reminders" do
        it 'does not send a reminder' do
          expect(@participant2).not_to receive(:remind_to_add_peers)
          allow(@participant2).to receive_message_chain(:self_evaluation, :completed?) { true }
          Training.send_add_peers_reminders
        end
      end

      describe ".send_remind_peers_reminders" do
        it 'does not send a reminder' do
          expect(@participant2).not_to receive(:remind_to_remind_peers)
          evaluator = create(:evaluator)
          @participant2.evaluations.create(evaluator_id: evaluator.id) 
          Training.send_remind_peers_reminders
        end
      end
      
    end
  end

end
