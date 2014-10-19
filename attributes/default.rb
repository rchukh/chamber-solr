# === VERSION AND LOCATION
#
default['chamber']['solr']['version']           = '4.10.1'
default['chamber']['solr']['home']              = '/usr/local/solr'
default['chamber']['solr']['log_dir']           = '/usr/local/solr/logs'
default['chamber']['solr']['war_name']          = 'solr'
# Custom Solr War file (integrated security, logging libraries, patches, etc.)
default['chamber']['solr']['custom_war_path']   = nil

# === USER & PATHS
#
default['chamber']['solr']['user']              = nil
default['chamber']['solr']['group']             = nil
default['chamber']['solr']['path']              = nil

# === DEPENDENCIES
#
default['chamber']['solr']['webserver']['tomcat']['include_context'] = true
