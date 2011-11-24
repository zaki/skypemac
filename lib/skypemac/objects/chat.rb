require 'skypemac/objects/user'
require 'skypemac/objects/chat_message'
require 'skypemac/objects/chat_member'


module SkypeMac
  class Chat < SkypeMac::Base
    @_class = 'CHAT'
    class << self
      def _search(command)
        Base::send_command "SEARCH #{command}" do |result|
          case result
          when /^CHATS (.*)$/
            chats = $1
            return chats.split(', ').map {|x| Chat.new x}
          end
        end
      end
      def recent_chats
        _search "RECENTCHATS"
      end
      def active_chats
        _search "ACTIVECHATS"
      end
      def missed_chats
        _search "MISSEDCHATS"
      end
      def bookmarked_chats
        _search "BOOKMARKEDCHATS"
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
    property :adder, :type=>:collection, :collection=>SkypeMac::User
    property :posters, :type=>:collection, :collection=>SkypeMac::User
    property :members, :type=>:collection, :collection=>SkypeMac::User
    property :active_members, :api_name=>:activemembers, :type=>:collection, :collection=>SkypeMac::User
    property :chat_messages,  :api_name=>:chatmessages,  :type=>:collection, :collection=>SkypeMac::ChatMessage
    property :recent_chat_messages,  :api_name=>:recentchatmessages,  :type=>:collection, :collection=>SkypeMac::ChatMessage

    # protocol 7 additions
    property :password_hint, :api_name=>:passwordhint
    property :guidelines
    property :options
    property :description
    property :my_status, :api_name=>:mystatus
    property :my_role, :api_name=>:myrole
    property :blob
    property :activity_timestamp, :type=>:timestamp

    # ALTER commands
    alter :topic
    alter :topic_xml, :api_name=>:settopicxml
    alter :leave!
    alter :bookmark!
    alter :unbookmark!
    alter :join!
    alter :clear_recent_messages!, :api_name=>:clearrecentmessages
    alter :alert_string, :api_name=>:alertstring
    alter :accept_add!, :api_name=>:acceptadd
    alter :disband!

    alter :password
    alter :enter_password, :api_name=>:enterpassword
    alter :options
    alter :kick
    alter :kickban

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
