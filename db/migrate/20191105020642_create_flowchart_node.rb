# frozen_string_literal: true

class CreateFlowchartNode < ActiveRecord::Migration[6.0]
  def change
    create_table :flowchart_nodes do |t|
      t.string :text, null: false
      t.string :header, null: false
      t.string :button_text
      t.string :next_question
      t.references :child_id, foreign_key: { to_table: :flowchart_nodes }
      t.references :sibling_id, foreign_key: { to_table: :flowchart_nodes }
      t.boolean :is_root, null: false
      t.references :flowchart_id, foreign_key: { to_table: :flowcharts }, null: false
      t.timestamps
    end
  end
end
