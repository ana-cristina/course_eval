class AddNeterminalToEvaluationSessions < ActiveRecord::Migration
  def change
    add_column :evaluation_sessions, :neterminal, :boolean
  end
end
