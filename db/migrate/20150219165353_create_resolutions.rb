class CreateResolutions < ActiveRecord::Migration
  def change
    create_table :resolutions do |t|
      t.text :resolutionWidth
      t.text :resolutionHeight
    end
  end
end
