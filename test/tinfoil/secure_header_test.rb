require 'test/unit'
require_relative '../../lib/tinfoil/secure_header'

module Tinfoil
  class SecureHeaderTest < Test::Unit::TestCase
    def setup
      @header_name = 'SomeHeader'
      @header = SecureHeader.new(@header_name)
    end

    def teardown
      @header = nil
    end

    def test_status_returns_ignored
      @header.ignore = true
      assert_equal "ignored", @header.status
    end

    def test_status_returns_exists
      @header.exists = true
      assert_equal "exists", @header.status
    end

    def test_status_returns_missing
      @header.exists = false
      assert_equal "missing", @header.status
    end

    def test_to_string_returns_correctly
      @header.exists = true
      assert_equal "SomeHeader: exists", @header.to_s
    end
  end
end

