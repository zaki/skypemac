module SkypeMac
  class Skype < SkypeMac::Base
    class << self
      def skype_version
        Base::send_command "GET SKYPEVERSION" do |result|
          if result =~ /^SKYPEVERSION (.*)$/
            $1
          end
        end
      end
    end
    def connection_status
      Base::send_command "GET CONNSTATUS" do |result|
        if result =~ /^CONNSTATUS (.*)$/
          $1
        end
      end
    end
    def initialize(version=8)
      protocol(version)
    end
  end
end
