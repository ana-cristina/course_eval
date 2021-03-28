class CreateEvaluationSessions < ActiveRecord::Migration[4.2]
  def change
    create_table :evaluation_sessions do |t|
      t.date :start_date
      t.date :end_date
      t.integer :year
      t.integer :semester
      t.string :status
      t.boolean :terminal
      t.references :form, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
