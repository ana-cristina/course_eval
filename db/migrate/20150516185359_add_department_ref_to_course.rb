class AddDepartmentRefToCourse < ActiveRecord::Migration
  def change
    add_reference :courses, :department, index: true, foreign_key: true
  end
end
