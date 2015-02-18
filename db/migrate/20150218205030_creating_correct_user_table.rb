class CreatingCorrectUserTable < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.text :identifier
      t.text :rootUrl

      t.timestamps null: false
    end
  end
end
