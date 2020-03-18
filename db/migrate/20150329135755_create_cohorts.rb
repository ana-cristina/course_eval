class CreateCohorts < ActiveRecord::Migration
  def change
    create_table :cohorts do |t|
      t.string :name
      t.boolean :is_terminal
      t.integer :students_number
      t.integer :optionals_number

      t.timestamps null: false
    end
  end
end
