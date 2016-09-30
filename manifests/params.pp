#
# = Class: samba::params
#
# The samba configuration settings.
#
class samba::params {

  case $::operatingsystemrelease {
    default: {
      fail("Class['samba::params']: Unsupported operatingsystemrelease: ${::operatingsystemrelease}")
    }
    /^5.*/: {
      $package_client          = 'samba3x-client'
      $package_server          = 'samba3x'
      $package_winbind         = 'samba3x-winbind'
      $package_winbind_clients = 'samba3x-winbind-clients'
      $package_cifs            = 'cifs-utils'
      $file_nsswitch_conf_template = 'samba/nsswitch.conf.el5.erb'
      $file_smb_conf_path          = '/etc/samba/smb.conf'
      $file_smb_conf_template      = 'samba/smb.conf.erb'
    }
    /^6.*/: {
      $package_client          = 'samba-client'
      $package_server          = 'samba'
      $package_winbind         = 'samba-winbind'
      $package_winbind_clients = 'samba-winbind-clients'
      $package_cifs            = 'cifs-utils'
      $file_nsswitch_conf_template = 'samba/nsswitch.conf.el6.erb'
      $file_smb_conf_path          = '/etc/samba/smb.conf'
      $file_smb_conf_template      = 'samba/smb36-ads.conf.erb'
    }
    /^7.*/: {
      $package_client          = 'samba-client'
      $package_server          = 'samba'
      $package_winbind         = 'samba-winbind'
      $package_winbind_clients = 'samba-winbind-clients'
      $package_cifs            = 'cifs-utils'
      $file_nsswitch_conf_template = 'samba/nsswitch.conf.el7.erb'
      $file_smb_conf_path          = '/etc/samba/smb.conf'
      $file_smb_conf_template      = 'samba/smb40-ads.conf.erb'
    }
  }

  $service_smb     = 'smb'
  $service_nmb     = 'nmb'
  $service_winbind = 'winbind'


}
