require 'rails_helper'

RSpec.describe EvaluationsController, :type => :controller do

  describe "GET edit" do
    it "returns http success" do
      evaluation = create(:evaluation)
      get :edit , id: evaluation.access_key
      expect(response).to be_success
    end
  end
end
