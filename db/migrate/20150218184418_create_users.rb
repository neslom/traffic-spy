class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.text :identifier
      t.text :root_url

      t.timestamps null: false
    end
  end
end
