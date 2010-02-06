require "xmpp_manager"

manager = XmppManager.new("username@jabber_server", "password", :debug => true)

manager.add_callback(:exit) do |manager|
  manager.stop
end

manager.add_callback(:rhythmbox) do |manager, playlist|
  `rhythmbox-client`
end

manager.add_callback(:playlist) do |manager, playlist|
  `rhythmbox-client --no-start --play-uri="#{playlist}"`
end

manager.add_callback(:playpause) do |manager|
  `rhythmbox-client --no-start --play-pause`
end

manager.add_callback(:volumeup) do |manager|
  `rhythmbox-client --no-start --volume-up`
end

manager.add_callback(:volumedown) do |manager|
  `rhythmbox-client --no-start --volume-down`
end

manager.add_callback(:soma) do |manager, name|
  name = name.split("/").last if name.include?("somafm.com")
  manager.run_callback(:playlist, "http://somafm.com/#{name}.pls")
end

manager.start

