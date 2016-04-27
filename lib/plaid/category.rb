module Plaid
  class Category
    # Public: The String category ID, e.g. "21010006".
    attr_reader :id

    # Public: The Symbol category type. One of :special, :place, :digital.
    attr_reader :type

    # Public: The Array of String hierarchy. E.g.
    # ["Food and Drink", "Nightlife", "Adult Entertainment"].
    attr_reader :hierarchy

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
      %{#<Plaid::Category id=#{id.inspect}, type=#{type.inspect}, hierarchy=#{hierarchy.inspect}>}
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
    # Returns a Category instance or raises Plaid::NotFoundError if category
    # with given id is not found.
    def self.get(id)
      new Connector.new(:categories, id).get
    end
  end
end
