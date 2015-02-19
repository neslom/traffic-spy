class CreatePayloadTable < ActiveRecord::Migration
  def change
    create_table :payloads do |t|
      t.integer :user_id
      t.integer :url_id
      t.text :requestedAt
      t.integer :respondedIn
      t.integer :referral_id
      t.integer :request_id
      t.text :paramaters
      t.integer :event_id
      t.integer :user_agent_id
      t.integer :resolution_id
      t.text :ip
    end
  end
end
