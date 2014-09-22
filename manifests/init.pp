# == Class: wkhtmltox
#
# The wkhtmltox Puppet module allows a user to install the wkhtmlto(x/pdf)
# toolkit via packages. It can either install it via a repository, or
# alternatively (and by default), downloads the latest version specified
# from sourceforge and installs the package.
#
# === Parameters
#
# [*ensure*]
#   Allows you to set (present|absent) which will install or remove the package
# [*version*]
#   Set the version number of wkhtml to download
# [*arch*]
#   Select either amd64 or i386 depending upon your architecture.
# [*osver*]
#   Set the operation system version, which by default pulls from facter.
# [*packagetype*]
#   Select the package type of wkhtml to download. We currently support deb/rpm
# [*provider*]
#   Set a valid provider type to install the package release we download
# [*download_url*]
#   Set the location of the final wkhtmltox binary download to use. Can be the
#   default or go to a local package repository if needed
# [*wkhtml_filename*]
#   Build a filename of the binary to download for wkhtmltox
# [*use_downloader*]
#   If the module should use a local/repo package version or download/install.
#
# === Examples
#
#  class { wkhtmltox:
#    ensure => present,
#  }
#
# === Authors
#
# Justice London <jlondon@syrussystems.com>
#
# === Copyright
#
# Copyright 2014 Justice London, unless otherwise noted.
#
class wkhtmltox (
  $ensure          = present, 
  $version         = $::wkhtmltox::params::version,
  $arch            = $::wkhtmltox::params::arch,
  $osver           = $::wkhtmltox::params::osver,
  $packagetype     = $::wkhtmltox::params::packagetype,
  $provider        = $::wkhtmltox::params::provider,
  $download_url    = "http://iweb.dl.sourceforge.net/project/wkhtmltopdf/${version}/${wkhtml_filename}",
  $wkhtml_filename = "wkhtmltox-${version}_linux-${osver}-${arch}.${packagetype}",
  $use_downloader  = true,
) inherits ::wkhtmltox::params {
  include wget

  #Variable validations
  validate_re($ensure, '^present$|^absent$')
  validate_string($version)
  validate_re($arch, '^i386$|^amd64$')
  validate_string($osver)
  validate_re($packagetype, '^deb$|^rpm$')
  validate_re($provider, '^dpkg$|^rpm$')
  validate_string($download_url)
  validate_string($wkhtml_filename)
  validate_bool($use_downloader)

  if $use_downloader {
    #Download wkhtmltox package
    wget::fetch { 'wkhtml_package':
      source      => $download_url,
      destination => "/tmp/${wkhtml_filename}",
      verbose     => false,
    }

    package { 'wkhtmltox':
      ensure   => $ensure,
      source   => "/tmp/${wkhtml_filename}",
      provider => $provider,
      require  => Wget::Fetch['wkhtml_package'],
    }
  }
  else {
    #Just install the plain package, such as from a repo.
    package { 'wkhtmltox':
      ensure => $ensure,
    }
  }

}
