#
# = Define: samba::server::winbind
#
define samba::server::share (
  $path,
  $template            = 'samba/share.erb',
  $comment             = '',
  $valid_users         = '',
  $force_user          = '',
  $force_group         = '',
  $browseable          = 'yes',
  $read_only           = '',
  $writeable           = 'yes',
  $force_mode          = '',
  $create_mask         = '',
  $force_dir_mode      = '',
  $force_security_mode = '',
  $directory_mode      = '',
  $case_sensitive      = '',
  $guest_ok            = 'no',
  $guest_only          = 'no',
  $delete_readonly     = '',
  $follow_symlinks     = '',
  $wide_links          = '',
  $hide_files          = '',
  $veto_files          = '',
  $veto_oplock_files   = '',
  $dont_descend        = '',
  $printable           = '',
  $opslocks            = '',
  $strict_locking      = '',
  $public              = '',
) {

  ::concat::fragment { "smb_conf:${name}":
    target  => '/etc/samba/smb.conf',
    content => template($template),
    order   => '200',
  }

}
