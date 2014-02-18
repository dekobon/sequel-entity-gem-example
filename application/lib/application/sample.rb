# Encoding: utf-8

module Application
  class Sample
    def self.start
      # If you are going to have more than one thread accessing the db handle
      # at once, turn off the single_threaded parameter.
      #
      # The use_models parameter indicates that the entities database setup
      # method should load the entities as defined in the entities gem.
      #
      # Within this block we have an open connection to the database. At the
      # end of the block the connection should close.
      Database.db_setup(single_threaded: true, use_models: true) do |db|
        # Let's create a manufacturer
        manufacturer = Manufacturer.create(name: 'Dagmar Industries')

        product = Product.create(name: 'little widget',
                                 description: 'Generic product')
        product.manufacturer = manufacturer
        product.save

        puts "Product Name: #{product.name_in_title_case}"
      end
    end
  end
end
