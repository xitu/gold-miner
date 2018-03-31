> * 原文地址：[Classes Without Classes](https://veriny.tf/classes-without-classes/)
> * 原文作者：[Fuyukai](https://veriny.tf/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/classes-without-classes.md](https://github.com/xitu/gold-miner/blob/master/TODO1/classes-without-classes.md)
> * 译者：
> * 校对者：

# Classes Without Classes

## Preface

Python's object model is incredibly powerful; you can override virtually everything, or hand out weird objects to anyone and have them accept it as if it is a normal object.

Python's OO is a descendant of smalltalk OO, where everything is an object, even objects and object types; especially functions. This made me wonder: is it possible to write classes without using classes?

## The code

The hefty code for this is down below. It's a very basic implementation, but it supports such edge cases as `__call__` (but not other magic methods, due to Magic Method loading alas). The explanation is then below that.

## What the heck?

This is some pretty advanced Python hackery that involves using some objects in a way they definitely weren't meant to be. We'll go through this in chunks.

#### The first helper

```
def _suspend_self(namespace, suspended):  
```

This is a scary signature. Suspension? That's never good. But we can work through this. The `_suspend_self` function is a simple implementation of `functools.partial` that works by capturing `namespace` in the outer function scope, "suspending" it in an inner function.

```
    def suspender(*args, **kwargs):
        return suspended(namespace, *args, **kwargs)
```

This inner function then calls the function being passed with the namespace as the first argument, essentially making a method wrapper as it would be implemented on a regular Python class. The rest of `_suspend_self` is just setting some attributes that reflection might use at some point (I probably missed some).

#### The beast

The next function along is `make_class`. What can we learn from its signature?

```
def make_class(locals: dict):  
    """
    Makes a class, from the locals of the callee.

    :param locals: The locals to build the class from.
    """
```

When something either asks for or just takes your local variables, it's never good. Usually, it's for scanning for something in a previous stack frame, or just hacking with your locals. In our case, it's the former; scanning your locals for functions to add to your class.

```
    # try and find a `__call__` to implement the call function
    # this is made as a function so that namespace and called can refer to eachother
    def call_maker():
        if '__call__' in locals and callable(locals['__call__']):
            return _suspend_self(namespace, locals['__call__'])

        def _not_callable(*args, **kwargs):
            raise TypeError('This is not callable')

        return _not_callable
```

This function is quite simple; it's a function that returns a function!
What this actually does is the following:

*   Check if you've defined a `__call__` in your function-class
*   If so, it makes it a method by suspending the namespace using `_suspend_self`, as described above.
*   If not, it returns a stub function that raises an error, the same as the default `__call__`.

#### The namespace

The namespace is a key part that I haven't explained yet. Every (for the most part) method on a class takes a `self` parameter as the first parameter, and that is the instance of the class that the function works on.

The instance of a class is really just a dictionary that you can do dot-access on, instead of index-access. So we need an object to mimic that which we can pass into every function we want. So we just say that our instance is a `namespace` on which we set stuff on. Where I use `namespace` later, think of it as our instance. You get the instance of a class by calling the class object itself, ala `obb = SomeClass()`.

The standard way of creating a dot-access dictionary is an attrdict:

```
attrdict = type("attrdict", (dict,), {"__getattr__": dict.__getitem__, "__setattr__": dict.__setitem__})  
```

However, that would be cheating, since it's making a class. The other ways are `typing.SimpleNamespace`, or making a sentinel empty class but both are making classes which is cheating, so we can't use both.

##### The solution

The solution to our namespace is another function. Functions can act as callable dot-access dictionaries, so we simply make a `namespace` function and pretend it's our self.

```
    # this acts as the "self" object
    # all attributes are set on this
    def namespace():
        return called()
```

Note the usage of calling `called()` - this is to emulate the behaviour of `__call__` on an instance normally.

#### Making an `__init__`

Every class in Python has an `__init__` (not including one defaults to the stock empty init), so we need to mock that and ensure user-defined inits are called.

```
    # make an init substitute function
    def new_class(*args, **kwargs):
        init = locals.get("__init__")
        if init is not None:
            init(namespace, *args, **kwargs)

        return namespace
```

This simply gets the user-defined `__init__` from locals, and if it's found calls it. Then, it returns the namespace (which is our fake instance), effectively simulating the `(metaclass.)__call__` -> `__new__` -> `__init__` cycle.

#### Cleaning up

The next thing to do is to make our methods on the class, which can be done with an incredibly simple scanning loop.

```
    # update namespace
    for name, item in locals.items():
        if callable(item):
            fn = _suspend_self(namespace, item)
            setattr(namespace, name, fn)
```

Similar to above, each callable function is wrapped in a `_suspend_self` to make the function a method, and set on the namespace.

#### Getting our class

The final thing to do is to simply `return new_class`. The final cycle of getting an instance of our class is:

*   The user code defines a class function
*   When the class function is called, it calls `make_class` to set up the namespace (this is done automatically by the `@make` decorator)
*   The `make_class` function sets up the instance ready to be initialised later
*   The `make_class` function returns another function which can be called to get the instance and initialise it.

And there we have it, classes done without writing a single class. Use this in production, I dare you.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
