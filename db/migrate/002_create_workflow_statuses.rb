class CreateWorkflowStatuses < ActiveRecord::Migration
  def self.up
    create_table :workflow_statuses do |t|
      t.integer :CompletedStatus, :default => 0
      t.string :Name
      t.integer :RunningStatus
      t.datetime :StartedDate

      t.timestamps
    end
  end

  def self.down
    drop_table :workflow_statuses
  end
end
