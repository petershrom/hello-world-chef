require 'serverspec'
require 'net/http'

set :backend, :exec

class WebRequest
  def initialize(url: 'http://localhost/', with_headers: {})
    @uri = URI(url)
    @headers = with_headers
    @http = Net::HTTP.start(@uri.host, @uri.port, use_ssl: @uri.scheme == 'https', verify_mode: OpenSSL::SSL::VERIFY_NONE)
  end

  def get
    response.body
  end

  def response
    req = Net::HTTP::Get.new(@uri.path.empty? ? '/' : @uri.path, @headers)
    @http.request(req)
  end
end
