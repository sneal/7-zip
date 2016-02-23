resource_name :seven_zip_package

property :app, kind_of: String, name_property: true
property :source, kind_of: String, default: nil
property :owner, kind_of: String, default: nil
property :destination, kind_of: String, default: nil
property :checksum, kind_of: String, default: nil

action :install do
  include_recipe 'seven-zip'

  seven_zip_file = ::File.join(Chef::Config[:file_cache_path], "#{app}.7z")
  seven_zip_dest = new_resource.destination || ::File.join(ENV['SYSTEMDRIVE'], new_resource.app)

  directory seven_zip_dest do
    recursive true
  end

  remote_file seven_zip_file do
    source new_resource.source
    checksum new_resource.checksum if new_resource.checksum
    only_if { new_resource.source }
  end

  execute 'unzip seven_zip_file' do
    command %Q^#{::File.join(node['7-zip']['home'], '7z')} e -y -o"#{seven_zip_dest}" "#{seven_zip_file}"^
  end
end
