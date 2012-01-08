module SkypeMac
  class Call < SkypeMac::Base
    @_class = 'CALL'
    class << self
      # -> CALL target[, target]*
      # <- CALL id status
      def call(*targets)
        protocol_required 1
        Base::send_command "CALL #{Array(targets).join(',')}" do |result|
          case result
          when /^CALL (\d+) (.*)$/
            return Call.new($1)
          else
            raise SkypeException.new("CALL", result)
          end
        end
      end
      def _search(command)
        Base::send_command "SEARCH #{command}" do |result|
          case result
          when /^CALLS (.*)$/
            calls = $1
            return calls.split(', ').map {|x| Call.new x}
          end
        end
      end

      def search(target)
        _search "CALLS #{target}"
      end
      def active_calls
        _search "ACTIVECALLS"
      end
      def missed_calls
        _search "MISSEDCALLS"
      end

    end

    def initialize(id)
      @id = id
    end

    #{{{ - Properties
    property :partner_handle
    property :partner_dispname
    property :target_identity
    property :conf_id
    property :status
    property :video_status
    property :video_send_status
    property :video_receive_status
    property :pstn_number
    property :duration, :type=>:integer
    property :pstn_status
    property :conf_participants_count, :type=>:integer
    property :wm_duration, :type=>:integer
    property :wm_allowed_duration, :type=>:integer
    property :rate, :type=>:integer
    property :rate_currency
    property :rate_precision
    property :transfer_active?, :api_name=>:transfer_active, :type=>:boolean
    property :transfer_status
    property :timestamp, :type=>:timestamp
    property :failure_reason, :api_name=>:failurereason
    property :type, :immutable=>true

    def conf_participant(index)
      Base::send_command "GET CALL #{@id} CONF_PARTICIPANT #{index}" do |response|
        case response
        when /^CALL #{@id} CONF_PARTICIPANT #{index} (.+)$/
          return $1
        end
      end
    end

    #{{{ - Type helpers
    def pstn?
      type =~ /PSTN/
    end

    def p2p?
      !pstn
    end

    def incoming?
      type =~ /INCOMING/
    end

    def outgoing?
      !incoming
    end
    #}}}

    #{{{ - Status helpers
    %w(unplaced routing earlymedia failed ringing inprogress onhold finished
       missed refused busy cancelled transferring transferred
       wm_buffering_greeting wm_playing_greeting wm_recording wm_uploading wm_sent wm_cancelled wm_failed
       waiting_redial_command redial_pending).each do |status|
      class_eval <<-RUBY
        def #{status}?; status == '#{status.upcase}'; end
      RUBY
    end
    #}}}

    #}}}

    # -> SET CALL id STATUS status
    # <- CALL id STATUS status
    # status = INPROGRESS | FINISHED | ONHOLD
    def set_call_status(status)
    end

    # -> SET CALL join_id JOIN_CONFERENCE master_id
    def join_conference(join_id, master_id)
    end
  end
end
