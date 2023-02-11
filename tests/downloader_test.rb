# frozen_string_literal: true

require_relative '../test_helper'
require_relative '../lib/apt/spy2/downloader'

# this is an integration test (needs interwebs)
class DownloaderTest < Minitest::Test
  def test_do
    downloader = Apt::Spy2::Downloader.new
    data = downloader.do_download('http://mirrors.ubuntu.com/DE.txt')
    assert(!data.empty?, 'There should have been a response, unless the mirrors are down.')
  end

  def test_do_wrong_countrys
    downloader = Apt::Spy2::Downloader.new
    assert_raises(RuntimeError) { downloader.do_download('http://mirrors.ubuntu.com/de.txt') }
  end
end
