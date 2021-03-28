class AddDepartmentRefToCourse < ActiveRecord::Migration[4.2]
  def change
    add_reference :courses, :department, index: true, foreign_key: true
  end
end
