class UpdateOptionalsNumberToCohorts < ActiveRecord::Migration
  def change
    change_column :cohorts, :optionals_number, :integer, :default => 0
  end
end
