class CreateEvaluationSessionActivities < ActiveRecord::Migration
  def change
    create_table :eval_session_activities do |t|
      t.references :course, index: true, foreign_key: true
      t.references :evaluation_session_cohort, index: true, foreign_key: true
      t.boolean :is_optional
      t.references :teacher, index: true, foreign_key: true
      t.integer :year
      t.integer :semester
      t.string :activity_type
      t.references :evaluation_session, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
