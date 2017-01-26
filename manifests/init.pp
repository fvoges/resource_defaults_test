class resource_defaults_test {
  File {
    owner => 'user1',
    group => 'user1',
    mode =>  '0600',
  }

  include resource_defaults_test::subclass
}