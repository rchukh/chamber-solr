#
# Cookbook Name:: chamber-solr
# Recipe:: _default
#
include_recipe 'ark'
include_recipe 'maven'

solr_pre_war = ::File.join(Chef::Config[:file_cache_path], 'chamber-solr', node[:chamber][:solr][:archive_war_path])
war_dir = ::File.join(Chef::Config[:file_cache_path], 'chamber-solr-extracted')
war_package = ::File.join(Chef::Config[:file_cache_path], 'chamber-solr', node[:chamber][:solr][:war_name] + '.war')

directory war_dir do
  mode 00755
  recursive true
  action :create
end

# Extract war file from solr archive
ark 'solr_war' do
  url node[:chamber][:solr][:url]
  action :cherry_pick
  creates node[:chamber][:solr][:archive_war_path]
  path ::File.join(Chef::Config[:file_cache_path], 'chamber-solr')
  strip_components 0
end

execute 'jar' do
  cwd war_dir
  command "jar xf #{solr_pre_war}"
  not_if { ::File.exist?(war_package) }
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
    version '1.0.13'
    dest ::File.join(war_dir, 'WEB-INF', 'lib')
  end
end

# Prepare solr server configuration
template 'tomcat.xml' do
  path ::File.join(war_dir, 'META-INF', 'context.xml')
  source 'tomcat.xml.erb'
end

# Pack solr war
execute 'jar' do
  cwd war_dir
  command "jar -cfM #{war_package} -C #{war_dir} ."
  creates war_package
  not_if { ::File.exist?(war_package) }
end

# Move Packaged War
remote_file ::File.join(node[:chamber][:solr][:path], node[:chamber][:solr][:war_name] + '.war') do
  source 'file://' + war_package
  owner node[:chamber][:solr][:user]
  group node[:chamber][:solr][:group]
  mode 00644
end
