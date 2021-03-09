class CreateTrades < ActiveRecord::Migration[6.1]
  def change
    create_table :trades do |t|
      t.integer :base_experience_difference

      t.timestamps
    end
  end
end
