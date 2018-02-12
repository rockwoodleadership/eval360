require 'rails_helper'

RSpec.describe ReportsController, :type => :controller do
  
  let(:participant) { FactoryBot.create(:participant) }
  let(:access_key) {  participant.access_key }

  describe "GET show" do
    it 'creates a new report' do
      expect(Report).to receive(:new).with(participant)
      get :show, participant_id: access_key
    end

    it 'assigns the report' do
      get :show, participant_id: access_key
      expect(assigns(:report)).to_not be_nil
    end

    it 'renders report show page' do
      get :show, participant_id: access_key
      expect(response).to render_template('show')
    end

    context 'when training is Yearlong Individual' do
      let(:questionnaire) { FactoryBot.create(:questionnaire, name: 'YearlongIndividual') }
      let(:training) { FactoryBot.create(:training, questionnaire: questionnaire) }
      let(:participant) { FactoryBot.create(:participant, training: training) }

      it 'renders loi report page' do
        get :show, participant_id: access_key
        expect(response).to render_template('loi_report')
      end

      it 'creates a LOI report' do
        expect(LOIReport).to receive(:new).with(participant)
        get :show, participant_id: access_key
      end
    end
  end

  describe "GET histogram" do
    let(:question) { FactoryBot.create(:question) }

    it 'creates a new histogram' do
      expect(Histogram).to receive(:new).with(participant, question)
      get :histogram, participant_id: access_key, question_id: question.id
    end

    it 'assigns the histogram' do
      get :histogram, participant_id: access_key, question_id: question.id
      expect(assigns(:histogram)).to_not be_nil
    end

    it 'renders histogram partial' do
      get :histogram, participant_id: access_key, question_id: question.id
      expect(response).to render_template(partial: '_histogram')
    end
  end
end
