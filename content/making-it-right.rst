Making It Right
###############

:date: 2017-01-20 17:47
:tags: quality, ci, openstack, zuul, integration, testing
:category: code
:summary: A story of breaking downstream consumers, and fixing it

We broke a downstream project in the last week before their release deadline.
This is about making it right for them.

Today members of the Glace contributors team were alerted [1]_
that we had broken and blocked OpenStackClient with our change [2]_ to support
community images [3]_. Folks were already in the process of beginning to
diagnose the issue when my day started.

It became clear that we had lots of cooks in this particular kitchen so I
moved over to another VM where I was testing changes [4]_ to the
python-glanceclient project related to the community images feature.

A candidate fix for the breakage became available [5]_ from another contributor.
The change was small, one change to logic, and a new functional test. I
switched contexts to begin reviewing it and testing it. Zuul [6]_ was reporting
a long queue, as lots of projects are feeling the crunch of the clients release
deadline, Ocata-3 milestone and feature and string freezes coming quickly.
Because of this I expected Jenkins gates to take their time coming back with a
vote so I started automated tests featuring just the additional test and without
the community images commit as a baseline. While that was running I started
combing over the changes in detail.

I got distracted from this by an email that came in signaling something in
Rackspace that needed me to respond quickly. That dispatched I returned to
see that the baseline testing showed the additional test should pass before
the community images feature, which is what was expected. I smashed the keys
a bit and started a test run to test the fix with the community images
feature. The work email from before resurfaced again, and so I hammered out
another response, caught up on IRC traffic, and returned to that code review.

When I completed the review, I tabbed over to look at the tests again and as
hoped everything passed. I updated folks on IRC and we proceeded to tag the
as ready to be merged. All the while, Zuul was busy grinding away on that
backlog of work before it could start the first pass of testing for this fix.


Fast forward
------------

Jenkins reports that the fix failed to pass the multiple scenarios in testing.
Inspection reports a few broken functional tests, 23 in all. What did I do
wrong? At this point I see the same set of tests failing under different
scenarios, and those tests are all related to the v1 API. That's why I know I
screwed up the review and approved a bad patch. My suspicion is that I made a
mistake somewhere in set up of that second test run.

At this point, it's more important to get things fixed because downstream
projects are still broken. It's a Friday afternoon and I'm sure at this point
we have shot any productivity down there but nobody wants to come in to find
the world broken on a Monday morning on the week of a deadline, so I'm
expecting to kill non-critical distractions and get into it again. I know I'm
not alone in the desire to do that, but the original author of the fix has
finished up his workday and checked-out so we have one less core, and one less
set of eyeballs familiar with the context.

The failing tests are all functional tests, and all focused on the v1 API. The
failures seem to highlight a failure to create images (note: the candidate fix
that causes the failures was addressing an issue with updating images). That
leads me to suspect that the issue is with the specific change of the candidate
fix. I started combing through the file (related to the sqlalchemy db storage
engine, as opposed to the simple db storage engine which is the only other
concrete db engine supported. The change which broke things only touched the
sqlalchemy engine code, and the sqlalchemy engine code is specifically
exercised by some if not all of the failing tests, so that helps me choose
which engine to fix, but I inspected both as a means of contrasting them. I'm
staring at a function that runs if something is true, and some other thing that
happens otherwise... the pieces are coming together.

The important point here is that clues about the scope of the breakage are
invaluable in pinpointing potential causes. Identifying what is common among a
set of tests which break is a helpful step. In this case it was many tests
breaking because they all used a common bit of code to create an image in
Glance as part of setting the tests preconditions.

The whole thing started because there was a gap in the existing automated
testing, both functional and unit testing could have identified the problem
with the initial community images implementation but code coverage is always a
balancing act. The more tests you have, the safer you might be but time to
imagine them is limited when there are other features or bugs you could spend
that time on. And in any long-lived project the coverage you have tends to
never be good enough. I find it helpful to just keep my expectations low and
hope that the tests will catch stuff but never be surprised when a gap is
discovered. Expect that you are working with incomplete information.

The original candidate fix was crafted with the help of a functional test which
was used to first model the bug before the cause was identified. This is a
great way to begin pinning down the problem, not only because it allows you to
capture the information from a bug report but it gives you leverage toward
identifying the cause as you can quickly drive toward the point of the failure
by running the test, combined with debug breakpoints or trace logging as
breadcrumbs leaving a trail through the code. Finally having that test allows
you to verify your fix and address the gap in test coverage gives confidence
that you won't have to repeat this work later.

One final lesson is to be found in investigating why my testing of the first
candidate fix passed when they failed in Jenkins. For that I had to inspect my
shell history. The gist of it is that when I was juggling states with git I
ended up with an incomplete application of the candidate fix in my workspace.
Specifically I ended up without the change to the sqlalchemy engine at all. In
that case, good git habits and workspace hygiene is important. Managing
distractions is the other side of this because the point where I was
interrupted by email the first time is when I made my mistake in setting up
the workspace for the second run.

The fix is merged and the downstream projects are unblocked. Maybe Monday
will be less exciting.

  .. [1] `[openstack-dev] [osc][openstackclient][glance] broken image functional
    test <http://lists.openstack.org/pipermail/openstack-dev/2017-January/110575.html>`_
  .. [2] `OpenStack Change-Id: I94bc7708b291ce37319539e27b3e88c9a17e1a9f
    <https://review.openstack.org/#/c/369110/>`_
  .. [3] `Glance spec: Add community-level image sharing
    <http://specs.openstack.org/openstack/glance-specs/specs/newton/approved/glance/community_visibility.html>`_
  .. [4] `OpenStack Change-Id: If8c0e0843270ff718a37ca2697afeb8da22aa3b1
    <https://review.openstack.org/#/c/352892/>`_
  .. [5] `OpenStack Change-Id: I996fbed2e31df8559c025cca31e5e12c4fb76548
    <https://review.openstack.org/#/c/423499/>`_
  .. [6] `OpenStack Zuul -- common continuous integration service
    <http://status.openstack.org/zuul/>`_
