# Encoding: utf-8

Sequel.migration do
  up do
    create_table(:products) do
      primary_key :id, :type => Bignum
      String :name
      String :description
      timestamp :created_at
      timestamp :updated_at

      index :name
    end
  end

  down do
    drop_table(:products)
  end
end
