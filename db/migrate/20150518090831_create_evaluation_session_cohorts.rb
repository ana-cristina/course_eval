class CreateEvaluationSessionCohorts < ActiveRecord::Migration
  def change
    create_table :evaluation_session_cohorts do |t|
      t.string :name
      t.boolean :is_terminal
      t.integer :students_number
      t.integer :optionals_number
      t.references :department, index: true, foreign_key: true
      t.references :evaluation_session, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
