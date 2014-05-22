package { ['tzdata', 'ntp', 'ntpdate']:
  ensure => installed,
}

file { '/etc/timezone':
  ensure  => 'present',
  content => 'Europe/Amsterdam',
}

file { '/etc/localtime':
  ensure  => 'present',
  target  => '/usr/share/zoneinfo/Europe/Amsterdam',
  require => Package['tzdata'],
}

#yumrepo { 'neo4j':
#  name     => 'neo4j',
#  baseurl  => 'http://yum.neo4j.org',
#  enabled  => 1,
#  gpgcheck => 1,
#  gpgkey   => 'http://debian.neo4j.org/neotechnology.gpg.key',
#}

class { 'neo4j':
  package_name      => 'neo4j-2.1.0-RC1_1.noarch',
  install_from_file => true,
}

