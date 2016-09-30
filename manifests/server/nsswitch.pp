#
# = Class: samba::server::nsswitch
#
class samba::server::nsswitch (
  $file_nsswitch_conf_template = $::samba::params::file_nsswitch_conf_template,
) inherits samba::params {

  file { '/etc/nsswitch.conf':
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template($file_nsswitch_conf_template),
  }

}
