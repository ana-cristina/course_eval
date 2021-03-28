class AddVisibilityToEvaluationSession < ActiveRecord::Migration[4.2]
  def change
    add_column :evaluation_sessions, :visibility, :boolean, default: false
  end
end
