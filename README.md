# Tinfoil

Tinfoil is a command-line utility that scans a Web server externally to listen for its usage of HTTP secure headers.  This utility will scan for the following secure headers:

* Strict-Transport-Security
* X-XSS-Protection
* X-Content-Type-Options
* X-Frame-Options
* Content-Security-Policy

Not all of these headers are required at all times, so you should use your best judgement when you see something is missing on your Web server.

You can scan a single server on the command line, or you can scan multiple servers using a configuration file.  In this configuration file you can also specify which secure headers you want to watch for or ignore.

## Installation

Install it through RubyGems:

    $ gem install tinfoil

## Usage

Scan a single server

    $ tinfoil -s www.example.com

Specifying the protocol, ``http://`` or ``https://``, is not required.

Scan multiple servers as specified in a configuration file.

    $ tinfoil -f servers.yaml

For other options, you can use the ``--help`` argument.

## Configuration File Format

The configuration file should be written in YAML format.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

See [LICENSE.txt](LICENSE.txt) for more information.

