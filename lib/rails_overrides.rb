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

