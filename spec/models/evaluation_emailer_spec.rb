require 'rails_helper'
require 'evaluation_emailer'

describe EvaluationEmailer do
  before do
    @participant = create(:participant_with_peer_evaluation)
  end

  describe '.send_pdf_reports' do
    before do
      @training = create(:training)
      @training.participants.create(email:"email1#{Time.now}")
      @training.participants.create(email:"email2#{Time.now}")
      allow_any_instance_of(Evaluation).to receive(:completed?) { true }
      allow(File).to receive(:open) { File.new("test", "w+") }
    end

    after do
      EvaluationEmailer.send_pdf_reports(@training.id, "example.com")
      FileUtils.rm("test")
    end

    it 'creates a pdf for each training participant' do
      expect(ReportPdf).to receive(:new).exactly(@training.participants.count).times { Prawn::Document.new } 
    end

    it 'creates a zip file' do
      expect(Zip::File).to receive(:open)
    end

    it 'emails the zip file' do
      mandrill = Mandrill::API.new "test"
      allow(EvaluationEmailer).to receive(:mandrill) { mandrill }
      expect(mandrill).to receive_message_chain(:messages, :send)
    end
  end

  describe '.remind_peers_reminder' do
    it 'emails a peer reminder template' do
      expect(EvaluationEmailer).to receive(:send_template).
        with("reminder-to-remind-#{@participant.training.questionnaire.name}", anything())
      EvaluationEmailer.remind_peers_reminder(@participant)
    end
  end

  describe '.send_peer_invites' do
    context 'when it successfully sends' do
      it 'returns a count for number of messages sent' do
        evaluations = Array.new(@participant.evaluations)
        expect(EvaluationEmailer.send_peer_invites(evaluations)).to eq 1 
      end
    end
  end

  describe '.send_peer_reminders' do
    context 'when it successfully sends' do
      it 'returns a count for number of messages sent' do
        expect(EvaluationEmailer.send_peer_reminders(@participant, "Please complete")).to eq 1
      end
    end
  end
end
