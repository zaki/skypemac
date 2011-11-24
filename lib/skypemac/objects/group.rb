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
            return users.split(', ').map {|x| Group.new x}
          end
        end
      end

      def create(name)
        Base::send_command "CREATE GROUP #{name}" do |result|
          case result
          when /^CREATE GROUP (.*)$/
            Group.new $1
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

    def delete
      Base::send_command "DELETE GROUP #{@id}"
    end

    #{{{ - Properties
    property :type
    property :custom_group_id, :immutable=>true
    property :display_name,:api_name=>:displayname
    property :user_count, :api_name=>:nrofusers
    property :online_user_count, :api_name=>:nrofusers_online
    property :users, :type=>:collection, :collection=>SkypeMac::User

    property :expanded, :type=>:boolean
    property_writer :display_name, :api_name=>:displayname

    alter :add_user, :api_name=>:adduser
    alter :remove_user, :api_name=>:removeuser

    alter :share!
    alter :accept!
    alter :decline!
    #}}}

  end
end
