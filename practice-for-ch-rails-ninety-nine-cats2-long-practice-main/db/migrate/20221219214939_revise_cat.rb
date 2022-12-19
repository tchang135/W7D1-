class ReviseCat < ActiveRecord::Migration[7.0]
  def change
    add_column :cats, :owner_id, :bigint
    add_foreign_key :cats, :users, column: :owner_id, primary_key: :id 

  end
end
