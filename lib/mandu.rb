require 'mandu/version'
require 'mandu/requirement'
require 'mandu/const'

module Mandu
  def self.mitmproxy(port)
    ## MITM Proxy
    proxy = EvilProxy::HTTPProxyServer.new Port: port
    proxy
  end

  def send_request(url, method, data, headers)
    uri = URI(url)
    scheme = uri.scheme
    port = 80
    resp = nil

    port = case scheme
           when 'https'
             443
           when 'ftp'
             21
           else # if http..
             80
           end

    http = Net::HTTP.new(uri.host, port)
    http.use_ssl = true if scheme 'https'

    case method
    when 'post'
      resp = http.post(uri.path + '?' + uri.query, data, headers)
    when 'get'
      resp = http.get(uri.path + '?' + uri.query, headers)
    when 'put'
      resp = http.put(uri.path + '?' + uri.query, data, headers)
    when 'delete'
      resp = http.delete(uri.path + '?' + uri.query, headers)
    else
      # Not supported method
      return NOTSUPPORT
    end
    resp
  end

  def send_request_raw(data)
    # TODO: ...
  end
end
