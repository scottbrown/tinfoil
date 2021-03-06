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

## Example

The following examples test the secure header support for the main [Github.com](http://github.com) website.

This checks both SSL and non-SSL versions of github.com.  The tool shows that nothing is present on the non-SSL version (because it redirects) and then shows which headers are present on the SSL version.

```bash
$ bin/tinfoil github.com
protocol: http
protocol: https
headers:
    Strict-Transport-Security: exists
    X-XSS-Protection: exists
    X-Content-Type-Options: exists
    X-Frame-Options: exists
    Content-Security-Policy: exists
```

Since we only care about the SSL version of github.com, we tell tinfoil to ignore the non-SSL version.

```bash
$ bin/tinfoil --ignore-http github.com
protocol: https
headers:
    Strict-Transport-Security: exists
    X-XSS-Protection: exists
    X-Content-Type-Options: exists
    X-Frame-Options: exists
    Content-Security-Policy: exists
```

And, for kicks, we now tell tinfoil to ignore the Content-Security-Policy header for no good reason.

```bash
$ bin/tinfoil --ignore-http --ignore-csp github.com
protocol: https
headers:
    Strict-Transport-Security: exists
    X-XSS-Protection: exists
    X-Content-Type-Options: exists
    X-Frame-Options: exists
    Content-Security-Policy: ignored
```

## Contributing

1. Fork it
1. Create your feature branch (`git checkout -b my-new-feature`)
1. Commit your changes (`git commit -am 'Add some feature'`)
1. Push to the branch (`git push origin my-new-feature`)
1. Create new Pull Request

## License

See [LICENSE.txt](LICENSE.txt) for more information.

