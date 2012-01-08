require 'appscript'

module SkypeMac
  class SkypeException < ArgumentError
    def initialize(command, error)
      @command = command
      @error = error
    end

    def to_s
      "COMMAND '#{@command}' failed:\n#{@error}"
    end
  end

  class Base
    @_class = 'BASE'
    @id = nil
    class << self
      # Sends an API command to Skype using the Applescript client
      def send(options)
        options[:script_name] ||= 'skypemac-ruby'
        result = Appscript.app('Skype').send_ options
        if result =~ /^ERROR /
          raise SkypeException.new(options[:command], result)
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

      def property(property_name, options={})
        api_name = options[:api_name] || property_name.to_s.gsub(/[?!]$/, '')
        api_name = api_name.to_s.upcase
        property_type = options[:type] || :string
        immutable = options[:immutable] || false
        collection_class = options[:collection] || Class

        class_eval <<-RUBY
          def #{property_name.to_s}
            #{immutable ? "@#{property_name.to_s}||" : '_property'}= Base::send_command "GET #{@_class} \#{@id} #{api_name}" do |result|
              case result
              when /^#{@_class} (.+) #{api_name} (.*)$/
                $2
              end
            end
            Base::property_convert(_property, :#{property_type}, #{collection_class}) unless _property.nil?
          end
        RUBY
      end

      def property_writer(property_name, options={})
        api_name = options[:api_name] || property_name.to_s.gsub(/[?!]$/, '')
        api_name = api_name.to_s.upcase

        class_eval <<-RUBY
          def #{property_name.to_s}=(value)
            Base::send_command "SET #{@_class} \#{@id} #{api_name} \#{value}" do |result|
              case result
              when /^#{@_class} (.+) #{api_name} (.*)$/
                $2
              end
            end
          end
        RUBY
      end

      def alter(property_name, options={})
        api_name = options[:api_name] || (property_name.to_s =~ /!$/ ? '' : 'SET')+property_name.to_s.gsub(/[?!]$/, '')
        api_name = api_name.to_s.upcase
        signature = property_name.to_s =~ /!$/ ? "#{property_name}(*value)" : "#{property_name.to_s}=(*value)"

        class_eval <<-RUBY
          def #{signature}
            Base::send_command "ALTER #{@_class} \#{@id} #{api_name} \#{Array(value).join(', ')}" do |result|
              case result
              when /^#{@_class} (.+) (#{api_name} )?(.*)$/
                $3
              end
            end
          end
        RUBY
      end

      def property_convert(property, type, collection_class)
        return if property.nil?
        case type
        when :string
          property.to_s
        when :integer
          property.to_i
        when :timestamp
          Time.at(property.to_i)
        when :boolean
          !!(property =~ /true/i)
        when :collection
          property.to_s.split(/, /).map {|x| collection_class.new(x) }
        else
          property
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

