require_relative "lib/active_record_nested_attribute_id_extension/version"

Gem::Specification.new do |spec|
  spec.name        = "active_record_nested_attribute_id_extension"
  spec.version     = ActiveRecordNestedAttributeIdExtension::VERSION
  spec.authors     = ["Jeremy Baker"]
  spec.email       = ["jeremy@retailzipline.com"]
  spec.homepage    = "https://github.com/retailzipline/active_record_nested_attribute_id_extension"
  spec.summary     = "Adds support for pre-generated IDs in ActiveRecord nested attributes"
  spec.description = "Adds support for pre-generated IDs in ActiveRecord nested attributes so that you can create GUIDs on the server side"
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/retailzipline/active_record_nested_attribute_id_extension"

  spec.files = Dir["lib/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "activerecord", "~> 6.1.5"
  spec.add_development_dependency "sqlite3", "~> 1.5"
end
