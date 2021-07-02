# Ansible Jumpbox Features

## Variable files and templates

### Jumpbox

#### variables - roles / jumpbox / vars / default.yml

   There are two sections here: unixgroups and unixusers. Each of these is a list of dictionaries of value to use when creating these users and groups.

   The idea here is that instead of manually creating users on the chart in the future, you just rerun the playbook. This will create new users and you will have 		consistent uid and gids for each object.

##### Keys directory
   Copy keys Users in the directory the format:

		User1.pub
		User2.pub


#### templates - roles / jumpbox / templates

##### etc_ssh_sshd_config.Debian.j2

​		This is the SSH server configuration that will be implemented in the jump box if you are running Ubuntu. It's close to the Ubuntu default, with the following 		changes:

   - Port 22

   - PermitRootLogin no

   - Password authentication no

   - Login GraceTime 30
