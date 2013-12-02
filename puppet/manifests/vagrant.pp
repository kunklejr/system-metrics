rbenv::install { "vagrant":
  group => 'vagrant',
  home  => '/home/vagrant'
}

rbenv::compile { "vagrant/2.0.0-p353":
  user => "vagrant",
  ruby => "2.0.0-p353",
  global => true,
}

rbenv::compile { "vagrant/1.9.3-p484":
  user => "vagrant",
  ruby => "1.9.3-p484",
}

package { "libsqlite3-dev":
  ensure => installed,
}