require 'optparse'
require 'ostruct'

module Tinfoil
  class CLI
    def self.run (args)
      options = default_options
      parse(args, options)
    end

    class << self
      private

      def parse (args, options)
        optparse = OptionParser.new do |opts|
          opts.on('-h', '--help', 'Display this screen') do
            puts usage
            puts opts
            exit 1
          end

          opts.on('-f', '--file FILE', 'Perform a scan with the given configuration file') do |file|
            options.file = file
          end

          opts.on('-o', '--output [FILENAME]', 'Store output in a file.  Default: results.txt') do |output_file|
            options.output_file = output_file || "results.txt"
          end

          opts.on('-s', '--server SERVER', 'Scan a single server') do |server|
            options.server = server
          end

          opts.on('-t', '--timeout [SECONDS]', Integer, "Change the timeout value.  Default: #{options.timeout} seconds.") do |timeout|
            options.timeout = timeout
          end

          opts.on_tail('-v', '--verbose', 'Enable verbose output') do
            options.verbose = true
          end

          opts.on_tail('--version', 'Display the version') do
            puts Tinfoil::VERSION
          end
        end

        optparse.parse!
      end

      def default_options
        options = OpenStruct.new
        options.verbose = false
        options.timeout = 10 #seconds
        options.file = nil
        options.server = nil
        options.output_file = nil

        return options
      end

      def usage
        # something's weird.  I can't HEREDOC with an indent here
        string = <<HEREDOC
tinfoil (c) 2014 Scott Brown

Scans one or more Web servers for the presence of secure headers.  This helps in discovering servers vulnerable to Web-based attack vectors.

HEREDOC

        return string
      end
    end
  end
end

