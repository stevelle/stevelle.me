.. title: Highs and Lows
.. slug: highs-and-lows
.. date: 2017-01-26 18:21:25 UTC-08:00
.. tags: process, draft
.. category: code
.. link:
.. description:
.. type: text

Many folks don't work in solitude. As a sidenote I have worked on solo projects
before and appreciate the unique experience that provides, but this post is
about working in a team.

One of the rewards of working in teams on software is that there are a lot of
opportunities to solve new problems and overcome more ambitious challenges. A
former coworker once observed (I paraphrase) that our job is to struggle, to be
challenged. As soon as we overcome one challenge, there is another one
waiting for us and it's time to move on to that. There is no time to rest on the
well understood problems.

If we are going to spend the great majority of our time struggling through the
next thing, it makes sense that we will feel our productivity ebb and flow as
we charge through the open to the next blockade, then slow to circumvent it.
This means a lot of our time is spent in diagnostic work, in exploration of the
problem, and in learning to use tools needed to make progress.




apt-get update && apt-get upgrade -y && apt-get install -y fail2ban vim tmux git
adduser stack
echo "stack ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
ssh stack@localhost
git clone https://git.openstack.org/openstack-dev/devstack
cd devstack
cat > local.conf

[[local|localrc]]
RECLONE=yes

# Credentials
DATABASE_PASSWORD=openstack
ADMIN_PASSWORD=openstack
SERVICE_PASSWORD=openstack
RABBIT_PASSWORD=openstack

# Enable Logging
LOGFILE=/opt/stack/logs/stack.sh.log
VERBOSE=True
LOG_COLOR=True
SCREEN_LOGDIR=/opt/stack/logs
