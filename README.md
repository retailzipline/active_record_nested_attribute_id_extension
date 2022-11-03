# ActiveRecord Nested Attribute ID support

ActiveRecord's nested attributes do not allow you to provide an id when creating
the nested objects. If you provide an ID, it results in an ActiveRecord::NotFound
error message.

This patches ActiveRecord so that you can override that behavior by passing an
attribute named `_create` when creating nested objects. This is similar to the
`_destroy` behavior.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'active_record_nested_attribute_id_extension'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install active_record_nested_attribute_id_extension
```

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
