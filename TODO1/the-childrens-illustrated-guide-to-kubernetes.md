> * 原文地址：[The Illustrated Children’s Guide to Kubernetes](https://www.cncf.io/the-childrens-illustrated-guide-to-kubernetes/)
> * 原文作者：[CLOUD NATIVE COMPUTING FOUNDATION](https://www.cncf.io)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/the-childrens-illustrated-guide-to-kubernetes.md](https://github.com/xitu/gold-miner/blob/master/TODO1/the-childrens-illustrated-guide-to-kubernetes.md)
> * 译者：
> * 校对者：

# The Illustrated Children’s Guide to Kubernetes

![](https://www.cncf.io/wp-content/uploads/2018/12/page1.png)

![](https://www.cncf.io/wp-content/uploads/2018/12/The-Illustrated-Childrens-Guide-to-Kubernetes-Book-Files-Sept-2018-CNCF-1024x791.jpg)

![](https://web.archive.org/web/20171108051103im_/https://deis.com/images/blog-images/kubernetes-illustrated-guide-illustration-1.png)

**Dedicated to all the parents who try to explain software engineering to their children.**

![](https://web.archive.org/web/20171108051103im_/https://deis.com/images/blog-images/kubernetes-illustrated-guide-illustration-3.png)

Once upon a time there was an app named Phippy. And she was a simple app. She was written in PHP and had just one page. She lived on a hosting provider and she shared her environment with scary other apps that she didn’t know and didn’t care to associate with. She wished she had her own environment: just her and a webserver she could call home.

![](https://web.archive.org/web/20171108051103im_/https://deis.com/images/blog-images/kubernetes-illustrated-guide-diagram-2.png)

An app has an environment that it relies upon to run. For a PHP app, that environment might include a webserver, a readable file system, and the PHP engine itself.

![](https://web.archive.org/web/20171108051103im_/https://deis.com/images/blog-images/kubernetes-illustrated-guide-illustration-4.png)

One day, a kindly whale came along. He suggested that little Phippy might be happier living in a container. And so the app moved. And the container was nice, but… It was a little bit like having a fancy living room floating in the middle of the ocean.

![](https://web.archive.org/web/20171108051103im_/https://deis.com/images/blog-images/kubernetes-illustrated-guide-diagram-3.png)

A container provides an isolated environment in which an app, together with its environment, can run. But those isolated containers often need to be managed and connected to the external world. Shared file systems, networking, scheduling, load balancing, and distribution are all challenges.

![](https://web.archive.org/web/20171108051103im_/https://deis.com/images/blog-images/kubernetes-illustrated-guide-illustration-5.png)

The whale shrugged his shoulders. “Sorry, kid,” he said, and disappeared beneath the ocean’s surface. But before Phippy could even begin to despair, a captain appeared on the horizon, piloting a gigantic ship. The ship was made of dozens of rafts all lashed together, but from the outside, it looked like one giant ship.

“Hello there, friend PHP app. My name is Captain Kube” said the wise old captain.

![](https://web.archive.org/web/20171108051103im_/https://deis.com/images/blog-images/kubernetes-illustrated-guide-diagram-4.png)

“Kubernetes” is the Greek word for a ship’s captain. We get the words **Cybernetic** and **Gubernatorial** from it. The Kubernetes project focuses on building a robust platform for running thousands of containers in production.

![](https://web.archive.org/web/20171108051103im_/https://deis.com/images/blog-images/kubernetes-illustrated-guide-illustration-6.png)

“I’m Phippy,” said the little app.

“Nice to make your acquaintance,” said the Captain as he slapped a name tag on her.

![](https://web.archive.org/web/20171108051103im_/https://deis.com/images/blog-images/kubernetes-illustrated-guide-diagram-5.png)

Kubernetes uses labels as “nametags” to identify things. And it can query based on these labels. Labels are open-ended: You can use them to indicate roles, stability, or other important attributes.

![](https://web.archive.org/web/20171108051103im_/https://deis.com/images/blog-images/kubernetes-illustrated-guide-illustration-7.png)

Captain Kube suggested that the app might like to move her container to a pod on board the ship. Phippy happily moved her container inside of the pod aboard Kube’s giant ship. It felt like home.

![](https://web.archive.org/web/20171108051103im_/https://deis.com/images/blog-images/kubernetes-illustrated-guide-diagram-6.png)

In Kubernetes, a Pod represents a runnable unit of work. Usually, you will run a single container inside of a Pod. But for cases where a few containers are tightly coupled, you may opt to run more than one container inside of the same Pod. Kubernetes takes on the work of connecting your pod to the network and the rest of the Kubernetes environment.

![](https://web.archive.org/web/20171108051103im_/https://deis.com/images/blog-images/kubernetes-illustrated-guide-illustration-8.png)

Phippy had some unusual interests. She was really into genetics and sheep. And so she asked the captain, “What if I want to clone myself… On demand… Any number of times?”

“That’s easy,” said the captain. And he introduced her to the replication controllers.

![](https://web.archive.org/web/20171108051103im_/https://deis.com/images/blog-images/kubernetes-illustrated-guide-diagram-7.png)

Replication controllers provide a method for managing an arbitrary number of pods. A replication controller contains a pod template, which can be replicated any number of times. Through the replication controller, Kubernetes will manage your pods’ lifecycle, including scaling up and down, rolling deployments, and monitoring.

![](https://web.archive.org/web/20171108051103im_/https://deis.com/images/blog-images/kubernetes-illustrated-guide-illustration-9.png)

For many days and nights the little app was happy with her pod and happy with her replicas. But only having yourself for company is not all it’s cracked up to be…. even if it is N copies of yourself.

Captain Kube smiled benevolently, “I have just the thing.”

No sooner had he spoken than a tunnel opened between Phippy’s replication controller and the rest of the ship. With a hearty laugh, Captain Kube said, “Even when your clones come and go, this tunnel will stay here so you can discover other pods, and they can discover you!”

![](https://web.archive.org/web/20171108051103im_/https://deis.com/images/blog-images/kubernetes-illustrated-guide-diagram-8.png)

A service tells the rest of the Kubernetes environment (including other pods and replication controllers) what **services** your application provides. While pods come and go, the service IP addresses and ports remain the same. And other applications can find your service through Kurbenetes service discovery.

![](https://web.archive.org/web/20171108051103im_/https://deis.com/images/blog-images/kubernetes-illustrated-guide-illustration-10.png)

Thanks to the services, Phippy began to explore the rest of the ship. It wasn’t long before Phippy met Goldie. And they became the best of friends. One day, Goldie did something extraordinary. She gave Phippy a present. Phippy took one look and the saddest of sad tears escaped her eye.

“Why are you so sad?” asked Goldie.

“I love the present, but I have nowhere to put it!” sniffled Phippy.

But Goldie knew what to do. “Why not put it in a volume?”

![](https://web.archive.org/web/20171108051103im_/https://deis.com/images/blog-images/kubernetes-illustrated-guide-diagram-9.png)

A volume represents a location where containers can access and store information. For the application, the volume appears as part of the local filesystem. But volumes may be backed by local storage, Ceph, Gluster, Elastic Block Storage, and a number of other storage backends.

Phippy loved life aboard Captain Kube’s ship and she enjoyed the company of her new friends (every replicated pod of Goldie was equally delightful). But as she thought back to her days on the scary hosted provider, she began to wonder if perhaps she could also have a little privacy.

“It sounds like what you need,” said Captain Kube, “is a namespace.”

![](https://web.archive.org/web/20171108051103im_/https://deis.com/images/blog-images/kubernetes-illustrated-guide-diagram-10.png)

A namespace functions as a grouping mechanism inside of Kubernetes. Services, pods, replication controllers, and volumes can easily cooperate within a namespace, but the namespace provides a degree of isolation from the other parts of the cluster.

Together with her new friends, Phippy sailed the seas on Captain Kube’s great boat. She had many grand adventures, but most importantly, Phippy had found her home.

And so Phippy lived happily ever after.

![](https://www.cncf.io/wp-content/uploads/2019/01/back-1024x787.jpg)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
