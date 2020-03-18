class AddUuidToTeachers < ActiveRecord::Migration
  def change
    add_column :teachers, :uuid, :integer
    add_column :teachers, :department, :string
  end
end
