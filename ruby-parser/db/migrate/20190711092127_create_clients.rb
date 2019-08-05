class CreateClients < ActiveRecord::Migration[5.2]
  def change
    create_table :clients do |t|
      t.string :country
      t.string :name
      t.string :oas

      t.timestamps
    end
  end
end
