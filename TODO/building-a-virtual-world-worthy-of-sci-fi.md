> * 原文地址：[Building a Virtual World Worthy of Sci-Fi: Designing a global metaverse](https://medium.com/google-developers/building-a-virtual-world-worthy-of-sci-fi-3d48e2fd05e3)
> * 原文作者：[Reto Meier](https://medium.com/@retomeier?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/building-a-virtual-world-worthy-of-sci-fi.md](https://github.com/xitu/gold-miner/blob/master/TODO/building-a-virtual-world-worthy-of-sci-fi.md)
> * 译者：
> * 校对者：

# Building a Virtual World Worthy of Sci-Fi: Designing a global metaverse

In the second episode of Build Out, [Colt McAnlis](https://medium.com/@duhroach) and [Reto Meier](https://medium.com/@retomeier) were given the challenge of designing a global metaverse.

Take a look at the video to see what they came up with, then continue reading to see how you can learn from their explorations to build your own solution!

<iframe width="700" height="393" src="https://www.youtube.com/embed/H9FbNi5aYYM?list=PLOU2XLYxmsILr0RmtqFITcoXnfOrWtytp" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>

### TL;DW: What they designed

Both solutions describe a design to generate a 3D environment that users experience using a virtual reality headset, using various levels of cloud compute and storage to provide virtual Earth data to the client, and calculate changes to the world environment as users interact with it.

**Reto’s solution** is focussed on creating a virtual clone of the real world using millions of drones to obtain real-time sensor readings. His virtual space is intrinsically linked to the real-world, including everything from geometry to prevailing weather conditions.

![](https://cdn-images-1.medium.com/max/1000/1*61k82U4FxUM9lOfd34stlg.png)

**Colt’s solution** leverages his video game development experience with a system design that completely disconnects the virtual world from the physical world. His architecture details the required framework for building the back-end services for an MMO (or other large scale cooperative space.)

![](https://cdn-images-1.medium.com/max/1000/1*Es5nrGnQu3jQYirGuq8aPw.png)

### Building your own global metaverse

The biggest difference in these designs is the source of the virtual environments’ climate and geometry. Reto’s design relies on analyzing the results of sensors in the real-world, where Colt’s system uses artists to contribute artificial landscapes and buildings.

If you want a system that incorporate real-world geometry and textures, you can use Google Maps as inspiration.

Their system uses a combination of imagery and sensor data to generate 3D models along with texture information for those models. This allows them to generate very realistic 3D representations of urban environments without needing to employ an army of artists to recreate the same content.

Mirroring this process let’s us generate a very similar representation. We can use satellite data, LIDAR input, and drone photography from various angles and sources, and push that into a GCS bucket.

Along with that, we generate work information and push work tokens off to pub/sub. We have a fleet of pre-emptive VMs working to gather those pub/sub requests, and start doing 3D meshing and texture atlas generation. The final results are pushed into a GCS bucket as well.

![](https://cdn-images-1.medium.com/max/800/1*2awv-uWabgiVAepGrpUdzA.png)

> **Why pre-emptive VMs?** PVMs allow themselves to be terminated by the Compute Engine manager. As such they offer a significantly discounted price than standard VMs of the same configuration. Since their lifespans are volatile, they are perfect for batch work jobs where work may get interrupted and not completed.

Pub/sub works hand-in-hand with PVMs in this regard. Once a PVM received a termination signal, it can stop work, and push the workload back to pubsub for another PVM to pick up and work on later.

Alternatively, or for areas where this algorithm fails, you could allow users to submit custom models and textures for iconic landmarks, which we can then be inserted into the generated 3D environment.

![](https://cdn-images-1.medium.com/max/800/1*8ngyDPNUw6GqNRdxWnvJrA.png)

### Storing and distributing metaverse binary data

Once all of our mesh and texture data has been processed, the result will be literal terabytes of virtual environment environmental data. Obviously, we can’t stream all that to each client at once, so instead, we bundle up model data based upon geographic boundaries.

These “regional blobs” are indexed, contain metadata, and can be stored in multi-layered compressed archives so that they can be streamed to the client.

To compute this, use the same offline build-process as for 3D mesh generation; specifically you can generate a bunch of tasks for pub/sub, and use an army of preemptive vms to compute and combine the proper regional blob archives.

![](https://cdn-images-1.medium.com/max/800/1*CEkaLsDQMXbQVvygHYrhGw.png)

Distribution of the regional archives to the client depends on the user’s “physical” location in the virtual universe — as well as what direction they’re facing.

![](https://cdn-images-1.medium.com/max/800/1*Jz_zqlU5Ca0MGIIGGjUMlg.png)

In order to optimize load times for the client, it’ll make sense to add a local cache for areas they visit frequently, to keep them from having to download gigs of data every time they enter a new area.

![](https://cdn-images-1.medium.com/max/800/1*6b2I4tUiPyn3pVSw7aPwfg.png)

For the sake of diagram clarity, we can wrap this entire process up as an offline system, and call it “Automated Content Generation” (ACG).

Over time, the local cache will become invalid, or updates will be need to be pushed out to the user. For this, we put together an update & staging process, where a client can receive the updated environment data as they log-in, or as they re-enter a zone they have recently visited.

![](https://cdn-images-1.medium.com/max/800/1*lCgVkyWLf2gSqfZE2Wlhww.png)

> **Why GCF?** There’s many ways to allow a client to check for updates. For example, we could create a load balancer which auto-scales a group of GCE instances. Or we could have made a Kubernetes pod which can scale for requests as well.

> Or we could have used app engine flex, which would allow us to provide our own images, but scale just the same. Or we could have used app engine standard, which has its own deployment and scaling.

> The reason we chose Cloud Functions here: First, GCF has enhanced support for Firebase push notifications. If something’s occuring, and we need to notify the client of an emergency patch, we can push that data to the client directly.

> Secondly, GCF needs the least amount of work to get a function deployed. We don’t have to spend extra cycles configuring images, balancing, or deployment specifics; we simply just write our code, and push it out to be ready to be used.

### Simulation data for your metaverse

As your users move and interact with the virtual environment, any changes they make will need to be synced with the rest of the universe data and shared with other users.

You’ll need some composite components to make sure that user actions aren’t violating any physical rules, and then a system for storing or broadcasting this information to the other players.

For this, you can leverage a set of App Engine Flex groups, called “World Shards” which allow geographically similar clients to connect and exchange data on position and movement information. So as a user enters a game zone, we’ll figure out their closest region, and connect them directly to the appropriate World Shard.

> **Why App Engine Flex?** For the World Shards, we could have easily used an instanced group of GCE VMs, which share an image, however app engine flex gives us that same functionality w/o needing the extra maintenance overhead. Likewise, a GKE Kubernetes cluster would have done the trick, but for our scenario, we didn’t need some of the advanced features that GKE provides.

We’ll also need a separate set of compute instances to help us manage all the secondary world-interaction items. Things like purchasing goods, inter-player communication, and so on. For this you can spin up a second group of App Engine Flex instances.

All persistent data that needs to be distributed to multiple other clients will be stored in cloud Spanner, which will allow regionally similarly clients to share information as soon as it happens.

![](https://cdn-images-1.medium.com/max/800/1*KQnoHJeVWVQbJJr8ELQKcQ.png)

> **Why Spanner?** We chose spanner here due to it’s managed service, global capacity, and ability to scale to handle very high transactional workloads. You could have also done this with a SQL system, but at that point, you’re doing a lot of heavy lifting in order to get the same effect.

Since our code will change often, we need to augment our updating and staging servers to also distribute code to our world-shards. Do this, we allow compute-level staging to occur in our staging code, and push images to Google Container Registry to be propped out to various world shards and game servers as needed.

![](https://cdn-images-1.medium.com/max/800/1*V0jjfEVbgTpBA1T91L1W1A.png)

### Drawing your metaverse

A metaverse isn’t a metaverse unless you have a strapped on headset. For this, you can leverage Google VR and the Android Daydream platform to render our massive metaverse within a fully immersive VR experience. However Daydream by itself is not a proper rendering engine, so you’ll need to leverage something like UNITY as a tool to help draw all our models and interact with the Daydream system on our behalf.

![](https://cdn-images-1.medium.com/max/800/1*cMAXUcr7QcZXdnFnOm38WA.png)

Describing how to properly render millions of polygons per frame in VR mode is a big challenge, but one that’s outside the scope of this article ;)

### Account & Identity services

We’re going to add an app engine front-end instance that leverages Cloud IAM to authenticate and identify the user, and communicate with the account management database, which may include sensitive information like billing and contact data.

![](https://cdn-images-1.medium.com/max/800/1*_XrckPhaLAUKQbfkJAV48g.png)

> **Why App Engine Standard?** We chose app engine standard as the front-end service for our IAM system for a number of reasons.

> Firstly is that it’s managed, so we don’t have to deal with provisioning and deployment details like with containers/ GKE/ App Engine Flex.

> Secondly, it has built in IAM rules and configurations, so we can write less code and get the right security and login systems we need.

> Thirdly, it has direct built in support for datastore, which we use to store all of our IAM data.

* * *

To hear a more detailed account of some of our choices, check out our companion podcast, Build Out Rewound, our on [Google Play Music](https://play.google.com/music/listen#/ps/Imvre4gs5o4fv2aqknxopy6cb7q), iTunes, or [your favorite podcast app / site](http://feeds.feedburner.com/BuildOutRewound).

Add a comment here, or on our YouTube video, with any questions you have about our system design or technology choices.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
