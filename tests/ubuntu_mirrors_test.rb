# frozen_string_literal: true

require_relative '../test_helper'
require_relative '../lib/apt/spy2/ubuntu_mirrors'

# test to confirm launchpad format (HTML) is parsed
class UbuntuMirrorsTest < Minitest::Test
  def test_mirrors
    expected = ['http://example.org', 'http://example.de']
    fixture = expected.join("\n")

    m = Apt::Spy2::UbuntuMirrors.new(fixture)
    assert_equal(expected, m.mirrors('country'))
  end
end
