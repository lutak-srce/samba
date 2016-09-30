#
# = Class: samba::server::winbind
#
class samba::server::winbind (
  $package         = $::samba::params::package_winbind,
  $package_clients = $::samba::params::package_winbind_clients,
  $package_ensure  = 'present',
  $service         = $::samba::params::service_winbind,
  $status          = 'enabled',
  $noops           = undef,
) inherits samba::params {

  package { 'samba-winbind':
    ensure => installed,
    name   => $package,
    noop   => $noops,
  }

  package { 'samba-winbind-clients':
    ensure => installed,
    name   => $package_clients,
    noop   => $noops,
  }

  service { 'winbind':
    ensure    => running,
    enable    => true,
    name      => $service,
    subscribe => Concat['/etc/samba/smb.conf'],
    noop      => $noops,
  }

}
