require 'ostruct'
require 'net/http'
require 'timeout'

module Tinfoil
  class Scanner
    def scan (domain, options = OpenStruct.new)
      @options = options
      server_result = {}

      [:http, :https].each do |protocol|
        unless options.ignore_protocols.include?(protocol.to_s)
          server_result[protocol] = call_server("#{protocol}://" + domain) || []
        end
      end

      return server_result
    end

    private

    def call_server (url)
      headers = []
      verbose("Connecting to #{url}")
      response = nil
      begin
        Timeout::timeout (@options.timeout) do
          response = Net::HTTP.get_response(URI(url))
        end
      rescue OpenSSL::SSL::SSLError
        verbose("SSL error found.  Skipping.")
      rescue Timeout::Error
        return []
      end

      case response
      when Net::HTTPSuccess
        verbose("Status 200 OK.  Processing response headers...")

        [ SecureHeader::Type::STS, SecureHeader::Type::XSS, SecureHeader::Type::CTO, SecureHeader::Type::FO, SecureHeader::Type::CSP ].each do |type|
          header = SecureHeader.new(type)
          if @options.ignore_headers.include?(type)
            verbose("#{type} header ignored.")
            header.ignore = true
          else
            if response[type]
              verbose("#{type} header found.")
              header.exists = true
            end
          end
          headers << header
        end
      when Net::HTTPRedirection
        verbose("HTTP redirection found.  Skipping.")
      else
        verbose("Unknown error occurred.")
      end

      return headers
    end

    def process_file
      raise NoSuchFileError if File.exists?(@options.file)
      raise InvalidFileAccessError if File.readable?(@options.file)
    end

    def process_server
      response = Net::HTTP.get_response(URI(@options.server))

      case response
      when Net::HTTPSuccess
        if response['x-frame-options']
          x_frame_options = true
        end
        if response['x-content-type-options']
          x_content_type_options = true
        end
        if response['x-xss-protection']
          x_xss_protection = true
        end
        if response['strict-transport-security']
          strict_transport_security = true
        end
        if response['content-security-policy']
          content_security_policy = true
        end
      when Net::HTTPRedirection
      else
      end
    end

    def verbose (msg)
      puts "[SCANNER] #{msg}" if @options.verbose
    end
  end
end

