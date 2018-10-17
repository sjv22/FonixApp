class CreateFonixAuths < ActiveRecord::Migration[5.2]
  def change
    create_table :fonix_auths do |t|
      t.references :user, foreign_key: true	
      t.string :mobile_number
      t.string :random_code
      t.boolean :is_used

      t.timestamps
    end
  end
end

