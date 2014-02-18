# Encoding: utf-8

##
# Product is an example of a simple entity.
class Product < Sequel::Model
  plugin :timestamps, update_on_create: true

  set_allowed_columns :name, :description

  many_to_one :manufacturer, key: :manufacturer_id
end
