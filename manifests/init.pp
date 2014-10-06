# Class: mysqlenc
#
#
class mysqlenc (
  $enable = true,
  $dbuser = 'encro',
  $dbpass = 'rosecret',
  $dbhost = 'localhost',
  $dbname = 'encdb',
  $install_dir = '/opt/puppet/bin',
  $manage_deps = false,
) {
  if $manage_deps {
    package { ['gcc','mysql-devel']:
      ensure => present,
    }
    package { ['mysql2','syslog_logger']:
      ensure   => present,
      provider => pe_gem,
    }
  }

  file { "${install_dir}/mysql-enc.rb":
    ensure => file,
    source => "puppet:///${module_name}/mysql-enc.rb",
    mode   => '0755',
    owner  => 'pe-puppet',
    group  => 'pe-puppet',
  }
  file { "${install_dir}/mysql-enc.yaml":
    ensure  => file,
    content => template("${module_name}/mysql-enc.yaml.erb"),
    mode    => '0600',
    owner   => 'pe-puppet',
    group   => 'pe-puppet',
  }


}