require 'active_record/acts/list'

ActiveRecord::Base.send :include, ActiveRecord::Acts::List

