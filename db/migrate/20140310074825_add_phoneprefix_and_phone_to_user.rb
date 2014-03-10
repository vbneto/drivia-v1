class AddPhoneprefixAndPhoneToUser < ActiveRecord::Migration
  def change
    add_column :users, :phoneprefix, :string
    add_column :users, :phone, :integer
  end
end
