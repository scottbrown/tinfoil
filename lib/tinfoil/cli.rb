require 'optparse'
require 'ostruct'

module Tinfoil
  class CLI
    DEFAULT_OUTPUT_FILE = 'results.txt'

    def self.run (args, stdout=$stdout, stderr=$stderr)
      @@options = default_options
      parse(args, @@options)

      if @@server.nil?
        $stderr.puts banner
        raise AbnormalProgramExitError
      end

      scanner = Tinfoil::Scanner.new
      result = scanner.scan(@@server, @@options)

      result.each_pair do |protocol, headers|
        $stdout.puts "protocol: #{protocol}"

        $stdout.puts "headers:"
        headers.each do |header|
          $stdout.puts "\t#{header}"
        end
      end
    end

    class << self
      private

      def parse (args, options)
        optparse = OptionParser.new do |opts|
          opts.on('-h', '--help', 'Display this screen') do
            $stdout.puts summary
            $stdout.puts opts
            raise AbnormalProgramExitError
          end

          opts.on('--ignore-http', 'Ignores the http protocol') do
            verbose("Ignoring HTTP")
            options.ignore_protocols << 'http'
          end

          opts.on('--ignore-https', 'Ignores the https protocol') do
            verbose("Ignoring HTTPS")
            options.ignore_protocols << 'https'
          end

          opts.on('--ignore-sts', 'Ignores the existence check for the Strict-Transport-Security header') do
            verbose("Ignoring Strict-Transport-Security header")
            options.ignore_headers << 'Strict-Transport-Security'
          end

          opts.on('--ignore-fo', 'Ignores the existence check for the X-Frame-Options header') do
            verbose("Ignoring X-Frame-Options header")
            options.ignore_headers << 'X-Frame-Options'
          end

          opts.on('--ignore-csp', 'Ignores the existence check for the Content-Security-Policy header') do
            verbose("Ignoring Content-Security-Policy header")
            options.ignore_headers << 'Content-Security-Policy'
          end

          opts.on('--ignore-xss', 'Ignores the existence check for the X-XSS-Protection header') do
            verbose("Ignoring X-XSS-Protection header")
            options.ignore_headers << 'X-XSS-Protection'
          end

          opts.on('--ignore-cto', 'Ignores the existence check for the X-Content-Type-Options header') do
            verbose("Ignoring X-Content-Type-Options header")
            options.ignore_headers << 'X-Content-Type-Options'
          end

          opts.on('-t', '--timeout [SECONDS]', Integer, "Change the timeout value.  Default: #{options.timeout} seconds.") do |timeout|
            verbose("Timeout set to #{timeout} seconds")
            options.timeout = timeout
          end

          opts.on_tail('-v', '--verbose', 'Enable verbose output') do
            options.verbose = true
          end

          opts.on_tail('--version', 'Display the version') do
            $stdout.puts Tinfoil::VERSION
          end

          opts.banner = banner
        end

        optparse.parse!(args)

        @@server = args.first
      end

      def default_options
        options = OpenStruct.new
        options.verbose = false
        options.timeout = 10 #seconds
        options.ignore_headers = []
        options.ignore_protocols = []

        return options
      end

      def verbose (msg)
        $stdout.puts "[CLI] #{msg}" if @@options.verbose
      end

      def banner
        "Usage: tinfoil [options] DOMAIN"
      end

      def summary 
        string = "tinfoil #{Tinfoil::VERSION} (c) 2014 Scott Brown\n\n"
        string << "Scans one or more Web servers for the presence of secure headers.  This helps in discovering servers vulnerable to Web-based attack vectors.\n\n"

        return string
      end
    end
  end
end

