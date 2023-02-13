# frozen_string_literal: true

require 'thor'
require 'colored'
require 'apt/spy2/country'
require 'apt/spy2/downloader'
require 'apt/spy2/launchpad'
require 'apt/spy2/request'
require 'apt/spy2/status'
require 'apt/spy2/ubuntu_mirrors'
require 'apt/spy2/url'
require 'apt/spy2/writer'

module Apt
  module Spy2
    module Command
      # BaseCommmand for all others
      class BaseCommand < Thor
        # rubocop:disable Metrics/BlockLength
        no_commands do
          def use_launchpad?(options)
            return false unless options[:launchpad]

            if options[:country] && options[:country] == 'mirrors'
              raise 'Please supply a `--country=foo`. Launchpad cannot guess!'
            end

            true
          end

          def country_names
            File.expand_path("#{File.dirname(__FILE__)}/../../../../var/country-names.txt")
          end

          def retrieve(launchpad: false)
            downloader = Apt::Spy2::Downloader.new

            if launchpad
              name = Apt::Spy2::Country.new(country_names).to_country_name(options[:country])
              launchpad = Apt::Spy2::Launchpad.new(downloader.do_download('https://launchpad.net/ubuntu/+archivemirrors'))
              return launchpad.mirrors(name)
            end

            country = options[:country]
            country.upcase! if country.length == 2

            ubuntu_mirrors = Apt::Spy2::UbuntuMirrors.new(downloader.do_download("http://mirrors.ubuntu.com/#{country}.txt"))
            ubuntu_mirrors.mirrors(country)
          end

          def filter(mirrors, strict: false, output: true)
            # f me :)
            working_mirrors = []
            url = Apt::Spy2::Url.new(strict)

            mirrors.each do |mirror|
              data = { 'mirror' => mirror }
              data['status'] = broken?(url.adjust!(mirror))
              working_mirrors << mirror if data['status'] == Apt::Spy2::Status::UP
              @writer.echo(data) if output
            end

            working_mirrors
          end

          def broken?(url)
            begin
              req = Apt::Spy2::Request.new(url)
              return Apt::Spy2::Status.status?(req.head.code)
            rescue StandardError
              # connection errors, ssl errors, etc.
            end

            Apt::Spy2::Status::DOWN
          end
        end
        # rubocop:enable Metrics/BlockLength
      end
    end
  end
end
