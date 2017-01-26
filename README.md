# resource_defaults_test

This is a simple module to show how Puppet resource default can be affected by scope and parse order

Resource defaults apply to resources in the local scope and also child scope.

The official documentation for resource defaults is [here](https://docs.puppet.com/puppet/latest/lang_defaults.html)

The module is composed of two classes.

 * The main class sets file resource defaults and includes the other class
 * The other class also sets file resource defaults specifying a couple of overlapping attributes and then it manages a file resource

```puppet
class resource_defaults_test {
  File {
    owner => 'user1',
    group => 'user1',
    mode =>  '0600',
  }

  include resource_defaults_test::subclass
}

class resource_defaults_test::subclass {
  File {
    owner => 'user2',
    group => 'user2',
  }

  file { '/tmp/resources_defaults_test':
    ensure => 'file',
  }
}

```

In the examples directory, there are two example manifests

 * `test1.pp` manages the users/groups needed for the example and then it declares the main class (resource_defaults_test)
 * `test2.pp` manages the users/groups needed for the example and then it declares the subclass (resource_defaults_test::subclass) and the main class (resource_defaults_test), in that order.



Applying the example manifests produces different results

```
testnode modules # puppet apply --modulepath . resource_defaults_test/examples/test1.pp
Notice: Compiled catalog for testnode.puppetlabs.vm in environment production in 0.10 seconds
Notice: /Stage[main]/Main/Group[user1]/ensure: created
Notice: /Stage[main]/Main/User[user1]/ensure: created
Notice: /Stage[main]/Main/Group[user2]/ensure: created
Notice: /Stage[main]/Main/User[user2]/ensure: created
Notice: /Stage[main]/Resource_defaults_test::Subclass/File[/tmp/resources_defaults_test]/ensure: created
Notice: Applied catalog in 0.88 seconds
testnode modules # ll /tmp/resources_defaults_test
-rw------- 1 user2 user2 0 Jan 26 11:53 /tmp/resources_defaults_test
```

The result of `test1.pp` is a file created with the resource defaults from both classes

```
testnode modules # rm /tmp/resources_defaults_test
testnode modules # puppet apply --modulepath . resource_defaults_test/examples/test2.pp
Notice: Compiled catalog for testnode.puppetlabs.vm in environment production in 0.08 seconds
Notice: /Stage[main]/Resource_defaults_test::Subclass/File[/tmp/resources_defaults_test]/ensure: created
Notice: Applied catalog in 0.24 seconds
testnode modules # ll /tmp/resources_defaults_test
-rw-r--r-- 1 user2 user2 0 Jan 26 11:53 /tmp/resources_defaults_test
testnode modules #
```

The result of `test2.pp` is a file created with the resource defaults from `resource_defaults_test::subclass`

