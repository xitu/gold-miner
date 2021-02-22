> * 原文地址：[Using Rust to Scale Elixir for 11 Million Concurrent Users](https://blog.discord.com/using-rust-to-scale-elixir-for-11-million-concurrent-users-c6f19fc029d3)
> * 原文作者：[discord.matt](https://medium.com/@discord.matt)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/using-rust-to-scale-elixir-for-11-million-concurrent-users.md](https://github.com/xitu/gold-miner/blob/master/article/2021/using-rust-to-scale-elixir-for-11-million-concurrent-users.md)
> * 译者：
> * 校对者：

![1_wtla_J4eY8-ftoQznTPiFA](https://user-images.githubusercontent.com/8282645/108677057-1bc37980-7524-11eb-9b05-890f6b05660f.png)

# Using Rust to Scale Elixir for 11 Million Concurrent Users

Over the last year, the Backend Infrastructure team at Discord was hard at work improving the scalability and performance of our core real-time communications infrastructure.

One big project we undertook was changing how we update the Member List (all those nifty people on the right side of the screen). Instead of sending updates for every single person in the Member List, we could just send down the updates for the visible portion of the Member List. This has obvious benefits such as less network traffic, less CPU usage, better battery life; the list goes on and on.

However, this posed one big problem on the server side: We needed a data structure capable of holding hundreds of thousands of entries, sorted in a particular way that can accept and process tons of mutations, and can report back indices of where things are being added and removed.

Elixir is a functional language; its data structures are immutable. This is great for reasoning about code and supporting the massive concurrency you enjoy when you write Elixir. The double-edged sword of immutable data structures is that mutations are modeled by taking an existing data structure and an operation and creating a brand new data structure that is the result of applying that operation to the existing data structure.

This meant that when someone joined a server — internally referred to as guilds — with a Member List of 100,000 members, we would have to build a new list with 100,001 members in it. The BEAM VM is pretty speedy and [getting faster everyday](http://blog.erlang.org/My-OTP-21-Highlights/). It tries to take advantage of [persistent data structures](https://en.wikipedia.org/wiki/Persistent_data_structure) where it can, but at the scale we operate, these large lists could not be updated fast enough.

## Pushing Elixir to the Limits

Two engineers took up the challenge of making a pure Elixir data structure that could hold large sorted sets and support fast mutation operations. This is easier said than done, so let’s put on our Computer Science helmets and go spelunking into the caves of data structure design.

Elixir ships with a set implementation called MapSet. MapSet is a general purpose data structure built on top of the Map data structure. It’s useful for lots of Set operations, but it provides no guarantees around ordering, which is a key requirement for the Member List. This pretty much ruled out MapSet as a contender.

Next up would be the venerable List type: wrap the List with a helper that would enforce uniqueness and sort the list after insertion of new elements. A quick benchmark of this approach shows that for small lists — 5,000 elements— insertion time was measured between 500𝜇s and 3,000𝜇s. This was already far too slow to be viable.

Even worse, the performance of insertion scaled with size of list and depth of position in the list. Worst case that was benchmarked was adding a new element to the end of a 250,000 item list, which came in around 170,000𝜇s: basically an eternity.

![https://miro.medium.com/max/2300/1*1UCJXCtJk0TNYxRgPk6htw.png](https://miro.medium.com/max/2300/1*1UCJXCtJk0TNYxRgPk6htw.png)

Two down, but BEAM isn’t out of the competition yet.

Erlang ships with a module called ordsets. Ordsets are Ordered Sets, so sounds like we found the solution to our problem: Let’s break out the benchmarking to check for viability. When the list is small the performance looks pretty great measuring between 0.008𝜇s and 288𝜇s. Sadly, when the size tested was increased to 250,000 worst-case performance increased to 27,000𝜇s, which was five times faster than our custom List implementation but still not fast enough.

Having exhausted all the obvious candidates that come with the language, a cursory search of packages was done to see if someone else had already solved and open sourced the solution to this problem. A few packages were checked, but none of them provided the properties and performance required. Thankfully, the field of Computer Science has been optimizing algorithms and data structures for storing and sorting data for the last 60 years, so there were plenty of ideas about how to proceed.

## SkipList

The ordsets perform extremely well at small sizes. Maybe there was some way that we could chain a bunch of very small ordsets together and quickly access the correct one when accessing a particular position. If you turn your head sideways and squint real hard, this starts to look like a [Skip List](https://en.wikipedia.org/wiki/Skip_list), which is exactly what was implemented.

The first incarnation of this new data structure was pretty straightforward. The OrderedSet was a wrapper around a list of Cells, inside each cell was a small ordset: the first item of the ordset, the last item of the ordset, and a count of the number of items. This allowed the OrderedSet to quickly traverse the list of Cells to find the appropriate Cell and then do a very fast ordset operation. By leveraging compile time guards in the implementation of traversal, you can get pretty good performance in the worst case scenarios that stymie ordset. Insertion of an item at the end of a 250,000 item list dropped from 27,000𝜇s to 5,000𝜇s, five times faster than raw ordsets and 34 times faster than the naive List implementation.

So pop the champagne corks and celebrate, right? Not quite.

The old worst case was better, but a new worst case of insertion at the beginning of the list had been created; a 250,000 item list was clocking in at 19,000𝜇s. Wat?!

This makes sense if you think about the data structure. When you insert an item into the front of the OrderedSet it ends up in the first Cell, but that Cell is full, so it evicts its last item to the next Cell, but that Cell is full, so it evicts its last item to the next Cell, and so on. At this point, most engineers would shrug and say “You can’t have your cake and eat it too,” but at Discord we are pushing the envelope on quantum cake technology.

## OrderedSet

The problem is that when things fill up, operations can cascade from Cell to Cell. What if we could do something more clever? What if we allow Cells to swell and split, dynamically inserting new Cells in the middle of the list? This is slightly more expensive, but has the benefit that the worst case is a Cell Split instead of 2N Cell operations, where N is the number of Cells.

Another day of coding data structures and we were ready to benchmark.

At small list sizes, this new dynamic OrderedSet could perform insertions at any point in the list between 4𝜇s and 34𝜇s. Not bad. The real test came when we cranked up the size to 250,000. Inserting at the beginning of the list took…. drumroll…. 4𝜇s. That’s looking fast. But remember last time we made one number fast, we made another slow. Maybe the end of the list is horrible now, better check.

With a list size of 250,000 items, inserting an item at the end of the list took 640𝜇s. Looks like we have a winner.

![https://miro.medium.com/max/2268/1*9c8HPdzJLpot3cdTRMEFFw.png](https://miro.medium.com/max/2268/1*9c8HPdzJLpot3cdTRMEFFw.png)

## Must. Go. Faster.

This solution would work for guilds up to 250,000 members, but that was the scaling limit. For a lot of people, this would have been the end of the story. But Discord has been using Rust to make things go fast, and we posed a question: “Could we use Rust to go faster?”

Rust is not a functional language, and will happily let you mutate data structures. It also has no run-time and provides “zero-cost abstractions.” If we could somehow get Rust to manage this set, it would probably perform much better.

Our core services aren’t written in Rust, they are Elixir-based. Elixir serves this purpose very well, and lucky for us, the BEAM VM had another nifty trick up its sleeve. The BEAM VM has three types of functions:

1. Functions that are written in Erlang or Elixir. These are simple user-space functions.
2. Functions that are built into the language and act as the building blocks for user-space functions. These are called BIFs or Built-In Functions.
3. Then there are NIFs or Native Implemented Functions. These are functions that are built in C or Rust and compiled into the BEAM VM. Calling these functions is just like calling a BIF but, you can control what it does.

There’s a fantastic Elixir project called [Rustler](https://github.com/hansihe/Rustler). It provides nice support on the Elixir and Rust side for making a safe NIF that is well behaved and using the guarantees of Rust is guaranteed not to crash the VM or leak memory.

We set aside a week to see if this would be worth the effort. By the end of the week, we had a very limited proof-of-concept that we could measure. The first benchmarks were extremely promising. The best case for adding an item to the set was 0.4𝜇s with a worst case of 2.85𝜇s, compared to OrderedSet’s 4𝜇s to 640𝜇s. This was a benchmark just using integers, but it was enough evidence to build out support for a wider range of Erlang Terms and fill out the rest of the functionality.

With the spike showing so much promise, we continued on building out support for most Erlang Terms and all the functionality we needed for the member list. It was time to benchmark again. We cranked the number of items all the way up to 1,000,000 items. The test machine churned for a few minutes and finally printed out the result: SortedSet best case was 0.61𝜇s and worst case was 3.68𝜇s, testing multiple sizes of sets from 5,000 to 1,000,000 items.

For the second iteration in a row we were able to make the worst case as good as the previous iterations best-case timings.

![https://miro.medium.com/max/2284/1*mJ0QzqsUwQXEoi_piLOZ1A.png](https://miro.medium.com/max/2284/1*mJ0QzqsUwQXEoi_piLOZ1A.png)

The Rust backed NIF provides massive performance benefits without trading off ease of use or memory. Since the library operations all clocked in well under the 1 millisecond threshold, we could just use the built-in Rustler guarantees and not need to worry about reductions or yielding. The SortedSet module looks to the caller to just be a vanilla Elixir module that performs crazy fast.

## Happily Ever After

Today, the Rust backed SortedSet powers every single Discord guild: from the 3 person guild planning a trip to Japan to 200,000 people enjoying the latest, fun game.

Since deploying SortedSet, we’ve seen performance improve across the board with no impact to memory pressure. We learned that Rust and Elixir can work side by side to operate in extremely tight performance constraints. We can still keep our core real-time communications logic in the higher-level Elixir with its wonderful guarantees and easy concurrency while dropping down into Rust when needed.

If you need a high-speed mutation friendly SortedSet, [we have released SortedSet as an open source library](https://github.com/discordapp/sorted_set_nif).

If solving hard problems with awesome tools like Elixir and Rust is interesting to you, [go check out our jobs page](https://discordapp.com/jobs?team=engineering).

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
