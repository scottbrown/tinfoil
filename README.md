# Tinfoil

Tinfoil is a command-line utility that scans a Web server externally to listen for its usage of HTTP secure headers.  This utility will scan for the following secure headers:

* [Strict-Transport-Security](http://tools.ietf.org/html/rfc6797)
* [X-XSS-Protection](http://blogs.msdn.com/b/ie/archive/2008/07/02/ie8-security-part-iv-the-xss-filter.aspx)
* [X-Content-Type-Options](http://blogs.msdn.com/b/ie/archive/2008/09/02/ie8-security-part-vi-beta-2-update.aspx)
* [X-Frame-Options](http://tools.ietf.org/html/draft-ietf-websec-x-frame-options-01)
* [Content-Security-Policy](http://www.w3.org/TR/CSP/)

Not all of these headers are required at all times, so you should use your best judgement when you see something is missing on your Web server.  Best of all, you can selectively ignore the headers that you do not yet support.

## Installation

Install it through RubyGems:

    $ gem install tinfoil

## Usage

Scan a single server

    $ tinfoil www.example.com

Specifying the protocol, ``http://`` or ``https://``, is not required.

You can selectively ignore the secure headers or protocols that you do not want.  For example, to ignore anything related to SSL or the Content-Security-Policy header:

    $ tinfoil --ignore-https --ignore-csp --ignore-sts www.example.com

To view the other options available, you can use the ``--help`` argument.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

See [LICENSE.txt](LICENSE.txt) for more information.

