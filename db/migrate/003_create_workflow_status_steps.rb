class CreateWorkflowStatusSteps < ActiveRecord::Migration
  def self.up
    create_table :workflow_status_steps do |t|
      t.integer :workflow_status_id
      t.string :Comments
      t.integer :CompletedStatus
      t.string :Name
      t.integer :RunningStatus
      t.datetime :StartedDate

      t.timestamps
    end
  end

  def self.down
    drop_table :workflow_status_steps
  end
end
