# frozen_string_literal: true

require 'net/http'
require 'net/https'
require 'uri'

module Apt
  module Spy2
    # make requests
    class Request
      def initialize(url)
        uri = URI(url)

        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true if uri.scheme == 'https'

        @http = http
        @request_uri = uri.request_uri
      end

      def get
        @http.request(Net::HTTP::Get.new(@request_uri))
      end

      def head
        @http.request(Net::HTTP::Head.new(@request_uri))
      end
    end
  end
end
