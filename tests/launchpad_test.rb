require 'apt/spy2/launchpad'

class LaunchpadTest < Minitest::Test
  def setup
    @download_fixture = File.read(File.expand_path(File.dirname(__FILE__) + "/fixtures/launchpad.html"))
  end

  def test_german_mirrors
    lp = Apt::Spy2::Launchpad.new(@download_fixture)
    mirrors = lp.get_mirrors('Germany')
    assert_equal(false, mirrors.empty?)
  end
end
