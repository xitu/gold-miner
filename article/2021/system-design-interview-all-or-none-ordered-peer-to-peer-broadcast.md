> * 原文地址：[System Design Interview: All or None, Ordered Peer-to-Peer Broadcast](https://levelup.gitconnected.com/system-design-interview-all-or-none-ordered-peer-to-peer-broadcast-45b33fb2f6be)
> * 原文作者：[Eileen Pangu](https://medium.com/@eileen-code4fun)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/system-design-interview-all-or-none-ordered-peer-to-peer-broadcast.md](https://github.com/xitu/gold-miner/blob/master/article/2021/system-design-interview-all-or-none-ordered-peer-to-peer-broadcast.md)
> * 译者：
> * 校对者：

# System Design Interview: All or None, Ordered Peer-to-Peer Broadcast

## Prologue

Let me state upfront, this is not an easy system design interview question. If you don’t have a good understanding of distributed systems, you may not even know where to start. It’s no doubt difficult. But unless you’re in a domain specific interview, chances are that the interviewer probably just wants to test your ability of navigating complex system design problems. So I’m hoping to present exactly that — working through this question bit by bit and see how far we’d get. In the end, we’ll not only arrive at some solutions, but also practice problem solving in the context of system design interviews. By the way, if you’re interested in more system design interviews, I have some other [blog posts](https://github.com/eileen-code4fun/SystemDesignInterviews) that you can check out.

## Reframe The Question

To frame this question a bit better, consider what problem we’re trying to solve. It’s a peer-to-peer message broadcast system. Usually when we say broadcast, we tend to only think about the sending end. However, that’s not enough here. The network could drop and delay messages. Machines (using “nodes” thereinafter just to be idiomatic) could crash. If we control only the sending end, it’s impossible to guarantee the desired “all or none” and “ordered” delivery semantics. So we have to control the receiving end as well.

A better way to think about this problem is to imagine building a communication middleware. The middleware hides the complexity of retrying, deduping, ordering, and peer coordination behind a simple interface, providing a communication abstraction to the upper layer application. Whenever the upper layer application wants to broadcast a message to all peers, it invokes a `broadcast` method in the middleware, which in turn transmits the message to the peers and make sure they get it. When the middleware receives a message, it does whatever necessary to preserve the delivery semantics, and then invokes a `deliver` callback submit the message to the upper layer application.

That turns the question into building a communication middleware which runs on all nodes, exposes the `broadcast` and `deliver` interface, and provides the delivery semantics guarantees. In a system design interview, we need to confirm with the interviewer to see if we can proceed with this question reframing. Here we assume the interviewer approves, and we’ll move on to discuss the delivery semantics.

## “All or None” Delivery Semantics

### The Definition of “All or None”

We need to elaborate on what we mean by “all or none” first: if a message is delivered by any node, we want it to be delivered by all correct nodes. Notice that we call out the “all or none” requirement only for nodes being “correct”, which, in the context of distributed systems, essentially means they haven’t crashed.

It’s worth highlighting that “all or none” is a form of atomicity. A message is either not delivered by anyone, or is delivered by all nodes eventually. A variance of “all or none” is “majority or none”. Since any node can fail at any time, and there is no reliable way to synchronously detect failure in distributed systems, we often make do with a quorum rather than insisting on “all”. The idea of quorum atomicity allows the overall system to make progress in the event of partial failure.

### Details of the Design

A tempting but flawed design is to have the sender retry until all (or a majority of) nodes acknowledge. This design seems valid. It does not, however, survive the crash of the sender in the middle of the broadcast. It stands to reason that we can’t rely on any single sender as they can always crash halfway, leaving the overall system in an inconsistent state. Therefore, even though one node will start the broadcast initially, every other node, upon receiving the message, should take part in helping spread the message.

Concretely, each node keeps a record of a list of seen message IDs (constructed to be unique) so that it can tell whether an inbound message is new or seen. When a node receives a new message, it immediately resends the message to all peers. At the same time, each node maintains a mapping of `\<message_id, acked_peer_ids>`. When the node receives a message from a peer, it adds the peer node ID into the `acked_peer_ids` for that `message_id`. The node delivers a message once the corresponding `acked_peer_ids` grows to include all or a majority of peers. See figure-1 for an overall illustration.

![](https://cdn-images-1.medium.com/max/2340/1*bX2e8zvGXSDjSQCU-Xzlog.png)

**Figure-1. (a): every node got acks from all peers and thus could deliver the message. (b): node 1 crashed after sending the message to node 2. Node 2 and node 3 continued the broadcast and could deliver the message because either they relied on quorum, or they detected the crash of node 1 and thus excluded it. (c): node 1 crashed after sending the message to node 2. Node 2 crashed after sending the message to node 3. Node 3, node 4 and node 5 continued the broadcast. (d): node 1 crashed after sending the message to node 2. Node 2 crashed before sending the message out to any peer. The message was not delivered by any node.**

Every message is first sent to all peers, which in turn resend the message to all their peers. The total number of message transmissions is `O(n²)`, assuming `n` nodes. The redundancy is needed to defend against partial failures. Readers who’re familiar with distributed systems concepts and algorithms may recognize that this is essentially the uniform reliable broadcast.

## Variances of the Design

A downside of this design is that every node is required to deal with sending and receiving messages to/from all other nodes. The heavy load resulting from the large fanout may be detrimental especially when `n` is large. One way to mitigate the impact is to organize the nodes into overlapping clusters so that the fanout can be constrained within cluster membership. But that comes with a lot of operational burdens. A design that’s hard to maintain probably wouldn’t impress the system design interviewer. It doesn’t hurt to mention it as an option though.

Another option would be to send the message to a few randomly selected peers instead of all peers. This is called probabilistic broadcast. Initially, the message is only known to one node, which is the original sender. In the first round, the original sender gossips the message to `k` nodes. In the second round, each of those `k` nodes in turn gossips the message to `k` other nodes.

This process continues. There will be wasted effort as some nodes will have already gotten the message from earlier rounds. Gossiping the message to those nodes does not increase the node coverage. In addition, since those nodes have seen the message before, they will not spread the message to others in the next round. The no spreading old messages to others is by design, otherwise the broadcast can’t terminate.

Let’s say the expected number of nodes that get the message exactly in the `**r**th` round is `g(r)`. We have `g(0)=1`. In round `r`, each node from `g(r-1)` randomly gossips the message to `k` peers, which are sampled from the rest of `n-1` nodes. Since some of those `n-1` peers might have already seen the message, we need to discount that in the calculation. Denote `E(r)` to be the total node coverage after round `r`, `E(r)=g(0)+g(1)+…+g(r)`. It’s easy to see that for all `r>0`, g(r)=g(r-1)*k*(n-E(r-1))/(n-1). You can check that `g(1)=k`. `E(r)` approaches `n` asymptotically as `r` increases. We could continue the math and analyze the trade-off between `k` and `r` but I’d consider it beyond the scope of a typical system design interview, given that we still have other important areas to cover.

## Bridging the Two Delivery Semantics

We’ll leverage the “all or none / quorum” delivery semantics to develop the “ordered” delivery semantics so that the “ordered” delivery semantics doesn’t need to worry about the atomicity of the message, and can therefore focus on the ordering part of the puzzle. This layered abstraction model is a typical way of tackling problems in computer science and frankly many other disciplines.

![](https://cdn-images-1.medium.com/max/2000/1*pIsK7air0l0o-C5rzzub4w.png)

**Figure-2**

As shown in figure-2, from now on, when we say “broadcast” in the “ordered” delivery semantics design, we mean invoking the `broadcast` interface in the underlying atomic delivery component. Likewise, when we say “receive” in the “ordered” delivery semantics design, we mean getting the `deliver` callback from the underlying atomic delivery component. When we say “deliver” in the “ordered” delivery semantics design, we mean actually delivering the message to the upper layer application.

## “Ordered” Delivery Semantics

### The Definition of “Ordered”

Before we dive into the design, It’s important to clarify the ordering guarantee we want to support. Consider this: if one node broadcasts a message `m1`, and another node broadcasts a message `m2`, what should be the order between them? The short answer is that we don’t know. It doesn’t matter whether the broadcast of `m1` is before or after the broadcast of `m2` in the sense of absolute clock, they’re concurrent from the view of the overall system.

There are three ways an order is considered established between two messages. Firstly, the broadcast of `m1` happens before the broadcast of `m2` on the same node. Secondly, the delivery of `m1` happens before the broadcast of `m2` on the same node. In these two cases, we say `m1` precedes `m2`. Lastly, order is transitive. So if there is a `m’` where `m1` precedes `m’`, and `m’` precedes `m2`, then `m1` precedes `m2`. This is called causal order in distributed systems. It makes intuitive sense because the broadcast of a message is likely a result of (having a causal dependency on) the broadcast or delivery of a previous message on the same node.

### A Naive Solution

A simple method to preserve ordering is to always piggyback the entire history of the messages broadcast or delivered by the node whenever it broadcasts a new message. This ensures that the recipient nodes will always get all the messages that precede the new message. Every recipient node will go through the received history from inception to the current, and deliver the undelivered messages in order. Clearly, this is prohibitively expensive because the history grows indefinitely and linearly over time. But no harm mentioning it to demonstrate our thought process in the interview. A quick optimization is to have each node send out acks — either individually or in batches — as they deliver messages. Upon receiving acks from all or quorum of nodes for a message, the node can prune the the message and all preceding messages in its history. This effectively garbage-collects the history as the node learns that a message has been correctly delivered by all/quorum, and therefore by induction all its preceding messages are also delivered.

### Using Vector Clocks

Even with the garbage-collected history, it may still be too expensive to send those past messages, not to mention the incurred cost of the additional acks. Instead, the nodes can buffer the received messages locally and use vector clocks to gate when it’s safe to deliver the messages.

Specifically, each node `i` maintains a local vector `V` such that `V[j]` denotes the number of messages from node `j` that node `i` has delivered. When `i==j`, `V[i]` denotes the number of messages node `i` has broadcast. Whenever node `i` broadcasts a new message `m`, it always piggybacks the latest local vector `V`. Node `i` increments `V[i]` after the broadcast. When node `i` receives a message `m` from node `j`, it puts the message `m` (and the corresponding `V_m`) in a buffer. It only delivers `m` when `V_m[k]\<=V[k]` for all `k`. After `m` is delivered, node `i` increments its local `V[j]` — because it has just delivered one more message from the message sender node `j`.

This approach may seem a bit arbitrary at first glance. We can think of it this way. Continuing on with our denotation, the sender is node `j`, the recipient is node `i`. `V_m` is the vector that comes with the message `m` from node `j`. `V` is the local vector on node `i`. Generally speaking, when `V_m[k]>V[k]`, there are messages from node `k` that the sender node `j` has already delivered but the recipient node `i` has not. There two special cases of `k`. The first case is when `k==j`: `V_m[j]>V[j]` means that the sender node `j` has previously broadcast other messages that the recipient node `i` has not yet delivered. The second case is when `k==i`: `V_m[i]` has to be already smaller than or equal to `V[i]` because `V[i]` is incremented when node `i` broadcasts a messages while `V_m[i]` is incremented when node `j` delivers that message. In conclusion, `V_m[k]` represents the number of messages from node `k` that precede the new message `m`. Therefore, the recipient node `i` needs to wait for those messages first. As node `i` delivers those preceding messages, it increments its local vector `V`. The message `m` is safe to be delivered when `V_m[k]\<=V[k]` for all `k`. See figure-3 for an example.

![](https://cdn-images-1.medium.com/max/2102/1*Mo7NtP6DZFFgaof35XCBvA.png)

**Figure-3. Node 3 couldn’t deliver m2 until it delivered m1 due to the vector clock condition.**

You may wonder why we need the number broken down per node, why can’t we collapse them to a single counter on each node that stores the total number of messages preceding a new broadcast. It’s easy to construct a counter-example wherein a node keeps broadcasting new messages but never get around to deliver any message. Its local counter will eventually become sufficiently large to accept any inbound message even though the node has not deliver a single required preceding message.

## Epilogue

I should reiterate, unless you’re in a domain specific interview focusing on distributed systems, the interviewer is probably just challenging you to see how you tackle a complex problem. So don’t feel discouraged if you didn’t have a clue when you first saw this question. Hopefully this blog post has provided a slight bit of inspiration. For more system design interview blog posts, please refer to this [list](https://github.com/eileen-code4fun/SystemDesignInterviews).

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
