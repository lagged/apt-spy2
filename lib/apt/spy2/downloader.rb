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

        begin
          return URI.open(@url, :read_timeout => 10).read
        rescue OpenURI::HTTPError => the_error
          case the_error.io.status[0]
          when "404"
            raise "The URL #{@url} does not exist."
          else
            raise "Status: #{the_error.io.status[0]}"
          end
        end
      end

    end
  end
end
