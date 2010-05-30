
openfire Mash.new unless attribute?("openfire")
openfire[:admin] = Mash.new unless openfire.has_key?(:admin)
openfire[:admin][:password] = "openfire"
