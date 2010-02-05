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
    @callbacks[name] = callback
    self
  end
  
  def start
    @client = Client.new(JID::new(@username))
    @client.connect
    @client.auth(@password)
    @client.send(Presence.new.set_type(:available))
    @client.add_message_callback do |message|
      @callbacks.each do |name, callback|
        if message.body[0, name.length] == name
          params = message.body[(name.length + 1)..-1].split(/ +/).map { |param| param.strip }
          callback.call(self, *params)
        end
      end
      debug(message)
    end
    @client.start
  end
  
  def stop
    @client.stop
  end
  
private
  def debug(message)
    p message if @options[:debug]
  end
end
