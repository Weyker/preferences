require 'rails'

module Preferences
  autoload :Preferable, 'preferences/preferable'
  autoload :PreferableClassMethods, 'preferences/preferable_class_methods'

  module Decorators
    autoload :Base, 'preferences/decorators/base'
  end
end

require 'preferences/engine'
