module Preferences::Decorators::Base
  extend ActiveSupport::Concern

  include Preferences::Preferable
  serialize :preferences, Hash

  after_initialize do
    if has_attribute?(:preferences) && !preferences.nil?
      self.preferences = default_preferences.merge(preferences)
    end
  end
end
