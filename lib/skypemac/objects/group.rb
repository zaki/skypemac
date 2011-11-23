require 'skypemac/objects/user'

module SkypeMac
  class Group < SkypeMac::Base
    @_class = 'GROUP'
    class << self
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
