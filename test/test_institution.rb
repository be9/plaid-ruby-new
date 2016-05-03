require 'test_helper'

# The test for Plaid::Institution
class PlaidInstitutionTest < MiniTest::Test
  include TestHelpers

  def setup
    tartan
  end

  def test_string_representation
    i = bofa

    str = '#<Plaid::Institution id="5301a93ac140de84910000e0", ' \
          'type="bofa", name="Bank of America">'

    assert_equal str, i.to_s
    assert_equal str, i.inspect
  end

  def test_all_institutions
    stub_request(:get, 'https://tartan.plaid.com/institutions')
      .to_return(status: 200, body: fixture(:institutions))

    insts = Plaid::Institution.all

    assert_equal 14, insts.size

    i = insts.select { |c| c.id == '5301a99504977c52b60000d0' }.first
    refute_nil i

    assert_equal({ 'username' => 'User ID', 'password' => 'Password' },
                 i.credentials)
    assert i.has_mfa
    assert_equal %w(code list), i.mfa

    assert_equal 'Chase', i.name
    assert_equal %i(connect auth balance info income risk), i.products
    assert_equal 'chase', i.type
  end

  def test_all_institutions_with_custom_client
    client = Plaid::Client.new(env: 'https://example.com')

    stub_request(:get, 'https://example.com/institutions')
      .to_return(status: 200, body: fixture(:institutions))

    Plaid::Institution.all client: client
  end

  def test_get_single_institution
    stub_request(:get, 'https://tartan.plaid.com/institutions/5301a99504977c52b60000d0')
      .to_return(status: 200, body: fixture('institution_chase'))

    i = Plaid::Institution.get '5301a99504977c52b60000d0'
    refute_nil i

    assert_equal({ 'username' => 'User ID', 'password' => 'Password' },
                 i.credentials)
    assert i.has_mfa
    assert_equal '5301a99504977c52b60000d0', i.id
    assert_equal %w(code list), i.mfa

    assert_equal 'Chase', i.name
    assert_equal %i(connect auth balance info income risk), i.products
    assert_equal 'chase', i.type
  end

  def test_get_single_institution_with_custom_client
    client = Plaid::Client.new(env: 'https://example.com')

    stub_request(:get, 'https://example.com/institutions/123')
      .to_return(status: 200, body: fixture('institution_chase'))

    Plaid::Institution.get '123', client: client
  end

  def test_get_nonexistent_institution
    stub_request(:get, 'https://tartan.plaid.com/institutions/0')
      .to_return(status: 404, body: fixture(:institution_not_found))

    e = assert_raises(Plaid::NotFoundError) do
      Plaid::Institution.get '0'
    end

    assert_equal 'Code 1301: unable to find institution. Double-check the ' \
                 'provided institution ID.', e.message
  end

  private

  def bofa
    Plaid::Institution.new('credentials' => {
                             'username' => 'Online ID',
                             'password' => 'Password'
                           },
                           'has_mfa' => true,
                           'id' => '5301a93ac140de84910000e0',
                           'mfa' => [
                             'code',
                             'list',
                             'questions(3)'
                           ],
                           'name' => 'Bank of America',
                           'products' => %w(
                             connect
                             auth
                             balance
                             info
                             income
                             risk),
                           'type' => 'bofa')
  end
end
