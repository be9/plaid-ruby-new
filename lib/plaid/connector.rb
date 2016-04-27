require 'net/http'
require 'uri'
require 'multi_json'

module Plaid
  # Private: A class encapsulating HTTP requests to the Plaid API servers
  class Connector
    attr_reader :uri, :http, :request, :response, :body

    # Private: Prepare to run request.
    #
    # path - The String path without leading slash. E.g. 'connect'
    def initialize(path, id = nil)
      unless Plaid.env
        raise NotConfiguredError, "You must set Plaid.env before using any methods! Add a Plaid.config do .. end block somewhere in the initialization code of your program."
      end

      path = File.join(Plaid.env, path.to_s)
      path = File.join(path, id) if id

      @uri = URI.parse(path)

      @http = Net::HTTP.new(@uri.host, @uri.port)
      @http.use_ssl = true
    end

    # Private: Run GET request.
    #
    # Returns the parsed JSON body.
    def get
      run Net::HTTP::Get.new(@uri.path)
    end

    # Private: Check if MFA response received.
    #
    # Returns true if response has code 201.
    def mfa?
      @response.is_a?(Net::HTTPCreated)
    end

    private

    # Private: Run the request and process the response.
    #
    # Returns the parsed JSON body or raises an appropriate exception (a
    # descendant of Plaid::PlaidError).
    def run(request)
      @request = request
      @response = http.request(@request)

      # All responses are expected to have a JSON body, so we always parse,
      # not looking at the status code.
      @body = MultiJson.load(@response.body)

      case @response
      when Net::HTTPSuccess, Net::HTTPCreated
        @body
      when Net::HTTPBadRequest
        raise Plaid::BadRequestError.new(*error_arguments)
      when Net::HTTPUnauthorized
        raise Plaid::UnauthorizedError.new(*error_arguments)
      when Net::HTTPPaymentRequired
        raise Plaid::RequestFailedError.new(*error_arguments)
      when Net::HTTPNotFound
        raise Plaid::NotFoundError.new(*error_arguments)
      else
        raise Plaid::ServerError.new(*error_arguments)
      end
    end

    # Private: Provide arguments for Plaid::PlaidError constructor.
    #
    # Returns an Array with arguments.
    def error_arguments
      [body['code'], body['message'], body['resolve']]
    end
  end
end
