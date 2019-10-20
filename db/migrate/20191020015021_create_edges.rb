class CreateEdges < ActiveRecord::Migration[6.0]
  def change
    create_table :edges do |t|
      t.references :question, foreign_key: {to_table: :questions}
      t.references :child, foreign_key: {to_table: :questions}
      t.references :sibling, foreign_key: {to_table: :questions}
    end
  end
end
