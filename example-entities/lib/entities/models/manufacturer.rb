# Encoding: utf-8

##
# Manufacturers are another simple entity that have a relationship with proudcts.
class Manufacturer < Sequel::Model
  plugin :timestamps, update_on_create: true

  set_allowed_columns :name

  one_to_many :products
end
