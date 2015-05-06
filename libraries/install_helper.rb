require 'mixlib/shellout'

module Nrsysmond
  class InstallHelper < Struct.new(:node)
    include Chef::Mixin::ShellOut

    def pkgin_installed?
      cmd = shell_out('pkgin search nrsysmond | grep ^nrsysmond | grep "=\|<"')
      return false unless cmd.exitstatus.zero?
      !cmd.stdout.include?("%s =" % min_nrsysmond_version)
    end

    def process_group
      'root'
    end

    def use_pkgin?
      latest_pkgin_version > ::Chef::Version.new(versionify_version(min_nrsysmond_version))
    end

    def latest_pkgin_version
      pkgin_versions.sort.last
    end

    def pkgin_versions
      [].tap do |versions|
        cmd = shell_out('pkgin search nrsysmond | grep ^nrsysmond')
        cmd.stdout.each_line do |line|
          _name, version = line.split(/[\s;]/)[0].split(/-([^-]+)$/)
          versions << ::Chef::Version.new(versionify_version(version))
        end
      end
    end

    def min_nrsysmond_version
      node['nrsysmond']['pkg']['version']
    end

    def versionify_version(version)
      version.split('.')[0..2].join('.')
    end
  end
end
