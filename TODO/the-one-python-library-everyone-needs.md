> * 原文地址：[The One Python Library Everyone Needs](https://glyph.twistedmatrix.com/2016/08/attrs.html)
* 原文作者：[glyph](https://twitter.com/glyph)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：


Why, you ask? Don’t ask. Just use it.

Okay, fine. Let me back up.

I love Python; it’s been my primary programming language for 10+ years and despite a number of [interesting](https://www.haskell.org) [developments](https://www.rust-lang.org) in the interim I have no plans to switch to anything else.

But Python is not without its problems. In some cases it encourages you to do the wrong thing. Particularly, there is a deeply unfortunate proliferation of class inheritance and the [God-object](https://en.wikipedia.org/wiki/God_object) anti-pattern in many libraries.

One cause for this might be that Python is a highly accessible language, so less experienced programmers make mistakes that they then have to [live with forever](https://twistedmatrix.com/documents/current/core/development/policy/compatibility-policy.html).

But I think that perhaps a more significant reason is the fact that Python sometimes punishes you for trying to do the right thing.

The “right thing” in the context of object design is to make lots of small, self-contained classes that do [one thing](https://en.wikipedia.org/wiki/Single_responsibility_principle) and do it [well](https://www.destroyallsoftware.com/talks/boundaries). For example, if you notice your object is starting to accrue a lot of private methods, perhaps you should be making those “public” methods of a private attribute. But if it’s tedious to do that, you probably won’t bother.

Another place you probably should be defining an object is when you have a bag of related data that needs its relationships, invariants, and behavior explained. Python makes it soooo easy to just define a tuple or a list. The first couple of times you type `host, port = ...` instead of `address = ...` it doesn’t seem like a big deal, but then soon enough you’re typing `[(family, socktype, proto, canonname, sockaddr)] = ...` everywhere and your life is filled with regret. That is, if you’re lucky. If you’re _not_ lucky, you’re just maintaining code that does something like `values[0][7][4][HOSTNAME][“canonical”]` and your life is filled with garden-variety _pain_ rather than the more complex and nuanced emotion of regret.

* * *

This raises the question: _is_ it tedious to make a class in Python? Let’s look at a simple data structure: a 3-dimensional cartesian coordinate. It starts off simply enough:

So far so good. We’ve got a 3 dimensional point. What next?


```
class Point3D(object):
    def __init__(self, x, y, z):

```

Well, that’s a bit unfortunate. I just want a holder for a little bit of data, and I’ve already had to override a special method from the Python runtime with an internal naming convention? Not _too_ bad, I suppose; _all_ programming is weird symbols after a fashion.

At least I see my attribute names in there, that makes sense.


```
class Point3D(object):
    def __init__(self, x, y, z):
        self.x

```

I already said I wanted an `x`, but now I have to assign it as an attribute...


```
class Point3D(object):
    def __init__(self, x, y, z):
        self.x = x

```

... to `x`? Uh, _obviously_ ...


```
class Point3D(object):
    def __init__(self, x, y, z):
        self.x = x
        self.y = y
        self.z = z

```

... and now I have to do that once for every attribute, so this actually _scales_ poorly? I have to type every attribute name 3 times?!?

Oh well. At least I’m done now.


```
class Point3D(object):
    def __init__(self, x, y, z):
        self.x = x
        self.y = y
        self.z = z
    def __repr__(self):

```

Wait what do you mean I’m not done.


```
class Point3D(object):
    def __init__(self, x, y, z):
        self.x = x
        self.y = y
        self.z = z
    def __repr__(self):
        return (self.__class__.__name__ +
                ("(x={}, y={}, z={})".format(self.x, self.y, self.z)))

```

Oh come _on_. So I have to type every attribute name _5_ times, if I want to be able to see what the heck this thing is when I’m debugging, which a tuple would have given me for free?!?!?


```
class Point3D(object):
    def __init__(self, x, y, z):
        self.x = x
        self.y = y
        self.z = z
    def __repr__(self):
        return (self.__class__.__name__ +
                ("(x={}, y={}, z={})".format(self.x, self.y, self.z)))
    def __eq__(self, other):
        if not isinstance(other, self.__class__):
            return NotImplemented
        return (self.x, self.y, self.z) == (other.x, other.y, other.z)

```

_7_ times?!?!?!?


```
class Point3D(object):
    def __init__(self, x, y, z):
        self.x = x
        self.y = y
        self.z = z
    def __repr__(self):
        return (self.__class__.__name__ +
                ("(x={}, y={}, z={})".format(self.x, self.y, self.z)))
    def __eq__(self, other):
        if not isinstance(other, self.__class__):
            return NotImplemented
        return (self.x, self.y, self.z) == (other.x, other.y, other.z)
    def __lt__(self, other):
        if not isinstance(other, self.__class__):
            return NotImplemented
        return (self.x, self.y, self.z) < (other.x, other.y, other.z)

```

_9_ times?!?!?!?!?


```
from functools import total_ordering
@total_ordering
class Point3D(object):
    def __init__(self, x, y, z):
        self.x = x
        self.y = y
        self.z = z
    def __repr__(self):
        return (self.__class__.__name__ +
                ("(x={}, y={}, z={})".format(self.x, self.y, self.z)))
    def __eq__(self, other):
        if not isinstance(other, self.__class__):
            return NotImplemented
        return (self.x, self.y, self.z) == (other.x, other.y, other.z)
    def __lt__(self, other):
        if not isinstance(other, self.__class__):
            return NotImplemented
        return (self.x, self.y, self.z) < (other.x, other.y, other.z)

```

Okay, whew - 2 more lines of code isn’t great, but now at least we don’t have to define all the other comparison methods. But _now_ we’re done, right?


```
from unittest import TestCase
class Point3DTests(TestCase):

```

You know what? I’m done. 20 lines of code so far and we don’t even have a class that _does_ anything; the hard part of this problem was supposed to be the quaternion solver, not “make a data structure which can be printed and compared”. I’m _all in_ on piles of undocumented garbage tuples, lists, and dictionaries it is; defining proper data structures well is way too hard in Python.

* * *

## `namedtuple` to the (not really) rescue

The standard library’s answer to this conundrum is [`namedtuple`](https://docs.python.org/2.7/library/collections.html#collections.namedtuple). While a valiant first draft (it bears many similarities to [my own](https://github.com/twisted/epsilon/blob/master/epsilon/structlike.py) somewhat embarrassing and antiquated entry in this genre) `namedtuple` is unfortunately unsalvageable. It exports a huge amount of undesirable public functionality which would be a huge compatibility nightmare to maintain, and it doesn’t address half the problems that one runs into. A full enumeration of its shortcomings would be tedious, but a few of the highlights:

*   Its fields are accessable as numbered indexes whether you want them to be or not. Among other things, this means you can’t have private attributes, because they’re exposed via the apparently public `__getitem__` interface.
*   It compares equal to a raw `tuple` of the same values, so it’s easy to get into bizarre type confusion, especially if you’re trying to use it to migrate _away_ from using `tuple`s and `list`s.
*   It’s a tuple, so it’s _always_ immutable. Sort of.

As to that last point, either you can use it like this:


```
Point3D = namedtuple('Point3D', ['x', 'y', 'z'])

```

in which case it doesn’t _look_ like a type in your code; simple syntax-analysis tools without special cases won’t recognize it as one. You can’t give it any other behaviors this way, since there’s nowhere to put a method. Not to mention the fact that you had to type the class’s name twice.

Alternately you can use inheritance and do this:


```
class Point3D(namedtuple('_Point3DBase', 'x y z'.split()])):
    pass

```

This gives you a place you can put methods, and a docstring, and generally have it look like a class, which it is... but in return you now have a weird internal name (which, by the way, is what shows up in the `repr`, not the class’s actual name). However, you’ve also silently made the attributes not listed here mutable, a strange side-effect of adding the `class` declaration; that is, unless you add `__slots__ = 'x y z'.split()` to the class body, and then we’re just back to typing every attribute name twice.

And this doesn’t even mention the fact that science has proven that [you shouldn’t use inheritance](https://www.youtube.com/watch?v=3MNVP9-hglc).

So, `namedtuple` can be an improvement if it’s all you’ve got, but only in some cases, and it has its own weird baggage.

* * *

## Enter The `attr`

So here’s where my favorite mandatory Python library comes in.

Let’s re-examine the problem above. How do I make `Point3D` with `attrs`?

Since this isn’t built into the language, we do have to have 2 lines of boilerplate to get us started: the import and the decorator saying we’re about to use it.


```
import attr
@attr.s
class Point3D(object):

```

Look, no inheritance! By using a class decorator, `Point3D` remains a Plain Old Python Class (albeit with some helpful double-underscore methods tacked on, as we’ll see momentarily).


```
import attr
@attr.s
class Point3D(object):
    x = attr.ib()

```

It has an attribute called `x`.


```
import attr
@attr.s
class Point3D(object):
    x = attr.ib()
    y = attr.ib()
    z = attr.ib()

```

And one called `y` and one called `z` and we’re done.

We’re done? Wait. What about a nice string representation?


```
>>> Point3D(1, 2, 3)
Point3D(x=1, y=2, z=3)

```

Comparison?


```
>>> Point3D(1, 2, 3) == Point3D(1, 2, 3)
True
>>> Point3D(3, 2, 1) == Point3D(1, 2, 3)
False
>>> Point3D(3, 2, 3) > Point3D(1, 2, 3)
True

```

Okay sure but what if I want to extract the data defined in explicit attributes in a format appropriate for JSON serialization?


```
>>> attr.asdict(Point3D(1, 2, 3))
{'y': 2, 'x': 1, 'z': 3}

```

Maybe that last one was a little on the nose. But nevertheless, it’s one of many things that becomes easier because `attrs` lets you _declare the fields on your class_, along with lots of potentially interesting metadata about them, and then get that metadata back out.

```
>>> import pprint
>>> pprint.pprint(attr.fields(Point3D))
(Attribute(name='x', default=NOTHING, validator=None, repr=True, cmp=True, hash=True, init=True, convert=None),
 Attribute(name='y', default=NOTHING, validator=None, repr=True, cmp=True, hash=True, init=True, convert=None),
 Attribute(name='z', default=NOTHING, validator=None, repr=True, cmp=True, hash=True, init=True, convert=None))

```

I am not going to dive into _every_ interesting feature of `attrs` here; you can read the documentation for that. Plus, it’s well-maintained, so new goodies show up every so often and I might miss something important. But `attrs` does a few key things that, once you have them, you realize that Python was sorely missing before:

1.  It lets you define types _concisely_, as opposed to the normally quite verbose manual `def __init__...`. Types without typing.
2.  It lets you say _what you mean directly_ with a declaration rather than expressing it in a roundabout imperative recipe. Instead of “I have a type, it’s called MyType, it has a constructor, in the constructor I assign the property ‘A’ to the parameter ‘A’ (and so on)”, you say “I have a type, it’s called MyType, it has an attribute called `a`”, and behavior is derived from that fact, rather than having to later _guess_ about the fact by reverse engineering it from behavior (for example, running `dir` on an instance, or looking at `self.__class__.__dict__`).
3.  It _provides useful default behavior_, as opposed to Python’s sometimes-useful but often-backwards defaults.
4.  It adds a place for you to put _a more rigorous implementation later_, while starting out simple.

Let’s explore that last point.

## Progressive Enhancement

While I’m not going to talk about _every_ feature, I’d be remiss if I didn’t mention a few of them. As you can see from those mile-long `repr()`s for `Attribute` above, there are a number of interesting ones.

For example: you can validate attributes when they are passed into an `@attr.s`-ified class. Our Point3D, for example, should probably contain numbers. For simplicity’s sake, we could say that that means instances of `float`, like so:

<div style="">

```
import attr
from attr.validators import instance_of
@attr.s
class Point3D(object):
    x = attr.ib(validator=instance_of(float))
    y = attr.ib(validator=instance_of(float))
    z = attr.ib(validator=instance_of(float))

```

The fact that we were using `attrs` means we have a place to _put_ this extra validation: we can just add type information to each attribute as we need it. Some of these facilities let us avoid other common mistakes. For example, this is a popular “spot the bug” Python interview question:


```
class Bag:
    def __init__(self, contents=[]):
        self._contents = contents
    def add(self, something):
        self._contents.append(something)
    def get(self):
        return self._contents[:]

```

Fixing it, of course, becomes this:


```
class Bag:
    def __init__(self, contents=None):
        if contents is None:
            contents = []
        self._contents = contents

```

adding two extra lines of code.

`contents` inadvertently becomes a global varible here, making all `Bag` objects not provided with a different list share the same list. With `attrs` this instead becomes:


```
@attr.s
class Bag:
    _contents = attr.ib(default=attr.Factory(list))
    def add(self, something):
        self._contents.append(something)
    def get(self):
        return self._contents[:]

```

There are several other features that `attrs` provides you with opportunities to make your classes both more convenient and more correct. Another great example? If you want to be strict about extraneous attributes on your objects (or more memory-efficient on CPython), you can just pass `slots=True` at the class level - e.g. `@attr.s(slots=True)` - to automatically turn your existing `attrs` declarations a matching [`__slots__` attribute](https://docs.python.org/3.5/reference/datamodel.html#object.__slots__). All of these handy features allow you to make better and more powerful use of your `attr.ib()` declarations.

* * *

## The Python Of The Future

Some people are excited about eventually being able to program in Python 3 everywhere. What _I’m_ looking forward to is being able to program in Python-with-`attrs` everywhere. It exerts a subtle, but positive, design influence in all the codebases I’ve seen it used in.

Give it a try: you may find yourself surprised at places where you’ll now use a tidily explained class, where previously you might have used a sparsely-documented tuple, list, or a dict, and endure the occasional confusion from co-maintainers. Now that it’s so easy to have structured types that clearly point in the direction of their purpose (in their `__repr__`, in their `__doc__`, or even just in the names of their attributes), you might find you’ll use a lot more of them. Your code will be better for it; I know mine has been.


* * *

1.  Scare quotes here because the attributes aren’t meaningfully exposed to the _caller_, they’re just named publicly. This pattern, getting rid of private methods entirely and having only private attributes, probably deserves its own post... ↩

2.  And we hadn’t even gotten to the really exciting stuff yet: type validation on construction, default mutable values... ↩

