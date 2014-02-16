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

    it 'can find a manufacturer by name' do
      manufacturer = Manufacturer.find(name: 'Acme')
      manufacturer.wont_be_nil
      manufacturer[:id].wont_be_nil
      manufacturer[:name].must_equal 'Acme'
    end

    it "can create a manufacturer when it isn't found by name" do
      manufacturer = Manufacturer.find_or_create(name: 'Medfield College')
      manufacturer.wont_be_nil
      manufacturer[:id].wont_be_nil
      manufacturer[:name].must_equal 'Medfield College'
    end

    it 'can create an manufacturer with an associations' do
      manufacturer = Manufacturer.find(name: 'Acme').tap do |m|
        m.add_product Product.find(name: 'Widget')
        m.add_product Product.find(name: 'Flubber')
        m.save
      end

      manufacturer.products.tap do |p|
        p.must_include Product.find(name: 'Widget')
        p.must_include Product.find(name: 'Flubber')
      end
    end
  end
end
