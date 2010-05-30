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
  supports :restart => true, :start => true
  action [ :start ]
end

# Ensure that mechanize is installed
package "libxslt1-dev"
package "libxml2-dev"
gem_package "mechanize"

# Run the setup_openfire.rb script
execute "setup_openfire.rb" do
  command "ruby /vagrant/setup_openfire.rb"
  user "root"
  action :run
end

service "openfire" do
  supports :restart => true, :start => true
  action [ :restart ]
end

script "wait-for-start" do
  interpreter "ruby"
  user "root"
  code <<-EOH
sleep 90
EOH
end

# Restart the openfire server
service "openfire" do
  supports :restart => true, :start => true, :stop => true
  action [ :stop ]
end

script "wait-for-start" do
  interpreter "ruby"
  user "root"
  code <<-EOH
sleep 20
EOH
end

script "overwrite-admin-password" do
  interpreter "bash"
  user "root"
  code <<-EOH
 cat /usr/share/openfire/embedded-db/openfire.script
 echo "INSERT INTO OFUSER VALUES('admin','admin',NULL, 'Administrator','admin','0','0');" >> /usr/share/openfire/embedded-db/openfire.script
 EOH
end

service "openfire" do
  supports :restart => true, :start => true
  action [ :start ]
end
