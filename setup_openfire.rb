#!/usr/bin/env ruby
require 'rubygems'
require 'mechanize'
require 'socket'

openfire = {
  :domain => Socket.gethostname,
  :password => "admin"
}

# Returns the form element, based on the given id
def get_form_by_action(page, action)
  form = page.search(".//form[@action='#{action}']")[0]
  form = Mechanize::Form.new(form, page.mech, page)
  return form
end

def title(page)
  puts page.search(".//title")[0].text
end

agent = Mechanize.new
agent.get("http://localhost:9090/index.jsp") do |page|
  page = page.form_with(:name => "sform").click_button
  title(page)
  page = page.form_with(:name => "f") do |form|
    form['domain'] = openfire[:domain]
  end.click_button
  title(page)
  form = get_form_by_action(page, "setup-datasource-settings.jsp")
  form.radiobuttons_with(:name => "mode").each do |field|
    if field.value == "embedded"
      field.check 
    else 
      field.uncheck
    end
  end
  button = form.button_with(:value => "Continue")
  page = form.click_button(button)
  page = page.form_with(:name => "profileform").click_button
  title(page)
  page = page.form_with(:name => "acctform") do |form|
    form['newPassword'] = openfire[:password]
    form['newPasswordConfirm'] = openfire[:password]
  end.click_button
  title(page)
end
