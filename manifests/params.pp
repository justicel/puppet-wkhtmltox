#Class parameters for wkhtmltox
class wkhtmltox::params {

  #Default parameters
  $version = '0.12.1'
  $arch    = $::architecture

  #A bit hacky but the packaged versions of wkhtmltox are sparse
  case $::osfamily {
    'Debian': {
      $osver       = $::lsbdistcodename
      $packagetype = 'deb'
      $provider    = 'dpkg'
    }
    'RedHat': {
      $os_major_ver = inline_template("<%= operatingsystemrelease.split('.')[0] %>")
      $osver        = "centos${os_major_ver}"
      $packagetype  = 'rpm'
      $provider     = 'rpm'
    }
    default: {
      fail("Class['wkhtmltox::params']: Unsupported OS: ${::osfamily}")
    }
  }

}
