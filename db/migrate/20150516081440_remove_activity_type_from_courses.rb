class RemoveActivityTypeFromCourses < ActiveRecord::Migration
  def change
    remove_column :courses, :activity_type, :string
    remove_column :courses, :department, :string
    remove_column :courses, :teacher_id, :integer
    remove_column :courses, :teacher_full_name, :string
    remove_column :courses, :evaluation_session_id, :integer

  end
end
