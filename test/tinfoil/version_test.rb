require 'test/unit'
require_relative '../../lib/tinfoil/version'

module Tinfoil
  class VersionTest < Test::Unit::TestCase
    def test_contains_version
      assert Tinfoil::VERSION
    end
  end
end

