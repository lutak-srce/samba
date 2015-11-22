# Class: samba::params
#
#   The samba configuration settings.
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class samba::params {
  # package name version
  # note: we want samba3x packages in RHEL v5
  case $::operatingsystemrelease {
    default: {
      $major = ''
    }
    /^5.*/: {
      $major = '3x'
    }
  }
  $package_ensure = 'present'
  $status         = 'enabled'

  # other settings
  $workgroup     = 'WORKGROUP'
  $realm         = ''
  $security      = 'share'
  $allow_trusted_domains = 'no'
  $password_server = ''
  # listen options
  $interfaces    = 'eth0 lo'
  # log options
  $syslog        = '0'
  $logfile       = '/var/log/samba/log.%m'
  # printer options
  $load_printers = 'no'
  $cups_options  = 'raw'
  # win integration options
  $domain_master = 'no'
  $local_master  = 'no'
  # idmap mapping
  $idmap_backend         = 'tdbsam'
  $idmap_range           = '10000-49999'
  $winbind_use_defdomain = 'yes'
  $winbind_enum_users    = 'yes'
  $winbind_enum_groups   = 'yes'
  $winbind_nested_groups = 'yes'
  # domain joining credentials
  $ad_user    = 'Administrator'
  $ad_passwrd = 'dummypass'
}
