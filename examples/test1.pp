user { 'user1':
  ensure  => present,
  gid     => 'user1',
}
user { 'user2':
  ensure  => present,
  gid     => 'user2',
}
group { 'user1':
  ensure => present,
}
group { 'user2':
  ensure => present,
}

include resource_defaults_test
