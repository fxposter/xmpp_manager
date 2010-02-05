require "xmpp_manager"

manager = XmppManager.new("username@jabber_server", "password", :debug => true)

manager.add_callback("soma") do |manager, url|
  playlist = "http://somafm.com/#{url.split("/").last}.pls"
  `rhythmbox-client --no-start --play-uri="#{playlist}"`
end

manager.add_callback("play-pause") do |manager|
  `rhythmbox-client --no-start --play-pause"`
end

manager.add_callback("volume-up") do |manager|
  `rhythmbox-client --no-start --volume-up`
end

manager.add_callback("volume-down") do |manager|
  `rhythmbox-client --no-start --volume-down`
end

manager.add_callback("exit") do |manager|
  manager.stop
end

manager.start

