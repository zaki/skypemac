module SkypeMac
  class Chat < SkypeMac::Base
    class << self
    end

    def initialize(id)
      @id = id
    end

    #{{{ - Properties

    def name; get_chat_property :name; end
    def status; get_chat_property :status; end
    def topic; get_chat_property :topic; end
    def topic_xml; get_chat_property :topicxml; end
    def bookmarked?; get_chat_property :bookmarked; end
    def friendly_name; get_chat_property :friendlyname; end

    def adder
      adder = get_chat_property :adder
#      User.new adder
    end

    def timestamp
      timestamp = get_chat_property :timestamp
      Time.at timestamp
    end

    def posters
      posters_str = get_chat_property :posters
      posters = posters_str.split(/ /).map {|x| User.new(x)}
    end
    def members
      members_str = get_chat_property :members
      members = members_str.split(/ /).map {|x| User.new(x)}
    end
    def active_members
      members_str = get_chat_property :activemembers
      members = members_str.split(/ /).map {|x| User.new(x)}
    end
    def chat_messages
      chat_messages_str = get_chat_property :chatmessages
      chat_messages = chat_messages_str.split(/, /).map {|x| Chatmessage.new(x)}
    end
    def recent_chat_messages
      chat_messages_str = get_chat_property :recentchatmessages
      chat_messages = chat_messages_str.split(/, /).map {|x| Chatmessage.new(x)}
    end
    #}}}
    # -> GET CALL id property
    # <- CALL id property value
    def get_chat_property(property)
      prop = property.to_s.upcase
      Base::send_command "GET CHAT #{@id} #{prop}" do |response|
        case response
        when /^CHAT #{@id} #{prop} (.*)$/
          return $1
        end
      end
    end
    #
  end
end
