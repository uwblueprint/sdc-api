# frozen_string_literal: true

class CreateFlowcharts < ActiveRecord::Migration[6.0]
  def change
    create_table :flowcharts do |t|
      t.string :title, null: false
      t.string :description, null: false
      t.integer :height, null: false
      t.timestamps
    end
  end
end
