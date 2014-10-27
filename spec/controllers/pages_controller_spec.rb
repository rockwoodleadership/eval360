require 'rails_helper'

RSpec.describe PagesController, :type => :controller do

  describe "GET index" do
    it "returns http success" do
      get :index
      expect(response).to be_success
    end
  end

  describe "GET thank_you" do
    before(:each) { get :thank_you }
    it "returns http success" do
      expect(response).to be_success
    end

    it "renders thank you template" do
      expect(response).to render_template('thank_you')
    end
  end

end
