# Encoding: utf-8
require_relative '../test_helper'

module Entities
  describe Product do
    let (:db) { Database.db_setup(single_threaded: true, use_models: true) }

    before do
      db.run 'TRUNCATE manufacturers CASCADE'
      db.run 'TRUNCATE products CASCADE'

      db["INSERT INTO manufacturers (name) VALUES ('Acme')"].insert
      db['INSERT INTO products (name, description) VALUES' +
         "('Widget', 'Awesome Widget')"].insert
      db['INSERT INTO products (name, description) VALUES' +
             "('Flubber', 'Flying Rubber')"].insert
    end

    after do
      Database.disconnect(db)
    end

    it 'can find an product by name' do
      product = Product.find(name: 'Flubber')
      product.wont_be_nil
      product[:id].wont_be_nil
      product[:name].must_equal 'Flubber'
    end

    it "can create an product when it isn't found by name" do
      product = Product.find_or_create(name: 'Gobstopper')
      product.wont_be_nil
      product[:id].wont_be_nil
      product[:name].must_equal 'Gobstopper'
    end

    it 'can create an product with an associations' do
      product = Product.create(name: 'Magic Tunnel')

      manufacturer = Manufacturer.find(name: 'Acme')
      product.manufacturer = manufacturer
      product.save

      product.refresh
      product.wont_be_nil
      product.must_equal product
      product.manufacturer.must_equal manufacturer
    end
  end
end
