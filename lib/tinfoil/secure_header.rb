module Tinfoil
  class SecureHeader
    class Type
      STS = 'Strict-Transport-Security'
      CSP = 'Content-Security-Policy'
      XSS = 'X-XSS-Protection'
      FO = 'X-Frame-Options'
      CTO = 'X-Content-Type-Options'
    end

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

