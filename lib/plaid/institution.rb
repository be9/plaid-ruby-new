module Plaid
  class Institution

    # Public: Get information about the Financial Institutions currently
    # supported by Plaid.
    #
    # Does a GET /institutions call.
    #
    # Returns an Array of Institution instances.
    def self.all
    end

    # Public: Get information about a given Financial Institution.
    #
    # Does a GET /institutions/:id call.
    #
    # id - the String institution ID (e.g. "5301a93ac140de84910000e0").
    #
    # Returns an Institution instance, or nil if institution was not found.
    def self.get(id)
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
