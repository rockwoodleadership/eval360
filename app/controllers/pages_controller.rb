class PagesController < ApplicationController
  include Databasedotcom::OAuth2::Helpers

  def index
    @authenticated = authenticated?
    @me = me if authenticated?
  end

  def thank_you
    render 'thank_you'
  end
end
