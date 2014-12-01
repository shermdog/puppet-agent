component "puppet" do |pkg, settings, platform|
  pkg.url "http://builds.puppetlabs.lan/pe-puppet/3.7.2.2/artifacts/pe-puppet-3.7.2.2.tar.gz"
  pkg.md5sum "4f0c81833af80aee77b45335b7e69a7f"
  pkg.version "3.7.2.2"

  # Patches Puppet 3.7.x to use /opt/puppetlabs/agent and ../cache as conf_dir and var_dir.
  pkg.apply_patch "resources/patches/puppet/update_confdir_vardir_in_puppet_3_7"

  pkg.build_requires "ruby"
  pkg.build_requires "facter"
  pkg.build_requires "hiera"

  case platform.servicetype
  when "systemd"
    pkg.install_service "ext/systemd/pe-puppet.service"
  when "sysv"
    pkg.install_service "ext/redhat/pe-puppet-client.init"
  else
    fail "need to know where to put service files"
  end

  pkg.install_file "ext/redhat/pe-puppet-logrotate", "/etc/logrotate.d/puppet"

  pkg.install do
    ["#{settings[:bindir]}/ruby install.rb --configdir=#{settings[:sysconfdir]} --sitelibdir=#{settings[:ruby_vendordir]} --configs --quick --man --mandir=#{settings[:mandir]}"]
  end
end
