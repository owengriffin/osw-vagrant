

The Vagrantfile will allow you to quickly provision a virtual machine with an Openfire server. This is intended to make testing easier.

To get started you will need to install Vagrant. From the command line this should be simple:

    $ gem install vagrant
    
If you are using an Ubuntu system you may need administrator privileges.

You then need to install a 'base' system. This is an image of a virtual machine onto which this script will install OneSocialWeb. Also from the command line:

    $ vagrant box add base http://files.vagrantup.com/base.box
    
This will install an Ubuntu Hardy LTS virtual machine.

From within the source folder you now need to start the virtual machine. This is done using the `vagrant up` command. You should see _lots_ of output from this command.

    $ vagrant up
    
Once this command is complete you should be able to access the Openfire server on localhost. 
