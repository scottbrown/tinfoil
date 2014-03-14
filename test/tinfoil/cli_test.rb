require 'test/unit'
require 'mocha/test_unit'
require_relative '../../lib/tinfoil'

module Tinfoil
  class CLITest < Test::Unit::TestCase
    def test_run_with_no_args_should_cause_program_exit
      assert_raises Tinfoil::AbnormalProgramExitError do
        capture_stderr do
          Tinfoil::CLI.run([])
        end
      end
    end

    def test_run_with_help_arg_causes_program_exit
      assert_raises Tinfoil::AbnormalProgramExitError do
        capture_stdout do
          Tinfoil::CLI.run(['-h'])
        end
      end
    end

    def test_run_with_domain_arg
      assert_nothing_raised do
        capture_stdout do
          Tinfoil::CLI.run(['example.com'])
        end
      end
    end

    private

    def capture_stdout(&block)
      original_stdout = $stdout
      $stdout = fake = StringIO.new
      begin
        yield
      ensure
        $stdout = original_stdout
      end
     fake.string
    end

    def capture_stderr(&block)
      original_stderr = $stderr
      $stderr = fake = StringIO.new
      begin
        yield
      ensure
        $stderr = original_stderr
      end
     fake.string
    end
  end
end

