module SkypeMac
  class User < SkypeMac::Base
    class << self
    end

    def initialize(id)
      @id = id
    end

    #{{{ - Properties
    property :language
    property :country
    property :provice
    property :city
    property :phone_home
    property :phone_office
    property :phone_mobile
    property :homepage
    property :about
    property :skypeme
    property :speed_dial, :api_name=>:speeddial
    property :mood_text
    property :rich_mood_text
    property :display_name, :api_name=>:displayname
    property :handle, :immutable=>true
    property :full_name, :api_name=>:fullname
    property :birthday
    property :gender, :api_name=>:sex
    property :has_call_equipment?, :api_name=>:hascallequipment, :type=>:boolean
    property :video_capable?, :api_name=>:is_video_capable, :type=>:boolean
    property :voicemail_capable?, :api_name=>:is_voicemail_capable, :type=>:boolean
    property :buddy_status, :api_name=>:buddystatus
    property :authorized?, :api_name=>:isauthorized, :type=>:boolean
    property :blocked?, :api_name=>:isblocked, :type=>:boolean
    property :online_status, :api_name=>:onlinestatus
    property :last_online_timestamp, :api_name=>:lastonlinetimestamp, :type=>:timestamp
    property :can_leave_voicemail?, :api_name=>:can_leave_vm, :type=>:boolean
    property :received_auth_request, :api_name=>:receivedauthrequest
    property :call_forwarding_active?, :api_name=>:is_cf_active, :type=>:boolean
    property :authorized_buddy_count, :api_name=>:nrof_authed_buddies, :type=>:integer
    #}}}

  end
end

