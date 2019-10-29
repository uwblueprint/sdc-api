class AddDetailsToQuestions < ActiveRecord::Migration[6.0]
  def change
    add_column :questions, :question, :string, null: false
    add_column :questions, :options, :string, array: true, default: [], null: false
    add_column :questions, :is_root, :boolean, null: false
  end
end
