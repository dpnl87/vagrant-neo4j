service { 'iptables':
  ensure => stopped,
  enable => false,
}

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

class { 'neo4j':
  package_name => 'neo4j-2.1.0-RC1_1.noarch',
}

file { '/etc/profile.d/neo4j.sh':
  ensure  => present,
  content => 'export PATH=/usr/share/neo4j/bin/:$PATH',
  require => Class['neo4j'],
}

class { 'apache':
  default_mods        => false,
  default_confd_files => false,
  purge_configs       => true,
  server_signature    => 'Off',
  server_tokens       => 'Prod',
  sendfile            => 'Off',
}

file { ['/var/www/dashboard', '/var/www/dashboard/app']:
  ensure  => directory,
  require => Class['apache'],
}

apache::vhost { 'dashboard':
  port          => '80',
  serveraliases => 'localhost',
  docroot       => '/var/www/dashboard/app',
  proxy_pass    => [{
    'path'   => '/neo4j',
    'url'    => 'http://localhost:7474/db/data'
  }],
  require       => File['/var/www/dashboard/app'],
}
