Write once, Read and rewrite many
=================================

:date: 2017-02-03 17:34
:tags: process, refactoring, style, python
:category: code
:summary: The story of a refactor


.. epigraph::

    “Indeed, the ratio of time spent reading versus writing is well over 10 to
    1. We are constantly reading old code as part of the effort to write new
    code. ...[Therefore,] making it easy to read makes it easier to write.”

    --  Robert C. Martin, Clean Code: A Handbook of Agile Software Craftsmanship

Most of my time in software development is spent reading and thinking about code
[1]_ rather than writing it. This is not a groundbreaking revelation [2]_ but it
is particularly true for me.

I tend to balance a little more on the side of preferring quality over speed of
delivery. That means when I write code I will often want to look at it and
shuffle the logic. The editing process is rewarding for me. I thrive on the
puzzle, in rearranging the pieces, shaving here and gluing there to make the
shape serve this purpose or that one better.

I got to exercise that recently when I was reviewing a change and find the
following logic proposed by folks, somewhat in jest: [3]_ [4]_

.. code-block:: python

    # Tao of Python says:
    #   if the implementation is hard to explain, it's a bad idea
    return reduce(lambda x, y: x or y,
                  map(lambda x: x.has_migrations(), migrations))


----

Myself, I like functional style solutions to problems. But in Python it can take
a form that looks unlike many others. The lambda syntax is a bit verbose. The
primitive building blocks to functional style like ``map``, ``filter`` and
``reduce`` functions are relegated to the corner and the alternatives are
promoted (moved from builtin space to functools in Python 3). All of this holds
with the Zen of Python [5]_.

The ``map`` usage here is basic. If you can't read that the purpose is to
generate a list of ``True`` of ``False`` values, one for each entry in the
``migrations`` list. It is the equivalent to either of the following:

.. code-block:: python

    # Tao of Python says:
    #   if the implementation is easy to explain, it may be a good idea
    def like_map(migrations):
      result = []
      for m in migrations:
        result.append(m.has_migrations())
      return result

    # Tao of Python says: flat is better than nested
    [x.has_migrations() for x in migrations]

----


But what is that ``reduce`` operation doing? To read that at a first pass it
helps to have experience working in functional languages in which case you might
have seen the pattern. Reduce will take N items as input and reduce them to a
single output, in this case ``True`` or ``False``. This reduce expression
(``x or y``) then will just ``or`` the list returned by the ``map`` operation.
If any ``m.has_migrations()`` for ``m`` in ``migrations``, then the final result
is ``True``, otherwise ``False``. We could simplify that logic to either of the
following:

.. code-block:: python

    # Tao of Python says: readability counts
    pending_migrations = [x.has_migrations() for x in migrations]
    return True in pending_migrations

    # Tao of Python says: simple is better than complex
    for m in migrations:
      if m.has_migrations:
        return True
    return False

----

Either of these would be a great solution. They are both explicit, simple, and
easy to explain.

The first is also flat and readable. The list comprehension [6]_ is the most
complex yet concise element here, but with a basic familiarity with
comprehensions it reads very well.

The second relies on syntax that anyone who has done a couple weeks of
programming in nearly any language can decipher (I avoided the use of for-else
because while it would be technically correct it is an unnecessary use of that
language feature and more verbose) but it has non-linear flow control and while
the logic is simple it doesn't convey meaning concisely.

We can do better.

.. code-block:: python

    # Tao of Python says: beautiful is better than ugly
    return any([x.has_migrations() for x in migrations])

----

Now the code reads beautifully. If you forgive the syntax and a bit of the
dialect of writing software, it expresses an idea simply:

  "Does any x has_migrations for each x in migrations?"

or

  "Does any object in this list have migrations to perform?"


When someone comes back to read this, it should take very little time to
comprehend regardless of their experience level with the language. When we
strive toward any of these last two sets of solutions and use the concise and
unambiguous elements of our language we place a lower working memory load [7]_
on ourselves and others. We are not likely to spend less time reading code, in
the end for a few reasons but if we apply this refinement technique in some
parts of a project that frees us to focus on the hard parts that really are
complex.

  .. [1] `MSDN Blogs: What do programmers really do anyway?
    <https://blogs.msdn.microsoft.com/peterhal/2006/01/04/what-do-programmers-really-do-anyway-aka-part-2-of-the-yardstick-saga/>`_

  .. [2] `MSDN Blogs: Code is read much more often than it is written, so plan
    accordingly <https://blogs.msdn.microsoft.com/oldnewthing/20070406-00/?p=27343>`_

  .. [3] `OpenStack Change-Id: Ie839e0f240436dce7b151de5b464373516ff5a64
    <https://review.openstack.org/#/c/392993/>`_

  .. [4] This logic is not in a tight loop, and doesn't operate over large data
    sets so the concerns of efficiency, performance, or memory optimization are
    not paramount in this case so I'm not going to mention them.

  .. [5] `Python PEP 20 -- The Zen of Python
    <https://www.python.org/dev/peps/pep-0020/>`_

  .. [6] `Python PEP 202  -- List Comprehensions
    <https://www.python.org/dev/peps/pep-0202/>`_

  .. [7] `Wikipedia: Working Memory
    <https://en.wikipedia.org/wiki/Working_memory>`_
