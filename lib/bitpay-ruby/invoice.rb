module BitPayRuby
  class Invoice
    class << self
      def fetch id
        self.new(nil, nil).fetch id
      end
    end

    attr_reader :id,
      :url,
      :posData,
      :notificationURL,
      :transactionSpeed,
      :fullNotifications,
      :notificationEmail,
      :redirectURL,
      :orderID,
      :itemDesc,
      :itemCode,
      :physical,
      :status,
      :price,
      :currency,
      :btcPrice,
      :invoiceTime,
      :expirationTime,
      :currentTime

    def initialize price, currency, options = {}
      @price = price
      @currency = currency
      @options = options
    end

    def create
      response = BitPayRuby::connection.post "/api/invoice", {
        "price" => price,
        "currency" => currency
      }.merge(@options)
      update! response.body
      self
    end

    def fetch id = @id
      response = BitPayRuby::connection.get "/api/invoice/#{id}"
      update! response.body
      self
    end

    def to_s
      {
        id: @id,
        url: @url,
        posData: @posData,
        status: @status,
        price: @price,
        currency: @currency,
        btcPrice: @btcPrice,
        invoiceTime: @invoiceTime,
        expirationTime: @expirationTime,
        currentTime: @currentTime,
      }.to_json
    end

    protected

    def update! json
      h = JSON.parse json
      @id ||= h["id"]
      @url ||= h["url"]
      @posData ||= h["posData"]
      @status ||= h["status"]
      @price ||= h["price"]
      @currency ||= h["currency"]
      @btcPrice ||= h["btcPrice"]
      @invoiceTime ||= h["invoiceTime"]
      @expirationTime ||= h["expirationTime"]
      @currentTime ||= h["currentTime"]
      self
    end
  end
end
