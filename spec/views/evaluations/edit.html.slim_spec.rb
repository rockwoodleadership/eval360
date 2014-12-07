require 'rails_helper'

describe 'evaluations/edit.html.slim' do
  before(:each) do
    @evaluation = create(:evaluation_with_questions)
    assign(:evaluation, @evaluation)
  end
  it 'displays correct text for peer evaluations' do
    allow(@evaluation).to receive(:self_eval?).and_return(false)    
    render
    expect(rendered).to match /#{Regexp.quote(@evaluation.questions.first.description)}/
  end

  it 'displays correct text for self evaluations' do
    allow(@evaluation).to receive(:self_eval?).and_return(true)
    render
    expect(rendered).to match /#{Regexp.quote(@evaluation.questions.first.self_description)}/
  end
  it 'displays input fields for responses' do
    render
    expect(rendered).to match /input/
  end
end

