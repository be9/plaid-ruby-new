module Plaid

  # Public: Exception to throw when there are configuration problems
  class NotConfiguredError < StandardError; end

  # Private: Base class for Plaid errors
  class PlaidError < StandardError
    attr_reader :code, :resolve

    # Private: Initialize a error with proper attributes.
    #
    # code    - The Integer code (e.g. 1501).
    # message - The String message, describing the error.
    # resolve - The String description how to fix the error.
    def initialize(code, message, resolve)
      @code, @resolve = code, resolve

      super "Code #{@code}: #{message}. #{resolve}"
    end
  end

  class BadRequestError    < PlaidError; end
  class UnauthorizedError  < PlaidError; end
  class RequestFailedError < PlaidError; end
  class NotFoundError      < PlaidError; end
  class ServerError        < PlaidError; end
end
