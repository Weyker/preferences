module Preferences
  class Engine < ::Rails::Engine
    config.preferences = Preferences

    config.to_prepare do
      Preferences.base_model.constantize.class_eval do
        include Preferences::Preferable
        serialize :preferences, Hash

        after_initialize do
          if has_attribute?(:preferences) && !preferences.nil?
            self.preferences = default_preferences.merge(preferences)
          end
        end
      end
    end
  end
end
