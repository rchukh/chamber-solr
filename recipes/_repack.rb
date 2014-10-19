#
# Cookbook Name:: chamber-solr
# Recipe:: _repack
#
include_recipe 'maven'

# === PREPARATION
# Download and extract solr.war
#
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

# === LIBRARY EXTENSIONS
# Load additional libraries to include in solr.war
#
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

# === CONFIGURATION EXTENSIONS
# Add additional config files to solr.war
#
directory 'classes directory' do
  path ::File.join(war_dir, 'WEB-INF', 'classes')
  mode 00755
  recursive true
  action :create
end
# Add logging configuration
template 'logback.xml' do
  path ::File.join(war_dir, 'WEB-INF', 'classes', 'logback.xml')
  source 'logback.xml.erb'
end
# Add Tomcat-specific context settings (environment, security, etc.)
template 'tomcat.xml' do
  path ::File.join(war_dir, 'META-INF', 'context.xml')
  source 'tomcat.xml.erb'
  only_if { node['chamber']['solr']['webserver']['tomcat']['include_context'] }
end

# === PACKAGE
#
# Package solr war
execute 'pack solr' do
  cwd war_dir
  command "jar -cfM #{repacked_war} -C #{war_dir} ."
  creates repacked_war
  not_if { ::File.exist?(repacked_war) }
end
# Move Packaged War
remote_file 'place solr' do
  path ::File.join(node['chamber']['solr']['path'], node['chamber']['solr']['war_name'] + '.war')
  source 'file://' + repacked_war
  owner node['chamber']['solr']['user']
  group node['chamber']['solr']['group']
  mode 00644
end
