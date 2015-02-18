class ChangeRooturlColumn < ActiveRecord::Migration
  def change
    rename_column :users, :root_url, :rootUrl
  end
end
