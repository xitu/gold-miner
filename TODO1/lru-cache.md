> * 原文地址：[Implementing an efficient LRU cache in JavaScript](https://yomguithereal.github.io/posts/lru-cache)

> * 原文作者：[Yomguithereal](https://github.com/Yomguithereal)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/lru-cache.md](https://github.com/xitu/gold-miner/blob/master/TODO1/lru-cache.md)
> * 译者：[hanxiaosss](https://github.com/hanxiaosss)
> * 校对者

# Implementing an efficient LRU cache in JavaScript

# 使用 JavaScript 实现一个高效的 LRU cache  

> Where we discover how to harness the power of JavaScript's typed arrays to design our very own low-cost pointer system for fixed-capacity data structures

>如何利用 JavaScript 类型化数组的强大功能，为固定容量的数据结构设计自己的低成本指针系统

Let's say we need to process a very large – hundreds of gigabytes large – csv file containing urls we will need to download.
To ensure we are not going to run out of memory while parsing the whole file, we read the file line by line:

假设我们需要处理一个非常大的 ——— 几百 GB 大 ——— csv 文件，其中包含需要下载的 url。
为了确保我们在解析整个文件的时候不会耗尽内存，我们逐行的读取这个文件：

```js
csv.forEachLine(line => {
  download(line.url);
});
```

Now let's say the person that created our file forgot to deduplicate the urls.

现在假设创建这个文件的人忘记删除重复的文件url。

> I am aware that this could easily be solved by using `sort -u` but that's not the point.
> Deduping urls is not as straigthforward as it may seem. Check the [ural](https://github.com/medialab/ural#readme) library in python, for instance, for some examples of what can be achieved in this regard.

>我知道使用 `sort -u` 可以很容易解决，但这不是重点。
>删除 url 并不像它看起来那么简单。例如，查看 python 中的 [ural](https://github.com/medialab/ural#readme) 库，了解这方面可以实现的一些示例。

This is an issue because we don't want to fetch the same url more than once: grabbing resources from the web is time-consuming & should be done parcimoniously not to flood the sites we are grabbing those resources from.

这是一个问题，因为我们并不想同一个 url 多次获取：从网页获取资源是耗时的并且我们需要做到尽量简洁以避免我们获取资源的站点泛滥。

An obvious solution could be to remember urls we already fetched by caching them into a map:

一个显而易见的解决方案是记住我们已经获取过的 url 缓存在一个 map 里面：

```js
const done = new Map();

csv.forEachLine(line => {
  if (done.has(line.url))
    return done.get(line.url);

  const result = download(line.url);
  done.set(line.url, result);
});
```

At this point, the astute reader will have noticed that we just defeated the purpose of reading the csv file line by line since we now need to commit all its urls to memory.

此时，精明的读者会注意到，我们刚刚放弃了逐行读取 csv 文件的意图，因为现在我们需要将它的所有 url 提交到内存中。

And herein lies the issue: we want to avoid fetching the same url more than once while also making sure we don't run out of memory. We have to find a way to compromise.

这就是问题所在：我们希望避免多次获取相同的 url，同时确保不会耗尽内存。我们必须找一个折中的办法。

>**Fun fact**: if you work with data coming from the Internet such as lists of crawled urls, you will inevitably stumble upon this kind of [power law](https://en.wikipedia.org/wiki/Power_law). It naturally occurs because people link exponentially more to `twitter.com` than `unknownwebsite.fr`.

>**有趣的事实**: 如果你处理来自 Internet 的数据，例如爬取的 url 列表，你将会不可避免的遇到 [power law](https://en.wikipedia.org/wiki/Power_law) 这一类的问题。这很常见，因为人们链接到 `twitter.com` 的次数指数级地多于链接到 `unknownwebsite.fr`的次数。

Fortunately for us, it seems that only a tiny fraction of the urls contained in our file are repeated very often while the vast majority of others only appears one or two times. We can leverage this fact by designing a policy to throw away urls from our map if we have a good intuition they are unlikely to appear again. Thus, we won't allow our map to exceed a predetermined amount of memory.

对我们来说幸运的是，似乎只有一小部分包含在文件中的 url 是经常重复的，其余的绝大部分 url 都只出现一两次。我们可以设计一个策略来利用这一事实，将 map 中我们觉得不太可能再次出现的 url 抛弃，因此，我们不允许我们的map超过一个我们预先设定的内存量。

And one of the most commonly used eviction policy is called “LRU”:

最常用的驱逐策略之一是 “ LRU ”

**L**east **R**ecently **U**sed.

**L**east **R**ecently **U**sed.

## The LRU cache

## LRU 缓存

Hence, we understand that a LRU cache is a fixed-capacity map able to bind values to keys with the following twist: if the cache is full and we still need to insert a new item, we will make some place by evicting the least recently used one.

因此，我们理解 LRU 缓存是一个固定容量的 map，可以根据以下方式将键值进行绑定：如果缓存是满的我们仍需要插入一个新的项，我们将通过删除最近最少使用的条目来腾出空间。

To do so, the cache will need to store given items in order of their last access. Then, each time someone tries to set a new key, or access a key, we need to modify the underlying list to ensure the needed order is maintained.

这样一来，缓存需要以最后访问的顺序存储给定的项。因此，每次有人试图设置一个新的键，或者访问一个新的键，我们都要修改底层的列表以确保维护我们所需的顺序。

>**Note**: LFU (Least Frequently Used) is a perfectly valid cache eviction policy. It's just less widespread. You can read about it [here](https://en.wikipedia.org/wiki/Cache_replacement_policies#Least-frequently_used_(LFU)) and find implementation notes [here](https://www.geeksforgeeks.org/lfu-least-frequently-used-cache-implementation/).

>**注意**：LFU(Least Frequently Used) 是一个完全有效的缓存驱逐策略，只是没有那么普遍，你可以点击 [这里](https://en.wikipedia.org/wiki/Cache_replacement_policies#Least-frequently_used_(LFU)) 阅读相关资料，也可以以在 [这里](https://www.geeksforgeeks.org/lfu-least-frequently-used-cache-implementation/) 找到实现笔记。

But why is this order relevant? Wouldn't it be better to record the number of times each item was accessed so we can evict the **L**east **R**ecently **U**sed instead?

但是为什么是这个顺序至关重要呢？难道不是记录下每项条目被访问的次数以便我们清除最近最少使用的条目更好一些吗？

Not necessarily. Here are some reasons why:

不一定，下面是一些原因：

* LRU is a actually a good proxy of LFU since the more frequently a pair is accessed, the less chance it has to be evicted.

* LRU 其实是 LFU 一个很好的代理，因为对一个键值对访问得越频繁，它被清除的几率就越小。

* You will need to store integers in addition to everything else to keep track of the number of times the items were accessed.

* 除了其他内容外 还需要存储整数，以便跟踪该项的访问次数。

* Ordering items on their last access is very straightforward to do since it can be synchronized with operations on the cache.

* 按照最后访问顺序排列的项非常直观，因为它可以与缓冲上的操作同步。

* LFU will often force you to make an arbitrary choice of item to evict: for instance if all your pairs have been accessed only once. With LRU, you don't have such choice to make: you just evict the least recently used. No ambiguity here.

* LFU 通常会强制你任意选择要清除的项：比如，如果所有的键值对都只被访问过一次。对于 LRU，你不用做这样的抉择： 你只需要清除最近最少使用的项，这里不会存在歧义。

## Implementing a LRU cache

## 实现一个 LRU 缓存

There are many ways to implement a working LRU cache but I will only focus on the way you are most likely to encounter in the wild when developing for high-level languages.

实现一个有效的 LRU 缓冲有多很种方法，但是我只会集中讲在开发高层语言时在自然环境下你最有可能用到的方法。

Usually, to implement a proper LRU cache, we need the two following ingredients:

通常，实现一个合适的 LRU 缓冲，我们需要以下两个要素：

1. A [hashmap](https://en.wikipedia.org/wiki/Hash_table)-like data structure able to retrieve values associated to arbitrary keys – such as strings – efficiently. In JavaScript we can either use the ES6 `Map` or any plain object `{}`: remember that our cache is no different from a fixed-capacity key-value store.

1. 一个类似于 [hashmap](https://en.wikipedia.org/wiki/Hash_table) 的数据结构，能够高效的检索与任意键相关联的值 -比如字符串 。在 JavaScript 中，我们可以使用 ES6 的 `map ` 或者任何普通的对象 `{}` :记住我们的缓冲与一个固定容量的键值对存储没什么不同。

2. A way to store our items in the order of their last access. What's more, we will need to move items around efficiently. That's why people naturally lean toward a [doubly-linked list](https://en.wikipedia.org/wiki/Doubly_linked_list) for the job.

2. 一种将所有项按最后访问顺序存储的方法。更重要的是，我们将需要有效地移动项，这也是人们通常倾向于使用 [doubly-linked list](https://en.wikipedia.org/wiki/Doubly_linked_list) 来实现。

Minimally, our implementation needs to be able to run the two following operations:

我们的实现至少需要可以执行下面两个操作：

* `#.set`: associating a value to the given key, while evicting the least recently used item if the cache is already full.

* `#.set`: 关联值到给定的键，同时当缓存已满时清除最近最少使用的项。

* `#.get`: retrieving the value associated to the given key if this one exists at all in the cache, while updating the underlying list to keep LRU order.

* `#.get`: 如果给定键在缓存中存在，检索与给定键关联的值，同时更新底层列表来保持 LRU 顺序。

And here is how we could use such a cache:

接下来是我们如何使用这样一个缓存：

```js
// Let's create a cache able to contain 3 items
// 创建一个可以容纳3个元素的缓存区
const cache = new LRUCache(3);

// Let's add items
// 添加一个元素
cache.set(1, 'one');
cache.set(2, 'two');
cache.set(3, 'three');

// Up until now, nothing was evicted from the cache
// 到目前为止，没有元素从缓存中清除
cache.has(2);
>>> true

// Oh no! we need to add a new item
// 噢不！我们需要添加一个新的元素
cache.set(4, 'four');

// `1` was evicted because it was the LRU key
// `1`被清除掉了因为它是最近最少使用的 key
cache.has(1);
>>> false

// If we get `2`, it won't be the LRU key anymore
// 如果我们访问 `2` ，它就不再是 LRU 的键了
cache.get(2);
>>> 'two'

// Which means that `3` that will get evicted now!
// 这意味着 `3`将被清除
cache.set(5, 'five');
cache.has(3);
>>> false

// Thus we never store more than 3 items
// 因此我们从来不会存储超过 3 个元素
cache.size
>>> 3
cache.items()
>>> ['five', 'two', 'four']
```

## Doubly-linked lists

## 双向链接列表

Question: Why isn't a singly-linked list enough in our case? Because we have to efficiently perform the following operations on our list:
- place an item at the beginning of the list
- move an item from anywhere in the list to its beginning
- remove the last item from the list while keeping a correct pointer to the new last item

问题：为什么我们的案例中使用一个单链表还不够？因为我们需要在我们的列表中高效的展示以下操作：
- 在列表的起始位置放置一个元素
- 在列表的任意位置将一个元素移到起始位置
- 将列表的最后一个元素移除同时保持新产生的最后一个元素的指针正确

To be able to implement a LRU cache, we will need to implement a doubly-linked list to make sure we are able to store our items in order of their last access: the most recently used item starting the list and the least recently used one ending it.

为了能够实现一个 LRU 缓存，我们需要实现一个双向链表来确保我们可以按照最后访问顺序来存储所有项：以最近使用的项起始并且以最近最少使用的项结束。

> Note that it could be the other way around. The direction of the list is not important.

>请注意，可能正好相反，列表的方向并不重要。

So how do we represent a doubly-linked list in memory? Usually, we do so by creating a node structure containing:

所以我们如何在内存中表达一个双向链表？通常，我们通过创建一个节点结构包含：

1. A payload, i.e. the actual value or item to store. It can be anything from a string to an integer…
2. A pointer toward the previous element in the list.
3. A pointer toward the next element in the list.

1. 一个有效荷载，也就是实际要存储的值或者项。它可以是任意类型，从字符串到整型……
2. 列表中指向前一个元素的指针。
3. 列表中指向下一个元素的指针。

Then we also need to store a pointer to both the first & the last element of the list and we are done.

然后我们也需要存储列表第一个和最后一个元素的指针。这样就完成了。

> Now is probably a good time to review [pointers](https://en.wikipedia.org/wiki/Pointer_(computer_programming)), if you are unsure what they are.

>如果你不太确定什么是指针，那么现在可以能是复习 [指针](https://en.wikipedia.org/wiki/Pointer_(computer_programming)) 的好时机。

Schematically, it looks somewhat like this:

如下图，它看起来是这样的：

```c
a node:

  (prev|payload|next)

  payload: the stored value. here, a string
  prev: pointer to previous item
  next: pointer to next item
  •: pointer
  x: null pointer

a list:

       ┌─────>┐   ┌───────>┐   ┌────────>┐
  head • (x|"one"|•)  (•|"two"|•)  (•|"three"|x) • tail
              └<───────┘   └<───────┘    └<──────┘
```

## LRU Cache list operations

## LRU 缓存列表操作

As long as the cache is not full, it is quite easy to maintain our list of cached items. We just need to prepend the newly inserted items into the list:

只要缓存没有满，维护我们获取的项列表是非常简单的，我们只需要在列表前插入一个新添加的项：

```c
1. an empty cache with capacity 3


  head x     x tail


2. let's insert key "one"

       ┌─────>┐
  head • (x|"one"|x) • tail
              └<─────┘

3. let's insert key "two" (notice how "two" comes at the front)

       ┌─────>┐   ┌───────>┐
  head • (x|"two"|•)  (•|"one"|x) • tail
              └<───────┘   └<─────┘

4. finally we insert key "three"

       ┌──────>┐    ┌───────>┐   ┌───────>┐
  head • (x|"three"|•)  (•|"two"|•)  (•|"one"|x) • tail
               └<────────┘   └<───────┘   └<─────┘
```

So far so good. Now, to keep our list in LRU order, if anyone accesses an already stored key in the cache we will need to reorder the list by moving said key to the front:

到目前为止一切顺利。现在，为了将我们的列表保持在 LRU 的顺序，如果任何人访问已经存储在缓存中的键我们就需要将访问的键移动到列表的起始位置来重新排序：

```c
1. the current state of our cache

       ┌──────>┐    ┌───────>┐   ┌───────>┐
  head • (x|"three"|•)  (•|"two"|•)  (•|"one"|x) • tail
               └<────────┘   └<───────┘   └<─────┘

2. we access key "two", we first extract it from the list and
   rewire previous & next items.

  extracted: (x|"two"|x)

       ┌──────>┐    ┌───────>┐
  head • (x|"three"|•)  (•|"one"|x) • tail
               └<────────┘   └<─────┘

3. then we move it to the front

       ┌─────>┐   ┌────────>┐    ┌───────>┐
  head • (x|"two"|•)  (•|"three"|•)  (•|"one"|x) • tail
              └<───────┘    └<────────┘   └<─────┘
```

Note that each time, we will need to update the head pointer and that, sometimes, we will also need to update the tail pointer.

注意每次我们都需要更新头指针，以及有时我们也需要更新尾指针。

Finally, if the cache is already full and a yet unknown key needs to be inserted, we will need to pop the last item from the list to make place to prepend the new one.

最后，如果这个缓存已经满了，一个未知的键需要被插入，所以我们需要把列表中最后一项移出以为新的项腾出空间。

```c
1. the current state of our cache

       ┌─────>┐   ┌────────>┐    ┌───────>┐
  head • (x|"two"|•)  (•|"three"|•)  (•|"one"|x) • tail
              └<───────┘    └<────────┘   └<─────┘

2. we need to insert key "six" but cache is full
   we first need to pop "one", being the LRU item

  removed: (x|"one"|x)

       ┌─────>┐   ┌────────>┐
  head • (x|"two"|•)  (•|"three"|•) • tail
              └<───────┘    └<──────┘

3. then we prepend the new item
       ┌─────>┐   ┌───────>┐   ┌────────>┐
  head • (x|"six"|•)  (•|"two"|•)  (•|"three"|x) • tail
              └<───────┘   └<───────┘    └<──────┘
```

Here is all we need to know about doubly-linked lists to be able to implement a decent LRU cache.

以上是实现一个好的 LRU 缓存我们所需要了解的有关双向链表的知识。

## Implementing doubly-linked lists in JavaScript

## 使用 JavaScript 实现一个双链表

Now there is a slight issue: the JavaScript language does not have pointers per se. Indeed we can only work by passing references around, and dereference pointers by accessing object properties.

现在有一个小问题：JavaScript 语言本身没有指针。事实上我们只能通过传递引用来工作，通过访问对象属性来取消传递指针。

This means that most people usually implement linked lists in JavaScript by writing classes like those:

这意味着人们通常通过写像下面的类来实现链表：

```js
// One class for nodes
function Node(value) {
  this.value = value;
  this.previous = null;
  this.next = null;
}

// One class for the list
function DoublyLinkedList() {
  this.head = null;
  this.tail = null;
}

// Performing operations
// (should be wrapped in the list's method)
const list = new DoublyLinkedList();

const node1 = new Node('one');
const node2 = new Node('two');

list.head = node1;
list.tail = node2;

node1.next = node2;
node2.previous = node1;

// ...
```

While there is nothing wrong with this approach, it still has drawbacks that will make any similar-looking implementation perform badly:

虽然这个方法没有什么问题，但是它仍然有一些缺点会使这种看起来类似的实现执行得很差：

1. Each time you instantiate a node, some superflous memory will be allocated for bookkeeping.

1. 每次你实例化一个节点，都会为记录分配一些多余的内存。

2. If your list moves fast, i.e. nodes are often added or removed, it will trigger garbage collection that will slow you down.

3. 如果列表移动的很快，比如节点被频繁的添加或者移除，将会触发垃圾回收机制导致运行变慢。

3. Engines will try to optimize your objects as low-level structs most of the time but you have no control over it.

3. 大多数时候，引擎会试图将对象优化为低级的结构，但是你却没法控制。

4. Finally, and this is related to `3.`, object property access is not the fastest thing in the JavaScript world.

4. 最后，和第三点相关的，访问对象属性并不是 JavaScript 世界里最快的方式。

> This is mostly why you won't see many people using linked lists in application JavaScript code. Only people needing it for very specific use cases where they algorithmically shine will actually use them. node.js has such an implementation [here](https://github.com/nodejs/node/blob/master/lib/internal/linkedlist.js) and you can find it used for timers [here](https://github.com/nodejs/node/blob/master/lib/internal/timers.js).

> 这就是为什么你不会看到很多人在 JavaScript 代码的应用中使用链表。只有在特殊用例中使用它的人才会真正用到它，而这些用例在算法上非常出色。node.js 有类似这样的实现 [这里](https://github.com/nodejs/node/blob/master/lib/internal/linkedlist.js),并且你可以发现它应用于定时器 [这里](https://github.com/nodejs/node/blob/master/lib/internal/timers.js)。

But we can be a little more clever than that. Indeed, there is a characteristic of our linked list that we can leverage to be more performant: its capacity cannot exceed a given number.

但是我们可以做到比这个更智能一点。事实上，我们可以利用链表的一个特性来提高性能：它的容量不能超过给定的数字。

So, instead of using JavaScript references & properties as pointers, let's roll our own pointer system using [Typed Arrays](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/TypedArray)!

所以，我们不使用 JavaScript 的引用和属性作为指针，让我们使用 [Typed Arrays](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/TypedArray) 玩转我们自己的指针系统。

## A custom pointer system

## 自定义的指针系统

Typed Arrays are very neat JavaScript objects able to represent fixed-capacity arrays containing a certain amount of typical number types such as `int32` or `float64` and so on…

类型化数组是非常简洁的 JavaScript 对象，能够标是包含一定数量类型例如 `int32` 或者 `float64` 等等…… 类型的固定容量数组。

They are fairly fast and consume very little memory because the stored items are statically typed and can't suffer from bookkeeping overhead.

它相当的快并且消耗很少的内存，因为被存储的项都是静态类型的，不会受记录开销影响。

Here is how we would use one:

下面是如何使用：

```js
// A typed array containing 256 unsigned 16 bits integers
const array = new Uint16Array(256);

// Every index is initially set to 0.
// We can read/set items very naturally
array[10] = 34;
array[10];
>>> 34

// But here's the catch: we cannot push new items
array.push(45);
>>> throw `TypeError: array.push is not a function`
```

> What's more, instantiating a typed array in JavaScript is not so far, conceptually, from calling a `malloc` in C. Or, at least, you can somewhat use them to perform the same kind of tasks in both languages.

> 而且，从概念上讲，使用 JavaScript 实例化一个类型化数组远和使用 c 语言调用一个 `malloc` 相差不远，或者至少可以使用它们在两种语言中执行相同的任务。

Since we can use those very performant arrays, why shouldn't we use them to implement our own pointer system? After all, pointers are nothing more than addresses mapping chunks of memory.

既然我们可以使用这些高性能的数组，我们为什么不使用它们实现我们自己的指针系统呢？ 毕竟指针也不过是映射内存块的地址。

Let's use a typed array as our chunk of memory then, and its indices as our addresses! The only tricky part now is to correctly choose an integer type, relative to our capacity, to avoid overflows.

我们使用一个类型化数组作为我们的内存块，并把它的索引作为地址！现在唯一棘手的部分就是根据我们的容量正确地选择一个整数类型，以免溢出。

> If you are ever unsure how to develop this, check this function right [here](https://github.com/Yomguithereal/mnemonist/blob/7ea90e6fec46b4c2283ae88f173bfb19ead68734/utils/typed-arrays.js#L8-L54)

> 如果你还不是不知道如何开发，参考这个函数 [这里](https://github.com/Yomguithereal/mnemonist/blob/7ea90e6fec46b4c2283ae88f173bfb19ead68734/utils/typed-arrays.js#L8-L54)

So, in order to implement a fixed-capacity doubly-linked list in JavaScript for our LRU cache structure, we'll need the following typed arrays:

所以，为了用 JavaScript 给我们的 LRU 缓存结构实现一个固定容量的双链表结构,我们需要下面的类型化数组：

1. A vanilla array to store our list's payloads, i.e. key-value pairs. Or two typed or vanilla arrays to store keys & values separately and depending on their respective types. For instance, if we can guarantee our values cannot be anything more than 32 bits integers, we can once again leverage typed arrays for the task.
2. A typed array storing a bunch of indices representing our next pointers.
3. Another one to store the indices representing our previous pointers.

1. 一个普通的数组用来存储我们列表的有效荷载，也就是键值对。或者两个类型数组或普通数组来根据它们各自的类型分别存储键和值。具体的，如果我们可以保证我们的值不超过32位整数，那么我们可以再一次利用类型数组完成这个任务。

2. 一个类型化数组，它存储了一系列表示下一个指针的索引。

3. 另一个个类型化数组，它存储了一组表示上一个指针的索引。

> Oftentimes, the **typed array pointers** trick can be a bit tedious to use when you need to ensure index `0`represents a null value/pointer. Two somewhat crafty ways to circumvent this issue:

> 通常，当你需要确保索引 `0` 代表一个空值或者空指针，使用**类型化数组指针**会有一点冗余。两个巧妙地办法来规避这个问题：


> - You can offset your values array by keeping the first item empty so that the `0` index does not risk storing anything important.

> - 你可以通过保持第一个元素为空来偏移存储值的数组，这样 `0` 索引就不会有存储任何重要内容的风险了。

> - You can offset your indices by one but this often requires to perform some light arithmetic on the indices which make the code quite unpalatable and complicated to understand.

> - 你可以将索引偏移 1，但是这通常需要对索引执行一些轻量级的运算，这会使得代码看起来非常复杂，难以理解。

> Note that people also use the trick of using signed typed arrays rather than unsigned ones (indices cannot be negative numbers, obviously) to add one level of indirection: a pointer can signify one thing or the other based on the sign of the index.

> 请注意，人们也使用有符号的类型数组而不是无符号(显然就是索引不能为负数)的类型数组的技巧来添加一个间接层：指针可以根据索引的符号表示一个或另一个不同的东西

> This is sometimes used, for instance, to flag nodes in a [Trie](https://en.wikipedia.org/wiki/Trie) as leaves, by using negative indices to save up memory.

> 例如，有的时候会通过负的索引保存内存，将 [Trie](https://en.wikipedia.org/wiki/Trie) 中一个节点标识为叶子节点。

Our code would subsequently look something like this:

我们的代码之后会是这样的：

```js
function FixedCapacityDoublyLinkedList(capacity) {
  this.keys   = new Array(capacity);
  this.values = new Uint8Array(capacity);

  this.next = new Uint8Array(capacity);
  this.previous = new Uint8Array(capacity);

  this.head = 0;
  this.tail = 0;
}

// This earlier example:
const list = new DoublyLinkedList();

const node1 = new Node('one');
const node2 = new Node('two');

list.head = node1;
list.tail = node2;

node1.next = node2;
node2.previous = node1;

// Would now look more like this:
const list = new FixedCapacityDoublyLinkedList(2);

// First node
list.keys[0] = 'one';
list.values[0] = 1;

// Second node
list.keys[1] = 'two';
list.values[1] = 2;

// Wiring & pointer mangling
list.next[0] = 1;
list.previous[1] = 0;

list.head = 0;
list.tail = 1;
```

The code looks a bit more complicated but now, instead of setting properties, we lookup & set indices in typed arrays.

这个代码看起来有一些复杂，但是现在，我们不再设置属性，而是在类型化数组中查找和设置索引。

Schematically, again, here is what we are doing:

如下图所示，我们是这样做的：

```c
To represent the following list:

       ┌──────>┐    ┌───────>┐   ┌───────>┐
  head • (x|"three"|•)  (•|"two"|•)  (•|"one"|x) • tail
               └<────────┘   └<───────┘   └<─────┘

We store the following indices & arrays instead:

  head     = 2
  tail     = 0
  capacity = 3
  size     = 3

  index       0      1       2
  keys   = ["one", "two", "three"]
  prev   = [    1,     2,       x]
  next   = [    x,     0,       1]

// x (null pointer) should be 0 here but for
// simplicity's sake don't worry too much about it
```

So, if we “rerun” our [previous examples](#lru-cache-list-operations) of required list operations using our new scheme we get:

所以，如果我们使用新方案重新运行 [前面的例子](#lru-cache-list-operations) 所需的列表操作，我们会得到：

```c
1. We start with an empty list

  head     = x
  tail     = x
  capacity = 3
  size     = 0

  index       0      1      2
  keys   = [    x,     x,     x]
  prev   = [    x,     x,     x]
  next   = [    x,     x,     x]

2. We insert "one"

  head     = 0
  tail     = 0
  capacity = 3
  size     = 1

  index       0      1      2
  keys   = ["one",     x,     x]
  prev   = [    x,     x,     x]
  next   = [    x,     x,     x]

3. We insert "two"

  head     = 1
  tail     = 0
  capacity = 3
  size     = 2

  index       0      1      2
  keys   = ["one", "two",     x]
  prev   = [    1,     x,     x]
  next   = [    x,     0,     x]

4. We insert "three"

  head     = 2
  tail     = 0
  capacity = 3
  size     = 3

  index       0      1       2
  keys   = ["one", "two", "three"]
  prev   = [    1,     2,       x]
  next   = [    x,     0,       1]

5. We access "two" and bring it the the front of the list
   (notice how only pointers change & keys stay the same)

  head     = 1
  tail     = 0
  capacity = 3
  size     = 3

  index       0      1       2
  keys   = ["one", "two", "three"]
  prev   = [    2,     x,       1]
  next   = [    x,     2,       0]

6. Finally we insert "six" and evict "one"

  head     = 0
  tail     = 2
  capacity = 3
  size     = 3

  index       0      1       2
  keys   = ["six", "two", "three"]
  prev   = [    1,     0,       1]
  next   = [    x,     2,       x]
```

Looks boring, no?

看起来很无聊，不是吗？

It's actually a good thing. It means we don't move things around too much. We don't create things, we just read & write array indices.

但是这其实是一件好事，它意味着我们不需要过多的移动元素，我们也不创建元素，我们只需要读写数组的索引。

So why is this faster than the traditional implementation we reviewed earlier?

所以为什么这种方式比我们之前讨论的那种传统的实现方式快呢？

- Memory is only allocated once. New objects are never instantiated and old one are never garbage collected.<SideNote id="pool">Yes you can temper memory allocation and garbage collection by using object pools. But if you can rely on typed arrays instead you'll find that it's faster and consumes less memory.</SideNote>And memory predictability is a desirable thing to have in a LRU cache implementation.

    The only memory hiccups in our implementation will be the result of filling our map with keys up to capacity then evicting some of them later on.

- 内存只会被分配一次，新的对象从未被实例化而旧的对象一直未被垃圾收集。<SideNote id="pool"> 是的，你可以通过使用对象池临时地调整内存分配和垃圾回收。但是如果你依赖类型化数组你会发现它更快并且占用更少的内存。</SideNote>，并且内存的可预测性在 LRU缓存的实现中是非常可取的。
我们的实现中唯一的内存问题是当映射中的键的容量填满后，稍后删除其中一些键。

- Array indices lookups/writes are really fast because the allocated memory is mostly contiguous, even more with typed arrays. You never need to jump very far to find what you need and cache optimizations can more easily perform their magic.

- 数组索引的查找/写入都非常快是因为分配的内存大多是连续的，对于类型化数组更是如此。你不需要很大幅度的跳跃来找你需要的东西，而且缓存优化能更好的展示他们的神奇。

- It leaves nothing to interpretation. The engine does not have to be clever about anything and will be able to automatically apply very low-level optimizations without a second thought.

- 无需过多的解释。引擎不需要对任何事情都智能，并且能够即时自如的应对非常低级的优化。

## Is it really worth the hassle?

## 真的值得这么麻烦吗？

To make sure of that, I tried to implement this custom pointer system I just described and benchmark it.

为了确认这一点，我尝试着实现了我刚刚描述的自定义指针系统并对其进行基准测试。

You can therefore find a typed array-based implementation of a LRU cache in the [mnemonist](https://github.com/Yomguithereal/mnemonist) library. You will find one implementation relying on a JavaScript object: the [`LRUCache`](https://yomguithereal.github.io/mnemonist/lru-cache), and another one relying on an ES6 `Map`: the [`LRUMap`](https://yomguithereal.github.io/mnemonist/lru-map).

所以你可以在这个 [mnemonist](https://github.com/Yomguithereal/mnemonist) 库里面看到一个基于类型化数组的 LRU 缓存实现。你也可以在 [`LRUCache`](https://yomguithereal.github.io/mnemonist/lru-cache) 查阅依赖 JavaScript 对象的实现方式，以及另一个依赖 ES6 `map` 实现 [`LRUMap`](https://yomguithereal.github.io/mnemonist/lru-map)。

You can read their source code [here](https://github.com/Yomguithereal/mnemonist/blob/master/lru-cache.js) and decide for yourself whether it's gibberish to deal with indices rather than object properties or not.

你可以在 [这里](https://github.com/Yomguithereal/mnemonist/blob/master/lru-cache.js) 阅读他们的源码，然后自己决定处理索引而不是对象属性是否很混乱。

Then there is this public benchmark on the [dominictarr/bench-lru](https://github.com/dominictarr/bench-lru) repository. As every benchmark it cannot perfectly suit your use cases but it still avoids some common pitfalls about unrelated engine optimizations and other related issues.

然后这里是一个公共的基准测试仓库 [dominictarr/bench-lru](https://github.com/dominictarr/bench-lru) 。尽管每个基准测试并不能完全是个你的用例但是它仍可以避免一些常见的无关引擎优化的陷阱以及其他相关问题。

Here are some the latest benchmark results, expressed in ops/ms (the higher, the better) for a variety of typical LRU cache methods, on my 2013 MacBook using node `12.6.0`:

下面是最近一些基准测试结果，用ops/ms(越高越好)来表示各种典型的LRU缓存方法，在我2013年的MacBook上使用node `12.6.0 ` :

| name                                                           | set    | get1   | update  | get2   | evict  |
|:----------------------------------------------------------------|-------:|-------:|--------:|-------:|-------:|
| [mnemonist-object](https://www.npmjs.com/package/mnemonist)    | 10793 | 53191 | 40486  | 56497 | 8217  |
| [hashlru](https://npmjs.com/package/hashlru) *                 | 13860 | 14981 | 16340  | 15385 | 6959  |
| [simple-lru-cache](https://npmjs.com/package/simple-lru-cache) | 5875  | 36697 | 28818  | 37453 | 6866  |
| [tiny-lru](https://npmjs.com/package/tiny-lru)                 | 4378  | 36101 | 34602  | 40568 | 5626  |
| [lru-fast](https://npmjs.com/package/lru-fast)                 | 4993  | 38685 | 38986  | 47619 | 5224  |
| [quick-lru](https://npmjs.com/package/quick-lru) *             | 4802  | 3430  | 4958   | 3306  | 5024  |
| [hyperlru-object](https://npmjs.com/package/hyperlru-object)   | 3831  | 12415 | 13063  | 13569 | 3019  |
| [mnemonist-map](https://www.npmjs.com/package/mnemonist)       | 3533  | 10020 | 6072   | 6475  | 2606  |
| [lru](https://www.npmjs.com/package/lru)                       | 3072  | 3929  | 3811   | 4654  | 2489  |
| [secondary-cache](https://npmjs.com/package/secondary-cache)   | 2629  | 8292  | 4772   | 9699  | 2004  |
| [js-lru](https://www.npmjs.com/package/js-lru)                 | 2903  | 6202  | 6305   | 6114  | 1661  |
| [lru-cache](https://npmjs.com/package/lru-cache)               | 2158  | 3882  | 3857   | 3993  | 1350  |
| [hyperlru-map](https://npmjs.com/package/hyperlru-map)         | 1757  | 4425  | 3684   | 3503  | 1289  |
| [modern-lru](https://npmjs.com/package/modern-lru)             | 1637  | 2746  | 1934   | 2551  | 1057  |
| [mkc](https://npmjs.com/packacge/package/mkc)                  | 1589  | 2192  | 1283   | 2092  | 999   |

> Note that the [hashlru](https://npmjs.com/package/hashlru) and [quick-lru](https://npmjs.com/package/quick-lru) are not traditional LRU caches. They still have, mostly the first one, very good write performance but somewhat less good read performance because they have to perform two distinct hashmap lookups.

> 请注意，[hashlru](https://npmjs.com/package/hashlru) 和 [quick-lru](https://npmjs.com/package/quick-lru) 并不是传统的 LRU 缓存，它们仍然具有(主要是第一个)非常好的写性能，但读性能稍差，因为它们必须执行两个不同的hashmap查找。

> Libraries are ranked by eviction performance because this is usually the slowest operation and the most critical for a LRU cache. But it makes the results hard to read. You should take time to carefully peruse the list.

> 这些库的排名依据的是删除性能因为着通常是最慢但是对于 LRU 缓存至关重要的操作。但这使得这个结果很难理解，你需要花时间去细读这个列表。

You should also run it on your computer because, while the ranking is mostly stable, results tend to vary.

你也应该在你的电脑上运行一下它，因为虽然这个排名大多是稳定的，结果却是多变的。

Futhermore, it should be noted that the benchmarked libraries differ in the array of features they offer so the result is not completely fair either.

此外，应该注意的是，基准库提供的数组的特性不同，所以结果也不完全公平。

Finally, we should probably add memory consumption to the benchmark in the future, even if it is not easy to reliably measure it in JavaScript. Indeed, I strongly suspect that using typed arrays should help reducing the memory footprint of any implementation.

最后，将来我们可能将内存消耗加到基准测试中，虽然在 JavaScript 中可靠的测量内存消耗并不容易，事实上我严重怀疑使用类型化数组会有助于降低任何实现的内存消耗。

## Concluding remarks

## 结束语

Now you know how to use JavaScript typed arrays to create your own pointer system. This trick is not limited to fixed-capacity linked lists and can be used for a variety or other data structure implementation problems.

现在你知道如何使用 JavaScript 类型化数组创建自己的指针系统了。这个技巧不仅限于固定容量的链表，可以被用于各种数据结构的实现问题中。

> A lot of tree-like data structures can also beneficiate from this trick, for instance.

> 例如，很多树状数据结构也可以从这个技巧中收益。

But as per usual, and this advice stands for most high-level languages, optimizing JavaScript is the same as squinting really hard and pretending the language:

但是和往常一样，并且这个建议代表了大部分高级语言，优化 JavaScript 眯着眼睛假装使用这种语言一样。

> The **typed array pointers** trick is far from suited to every high-level language. In python, for instance, if you try to replicate this trick using `bytearray` or `np.array` you will actually get abysmal performances

> **类型化数组指针**技巧还远远不能适用于每一种高级语言。例如，在 python 中，如果你试图使用 `bytearray` 或者 `np.array` 复用这个技巧，你会发现性能非常糟糕。

1. has static typing
2. is low-level

1. 有静态的类型
2. 是低级的

Basically, the less choices the engine has to make, the easier it will be for it to optimize your code.

基本上，引擎的选择越少，优化代码就越容易。

Of course this is not advisable for application code and this level of optimization should only be a goal if you try to optimize critical things such as, off the top of my head, a LRU cache.

当然，这对于应用程序代码是不可取的，只有当你试图优化一些关键的东西时，才应该将这种优化级别当作目标，比如我所能想到的 LRU 缓存。

> LRU cache are very important to many implementations of memoization, for instance. Web servers and clients alike also massively rely on those kinds of caches.

>例如 LRU 缓存对于很多存储的实现都非常重要。Web 服务器和客户端同样大量依赖于这种缓存。

And finally, please don't take my words or advice too seriously. It is infamously tricky to optimize interpreted languages and JavaScript is even worse because you have to consider JIT compilation and several engines such as Gecko or V8.

最后，请不要把我的话或建议太当真，优化解释性语言是出了名的棘手， JavaScript 更是糟糕，因为你得考虑 JIT 和 多种引擎，例如 Gecko 或者 V8。

So, pretty please, do benchmark your code, for your mileage may vary.

所以，恳请您测试您的代码，因为你的经历可能不同。

  Have a good day!

  祝您生活愉快！

-----

## Miscellany

## 杂记

### About evictions & splay trees

### 关于删除和展开树

The single thing hampering every JavaScript implementation of a LRU cache is eviction performance. Getting rid of keys from either an object (using the `delete` keyword) or a map (using the `#.delete` method) is very costly.

在每一个 JavaScript 的 LRU 的实现中，唯一的阻碍的问题就是删除性能，不管是在一个对象(使用 `delete` 关键词)还是在一个 map 映射中(使用 `#.delete` 方法)删除一个键都是非常高消耗的。

> Once again the [hashlru](https://npmjs.com/package/hashlru) and [quick-lru](https://npmjs.com/package/quick-lru) libraries formulate an original solution to this issue and I warmly encourage you to check them.

> 再一次， 在 [hashlru](https://npmjs.com/package/hashlru) 和 [quick-lru](https://npmjs.com/package/quick-lru) 这两个库中提出了常规问题的解决方案，我强烈建议你阅读它们。

There seems to be no way around it because it is quite impossible (yet?) to beat the engines native hashmaps' performance from within interpreted JavaScript code.

似乎没有办法解决这个问题(目前？ )，因为使用解释型语言 JavaScript 击败引擎中原生的 hashmap 的性能几乎是不可能的。

> The contrary would be very counterintuitive since there is no way to run hash algorithms as fast the engine is able to do natively.

> 相反，这将是非常违反直觉的，因为没有办法运行哈希算法的速度能像引擎本身那样快。

> I tried to implement tree-based key-value associative data structures like [CritBit trees](https://cr.yp.to/critbit.html) but must report that it's not possible to beat a JavaScript object or map thusly.

> 我尝试实现基于树的键值关联数据结构，如[CritBit trees](https://cr.yp.to/critbit.html)，但必须说还是无法击败JavaScript对象或 map 映射。

> You can still implement those trees so that they can be only from 2 to 5 times less performant than native objects for certain use case, all while maintaining lexicographical order. Which is not too shabby. I guess?

> 您仍然可以实现这些树，以便它们在特定用例下的性能仅比原生对象低2到5倍，同时保持字典顺序。我猜这也不算太坏?

> Feel free to check the yet undocumented code [here](https://github.com/Yomguithereal/mnemonist/blob/master/critbit-tree-map.js)

> 自由查阅尚未归档的代码[这里](https://github.com/Yomguithereal/mnemonist/blob/master/critbit-tree-map.js)

This means that you can't roll your own map in JavaScript, a fixed-capacity one with inexpensive deletion for instance, and hope to beat what's already provided to you with the native object.

这意味着您不可能在 JavaScript 中运行您自己的 mapping，比如，一个具有低消耗删除功能的固定容量映射，并且希望能够超越原生对象已经提供给您的 map。

One interesting solution that would be nice to test is using [splay trees](https://en.wikipedia.org/wiki/Splay_tree).

一个有趣的解决方法值得一试是使用 [splay trees](https://en.wikipedia.org/wiki/Splay_tree)。

Those trees, being a binary search tree variant, support rather efficient associative key-value operations while being very suited to LRU caches since they already work by “splaying” very frequently accessed key to the top of their hierarchy.

这些树是二叉搜索树的变体，支持相当高效的关联键值操作，同时非常适合LRU缓存，因为它们已经通过将非常频繁访问的键“展开”到其层次结构的顶部来工作。

### What about webassembly?

### 关于webassembly

Wouldn't it be faster to implement a LRU cache using shiny new things such as `webassembly` rather than trying to shoehorn low-level concepts into JavaScript high-level code?

使用诸如 `webassembly` 这样大热的新东西来实现LRU缓存，而不是试图将底层概念硬塞进 JavaScript 高级代码中，会不会更快呢?

Well yes. But here is the trick: if you ever need to use this implementation from the JavaScript side, then you are out of luck because it will be slow as hell. Communication between the JavaScript side and the webassembly one will slow you down, just a little, but enough to make such an implementation moot.

是的。但这里有一个问题:如果您需要从JavaScript端使用这个实现，那么您就不走运了，因为它会非常慢。JavaScript端与web程序集端之间的通信将会减慢您的速度，虽然只是一点点，但足以使这样的实现变得毫无意义。

> Communication between wasm and JS has been wildly improving. Check this very good [blog post](https://hacks.mozilla.org/2018/10/calls-between-javascript-and-webassembly-are-finally-fast-%F0%9F%8E%89/) on the matter, for instance.

> wasm 与 JS 之间的通信被大幅的提高了，比如这个问题可以查阅 [blog post](https://hacks.mozilla.org/2018/10/calls-between-javascript-and-webassembly-are-finally-fast-%F0%9F%8E%89/)。

> But it's still not enough to justify having hot data structure methods run on the wasm side while being called from the JS side, unfortunately.

> 但是，不幸的是，在从JS端调用热数据结构方法的同时，在wasm端运行热数据结构方法仍然是不够的。

However, if you can afford to write some code that will only run in webassembly and doesn't need to rely on JavaScript's API, because you compile rust to webassembly for instance, then it's a tremendous idea to also implement your LRU cache there. You will definitely get better results.

但是，如果您能够编写一些只在webassembly中运行的代码，并且不需要依赖JavaScript的API，比如您将rust编译为webassembly，那么在那里实现LRU缓存也是一个非常棒的主意。你一定会得到更好的结果。

### Saving one pointer array

### 保存一个指针数组

There is a known trick with LRU cache you can use to save up one pointer level. It does not mean that you don't need a doubly-linked list anymore to be efficient but just that the hashmap/dictionary structure you are using can store pointers to the previous key rather than the related one to save up memory.

对于LRU缓存，有一个已知的技巧可以用来保存一个指针级别。这并不意味着您不再需要双链表来提高效率，但是您使用的 hashmap/dictionary 结构可以存储指向前一个键的指针，而不是相关键的指针，从而节省内存。

I won't explain this here but you can head to this [stackoverflow answer](https://stackoverflow.com/questions/49621983/lru-cache-with-a-singly-linked-list#answer-49622080) if you want to get the gist of it.

我在这里就不解释了但是如果你想要了解要点可以去这里  [stackoverflow answer](https://stackoverflow.com/questions/49621983/lru-cache-with-a-singly-linked-list#answer-49622080)。

Just note that, in JavaScript, it's usually not a good idea if you want to remain performant (computation-wise, not memory-wise, obviously) since you will need more hashmap lookups to update pointers, and they are quite costly.

请注意，在JavaScript中，如果您想保持性能(显然是在计算方面，而不是内存方面)，这通常不是一个好主意，因为您将需要更多的 hashmap 查找来更新指针，而且它们消耗非常大。

### About arbitrary evictions

### 关于任意删除


Note that the LRU cache implementation proposed here will have a hard time handling arbitrary evictions, i.e. letting the user delete keys.
https://github.com/hanxiaosss/gold-miner/tree/translation/lru-cache.md/TODO1
注意，这里提出的 LRU 缓存实现将很难处理任意的清除，即让用户删除键。

Why? Because for now, since we only need to swap key-value pairs when inserting a new key that will evict the LRU one, we don't need to have a way to find “available” slots in our memory. Those slots, if the user can delete keys at will, would be randomly found in the typed array and we would need a way to track them in order to “reallocate” them.

为什么? 因为到目前为止，由于在当要清除一个 LRU 的键来腾出空间插入新的键时，我们才交换键值对，所以我们不需要找到内存中 “可用” 插槽的方法。如果用户可以随意删除键，那么这些插槽就会随机出现在输入数组中，我们需要一种方法来跟踪它们，以便 “重新分配” 它们。

This could be done by using an additional array serving as a free pointer stack, but this has obviously a memory and performance cost.

可以通过使用一个额外的数组作为一个空闲指针堆栈来实现，但这显然会消耗内存和性能。

### A fully dynamic custom pointer system

### 一个完全动态的自定义指针系统

Here I mostly spoke of typed arrays to implement fixed-capacity pointer system. But if you are a little bit more ambitious you can very well imagine designing a dynamic-capacity pointer system.

这里我主要讲的是实现固定容量指针系统的类型化数组。但如果你更有野心，你可以很好地想象设计一个动态容量指针系统。

To do so, you can use dynamic typed arrays like mnemonist's [Vector](https://yomguithereal.github.io/mnemonist/vector.html). They are sometimes more efficient than vanilla JavaScript arrays when handling numbers and will let you implement what you need.

为此，可以使用动态类型数组，如 mnemonist 的 [Vector](https://yomguithereal.github.io/mnemonist/vector.html) 。在处理数字时，它们有时比普通的 JavaScript 数组更有效，并且可以让您实现所需的功能。

I am unsure whether having a custom dynamic pointer system would yield any performance improvement when implementing some other data structure however.

但是，我不确定在实现其他数据结构时，使用自定义动态指针系统是否会带来任何性能改进。

## Links

### 相关链接

* You might find the [mnemonist](https://yomguithereal.github.io/mnemonist/) library useful. It contains a lot of efficient and cohesive data structure implementations for JavaScript.

* 你会发现 [mnemonist](https://yomguithereal.github.io/mnemonist/) 非常有用。它包含的很多 JavaScript 高效和内聚的数据结构的实现。

* I did a [talk](https://fosdem.org/2019/schedule/event/data_structures_javascript/) about implementing data structures in JavaScript at FOSDEM in 2019 ([slides](https://yomguithereal.github.io/mnemonist/presentations/fosdem2019)).

* 我做了一个关于 2019 年在 FOSDEM 用 JavaScript 实现数据结构的演讲 ([slides](https://yomguithereal.github.io/mnemonist/presentations/fosdem2019))。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
