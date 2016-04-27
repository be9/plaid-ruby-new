module Plaid
  class Category
    attr_reader :type, :hierarchy, :id

    # Private: Initialize a Category with given fields.
    def initialize(fields)
      @type = fields['type'].to_sym
      @hierarchy = fields['hierarchy']
      @id = fields['id']
    end

    # Public: Get a String representation of Category.
    #
    # Returns a String.
    def inspect
      %{#<Plaid::Category type=#{type.inspect}, hierarchy=#{hierarchy.inspect}, id=#{id.inspect}>}
    end

    # Public: Get a String representation of Category.
    #
    # Returns a String.
    alias to_s inspect

    # Public: Get information about all available categories.
    #
    # Does a GET /categories call.
    #
    # Returns an Array of Category instances.
    def self.all
      Connector.new(:categories).get.map do |category_data|
        new(category_data)
      end
    end

    # Public: Get information about a given category.
    #
    # Does a GET /categories/:id call.
    #
    # id - the String category ID (e.g. "17001013").
    #
    # Returns a Category instance.
    def self.get(id)
      new Connector.new(:categories, id).get
    end
  end
end
