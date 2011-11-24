module SkypeMac
  class ChatMessage < SkypeMac::Base
    @_class = 'CHATMESSAGE'
    class << self
      def _search(command)
        Base::send_command "SEARCH #{command}" do |result|
          case result
          when /^CHATMESSAGES (.*)$/
            chatmessages = $1
            return chatmessages.split(', ').map {|x| ChatMessage.new x}
          end
        end
      end

      def search(user)
        _search "CHATMESSAGES #{user.to_s}"
      end
      def missed_chat_messages
        _search "MISSEDCHATMESSAGES"
      end
    end

    def initialize(id)
      @id = id
    end

    #{{{ - Properties
    property :seen?, :type=>:boolean
    property :body
    property :from_dispname
    property :status
    property :chat_name
    property :options
    property :role
    property :timestamp, :type=>:timestamp
    property :from_handle, :immutable=>true
    property :type, :immutable=>true
    property :leave_reason, :api_name=>:leavereason
    property :editable?, :type=>:boolean
    property :edited_timestamp, :type=>:timestamp

    def seen=
      #TODO
    end
    def body=
      #TODO
    end
    #}}}
  end
end

