# Encoding: utf-8
require_relative '../test_helper'

module Entities
  describe Product do
    let (:db) { Database.db_setup(single_threaded: true, use_models: true) }

    before do
      db.run 'TRUNCATE offers CASCADE'
      db.run 'TRUNCATE businesses CASCADE'
      db.run 'TRUNCATE advertisers CASCADE'
      db["INSERT INTO advertisers (name) VALUES ('Test 1')"].insert
    end

    after do
      Database.disconnect(db)
    end

    it 'can find an advertiser by name' do
      advertiser = Product.find(name: 'Test 1')
      advertiser.wont_be_nil
      advertiser[:id].wont_be_nil
      advertiser[:name].must_equal 'Test 1'
    end

    it "can create an advertiser when it isn't found by name" do
      advertiser = Product.find_or_create(name: 'Test 2')
      advertiser.wont_be_nil
      advertiser[:id].wont_be_nil
      advertiser[:name].must_equal 'Test 2'
    end

    it 'can create an advertiser with an associations' do
      advertiser = Product.create(name: 'Test 3')
      business = Business.new(name: 'Test Business Advertiser')
      advertiser.business = business
      advertiser.save

      advertiser.refresh
      advertiser.wont_be_nil
      advertiser.must_equal advertiser
      advertiser.business.must_equal business
    end
  end
end
