helper = Nrsysmond::InstallHelper.new(node)

template '/opt/local/etc/nrsysmond.cfg' do
  source 'nrsysmond.cfg.erb'
  owner 'root'
  group helper.process_group
  mode 0640
  variables(
    license: node['nrsysmond']['license'],
    logfile: node['nrsysmond']['logfile'],
    loglevel: node['nrsysmond']['loglevel'],
    proxy: node['nrsysmond']['proxy'],
    ssl: node['nrsysmond']['ssl'],
    ssl_ca_path: node['nrsysmond']['ssl_ca_path'],
    ssl_ca_bundle: node['nrsysmond']['ssl_ca_bundle'],
    pidfile: node['nrsysmond']['pidfile'],
    collector_host: node['nrsysmond']['collector_host'],
    timeout: node['nrsysmond']['timeout']
  )
  notifies :restart, 'service[nrsysmond]'
end

if helper.use_pkgin?
  package 'nrsysmond' do
    version helper.latest_pkgin_version.to_s
  end
else
  execute 'remove old nrsysmond' do
    command 'pkg_delete nrsysmond'
    only_if { helper.remove_old_version? }
  end

  execute 'install nrsysmond' do
    command 'pkg_add -f %s' % helper.pkg_url
    not_if  { helper.already_installed? }
  end
end

service 'nrsysmond'
