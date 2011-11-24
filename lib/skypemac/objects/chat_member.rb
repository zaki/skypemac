module SkypeMac
  class ChatMember < SkypeMac::Base
    @_class = 'CHATMEMBER'
    class << self
    end

    def initialize(id)
      @id = id
    end

    #{{{ - Properties
    property :chat_name, :api_name=>:chatname
    property :identity
    property :role
    property :active?, :api_name=>:is_active, :type=>:boolean

    alter :role, :api_name=>:setroleto
    alter :can_set_role, :api_name=>:cansetroleto
    #}}}
  end
end
