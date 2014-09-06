use_inline_resources

action :create do
  remote_directory 'Solr core' do
    path ::File.join(node['chamber']['solr']['home'], new_resource.name)
    source new_resource.directory || new_resource.name
    cookbook new_resource.cookbook if new_resource.cookbook
    owner node['chamber']['solr']['user']
    group node['chamber']['solr']['group']
    action :create
  end
  new_resource.updated_by_last_action(true)
end
