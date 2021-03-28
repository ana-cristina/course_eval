class AddEmailToTeachers < ActiveRecord::Migration[4.2]
  def change
    add_column :teachers, :email, :string
  end
end
