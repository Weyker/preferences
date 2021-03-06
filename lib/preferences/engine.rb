module Preferences
  class Engine < ::Rails::Engine
    config.preferences = Preferences
  end
end

ActiveRecord::Base.class_eval do
  include Preferences::Preferable
  serialize :preferences, Hash

  after_initialize do
    if has_attribute?(:preferences) && !preferences.nil?
      self.preferences = default_preferences.merge(preferences)
    end
  end
end
