.. title: Reproducing OpenStack Grenade gate job results
.. slug: reproducing-grenade-results
.. date: 2017-03-15 16:21:22 UTC-07:00
.. tags: openstack,grenade,zuul
.. category:
.. link:
.. description:
.. type: text

Step 1:
# Provision a new VM which could run a gate job.
# Prepare it with any personal customizations and tailor to your tool
# preferences appropriate to a disposable working environment.

Step 2:
# Prepare the host to emulate the gate
cd /opt # or somewhere you want to put stuff
git clone https://github.com/JohnVillalovos/devstack-gate-test.git
cd devstack-gate-test
./vm-setup.sh
su - jenkins

Step 2.5: [optional]
# Snapshot the instance here for convenience

Step 3:
# Execute the reproduction event
# [in a browser]
# - click the link of the correct gate job from the review you want to reproduce
# - find the ``reproduce.sh`` script in the ``logs`` directory
# - ``copy link location`` for this script

cd ..
wget [paste-url]
chmod u+x reproduce.sh
./reproduce.sh
