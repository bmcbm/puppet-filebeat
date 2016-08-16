class filebeat::config {
  $filebeat_config = {
    'filebeat'   => {
      'spool_size'    => $filebeat::spool_size,
      'idle_timeout'  => $filebeat::idle_timeout,
      'registry_file' => $filebeat::registry_file,
      'publish_async' => $filebeat::publish_async,
      'config_dir'    => $filebeat::config_dir,
    },
    'output'     => $filebeat::outputs,
    'shipper'    => $filebeat::shipper,
    'logging'    => $filebeat::logging,
    'runoptions' => $filebeat::run_options,
  }

  $notify = $filebeat::package_ensure ? {
    'absent' => undef,
    default  => Service['filebeat'],
  }

  case $::kernel {
    'Linux'   : {
      file {'filebeat.yml':
        ensure  => file,
        path    => $filebeat::config_file,
        content => template($filebeat::conf_template),
        owner   => 'root',
        group   => 'root',
        mode    => $filebeat::config_file_mode,
        notify  => $notify,
      }

      file {'filebeat-config-dir':
        ensure  => directory,
        path    => $filebeat::config_dir,
        owner   => 'root',
        group   => 'root',
        mode    => $filebeat::config_dir_mode,
        recurse => $filebeat::purge_conf_dir,
        purge   => $filebeat::purge_conf_dir,
      }
    } # end Linux

    'Windows' : {
      file {'filebeat.yml':
        ensure  => file,
        path    => $filebeat::config_file,
        content => template($filebeat::conf_template),
        notify  => $notify,
      }

      file {'filebeat-config-dir':
        ensure  => directory,
        path    => $filebeat::config_dir,
        recurse => $filebeat::purge_conf_dir,
        purge   => $filebeat::purge_conf_dir,
      }
    } # end Windows

    default : {
      fail($filebeat::kernel_fail_message)
    }
  }
}
