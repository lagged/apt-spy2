# apt-spy2

… or: "apt-spy for Ubuntu"

[![pr](https://github.com/lagged/apt-spy2/actions/workflows/pr.yml/badge.svg)](https://github.com/lagged/apt-spy2/actions/workflows/pr.yml)
[![Gem Version](https://badge.fury.io/rb/apt-spy2.svg)](https://badge.fury.io/rb/apt-spy2)
[![Code Climate](https://codeclimate.com/github/lagged/apt-spy2.png)](https://codeclimate.com/github/lagged/apt-spy2)
[![Coverage Status](https://coveralls.io/repos/lagged/apt-spy2/badge.png)](https://coveralls.io/r/lagged/apt-spy2)


## Installation

```
gem install apt-spy2
```

## Usage

```
$ apt-spy2                                                                                                                                                         [21:03:52]
apt-spy2 commands:
  apt-spy2 check           # Evaluate mirrors
  apt-spy2 fix             # Set the closest/fastest mirror
  apt-spy2 help [COMMAND]  # Describe available commands or one specific command
  apt-spy2 list            # List the currently available mirrors
```

### list command

Displays a list of currently available mirrors. These mirrors are automatically selected via
[ubuntu-mirrors](http://mirrors.ubuntu.com) using your IP's location.

```
$ apt-spy2 list
...
```

Since `mirrors.ubuntu.com` is frequently down, you can the list on [Launchpad](launchpad.net/ubuntu/+archivemirrors):

```
$ apt-spy2 list --launchpad --country=Germany
...
```

### check command

`check` works like `list`, but also determines if the servers returned are working. It supports Launchpad as well.

```
$ apt-spy2 check
...
$ apt-spy2 list --launchpad --country=US
...
```

### fix command

`fix` applies the result of `check` and updates `/etc/apt/sources.list`.

Once the fix is applied, please run `apt-get update`.

**Please note:** Depending on the context, it may require sudo.

### options/switches

See `apt-spy2 help list|check|fix` for available options.

**Please note:** `--launchpad` always requires you pass `--country=FOO` as well.

### exit codes

 * 0 - all went well
 * 1 - some kind of error

### output and non-interactiveness

See `apt-spy2 help COMMAND` for more information.

Generally, `apt-spy2` plays especially nice in a non-interactive environment and won't ask for anything without setting environment variables or using the usual `-y`.

## License

[New BSD License](http://opensource.org/licenses/BSD-2-Clause)

### Release (procedure)

 - update version in `lib/apt/spy2/version.rb`
 - `bundle install`
 - `git commit -a -m 'New release' && git tag -a vVERSION && git push --tags`
