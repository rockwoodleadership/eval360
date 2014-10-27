class PagesController < ApplicationController
  include Databasedotcom::OAuth2::Helpers

  def index
    @authenticated = authenticated?
    @me = me if authenticated?
  end

  def logout
    client.logout if authenticated?
    render 'index'
  end

  def thank_you
    render 'thank_you'
  end
end
