require 'rails_helper'

describe 'participants/invitations.html.slim' do
  before(:each) do
    @participant = create(:participant)
    assign(:participant, @participant)
  end

  it 'displays a form to collect email addresses to send invite for peer evaluations' do
    render
    expect(rendered).to match /input/
  end
end
