> * 原文地址：[Implementing an efficient LRU cache in JavaScript](https://yomguithereal.github.io/posts/lru-cache)
> * 原文作者：[Yomguithereal](https://github.com/Yomguithereal) 
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/lru-cache.md](https://github.com/xitu/gold-miner/blob/master/TODO1/lru-cache.md)
> * 译者：
> * 校对者

# Implementing an efficient LRU cache in JavaScript

> Where we discover how to harness the power of JavaScript's typed arrays to design our very own low-cost pointer system for fixed-capacity data structures

Let's say we need to process a very large – hundreds of gigabytes large – csv file containing urls we will need to download.
To ensure we are not going to run out of memory while parsing the whole file, we read the file line by line:

```js
csv.forEachLine(line => {
  download(line.url);
});
```

Now let's say the person that created our file forgot to deduplicate the urls.

> I am aware that this could easily be solved by using `sort -u` but that's not the point.
> Deduping urls is not as straigthforward as it may seem. Check the [ural](https://github.com/medialab/ural#readme) library in python, for instance, for some examples of what can be achieved in this regard.

This is an issue because we don't want to fetch the same url more than once: grabbing resources from the web is time-consuming & should be done parcimoniously not to flood the sites we are grabbing those resources from.

An obvious solution could be to remember urls we already fetched by caching them into a map:

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

And herein lies the issue: we want to avoid fetching the same url more than once while also making sure we don't run out of memory. We have to find a way to compromise.

>**Fun fact**: if you work with data coming from the Internet such as lists of crawled urls, you will inevitably stumble upon this kind of [power law](https://en.wikipedia.org/wiki/Power_law). It naturally occurs because people link exponentially more to `twitter.com` than `unknownwebsite.fr`.

Fortunately for us, it seems that only a tiny fraction of the urls contained in our file are repeated very often while the vast majority of others only appears one or two times. We can leverage this fact by designing a policy to throw away urls from our map if we have a good intuition they are unlikely to appear again. Thus, we won't allow our map to exceed a predetermined amount of memory.

And one of the most commonly used eviction policy is called “LRU”: 

**L**east **R**ecently **U**sed.

## The LRU cache

Hence, we understand that a LRU cache is a fixed-capacity map able to bind values to keys with the following twist: if the cache is full and we still need to insert a new item, we will make some place by evicting the least recently used one.

To do so, the cache will need to store given items in order of their last access. Then, each time someone tries to set a new key, or access a key, we need to modify the underlying list to ensure the needed order is maintained.

>**Note**: LFU (Least Frequently Used) is a perfectly valid cache eviction policy. It's just less widespread. You can read about it [here](https://en.wikipedia.org/wiki/Cache_replacement_policies#Least-frequently_used_(LFU)) and find implementation notes [here](https://www.geeksforgeeks.org/lfu-least-frequently-used-cache-implementation/).

But why is this order relevant? Wouldn't it be better to record the number of times each item was accessed so we can evict the **L**east **R**ecently **U**sed instead?

Not necessarily. Here are some reasons why:

* LRU is a actually a good proxy of LFU since the more frequently a pair is accessed, the less chance it has to be evicted.
* You will need to store integers in addition to everything else to keep track of the number of times the items were accessed.
* Ordering items on their last access is very straightforward to do since it can be synchronized with operations on the cache.
* LFU will often force you to make an arbitrary choice of item to evict: for instance if all your pairs have been accessed only once. With LRU, you don't have such choice to make: you just evict the least recently used. No ambiguity here.

## Implementing a LRU cache

There are many ways to implement a working LRU cache but I will only focus on the way you are most likely to encounter in the wild when developing for high-level languages.

Usually, to implement a proper LRU cache, we need the two following ingredients:

1. A [hashmap](https://en.wikipedia.org/wiki/Hash_table)-like data structure able to retrieve values associated to arbitrary keys – such as strings – efficiently. In JavaScript we can either use the ES6 `Map` or any plain object `{}`: remember that our cache is no different from a fixed-capacity key-value store.
2. A way to store our items in the order of their last access. What's more, we will need to move items around efficiently. That's why people naturally lean toward a [doubly-linked list](https://en.wikipedia.org/wiki/Doubly_linked_list) for the job.

Minimally, our implementation needs to be able to run the two following operations:

* `#.set`: associating a value to the given key, while evicting the least recently used item if the cache is already full.
* `#.get`: retrieving the value associated to the given key if this one exists at all in the cache, while updating the underlying list to keep LRU order.

And here is how we could use such a cache:

```js
// Let's create a cache able to contain 3 items
const cache = new LRUCache(3);

// Let's add items
cache.set(1, 'one');
cache.set(2, 'two');
cache.set(3, 'three');

// Up until now, nothing was evicted from the cache
cache.has(2);
>>> true

// Oh no! we need to add a new item
cache.set(4, 'four');

// `1` was evicted because it was the LRU key
cache.has(1);
>>> false

// If we get `2`, it won't be the LRU key anymore
cache.get(2);
>>> 'two'

// Which means that `3` that will get evicted now!
cache.set(5, 'five');
cache.has(3);
>>> false

// Thus we never store more than 3 items
cache.size
>>> 3
cache.items()
>>> ['five', 'two', 'four']
```

## Doubly-linked lists

Question: Why isn't a singly-linked list enough in our case? Because we have to efficiently perform the following operations on our list:
- place an item at the beginning of the list
- move an item from anywhere in the list to its beginning
- remove the last item from the list while keeping a correct pointer to the new last item

To be able to implement a LRU cache, we will need to implement a doubly-linked list to make sure we are able to store our items in order of their last access: the most recently used item starting the list and the least recently used one ending it.

> Note that it could be the other way around. The direction of the list is not important.

So how do we represent a doubly-linked list in memory? Usually, we do so by creating a node structure containing:

1. A payload, i.e. the actual value or item to store. It can be anything from a string to an integer…
2. A pointer toward the previous element in the list.
3. A pointer toward the next element in the list.

Then we also need to store a pointer to both the first & the last element of the list and we are done.

> Now is probably a good time to review [pointers](https://en.wikipedia.org/wiki/Pointer_(computer_programming)), if you are unsure what they are.

Schematically, it looks somewhat like this:

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

As long as the cache is not full, it is quite easy to maintain our list of cached items. We just need to prepend the newly inserted items into the list:

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

Finally, if the cache is already full and a yet unknown key needs to be inserted, we will need to pop the last item from the list to make place to prepend the new one.

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

## Implementing doubly-linked lists in JavaScript

Now there is a slight issue: the JavaScript language does not have pointers per se. Indeed we can only work by passing references around, and dereference pointers by accessing object properties.

This means that most people usually implement linked lists in JavaScript by writing classes like those:

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

1. Each time you instantiate a node, some superflous memory will be allocated for bookkeeping.
2. If your list moves fast, i.e. nodes are often added or removed, it will trigger garbage collection that will slow you down.
3. Engines will try to optimize your objects as low-level structs most of the time but you have no control over it.
4. Finally, and this is related to `3.`, object property access is not the fastest thing in the JavaScript world.

> This is mostly why you won't see many people using linked lists in application JavaScript code. Only people needing it for very specific use cases where they algorithmically shine will actually use them. node.js has such an implementation [here](https://github.com/nodejs/node/blob/master/lib/internal/linkedlist.js) and you can find it used for timers [here](https://github.com/nodejs/node/blob/master/lib/internal/timers.js).

But we can be a little more clever than that. Indeed, there is a characteristic of our linked list that we can leverage to be more performant: its capacity cannot exceed a given number.

So, instead of using JavaScript references & properties as pointers, let's roll our own pointer system using [Typed Arrays](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/TypedArray)!

## A custom pointer system

Typed Arrays are very neat JavaScript objects able to represent fixed-capacity arrays containing a certain amount of typical number types such as `int32` or `float64` and so on…

They are fairly fast and consume very little memory because the stored items are statically typed and can't suffer from bookkeeping overhead.

Here is how we would use one:

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

Since we can use those very performant arrays, why shouldn't we use them to implement our own pointer system? After all, pointers are nothing more than addresses mapping chunks of memory.

Let's use a typed array as our chunk of memory then, and its indices as our addresses! The only tricky part now is to correctly choose an integer type, relative to our capacity, to avoid overflows.

> If you are ever unsure how to develop this, check this function right [here](https://github.com/Yomguithereal/mnemonist/blob/7ea90e6fec46b4c2283ae88f173bfb19ead68734/utils/typed-arrays.js#L8-L54)

So, in order to implement a fixed-capacity doubly-linked list in JavaScript for our LRU cache structure, we'll need the following typed arrays:

1. A vanilla array to store our list's payloads, i.e. key-value pairs. Or two typed or vanilla arrays to store keys & values separately and depending on their respective types. For instance, if we can guarantee our values cannot be anything more than 32 bits integers, we can once again leverage typed arrays for the task.
2. A typed array storing a bunch of indices representing our next pointers.
3. Another one to store the indices representing our previous pointers.

> Oftentimes, the **typed array pointers** trick can be a bit tedious to use when you need to ensure index `0`represents a null value/pointer. Two somewhat crafty ways to circumvent this issue:
> - You can offset your values array by keeping the first item empty so that the `0` index does not risk storing anything important.
> - You can offset your indices by one but this often requires to perform some light arithmetic on the indices which make the code quite unpalatable and complicated to understand.
> Note that people also use the trick of using signed typed arrays rather than unsigned ones (indices cannot be negative numbers, obviously) to add one level of indirection: a pointer can signify one thing or the other based on the sign of the index.
> This is sometimes used, for instance, to flag nodes in a [Trie](https://en.wikipedia.org/wiki/Trie) as leaves, by using negative indices to save up memory.

Our code would subsequently look something like this:

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

Schematically, again, here is what we are doing:

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

It's actually a good thing. It means we don't move things around too much. We don't create things, we just read & write array indices.

So why is this faster than the traditional implementation we reviewed earlier?

- Memory is only allocated once. New objects are never instantiated and old one are never garbage collected.<SideNote id="pool">Yes you can temper memory allocation and garbage collection by using object pools. But if you can rely on typed arrays instead you'll find that it's faster and consumes less memory.</SideNote>And memory predictability is a desirable thing to have in a LRU cache implementation.
    The only memory hiccups in our implementation will be the result of filling our map with keys up to capacity then evicting some of them later on.
- Array indices lookups/writes are really fast because the allocated memory is mostly contiguous, even more with typed arrays. You never need to jump very far to find what you need and cache optimizations can more easily perform their magic.
- It leaves nothing to interpretation. The engine does not have to be clever about anything and will be able to automatically apply very low-level optimizations without a second thought.

## Is it really worth the hassle?

To make sure of that, I tried to implement this custom pointer system I just described and benchmark it.

You can therefore find a typed array-based implementation of a LRU cache in the [mnemonist](https://github.com/Yomguithereal/mnemonist) library. You will find one implementation relying on a JavaScript object: the [`LRUCache`](https://yomguithereal.github.io/mnemonist/lru-cache), and another one relying on an ES6 `Map`: the [`LRUMap`](https://yomguithereal.github.io/mnemonist/lru-map).

You can read their source code [here](https://github.com/Yomguithereal/mnemonist/blob/master/lru-cache.js) and decide for yourself whether it's gibberish to deal with indices rather than object properties or not.

Then there is this public benchmark on the [dominictarr/bench-lru](https://github.com/dominictarr/bench-lru) repository. As every benchmark it cannot perfectly suit your use cases but it still avoids some common pitfalls about unrelated engine optimizations and other related issues.

Here are some the latest benchmark results, expressed in ops/ms (the higher, the better) for a variety of typical LRU cache methods, on my 2013 MacBook using node `12.6.0`:

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
> Libraries are ranked by eviction performance because this is usually the slowest operation and the most critical for a LRU cache. But it makes the results hard to read. You should take time to carefully peruse the list.

You should also run it on your computer because, while the ranking is mostly stable, results tend to vary.

Futhermore, it should be noted that the benchmarked libraries differ in the array of features they offer so the result is not completely fair either.

Finally, we should probably add memory consumption to the benchmark in the future, even if it is not easy to reliably measure it in JavaScript. Indeed, I strongly suspect that using typed arrays should help reducing the memory footprint of any implementation.

## Concluding remarks

Now you know how to use JavaScript typed arrays to create your own pointer system. This trick is not limited to fixed-capacity linked lists and can be used for a variety or other data structure implementation problems.

> A lot of tree-like data structures can also beneficiate from this trick, for instance.

But as per usual, and this advice stands for most high-level languages, optimizing JavaScript is the same as squinting really hard and pretending the language:

> The **typed array pointers** trick is far from suited to every high-level language. In python, for instance, if you try to replicate this trick using `bytearray` or `np.array` you will actually get abysmal performances

1. has static typing
2. is low-level

Basically, the less choices the engine has to make, the easier it will be for it to optimize your code.

Of course this is not advisable for application code and this level of optimization should only be a goal if you try to optimize critical things such as, off the top of my head, a LRU cache.

> LRU cache are very important to many implementations of memoization, for instance. Web servers and clients alike also massively rely on those kinds of caches.

And finally, please don't take my words or advice too seriously. It is infamously tricky to optimize interpreted languages and JavaScript is even worse because you have to consider JIT compilation and several engines such as Gecko or V8.

So, pretty please, do benchmark your code, for your mileage may vary.

  Have a good day!

-----

## Miscellany

### About evictions & splay trees

The single thing hampering every JavaScript implementation of a LRU cache is eviction performance. Getting rid of keys from either an object (using the `delete` keyword) or a map (using the `#.delete` method) is very costly.

> Once again the [hashlru](https://npmjs.com/package/hashlru) and [quick-lru](https://npmjs.com/package/quick-lru) libraries formulate an original solution to this issue and I warmly encourage you to check them.

There seems to be no way around it because it is quite impossible (yet?) to beat the engines native hashmaps' performance from within interpreted JavaScript code.

> The contrary would be very counterintuitive since there is no way to run hash algorithms as fast the engine is able to do natively.
> I tried to implement tree-based key-value associative data structures like [CritBit trees](https://cr.yp.to/critbit.html) but must report that it's not possible to beat a JavaScript object or map thusly.
> You can still implement those trees so that they can be only from 2 to 5 times less performant than native objects for certain use case, all while maintaining lexicographical order. Which is not too shabby. I guess?
> Feel free to check the yet undocumented code [here](https://github.com/Yomguithereal/mnemonist/blob/master/critbit-tree-map.js)

This means that you can't roll your own map in JavaScript, a fixed-capacity one with inexpensive deletion for instance, and hope to beat what's already provided to you with the native object.

One interesting solution that would be nice to test is using [splay trees](https://en.wikipedia.org/wiki/Splay_tree).

Those trees, being a binary search tree variant, support rather efficient associative key-value operations while being very suited to LRU caches since they already work by “splaying” very frequently accessed key to the top of their hierarchy.

### What about webassembly?

Wouldn't it be faster to implement a LRU cache using shiny new things such as `webassembly` rather than trying to shoehorn low-level concepts into JavaScript high-level code?

Well yes. But here is the trick: if you ever need to use this implementation from the JavaScript side, then you are out of luck because it will be slow as hell. Communication between the JavaScript side and the webassembly one will slow you down, just a little, but enough to make such an implementation moot.

> Communication between wasm and JS has been wildly improving. Check this very good [blog post](https://hacks.mozilla.org/2018/10/calls-between-javascript-and-webassembly-are-finally-fast-%F0%9F%8E%89/) on the matter, for instance.
> But it's still not enough to justify having hot data structure methods run on the wasm side while being called from the JS side, unfortunately.

However, if you can afford to write some code that will only run in webassembly and doesn't need to rely on JavaScript's API, because you compile rust to webassembly for instance, then it's a tremendous idea to also implement your LRU cache there. You will definitely get better results.

### Saving one pointer array

There is a known trick with LRU cache you can use to save up one pointer level. It does not mean that you don't need a doubly-linked list anymore to be efficient but just that the hashmap/dictionary structure you are using can store pointers to the previous key rather than the related one to save up memory.

I won't explain this here but you can head to this [stackoverflow answer](https://stackoverflow.com/questions/49621983/lru-cache-with-a-singly-linked-list#answer-49622080) if you want to get the gist of it.

Just note that, in JavaScript, it's usually not a good idea if you want to remain performant (computation-wise, not memory-wise, obviously) since you will need more hashmap lookups to update pointers, and they are quite costly.

### About arbitrary evictions

Note that the LRU cache implementation proposed here will have a hard time handling arbitrary evictions, i.e. letting the user delete keys.

Why? Because for now, since we only need to swap key-value pairs when inserting a new key that will evict the LRU one, we don't need to have a way to find “available” slots in our memory. Those slots, if the user can delete keys at will, would be randomly found in the typed array and we would need a way to track them in order to “reallocate” them.

This could be done by using an additional array serving as a free pointer stack, but this has obviously a memory and performance cost.

### A fully dynamic custom pointer system

Here I mostly spoke of typed arrays to implement fixed-capacity pointer system. But if you are a little bit more ambitious you can very well imagine designing a dynamic-capacity pointer system.

To do so, you can use dynamic typed arrays like mnemonist's [Vector](https://yomguithereal.github.io/mnemonist/vector.html). They are sometimes more efficient than vanilla JavaScript arrays when handling numbers and will let you implement what you need.

I am unsure whether having a custom dynamic pointer system would yield any performance improvement when implementing some other data structure however.

## Links

* You might find the [mnemonist](https://yomguithereal.github.io/mnemonist/) library useful. It contains a lot of efficient and cohesive data structure implementations for JavaScript.
* I did a [talk](https://fosdem.org/2019/schedule/event/data_structures_javascript/) about implementing data structures in JavaScript at FOSDEM in 2019 ([slides](https://yomguithereal.github.io/mnemonist/presentations/fosdem2019)).

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
