# hello-world-chef

# Pre-requisites

ChefDk - https://downloads.getchef.com/chef-dk
  
Vagrant - https://www.vagrantup.com/downloads.html
  
Vagrant Plugins

  ```vagrant plugin install vagrant-berkshelf```
  
  ```vagrant plugin install vagrant-omnibus```
  
  ```vagrant plugin install vagrant-chef-zero```
  
  ```vagrant plugin install vagrant-vbguest```
  
Virtualbox - https://www.virtualbox.org/wiki/Downloads

# Cookbook
1. Runs Apt-get Update
2. Sets firewall to allow 22, 80 and 443
3. Installs Nginx
4. Installs app
5. Generates Self Signed SSL

# Testing
Run ```kitchen test``` in the root directory to Create, Converge, Verify, Test and Destroy an instance in Vagrant

The tests check:

1. Firewall Rules
2. Firewall is Running
3. Nginx is running
4. Server is listening on 80
5. Server is listening on 443
6. Server forwards 80 to 443
7. Webiste on 443 has expected "Hello World!" content



