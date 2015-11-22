#
# = Class: samba
#
# This module installs samba with CIFS client
class samba (
  $major          = $samba::params::major,
  $package_ensure = $samba::params::package_ensure,
) inherits samba::params {

  package {"samba${major}-client":
    ensure => $package_ensure,
    alias  => 'samba-client',
  }

  case $::operatingsystemrelease {
    default: {}
    /^6.*/: {
      package { 'cifs-utils' : ensure => present, }
    }
  }

}
