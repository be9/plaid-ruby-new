require 'test_helper'

class PlaidConnectorTest < MiniTest::Test
  include TestHelpers

  def setup
    tartan
  end

  def test_no_env_set
    reset_config

    assert_raises(Plaid::NotConfiguredError) do
      Plaid::Connector.new(:categories)
    end
  end

  def test_200
    stub_request(:get, "https://tartan.plaid.com/test").
      to_return(status: 200, body: '{"test": true}')

    conn = Plaid::Connector.new(:test)

    assert_equal({"test" => true}, conn.get)
    refute conn.mfa?
  end

  def test_201
    stub_request(:get, "https://tartan.plaid.com/test").
      to_return(status: 201, body: '{"test": true}')

    conn = Plaid::Connector.new(:test)

    assert_equal({"test" => true}, conn.get)
    assert conn.mfa?
  end

  def test_400
    stub_request(:get, "https://tartan.plaid.com/test").to_return(status: 400, body: error_body)

    e = assert_raises(Plaid::BadRequestError) { make_request }
    check_exception e
  end

  def test_401
    stub_request(:get, "https://tartan.plaid.com/test").to_return(status: 401, body: error_body)

    e = assert_raises(Plaid::UnauthorizedError) { make_request }
    check_exception e
  end

  def test_402
    stub_request(:get, "https://tartan.plaid.com/test").to_return(status: 402, body: error_body)

    e = assert_raises(Plaid::RequestFailedError) { make_request }
    check_exception e
  end

  def test_404
    stub_request(:get, "https://tartan.plaid.com/test").to_return(status: 404, body: error_body)

    e = assert_raises(Plaid::NotFoundError) { make_request }
    check_exception e
  end

  def test_500
    stub_request(:get, "https://tartan.plaid.com/test").to_return(status: 500, body: error_body)

    e = assert_raises(Plaid::ServerError) { make_request }
    check_exception e
  end

  private

  def make_request
    Plaid::Connector.new(:test).get
  end

  def error_body
    %({"code": 999, "message": "boy it's wrong", "resolve": "No way!"})
  end

  def check_exception(e)
    assert_equal 999, e.code
    assert_equal "No way!", e.resolve
    assert_equal "Code 999: boy it's wrong. No way!", e.message
  end
end
