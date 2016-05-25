#
# Cookbook Name:: hello-world
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

include_recipe 'apt'

# apt get update
execute "apt-get update" do
  command "apt-get update"
  ignore_failure true
  action
 :nothing
end

include_recipe 'nginx'
include_recipe 'firewall'

# allow ports for webserver
firewall_rule 'http/https' do
  protocol :tcp
  port     [80, 443]
  action   :allow
end

# mkdir /var/www
directory "#{node['nginx']['default_root']}"

# template website
template "#{node['nginx']['default_root']}/index.html" do
  source 'index.html.erb'

  notifies :reload, 'service[nginx]', :delayed
end


# Generate and template SSLs
keys = {}

bash 'Generate Self-Signed Certs' do
  cwd '/etc/ssl'
  code <<-EOH
  umask 077
  openssl genrsa 4096 > #{node['app_name']}.key
  openssl req -new -subj "/C=US/ST=PA/L=Philadelphia/O=#{node['app_name']}/OU=#{node['app_name']}/CN=www.#{node['app_name']}" -key #{node['app_name']}.key -out #{node['app_name']}.csr
  openssl x509 -req -days 3650 -in #{node['app_name']}.csr -signkey #{node['app_name']}.key -out #{node['app_name']}.crt
  cat #{node['app_name']}.crt > #{node['app_name']}.pem
  EOH
  not_if do
    File.exist?("/etc/ssl/#{node['app_name']}.pem")
  end
end

template "/etc/ssl/#{node['app_name']}.pem" do
  source 'certificate.pem.erb'
  mode 0640
  variables(
    cert: keys['cert']
  )
end

template "/etc/ssl/#{node['app_name']}.key" do
  source 'certificate.key.erb'
  mode 0640
  variables(
    key: keys['key']
  )
end

template "#{node['nginx']['dir']}/sites-available/default" do
  source 'default.erb'
  owner  'root'
  group  node['root_group']
  mode   '0644'
  notifies :reload, 'service[nginx]', :delayed
end
