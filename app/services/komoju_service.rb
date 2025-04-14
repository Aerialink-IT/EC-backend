class KomojuService
  require 'net/http'
  require 'uri'
  require 'json'

  def self.create_session(amount, email, return_url, cancel_url, metadata = {}, payment_data = {})
    uri = URI(ENV['KOMOJU_API_URL'])
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri)
    request["Content-Type"] = "application/json"
    request.basic_auth(ENV['KOMOJU_SECRET_KEY'], "")

    request.body = {
      amount: amount,
      currency: "JPY",
      return_url: return_url || "#{ENV['BASE_URL']}/webhooks/komoju",
      cancel_url: cancel_url,
      email: email,
      payment_data: payment_data,
      metadata: metadata
    }.to_json

    http.request(request)
  end

  def self.check_payment_status(session_id)
    uri = URI("#{ENV['KOMOJU_API_URL']}/#{session_id}")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(uri)
    request.basic_auth(ENV['KOMOJU_SECRET_KEY'], "")

    response = http.request(request)
    JSON.parse(response.body)
  end
end
