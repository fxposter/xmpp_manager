require "xmpp_manager"

manager = XmppManager.new("username@jabber_server", "password", :debug => true)
manager.add_callback("soma") do |manager, url|
  playlist = "http://somafm.com/#{url.split("/").last}.pls"
  p playlist
end

manager.add_callback("exit") do |manager|
  manager.stop
end

manager.start
