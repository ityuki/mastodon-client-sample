#!/usr/local/env ruby
# coding: utf-8

http_proxy = nil

# use HTTPS
mastodon_server = "mstdn-workers.com"

require 'net/https'
require 'uri'
require 'json'


client_id = nil
client_secret = nil
code = nil

File.open("mclient.id","r"){|f|
  client_id = f.gets.chomp
  client_secret = f.gets.chomp
}
File.open("mclient.code","r"){|f|
  code = f.gets.chomp
}

uri = URI.parse("https://" + mastodon_server + "/oauth/token");
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
http.verify_mode = OpenSSL::SSL::VERIFY_NONE # :P
req = Net::HTTP::Post.new(uri.path)
req.set_form_data({'grant_type' => 'authorization_code', 'redirect_uri' => 'urn:ietf:wg:oauth:2.0:oob', 'client_id' => client_id, 'client_secret' => client_secret, 'code' => code})
res = http.request(req)

json = JSON.parse(res.body)
\
File.open("mclient.token","w"){|f|
  f.puts json['access_token']
}
