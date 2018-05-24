module Preferences
  module Models
    class PreferenceObject < Preferences.base_model.constantize
      self.table_name = Preferences.preferences_object_table

      serialize :value

      validates :key, presence: true, uniqueness: { case_sensitive: false, allow_blank: true }
    end
  end
end
