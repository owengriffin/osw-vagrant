# -*- coding: utf-8 -*-

# Automatically accept the Sun Java licence
script "accept-java-licence" do
  interpreter "bash"
  user "root"
  code <<-EOH
echo sun-java5-jdk shared/accepted-sun-dlj-v1-1 select true | /usr/bin/debconf-set-selections
echo sun-java5-jre shared/accepted-sun-dlj-v1-1 select true | /usr/bin/debconf-set-selections
echo sun-java6-jdk shared/accepted-sun-dlj-v1-1 select true | /usr/bin/debconf-set-selections
echo sun-java6-jre shared/accepted-sun-dlj-v1-1 select true | /usr/bin/debconf-set-selections
EOH
end

package "sun-java6-jdk"

# Download the latest OpenFire server
remote_file "/vagrant/openfire_3.6.4_all.deb" do
  source "http://www.igniterealtime.org/downloadServlet?filename=openfire/openfire_3.6.4_all.deb"
  checksum "ef143f2f017b23fac7b04572837a0001"
  not_if "test -f /vagrant/openfire_3.6.4_all.deb"
end

# Install the OpenFire server"
execute "install-openfire" do
  command "sudo dpkg -i /vagrant/openfire_3.6.4_all.deb"
  action :run
end

service "openfire" do
  supports :start => true, :stop => true
  action [ :stop ]
end

# Install the MySQL database
include_recipe "mysql::server"
Gem.clear_paths
require 'mysql'

execute "create #{node[:openfire][:db][:database]} database" do
  command "/usr/bin/mysqladmin -u root -p#{node[:mysql][:server_root_password]} create #{node[:openfire][:db][:database]}"
  not_if do
    m = Mysql.new("localhost", "root", @node[:mysql][:server_root_password])
    m.list_dbs.include?(@node[:openfire][:db][:database])
  end
end

execute "create mysql user #{@node[:openfire][:db][:user]}" do
  command "echo \"GRANT ALL PRIVILEGES ON *.* TO '#{node[:openfire][:db][:user]}'@'localhost' IDENTIFIED BY '#{@node[:openfire][:db][:password]}';GRANT ALL PRIVILEGES ON *.* TO '#{node[:openfire][:db][:user]}'@'%' IDENTIFIED BY '#{@node[:openfire][:db][:password]}'; flush privileges;\" | /usr/bin/mysql -u root -p#{node[:mysql][:server_root_password]}"
  not_if do
    m = Mysql.new("localhost", "root", @node[:mysql][:server_root_password])
    st = m.prepare("select User from mysql.user")
    st.execute
    st.fetch.include?(@node[:openfire][:db][:user])
  end
end

execute "import database dump" do
  command "/usr/bin/mysql -u root -p#{node[:mysql][:server_root_password]} #{node[:openfire][:db][:database]}< /vagrant/openfire.sql ; touch /vagrant/dump.complete"
  not_if "test -f /vagrant/dump.complete"
end

# Write the openfire configuration file
template "/etc/openfire/openfire.xml" do
  source "openfire.xml.erb"
  owner "openfire"
  group "openfire"
  variables({ :admin_port => 9090, :secure_port => 9091, :locale => "en"})
end

service "openfire" do
  supports :start => true, :stop => true
  action [ :stop ]
end

service "openfire" do
  supports :start => true, :stop => true
  action [ :start ]
end

script "wait-for-start" do
  interpreter "ruby"
  user "root"
  code <<-EOH
sleep 90
EOH
end
