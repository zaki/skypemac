module SkypeMac
  class Group < SkypeMac::Base
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

    def users
      #TODO
    end
    #}}}

  end
end
