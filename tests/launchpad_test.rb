# frozen_string_literal: true

require_relative '../test_helper'
require_relative '../lib/apt/spy2/launchpad'

# test to confirm launchpad format (HTML) is parsed
class LaunchpadTest < Minitest::Test
  def setup
    @download_fixture = File.read(File.expand_path("#{File.dirname(__FILE__)}/fixtures/launchpad.html"))
  end

  def test_german_mirrors
    lp = Apt::Spy2::Launchpad.new(@download_fixture)
    mirrors = lp.mirrors('Germany')
    assert_equal(false, mirrors.empty?)
  end
end
