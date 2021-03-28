class AddDateRangeToEvaluationSessions < ActiveRecord::Migration[4.2]
  def change
    add_column :evaluation_sessions, :start_date_terminal, :date
    add_column :evaluation_sessions, :end_date_terminal, :date
  end
end
