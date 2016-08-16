class filebeat::service {
  if ( $filebeat::package_ensure != 'absent' ) {
    service { 'filebeat':
      ensure   => $filebeat::service_ensure,
      enable   => $filebeat::service_enable,
      provider => $filebeat::service_provider,
    }
  }
}
