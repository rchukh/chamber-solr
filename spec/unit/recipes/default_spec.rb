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
    runner.converge(described_recipe)
  end

  it 'create directory for solr home' do
    expect(chef_run).to create_directory('/usr/local/solr').with(
      user: 'user',
      group: 'group',
      mode: 00755
    )
  end

  it 'create directory for solr home' do
    expect(chef_run).to create_directory('/usr/local/solr/logs').with(
      user: 'user',
      group: 'group',
      mode: 00755
    )
  end

  it 'create solr.xml config' do
    expect(chef_run).to create_template('/usr/local/solr/solr.xml')
  end
end
