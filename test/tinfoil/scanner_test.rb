require 'test/unit'
require 'mocha/test_unit'
require 'ostruct'
require_relative '../../lib/tinfoil'

module Tinfoil
  class ScannerTest < Test::Unit::TestCase
    def setup
      @scanner = Tinfoil::Scanner.new

      @options = OpenStruct.new
      @options.verbose = false
      @options.timeout = 10
      @options.ignore_headers = []
      @options.ignore_protocols = []
    end

    def teardown
      @scanner = nil
    end

    def test_scan_returns_correct_result_for_one_server
      mock_remote_call do |result|
        assert_equal 2, result.size
        assert result.has_key?(:http)
        assert result.has_key?(:https)
      end
    end

    def test_scan_ignores_http_when_ordered
      @options.ignore_protocols << "http"
      mock_remote_call do |result|
        assert_equal 1, result.size
        assert !result.has_key?(:http)
        assert result.has_key?(:https)
      end
    end

    def test_scan_ignores_https_when_ordered
      @options.ignore_protocols << 'https'
      mock_remote_call do |result|
        assert_equal 1, result.size
        assert result.has_key?(:http), 'http should be present'
        assert !result.has_key?(:https), 'https should not be present'
      end
    end

    def test_scan_returns_empty_array_after_timeout
      Net::HTTP.stubs(:get_response).raises(Timeout::Error)
      domain = 'justplainsimple.com'
      result = @scanner.scan(domain, @options)

      assert_equal 0, result[:http].size
    end

    def test_scan_ignores_header_when_ordered
      [ SecureHeader::Type::STS, SecureHeader::Type::XSS, SecureHeader::Type::CTO, SecureHeader::Type::FO, SecureHeader::Type::CSP ].each do |header_name|
        @options.ignore_headers << header_name
        mock_remote_call do |result|
          assert_not_nil result[:http].select { |h| h.name == header_name && h.ignore }.first
        end
      end
    end

    def test_scan_show_header_exists
      res = custom_response(Tinfoil::SecureHeader::Type::FO)
      mock_remote_call(res) do |result|
        assert_not_nil result[:http].select { |h| h.name == Tinfoil::SecureHeader::Type::FO && h.exists }.first
      end
    end

    def test_scan_show_missing_header
      res = custom_response()
      mock_remote_call(res) do |result|
        assert_not_nil result[:http].select { |h| h.name == Tinfoil::SecureHeader::Type::CSP && !h.exists }.first
      end
    end

    private

    def default_response
      res = Net::HTTPSuccess.new('1.1',200,'OK')
      res.add_field Tinfoil::SecureHeader::Type::FO, 'foo'
      res.add_field Tinfoil::SecureHeader::Type::CSP, 'foo'
      res.add_field Tinfoil::SecureHeader::Type::XSS, 'foo'
      res.add_field Tinfoil::SecureHeader::Type::STS, 'foo'
      res.add_field Tinfoil::SecureHeader::Type::CTO, 'foo'
      return res
    end

    def custom_response (*headers)
      res = Net::HTTPSuccess.new('1.1',200,'OK')
      headers.each do |h|
        res.add_field h, 'foo'
      end
      return res
    end

    def mock_remote_call (res = nil, &block)
      res = default_response if res.nil?
      Net::HTTP.expects(:get_response).at_least_once.returns(res)
      domain = 'justplainsimple.com'
      result = @scanner.scan(domain, @options)
      yield result
    end
  end
end

