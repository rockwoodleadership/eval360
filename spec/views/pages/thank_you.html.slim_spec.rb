require 'rails_helper'

describe 'pages/thank_you.html.slim' do
  it 'displays text to thank peer evaluators' do
    render
    expect(rendered).to match /Thank you/
  end
end
