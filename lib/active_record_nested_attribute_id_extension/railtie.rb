module ActiveRecordNestedAttributeIdExtension
  class Railtie < ::Rails::Railtie
    initializer 'active_record_nested_attribute_id_extension.setup' do
      ActiveRecord::NestedAttributes.prepend ActiveRecordNestedAttributeIdExtension::Collection
      ActiveRecord::NestedAttributes.prepend ActiveRecordNestedAttributeIdExtension::OneToOne
    end
  end
end
