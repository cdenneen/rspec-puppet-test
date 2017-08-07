class profile_base::el(
  Optional[String]$selinux_mode = undef,
) {
  stage { 'last': }
  Stage['main'] -> Stage['last']
  if $facts['virtual'] != 'docker' {
    class {'::selinux':
      stage => last,
      mode  => $selinux_mode,
    }
  }
}
