# Encoding: utf-8

Sequel.migration do
  up do
    create_table(:manufacturers) do
      primary_key :id, :type => Bignum
      String :name
      timestamp :created_at
      timestamp :updated_at

      index :name
    end

    create_table(:products) do
      primary_key :id, :type => Bignum
      String :name
      String :description

      foreign_key :manufacturer_id, :manufacturers

      timestamp :created_at
      timestamp :updated_at

      index :name
    end
  end

  down do
    drop_table(:products)
  end
end
