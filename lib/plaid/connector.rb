require 'net/http'
require 'uri'
require 'multi_json'

module Plaid
  # Internal: A class encapsulating HTTP requests to the Plaid API servers
  class Connector
    attr_reader :uri, :http, :request, :response, :body

    # Internal: Default read timeout for HTTP calls.
    DEFAULT_TIMEOUT = 120

    # Internal: Prepare to run request.
    #
    # path    - The String path without leading slash. E.g. 'connect'
    # subpath - The String subpath. E.g. 'get'
    # auth - The Boolean flag indicating that client_id and secret should be
    #        included into the request payload.
    def initialize(path, subpath = nil, auth: false)
      @auth = auth
      verify_configuration

      path = File.join(Plaid.env, path.to_s)
      path = File.join(path, subpath.to_s) if subpath

      @uri = URI.parse(path)

      @http = Net::HTTP.new(@uri.host, @uri.port)
      @http.use_ssl = true

      @http.read_timeout = Plaid.read_timeout || DEFAULT_TIMEOUT
    end

    # Internal: Run GET request.
    #
    # Returns the parsed JSON response body.
    def get
      run Net::HTTP::Get.new(@uri.path)
    end

    # Internal: Run POST request.
    #
    # Adds client_id and secret to the payload if @auth is true.
    #
    # payload - The Hash with data.
    #
    # Returns the parsed JSON response body.
    def post(payload)
      post_like payload, Net::HTTP::Post.new(@uri.path)
    end

    # Internal: Run PATCH request.
    #
    # Adds client_id and secret to the payload if @auth is true.
    #
    # payload - The Hash with data.
    #
    # Returns the parsed JSON response body.
    def patch(payload)
      post_like payload, Net::HTTP::Patch.new(@uri.path)
    end

    # Internal: Run DELETE request.
    #
    # Adds client_id and secret to the payload if @auth is true.
    #
    # payload - The Hash with data.
    #
    # Returns the parsed JSON response body.
    def delete(payload)
      post_like payload, Net::HTTP::Delete.new(@uri.path)
    end

    # Internal: Check if MFA response received.
    #
    # Returns true if response has code 201.
    def mfa?
      @response.is_a?(Net::HTTPCreated)
    end

    private

    # Internal: Run the request and process the response.
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
      else
        raise_error
      end
    end

    # Internal: Run POST-like request.
    #
    # payload - The Hash with posted data.
    # request - The Net::HTTPGenericRequest descendant instance.
    def post_like(payload, request)
      if @auth
        payload = payload.merge(client_id: Plaid.client_id,
                                secret: Plaid.secret)
      end

      request.set_form_data(payload)

      run request
    end

    # Internal: Raise an error with the class depending on @response.
    #
    # Returns an Array with arguments.
    def raise_error
      klass = case @response
              when Net::HTTPBadRequest then Plaid::BadRequestError
              when Net::HTTPUnauthorized then Plaid::UnauthorizedError
              when Net::HTTPPaymentRequired then Plaid::RequestFailedError
              when Net::HTTPNotFound then Plaid::NotFoundError
              else
                Plaid::ServerError
              end

      raise klass.new(body['code'], body['message'], body['resolve'])
    end

    # Internal: Verify that Plaid environment is properly configured.
    #
    # Raises NotConfiguredError if anything is wrong.
    def verify_configuration
      raise_not_configured(:env, auth: false) unless Plaid.env
      return unless @auth

      cid = Plaid.client_id
      sec = Plaid.secret

      (!cid.is_a?(String) || cid.empty?) && raise_not_configured(:client_id)
      (!sec.is_a?(String) || sec.empty?) && raise_not_configured(:secret)
    end

    # Internal: Raise a NotConfiguredError exception with proper message.
    def raise_not_configured(field_name, auth: true)
      message = "You must set Plaid.#{field_name} before using any methods"
      message << ' which require authentication' if auth
      message << "! It's current value is #{Plaid.send(field_name).inspect}. " \
                 'Add a Plaid.config do .. end block somewhere in the ' \
                 'initialization code of your program.'

      raise NotConfiguredError, message
    end
  end
end
