class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users, id: false  do |t|
      t.string :first_name
      t.string :last_name
      t.string :status
      t.string :email
      t.string :is_student
      t.string :is_teacher
      t.string :is_management
      t.string :is_admin
      t.primary_key :uid

      t.timestamps null: false
    end
  end
end
