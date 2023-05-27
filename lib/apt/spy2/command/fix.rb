# frozen_string_literal: true

require 'apt/spy2/command/command'
require 'colored'
require 'fileutils'

module Apt
  module Spy2
    module Command
      # runs `apt-spy2 fix`
      class Fix < BaseCommand
        option :commit, type: :boolean
        option :strict, type: :boolean

        desc 'do_it', ''
        def do_it
          working = filter(retrieve(launchpad: use_launchpad?(options)), strict: options[:strict], output: false)
          print 'The closest mirror is: '
          puts (working[0]).to_s.bold.magenta
          unless options[:commit]
            puts 'Run with --commit to adjust /etc/apt/sources.list'.yellow
            return
          end

          puts 'Updating /etc/apt/sources.list'.yellow
          update(working[0])
        end

        default_task :do_it

        private

        def update(mirror)
          t = Time.now
          r = `lsb_release -c`.split(' ')[1]
          sources = "## Updated on #{t} by apt-spy2\n"
          sources += "deb #{mirror} #{r} main restricted universe multiverse\n"
          sources += "deb #{mirror} #{r}-updates main restricted universe multiverse\n"
          sources += "deb #{mirror} #{r}-backports main restricted universe multiverse\n"
          sources += "deb #{mirror} #{r}-security main restricted universe multiverse\n"

          apt_sources = '/etc/apt/sources.list'

          begin
            File.rename apt_sources, "#{apt_sources}.#{t.to_i}"
            File.open(apt_sources, 'w') do |f|
              f.write(sources)
            end
          rescue StandardError
            raise "Failed updating #{apt_sources}! You probably need sudo!"
          end

          puts "Updated '#{apt_sources}' with #{mirror}".green
          puts 'Run `apt update` to update'.black_on_yellow
        end
      end
    end
  end
end
