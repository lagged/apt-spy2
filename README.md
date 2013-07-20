# apt-spy2 or, "apt-spy for ubuntu"


## setup

```
gem install bundler
bundle install --dev
```

or:

```
gem install apt-spy2
```

## usage

```
$ apt-spy2                                                                                                                                                         [21:03:52]
apt-spy2 commands:
  apt-spy2 check           # Evaluate mirrors
  apt-spy2 fix             # Set the closest/fastest mirror
  apt-spy2 help [COMMAND]  # Describe available commands or one specific command
  apt-spy2 list            # List the currently available mirrors
```

### list

Displays a list of currently available mirrors. These mirrors are automatically selected via
[ubuntu-mirrors](http://mirrors.ubuntu.com) using your IP's location.

### check

`check` works like `list`, but also determines if the servers returned are working.

### fix

`fix` applies the result of `check` and updates `/etc/apt/sources.list`.

Please note: Depending on the context, it may require sudo.

### options/switches

See `apt-spy2 help list|check|fix` for available options.

### exit codes

 * 0 - all went well
 * 1 - some kind of error

### output and non-interactiveness

See `apt-spy2 help COMMAND` for more information.

Generally, this piece of code plays especially nice in a non-interactive environment and won't ask for anything.

## License

[New BSD License](http://opensource.org/licenses/BSD-2-Clause)

## Contributions

Contributions are welcome!

