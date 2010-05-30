#!/usr/bin/env ruby
require 'rubygems'
require 'mechanize'

sleep 60

agent = Mechanize.new
agent.get("http://localhost:9090/plugin-admin.jsp") do |page|
  page = page.form_with(:name => "loginForm") do |form|
    form['username']="admin"
    form['password']="admin"
  end.submit
  puts page.body
  page = page.form_with(:method => 'POST') do |form|
    form.file_uploads.first.file_name = ARGV[0]
  end.submit
end
