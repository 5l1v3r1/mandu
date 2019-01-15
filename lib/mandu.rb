# frozen_string_literal: true

require 'mandu/version'
require 'mandu/requirement'
require 'mandu/const'
require 'mandu/fuzzer/fuzz'

module Mandu
  def self.mitmproxy(port)
    ## MITM Proxy
    proxy = EvilProxy::HTTPProxyServer.new Port: port
    proxy
  end

  def self.send_request(url, method, data, headers)
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

  def self.send_request_raw(data)
    # TODO: ...
  end

  def self.fuzz
    Fuzz.instance
  end

  def self.parse_xml(source)
    data = ''
    begin # url pattern
      data = open(source)
    rescue StandardError # data pattern
      data = source
    end

    begin
      return Nokogiri::XML(data)
    rescue StandardError => e
      return false
    end
  end

  def self.parse_html(source)
    data = ''
    begin # url pattern
      data = open(source)
    rescue StandardError # data pattern
      data = source
    end

    begin
      return Nokogiri::HTML(data)
    rescue StandardError => e
      return false
    end
  end

  def self.parse_http_request(rawdata)
    req = WEBrick::HTTPRequest.new(WEBrick::Config::HTTP)
    req.parse(StringIO.new(rawdata))
    req
  end
end
