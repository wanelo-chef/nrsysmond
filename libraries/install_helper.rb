require 'mixlib/shellout'

module Nrsysmond
  class InstallHelper < Struct.new(:node)
    include Chef::Mixin::ShellOut

    def pkg_url
      use_unsigned_package? ?
        '%s/unsigned/nrsysmond-%s.tgz' % [node['nrsysmond']['pkg']['url'], min_nrsysmond_version] :
        '%s/nrsysmond-%s.tgz' % [node['nrsysmond']['pkg']['url'], min_nrsysmond_version]
    end

    def already_installed?
      cmd = shell_out('pkg_info | grep ^nrsysmond | cut -d" " -f1 | cut -d";" -f1 | cut -d"-" -f2-', returns: [0, 1])
      return false unless cmd.exitstatus.zero?
      version = cmd.stdout.chomp
      return false if version.empty?
      ::Chef::Version.new(versionify_version(version)) == ::Chef::Version.new(versionify_version(min_nrsysmond_version))
    end

    def remove_old_version?
      cmd = shell_out('pkg_info | grep ^nrsysmond | cut -d" " -f1 | cut -d";" -f1 | cut -d"-" -f2-', returns: [0, 1])
      return false unless cmd.exitstatus.zero?
      version = cmd.stdout.chomp
      return false if version.empty?
      ::Chef::Version.new(versionify_version(cmd.stdout.chomp)) < ::Chef::Version.new(versionify_version(min_nrsysmond_version))
    end

    def process_group
      'root'
    end

    def use_pkgin?
      return false unless latest_pkgin_version
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

    private

    def use_unsigned_package?
      shell_out('grep VERIFIED_INSTALLATION=trusted /opt/local/etc/pkg_install.conf').error?
    rescue
      true
    end
  end
end
