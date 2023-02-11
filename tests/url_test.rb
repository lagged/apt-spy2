# frozen_string_literal: true

require_relative '../test_helper'
require_relative '../lib/apt/spy2/url'

# test to check request lib
class UrlTest < Minitest::Test
  def test_non_strict
    expected = 'http://example.org'

    url = Apt::Spy2::Url.new(false)
    assert_equal(expected, url.adjust!(expected))
  end

  # def strict
  #   skip "Test only runs on ubuntu" if OS.unix? and not OS.mac?

  #   expected = 'http://example.org'

  #   url = Apt::Spy2::Url.new(true)
  #   assert_not_equal(expected, url.mirror)
  # end
end
