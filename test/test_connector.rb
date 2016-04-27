require 'test_helper'

class PlaidConnectorTest < MiniTest::Test
  include TestHelpers

  def setup
    reset_config
  end

  def test_no_env_set
    assert_raises(Plaid::NotConfiguredError) do
      Plaid::Connector.new(:categories)
    end
  end
end
