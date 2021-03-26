> * 原文地址：[Top 10 Open Source Projects for SREs and DevOps](https://dzone.com/articles/top-open-source-projects-for-sres-and-devops)
> * 原文作者：Nir Sharma
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/top-open-source-projects-for-sres-and-devops.md](https://github.com/xitu/gold-miner/blob/master/article/2021/top-open-source-projects-for-sres-and-devops.md)
> * 译者：
> * 校对者：

# Top 10 Open Source Projects for SREs and DevOps

Building scalable and highly reliable software systems is the ultimate goal of every SRE out there. Follow the path of continuous learning with the help of our latest blog which outlines some of the most sought out open source projects in the monitoring, deployment, and maintenance space.
The path to becoming a successful SRE lies in continuous learning. There are a plethora of great open source projects out there for SREs/DevOps, each with new and exciting implementations and often tackling unique challenges. These open-source projects do the heavy lifting so you can do your job more easily.

In this blog, we look at some of the most sought-out open source projects in the areas of monitoring, deployment, and maintenance. Among the projects we have covered are those that simulate network traffic and allow you to model unpredictable(chaotic) events to develop dependable systems.

## 1. Cloudprober

[Cloudprober](https://github.com/google/cloudprober) is an active tracking and monitoring application to spot malfunctions before your customers do. It uses an 'active' monitoring model to check that your components are operating as intended. It runs probes proactively, for instance, to ensure if your frontends can access your backends. Similarly, a probe can be run to verify that your on-premise systems can actually reach your in-Cloud VMs. This method of tracking makes it easy, independent of the implementation, to track the configurations of your applications and lets you easily pin down what is broken in your system.

### Features:

* Native Integration with open source monitoring stack of Prometheus and Grafana. Cloudprober can export probe results as well.
* For Cloud targets, automatic target discovery. Out-of-the-box support is provided to GCE and Kubernetes; other cloud services can be easily configured.
* Significant commitment on ease of deployment. Cloudprober is completely written and compiled into a static binary in Go. It can be deployed quickly by way of Docker containers. In addition to most of the updates, there is normally no need to re-deploy or reconfigure Cloudprober due to the automatic aim discovery.
* The Cloudprober Docker image size is low, containing only a statically compiled binary, and it requires a very small amount of CPU and RAM to run even a large number of probes.

![[Image Source](https://github.com/google/cloudprober)](https://uploads-ssl.webflow.com/5c9200c49b1194323aff7304/5fae5bd946575b4c9affe61b_1.png)

## 2. Cloud Operations Sandbox (Alpha)

[Cloud Operations Sandbox](https://github.com/GoogleCloudPlatform/cloud-ops-sandbox) is an open-source platform that lets specialists learn about Google's Service Reliability Engineering practices and adapt them to their cloud systems using Ops Management (formerly Stackdriver). It is based on the Hipster Shop, a cloud-based platform for native microservices. Note: This requires a Google cloud services account.

### Features:

* Demo Service — an application designed on a modern, cloud-native, microservice architecture.
* One-click deployment — a script handles the work of deploying the service to Google Cloud Platform.
* Load Generator — a part that produces simulated traffic on a demo service.

![[Image Source](https://github.com/GoogleCloudPlatform/cloud-ops-sandbox)](https://uploads-ssl.webflow.com/5c9200c49b1194323aff7304/5fae5c14d10c2b76716fbe34_2.jpg)

## 3. Version Checker for Kubernetes

A [Kubernetes utility](https://github.com/jetstack/version-checker#:~:text=version%2Dchecker%20is%20a%20Kubernetes,This%20tool%20is%20currently%20experimental.) allows you to observe existing versions of images that are running in the cluster. This tool also allows you to see the current image versions in table format on a Grafana dashboard.

### Features:

* Multiple self-hosted registries can be set-up at once.
* This utility allows you to see the version information as Prometheus metrics.
* Support for registries like ACR, DockerHub, ECR.

![[Image Source](https://github.com/jetstack/version-checker)](https://uploads-ssl.webflow.com/5c9200c49b1194323aff7304/5fae46c71a5a0a24cfccbd8d_image6.png)

## 4. Istio

[Istio](https://istio.io/) is an open framework for incorporating microservices, monitoring traffic movement through microservices, implementing policies, and aggregating telemetry data in a standardised way. The control plane of Istio offers an abstraction layer over the underlying platform for cluster management, such as Kubernetes.

### Features:

* Automatic load balancing for HTTP, gRPC, WebSocket, and TCP traffic.
* Fine-grained control of traffic behavior with rich routing rules, retries, failovers, and fault injection.
* A pluggable policy layer and configuration API supporting access controls, rate limits, and quotas.
* Automatic metrics, logs, and traces for all traffic within a cluster, including cluster ingress and egress.
* Secure service-to-service communication in a cluster with strong identity-based authentication and authorization.

![[Image Source](https://istio.io/)](https://uploads-ssl.webflow.com/5c9200c49b1194323aff7304/5fae5c3ad3b5421ccfa359f7_3.jpg)

## 5. Checkov

[Checkov](https://www.checkov.io/) is an Infrastructure-as-Code static code review tool. It scans Terraform, Cloud Details, Cubanet, Serverless, or ARM Models cloud infrastructure, and detects security and compliance misconfigurations.

### Features:

* More than 400 built-in rules cover AWS, Azure, and Google Cloud's best protection and security practices.
* Assesses Terraform Provider settings to monitor Terraform-managed IaaS, PaaS, or SaaS development, maintenance, and updates.
* Detects AWS credentials in EC2 Userdata, Lambda context variables, and Terraform providers.

![[Image Source](https://www.checkov.io/)](https://uploads-ssl.webflow.com/5c9200c49b1194323aff7304/5fae46b8a8cf376b15c27f31_image3.png)

## 6. Litmus

[Cloud-Native Chaos Engineering](https://github.com/litmuschaos/litmus)
Litmus is a cloud-based chaos modeling toolkit. Litmus provides tools to orchestrate chaos on Kubernetes to help SREs discover vulnerabilities in their deployments. SREs use Litmus to conduct chaos tests first in the staging area and finally in development to discover glitches and vulnerabilities. Fixing the deficiencies leads to improved system resilience.

### Features:

* Developers can run chaos tests during application development as an extension to unit testing or integration testing.
* For CI pipeline builders: To run chaos as a pipeline stage to find bugs when the application is subjected to fail paths in a pipeline.

![[Image Source](https://github.com/litmuschaos/litmus)](https://uploads-ssl.webflow.com/5c9200c49b1194323aff7304/5fae5c80e9ad215032686770_4.jpg)

## 7. Locust

[Locust](https://github.com/locustio/locust) is a simple to use, scriptable and flexible performance testing application. You define the behavior of your users in standard Python code, instead of using a clunky UI or domain-specific language. This enables Locust to be extensible and developer-friendly.

### Features:

* Locust is distributed and scalable — easily supporting hundreds or thousands of users.
* Web-based UI that shows progress in real-time.
* Can test any system with a little tinkering.

![[Image Source](https://github.com/locustio/locust)](https://uploads-ssl.webflow.com/5c9200c49b1194323aff7304/5fae487f1a5a0a3f0eccc78d_image1.png)

## 8. Prometheus

[Prometheus](https://github.com/prometheus/prometheus), a Cloud Native Computing Foundation project, is a systems and service monitoring system. It extracts metrics from configured destinations at specific times, tests rules, and shows outcomes. If specified criteria are violated, it will trigger notifications.

### Features:

* A multi-dimensional data model (time series defined by metric name and set of key/value dimensions).
* Targets are discovered via service discovery or static configuration.
* No dependency on distributed storage; single server nodes are autonomous.
*  PromQL, a powerful and flexible query language to leverage this dimensionality.

![[Image Source](https://github.com/prometheus/prometheus)](https://uploads-ssl.webflow.com/5c9200c49b1194323aff7304/5fae5cabe713151e3ba35284_5.jpg)

### 9. Kube-monkey

[Kube-monkey](https://github.com/asobti/kube-monkey) is a Kubernetes cluster implementation of [Netflix's Chaos Monkey](https://netflix.github.io/chaosmonkey/). The random deletion of Kubernetes pods facilitates the creation of failure-resistant resources and validates them at the same time.

### Features:

* Kube-monkey is operating with an opt-in model and only targeting the termination of Kubernetes (k8s) users which have specifically accepted that kube-monkey will terminate their pods.
* Highly customizable scheduling features based on your requirements

![[Image Source](https://www.slideshare.net/arungupta1/chaos-engineering-with-kubernetes)](https://uploads-ssl.webflow.com/5c9200c49b1194323aff7304/5fae4976092c02d97f145670_image10.png)

## 10. PowerfulSeal

[PowerfulSeal](https://github.com/powerfulseal/powerfulseal) injects failure into Kubernetes clusters, helping you to recognize issues as quickly as possible. It enables scenarios that portray complete chaos experiments to be created.

### Features:

* Compatible with Kubernetes, OpenStack, AWS, Azure, GCP, and local machines.
* Connects with [Prometheus](https://prometheus.io/) and [Datadog](https://www.datadoghq.com/) for metrics collection.
* Multiple modes allowed for custom use cases.

![[Image Source](https://github.com/powerfulseal/powerfulseal)](https://uploads-ssl.webflow.com/5c9200c49b1194323aff7304/5fae5cca5c87c3b80dcf9912_6.jpg)

## Conclusion

The great benefit of open source technologies is their extensible nature. You can add features to the tool if required to better fit your custom architecture. These open source projects have extensive support documentation and a community of users. As microservice architecture is slated to dominate the cloud computing space, reliable tools to monitor and troubleshoot these instances are sure to become part of every developer's arsenal.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
