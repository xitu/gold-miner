> * 原文地址：[Implementing an efficient LRU cache in JavaScript](https://yomguithereal.github.io/posts/lru-cache)
> * 原文作者：[Yomguithereal](https://github.com/Yomguithereal)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/lru-cache.md](https://github.com/xitu/gold-miner/blob/master/TODO1/lru-cache.md)
> * 译者：[hanxiaosss](https://github.com/hanxiaosss)
> * 校对者：[TokenJan](https://github.com/TokenJan), [shixi-li](https://github.com/shixi-li)

# 使用 JavaScript 实现一个高效的 LRU 缓存  

> 如何利用 JavaScript 类型化数组的强大功能，为固定容量的数据结构设计自己的低成本指针系统

假设我们需要处理一个非常大（比如几百 GB）的 csv 文件，其中包含需要下载的 url。  
为了确保我们在解析整个文件的时候不会耗尽内存，我们逐行的读取这个文件：

```js
csv.forEachLine(line => {
  download(line.url);
});
```

现在假设创建这个文件的人忘记删除重复的 url。

> 我知道使用 `sort -u` 可以很容易解决，但这不是重点。
> 去重 url 可能并不像它看起来那么简单。比如你可以查看 python 中的 [ural](https://github.com/medialab/ural#readme) 库，了解这方面可以实现的一些示例。

这是一个问题，因为我们并不想多次获取同一个 url：从网页获取资源是耗时的并且我们需要做到尽量简洁以避免我们对获取资源的站点发出过多的请求。

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

此时，精明的读者会注意到，我们刚刚放弃了逐行读取 csv 文件的意图，因为现在我们需要将它的所有 url 提交到内存中。

这就是问题所在：我们希望避免多次获取相同的 url，同时确保不会耗尽内存。我们必须找一个折中的办法。

> **有趣的事实**：如果你处理来自 Internet 的数据，例如爬取的 url 列表，你将会不可避免的遇到 [power law](https://en.wikipedia.org/wiki/Power_law) 这一类的问题。这很常见，因为人们链接到 `twitter.com` 的次数指数级地多于链接到 `unknownwebsite.fr` 的次数。

对我们来说幸运的是，似乎只有一小部分包含在文件中的 url 是经常重复的，其余的绝大部分 url 都只出现一两次。我们可以设计一个策略来利用这一事实，将 map 中我们觉得不太可能再次出现的 url 删除，因此，我们不允许我们的 map 超过一个我们预先设定的内存量。

最常用的驱逐策略之一是 “LRU”

**L**east **R**ecently **U**sed.

## LRU 缓存

因此，我们理解 LRU 缓存是一个固定容量的 map，可以根据以下方式将键值进行绑定：如果缓存是满的我们仍需要插入一个新的元素，我们将通过删除最近最少使用的元素来腾出空间。

这样一来，缓存需要以最后访问的顺序存储给定的项。因此，每次有人试图设置一个新的键，或者访问一个新的键，我们都要修改底层的列表以确保维护我们所需的顺序。

> **注意**：LFU(LFU (最不经常使用)) 是一个完全有效的缓存驱逐策略，只是没有那么普遍，你可以点击 [这里](https://en.wikipedia.org/wiki/Cache_replacement_policies#Least-frequently_used_(LFU)) 阅读相关资料，也可以在 [这里](https://www.geeksforgeeks.org/lfu-least-frequently-used-cache-implementation/) 找到实现笔记

但是为什么是这个顺序至关重要呢？难道不是记录下每项元素被访问的次数以便我们清除最近最少使用的元素更好一些吗？

不一定，下面是一些原因：

* LRU 其实是 LFU 一个很好的替代品，因为对一个键值对访问得越频繁，它被清除的几率就越小。
* 除了其他内容外，你还需要存储整数，以便跟踪该元素的访问次数。
* 按照最后访问顺序排列元素非常直观，因为它可以与缓存上的操作同步。
* LFU 通常会强制你任意选择要清除的元素：比如，如果所有的键值对都只被访问过一次。对于 LRU，你不用做这样的抉择：你只需要清除最近最少使用的元素，这里不会存在歧义。

## 实现一个 LRU 缓存

实现一个有效的 LRU 缓冲有很多种方法，但是我只会着重讲在开发高层语言时你最有可能用到的方法。

通常，实现一个合适的 LRU 缓存，我们需要以下两个要素：

1. 一个类似于 [hashmap](https://en.wikipedia.org/wiki/Hash_table) 的数据结构，能够高效的检索与任意键相关联的值 ———— 比如字符串。在 JavaScript 中，我们可以使用 ES6 的 `Map ` 或者任何普通的对象 `{}`：记住我们的缓存与一个固定容量的键值对存储没什么不同。
2. 一种将所有元素按最后访问顺序存储的方法。更重要的是，我们将需要有效地移动元素，这也是人们通常倾向于使用 [双向链表](https://en.wikipedia.org/wiki/Doubly_linked_list) 来实现。

我们的实现至少需要可以执行下面两个操作：

* `#.set`：关联值到给定的键，同时当缓存已满时清除最近最少使用的元素。
* `#.get`：如果给定键在缓存中存在，检索与给定键关联的值，同时更新底层列表来保持 LRU 顺序。

接下来是我们如何使用这样一个缓存：

```js
// 创建一个可以容纳3个元素的缓存
const cache = new LRUCache(3);

// 添加一些元素
cache.set(1, 'one');
cache.set(2, 'two');
cache.set(3, 'three');

// 到目前为止，没有元素从缓存中清除
cache.has(2);
>>> true

// 噢不！我们需要添加一个新的元素
cache.set(4, 'four');

// `1` 被清除掉了因为它是最近最少使用的键
cache.has(1);
>>> false

// 如果我们访问 `2` ，它就不再是 LRU 的键了
cache.get(2);
>>> 'two'

// 这意味着 `3` 将被清除
cache.set(5, 'five');
cache.has(3);
>>> false

// 因此我们从来不会存储超过 3 个元素
cache.size
>>> 3
cache.items()
>>> ['five', 'two', 'four']
```

## 双向链表

问题：为什么我们的案例中使用一个单链表还不够？因为我们需要在我们的列表中高效的执行以下操作：

- 在列表的起始位置放置一个元素
- 在列表的任意位置将一个元素移到起始位置
- 将列表的最后一个元素移除同时保持新产生的最后一个元素的指针正确

为了能够实现一个 LRU 缓存，我们需要实现一个双向链表来确保我们可以按照最后访问顺序来存储所有元素：以最近使用的元素起始并且以最近最少使用的元素结束。

> 请注意，可能正好相反，列表的方向并不重要。

所以我们如何在内存中表示一个双向链表？通常，我们通过创建一个节点结构包含：

1. 一个有效荷载，也就是实际要存储的值或者元素。它可以是任意类型，从字符串到整型……
2. 列表中指向前一个元素的指针。
3. 列表中指向下一个元素的指针。

然后我们也需要存储列表第一个和最后一个元素的指针。这样就完成了。

> 如果你不太确定什么是指针，那么现在可能是复习 [指针](https://en.wikipedia.org/wiki/Pointer_(computer_programming)) 的好时机。

如下图，它看起来是这样的：

```c
节点的结构：

  (prev|payload|next)

  payload：字符串型，存储的值
  prev：指向前一个元素的指针
  next：指向下一个元素的指针
  •: 指针
  x: null 空指针

链表结构：

       ┌─────>┐   ┌───────>┐   ┌────────>┐
  head • (x|"one"|•)  (•|"two"|•)  (•|"three"|x) • tail
              └<───────┘   └<───────┘    └<──────┘
```

## LRU 缓存列表操作

只要缓存没有满，维护我们获取的元素列表是非常简单的，我们只需要在列表前插入一个新添加的元素：

```c
1. 一个容量为3 的空缓存


  head x     x tail


2. 插入为 “one” 的键

       ┌─────>┐
  head • (x|"one"|x) • tail
              └<─────┘

3. 插入为 “two” 的键 (注意 “two” 如何插入到链表前面)

       ┌─────>┐   ┌───────>┐
  head • (x|"two"|•)  (•|"one"|x) • tail
              └<───────┘   └<─────┘

4. 最后我们插入为 “three” 的键

       ┌──────>┐    ┌───────>┐   ┌───────>┐
  head • (x|"three"|•)  (•|"two"|•)  (•|"one"|x) • tail
               └<────────┘   └<───────┘   └<─────┘
```

到目前为止一切顺利。现在，为了将我们的列表保持在 LRU 的顺序，如果任何人访问已经存储在缓存中的键，我们就需要将访问的键移动到列表的起始位置来重新排序：

```c
1. 我们的缓存目前的状态

       ┌──────>┐    ┌───────>┐   ┌───────>┐
  head • (x|"three"|•)  (•|"two"|•)  (•|"one"|x) • tail
               └<────────┘   └<───────┘   └<─────┘

2. 访问 "two" 键，我们先将该元素从列表中提取出来
并将它的前一个元素和后一个元素重新链接起来。

  提取：(x|"two"|x)

       ┌──────>┐    ┌───────>┐
  head • (x|"three"|•)  (•|"one"|x) • tail
               └<────────┘   └<─────┘

3. 然后将它移至最前面

       ┌─────>┐   ┌────────>┐    ┌───────>┐
  head • (x|"two"|•)  (•|"three"|•)  (•|"one"|x) • tail
              └<───────┘    └<────────┘   └<─────┘
```

注意每次我们都需要更新头指针，以及有时我们也需要更新尾指针。

最后，如果这个缓存已经满了，一个未知的键需要被插入，所以我们需要把列表中最后一项元素移出以为新的元素腾出空间。

```c
1. 当前的缓存状态是这样的

       ┌─────>┐   ┌────────>┐    ┌───────>┐
  head • (x|"two"|•)  (•|"three"|•)  (•|"one"|x) • tail
              └<───────┘    └<────────┘   └<─────┘

2. 这时我们需要插入一个键为 “six” 的元素，但是缓存已经满了
   我们需要将作为 LRU 元素的 “one” 删除

  移除：(x|"one"|x)

       ┌─────>┐   ┌────────>┐
  head • (x|"two"|•)  (•|"three"|•) • tail
              └<───────┘    └<──────┘

3. 然后将新元素插到前面
       ┌─────>┐   ┌───────>┐   ┌────────>┐
  head • (x|"six"|•)  (•|"two"|•)  (•|"three"|x) • tail
              └<───────┘   └<───────┘    └<──────┘
```

以上是实现一个好的 LRU 缓存我们所需要了解的有关双向链表的知识。

## 使用 JavaScript 实现一个双向链表

现在有一个小问题：JavaScript 语言本身没有指针。事实上我们只能通过传递引用来解决，通过访问对象属性来取消传递指针。

这意味着人们通常通过在 JavaScript 中写像下面的类来实现链表：

```js
//节点的类构造函数
function Node(value) {
  this.value = value;
  this.previous = null;
  this.next = null;
}

//列表的类构造函数
function DoublyLinkedList() {
  this.head = null;
  this.tail = null;
}

//执行操作
// 应该被包裹在列表的方法内
const list = new DoublyLinkedList();

const node1 = new Node('one');
const node2 = new Node('two');

list.head = node1;
list.tail = node2;

node1.next = node2;
node2.previous = node1;

// ...
```

虽然这个方法没有什么问题，但是它仍然有一些缺点会使这种看起来类似的实现执行得不高效：

1. 每次你实例化一个节点，都会为记录分配一些多余的内存。
2. 如果列表移动的很快，比如节点被频繁的添加或者移除，将会触发垃圾回收机制导致运行变慢。
3. 大多数时候，引擎会试图将对象优化为低级的结构，但是你却没法控制。
4. 最后，和 `3.` 相关的，访问对象属性并不是 JavaScript 世界里最快的方式。

> 这就是为什么你不会看到很多人在 JavaScript 代码的应用中使用链表。只有在特定情况下需要使用它的人才会真正用到它，比如在算法上非常出色的时候。node.js 有类似这样的实现 [这里](https://github.com/nodejs/node/blob/master/lib/internal/linkedlist.js)，并且你可以发现它应用于定时器 [这里](https://github.com/nodejs/node/blob/master/lib/internal/timers.js)。

但是我们可以做到比这个更智能一点。事实上，我们可以利用链表的一个特性来提高性能：它的容量不能超过给定的数字。

所以，我们不使用 JavaScript 的引用和属性作为指针，让我们使用 [Typed Arrays](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/TypedArray) 玩转我们自己的指针系统。

## 自定义的指针系统

类型化数组是非常简洁的 JavaScript 对象，能够代表固定容量数组，其中包含一些典型的数字类型，例如 int32 或者 float64 等等……

它相当的快并且消耗很少的内存，因为被存储的元素都是静态类型的，不会受记录开销影响。

下面是如何使用：

```js
// 由 256 位无符号的 16 位字节整数组成的类型化数组
const array = new Uint16Array(256);

// 将每个索引都初始化为 0。
// 我们可以很自然地读取/设置元素
array[10] = 34;
array[10];
>>> 34

// 但是这个缓存：我们不能添加一个新的元素
array.push(45);
>>> throw `TypeError: array.push is not a function`
```

> 而且，从概念上讲，使用 JavaScript 实例化一个类型化数组和使用 c 语言调用一个 `malloc` 相差不远，或者至少可以使用它们在两种语言中执行相同的任务。

既然我们可以使用这些高性能的数组，我们为什么不使用它们实现我们自己的指针系统呢？毕竟指针也不过是映射内存块的地址。

我们使用一个类型化数组作为我们的内存块，并把它的索引作为地址！现在唯一棘手的部分就是根据我们的容量正确地选择一个整数类型，以免溢出。

> 如果你还不是不知道如何开发，参考这个函数 [这里](https://github.com/Yomguithereal/mnemonist/blob/7ea90e6fec46b4c2283ae88f173bfb19ead68734/utils/typed-arrays.js#L8-L54)

所以，为了用 JavaScript 给我们的 LRU 缓存结构实现一个固定容量的双链表结构，我们需要下面的类型化数组：

1. 一个普通的数组用来存储我们列表的有效荷载，也就是键值对。或者两个类型数组或普通数组来根据它们各自的类型分别存储键和值。比如，如果我们可以保证我们的值不超过 32 位整数，那么我们可以再一次利用类型数组完成这个任务。
2. 一个类型化数组，它存储了一系列表示下一个指针的索引。
3. 另一个类型化数组，它存储了一组表示上一个指针的索引。

> 通常，当你需要确保索引 `0` 代表一个空值或者空指针，使用**类型化数组指针**会有一点冗余。两个巧妙地办法来规避这个问题：
> - 你可以通过保持第一个元素为空来偏移存储值的数组，这样 `0` 索引就不会有存储任何重要内容的风险了。
> - 你可以将索引偏移 1，但是这通常需要对索引执行一些轻量级的运算，这会使得代码看起来非常复杂，难以理解。
> 
> 请注意，人们也使用有符号的类型数组而不是无符号 (显然就是索引不能为负数) 的类型数组的技巧来添加一个间接层：指针可以根据索引的符号表示一个或另一个不同的东西
> 例如，有的时候会通过负的索引节约内存，将 [Trie](https://en.wikipedia.org/wiki/Trie) 中一个节点标识为叶子节点。

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

// 下面是之前的例子：
const list = new DoublyLinkedList();

const node1 = new Node('one');
const node2 = new Node('two');

list.head = node1;
list.tail = node2;

node1.next = node2;
node2.previous = node1;

// 现在应该是这样的
const list = new FixedCapacityDoublyLinkedList(2);

// 第一个节点
list.keys[0] = 'one';
list.values[0] = 1;

// 第二个节点
list.keys[1] = 'two';
list.values[1] = 2;

// 节点的写入和指针连接
list.next[0] = 1;
list.previous[1] = 0;

list.head = 0;
list.tail = 1;
```

这个代码看起来有一些复杂，但是现在，我们不再设置属性，而是在类型化数组中查找和设置索引。

如下图所示，我们是这样做的：

```c
表示以下列表：

       ┌──────>┐    ┌───────>┐   ┌───────>┐
  head • (x|"three"|•)  (•|"two"|•)  (•|"one"|x) • tail
               └<────────┘   └<───────┘   └<─────┘

我们这次存储下面的索引和数组：

  head     = 2
  tail     = 0
  capacity = 3
  size     = 3

  index       0      1       2
  keys   = ["one", "two", "three"]
  prev   = [    1,     2,       x]
  next   = [    x,     0,       1]

// x (空指针) 应该为 0 
//但是简单起见不用考虑这么多
```

所以，如果我们使用新方案 “重新运行” [前面的例子](#lru-cache-list-operations) 所需的列表操作，我们会得到：

```c
1. 我们以一个空列表开始：

  head     = x
  tail     = x
  capacity = 3
  size     = 0

  index       0      1      2
  keys   = [    x,     x,     x]
  prev   = [    x,     x,     x]
  next   = [    x,     x,     x]

2. 插入 “one”

  head     = 0
  tail     = 0
  capacity = 3
  size     = 1

  index       0      1      2
  keys   = ["one",     x,     x]
  prev   = [    x,     x,     x]
  next   = [    x,     x,     x]

3. 插入 “two”

  head     = 1
  tail     = 0
  capacity = 3
  size     = 2

  index       0      1      2
  keys   = ["one", "two",     x]
  prev   = [    1,     x,     x]
  next   = [    x,     0,     x]

4. 插入 “three”

  head     = 2
  tail     = 0
  capacity = 3
  size     = 3

  index       0      1       2
  keys   = ["one", "two", "three"]
  prev   = [    1,     2,       x]
  next   = [    x,     0,       1]

5. 访问 “two” 并将它放到列表的前面
   (注意只有指针改变值不变)

  head     = 1
  tail     = 0
  capacity = 3
  size     = 3

  index       0      1       2
  keys   = ["one", "two", "three"]
  prev   = [    2,     x,       1]
  next   = [    x,     2,       0]

6. 最后插入 “six” 然后删除 “one”

  head     = 0
  tail     = 2
  capacity = 3
  size     = 3

  index       0      1       2
  keys   = ["six", "two", "three"]
  prev   = [    1,     0,       1]
  next   = [    x,     2,       x]
```

看起来很无聊，不是吗？

但是这其实是一件好事，它意味着我们不需要过多地移动元素，我们也不创建元素，我们只需要读写数组的索引。

所以为什么这种方式比我们之前讨论的那种传统的实现方式快呢？

- 内存只会被分配一次，新的对象从未被实例化而旧的对象一直未被垃圾收集。<SideNote id="pool"> 是的，你可以通过使用对象池临时地调整内存分配和垃圾回收。但是如果你依赖类型化数组你会发现它更快并且占用更少的内存。</SideNote>并且内存的可预测性在 LRU缓存的实现中是非常可取的。
我们的实现中唯一的内存问题是当映射中的键的容量填满后，稍后删除其中一些键。
- 数组索引的查找/写入都非常快是因为分配的内存大多是连续的，对于类型化数组更是如此。你不需要很大幅度的跳跃来找你需要的东西，而且缓存优化能更好的展示他们的神奇。
- 无需过多的解释。引擎不需要对任何事情都智能，并且能够即时自如的应对非常低级的优化。

## 真的值得这么麻烦吗？

为了确认这一点，我尝试着实现了我刚刚描述的自定义指针系统并对其进行基准测试。

所以你可以在这个 [mnemonist](https://github.com/Yomguithereal/mnemonist) 库里面看到一个基于类型化数组的 LRU 缓存实现。你也可以在 [`LRUCache`](https://yomguithereal.github.io/mnemonist/lru-cache) 查阅依赖 JavaScript 对象的实现方式，以及另一个依赖 ES6 `Map` 实现 [`LRUMap`](https://yomguithereal.github.io/mnemonist/lru-map)。

你可以在 [这里](https://github.com/Yomguithereal/mnemonist/blob/master/lru-cache.js) 阅读他们的源码，然后自己决定处理索引而不是对象属性是否很混乱。

然后这里是一个公共的基准测试仓库 [dominictarr/bench-lru](https://github.com/dominictarr/bench-lru) 。尽管每个基准测试并不能完全适合你的用例，但是它仍可以避免一些常见的无关引擎优化的陷阱以及其他相关问题。

下面是最近一些基准测试结果，用 ops/ms (越高越好) 来表示各种典型的 LRU 缓存方法，在我 2013 年的 MacBook 上使用 node `12.6.0 `：

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

> 请注意，[hashlru](https://npmjs.com/package/hashlru) 和 [quick-lru](https://npmjs.com/package/quick-lru) 并不是传统的 LRU 缓存，它们仍然具有 (主要是第一个) 非常好的写性能，但读性能稍差，因为它们必须执行两个不同的 hashmap 查找。
> 这些库的排名依据的是删除性能，因为这通常是最慢但是对于 LRU 缓存至关重要的操作。但这使得这个结果很难理解，你需要花时间去细读这个列表。

你也应该在你的电脑上运行一下它，因为虽然这个排名大多是稳定的，但结果也会有不同。

此外，应该注意的是，基准库提供的数组的特性不同，所以结果也不完全公平。

最后，将来我们可能将内存消耗加到基准测试中，虽然在 JavaScript 中可靠的测量内存消耗并不容易，事实上我严重怀疑使用类型化数组会有助于降低任何实现的内存消耗。

## 结束语

现在你知道如何使用 JavaScript 类型化数组创建自己的指针系统了。这个技巧不仅限于固定容量的链表，可以被用于各种数据结构的实现问题中。

> 例如，很多树状数据结构也可以从这个技巧中受益。

但是和往常一样，并且这个建议代表了大部分高级语言，优化 JavaScript 就像努力眯着眼睛假装使用这种语言一样。

> **类型化数组指针**技巧还远远不能适用于每一种高级语言。例如，在 python 中，如果你试图使用 `bytearray` 或者 `np.array` 复用这个技巧，你会发现性能非常糟糕。

1. 有静态的类型
2. 是低级的

基本上，引擎的选择越少，优化代码就越容易。

当然，这对于应用程序代码是不可取的，只有当你试图优化一些关键的东西时，才应该将这种优化级别当作目标，比如我所能想到的 LRU 缓存。

> 例如 LRU 缓存对于很多存储的实现都非常重要。Web 服务器和客户端同样大量依赖于这种缓存。

最后，请不要把我的话或建议太当真，优化解释性语言是出了名的棘手，JavaScript 更是糟糕，因为你得考虑 JIT 和多种引擎，例如 Gecko 或者 V8。

所以，恳请您测试您的代码，因为您的具体场景可能不尽相同。

祝您生活愉快!

-----

## 杂记

### 关于删除和展开树

在每一个 JavaScript 的 LRU 的实现中，唯一的阻碍的问题就是删除性能，不管是在一个对象 (使用 `delete` 关键词) 还是在一个 map 映射中 (使用 `#.delete` 方法) 删除一个键都是非常高消耗的。

> 再一次，在 [hashlru](https://npmjs.com/package/hashlru) 和 [quick-lru](https://npmjs.com/package/quick-lru) 这两个库中提出了常规问题的解决方案，我强烈建议你阅读它们。

似乎 (目前？) 没有办法解决这个问题，因为使用解释型语言 JavaScript 击败引擎中原生的 hashmap 的性能几乎是不可能的。

> 相反，这将是非常违反直觉的，因为没有办法运行哈希算法的速度能像引擎本身那样快。
> 我尝试实现基于树的键值关联数据结构，如 [CritBit trees](https://cr.yp.to/critbit.html)，但必须说还是无法击败 JavaScript 对象或 map 映射。
> 您仍然可以实现这些树，以便它们在特定用例下的性能仅比原生对象低 2 到 5 倍，同时保持字典顺序。我猜这也不算太坏？
> 自由查阅尚未归档的代码 [这里](https://github.com/Yomguithereal/mnemonist/blob/master/critbit-tree-map.js)

这意味着您不可能在 JavaScript 中运行您自己的 map，比如，一个具有低消耗删除功能的固定容量映射，并且希望能够超越原生对象已经提供给您的 map。

一个有趣的解决方法值得一试是使用 [splay trees](https://en.wikipedia.org/wiki/Splay_tree)。

这些树是二叉搜索树的变体，支持相当高效的关联键值操作，同时非常适合 LRU 缓存，因为它们已经通过将非常频繁访问的键“展开”到其层次结构的顶部来工作。

### 关于webassembly

使用诸如 `webassembly` 这样大热的新东西来实现 LRU 缓存，而不是试图将底层概念硬塞进 JavaScript 高级代码中，会不会更快呢？

是的。但这里有一个问题：如果您需要从 JavaScript 端使用这个实现，那么您就不走运了，因为它会非常慢。JavaScript 端与 web 程序集端之间的通信将会减慢您的速度，虽然只是一点点，但足以使这样的实现变得毫无意义。

> wasm 与 JS 之间的通信被大幅的提高了，比如这个问题可以查阅 [blog post](https://hacks.mozilla.org/2018/10/calls-between-javascript-and-webassembly-are-finally-fast-%F0%9F%8E%89/)。
> 但是，不幸的是，在从 JS 端调用热数据结构方法的同时，在 wasm 端运行热数据结构方法仍然是不够的。

但是，如果您能够编写一些只在 webassembly 中运行的代码，并且不需要依赖 JavaScript 的 API，比如您将 rust 编译为 webassembly，那么在那里实现 LRU 缓存也是一个非常棒的主意。你一定会得到更好的结果。

### 保存一个指针数组

对于 LRU 缓存，有一个已知的技巧可以用来保存一个指针级别。这并不意味着您不再需要双链表来提高效率，但是您使用的 hashmap/dictionary 结构可以存储指向前一个键的指针，而不是相关键的指针，从而节省内存。

我在这里就不解释了，但是如果你想要了解要点可以去这里 [stackoverflow answer](https://stackoverflow.com/questions/49621983/lru-cache-with-a-singly-linked-list#answer-49622080)。

请注意，在 JavaScript 中，如果您想保持性能（显然是在计算方面，而不是内存方面），这通常不是一个好主意，因为您将需要更多的 hashmap 查找来更新指针，而且它们消耗非常大。

### 关于任意删除

注意，这里提出的 LRU 缓存实现将很难处理任意的清除，即让用户删除键。

为什么？因为到目前为止，由于在当要清除一个 LRU 的键来腾出空间插入新的键时，我们才交换键值对，所以我们不需要找到内存中“可用”插槽的方法。如果用户可以随意删除键，那么这些插槽就会随机出现在输入数组中，我们需要一种方法来跟踪它们，以便“重新分配”它们。

可以通过使用一个额外的数组作为一个空闲指针堆栈来实现，但这显然会消耗内存和性能。

### 一个完全动态的自定义指针系统

这里我主要讲的是实现固定容量指针系统的类型化数组。但如果你更有野心，你可以很好地想象设计一个动态容量指针系统。

为此，可以使用动态类型数组，如 mnemonist 的 [Vector](https://yomguithereal.github.io/mnemonist/vector.html)。在处理数字时，它们有时比普通的 JavaScript 数组更有效，并且可以让您实现所需的功能。

但是，我不确定在实现其他数据结构时，使用自定义动态指针系统是否会带来任何性能改进。

### 相关链接

* 你会发现 [mnemonist](https://yomguithereal.github.io/mnemonist/) 非常有用。它包含的很多 JavaScript 高效和内聚的数据结构的实现。
* 我做了一个关于 2019 年在 FOSDEM 用 JavaScript 实现数据结构的演讲 ([slides](https://yomguithereal.github.io/mnemonist/presentations/fosdem2019))。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
