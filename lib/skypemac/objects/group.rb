require 'skypemac/objects/user'

module SkypeMac
  class Group < SkypeMac::Base
    @_class = 'GROUP'
    class << self
      def _search(command)
        Base::send_command "SEARCH #{command}" do |result|
          case result
          when /^GROUPS (.*)$/
            users = $1
            return users.split(', ').map {|x| User.new x}
          end
        end
      end

      # [{ALL|CUSTOM|HARDWIRED}]
      def search(type='')
        _search "GROUPS #{type.to_s.upcase}"
      end
    end

    def initialize(id)
      @id = id
    end

    #{{{ - Properties
    property :type
    property :custom_group_id, :immutable=>true
    property :display_name
    property :user_count, :api_name=>:nrofusers
    property :online_user_count, :api_name=>:nrofusers_online
    property :users, :type=>:collection, :collection=>SkypeMac::User
    #}}}

  end
end
