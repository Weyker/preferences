require 'rails'

module Preferences
  module Models
    autoload :PreferenceObject, 'preferences/models/preferences_object'
  end

  mattr_accessor :preferences_table
  @@preferences_table = 'preferences'

  mattr_accessor :base_model
  @@base_model = 'ActiveRecord::Base'

  def self.configuration
    yield self
  end
end

require 'preferences/engine'
