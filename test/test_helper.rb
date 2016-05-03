require 'minitest/autorun'
require 'webmock/minitest'

require 'plaid'

# Internal: Helpers to be included to the test classes.
module TestHelpers
  def fixture(name)
    File.new(File.dirname(__FILE__) + "/fixtures/#{name}.json")
  end

  def reset_config
    Plaid.client_id = nil
    Plaid.secret = nil
    Plaid.env = nil
  end

  def tartan
    Plaid.config do |p|
      p.env = :tartan
    end
  end

  def full_test_credentials
    Plaid.config do |p|
      p.env = :tartan
      p.client_id = 'test_id'
      p.secret = 'test_secret'
    end
  end

  def stub_api(method, path, body: {}, status: 200, response: nil)
    response = fixture(response) if response.is_a?(Symbol)

    stub_request(method, "https://tartan.plaid.com/#{path}")
      .with(body: body,
            headers: { 'Content-Type' => 'application/x-www-form-urlencoded' })
      .to_return(status: status, body: response)
  end
end
