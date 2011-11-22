require 'appscript'

module SkypeMac
  class Base

    class << self
      # Sends an API command to Skype using the Applescript client
      def send(options)
        options[:script_name] ||= 'skypemac-ruby'
        result = Appscript.app('Skype').send_ options
        if result =~ /^ERROR /
          raise SkypeException.new(result)
        end
        result
      end

      def protocol_required(protocol)
      end

      def send_command(command, command_id=nil, &block)
        id=''
        if command_id =~ /[a-zA-Z0-9]+/
          id = "##{command_id} "
        end
        result = SkypeMac::Base.send(:command=>"#{id}#{command}")
        if block
          yield result
        else
          result
        end
      end
    end

    def protocol(protocol_version=8)
      Base::send_command "PROTOCOL #{protocol_version}" do |result|
        if result =~ /^PROTOCOL (\d)$/
          @protocol = $1.to_i
          warn "Requested #{protocol_version} but received #{@protocol}" if @protocol != protocol_version
        end
      end
    end
  end
end

