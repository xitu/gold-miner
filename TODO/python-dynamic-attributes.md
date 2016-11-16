> * 原文地址：[Python: Declaring Dynamic Attributes](http://amir.rachum.com/blog/2016/10/05/python-dynamic-attributes/)
* 原文作者：[Amir Rachum](http://amir.rachum.com/about/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

# Python: Declaring Dynamic Attributes


October 5, 2016

The examples below are in Python 3.5, but otherwise this post is applicable to both Python 2.x and 3.x

It is a common solution in Python to override the `__getattr__` magic method in classes, to implement dynamic attributes. Consider `AttrDict` - it is a dictionary that allows attribute-like access to its stored key-value pairs:



    class AttrDict(dict):
        def __getattr__(self, item):
            return self[item]



This simplified `AttrDict` allows to read dictionary values from it like attributes, but it’s pretty simple to also allow to _set_ key-value pairs. At any rate, here it is in action:



    >>> attrd = AttrDict()
    ... attrd["key"] = "value"
    ... print(attrd.key)
    value



Overriding `__getattr__` (and `__setattr__`) is very useful - from simple “gimmicks” like `AttrDict` that makes your code more readable to essential building blocks of your application like remote procedure callers (RPCs). There is, however, something a little bit frustrating about dynamic attributes - you can’t see them before you use them!

Dynamic attributes have two usability problems when working in an interactive shell. The first is that they don’t appear when a user tries to examine the object’s API by calling the `dir` method:



    >>> dir(attrd)  # I wonder how I can use attrd
    ['__class__', '__contains__', ... 'keys', 'values']
    >>> # No dynamic attribute :(



The second problem is autocompletion - if we set `normal_attribute` as an attribute the old fashioned way, we get autocompletion from most modern shell environments[1](http://amir.rachum.com/blog/2016/10/05/python-dynamic-attributes/#fn:1):

![](http://amir.rachum.com/images/posts/normal_attribute.png)

But setting `dynamic_attribute` by inserting it as a dictionary key-value pair does not provide us with autocompletion:

![](http://amir.rachum.com/images/posts/dynamic_attribute_before.png)

There is, however, an extra step you can take when implementing dynamic attributes which will make it a delight for your users and [kill two birds with one stone](https://www.youtube.com/watch?v=71gilEP4aJY) - **implement the `__dir__` method**. From [the docs](https://docs.python.org/2/library/functions.html#dir):

> If the object has a method named `__dir__()`, this method will be called and must return the list of attributes. This allows objects that implement a custom `__getattr__()` or `__getattribute__()` function to customize the way `dir()` reports their attributes.

Implementing `__dir__` is straightforward: return a list of attribute names for the object:



    class AttrDict(dict):
        def __getattr__(self, item):
            return self[item]

        def __dir__(self):
            return super().__dir__() + [str(k) for k in self.keys()]



This will make `dir(attrd)` return dynamic attributes as well as the regular ones. The interesting thing about this is that **shell environments often use `__dir__` to suggest autocompletion options!** so without any additional effort, we also get autocompletion[2](http://amir.rachum.com/blog/2016/10/05/python-dynamic-attributes/#fn:2):

![](http://amir.rachum.com/images/posts/dynamic_attribute_after.png)

**Discuss** this post at [Hacker News](https://news.ycombinator.com/item?id=12644164), [/r/Programming](https://www.reddit.com/r/programming/comments/55zuip/python_declaring_dynamic_attributes/), or the comment section below.  
**Follow** me on [Twitter](https://twitter.com/AmirRachum) , [Facebook](https://www.facebook.com/amir.rachum.blog) or [Google+](https://plus.google.com/collection/ku7PME)  
**Thanks** to [Ram Rachum](http://ram.rachum.com/) for reading drafts of this.

