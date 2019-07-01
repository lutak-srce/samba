#
# = Class: samba::server
#
# This class sets up samba server
class samba::server (
  $ensure                 = present,
  $version                = undef,
  $package                = $::samba::params::package_server,
  $status                 = 'enabled',
  $service_smb            = $::samba::params::service_smb,
  $service_nmb            = $::samba::params::service_nmb,
  $file_smb_conf_path     = $::samba::params::file_smb_conf_path,
  $file_smb_conf_template = $::samba::params::file_smb_conf_template,
  $workgroup              = 'WORKGROUP',
  $realm                  = '',
  $security               = 'share',
  $allow_trusted_domains  = 'no',
  $password_servers       = [],
  $interfaces             = 'lo eth0',
  $logfile                = '/var/log/samba/log.%m',
  $max_log_size           = '50',
  $log_level              = '0',
  $syslog                 = '0',
  $load_printers          = 'no',
  $cups_options           = 'raw',
  $domain_master          = 'no',
  $local_master           = 'no',
  $idmap_backend          = 'tdbsam',
  $idmap_range            = '10000-49999',
  $winbind_use_defdomain  = 'yes',
  $winbind_enum_users     = 'yes',
  $winbind_enum_groups    = 'yes',
  $winbind_nested_groups  = 'yes',
  $ad_user                = 'Administrator',
  $ad_password            = 'dummypass',
  $kernel_oplocks         = undef,
  $socket_options         = undef,
  $noops                  = undef,
) inherits samba::params {

  ### Input parameters validation
  validate_re($ensure, ['present','absent'], 'Valid values are: present, absent')
  validate_string($package)
  validate_string($version)
  validate_re($status,  ['enabled','disabled','running','stopped','activated','deactivated','unmanaged'], 'Valid values are: enabled, disabled, running, stopped, activated, deactivated and unmanaged')
  validate_string($service_smb)
  validate_string($service_nmb)

  ### Internal variables (that map class parameters)
  if $ensure == 'present' {
    $package_ensure = $version ? {
      ''      => 'present',
      default => $version,
    }
    $service_enable = $status ? {
      'enabled'     => true,
      'disabled'    => false,
      'running'     => undef,
      'stopped'     => undef,
      'activated'   => true,
      'deactivated' => false,
      'unmanaged'   => undef,
    }
    $service_ensure = $status ? {
      'enabled'     => 'running',
      'disabled'    => 'stopped',
      'running'     => 'running',
      'stopped'     => 'stopped',
      'activated'   => undef,
      'deactivated' => undef,
      'unmanaged'   => undef,
    }
  } else {
    $package_ensure = 'absent'
    $service_enable = undef
    $service_ensure = stopped
  }

  # packages
  package { 'samba':
    ensure => $package_ensure,
    name   => $package,
    noop   => $noops,
  }

  # files
  File {
    mode    => '0644',
    require => Package['samba'],
    noop    => $noops,
  }

  # config dir
  file { '/etc/samba':
    ensure  => directory,
  }


  # smb.conf
  concat { '/etc/samba/smb.conf':
    path  => $file_smb_conf_path,
    owner => root,
    group => root,
    mode  => '0644',
    noop  => $noops,
  }

  ::concat::fragment { 'smb_conf:global':
    target  => '/etc/samba/smb.conf',
    content => template($file_smb_conf_template),
    order   => '100',
  }

  # services
  Service {
    ensure    => $service_ensure,
    enable    => $service_enable,
    subscribe => Concat['/etc/samba/smb.conf'],
    require   => Package['samba'],
    noop      => $noops,
  }

  service { 'smb': name => $service_smb }
  service { 'nmb': name => $service_nmb }


  # Active Directory
  if upcase($security) == 'ADS' {
    include ::samba::server::winbind
    include ::samba::server::nsswitch
    include ::kerberos

    ::kerberos::realm { 'ads_domain_realm':
      realm => $realm,
      kdc   => $password_servers,
    }

    exec { 'generate_krb_ticket' :
      command => "/bin/echo ${ad_password} | /usr/bin/kinit ${ad_user}@${realm}",
      unless  => '/usr/bin/klist > /dev/null',
      require => [
        ::Kerberos::Realm['ads_domain_realm'],
        Class['kerberos'],
      ],
    }

    exec { 'join_active_directory_domain' :
      command => "/usr/bin/net ads join -U ${ad_user}%${ad_password}",
      onlyif  => '/usr/bin/net ads testjoin -k 2>&1 | /bin/grep -q "not valid"',
      require => [
        Exec['generate_krb_ticket'],
        Concat['/etc/samba/smb.conf'],
      ],
      notify  => Service['smb', 'winbind'],
    }
  }

}
