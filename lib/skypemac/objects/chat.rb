module SkypeMac
  class Chat < SkypeMac::Base
    @_class = 'CHAT'
    class << self
      def recent_chats
        Base::send_command "SEARCH RECENTCHATS" do |result|
          case result
          when /^CHATS (.*)$/
            chats = $1
            return chats.split(', ').map {|x| Chat.new x}
          end
        end
      end
    end

    def initialize(id)
      @id = id
    end

    #{{{ - Properties
    property :name
    property :topic
    property :status
    property :topic_xml,      :api_name=>:topicxml
    property :bookmarked?,    :api_name=>:bookmarked, :type=>:boolean
    property :friendly_name,  :api_name=>:friendlyname
    property :timestamp,      :type=>:timestamp

    def adder
      adder = get_chat_property :adder
      User.new adder
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

    # protocol 7 additions
    property :password_hint, :api_name=>:passwordhint
    property :guidelines
    property :options
    property :description
    property :my_status, :api_name=>:mystatus
    property :my_role, :api_name=>:myrole
    property :blob
    property :activity_timestamp, :type=>:timestamp

    def member_objects
      #TODO
    end

    def dialog_partner
      #TODO
    end

    def applicants
      #TODO
    end

    #}}}
  end
end
