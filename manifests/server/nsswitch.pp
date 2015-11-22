# Class: samba::server::nsswitch
class samba::server::nsswitch {

  file { '/etc/nsswitch.conf':
    ensure => file,
    owner  => root,
    group  => root,
    mode   => '0644',
    source => 'puppet:///modules/samba/nsswitch.conf',
  }

}
