class CreateUrlTable < ActiveRecord::Migration
  def change
    create_table :urls do |t|
      t.text :url
    end
  end
end
