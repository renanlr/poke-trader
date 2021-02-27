class CreatePokemons < ActiveRecord::Migration[6.1]
  def change
    create_table :pokemons do |t|
      t.string :name, null: false
      t.string :image_url
      t.integer :base_experience, null: false
      t.integer :trade_group, null: false
      t.references :trade, null: false, foreign_key: true

      t.timestamps
    end
  end
end
