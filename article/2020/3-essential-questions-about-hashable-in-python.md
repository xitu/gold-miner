> * 原文地址：[3 Essential Questions About Hashable in Python](https://medium.com/better-programming/3-essential-questions-about-hashable-in-python-33e981042bcb)
> * 原文作者：[Yong Cui, Ph.D.](https://medium.com/@yong.cui01)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/3-essential-questions-about-hashable-in-python.md](https://github.com/xitu/gold-miner/blob/master/article/2020/3-essential-questions-about-hashable-in-python.md)
> * 译者：
> * 校对者：

# 3 Essential Questions About Hashable in Python

![Photo by [Yeshi Kangrang](https://unsplash.com/@omgitsyeshi?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/7648/0*eL1s2Ik6LMju82xU)

As a general-purpose programming language, Python provides a good range of built-in data types for various use cases.

When you learned these basics, you have probably encountered the mentioning of **hashable** at certain points. For example, you may see that the keys in a `dict` need to be hashable (see a trivial example in the code snippet below).

For another instance, it’s mentioned that the elements in a `set` need to be hashable.

```Python
>>> # A good dictionary declaration
>>> good_dict = {"a": 1, "b": 2}
>>> 
>>> # A failed dictionary declaration
>>> failed_dict = {["a"]: 1, ["b"]: 2}
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
TypeError: unhashable type: 'list'
```

You may wonder — What does hashable mean exactly? Which objects are hashable and which are not? What will happen if we use unhashable objects as keys for dictionaries? And so on. Many related questions can be asked.

In this article, we’ll go over some key points about hashability such that you’ll learn how to address these questions. In the end, you’ll probably find out that these questions are actually not hard at all, unlike what you may have thought initially.

## Which Objects Are Hashable and Which Are Not?

Before we begin any mechanistic explanation, the first question that we want to address is which objects are hashable and which are not.

Because we know that Python explicitly requires that the elements in a `set` should be hashable, we can test an object’s hashability by simply trying to add the object to a `set`. Successful insertion indicates the objects being hashable and vice versa.

```python
>>> # Create an empty set object
>>> elements = set()
>>> 
>>> # The list of objects with each to be inserted to the set
>>> items = [1, 0.1, 'ab', (2, 3), {'a': 1}, [1, 2], {2, 4}, None]
```

As shown in the above code, I created a `set` variable called `elements` and a `list` variable called `items`, which includes the most commonly used built-in data types: `int`, `float`, `str`, `tuple`, `dict`, `list`, `set`, and `NoneType`.

The experiment that I’ll run is to add each of the `items` to the `elements`. I won’t use the `for` loop in this case, because any possible `TypeError` will stop the iteration. Instead, I’ll just retrieve individual items using indexing.

```Python
>>> elements.add(items[0])
>>> elements.add(items[1])
>>> elements.add(items[2])
>>> elements.add(items[3])
>>> elements.add(items[4])
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
TypeError: unhashable type: 'dict'
>>> elements.add(items[5])
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
TypeError: unhashable type: 'list'
>>> elements.add(items[6])
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
TypeError: unhashable type: 'set'
>>> elements.add(items[7])
>>> elements
{0.1, 1, 'abc', None, (2, 3)}
```

As you can see in the above code snippet, here’s a quick summary of the experiment’s results.

#### Answer to the section’s question

* Hashable data types: `int`, `float`, `str`, `tuple`, and `NoneType`.
* Unhashable data types: `dict`, `list`, and `set`.

If you’re completely new to Python programming, you may have noticed that these three unhashable data types are all mutable in nature, while these five hashable data types are all immutable.

In essence, these mutable data are objects whose values can be changed after their creation, while the values of immutable objects can’t be changed after the creation.

Data mutability is a standalone topic that I have covered previously in my other [article](https://medium.com/swlh/6-things-to-understand-python-data-mutability-b52f5c5db191).

## What Does Hashable Mean?

You now have some ideas about which objects are hashable and which are not, but what does hashable mean, exactly?

Actually, you may have heard many similar computer terminologies related to hashable, such as hash value, hashing, hash table, and hashmap. At their core, they share the same fundamental procedure — hashing.

![General process of hashing ([Wikipedia](https://en.wikipedia.org/wiki/Hash_function), Public Domain)](https://cdn-images-1.medium.com/max/2000/1*DMk42PdjZOSHPyqynP1M-Q.png)

The above diagram shows you the general process of hashing. We start with some raw data values (termed **keys** in the figure).

A hash function, which is sometimes termed a **hasher**, will carry out specific computations and output the hash values (termed **hashes** in the figure) for the raw data values.

Hashing and its related concepts require a whole book to get clarified, which is beyond the scope of the current article. However, some important aspects have been discussed briefly in my [previous article](https://medium.com/better-programming/what-is-hashable-in-swift-6a51627f904).

Here, I’ll just highlight some key points that are relevant to the present discussion.

1. The hash function should be **computationally robust** such that different objects should have different hash values. When different objects have the same hash value, a collision occurs (as shown in the figure above) and should be handled.
2. The hash function should **be consistent** such that the same objects will always lead to the same hash values.

Python has implemented its built-in hash function that produces hash values for its objects. Specifically, we can retrieve an object’s hash value by using the built-in `hash()` function. The following code shows you some examples.

```Python
>>> # Get an string object's hash value
>>> hash("Hello World!")
5892830027481816904
>>> 
>>> # Get a tuple object's hash value
>>> hash((2, 'Hello'))
-4798835419149360612
>>> 
>>> # Get a list object's hash value
>>> hash([1, 2, 3])
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
TypeError: unhashable type: 'list'
>>> 
>>> # Get a dict object's hash value
>>> hash({"a": 1, "b": 2})
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
TypeError: unhashable type: 'dict'
```

As shown above, we were able to get the hash values — integer numbers for the` int` and `tuple` objects.

However, neither the `list` object nor the `dict` object had hash values. These results are consistent with the distinction that we’re making between hashable and unhashable objects in the last section.

#### Answer to the section’s question

* Hashable: A characteristic of a Python object to indicate whether the object has a hash value, which allows the object to serve as a key in a dictionary or an element in a set.

## How Can We Customize Hashability?

The flexibility of Python as a general-purpose programming language mainly comes from its support of creating custom classes. With your own classes, many related data and operations can be grouped in a much more meaningful and readable way.

Importantly, Python has evolved to be smart enough to make our custom objects hashable by default in most cases.

Consider the following example. We created a custom class, `Person`, which would allow us to create instances by specifying a person’s name and social security number.

Notably, we overrode the default `__repr__()` function using the f-string method, which would allow us to display the object with more readable information, as shown in the last line of the code snippet.

```Python
>>> # Create a custom class
>>> class Person:
...     def __init__(self, name, ssn):
...         self.name = name
...         self.ssn = ssn
...
...     def __repr__(self):
...         return f"***Name: {self.name}; SSN: {self.ssn}***"
... 
>>> # Create a custom object and check the hash value
>>> person0 = Person('John Smith', '012345678')
>>> hash(person0)
272583189
>>> 
>>> # Create a set that consists of the Person objects
>>> persons = {person0}
>>> persons
{***Name: John Smith; SSN: 012345678***}
```

As shown in the above code, we can find out the hash value for the created object `person0` by using the built-in `hash()` function. Importantly, we’re able to include the `person0` object as an element in a `set` object, which is good.

However, what will happen if we want to add more `Person` instances to the set? A more complicated, but probable scenario is that we construct multiple `Person` objects of the same person and try to add them to the `set` object.

See the following code. I created another `Person` instance, `person1`, which has the same name and social security number — essentially the same natural person.

```Python
>>> # Create another Person object for the same person
>>> person1 = Person('John Smith', '012345678')
>>> 
>>> # Add the person1 to the set
>>> persons.add(person1)
>>> persons
{***Name: John Smith; SSN: 012345678***, ***Name: John Smith; SSN: 012345678***}
>>> 
>>> # Compare these two Person objects
>>> person0 == person1
False
```

However, when we added this person to the `set` object, `persons`, both `Person` objects are in the `set`, which we would not want to happen.

Because, by design, we want the `set` object to store unique natural persons. Consistent with both persons included in the `set` object, we found out that these two `Person` instances are indeed different.

I’ll show you the code of how we can make the custom class `Person` smarter so that it knows which persons are the same or different, for that matter.

```Python
>>> # Update the Person function
>>> class Person:
...     # __init__ and __repr__ stay the same
...
...     def __hash__(self):
...         print("__hash__ is called")
...         return hash((self.name, self.ssn))
...
...     def __eq__(self, other):
...         print("__eq__ is called")
...         return (
...             self.__class__ == other.__class__ and 
...             self.name == other.name and
...             self.ssn == other.ssn
...         )
...
>>> # Create two Person objects
>>> p0 = Person("Jennifer Richardson", 123456789)
>>> p1 = Person("Jennifer Richardson", 123456789)
>>> 
>>> # Create a set consisting of these two objects
>>> ps = {p0, p1}
__hash__ is called
__hash__ is called
__eq__ is called
>>> ps
{***Name: Jennifer Richardson; SSN: 123456789***}
>>> 
>>> # Compare these two objects
>>> p0 == p1
__eq__ is called
True
```

In the above code, we updated the custom class `Person` by overriding the `__hash__` and `__eq__` functions.

We have previously mentioned that the `__hash__()` function is used to calculate an object’s hash value. The `__eq__()` function is used to compare the object with another object for equality and it’s also required that objects that compare equal should have the [same hash value](https://docs.python.org/3.5/reference/datamodel.html#object.__hash__).

By default, custom class instances are compared by comparing their identities using the built-in `id()` function (learn more about the `id()` function by referring to [this article](https://medium.com/better-programming/use-id-to-understand-6-key-concepts-in-python-73e0bbd461ec)).

With the updated implementation, we can see that when we were trying to create a `set` object that consisted of the two `Person` objects, the `__hash__()` function got called such that the set object only kept the objects of unique hash values.

Another thing to note is that when Python checks whether the elements in the `set` object have unique hash values, it will make sure that these objects aren’t equal as well by calling the `__eq__()` function.

#### Answer to the section’s question

Customization: To provide customized behaviors in terms of hashability and equality, we need to implement the `__hash__` and `__eq__` functions in our custom classes.

## Conclusion

In this article, we reviewed the concepts of hashable/hashability in Python.

Specifically, by addressing the three important questions, I hope that you have a better understanding of hashability in Python. When it’s applicable, you can implement tailored hashability behaviors for your own custom classes.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
