module SkypeMac
  class Call < SkypeMac::Base
    class << self
      # -> CALL target[, target]*
      # <- CALL id status
      def call(*target)
        protocol_required 1
        command :call, list(:target) do
          match /^CALL (\d+) (.*)$/ do
            return Call.new($1)
          end
        end
      end
    end

    def initialize(id)
      @id = id
    end

    #{{{ - Properties

    #{{{ - Simple properties
    %w(partner_handle partner_dispname target_identity conf_id status
       video_status video_send_status video_receive_status
       pstn_number duration pstn_status conf_participants_count
       wm_duration wm_alloved_duration rate rate_currency rate_precision
       input output capture_mic vaa_input_status
       transfer_active transfer_status).each do |command|
      class_eval <<-RUBY
        def #{command}; get_call_property :#{command}; end
      RUBY
    end
    #}}}

    def timestamp
      timestamp = get_call_property :timestamp
      Time.at timestamp
    end

    def conf_participant(index)
      Base::send_command "GET CALL #{@id} CONF_PARTICIPANT #{index}" do |response|
        case response
        when /^CALL #{@id} CONF_PARTICIPANT #{index} (.+)$/
          return $1
        end
      end
    end

    def failure_reason
      get_call_property :failurereason
    end

    def type
      @type ||= get_call_property :type
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

    # -> GET CALL id property
    # <- CALL id property value
    def get_call_property(property)
      prop = property.to_s.upcase
      Base::send_command "GET CALL #{@id} #{prop}" do |response|
        case response
        when /^CALL #{@id} #{prop} (.*)$/
          return $1
        end
      end
    end

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
