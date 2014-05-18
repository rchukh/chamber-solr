default[:chamber][:solr][:version]          = '4.8.0'
default[:chamber][:solr][:url]              = ::File.join(node[:ark][:apache_mirror],
                                                          'lucene/solr', node[:chamber][:solr][:version],
                                                          "solr-#{node[:chamber][:solr][:version]}.tgz")
default[:chamber][:solr][:archive_war_path] = ::File.join("solr-#{node[:chamber][:solr][:version]}",
                                                          'dist',
                                                          "solr-#{node[:chamber][:solr][:version]}.war")
default[:chamber][:solr][:home]             = '/usr/local/solr'
default[:chamber][:solr][:log_dir]          = '/usr/local/solr/logs'
default[:chamber][:solr][:war_name]			= 'solr'

# Custom Solr War file (integrated security, logging libraries, patches, etc.)
default[:chamber][:solr][:custom_war_path]  = nil

# Required parameters
default[:chamber][:solr][:user]				= nil
default[:chamber][:solr][:group]			= nil
default[:chamber][:solr][:path]             = nil
