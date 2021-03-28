class AddLastRefreshToEvaluationSession < ActiveRecord::Migration[4.2]
  def change
    add_column :evaluation_sessions, :last_refresh, :datetime
  end
end
