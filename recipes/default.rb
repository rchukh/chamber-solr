#
# Cookbook Name:: chamber-solr
# Recipe:: solr
#
include_recipe 'chef-sugar::default'
require 'chef/sugar/core_extensions'

unless centos?
  Chef::Application.fatal!('Cookbook incompatible with #{platform_family?}')
end

if node['chamber']['solr']['user'].blank? && node['chamber']['solr']['group'].blank?
  Chef::Application.fatal!('Solr user/group ownership attributes are missing')
end

if node['chamber']['solr']['path'].blank?
  Chef::Application.fatal!('Solr path attribute is missing')
end

# Prepare Solr Home
[node['chamber']['solr']['home'], node['chamber']['solr']['log_dir']].each do |path|
  directory path do
    owner node['chamber']['solr']['user']
    group node['chamber']['solr']['group']
    mode 00755
    recursive true
    action :create
  end
end

# Prepare solr server configuration
template 'solr.xml' do
  path ::File.join(node['chamber']['solr']['home'], 'solr.xml')
  owner node['chamber']['solr']['user']
  group node['chamber']['solr']['group']
  source 'solr.xml.erb'
end

# Prepare and deploy solr.war
if node['chamber']['solr']['custom_war_path'].blank?
  include_recipe 'chamber-solr::_repack'
else
  include_recipe 'chamber-solr::_custom'
end
