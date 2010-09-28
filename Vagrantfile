Vagrant::Config.run do |config|
  config.vm.box = "base"
  config.vm.provisioner = :chef_solo
  config.chef.cookbooks_path = ["opscode-cookbooks", "cookbooks"]
  config.chef.run_list.clear  
  config.chef.add_recipe("onesocialweb-plugin")

  config.vm.forward_port("web", 80, 4567)
  config.vm.forward_port("openfire_admin", 9090, 9090)
  config.vm.forward_port("openfire_xmpp", 7070, 7070)
  config.vm.forward_port("openfire_xmpp1", 5269, 5269)
  config.vm.forward_port("openfire_xmpp2", 5222, 5222)
  config.vm.forward_port("openfire_xmpp3", 5223, 5223)
  config.chef.log_level = :debug
  config.vm.boot_mode = "gui"
end
