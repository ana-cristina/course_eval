class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :title
      t.string :uid
      t.string :activity_type
      t.string :department
      t.integer :teacher_id
      t.string :teacher_full_name
      t.references :evaluation_session, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
