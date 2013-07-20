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
  def check
    mirrors = retrieve(options[:country])
    return filter(mirrors, options[:output])
  end

  desc "list", "List the currently available mirrors"
  option :country, :default => "mirrors"
  def list
    mirrors = retrieve(options[:country])
    puts mirrors
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
        puts "The country code '#{country}' is incorrect.".red
        exit 1
      else
        puts "Status: #{the_error.io.status[0]}".red
        exit 1
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
      print "Mirror: #{mirror} - " if output
      begin
        mirror_status = open(mirror)
        puts "UP".green if output
        working_mirrors << mirror
      rescue OpenURI::HTTPError => the_error
        puts "BROKEN: #{the_error.io.status[0]}".yellow_on_red if output
      rescue Errno::ECONNREFUSED
        puts "DOWN".red if output
      end
    end

    return working_mirrors

  end

  private
  def update(mirror)

    t = Time.now
    r = `lsb_release -c`.split(" ")[1]
    sources = "## Updated on #{t.to_s}\n"
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
      puts "Failed updating #{apt_sources}!".red_on_white
      puts "You probably need sudo!".red
      exit 1
    end

    puts "Updated '#{apt_sources}' with #{mirror}".green
    puts "Run `apt-get update` to update".red_on_yellow
  end
end
