# This is a copy of the sortable_element_js helper which overrides the default in ActionView. This version is modifed 
# just slightly. We have placed two more options [:hoverclass,:accept] since there are part of the Scriptaculous 
# options withing its API. By adding there here, the options are now quoted correctly in the rendered JS code.
# 
module ActionView
  module Helpers
    module ScriptaculousHelper
      def sortable_element_js(element_id, options = {})
        options[:with]     ||= "Sortable.serialize(#{element_id.to_json})"
        options[:onUpdate] ||= "function(){" + remote_function(options) + "}"
        options.delete_if { |key, value| PrototypeHelper::AJAX_OPTIONS.include?(key) }
  
        [:tag, :overlap, :constraint, :hoverclass, :accept, :handle].each do |option|
          options[option] = "'#{options[option]}'" if options[option]
        end
  
        options[:containment] = array_or_string_for_javascript(options[:containment]) if options[:containment]
        options[:only] = array_or_string_for_javascript(options[:only]) if options[:only]
  
        %(Sortable.create(#{element_id.to_json}, #{options_for_javascript(options)});)
      end
    end
  end
end

# Making some modifications to acts_as_list:
# -------------------------------------------------------------------------------------------------------------------------
# 1) Added class method scope_column() so AAL objects can request their own scope column in some new private methods.
# 2) Removed (before_create :add_to_list_bottom) callback and replaced with (before_validation_on_create) with two methods
#    The first AAL standar add_to_list_top() moves all items down and the custom set_new_to_list_top() set the position to 
#    1 on the newly created item, all before validation so it works.
# 3) Added insert_at_new_scope_and_position() which is like like insert_at() but allows for a new scope_column which must
#    be assigned in the method's parameters.
# 
module ActiveRecord::Acts::List
  module ClassMethods
    alias_method :orig_acts_as_list, :acts_as_list
    def acts_as_list(options = {})
      configuration = { :column => "position", :scope => "1 = 1" }
      configuration.update(options) if options.is_a?(Hash)
      configuration[:scope] = "#{configuration[:scope]}_id".intern if configuration[:scope].is_a?(Symbol) && configuration[:scope].to_s !~ /_id$/
      if configuration[:scope].is_a?(Symbol)
        scope_condition_method = %(
          def scope_condition
            if #{configuration[:scope].to_s}.nil?
              "#{configuration[:scope].to_s} IS NULL"
            else
              "#{configuration[:scope].to_s} = \#{#{configuration[:scope].to_s}}"
            end
          end
        )
      else
        scope_condition_method = "def scope_condition() \"#{configuration[:scope]}\" end"
      end
      class_eval <<-EOV
        include ActiveRecord::Acts::List::InstanceMethods
        def acts_as_list_class
          ::#{self.name}
        end
        def position_column
          '#{configuration[:column]}'
        end
        def scope_column
          '#{options[:scope].to_s}'
        end
        #{scope_condition_method}
        before_validation_on_create  :add_to_list_top, :set_new_to_list_top
        after_destroy  :remove_from_list
      EOV
    end
  end
  module InstanceMethods
    def set_new_to_list_top
      self[position_column] = 1
    end
    def insert_at_new_scope_and_position(scope, position)
      remove_from_list
      self.update_attribute(scope_column, scope)
      increment_positions_on_lower_items(position)
      self.update_attribute(position_column, position)
    end
  end
end

