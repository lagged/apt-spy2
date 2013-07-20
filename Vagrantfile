Vagrant::Config.run do |config|

    config.vm.box = "precise64"
    config.vm.box_url = "http://dl.dropbox.com/u/1537815/precise64.box"

    config.vm.customize [
        "modifyvm", :id,
        "--name", "apt-spy2 testbox",
        "--memory", "128"
    ]
end
