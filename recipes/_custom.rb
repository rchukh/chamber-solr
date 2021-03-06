#
# Cookbook Name:: chamber-solr
# Recipe:: _custom
#
# Custom Solr package (e.g. integrated security, logging libraries)
#
cookbook_file 'place solr' do
  source node['chamber']['solr']['custom_war_path']
  path ::File.join(node['chamber']['solr']['path'], node['chamber']['solr']['war_name'] + '.war')
  owner node['chamber']['solr']['user']
  group node['chamber']['solr']['group']
  mode 00644
  action :create_if_missing
end
