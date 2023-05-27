# frozen_string_literal: true

require 'nokogiri'

module Apt
  module Spy2
    # parse launchpad output
    class Launchpad
      def initialize(download)
        @document = Nokogiri::HTML(download) do |c|
          # rubocop:disable Layout/LineLength
          c.options = Nokogiri::XML::ParseOptions::HUGE | Nokogiri::XML::ParseOptions::NONET | Nokogiri::XML::ParseOptions::RECOVER
          # rubocop:enable Layout/LineLength
        end
      end

      def mirrors(country)
        mirrors = []

        table_rows = @document.xpath("//tr/th[text()='#{country}']/../following-sibling::*")
        raise "Couldn't find a mirror for #{country}." if table_rows.empty?

        table_rows.each do |node|
          break if node['class'] == 'head' # this is the next country heading

          next if node.xpath(".//span[@class='distromirrorstatusUP']").empty? # this mirror is broken, behind, etc.

          # return all mirrors: .//a[not(starts-with(@href, '/'))] - we'll just get http(s):// for now
          node.xpath(".//a[starts-with(@href, 'http')]").each do |child|
            mirrors << child['href']
          end
        end

        mirrors
      end
    end
  end
end
