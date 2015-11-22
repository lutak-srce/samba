# Class: samba::server::winbind
class samba::server::winbind(
  $major                 = $samba::server::major,
) inherits samba::server {

  package { "samba${major}-winbind":
    ensure => installed,
    alias  => 'samba-winbind',
  }

  service { 'winbind':
    ensure    => running,
    enable    => true,
    subscribe => Concat['/etc/samba/smb.conf'],
  }

}
