require 'chefspec'

describe 'chamber-solr::default' do
  let(:platform) { 'centos' }
  let(:platform_version) { '6.5' }
  let(:chef_run) do
    runner = ChefSpec::SoloRunner.new(platform: platform, version: platform_version)
    runner.node.set['chamber']['solr']['user'] = 'user'
    runner.node.set['chamber']['solr']['group'] = 'group'
    runner.node.set['chamber']['solr']['home'] = '/usr/local/solr'
    runner.node.set['chamber']['solr']['log_dir'] = '/usr/local/solr/logs'
    runner.node.set['chamber']['solr']['path'] = '/usr/local/tomcat/webapps'
    runner.node.set['chamber']['solr']['webserver']['tomcat']['include_context'] = true

    runner.node.set['chamber']['solr']['war_name'] = 'solr-unit-test'
    runner.node.set['chamber']['solr']['custom_war_path']   = 'test.war'
    runner.converge(described_recipe)
  end

  it 'place custom solr.war at correct location' do
    expect(chef_run).to create_cookbook_file_if_missing('/usr/local/tomcat/webapps/solr-unit-test.war').with(
      user: 'user',
      group: 'group',
      mode: 00644
    )
  end
end
