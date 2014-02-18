# Encoding: utf-8

##
# This is an example of extending product for a specific project without
# letting the extensions bleed into the shared entities.
class Product < Sequel::Model
  ##
  # @return the product name in title case
  def name_in_title_case
    name.titlecase
  end
end
