require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

require 'webmock/rspec'
WebMock.disable_net_connect!(:allow => "codeclimate.com")

require 'factory_girl'
require 'database_cleaner'

RSpec.configure do |config|

  config.expect_with :rspec do |expectations|
    # Enable only the newer, non-monkey-patching expect syntax.
    # For more details, see:
    #   - http://myronmars.to/n/dev-blog/2012/06/rspecs-new-expectation-syntax
    expectations.syntax = :expect
  end

  config.before(:each) do
    body = [{'email'=>'person1@example.com', 'status'=>'sent', '_id'=>'77bcd', 'reject_reason'=>nil}]
    stub_request(:post, "https://mandrillapp.com/api/1.0/messages/send-template.json").to_return(:status => 200, :body => body.to_json, :headers => {})
  end

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end

  config.include FactoryGirl::Syntax::Methods

  config.alias_example_to :expect_it
end

RSpec::Core::MemoizedHelpers.module_eval do
  alias to should
  alias to_not should_not
end
