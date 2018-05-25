# Preferable allows defining preference accessor methods.
#
# A class including Preferable must implement #preferences which should return
# an object responding to .fetch(key), []=(key, val), and .delete(key).
#
# The generated writer method performs typecasting before assignment into the
# preferences object.
#
# Examples:
#
#   # ActiveRecord::Base includes Preferable and defines preferences as a serialized
#   # column.
#   class Settings < ActiveRecord::Base
#     preference :color,       :string,  default: 'red'
#     preference :temperature, :integer, default: 21
#   end
#
#   s = Settings.new
#   s.preferred_color # => 'red'
#   s.preferred_temperature # => 21
#
#   s.preferred_color = 'blue'
#   s.preferred_color # => 'blue'
#
#   # Typecasting is performed on assignment
#   s.preferred_temperature = '24'
#   s.preferred_temperature # => 24
#
#   # Modifications have been made to the .preferences hash
#   s.preferences #=> {color: 'blue', temperature: 24}
#
#   # Save the changes. All handled by activerecord
#   s.save!
module Preferences::Preferable
  extend ActiveSupport::Concern

  included do
    extend Preferences::PreferableClassMethods
  end

  def get_preference(name)
    has_preference! name
    send self.class.preference_getter_method(name)
  end

  def set_preference(name, value)
    has_preference! name
    send self.class.preference_setter_method(name), value
  end

  def preference_type(name)
    has_preference! name
    send self.class.preference_type_getter_method(name)
  end

  def preference_default(name)
    has_preference! name
    send self.class.preference_default_getter_method(name)
  end

  def has_preference!(name)
    raise NoMethodError, "#{name} preference not defined" unless has_preference? name
  end

  def has_preference?(name)
    respond_to? self.class.preference_getter_method(name)
  end

  def defined_preferences
    methods.grep(/\Apreferred_.*=\Z/).map do |pref_method|
      pref_method.to_s.gsub(/\Apreferred_|=\Z/, '').to_sym
    end
  end

  def default_preferences
    Hash[
      defined_preferences.map do |preference|
        [preference, preference_default(preference)]
      end
    ]
  end

  def clear_preferences
    preferences.keys.each { |pref| preferences.delete pref }
  end

  private

  def convert_preference_value(value, type)
    case type
    when :string, :text
      value.to_s
    when :password
      value.to_s
    when :decimal
      (value.presence || 0).to_s.to_d
    when :integer
      value.to_i
    when :boolean
      if value.is_a?(FalseClass) ||
         value.nil? ||
         value == 0 ||
         value =~ /^(f|false|0)$/i ||
         (value.respond_to?(:empty?) && value.empty?)
        false
      else
        true
      end
    when :array
      value.is_a?(Array) ? value : Array.wrap(value)
    when :hash
      case value.class.to_s
      when 'Hash'
        value
      when 'String'
        # only works with hashes whose keys are strings
        JSON.parse value.gsub('=>', ':')
      when 'Array'
        begin
          value.try(:to_h)
        rescue TypeError
          Hash[*value]
        rescue ArgumentError
          raise 'An even count is required when passing an array to be converted to a hash'
        end
      else
        value.class.ancestors.include?(Hash) ? value : {}
      end
    else
      value
    end
  end
end
