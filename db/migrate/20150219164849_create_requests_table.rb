class CreateRequestsTable < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.text :requestType
    end
  end
end
