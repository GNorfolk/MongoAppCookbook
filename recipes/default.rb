#
# Cookbook:: node-server
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

apt_update

package 'nginx'

service 'nginx' do 
	supports status: true, restart: true, reload: true
	action [:enable, :start]
end

remote_file '/tmp/node_installer' do
	source 'https://deb.nodesource.com/setup_6.x'
	action :create
end

execute "install nodejs source" do
	command "sh /tmp/node_installer"
end

package 'nodejs' do
	action :upgrade 
end

execute "install pm2" do
	command "npm install pm2 -g"
end

link '/etc/nginx/sites-enabled/default' do
	action :delete
end

link '/home/ubuntu/environment' do
	to '/home/ubuntu/Devops/environment'
end

template '/etc/nginx/sites-available/reverse-proxy.conf' do
	source 'reverse-proxy.conf.erb'
	owner 'root'
	group 'root'
	mode '0755'
end

link '/etc/nginx/sites-enabled/reverse-proxy.conf' do
	to '/etc/nginx/sites-available/reverse-proxy.conf'
end

service 'nginx' do
	action :restart
end