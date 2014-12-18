class CreateProvider < ActiveRecord::Migration
  def up
    create_table :computer_systems do |t|
      t.belongs_to :configured_system, :type => :bigint
      t.timestamps
    end
    add_index :computer_systems, :configured_system_id

    create_table :configuration_profiles do |t|
      t.string     :name
      t.belongs_to :operating_system_flavor, :type => :bigint
      t.belongs_to :provider,                :type => :bigint
      t.string     :provider_ref
      t.timestamps
    end
    add_index :configuration_profiles, :operating_system_flavor_id
    add_index :configuration_profiles, :provider_id
    add_index :configuration_profiles, :provider_ref

    create_table :configuration_profile_scripts do |t|
      t.belongs_to :configuration_profile,   :type => :bigint
      t.belongs_to :operating_system_flavor, :type => :bigint
    end
    add_index :configuration_profile_scripts, [:configuration_profile_id, :operating_system_flavor_id],
              :name => :configuration_profile_scripts_i1
    add_index :configuration_profile_scripts, [:operating_system_flavor_id, :configuration_profile_id],
              :name => :configuration_profile_scripts_i2

    create_table :configuration_services do |t|
      t.belongs_to :provider, :type => :bigint
      t.string     :type
      t.timestamps
    end
    add_index :configuration_services, :provider_id

    create_table :configured_systems do |t|
      t.string     :hostname
      t.belongs_to :operating_system_flavor, :type => :bigint
      t.belongs_to :provider,                :type => :bigint
      t.string     :provider_ref
      t.string     :type
      t.timestamps
    end
    add_index :configured_systems, :operating_system_flavor_id
    add_index :configured_systems, :provider_id
    add_index :configured_systems, :provider_ref

    create_table :configured_system_scripts do |t|
      t.belongs_to :configured_system,    :type => :bigint
      t.belongs_to :customization_script, :type => :bigint
    end
    add_index :configured_system_scripts, [:configured_system_id, :customization_script_id],
              :name => :configured_system_scripts_i1
    add_index :configured_system_scripts, [:customization_script_id, :configured_system_id],
              :name => :configured_system_scripts_i2

    create_table :customization_scripts do |t|
      t.string     :name
      t.belongs_to :provider, :type => :bigint
      t.string     :provider_ref
      t.string     :type
      t.timestamps
    end
    add_index :customization_scripts, :provider_id
    add_index :customization_scripts, :provider_ref

    create_table :operating_system_flavors do |t|
      t.string     :name
      t.string     :description
      t.belongs_to :provider, :type => :bigint
      t.string     :provider_ref
      t.timestamps
    end
    add_index :operating_system_flavors, :provider_id
    add_index :operating_system_flavors, :provider_ref

    create_table :operating_system_flavor_scripts do |t|
      t.belongs_to :operating_system_flavor, :type => :bigint
      t.belongs_to :customization_script,    :type => :bigint
    end
    add_index :operating_system_flavor_scripts, [:operating_system_flavor_id, :customization_script_id],
              :name => :operating_system_flavor_scripts_i1
    add_index :operating_system_flavor_scripts, [:customization_script_id, :operating_system_flavor_id],
              :name => :operating_system_flavor_scripts_i2

    create_table :providers do |t|
      t.string  :name
      t.string  :hostname
      t.integer :port
      t.integer :verify_ssl
      t.string  :type
      t.string  :guid, :limit => 36
      t.timestamps
    end

    add_column :hardwares,         :computer_system_id, :bigint
    add_index  :hardwares,         :computer_system_id
    add_column :operating_systems, :computer_system_id, :bigint
    add_index  :operating_systems, :computer_system_id
  end

  def down
    remove_column :hardwares,         :computer_system_id
    remove_column :operating_systems, :computer_system_id

    drop_table :providers
    drop_table :operating_system_flavor_scripts
    drop_table :operating_system_flavors
    drop_table :customization_scripts
    drop_table :configured_system_scripts
    drop_table :configured_systems
    drop_table :configuration_services
    drop_table :configuration_profile_scripts
    drop_table :configuration_profiles
    drop_table :computer_systems
  end
end
