---
title: "Preferences"
---

## Overview

Preferences support preferences per model instance.
To implement preferences for a model, simply add a new column called `preferences`. This is an example migration for the `products` table:

```ruby
class AddPreferencesColumnToProducts < ActiveRecord::Migration[4.2]
  def up
    add_column :products, :preferences, :text
  end

  def down
    remove_column :products, :preferences
  end
end
```

This will work because `Product` is a subclass of `ActiveRecord::Base`. If found, the `preferences` attribute gets serialized into a `Hash` and merged with the default values.

As another example, you might want to add preferences for users to manage their notification settings. Just make sure your `User` model inherits from `ActiveRecord::Base` then add the `preferences` column. You'll then be able to define preferences for `User`s without adding extra columns to the database table.

Extensions may add to the Spree General Settings or create their own namespaced preferences.

The first several sections of this guide describe preferences in a very general way. If you're just interested in making modifications to the existing preferences, you can skip ahead to the [Configuring Spree Preferences section](#configuring-spree-preferences). If you would like a more in-depth understanding of the underlying concepts used by the preference system, please read on.

### Motivation

Preferences for models within an application are very common. Although the rule of thumb is to keep the number of preferences available to a minimum, sometimes it's necessary if you want users to have optional preferences like disabling e-mail notifications.

Both use cases are handled by Preferences. They are easy to define, provide quick cached reads, persist across restarts and do not require additional columns to be added to your models' tables.


## Defining Preferences

You can define preferences for a model within the model itself:

```ruby
class User < ActiveRecord::Base
  preference :hot_salsa, :boolean
  preference :dark_chocolate, :boolean, default: true
  preference :color, :string
  preference :favorite_number, :integer
  preference :language, :string, default: "English"
end
```

In the above model, five preferences have been defined:

* `hot_salsa`
* `dark_chocolate`
* `color`
* `favorite_number`
* `language`

For each preference, a data type is provided. The types available are:

* `boolean`
* `string`
* `password`
* `integer`
* `text`
* `array`
* `hash`

An optional default value may be defined which will be used unless a value has been set for that specific instance.

## Accessing Preferences

Once preferences have been defined for a model, they can be accessed either using the shortcut methods that are generated for each preference or the generic methods that are not specific to a particular preference.

### Shortcut Methods

There are several shortcut methods that are generated. They are shown below.

Query methods:

```ruby
user.prefers_hot_salsa? # => false
user.prefers_dark_chocolate? # => false
```

Reader methods:

```ruby
user.preferred_color      # => nil
user.preferred_language   # => "English"
```

Writer methods:

```ruby
user.prefers_hot_salsa = false         # => false
user.preferred_language = "English"    # => "English"
```

Check if a preference is available:

```ruby
user.has_preference? :hot_salsa
```

### Generic Methods

Each shortcut method is essentially a wrapper for the various generic methods shown below:

Query method:

```ruby
user.prefers?(:hot_salsa)       # => false
user.prefers?(:dark_chocolate)  # => false
```

Reader methods:

```ruby
user.preferred(:color)      # => nil
user.preferred(:language)   # => "English"
```

```ruby
user.get_preference :color
user.get_preference :language
```

Writer method:

```ruby
user.set_preference(:hot_salsa, false)     # => false
user.set_preference(:language, "English")  # => "English"
```

### Accessing All Preferences

You can get a hash of all stored preferences by accessing the `preferences` helper:

```ruby
user.preferences # => {"language"=>"English", "color"=>nil}
```

This hash will contain the value for every preference that has been defined for the model instance, whether the value is the default or one that has been previously stored.

### Default and Type

You can access the default value for a preference:

```ruby
user.preferred_color_default # => 'blue'
```

Types are used to generate forms or display the preference. You can also get the type defined for a preference:

```ruby
user.preferred_color_type # => :string
```
