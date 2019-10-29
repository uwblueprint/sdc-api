class CreateEdges < ActiveRecord::Migration[6.0]
  def change
    create_table :edges do |t|
      t.references :question, foreign_key: {to_table: :questions}, null: false
      t.references :next_question, foreign_key: {to_table: :questions}, null: false
      t.boolean :is_child, null: false
    end
  end
end
