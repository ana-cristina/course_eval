class AddNeterminalToEvaluationSessions < ActiveRecord::Migration[4.2]
  def change
    add_column :evaluation_sessions, :neterminal, :boolean
  end
end
