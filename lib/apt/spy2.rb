# frozen_string_literal: true

require 'thor'
require 'apt/spy2/command/fix'
require 'apt/spy2/command/list'
require 'apt/spy2/command/check'
require 'apt/spy2/version'

# apt-spy2 command interface
class AptSpy2 < Thor
  package_name 'apt-spy2'
  class_option :country, default: 'mirrors'
  class_option :launchpad, type: :boolean, banner: 'Use launchpad\'s mirror list'

  desc 'check', 'Evaluate mirrors'
  subcommand 'check', Apt::Spy2::Command::Check

  desc 'fix', 'Update sources'
  subcommand 'fix', Apt::Spy2::Command::Fix

  desc 'list', 'List the currently available mirrors'
  subcommand 'list', Apt::Spy2::Command::List

  desc 'version', 'Show which version of apt-spy2 is installed'
  def version
    puts Apt::Spy2::VERSION
    exit
  end
end
