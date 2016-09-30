#
# = Class: samba
#
# This module installs samba with CIFS client
class samba (
  $ensure       = 'present',
  $package      = $::samba::params::package_client,
  $package_cifs = $::samba::params::package_cifs,
  $version      = undef,
  $noops        = undef,
) inherits samba::params {

  ### Input parameters validation
  validate_re($ensure, ['present','absent'], 'Valid values are: present, absent')
  validate_string($package)
  validate_string($version)

  ### Internal variables (that map class parameters)
  if $ensure == 'present' {
    $package_ensure = $version ? {
      ''      => 'present',
      default => $version,
    }
  } else {
    $package_ensure = 'absent'
  }

  package { 'samba-client':
    ensure => $package_ensure,
    name   => $package,
    noop   => $noops,
  }

  package { 'cifs-utils' :
    ensure => present, 
    name   => $package_cifs,
    noop   => $noops,
  }

}
