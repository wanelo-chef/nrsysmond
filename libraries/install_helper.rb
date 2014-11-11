require 'mixlib/shellout'

module Nrsysmond
  class InstallHelper < Struct.new(:node)
    include Chef::Mixin::ShellOut

    def pkgin_installed?
      cmd = shell_out('pkgin search nrsysmond | grep ^nrsysmond | grep =')
      return false unless cmd.exitstatus.zero?
      !cmd.stdout.include?(node['nrsysmond']['pkg']['version'])
    end

    def process_group
      'root'
    end
  end
end
