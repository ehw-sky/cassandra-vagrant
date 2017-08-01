include cassandra::datastax_repo
include cassandra::java

node /^cassandra-node[012]$/ {
  class { 'cassandra':
    dc             => 'DC1',
    settings       => {
      'authenticator'               => 'AllowAllAuthenticator',
      'auto_bootstrap'              => false,
      'cluster_name'                => 'MyCassandraCluster',
      'commitlog_directory'         => '/var/lib/cassandra/commitlog',
      'commitlog_sync'              => 'periodic',
      'commitlog_sync_period_in_ms' => 10000,
      'data_file_directories'       => ['/var/lib/cassandra/data'],
      'endpoint_snitch'             => 'GossipingPropertyFileSnitch',
      # 'hints_directory'             => '/var/lib/cassandra/hints',
      'listen_interface'            => 'eth0',
      'num_tokens'                  => 256,
      'partitioner'                 => 'org.apache.cassandra.dht.Murmur3Partitioner',
      'saved_caches_directory'      => '/var/lib/cassandra/saved_caches',
      'seed_provider'               => [
        {
          'class_name' => 'org.apache.cassandra.locator.SimpleSeedProvider',
          'parameters' => [
            {
              # 'seeds' => '110.82.155.0,110.82.156.3',
              'seeds' => 'cassandra-node0, cassandra-node3',
            },
          ],
        },
      ],
      'start_native_transport'      => true,
    },
    service_ensure => 'running',
    require  => Class['cassandra::datastax_repo', 'cassandra::java'],
    notify => File['/etc/security/limits.d/cassandra.conf'],
  }
}

node /^cassandra-node[345]$/ {
  class { 'cassandra':
    dc             => 'DC2',
    settings       => {
      'authenticator'               => 'AllowAllAuthenticator',
      'auto_bootstrap'              => false,
      'cluster_name'                => 'MyCassandraCluster',
      'commitlog_directory'         => '/var/lib/cassandra/commitlog',
      'commitlog_sync'              => 'periodic',
      'commitlog_sync_period_in_ms' => 10000,
      'data_file_directories'       => ['/var/lib/cassandra/data'],
      'endpoint_snitch'             => 'GossipingPropertyFileSnitch',
      # 'hints_directory'             => '/var/lib/cassandra/hints',
      'listen_interface'            => 'eth0',
      'num_tokens'                  => 256,
      'partitioner'                 => 'org.apache.cassandra.dht.Murmur3Partitioner',
      'saved_caches_directory'      => '/var/lib/cassandra/saved_caches',
      'seed_provider'               => [
        {
          'class_name' => 'org.apache.cassandra.locator.SimpleSeedProvider',
          'parameters' => [
            {
              # 'seeds' => '110.82.155.0,110.82.156.3',
              'seeds' => 'cassandra-node0.lxc, cassandra-node3.lxc',

            },
          ],
        },
      ],
      'start_native_transport'      => true,
    },
    service_ensure => 'running',
    require  => Class['cassandra::datastax_repo', 'cassandra::java'],
    notify => File['/etc/security/limits.d/cassandra.conf'],
  }
}

file { '/etc/security/limits.d/cassandra.conf':
    content => "cassandra - nofile 100000
cassandra - nproc 32768
",
}