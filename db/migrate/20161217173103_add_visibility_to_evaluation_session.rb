class AddVisibilityToEvaluationSession < ActiveRecord::Migration
  def change
    add_column :evaluation_sessions, :visibility, :boolean, default: FALSE
  end
end
