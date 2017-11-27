## site.pp ##

# This file (/etc/puppetlabs/puppet/manifests/site.pp) is the main entry point
# used when an agent connects to a master and asks for an updated configuration.
#
# Global objects like filebuckets and resource defaults should go in this file,
# as should the default node definition. (The default node can be omitted
# if you use the console and don't define any other nodes in site.pp. See
# http://docs.puppetlabs.com/guides/language_guide.html#nodes for more on
# node definitions.)

## Active Configurations ##

# Disable filebucket by default for all File resources:
#https://docs.puppet.com/pe/2015.3/release_notes.html#filebucket-resource-no-longer-created-by-default
File { backup => false }

# DEFAULT NODE
# Node definitions in this file are merged with node data from the console. See
# http://docs.puppetlabs.com/guides/language_guide.html#nodes for more on
# node definitions.

# The default node definition matches any node lacking a more specific node
# definition. If there are no other nodes in this file, classes declared here
# will be included in every node's catalog, *in addition* to any classes
# specified in the console for that node.
node 'shashiudawa5.mylabserver.com' {
  include ::haproxy
  
  haproxy::listen { 'paka':
    collect_exported => false,
    ipaddress        => '54.190.58.141',
    ports            => '80',
  }
  
  haproxy::balancermember { 'shashiudawa2.mylabserver.com':
    listening_service => 'paka',
    server_names      => 'shashiudawa2.mylabserver.com',
    ipaddresses       => '54.149.153.181',
    ports             => '8080',
    options           => 'check',
  }
}

node 'shashiudawa2.mylabserver.com' {
 tomcat::deploy { "sysfoo":
   deploy_url     => "https://1-112145048-gh.circle-artifacts.com/0/tmp/circle-artifacts.dh5LqCi/sysfoo.war",
   checksum_value => '3d9aaf8712ebe0ad22460e487438447d',
 }
}

node default {
  # This is where you can declare classes for all nodes.
  # Example:
  #   class { 'my_class': }
}
