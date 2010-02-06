require "rubygems"
require "xmpp4r/client"

class XmppManager
  include Jabber
  
  def initialize(username, password, options = {})
    @username = username
    @password = password
    @options = options
    @client = nil
    @callbacks = {}
  end

  def add_callback(name, &callback)
    name = name.to_s
    @callbacks[name] = callback
    self
  end
  
  def run_callback(name, *args)
    name = name.to_s
    @callbacks[name].call(*args) if @callbacks[name]
  end
  
  def start
    @client = Client.new(JID::new(@username))
    @client.connect
    @client.auth(@password)
    @client.send(Presence.new.set_type(:available))
    @client.add_message_callback do |message|
      if message.body
        @callbacks.each do |name, callback|
          if message.body[0, name.length] == name
            params = message.body[name.length..-1].strip.split(/ +/)
            callback.call(self, *params)
          end
        end
        debug(message.body)
      end
      debug(message)
    end
    @client.start
  end
  
  def stop
    @client.stop if @client
  end
  
private
  def debug(message)
    p message if @options[:debug]
  end
end
