> * 原文地址：[Bringing Pokémon GO to life on Google Cloud](https://cloudplatform.googleblog.com/2016/09/bringing-Pokemon-GO-to-life-on-Google-Cloud.html)
* 原文作者：[Luke Stone](https://cloudplatform.googleblog.com/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

# Bringing Pokémon GO to life on Google Cloud
Posted by Luke Stone, Director of Customer Reliability Engineering  

Throughout my career as an engineer, I’ve had a hand in numerous product launches that grew to millions of users. User adoption typically happens gradually over several months, with new features and architectural changes scheduled over relatively long periods of time. Never have I taken part in anything close to the growth that [Google Cloud](https://cloud.google.com/) customer [Niantic](https://www.nianticlabs.com/) experienced with the launch of Pokémon GO.  

As a teaser, I’ll start with a picture worth a thousand words:  

[![](https://3.bp.blogspot.com/-QNgvo5Ec03Q/V-2XAaD0GQI/AAAAAAAADJA/g2M6VTRGUiktueNG6gGFxBjSLXRQDeNZQCLcB/s640/google-cloud-pokemon-go-1.png)](https://3.bp.blogspot.com/-QNgvo5Ec03Q/V-2XAaD0GQI/AAAAAAAADJA/g2M6VTRGUiktueNG6gGFxBjSLXRQDeNZQCLcB/s1600/google-cloud-pokemon-go-1.png)

Our peers in the technical community have asked about the infrastructure that helped bring Pokémon GO to life for millions of players. Niantic and the Google Cloud teams put together this post to highlight some of the key components powering one of the most popular mobile games to date.  

### A shared fate

At our [Horizon](https://atmosphere.withgoogle.com/live/horizon) event today, we’ll be introducing Google Customer Reliability Engineering (CRE), a new engagement model in which technical staff from Google integrates with customer teams, creating a shared responsibility for the reliability and success of critical cloud applications. Google CRE’s first customer was Niantic, and its first assignment the launch of Pokémon GO — a true test if there ever was one!  

Within 15 minutes of launching in Australia and New Zealand, player traffic surged well past Niantic’s expectations. This was the first indication to Niantic’s product and engineering teams that they had something truly special on their hands. Niantic phoned in to Google CRE for reinforcements, in anticipation of the US launch planned the next day. Niantic and Google Cloud — spanning CRE, SRE, development, product, support and executive teams — braced for a flood of new Pokémon Trainers, as Pokémon GO would go on to shatter all prior estimates of player traffic.  

### Creating the Pokémon game world

Pokémon GO is a mobile application that uses many services across Google Cloud, but [Cloud Datastore](https://cloud.google.com/datastore/) became a direct proxy for the game’s overall popularity given its role as the game’s primary database for capturing the Pokémon game world. The graph opening this blog post tells the story: the teams targeted 1X player traffic, with a worst-case estimate of roughly 5X this target. Pokémon GO’s popularity quickly surged player traffic to 50X the initial target, ten times the worst-case estimate. In response, Google CRE seamlessly provisioned extra capacity on behalf of Niantic to stay well ahead of their record-setting growth.  

Not everything was smooth sailing at launch! When issues emerged around the game’s stability, Niantic and Google engineers braved each problem in sequence, working quickly to create and deploy solutions. Google CRE worked hand-in-hand with Niantic to review every part of their architecture, tapping the expertise of core Google Cloud engineers and product managers — all against a backdrop of millions of new players pouring into the game.  

### Pokémon powered by containers

Beyond being a global phenomenon, Pokémon GO is one of the most exciting examples of container-based development in the wild. The application logic for the game runs on [Google Container Engine (GKE)](https://cloud.google.com/container-engine/) powered by the open source [Kubernetes project](http://kubernetes.io/). Niantic chose GKE for its ability to orchestrate their container cluster at planetary-scale, freeing its team to focus on deploying live changes for their players. In this way, Niantic used Google Cloud to turn Pokémon GO into a service for millions of players, continuously adapting and improving.  

One of the more daring technical feats accomplished by Niantic and the Google CRE team was to upgrade to a newer version of GKE that would allow for more than a thousand additional nodes to be added to its container cluster, in preparation for the highly anticipated launch in Japan. Akin to swapping out the plane’s engine in-flight, careful measures were taken to avoid disrupting existing players, cutting over to the new version while millions of new players signed up and joined the Pokémon game world. On top of this upgrade, Niantic and Google engineers worked in concert to replace the [Network Load Balancer](https://cloud.google.com/compute/docs/load-balancing/network/), deploying the newer and more sophisticated HTTP/S Load Balancer in its place. The [HTTP/S Load Balancer](https://cloud.google.com/load-balancing/) is a global system tailored for HTTPS traffic, offering far more control, faster connections to users and higher throughput overall — a better fit for the amount and types of traffic Pokémon GO was seeing.  

The lessons-learned from the US launch — generous capacity provisioning, the architectural swap to the latest version of Container Engine, along with the upgrade to the HTTP/S Load Balancer — paid off when the game launched without incident in Japan, where the number of new users signing up to play _tripled_ the US launch two weeks earlier.  







[![](https://3.bp.blogspot.com/-Eo29IdLeofM/V-ysvX6aqXI/AAAAAAAADIc/b1Kf1YUDk2UbiheUIKElXjTypd5MBqpGACLcB/s640/google-cloud-cre.png)](https://3.bp.blogspot.com/-Eo29IdLeofM/V-ysvX6aqXI/AAAAAAAADIc/b1Kf1YUDk2UbiheUIKElXjTypd5MBqpGACLcB/s1600/google-cloud-cre.png)





The Google Cloud GKE/Kubernetes team that supports many of our customers like Niantic







Other fun facts  

*   The Pokémon GO game world was brought to life using over a dozen services across Google Cloud.
*   Pokémon GO was the largest [Kubernetes](http://kubernetes.io/) deployment on [Google Container Engine](https://cloud.google.com/container-engine/) ever. Due to the scale of the cluster and accompanying throughput, a multitude of bugs were identified, fixed and merged into the [open source project](https://github.com/kubernetes/kubernetes).
*   To support Pokémon GO’s massive player base, Google provisioned many tens of thousands of cores for Niantic’s Container Engine cluster.
*   [Google’s global network](https://peering.google.com/#/infrastructure) helped reduce the overall latency for Pokémon Trainers inhabiting the game’s shared world. Game traffic travels Google’s private fiber network through most of its transit, delivering reliable, low-latency experiences for players worldwide. [Even under the sea](https://cloudplatform.googleblog.com/2016/06/Google-Cloud-customers-run-at-the-speed-of-light-with-new-FASTER-undersea-pipe.html)!

Niantic’s Pokémon GO was an all-hands-on-deck launch that required quick and highly informed decisions across more than a half-dozen teams. The sheer scale and ambition of the game required Niantic to tap architectural and operational best-practices directly from the engineering teams who designed the underlying products. On behalf of the Google CRE team, I can say it was a rare pleasure to be part of such a memorable product launch that created joy for so many people around the world.  