module SkypeMac
  class Profile < SkypeMac::Base
    @_class = 'PROFILE'
    class << self
    end

    def initialize(id)
      @id = id
    end

    #{{{ - Properties
    property :pstn_balance
    property :pstn_balance_currency
    property :full_name, :api_name=>:fullname
    property :birthday
    property :gender, :api_name=>:sex
    property :languages
    property :country
    property :ip_country, :api_name=>:ipcountry
    property :province
    property :city
    property :phone_home
    property :phone_office
    property :phone_mobile
    property :homepage
    property :about
    property :mood_text
    property :rich_mood_text
    property :time_zone, :api_name=>:timezone
    property :call_apply_forwading, :api_name=>:call_apply_cf
    property :call_noanswer_timeout
    property :call_forward_rules
    property :call_send_to_voicemail, :api_name=>:call_send_to_vm
    property :sms_validated_numbers

    property_writer :mood_text
    property_writer :rich_mood_text
    #}}}

  end
end
