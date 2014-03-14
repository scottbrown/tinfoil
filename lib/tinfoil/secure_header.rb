module Tinfoil
  class SecureHeader
    attr_accessor :name, :ignore, :exists

    def initialize (name)
      @name = name
      @ignore = false
      @exists = false
    end

    def status
      if @ignore
        "ignored"
      else
        if @exists
          "exists"
        else
          "missing"
        end
      end
    end

    def to_s
      "#{@name}: #{status}"
    end
  end
end

