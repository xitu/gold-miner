> * 原文地址：[Messaging Sync — Scaling Mobile Messaging at Airbnb](https://medium.com/airbnb-engineering/messaging-sync-scaling-mobile-messaging-at-airbnb-659142036f06)
> * 原文作者：[Zhiyao Wang](https://medium.com/@zhiyaowang), [Michelle Leon](https://medium.com/@mkleon) , [Jason Goodman](https://medium.com/@jasonkgoodman) , [Nick Reynolds](https://medium.com/@thenickreynolds) , [Julia Fu](https://medium.com/@chengxiaofu) , [Jeff Hodnett](http://www.jeffhodnett.com/) , [Manuel Deschamps](https://medium.com/@manuel) , [John Pottebaum](https://medium.com/@johnpottebaum), Charlie Jiang
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：
> * 校对者：

# Messaging Sync — Scaling Mobile Messaging at Airbnb #

![](https://cdn-images-1.medium.com/max/800/1*fZpQ95jk81Ae7tqpkXNIwA.gif)

Old Inbox vs New Inbox with slow network

With more than 100k messages being sent on mobile per hour, messaging is the most engaged with feature on the Airbnb App. However, with the old inbox fetch method on mobile, the inbox was slow to load, suffered from data inconsistency, and required a network connection to read messages. All of this results in a poor experience for hosts and guests using the mobile inbox. In order to make the inbox faster, more reliable, and more consistent, the Hosts and Homes team at Airbnb built Messaging Sync.

The old inbox fetch was implemented similar to a turn-of-the-century webmail client, doing a network fetch for a screenful of information at every user tap. With messaging sync, new messages and thread updates are fetched only when data change, which greatly reduces the number of network requests. This means navigation between the inbox and message thread screens is much faster, hitting the local mobile storage most of the time, instead of issuing a network request with each screen change. Messaging sync also reduces the response size for each network fetch, which results in a 2x improvement in terms of API latency. These user experience gains are magnified in areas with slow networks.

Here’s how Messaging Sync works, broken into 3 scenarios:

**Scenario 1: Full Delta Update**

![](https://cdn-images-1.medium.com/max/800/1*RqXfpzXiZ2nudOrEPA7Dvg.png)

This is the most common scenario:

1. Mobile client calls the sync API with a sequence_id stored locally (e.g. 1490000000), which denotes the last time the client synced with the server.
2. API server only returns all modified thread objects and new messages after that sequence_id, together with a new sequence_id (e.g. 1491111111).
3. Mobile client merges those updated threads and messages with its local datastore.
4. Mobile client also stores the new sequenced_id to be used next time.

**Scenario 2: Initial Sync**

This is when there are too many threads and/or messages updates to return. For example, when a user first downloads the App, the server needs to send 10 thread objects and 30 messages for a full delta sync. The full delta sync response payload would be huge, which would result in longer load times and subpar user experience. Instead, we only return a full screen of threads.

![](https://cdn-images-1.medium.com/max/800/1*0NQo4EQtq4A6ZcD0I-FGCQ.png)

1. Mobile client calls the sync API with a sequence_id stored locally
2. API server estimates the size of the response for a full delta sync, and decides it’s too big.
3. API server sends down only the N most recent thread objects without any messages to have the client render at least a full screen of threads in the inbox view.
4. Client clears its local datastore.
5. Client stores the most recent thread objects and sequence_id.
6. When a user opens a thread, the client requests all messages in the thread from the server.
7. When a user scrolls historically in the inbox, the client sends paginated requests to fetch threads.

**Scenario 3: Threads Removal**

Threads sometimes need to be removed from the mobile App. For example, when a cohost is no longer managing the listing for the host, the server removes the threads between the cohost and the guest. In this case, the API sends down an array of thread ids deleted after last sync.

### Catching Regressions ###

While migrating to the new messaging sync API, there were couple caveats to watch out for:

1. Airbnb’s messaging system is closely integrated with its core booking flow and other product logic. The server needs to listen to all changes that affect the data displayed on the inbox screen. For example, after a trip is finished, the App needs to render a “Leave Review” button in the thread. There are two solutions to this. One is to check the review object in read time to see if it has been modified. The other solution is to subscribe to review object changes and update the notion of when the corresponding thread object is last modified. We chose the second solution as it is much cheaper on read time. However, the challenge is to capture relevant changes for all objects that can affect what’s being rendered on the UI.
2. Updated threads could be in a different order from the threads stored locally. We need to make sure that after merging the data, the UI is refreshed correctly.

In order to catch any discrepancies between the data returned by the old messaging API and the messaging sync API, a small percentage of mobile Apps run both the old and the new API at the same time to spot check. It logs all attribute values and the thread order returned from the two APIs. This allows us to catch regressions with the new API and iterate quickly. Whenever a bug is caught, the server marks corresponding thread objects as modified so that it would correct the discrepancy in the next sync.

### Conclusions ###

1. Messaging Sync API reduced API request latency by 2x. It also results in a much more stable request duration than the old messaging API (spiky blue line below).

![](https://cdn-images-1.medium.com/max/800/1*SbTsdzUkh9miVCbZScBKCQ.png)

2. Messaging Sync makes it possible for users to read messages under airplane mode and bad network conditions.

After rolling out Messaging Sync together with other messaging improvements, we see more messages are being sent from mobile (+3.8% and +5.3% for Android and iOS), fewer messages are being sent from web (-4.6% and -4.2%). And daily inbox visits are way up (+200% and +96%) as it is now the main screen on the hosting mode. The launch is a big win for our hosting community as messaging is the most used feature by hosts on Airbnb.

*Last but not least, if you are interested in creating a thriving community of engaged hosts who provide amazing hospitality everywhere in the world, the Hosts and Homes engineering team is always* [*looking for talented people to join*](https://www.airbnb.com/careers/departments/engineering)!

![](https://cdn-images-1.medium.com/max/2000/1*XMOMFask2IOSeOQznGLe7Q.png)

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
