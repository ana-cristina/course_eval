class AddLastRefreshToEvaluationSession < ActiveRecord::Migration
  def change
    add_column :evaluation_sessions, :last_refresh, :datetime
  end
end
