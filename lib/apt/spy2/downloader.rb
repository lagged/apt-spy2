require 'open-uri'

module Apt
  module Spy2
    class Downloader

      def initialize(url = nil)
        @url = url if !url.nil?
      end

      def do_download(url = nil)
        @url = url if !url.nil?

        raise "Please supply a url." if url.nil?

        return open(@url)
      end

    end
  end
end
