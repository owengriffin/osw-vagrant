
# Download the openfire plugin if it does not already exist
remote_file "/vagrant/osw-openfire-plugin-0.6.0.tgz" do
  source "http://github.com/downloads/onesocialweb/osw-openfire-plugin/osw-openfire-plugin-0.6.0.tgz"
  not_if "test -f /vagrant/osw-openfire-plugin-0.6.0.tgz" 
end

# Extract the openfire plugin
execute "extract-plugin" do
  command "tar xvf /vagrant/osw-openfire-plugin-0.6.0.tgz"
  user "root"
  cwd "/vagrant/"
  action :run
  not_if "test -f /vagrant/osw-openfire-plugin-0.6.0/osw-openfire-plugin.jar" 
end

# Run the install_plugin.rb script
execute "install_plugin.rb" do
  command "ruby /vagrant/install_plugin.rb /vagrant/osw-openfire-plugin-0.6.0/osw-openfire-plugin.jar"
  user "root"
  action :run
end
