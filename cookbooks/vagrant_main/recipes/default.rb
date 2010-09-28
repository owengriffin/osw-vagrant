# -*- coding: utf-8 -*-
include_recipe "apt"
include_recipe "mysql::client"
include_recipe "mysql::server"
include_recipe "openfire"
include_recipe "onesocialweb-plugin"
