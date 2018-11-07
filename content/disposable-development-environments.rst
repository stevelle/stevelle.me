Disposable Development Environments
===================================

:date: 2017-01-23 13:20
:tags: tools, environment, productivity
:category: code
:summary: Thinking about development environments

I might be taking things too far with my development environments, but I really
don't like the idea that my development environment might be special. That
could mean many things.

Consider the case where my development environment has lots of stuff installed
which might not be enumerated in the Developer Documentation or Getting Started
guide or README file that makes things work for me but keeps others from being
able to quickly have the same success with whatever environment they might be
starting from. That is a rotten way to onboard new team members or welcome new
contributors, so keeping yourself aware of what it takes to go from zero to
developing is important.

I deteste the similar case where my development environment has lots of stuff
installed which cause my environment to behave differently from an automated
testing environment or any place it might be deployed. There are a lot of ways
to get an advantage over this particular gremlin too.

Lastly, I loath the situation where you have to work on a new or temporary
device, or you end up having to nuke and start over with a fresh operating
system. Lose all produtivity while you install and customize your working
environment during production environment outage due to a critical bug one time
and you might feel the same.

So I realize that app containers are the hotness, but none of the apps I work on
for OpenStack or for Rackspace include manifests for the dominant container
orchestration tools. That isn't to say nobody has run them in Docker, but I'm
not really that interested in dinking around with deploying all the various
pieces needed and fixing all the broken windows along the way.

Take the Glance project as an example. A typical deploy of Glance requires
MariaDB, RabbitMQ, Glance API, Glance Registry, the ability to run Glance Manage
and Glance Cache, and possibly also a Glance Scrubber in daemon mode in order to
have a complete ecosystem. That is all needed just to use the filesystem storage
driver in the container. I don't really want to maintain 7 different app
containers on my development host box (murdering my battery life as they spin up
and down). That is neglecting the need to keep 3 versions of each manifest of
the deploy tools tailored to the needs of each branch of Glance (master an 2
stable branches) in service at a time as well as having each manifest accomodate
the various customizations needed in service configuration, and keep them all in
sync.

This is in part why we have Devstack [1]_ within the OpenStack community, as it
provides a ready-to-eat means of deploying and configuing all the pieces to a
single [virtual] host. That could be an OS container [2]_ (such as LXD [3]_) as
well, but whatever.

I work from any of two different Mac laptops a Windows desktop, or a Linux
workstation, but mostly I work from one of the laptops. The churn of builds and
package installs is slower locally and kills my laptop's battery life, so I use
virtual machines in the Rackspace public cloud for almost all of my work. But
this requires a fair bit of machinery, I want pip to install the right python
package versions of the OpenStack and Nova clients, and their prerequisites. I
want the right cloud.yml or open.rc file which are used to contain authorization
credentials and I want to ensure my SSH private key is used for authentication.
And even then, I don't want to use the OpenStack or Nova client directly, when
there are only two to three things I might want different between each virtual
machine instance I work from, (name, flavor, image).

So I go one step further. I install VirtualBox and Vagrant directly on the
laptop, and I pull down one private git repository in order to get the laptop
set up as a development environment.  From there it's as easy as changing
directory into the repository and entering one command.

.. code-block:: bash

  $ vagrant up && vagrant ssh

The git repository has a Vagrantfile which specifies a current distro release to
use as a development jumpbox. The provisioning scripting in the Vagrantfile sets
up all of the libraries, SSH Agent, and credentials for me under the vagrant
user and then pulls down another git repository [4]_ which contains a few more
shortcuts to simplify my work (at time of writing I have a bunch of changes on
my private git hosts which I haven't cloned to github so what's visible may not
even work but I assure you I have a git source which does should the laptop need
to be nuked) including setting up my shell, vim, etc. preferences inside the
cloud VM.

I can spin up new development environments for any project I want to work on
after that, isolating each project along with it's system and language-specific
package requirements, and the language specific tooling. Sometimes that is done
with Ansible playbooks, sometimes using project-specific bootstrapping scripts,
(all helpfully cloned into the Vagrant VM by the provisioning scripts) from the
Vagrant VM.

To recap: I navigate from the laptop where I do most of my work, to a VM on the
host, to a VM in the cloud where my workspace lives. It's a bit convoluted but
the battery drain isn't too bad (compared to just invoking ssh directly from the
laptop, which is an option but not always as convenient), all the bits are
highly agnostic to host OS, and the steps needed to get myself into a
productive mode on any given environment are really minimal and stable.

On a regular basis I seem to blow away the VM on the laptop and rebuild for one
reason or another and this has been remarkably stable over time, with only one
or two things I tweak every few months as I come up with more customizations or
resolve a new issue. Most recently I found that my VirtualBox upgraded to a
version more recent than that supported by Vagrant, so I just updated that and
everything started to hum again. On the other hand when I end up with any kind
of dependency hell on the jumpbox VM it's never further away than:

.. code-block:: bash

  $ vagrant destroy -f && vagrant up

All things considered, I could simplify this set up considerably by eliminating
the jumpbox VM with the use of a virtual environment to contain the bits needed
to connect to the various OpenStack clouds I might operate my development VMs
on. The problem there is of course that this sort of refactoring usually
happens at highly irregular intervals and I just haven't found the time [5]_.


.. [1] `Devstack <http://docs.openstack.org/developer/devstack/>`_
.. [2] `LinuxContainers.org <https://linuxcontainers.org/>`_
.. [3] `LXD <https://www.ubuntu.com/cloud/lxd>`_
.. [4] `github.com/stevelle/instancer <https://github.com/stevelle/instancer>`_
.. [5] `The cobblers children have no shoes <http://tvtropes.org/pmwiki/pmwiki.php/Main/TheCobblersChildrenHaveNoShoes>`_
