module Plaid
  # Public: A class which encapsulates the authenticated user for all Plaid
  # products.
  class User
    # Public: Access token for authenticated user.
    attr_reader :access_token

    # Public: Create (add) a user.
    #
    # product     - The Symbol product name you are adding the user to, one of
    #               Plaid::PRODUCTS (e.g. :info, :connect, etc.).
    # institution - The String/Symbol financial institution code that you
    #               want to access (e.g. :wells).
    # username    - The String username associated with the financial institution.
    # password    - The String password associated with the financial institution.
    # pin         - The String PIN number associated with the financial institution
    #               (default: nil).
    # options     - the Hash options (default: {}):
    #               :list       - The Boolean flag which would request the
    #                             available send methods if the institution
    #                             requires code-based MFA credential (default:
    #                             false).
    #               :webhook    - The String webhook URL. Used with :connect,
    #                             :income, and :risk products (default: nil).
    #               :pending    - The Boolean flag requesting to return
    #                             pending transactions. Used with :connect
    #                             product (default: false).
    #               :login_only - The Boolean option valid for initial
    #                             authentication only. If set to false, the
    #                             initial request will return transaction data
    #                             based on the start_date and end_date.
    #               :start_date - The start Date from which to return
    #                             transactions (default: 30 days ago).
    #               :end_date   - The end Date to which transactions
    #                             will be collected (default: today).
    #
    # Returns a Plaid::User instance.
    def self.create(product, institution, username, password, pin = nil, options = {})
    end

    # Public: Get User instance in case user access token is known.
    #
    # token - the String access token for the user.
    def self.revive(token)
    end

    # Public: Find out if MFA is required based on last request.
    #
    # After calling e.g. User.create you might need to make an additional
    # authorization step if MFA is required by the financial institution.
    #
    # Returns true if this step is needed.
    def mfa_required?
    end

    # Public: Initiate MFA.
    #
    # send_method - The Hash which specifies which code delivery method to
    #               use.
    #
    # Examples
    #
    #   mfa_request({type: "phone"})
    #
    #   mfa_request({mask:"123-...-4321"})
    #
    # Returns true if code was sent.
    def mfa_request(send_method = {})
    end

    # Public: Submit MFA information.
    #
    # info - The String with MFA information.
    #
    # Returns true if whole MFA process is completed, false otherwise.
    def mfa(info)
    end

    # Public: Get transactions provided by initial call to User.create.
    #
    # If the :login_only option of User.create is set to false, the initial
    # 30-day transactional data are returned during the call. This method
    # returns them.
    #
    # Returns an Array of Transaction records (empty if not appropriate).
    def initial_transactions
    end

    # Public: Get transactions.
    #
    # Does a /connect/get call.
    #
    # pending    - the Boolean flag requesting to return pending transactions.
    # account_id - the String Account ID (default: nil). If this argument is
    #              present, only transactions for given account will be
    #              requested.
    # start_date - The start Date (inclusive).
    # end_date   - The end Date (inclusive).
    #
    # Returns an Array of Transaction records.
    def transactions(pending: false, account_id: nil, start_date: nil, end_date: nil)
    end

    # Public: Update user credentials.
    #
    # Updates the credentials for current product. Use User#for_product
    #
    # username    - The String username associated with the financial institution.
    # password    - The String password associated with the financial institution.
    # pin         - The String PIN number associated with the financial institution
    #               (default: nil).
    #
    # Returns self.
    def update(username, password, pin = nil)
    end

    # Public: Delete the user.
    #
    # Returns true if deletion went ok.
    def delete
    end

    # Public: Upgrade the user.
    #
    # For an existing user that has been added via any of products (:connect,
    # :auth, :income, :info, or :risk), you can upgrade that user to have
    # functionality with other products.
    #
    # Does a POST /upgrade request.
    #
    # See also User#for_product.
    #
    # product - The Symbol product name you are upgrading the user to, one of
    #           Plaid::PRODUCTS.
    #
    # Returns another User record with the same access token, but tied to the
    # new product.
    def upgrade(product)
    end

    # Public: Get the current user tied to another product.
    #
    # No API request is made, just the current product is changed.
    #
    # product - The Symbol product you are selecting, one of Plaid::PRODUCTS.
    #
    # See also User#upgrade.
    #
    # Returns a new User instance.
    def for_product(product)
    end

    # Public: Get auth information for the user.
    #
    # Does a POST /auth/get request.
    #
    # Returns ???
    def auth
    end

    # Public: Get info for the user.
    #
    # Does a POST /info/get request.
    #
    # Returns a Plaid::Info instance.
    def info
    end

    # Public: Get income data for the user.
    #
    # Does a POST /income/get request.
    #
    # Returns a Plaid::Income instance.
    def income
    end

    # Public: Get risk data for the user.
    #
    # Does a POST /risk/get request.
    #
    # Returns a Plaid::Risk instance.
    def risk
    end

    # Public: Get current account balance.
    #
    # Does a POST /balance request.
    #
    # Returns an Array of Plaid::Account.
    def balance
    end
  end
end
