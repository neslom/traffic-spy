class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.text :eventName
    end
  end
end
