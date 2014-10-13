require 'rails_helper'

RSpec.describe "Evaluations", :type => :request do
  describe "GET /evaluations/access_key/edit" do
    it "responds with a status of ok" do
      get "evaluations/access_code/edit"
      expect(response).to have_http_status(200)
    end
  end
end
