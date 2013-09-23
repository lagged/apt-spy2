require 'nokogiri'

module Apt
  module Spy2
    class Launchpad

      def initialize(download)
        @launchpad = download
      end

      def get_mirrors(country)

        mirrors = []

        document = Nokogiri::HTML(@launchpad)
        document.xpath("//tr/th[text()='#{country}']/../following-sibling::*").each do |node|
          break if node['class'] == 'head' # this is the next country heading

          next if node.xpath(".//span[@class='distromirrorstatusUP']").empty? # this mirror is broken, behind, etc.

          # return all mirrors: .//a[not(starts-with(@href, '/'))] - we'll just get http(s):// for now
          node.xpath(".//a[starts-with(@href, 'http')]").each do |child|
            mirrors << child['href']
          end
        end

        return mirrors

      end

    end
  end
end
