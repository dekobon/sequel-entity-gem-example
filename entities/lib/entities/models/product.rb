# Encoding: utf-8

##
# Advertisers are entities that can manage or submit advertisements on behalf
# of businesses. Many times a business and an advertiser are the same entity.
class Product < Sequel::Model
  plugin :timestamps, update_on_create: true

  set_allowed_columns :id, :name, :icon_url, :cj_affiliate_id,
                      :phone_number, :contact_name, :use_twitter_icon,
                      :business

  one_to_one :business, key: :id, reciprocal: nil
  one_to_many :offers
end
