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
    source => "puppet:///modules/${module_name}/mysql-enc.rb",
    mode   => '0755',
    owner  => 'pe-puppet',
    group  => 'pe-puppet',
    require => File["${install_dir}/mysql-enc.yaml"],
  }
  file { "${install_dir}/mysql-enc.yaml":
    ensure  => file,
    content => template("${module_name}/mysql-enc.yaml.erb"),
    mode    => '0600',
    owner   => 'pe-puppet',
    group   => 'pe-puppet',
  }

  ini_setting { 'Puppet Node Terminus':
    ensure  => present,
    path    => "${confdir}/puppet.conf",
    section => "master",
    setting => "node_terminus",
    value   => "exec",
    require => File["${install_dir}/mysql-enc.rb"],
    notify  => Service['pe-httpd'],
  }

  ini_setting { 'Puppet ENC':
    ensure  => present,
    path    => "${confdir}/puppet.conf",
    section => "master",
    setting => "external_nodes",
    value   => "${install_dir}/mysql-cert-autosign.rb",
    require => File["${install_dir}/mysql-enc.rb"],
    notify  => Service['pe-httpd'],
  }

}