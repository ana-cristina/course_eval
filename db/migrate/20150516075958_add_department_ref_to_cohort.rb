class AddDepartmentRefToCohort < ActiveRecord::Migration[4.2]
  def change
    add_reference :cohorts, :department, index: true, foreign_key: true
    add_column :cohorts, :year, :integer
    remove_column :evaluation_sessions, :neterminal, :boolean
    remove_column :evaluation_sessions, :start_date_terminal, :date
    remove_column :evaluation_sessions, :end_date_terminal, :date
  end
end
