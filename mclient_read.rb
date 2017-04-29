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
token = nil

File.open("mclient.id","r"){|f|
  client_id = f.gets.chomp
  client_secret = f.gets.chomp
}
File.open("mclient.token","r"){|f|
  token = f.gets.chomp
}


uri = URI.parse("https://" + mastodon_server + "/api/v1/timelines/public");
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
req = Net::HTTP::Get.new(uri.path);
#req['Authorization'] = "Bearer " + token
req.set_form_data({'local' => '','bearer_token' => token})
res = http.request(req)

json = JSON.parse(res.body)

json.reverse.each{|s|
  puts s['content']
}
