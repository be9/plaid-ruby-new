module Plaid
  class Category
    # Public: Get information about all available categories.
    #
    # Does a GET /categories call.
    #
    # Returns an Array of Category instances.
    def self.all
    end

    # Public: Get information about a given category.
    #
    # Does a GET /categories/:id call.
    #
    # id - the String category ID (e.g. "17001013").
    #
    # Returns a Category instance, or nil if category was not found.
    def self.get(id)
    end
  end
end
