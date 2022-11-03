module ActiveRecordNestedAttributeIdExtension
  module Collection
    def assign_nested_attributes_for_collection_association(association_name, attributes_collection)
      options = nested_attributes_options[association_name]
      if attributes_collection.respond_to?(:permitted?)
        attributes_collection = attributes_collection.to_h
      end

      unless attributes_collection.is_a?(Hash) || attributes_collection.is_a?(Array)
        raise ArgumentError, "Hash or Array expected for attribute `#{association_name}`, got #{attributes_collection.class.name} (#{attributes_collection.inspect})"
      end

      check_record_limit!(options[:limit], attributes_collection)

      if attributes_collection.is_a? Hash
        keys = attributes_collection.keys
        attributes_collection = if keys.include?("id") || keys.include?(:id)
          [attributes_collection]
        else
          attributes_collection.values
        end
      end

      association = association(association_name)

      existing_records = if association.loaded?
        association.target
      else
        # Changed: We check for _create so that ids for new objects do not get added to the lookup
        attribute_ids = attributes_collection.map { |a| !(a["_create"] || a[:_create]) && (a["id"] || a[:id]) }.compact
        attribute_ids.empty? ? [] : association.scope.where(association.klass.primary_key => attribute_ids)
      end

      attributes_collection.each do |attributes|
        if attributes.respond_to?(:permitted?)
          attributes = attributes.to_h
        end
        attributes = attributes.with_indifferent_access
        # Changed: Idenfity if a record is expected to be new even if it has an id
        force_new_record = attributes.delete("_create").present?

        # Changed: Alter the logic flow if new record
        if attributes["id"].blank? || force_new_record
          unless reject_new_record?(association_name, attributes)
            # Changed: If it's expected to be a new record, we allow the ID to be assigned
            unassignable_keys = ActiveRecord::NestedAttributes::UNASSIGNABLE_KEYS
            unassignable_keys.delete("id") if force_new_record

            association.reader.build(attributes.except(*unassignable_keys))
          end
        elsif existing_record = existing_records.detect { |record| record.id.to_s == attributes["id"].to_s }
          unless call_reject_if(association_name, attributes)
            # Make sure we are operating on the actual object which is in the association's
            # proxy_target array (either by finding it, or adding it if not found)
            # Take into account that the proxy_target may have changed due to callbacks
            target_record = association.target.detect { |record| record.id.to_s == attributes["id"].to_s }
            if target_record
              existing_record = target_record
            else
              association.add_to_target(existing_record, skip_callbacks: true)
            end

            assign_to_or_mark_for_destruction(existing_record, attributes, options[:allow_destroy])
          end
        else
          raise_nested_attributes_record_not_found!(association_name, attributes["id"])
        end
      end
    end
  end
end
