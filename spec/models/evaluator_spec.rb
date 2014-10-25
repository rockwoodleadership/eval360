require 'rails_helper'

RSpec.describe Evaluator, :type => :model do
  expect_it { to validate_uniqueness_of :email }
  expect_it { to validate_presence_of :email }
  expect_it { to have_one :evaluation }
  expect_it { to have_one(:participant).through(:evaluation) }

  

  context 'when it is a peer evaluator' do
    it 'validates presence of participant' do
      allow(subject).to receive(:actable_type) { nil }
      expect(subject).to_not be_valid
    end
  end

  context 'when it is a self evaluator' do
    it 'does not validate presence of participant' do
      allow(subject).to receive(:actable_type) { 'Participant' }
      subject.email = "test@#{Time.now}" 
      expect(subject).to be_valid
    end
  end

  describe '.bulk_create' do
    it ' creates multiple evaluators' do
      attributes = {"0"=>{"email"=>"test1#{Time.now}@gmail.com"},
     "1"=>{"email"=>"test2#{Time.now}@gmail.com"}}
      evaluators = Evaluator.bulk_create(attributes)
      expect(evaluators.length).to eq 2
      expect(evaluators.first).to be_instance_of(Evaluator)
    end
  end

end
