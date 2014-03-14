require 'ostruct'
require 'net/http'

module Tinfoil
  class Scanner
    AVAILABLE_SECURE_HEADERS = %w{ Strict-Transport-Security X-XSS-Protection X-Content-Type-Options X-Frame-Options Content-Security-Policy }

    attr_accessor :options

    def initialize
      @options = OpenStruct.new
    end

    def scan (domain)
      server_result = {}

      [:http, :https].each do |protocol|
        unless @options.ignore_protocols.include?(protocol.to_s)
          server_result[protocol] = call_server("#{protocol}://" + domain) || []
        end
      end

      return server_result
    end

    private

    def call_server (url)
      headers = []
      verbose("Connecting to #{url}")
      response = Net::HTTP.get_response(URI(url))
      case response
      when Net::HTTPSuccess
        verbose("Status 200 OK.  Processing response headers...")

        AVAILABLE_SECURE_HEADERS.each do |type|
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
    rescue OpenSSL::SSL::SSLError
      verbose("SSL error found.  Skipping.")
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

    def generate_headers
      headers = []
      headers << SecureHeader.new('Strict-Transport-Security')
      headers << SecureHeader.new('X-XSS-Protection')
      headers << SecureHeader.new('X-Content-Type-Options')
      headers << SecureHeader.new('X-Frame-Options')
      headers << SecureHeader.new('Content-Security-Policy')
      return headers
    end

    def verbose (msg)
      puts "[SCANNER] #{msg}" if @options.verbose
    end
  end
end

