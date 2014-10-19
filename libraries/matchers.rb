if defined?(ChefSpec)
  ChefSpec.define_matcher 'chamber-solr'

  def create_chamber_solr_core(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new('chamber-solr', :create, resource_name)
  end
end
