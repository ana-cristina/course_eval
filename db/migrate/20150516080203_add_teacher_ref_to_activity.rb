class AddTeacherRefToActivity < ActiveRecord::Migration
  def change
    add_reference :activities, :teacher, index: true, foreign_key: true
    add_column :activities, :year, :integer
    add_column :activities, :semester, :integer
    add_column :activities, :activity_type, :string
  end
end
