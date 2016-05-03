module Plaid
  # Public: A class encapsulating information about a Financial Institution
  # supported by Plaid.
  class Institution
    # Public: The String institution ID. E.g. "5301a93ac140de84910000e0".
    attr_reader :id

    # Public: The String institution name. E.g. "Bank of America".
    attr_reader :name

    # Public: The String institution shortname, or "type" per Plaid API docs.
    # E.g. "bofa".
    attr_reader :type

    # Public: The Boolean flag telling if the institution requires MFA.
    attr_reader :has_mfa

    # Public: Returns true if the institution requires MFA.
    alias has_mfa? has_mfa

    # Public: The Hash with MFA options available. E.g. ["code", "list",
    # "questions(3)"]. This means that you are allowed to request a list of
    # possible MFA options, use code-based MFA and questions MFA (there are 3
    # questions).
    attr_reader :mfa

    # Public: The Hash with credential labels, how they are exactly named by
    # the institution. E.g. {"username": "Online ID", "password": "Password"}.
    attr_reader :credentials

    # Public: An Array with Symbol product names supported by the institution.
    # E.g. [:connect, :auth, :balance, :info, :income, :risk]. See
    # Plaid::PRODUCTS.
    attr_reader :products

    # Internal: Initialize an Institution with given fields.
    def initialize(fields)
      @id = fields['id']
      @name = fields['name']
      @type = fields['type']
      @has_mfa = fields['has_mfa']
      @mfa = fields['mfa']
      @credentials = fields['credentials']
      @products = fields['products'].map(&:to_sym)
    end

    # Public: Get a String representation of the institution.
    #
    # Returns a String.
    def inspect
      "#<Plaid::Institution id=#{id.inspect}, type=#{type.inspect}, " \
      "name=#{name.inspect}>"
    end

    # Public: Get a String representation of the institution.
    #
    # Returns a String.
    alias to_s inspect

    # Public: Get information about the Financial Institutions currently
    # supported by Plaid.
    #
    # Does a GET /institutions call.
    #
    # client - The Plaid::Client instance used to connect
    #          (default: Plaid.client).
    #
    # Returns an Array of Institution instances.
    def self.all(client: nil)
      Connector.new(:institutions, client: client).get.map do |idata|
        new(idata)
      end
    end

    # Public: Get information about a given Financial Institution.
    #
    # Does a GET /institutions/:id call.
    #
    # id     - the String institution ID (e.g. "5301a93ac140de84910000e0").
    # client - The Plaid::Client instance used to connect
    #          (default: Plaid.client).
    #
    # Returns an Institution instance or raises Plaid::NotFoundError if
    # institution with given id is not found.
    def self.get(id, client: nil)
      new Connector.new(:institutions, id, client: client).get
    end

    # Public: Get information about the "long tail" institutions supported
    # by Plaid via partnerships.
    #
    # Does a POST /institutions/longtail call.
    #
    # count  - The Integer number of results to retrieve (default: 50).
    # offset - The Integer number of results to skip forward from the
    #          beginning of the list (default: 0).
    #
    # Returns an Array of Institution instances.
    def self.longtail(count: 50, offset: 0)
    end

    # Public: Search institutions.
    #
    # query   - The String search query to match against the full list of
    #           institutions. Partial matches are returned making this useful
    #           for autocompletion purposes (default: nil).
    # product - The Symbol product name to filter by, one of Plaid::PRODUCTS
    #           (e.g. :info, :connect, etc.). Only valid when query is
    #           specified. If nil, results are not filtered by product
    #           (default: nil).
    # id      - The String ID of a financial institution. If this argument is
    #           specified, query and product are ignored (default: nil).
    def self.search(query: nil, product: nil, id: nil)
    end
  end
end
