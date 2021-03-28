class AddUuidToTeachers < ActiveRecord::Migration[4.2]
  def change
    add_column :teachers, :uuid, :integer
    add_column :teachers, :department, :string
  end
end
