class UpdateOptionalsNumberToCohorts < ActiveRecord::Migration[4.2]
  def change
    change_column :cohorts, :optionals_number, :integer, :default => 0
  end
end
