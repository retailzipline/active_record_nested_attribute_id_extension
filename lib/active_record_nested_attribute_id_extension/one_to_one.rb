module ActiveRecordNestedAttributeIdExtension
  module OneToOne
    def assign_nested_attributes_for_one_to_one_association(association_name, attributes)
      options = nested_attributes_options[association_name]
      if attributes.respond_to?(:permitted?)
        attributes = attributes.to_h
      end
      attributes = attributes.with_indifferent_access
      # Changed: Idenfity if a record is expected to be new even if it has an id
      force_new_record = attributes.delete("_create").present?
      # ---- end
      existing_record = send(association_name)

      if (options[:update_only] || !attributes["id"].blank?) && existing_record &&
          (options[:update_only] || existing_record.id.to_s == attributes["id"].to_s)
        assign_to_or_mark_for_destruction(existing_record, attributes, options[:allow_destroy]) unless call_reject_if(association_name, attributes)

      elsif attributes["id"].present? && !force_new_record # Changed
        raise_nested_attributes_record_not_found!(association_name, attributes["id"])

      elsif !reject_new_record?(association_name, attributes)
        # Changed: If it's expected to be a new record, we allow the ID to be assigned
        unassignable_keys = ActiveRecord::NestedAttributes::UNASSIGNABLE_KEYS
        unassignable_keys.delete("id") if force_new_record

        assignable_attributes = attributes.except(*unassignable_keys)
        # ---- end

        if existing_record && existing_record.new_record?
          existing_record.assign_attributes(assignable_attributes)
          association(association_name).initialize_attributes(existing_record)
        else
          method = :"build_#{association_name}"
          if respond_to?(method)
            send(method, assignable_attributes)
          else
            raise ArgumentError, "Cannot build association `#{association_name}'. Are you trying to build a polymorphic one-to-one association?"
          end
        end
      end
    end
  end
end
