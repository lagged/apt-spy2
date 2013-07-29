require 'thor'
require 'open-uri'
require 'colored'
require 'fileutils'
require 'apt/spy2/writer'
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
  def list

    mirrors = retrieve(options[:country])
    @writer = Apt::Spy2::Writer.new(options[:format])

    @writer.set_complete(mirrors)

    puts @writer.to_json if @writer.json?
    puts mirrors if !@writer.json?
  end

  private
  def retrieve(country = "mirrors")
    begin
      country.upcase! if country.length == 2
      mirrors = open("http://mirrors.ubuntu.com/#{country}.txt") do |list|
        list.read
      end
    rescue OpenURI::HTTPError => the_error
      case the_error.io.status[0]
      when "404"
        raise "The country code '#{country}' is incorrect."
      else
        raise "Status: #{the_error.io.status[0]}"
      end
    end

    mirrors = mirrors.split(/\n/)
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
