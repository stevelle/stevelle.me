#!/bin/bash
echo "deb http://stable.packages.cloudmonitoring.rackspace.com/ubuntu-14.04-x86_64 cloudmonitoring main" > /etc/apt/sources.list.d/rackspace-monitoring-agent.list
curl https://monitoring.api.rackspacecloud.com/pki/agent/linux.asc | sudo apt-key add -
apt-get update && apt-get install rackspace-monitoring-agent
rackspace-monitoring-agent --setup
service rackspace-monitoring-agent start
apt-get install iptables-persistent
# put the crt and key files into /var/www/secure/
