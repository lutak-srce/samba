# Class: samba::server::restart
class samba::server::restart {

  file { '/usr/local/bin/sambarestart':
    ensure => file,
    owner  => root,
    group  => root,
    mode   => '0755',
    source => 'puppet:///modules/samba/sambarestart',
  }

}
