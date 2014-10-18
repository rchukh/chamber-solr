#
# Cookbook Name:: chamber-solr
# Recipe:: _default
#
include_recipe 'maven'

download_dir = ::File.join(Chef::Config['file_cache_path'], 'chamber-solr')
war_dir = ::File.join(Chef::Config['file_cache_path'], 'chamber-solr-extracted')

original_war_name = 'solr-original'
maven original_war_name do
  artifact_id 'solr'
  group_id 'org.apache.solr'
  version node['chamber']['solr']['version']
  packaging 'war'
  dest download_dir
  action :put
end

original_war = ::File.join(download_dir, "#{original_war_name}.war")
repacked_war = ::File.join(download_dir, "#{node['chamber']['solr']['war_name']}.war")
execute 'extract solr' do
  cwd war_dir
  command "jar xf #{original_war}"
  not_if { ::File.exist?(repacked_war) }
end

# Load  additional libraries
%w(log4j-over-slf4j slf4j-api jcl-over-slf4j).each do | libname |
  maven libname do
    group_id 'org.slf4j'
    version '1.7.7'
    dest ::File.join(war_dir, 'WEB-INF', 'lib')
  end
end

%w(logback-classic logback-core).each do | libname |
  maven libname do
    group_id 'ch.qos.logback'
    version '1.1.2'
    dest ::File.join(war_dir, 'WEB-INF', 'lib')
  end
end

# Prepare solr server configuration
template 'tomcat.xml' do
  path ::File.join(war_dir, 'META-INF', 'context.xml')
  source 'tomcat.xml.erb'
end
directory ::File.join(war_dir, 'WEB-INF', 'classes') do
  mode 00755
  recursive true
  action :create
end
template 'logback.xml' do
  path ::File.join(war_dir, 'WEB-INF', 'classes', 'logback.xml')
  source 'logback.xml.erb'
end

execute 'pack solr' do
  cwd war_dir
  command "jar -cfM #{repacked_war} -C #{war_dir} ."
  creates repacked_war
  not_if { ::File.exist?(repacked_war) }
end

# Move Packaged War
remote_file ::File.join(node['chamber']['solr']['path'], node['chamber']['solr']['war_name'] + '.war') do
  source 'file://' + repacked_war
  owner node['chamber']['solr']['user']
  group node['chamber']['solr']['group']
  mode 00644
end
