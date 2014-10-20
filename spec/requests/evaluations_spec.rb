require 'rails_helper'

RSpec.describe "Evaluations", :type => :request do
  describe "GET /evaluations/access_key/edit" do
    context "when access_key is found" do
      it "responds with a status of ok" do
        evaluation = create(:evaluation)
        answer = create(:answer)
        allow(Evaluation).to receive(:find_by_access_key).and_return(evaluation)
        allow(evaluation).to receive(:build_questions).and_return([])
        allow(evaluation).to receive(:header).and_return("test")
        allow(evaluation).to receive(:answers).and_return([])
        get "evaluations/#{evaluation.access_key}/edit"
        expect(response).to have_http_status(200)
      end
    end

    context "when access_key is not found" do
      it "responds with status of not found" do
        allow(Evaluation).to receive(:find_by_access_key).and_return(nil)
        get "evaluations/1222/edit"
        expect(response).to have_http_status(404)
      end
    end

  end
end
