class resource_defaults_test::subclass {
  File {
    owner => 'user2',
    group => 'user2',
  }

  file { '/tmp/resources_defaults_test':
    ensure => 'file',
  }
}