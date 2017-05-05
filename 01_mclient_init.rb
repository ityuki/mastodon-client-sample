#!/usr/local/env ruby
# coding: utf-8

http_proxy = nil

client_name = "mclient"

# use HTTPS
mastodon_server = "mstdn-workers.com"

ENV["SSL_CERT_FILE"] = "cacert.pem"

require 'net/https'
require 'uri'
require 'json'

uri = URI.parse("https://" + mastodon_server + "/api/v1/apps");
proxy_uri = { "addr" => nil, "port" => nil, "user" => nil, "pass" => nil }
if (http_proxy != nil)
  puri = URI.parse(http_proxy)
  proxy_uri['addr'] = puri.host
  proxy_uri['port'] = puri.port
  proxy_uri['user'] = puri.user
  proxy_uri['pass'] = puri.password
end
http = Net::HTTP.new(uri.host, uri.port,proxy_uri['addr'],proxy_uri['port'],proxy_uri['user'],proxy_uri['pass'])
http.use_ssl = true
req = Net::HTTP::Post.new(uri.path)
req.set_form_data({'client_name' => client_name, 'redirect_uris' => 'urn:ietf:wg:oauth:2.0:oob', 'scopes' => 'read write'})
res = http.request(req)

json = JSON.parse(res.body)

File.open("mclient.id","w"){ |f|
  f.puts json['client_id']
  f.puts json['client_secret']
}


