> * 原文地址：[Python: Declaring Dynamic Attributes](http://amir.rachum.com/blog/2016/10/05/python-dynamic-attributes/)
* 原文作者：[Amir Rachum](http://amir.rachum.com/about/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[王子建](https://github.com/Romeo0906)
* 校对者：[冯志浩](https://github.com/fengzhihao123)，[Zheaoli](https://github.com/Zheaoli)

# 带你声明 Python 中的动态属性

2016 年 10 月 5 日

以下实例均为 Python 3.5 版本，但同样适用于 Python 2.x 和 Python 3.x 版本。

重写类中的 `__getattr__` 魔术方法是 Python 中实现动态属性的很普通的方法。试想有这样一个数据词典 `AttrDict`，它允许类似属性的方式访问其存储的键值对：

    class AttrDict(dict):
        def __getattr__(self, item):
            return self[item]

这个简化的 `AttrDict` 类允许以类似属性的方式获取数据字典的值，同时，它允许一种非常简单的方式来**设置**键值对的值。无论哪种情况下，它都可以这样做：

    >>> attrd = AttrDict()
    ... attrd["key"] = "value"
    ... print(attrd.key)
    value

重写 `__getattr__` 方法（和 `__setattr__` 方法）非常有用——这能够让你的构建远程过程调用（RPCs）单元的代码更具可读性。然而，动态属性也有令人沮丧的地方——它们在使用之前是不可见的！

动态属性在交互的 shell 下有两大使用问题。第一个问题就是当用户使用 `dir` 方法去检查对象的 API 的时候，它们并不会出现：

    >>> dir(attrd)  # 我想知道如何使用 attrd
    ['__class__', '__contains__', ... 'keys', 'values']
    >>> # 没有动态属性 [傲娇脸]

第二个问题是自动完成——如果我们照常设置 `normal_attribute` 属性，大部分主流的 shell 环境 [1](http://amir.rachum.com/blog/2016/10/05/python-dynamic-attributes/#fn:1) 下都能自动完成。

![](http://amir.rachum.com/images/posts/normal_attribute.png)

但是以字典键值对的方式设置 `dynamic_attribute` 的时候并没有自动完成功能：

![](http://amir.rachum.com/images/posts/dynamic_attribute_before.png)

然而，你可以在实现动态属性的时候锦上添花地**实现 `__dir__` 方法**，这样不但能提高用户体验还能一石二鸟地解决以上两个问题。详见 [文章](https://docs.python.org/2/library/functions.html#dir)：

> 如果对象内有名为 `__dir__()`的方法，方法被调用时必须返回属性列表。这使得对象可以实现一个自定义的 `__getattr__()` 或者 `__getattribute__()` 方法，来自定义 `dir()` 方法输出属性的方式。

实现 `__dir__` 方法非常简单，只需返回对象的属性键名列表：

    class AttrDict(dict):
        def __getattr__(self, item):
            return self[item]

        def __dir__(self):
            return super().__dir__() + [str(k) for k in self.keys()]

这样 `dir(attrd)` 将会返回动态属性和普通属性。有趣的是，**shell 环境将会使用 `__dir__` 方法来进行自动完成提示**！因此我们毫不费力就实现了自动完成 [2](http://amir.rachum.com/blog/2016/10/05/python-dynamic-attributes/#fn:2)功能：

![](http://amir.rachum.com/images/posts/dynamic_attribute_after.png)

如对此文有**金玉良言**请前往 [Hacker News](https://news.ycombinator.com/item?id=12644164)，[/r/Programming](https://www.reddit.com/r/programming/comments/55zuip/python_declaring_dynamic_attributes/)，或者添加评论。
欢迎**关注**我 [Twitter](https://twitter.com/AmirRachum)，[Facebook](https://www.facebook.com/amir.rachum.blog) 或者 [Google+](https://plus.google.com/collection/ku7PME) 。
**感谢**[Ram Rachum](http://ram.rachum.com/) 校稿。