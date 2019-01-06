require "mandu/version"
require "mandu/requirement"
require "mandu/const"

module Mandu
  def Mandu.MITMProxyOn(port)
    ## MITM Proxy
    proxy = EvilProxy::HTTPProxyServer.new Port: port
    return proxy
  end

  def sendRequest(url,method,data,headers)
    uri = URI(url)
    scheme = uri.scheme
    port = 80
    resp = nil

    case scheme
    when 'https'
      port = 443
    when 'ftp'
      port = 21
    else # if http..
      port = 80
    end

    http = Net::HTTP.new(uri.host, port)
    if scheme 'https'
      http.use_ssl = true
    end

    case method
    when 'post'
      resp = http.post(uri.path+'?'+uri.query,data,headers)
    when 'get'
      resp = http.get(uri.path+'?'+uri.query, headers)
    when 'put'
      resp = http.put(uri.path+'?'+uri.query, data, headers)
    when 'delete'
      resp = http.delete(uri.path+'?'+uri.query, headers)
    else
      # Not supported method
      return NOTSUPPORT
    end
    return resp
  end

  def sendRawRequest(data)
    # TODO ...
  end
end
