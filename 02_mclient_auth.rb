#!/usr/local/env ruby
# coding: utf-8

# use HTTPS
mastodon_server = "mstdn-workers.com"

require "cgi"
require 'rbconfig'

def os
  @os ||= (
    host_os = RbConfig::CONFIG['host_os']
    case host_os
    when /mswin|msys|mingw|cygwin|bccwin|wince|emc/
      :windows
    when /darwin|mac os/
      :macosx
    when /linux/
      :linux
    when /solaris|bsd/
      :unix
    else
      :unknown
    end
  )
end


client_id = nil

File.open("mclient.id","r"){|f|
  client_id = f.gets.chomp
}

url = "https://" + mastodon_server + "/oauth/authorize?client_id=" + CGI.escape(client_id) + "&response_type=code&scope=" + CGI.escape("read write") + "&redirect_uri=" + CGI.escape("urn:ietf:wg:oauth:2.0:oob");

puts "open browser " + url

if (os == :windows)
  system 'start "" "' + url + '"'
end

puts "input auth code:"
code = gets

File.open("mclient.code","w"){ |f|
  f.puts code
}



