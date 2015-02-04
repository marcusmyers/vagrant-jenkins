group { "puppet":
  ensure => "present",
}

File { owner => 0, group => 0, mode => 0644 }

exec { "apt-update":
  command => "/usr/bin/apt-get update",
}

Exec["apt-update"] -> Package <| |>

file { '/etc/motd':
  content => "Welcome to your NEW Vagrant-built virtual machine!
              Managed by Puppet.\n"
}

include jenkins
include git
class { 'apache':
  notify => [
    Exec['allow_jenkins_virtual_hosts'],
  ],
}

file { "/var/lib/jenkins/conf.d":
  ensure => "directory",
}


# /etc/httpd/conf.d/*.conf gets deleted on every provision,
# so we put our virtual hosts elsewhere, specifically at
# /var/lib/jenkins/conf.d/*.conf. I could not get the conditional to
# work with exec, so I'm including the condition (via ||) directly
# in the command. This command adds the line only if it does not already
# exist.
exec { "allow_jenkins_virtual_hosts":
  command => '/bin/grep "Include \"\/var\/lib\/jenkins\/conf\.d\/\*.conf\"" /etc/httpd/conf/httpd.conf || /bin/echo "Include \"/var/lib/jenkins/conf.d/*.conf\"" >> /etc/httpd/conf/httpd.conf; sudo apachectl restart',
}

php::ini { '/etc/php.ini':
  display_errors => 'On',
  memory_limit   => '256M',
}
include php::cli
# see https://drupal.org/node/881098 for xml
php::module { [ 'mbstring', 'apc', 'pdo', 'mysql', 'gd', 'xml' ]: }
class { 'php::mod_php5': inifile => '/etc/php.ini' }

# See https://ask.puppetlabs.com/question/3516
# Specifying a password here causes permissions problems
# with PHP.
# See README.md on how to change the password
class { '::mysql::server':
}

# don't use a firewall, see http://stackoverflow.com/questions/5984217
service { iptables: ensure => stopped }

# Install git and dependencies, see
# https://github.com/jenkinsci/puppet-jenkins/issues/78
jenkins::plugin { 'git': }
# plot seems to be the best way to generate generic graphs
# see http://jenkinsrecip.es/add-custom-graphs-to-a-jenkins-ci-job/
jenkins::plugin { 'plot': }
jenkins::plugin { 'log-parser': }
jenkins::plugin { 'ssh-credentials': }
jenkins::plugin { 'scm-api': }
jenkins::plugin { 'credentials': }
jenkins::plugin { 'multiple-scms': }
jenkins::plugin { 'parameterized-trigger': }
jenkins::plugin { 'git-client': }
