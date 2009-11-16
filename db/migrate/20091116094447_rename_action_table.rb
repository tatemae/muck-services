class RenameActionTable < ActiveRecord::Migration
  def self.up
    rename_table :action_types, :attention_types
    rename_column :attention_types, :action_type, :name
    rename_column :attention_types, :weight, :default_weight
    rename_column :attentions, :action_type, :attention_type_id
    change_column :attentions, :attention_type_id, :integer
    add_index :attentions, :attention_type_id
  end

  def self.down
    remove_index :attentions, :attention_type_id
    change_column :attentions, :attention_type_id, :string
    rename_column :attention_types, :default_weight, :weight
    rename_column :attentions, :attention_type_id, :action_type
    rename_column :attention_types, :name, :action_type
    rename_table :attention_types, :action_types
  end
end
