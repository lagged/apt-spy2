# frozen_string_literal: true

require 'apt/spy2/request'

module Apt
  module Spy2
    # download url (e.g. mirror list or launchpad page)
    class Downloader
      def do_download(url = nil)
        raise 'Please supply a url.' if url.nil?

        req = Apt::Spy2::Request.new(url)

        begin
          response = req.get
          return response.body if response.code == '200'

          raise "The URL #{@url} does not exist." if response.code == '404'

          raise "Status code: #{response.code}"
        rescue StandardError => e
          raise e
        end
      end
    end
  end
end
