require 'webmock/rspec'
require 'vcr'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
    expectations.syntax = [:should, :expect]
  end

  config.mock_with :mocha

  config.tty = true
  config.color = true
  config.formatter = :documentation

  config.around(:each) do |example|
    $redis.flushall
    example.run
  end
end
