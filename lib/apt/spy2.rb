require 'thor'
require 'open-uri'
require 'colored'
require 'fileutils'
require 'apt/spy2/writer'
require 'apt/spy2/country'
require 'apt/spy2/ubuntu_mirrors'
require 'apt/spy2/launchpad'
require 'json'

class AptSpy2 < Thor
  package_name "apt-spy2"

  desc "fix", "Set the closest/fastest mirror"
  option :country, :default => "mirrors"
  option :commit, :type => :boolean
  def fix
    working = filter(retrieve(), false)
    print "The closest mirror is: "
    puts "#{working[0]}".white_on_green
    if !options[:commit]
      puts "Run with --commit to adjust /etc/apt/sources.list".yellow
    else
      puts "Updating /etc/apt/sources.list".yellow
      update(working[0])
    end
  end

  desc "check", "Evaluate mirrors"
  option :country, :default => "mirrors"
  option :output, :type => :boolean, :default => true
  option :format, :default => "shell"
  def check

    @writer = Apt::Spy2::Writer.new(options[:format])

    mirrors = retrieve(options[:country])
    filter(mirrors, options[:output])

    puts @writer.to_json if @writer.json?
  end

  desc "list", "List the currently available mirrors"
  option :country, :default => "mirrors"
  option :format, :default => "shell"
  option :launchpad, :type => :boolean, :banner => "Use launchpad's mirror list"
  def list

    use_launchpad = false

    if options[:launchpad]

      if options[:country] == 'mirrors'
        raise "Please supply a --country. Launchpad cannot guess!"
      end

      use_launchpad = true
    end

    mirrors = retrieve(options[:country], use_launchpad)

    @writer = Apt::Spy2::Writer.new(options[:format])

    @writer.set_complete(mirrors)

    puts @writer.to_json if @writer.json?
    puts mirrors if !@writer.json?
  end

  private
  def retrieve(country = "mirrors", launchpad = false)

    if launchpad === true
      csv_path = File.expand_path(File.dirname(__FILE__) + "/../../var/country-names.txt")
      country  = Apt::Spy2::Country.new(csv_path)
      name     = country.to_country_name(options[:country])

      launchpad = Apt::Spy2::Launchpad.new('https://launchpad.net/ubuntu/+archivemirrors')
      return launchpad.get_mirrors(name)
    end

    ubuntu_mirrors = Apt::Spy2::UbuntuMirrors.new("http://mirrors.ubuntu.com")
    mirrors = ubuntu_mirrors.get_mirrors(country)
    return mirrors

  end

  private
  def filter(mirrors, output = true)
    # f me :)

    working_mirrors = []

    mirrors.each do |mirror|
      data = {"mirror" => mirror }
      begin
        mirror_status = open(mirror)
        data["status"] = "up"
        working_mirrors << mirror
      rescue OpenURI::HTTPError => the_error
        data["status"] = "broken"
      rescue Errno::ECONNREFUSED
        data["status"] = "down"
      end

      @writer.echo(data) if output
    end

    return working_mirrors

  end

  private
  def update(mirror)

    t = Time.now
    r = `lsb_release -c`.split(" ")[1]
    sources = "## Updated on #{t.to_s} by apt-spy2\n"
    sources << "deb #{mirror} #{r} main restricted universe multiverse\n"
    sources << "deb #{mirror} #{r}-updates main restricted universe multiverse\n"
    sources << "deb #{mirror} #{r}-backports main restricted universe multiverse\n"
    sources << "deb #{mirror} #{r}-security main restricted universe multiverse\n"

    apt_sources = '/etc/apt/sources.list'

    begin
      File.rename apt_sources, "#{apt_sources}.#{t.to_i}"
      File.open(apt_sources, 'w') do |f|
        f.write(sources)
      end
    rescue
      msg  = "Failed updating #{apt_sources}!"
      msg << "You probably need sudo!"
      raise msg
    end

    puts "Updated '#{apt_sources}' with #{mirror}".green
    puts "Run `apt-get update` to update".red_on_yellow
  end
end
