module SkypeMac
  class Skype < SkypeMac::Base
    def initialize(version=8)
      protocol(version)
    end
  end
end
