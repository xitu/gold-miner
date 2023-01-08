> * 原文地址：[An Analysis of Hash Map Implementations in Popular Languages](https://rcoh.me/posts/hash-map-analysis/)
> * 原文作者：[Russell Cohen](https://rcoh.me/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2022/hash-map-analysis.md](https://github.com/xitu/gold-miner/blob/master/article/2022/hash-map-analysis.md)
> * 译者：
> * 校对者：

# An Analysis of Hash Map Implementations in Popular Languages

Few data-structures are more ubiquitous in real-world development than the hash table. Nearly every major programming features an implementation in its standard library or built into the runtime. Yet, there is no conclusive best strategy to implement one and the major programming languages diverge widely in their implementations! I did a survey of the Hash map implementations in Go, Python, Ruby, Java, C#, C++, and Scala to compare and contrast how they were implemented.

**Note: The rest of this post assumes a working knowledge of how hash tables work along with the most common schemes for implementing them.** If you need a refresher, [Wikipedia](https://en.wikipedia.org/wiki/Hash_table) provides a fairly readable explanation. Beyond the basics, the sections on [chaining](https://en.wikipedia.org/wiki/Hash_table#Separate_chaining) and [open addressing](https://en.wikipedia.org/wiki/Hash_table#Open_addressing) should provide sufficient background.

For each hash map I’ll compare:

* **Scheme**: How does the hash table handle collisions? Any optimizations to the chosen strategy?
* **Growth Rate**: When the hash table resizes, how much does it grow by?
* **Load Factor**: How full (as a fraction of `num_keys/slots`) does the hash table need to be before resizing is triggered?

Some vocabulary to keep in mind:

* **Perturbation**: Many of the maps below always have a size that is a power of 2. `n % (i**2)` is equivalent to dropping some of the higher order bits. To combat this, the maps combine certain sections of the hash code with itself via xor or simple numeric addition. This ensures that the impact from the higher order bits is not lost.
* **Tombstoning:** In open addressing when an item is deleted, it must marked as deleted instead of being removed completely. This is so that searches for elements further down the chain know to continue when hitting the “tombstone”.

Though all implementations differed significantly, certain commonalities remained:

* Open addressing (Python, Ruby, C++) and chaining (Java, Scala, Go) were represented about equally
* No “exotic” implementations like [cuckoo hashing](https://en.wikipedia.org/wiki/Cuckoo_hashing), etc in the surveyed languages although most implementations included varying degrees of optimizations that complicated the code significantly.
* Most languages attempt to add entropy to the hash code by mixing the lower and higher order bits at some point in the process. Those languages all contained a primitive type with a low-entropy hash function that lead to this being a necessity.
* All grow by at least 2x. Most guarantee that the size is always a power of 2.

On to the details:

## Python (CPython)

[Source](https://github.com/python/cpython/blob/master/Objects/dictobject.c) [Implementers Notes](https://github.com/python/cpython/blob/master/Objects/dictnotes.txt)

**Scheme:** Open Addressing with custom sequence. The sequence is

```
next = ((5*prev) + 1 + perturb) % TABLE_SIZE
```

`perturb` is initially the hash code. For each successive element in the chain, `perturb = perturb >> 5`. If perturb started at 2^32, it would impact the first 7 items in the chain. This is interesting because it’s neither linear nor quadratic probing, the two schemes everyone learns in school.

**Growth rate:** At least 2x, and size is always a power of 2. In the case where there are no deletions, it will double in size. Since deletions are tombstoned (see above for explanation of tombstoning), it’s possible that we have very long chains without hitting the load factor. The growth rate is `NUM_ITEMS*2+capacity/2`.[1](#fn:3) By taking the size of the hash table into account, it ensures that the hash map will always grow when a resize is triggered.

**Load factor:** 0.66

Other bits of note:

* Although Ruby uses a different perturbation strategy, they both use the same underlying probing scheme of `next = (prev * 5) + 1 mod TABLE_SIZE)`
* The implementation special cases maps where the keys are exclusively unicode strings[2](#fn:2). The motivation for this comes from the fact that so many of the Python internals rely on dictionaries with unicode keys (eg. looking up local variables).[3](#fn:5)
    * With only string keys, keys are stored into an array directly and pointers to the values are stored in a separate array. This enables a few optimizations and means a pointer dereference isn’t necessary when reading the keys.
    * With non string keys, the key values pairs are stored together within a struct and these structs are in a single array.
* Designed to work with badly behaved hash code functions because for integers in Python `hash(i) == i`. A lot of care and tuning went into the perturbation strategy.
* Tuned empirically with lots of magic numbers[4](#fn:4)
* The growth rate changed from `used*4` to `used*2` in `3.3.0`.[1](#fn:3)

## Ruby

[Source](https://github.com/ruby/ruby/blob/trunk/st.c) [Implementers Notes](https://github.com/ruby/ruby/blob/trunk/st.c#L1-L96)

**Scheme:** Open addressing using `j = ((5*j) + 1 + perturb) mod TABLE_SIZE`. This is the same general structure as Python but they use a slightly different perturbation strategy.

**Growth rate:** 2x. The number of slots is always a power of 2.

**Load factor:** 0.5

Other bits of note:

* Old implementation used chaining. New implementation is reportedly 40% (!) faster[5](#fn:1)
* Entries array (for fast iteration) is split from bins array for hash lookup
* Very small arrays have no bins and use linear scanning instead.
* Ruby experimented with quadratic programming (in fact you can turn it on while compiling with `#define QUADRATIC_PROBE`), but it was slower in practice.[6](#fn:7)

## Java

**Scheme:** Chaining, with linked lists that convert into TreeMaps when the length of lists > 8. This conversion is most helpful if either:

* K implements `Comparable<>`
* The hash codes collide mod the table size but are not equal.

**Growth rate:** 2x. The number of slots is always a power of 2

**Load factor: 0.75**

Other bits of note:

* Since Java hash tables are always power-of-2 sized, when you take the `hash_code % tablesize`, you will always drop some higher order bits until your hash table is `2^32`. To account for this, Java xors the hash code with itself, right shifted by 16. This ensures that the high order bits have some impact. `int h = key.hashCode(); h = h ^ h >>> 16;`
* When resizing, elements go in one of two buckets, `k` or `k+oldSize`. This is a convenience of factor-of-two resizing.
* The code is really hard to follow, primarily due to the fact that chains can flip between trees and linked lists.

## Scala

### Immutable Map

[Source](https://github.com/scala/scala/blob/2.12.x/src/library/scala/collection/immutable/HashMap.scala) Most hash map usage in Scala uses the immutable hash map, so I’ll discuss that first.

**Scheme:** Hash Trie with chaining. A hash trie is a recursive data structure (so it’s hash tries all the way down). The [Scala doucmentation](http://docs.scala-lang.org/overviews/collections/concrete-immutable-collection-classes.html#hash-tries) provides a decent explanation. For more depth, [Phil Bagwell’s paper](https://infoscience.epfl.ch/record/64398/files/idealhashtrees.pdf) is an excellent resource. I’ll provide a brief summary:

For maps of size 0 to 4, it uses hardcoded maps. For larger maps, it uses a HashTrie. Each level of the hash trie considers some subset of bits of the hash code. When inserting or retrieving, the implementation recurses into the branch of the trie matching the bits, using the next subset of bits as an argument. Since The Scala hash trie implementation has a branching factor of 32, each level considers 5 bits of the hash code (2^5 = 32). Since hash codes in Java/Scala are 32-bit integers, this means that if all hash codes are unique, the hash trie will store 2^32 elements without collision.

If the hash codes are identical, chaining is used, wrapped within the [`HashMapCollision`](https://github.com/scala/scala/blob/2.12.x/src/library/scala/collection/immutable/HashMap.scala#L239) data structure.

Scala also provides a mutable hash map. Since it lacks the optimizations of the other languages I looked at, it was the only one that was straightforward.

### Mutable Hash Map

[Source](https://github.com/scala/scala/blob/2.12.x/src/library/scala/collection/mutable/HashTable.scala)

**Scheme:** Chaining with linked lists

**Growth rate:** 2x

**Load factor:** 0.75

Bits of note:

* This is what I naively expected a hash map implementation to look like. It’s under 500 lines, and the core is under 100 lines. It’s straightforward, without complications and easy to read.
* Like many other implementations, it attempts to increase the entropy of the incoming hash codes with some mixing:

```
var h: Int = hcode + ~(hcode << 9)
h = h ^ (h >>> 14)
h = h + (h << 4)
h ^ (h >>> 10)
```

## Golang

[Source](https://github.com/golang/go/blob/master/src/runtime/hashmap.go)

**Scheme:** Chaining, with some optimizations. The chains are composed of buckets. Each bucket has 8 slots. Once all 8 slots are consumed, an overflow bucket is chained to the first bucket. Storing 8 key-value pairs in contiguous memory reduces the amount of memory accesses and memory allocations when reading and writing to the map.

**Growth Rate:** 2x. When a lot of deletions occur, a map of the same size is allocated to garbage collect the unused buckets.

**Load factor**: 6.5! Not 6.5%, but rather 6.5x. This means that on average, the hash map will resize when each bucket has 6.5 items. This is a major contrast with the other hash map implementations which all use a load factor less than 1.

Bits of note:

* In all other implementations, the work of copying the elements from the old array to the new array is performed during the single insert that triggered the resize. In Golang, the resize operations of moving to the new map are done incrementally as more keys are added! For each new element that’s added / updated, 2 keys are moved from the old map to the new map, ensuring that no single write incurs `O(n)` performance. Once all the keys have been [`evacuated`](https://github.com/golang/go/blob/fbfc203/src/runtime/hashmap.go#L1006) from the old array, the old array can be deallocated.
    
* 2 conditions can trigger resizing:
    
1. The number of elements >= 6.5x the size of the array, the new array is the same size as the old array.
2. The number of buckets is too large.

In the case of #2, the newly allocated array is the same size as the old array. This seeming nonsensical behavior comes from this [commit](https://github.com/golang/go/commit/9980b70cb460f27907a003674ab1b9bea24a847c). In the case of deletions, allocating and slowly migrating to a new array means that we’ll garbage collect the old buckets instead of slowly leaking them. They chose this approach to ensure that iterators continued to work properly.
    

## C#

[Source](https://github.com/dotnet/coreclr/blob/master/src/mscorlib/shared/System/Collections/Generic/Dictionary.cs)

**Scheme:** Chaining

**Growth Rate:** >2x. The new size is the smallest prime number greater than 2x the old size.

**Load Factor:** 1

Bits of note:

* Although it uses chaining, it does it in a clever way. The hash table stores 2 arrays:
    
1. An array of ints that are indices into the entries array (array #2). When looking up some key `k` in the table, we take its hash code mod the length of this array and look at that index in array #1.
2. An array of `Entries`: each entry stores a key, a value, and the index of another entry in the same array.

```
private struct Entry
{
  public TKey key;        // Key of entry
  public TValue value;    // Value of entry
  public int next;        // Index of next entry, -1 if last
                          // (or only) item in chain
}
```
    

The clever bit here, is that when we need to chain items together we don’t need to allocate linked-list nodes – they’re already preallocated. Furthermore, they’re already in one block of contiguous memory which improves cache locality.

## C++ (GCC STL)

**I originally got this totally wrong and was looking at the wrong source. Thanks to reddit user [u/raevnos](https://www.reddit.com/user/raevnos) for setting me straight.**

[Source](https://github.com/gcc-mirror/gcc/blob/846deaf01bfe46e0db44402858ab1b7ee43f4023/libstdc++-v3/include/std/unordered_map) which `#includes` [the actual source](https://github.com/gcc-mirror/gcc/blob/master/libstdc%2B%2B-v3/include/bits/hashtable.h)

**Scheme:** Chaining

**Growth Rate:** >2x. The new size is the smallest prime number greater than 2x the old size.

**Load Factor:** 1

Bits of note:

* There is no one implementation of the C++ standard, however, the standard seemingly mandates chaining, as explained in this [stack overflow answer](https://stackoverflow.com/questions/31112852/how-stdunordered-map-is-implemented). The proposal for [adding hash maps to the spec](http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2003/n1456.html) rules out open addressing as a straightforward way to implement hash tables as a c++ template.
* Similar to C# in growth behavior
* Table size is always prime.[7](#fn:6) This surprised me since I figured c++ would try to align on powers of 2 to help out malloc.
* C++ templates are very hard to follow ;-)

### Wrap Up

I find it fascinating that there are so many different implementations for hash tables used in the production languages. I found Ruby’s shift from chaining to open addressing especially interesting since it apparently improved on benchmarks quite a bit. It would be interesting to write an open-addressed hash table for Java or Go and compare performance.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
