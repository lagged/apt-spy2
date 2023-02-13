# frozen_string_literal: true

require 'thor'
require 'open-uri'
require 'colored'
require 'fileutils'
require 'apt/spy2/writer'
require 'apt/spy2/country'
require 'apt/spy2/downloader'
require 'apt/spy2/ubuntu_mirrors'
require 'apt/spy2/launchpad'
require 'apt/spy2/request'
require 'apt/spy2/url'

# apt-spy2 command interface
class AptSpy2 < Thor
  package_name 'apt-spy2'
  class_option :country, default: 'mirrors'
  class_option :launchpad, type: :boolean, banner: "Use launchpad's mirror list"

  desc 'fix', 'Set the closest/fastest mirror'
  option :commit, type: :boolean
  option :strict, type: :boolean
  def fix
    mirrors = retrieve(options[:country], use_launchpad?(options))
    working = filter(mirrors, options[:strict], false)
    print 'The closest mirror is: '
    puts (working[0]).to_s.bold.magenta
    unless options[:commit]
      puts 'Run with --commit to adjust /etc/apt/sources.list'.yellow
      return
    end

    puts 'Updating /etc/apt/sources.list'.yellow
    update(working[0])
  end

  desc 'check', 'Evaluate mirrors'
  option :output, type: :boolean, default: true
  option :format, default: 'shell'
  option :strict, type: :boolean
  def check
    @writer = Apt::Spy2::Writer.new(options[:format])

    mirrors = retrieve(options[:country], use_launchpad?(options))
    filter(mirrors, options[:strict], options[:output])

    puts @writer.to_json if @writer.json?
  end

  desc 'list', 'List the currently available mirrors'
  option :format, default: 'shell'
  def list
    mirrors = retrieve(options[:country], use_launchpad?(options))

    @writer = Apt::Spy2::Writer.new(options[:format])

    @writer.complete(mirrors)

    puts @writer.to_json if @writer.json?
    puts mirrors unless @writer.json?
  end

  desc 'version', 'Show which version of apt-spy2 is installed'
  def version
    puts Apt::Spy2::VERSION
    exit
  end

  private

  def retrieve(country = 'mirrors', launchpad = false)
    downloader = Apt::Spy2::Downloader.new

    if launchpad
      csv_path = File.expand_path("#{File.dirname(__FILE__)}/../../var/country-names.txt")
      country  = Apt::Spy2::Country.new(csv_path)
      name     = country.to_country_name(options[:country])

      launchpad = Apt::Spy2::Launchpad.new(downloader.do_download('https://launchpad.net/ubuntu/+archivemirrors'))
      return launchpad.mirrors(name)
    end

    country.upcase! if country.length == 2

    ubuntu_mirrors = Apt::Spy2::UbuntuMirrors.new(downloader.do_download("http://mirrors.ubuntu.com/#{country}.txt"))
    ubuntu_mirrors.mirrors(country)
  end

  def filter(mirrors, strict = false, output = true)
    # f me :)

    working_mirrors = []

    url = Apt::Spy2::Url.new(strict)

    mirrors.each do |mirror|
      data = { 'mirror' => mirror }

      check = url.adjust!(mirror)

      status = broken?(check)

      data['status'] = status

      working_mirrors << mirror if status == 'up'

      @writer.echo(data) if output
    end

    working_mirrors
  end

  def broken?(url)
    begin
      req = Apt::Spy2::Request.new(url)
      response = req.head
      return 'up' if response.code == '200'

      return 'broken' if response.code == '404'
    rescue StandardError
      # connection errors, ssl errors, etc.
    end

    'down'
  end

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
      msg  = "Failed updating #{apt_sources}!"
      msg += 'You probably need sudo!'
      raise msg
    end

    puts "Updated '#{apt_sources}' with #{mirror}".green
    puts 'Run `apt-get update` to update'.black_on_yellow
  end

  def use_launchpad?(options)
    return false unless options[:launchpad]

    if options[:country] && options[:country] == 'mirrors'
      raise 'Please supply a `--country=foo`. Launchpad cannot guess!'
    end

    true
  end
end
