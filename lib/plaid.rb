require 'plaid/version'
require 'plaid/errors'
require 'plaid/connector'
require 'plaid/category'
require 'plaid/institution'
require 'plaid/user'
require 'plaid/transaction'
require 'plaid/info'
require 'plaid/income'

require 'uri'

# Public: The Plaid namespace.
module Plaid
  # Public: Available Plaid products.
  PRODUCTS = %i(connect auth info income risk).freeze

  class <<self
    # Public: The String Plaid account client ID to authenticate requests.
    attr_accessor :client_id

    # Public: The String Plaid account secret to authenticate requests.
    attr_accessor :secret

    # Public: Plaid environment to use. Should be set to :tartan, :api, or a
    # full URL like 'https://tartan.plaid.com'.
    attr_accessor :env

    # Public: The Integer read timeout for requests to Plaid HTTP API.
    # Should be specified in seconds. Default value is 120 (2 minutes).
    attr_accessor :read_timeout

    # Public: A helper function to ease configuration.
    #
    # Yields self.
    #
    # Examples
    #
    #   Plaid.configure do |p|
    #     p.client_id = 'Plaid provided client ID here'
    #     p.secret = 'Plaid provided secret key here'
    #     p.env = :tartan
    #     p.read_timeout = 300   # it's 5 minutes, yay!
    #   end
    #
    # Returns nothing.
    def config
      yield self

      case env
      when :tartan, :api
        self.env = "https://#{env}.plaid.com/"
      when String
        begin
          URI.parse(env)
        rescue
          raise ArgumentError, "Invalid URL in Plaid.env (#{env.inspect}). " \
                               'Specify either Symbol (:tartan, :api), or a ' \
                               "full URL, like 'https://tartan.plaid.com'"
        end
      else
        raise ArgumentError, "Invalid value for Plaid.env (#{env.inspect}): " \
                             'must be :tartan, :api, or a full URL, ' \
                             "e.g. 'https://tartan.plaid.com'"
      end
    end

    # Internal: Symbolize keys (and values) for a hash.
    #
    # hash   - The Hash with string keys (or nil).
    # values - The Boolean flag telling the function to symbolize values
    #          as well.
    #
    # Returns a Hash with keys.to_sym (or nil if hash is nil).
    def symbolize_hash(hash, values: false)
      return unless hash
      return hash.map { |h| symbolize_hash(h) } if hash.is_a?(Array)

      hash.each_with_object({}) do |(k, v), memo|
        memo[k.to_sym] = values ? v.to_sym : v
      end
    end
  end
end
