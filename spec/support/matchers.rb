def install_maven(resource_name)
  ChefSpec::Matchers::ResourceMatcher.new(
    :maven, :install, resource_name
  )
end

def put_maven(resource_name)
  ChefSpec::Matchers::ResourceMatcher.new(
    :maven, :put, resource_name
  )
end
