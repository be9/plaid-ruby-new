require 'plaid/version'
require 'plaid/errors'
require 'plaid/connector'
require 'plaid/category'

require 'uri'

module Plaid
  class <<self
    # Public: Your Plaid account client ID, used to authenticate
    # requests.
    attr_accessor :client_id

    # Public: Your Plaid account secret, used to authenticate
    # requests.
    attr_accessor :secret

    # Public: Plaid environment to use. Should be set to :tartan, :api, or a full
    # URL like 'https://tartan.plaid.com'.
    attr_accessor :env

    # Public: Available Plaid products.
    PRODUCTS = %i(connect auth info income risk)

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
          raise ArgumentError, "Invalid URL in Plaid.env (#{env.inspect}). Specify either Symbol (:tartan, :api), or a full URL, like 'https://tartan.plaid.com'"
        end
      else
        raise ArgumentError, "Invalid value for Plaid.env (#{env.inspect}): must be :tartan, :api, or a full URL, e.g. 'https://tartan.plaid.com'"
      end
    end
  end
end
