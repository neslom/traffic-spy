class CreateReferralsTable < ActiveRecord::Migration
  def change
    create_table :referrals do |t|
      t.text :referredBy
    end
  end
end
