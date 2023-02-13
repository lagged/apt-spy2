# frozen_string_literal: true

require_relative '../test_helper'
require_relative '../lib/apt/spy2/launchpad'
require_relative '../lib/apt/spy2/downloader'

# test to confirm launchpad format (HTML) is parsed
class LaunchpadTest < Minitest::Test
  def test_german_mirrors
    lp = Apt::Spy2::Launchpad.new(File.open("#{File.dirname(__FILE__)}/fixtures/launchpad.html", 'r:UTF-8'))
    mirrors = lp.mirrors('Germany')
    assert_equal(false, mirrors.empty?)
  end

  def test_online
    downloader = Apt::Spy2::Downloader.new
    launchpad = Apt::Spy2::Launchpad.new(downloader.do_download('https://launchpad.net/ubuntu/+archivemirrors'))
    mirrors = launchpad.mirrors('Ukraine')
    assert_equal(false, mirrors.empty?)
  end
end
