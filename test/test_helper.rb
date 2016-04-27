require 'minitest/autorun'
require 'webmock/minitest'

require 'plaid'

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
    Plaid.env = :tartan
  end
end
