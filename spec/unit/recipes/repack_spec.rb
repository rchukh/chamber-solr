require 'chefspec'

describe 'chamber-solr::default' do
  before do
    @file_cache_path = Dir.mktmpdir
    Chef::Config[:file_cache_path] = @file_cache_path

    @download_dir = ::File.join(@file_cache_path, 'chamber-solr')
    @war_dir      = ::File.join(@file_cache_path, 'chamber-solr-extracted')
    @repacked_war = ::File.join(@download_dir, 'solr-unit-test.war')
    @original_war = ::File.join(@download_dir, 'solr-original.war')
  end

  let(:platform) { 'centos' }
  let(:platform_version) { '6.5' }
  let(:chef_run) do
    runner = ChefSpec::SoloRunner.new(platform: platform, version: platform_version)
    # Overriding file_cache_path set during Runner initialization
    Chef::Config[:file_cache_path] = @file_cache_path
    runner.node.set['chamber']['solr']['version'] = '4.10.1'
    runner.node.set['chamber']['solr']['user'] = 'user'
    runner.node.set['chamber']['solr']['group'] = 'group'
    runner.node.set['chamber']['solr']['home'] = '/usr/local/solr'
    runner.node.set['chamber']['solr']['log_dir'] = '/usr/local/solr/logs'
    runner.node.set['chamber']['solr']['path'] = '/usr/local/tomcat/webapps'
    runner.node.set['chamber']['solr']['webserver']['tomcat']['include_context'] = true
    runner.node.set['chamber']['solr']['war_name'] = 'solr-unit-test'
    runner.converge(described_recipe)
  end

  it 'installs a solr from maven library with the put action' do
    expect(chef_run).to put_maven('solr-original').with(
      artifact_id: 'solr',
      group_id: 'org.apache.solr',
      version: '4.10.1',
      packaging: 'war',
      dest: @download_dir
    )
  end

  it 'runs a execute with attributes' do
    expect(chef_run).to run_execute('extract solr').with(
      cwd: @war_dir,
      command: 'jar xf ' + @original_war
    )
  end

  it 'installs a additional libraries from maven library with the put action' do
    %w(log4j-over-slf4j slf4j-api jcl-over-slf4j).each do | libname |
      expect(chef_run).to install_maven(libname).with(
        group_id: 'org.slf4j',
        version: '1.7.7',
        dest: ::File.join(@war_dir, 'WEB-INF', 'lib')
      )
    end
    %w(logback-classic logback-core).each do | libname |
      expect(chef_run).to install_maven(libname).with(
        group_id: 'ch.qos.logback',
        version: '1.1.2',
        dest: ::File.join(@war_dir, 'WEB-INF', 'lib')
      )
    end
  end

  it 'create directory for solr home' do
    expect(chef_run).to create_directory(@war_dir + '/WEB-INF/classes').with(
      mode: 00755
    )
  end

  it 'create logback config' do
    expect(chef_run).to create_template(@war_dir + '/WEB-INF/classes/logback.xml')
  end

  it 'create tomcat context config' do
    expect(chef_run).to create_template(@war_dir + '/META-INF/context.xml')
  end

  it 'does not create tomcat context config' do
    chef_run.node.set['chamber']['solr']['webserver']['tomcat']['include_context'] = false
    chef_run.converge(described_recipe)

    expect(chef_run).to_not create_template(@war_dir + '/META-INF/context.xml')
  end

  it 'runs a execute to pack solr' do
    expect(chef_run).to run_execute('pack solr').with(
      cwd: @war_dir,
      command: 'jar -cfM ' + @repacked_war + ' -C ' + @war_dir + ' .',
      creates: @repacked_war
    )
  end

  it 'place solr.war at correct location' do
    expect(chef_run).to create_remote_file('/usr/local/tomcat/webapps/solr-unit-test.war').with(
      user: 'user',
      group: 'group',
      mode: 00644
    )
  end
end
