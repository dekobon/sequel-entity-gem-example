# Encoding: utf-8

##
# Advertisers are entities that can manage or submit advertisements on behalf
# of businesses. Many times a business and an advertiser are the same entity.
class Product < Sequel::Model
  plugin :timestamps, update_on_create: true

  set_allowed_columns :name, :description

  many_to_one :manufacturer, key: :manufacturer_id
end
