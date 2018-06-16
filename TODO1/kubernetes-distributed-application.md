> * 原文地址：[KUBERNETES DISTRIBUTED APPLICATION DEPLOYMENT WITH SAMPLE FACE RECOGNITION APP](https://skarlso.github.io/2018/03/15/kubernetes-distributed-application/)
> * 原文作者：[skarlso](https://skarlso.github.io/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/kubernetes-distributed-application.md](https://github.com/xitu/gold-miner/blob/master/TODO1/kubernetes-distributed-application.md)
> * 译者：[maoqyhz](https://github.com/maoqyhz)
> * 校对者：

# Kubernetes 分布式应用部署和人脸识别 app 实例

![](https://skarlso.github.io/img/2018/03/kube_overview.png)

好的，伙计，让我们静下心来。下面将会是一个漫长但充满希望和有趣的旅程。

我将使用 [Kubernetes](https://kubernetes.io/) 部署分布式应用程序。我试图创建一个类似于真实世界 app 的应用程序。显然，由于时间和精力有限，我不得不忽略一些细节部分。

我的重点将放在 Kubernetes 和应用部署上。

准备好进入正题了吗？

## 关于应用

摘要

![kube overview](https://skarlso.github.io/img/kube_overview.png)

应用程序由六个部分组成。代码仓库可在这里找到：[Kube Cluster Sample](https://github.com/Skarlso/kube-cluster-sample)。

这是一个人脸识别的微服务应用，它可以识别人物的图像并将其和已知人物进行比较。应用的运行过程如下：首先向[接收器](https://github.com/Skarlso/kube-cluster-sample/tree/master/receiver)发送请求，请求中需要包含图像的路径。然后将图像存储在 NFS 的某处，同时接收器会将图像路径存储在 DB（MySQL）中。最后向队列发送一个处理请求，包含保存图像的 ID。这里使用 [NSQ](http://nsq.io/) 作为队列（**译者注**：NSQ 是一个基于 Go 语言的分布式实时消息平台）。识别结果会在一个简单的前端中，通过表格的形式展现出来，可以看到这些待识别的图像中的人物是谁。

期间，[图像处理](https://github.com/Skarlso/kube-cluster-sample/tree/master/image_processor)服务会不间断地监视将要执行作业的队列。处理流程由以下步骤组成：取 ID；加载图像；最后，通过 [gRPC](https://grpc.io/) 将图像发送到用 Python 编写的[人脸识别](https://github.com/Skarlso/kube-cluster-sample/tree/master/face_recognition)后端程序。如果识别成功，后端将返回与该图像中人物相对应的名称。然后，image_processor 会更新图像记录的人物 ID 字段，并将图像标记为“processed successfully”。如果识别不成功，图像将被保留为“pending”。 如果在识别过程中出现故障，图像将被标记为“failed”。

处理失败的图像可以通过 cron 作业重试，例如：

那么这是如何工作的？让我们来看看 。

## 接收器

接收器服务是整个应用运行的起点。接收器接收一个请求的 API 格式如下：

```
curl -d '{"path":"/unknown_images/unknown0001.jpg"}' http://127.0.0.1:8000/image/post
```

在这个例子中，接收器通过共享数据库集群来存储图像路径。当数据库存储图像路径成功后，接收器实例就能从数据库服务中接收图像 ID。此应用程序是基于在持久层提供实体对象唯一标识的这一模型的。一旦 ID 产生，接收器会向 NSQ 发送一个消息。到这里，接收器的工作就完成了。

## 图像处理器

下面是激动人心的开始。当图像处理器第一次运行时，它会创建两个 Go 例程（routine）。 他们是：

### Consume

这是一个 NSQ 消费者。它有三个必要的工作。首先，它能够监听队列中的消息。其次，当其接收到消息后，会将收到的 ID 添加到第二个例程处理的线程安全的 ID 切片中去。最后，它标志着第二个例程需要开始工作。NSQ 消费者通过 [sync.Condition](https://golang.org/pkg/sync/#Cond) 执行操作。

### ProcessImages

该例程处理 ID 切片，知道切片完全耗尽。一旦切片消耗完，例程将暂停而不是在通道上等待睡眠。以下是处理单个 ID 的步骤：

*   与人脸识别服务建立 gRPC 连接（在人脸识别章节解释）
*   从数据库中取回图像记录
*   设置 [断路器](#circuit-breaker) 的两个函数
    *   设置 1: 运行RPC方法调用的主函数
    *   设置 2: 对断路器的 Ping 进行健康检查
*   调用函数 1，发送图像路径到人脸识别服务。服务需要能够访问该路径。最好能像 NFS 一样进行文件共享
*   如果调用失败，更新图像记录的状态字段为“FAILED PROCESSING”
*   如果成功，将会返回数据库中与图片相关的人物名。它会执行一个 SQL 的连接查询，获取到相关的人物 ID
*   更新数据库中图片记录的状态字段为“PROCESSED”，以及人物字段为识别出的人物 ID

这个服务可以被复制，换句话说，可以同时运行多个服务。

<h3 id="circuit-breaker">断路器</h3>

虽然这是一个不需要太大精力就能够复制资源的系统，但仍然可能存在例如，网络故障，两个服务间的任何的通信问题。因此我在 gRRC 调用上实现了一个小小的断路器作为乐趣。

它是这样工作的：

![kube circuit](https://skarlso.github.io/img/kube_circuit1.png)

正如你所见到的，在服务中一旦有 5 个不成功的调用，断路器将会被激活，并且不允许任何调用通过。经过一段配置的时间后，会向服务发送一个 Ping 调用，并检测服务是否返回信息。如果仍然出错，会增加超时时间，否则就会打开，使正常通信。

## 前端

这只是一个简单的表格视图，使用 Go 自带的 HTML 模板来渲染图像列表。

## 人脸识别

这里是识别魔术发生的地方。为了追求灵活性，我决定将人脸识别这项功能封装成为基于 gRPC 的服务。我开始打算用 Go 语言去编写，但后来发现使用 Python 来实现会更加清晰。事实上，除了 gPRC 代码之外，人脸识别部分大概需要 7 行代码。我正在使用一个极好的库，它包含了所有 C 实现的 OpenCV 的调用。[人脸识别](https://github.com/ageitgey/face_recognition)。在这里签订 API 使用协议，也就意味着在协议的许可下，我可以随时更改人脸识别代码的实现。

请注意，这里存在一个可以用 Go 语言来开发 OpenCV 的库。我正打算使用它，但是它并没有包含 C 实现的 OpenCV 的调用。这个库叫做 [GoCV](https://gocv.io/)，你可以去了解一下。它们有些非常了不起的地方，比如，实时的摄像头反馈处理，只需要几行代码就能够实现。

python 的库本质上很简单。现在，我们有一组已知的人物图像，并将其命名为 `hannibal_1.jpg, hannibal_2.jpg, gergely_1.jpg, john_doe.jpg` 放在文件夹中。在数据库中包含两张表，分别是 `person` 和 `person_images`。它们看起来像这样：

```
+----+----------+
| id | name     |
+----+----------+
|  1 | Gergely  |
|  2 | John Doe |
|  3 | Hannibal |
+----+----------+
+----+----------------+-----------+
| id | image_name     | person_id |
+----+----------------+-----------+
|  1 | hannibal_1.jpg |         3 |
|  2 | hannibal_2.jpg |         3 |
+----+----------------+-----------+
```

脸部识别库返回来自已知人物的图像的名称，其与未知图像中的人物匹配。之后，一个简单的连接查询，就像这样，会返回识别出的人物信息。

```
select person.name, person.id from person inner join person_images as pi on person.id = pi.person_id where image_name = 'hannibal_2.jpg';
```

gRPC 调用会返回人物的 ID，并用于修改待识别图像记录中 `person` 那一列的值。

## NSQ

NSQ 是一个极好的基于 Go 语言的队列。它可以缩放并且在系统上具有最小的占用空间。它还具有消费者用来接收消息的查找服务，以及发送者在发送消息时使用的守护程序。

NSQ 的理念是守护进程应该与发送者应用程序一起运行。这样，发件人只会发送到本地主机。但守护进程连接到查找服务，这就是他们如何实现全局队列。

这就意味着，有多少个发送者，有需要部署多少个 NSQ 守护进程。由于守护进程的资源要求很小，因此不会干扰主应用程序的要求。

## 配置

为了尽可能灵活，以及使用 Kubernetes 的 ConfigSet，我在开发中使用 .env 文件来存储配置，如数据库服务的位置或 NSQ 的查找地址。 在生产中，这意味着在 Kubernetes 环境中，我将使用环境变量。

## 人脸识别应用程序总结

这就是我们即将部署的应用程序的架构。它的所有组件都是可变的，只能通过数据库，队列和 gRPC 进行耦合。由于更新机制的工作原因，这在部署分布式应用程序时非常重要。我将在“部署”部分中介绍该部分。

## 在 Kubernetes 中部署应用

### 基础

什么**是** Kubernetes？

我将在这里介绍一些基础知识，但不会过多介绍细节。如果你想了解更多，可阅读的整本书：[Kubernetes Up And Running](http://shop.oreilly.com/product/0636920043874.do)。另外，如果你足够大胆，你可以看看这个文档：[Kubernetes Documentation](https://kubernetes.io/docs/)。

Kubernetes 是一个容器化的服务和应用程序管理平台。它容易扩展，可管理一大堆容器，最重要的是，它可以通过基于 yaml 的模板文件高度配置。人们经常将 Kubernetes 与Docker 集群进行比较，但 Kubernetes 确实不止于此！例如：它可以管理不同的容器。你可以使用 Kubernetes 来对LXC 进行管理和编排，同时也可以使用相同的方式管理 Docker。它提供了一个高于管理已部署服务和应用程序集群的层。怎么样？让我们快速浏览一下 Kubernetes 的构建模块吧。

在 Kubernetes 中，您将描述应用程序的期望状态，Kubernetes 会做一些事情，使之达到这个状态。状态可能是部署、暂停、重复两次等等。

Kubernetes 的基础知识之一是它为所有组件使用标签和注解。Services，Deployments，ReplicaSets，DaemonSets，一切都能够被标记。考虑以下情况。为了确定哪个 pod 属于哪个应用程序，我们将会使用了一个名为 `app：myapp` 的标签。假设您已部署了此应用程序的两个容器; 如果您从其中一个容器中移除标签 `app`，则 Kubernetes 只会检测到一个标签，因此会启动一个新的 `myapp` 实例。

### Kubernetes Cluster

对于 Kuberenetes 的工作，需要有 Kubernetes 集群的存在。配置集群可能是非常痛苦的，但幸运的是，帮助就在眼前。Minikube 在本地为我们配置一个带有一个节点的集群。AWS 有一个以 Kubernetes 集群形式运行的测试服务，其中您唯一需要做的就是请求节点并定义你的部署。Kubernetes 集群组件的文档在此处：[Kubernetes Cluster Components](https://kubernetes.io/docs/concepts/overview/components/)。

### Nodes

一个节点就是一台工作主机。它可以是任何事物，例如物理机、虚拟机以及各种云服务提供的虚拟资源。

### Pods

Pods 是一个逻辑上分组的容器，也就意味着一个 Pod 可以容纳多个容器。一个 Pod 在创建后会获得自己的 DNS 和虚拟 IP 地址，这样Kubernetes 就可以为其平衡流量。你很少需要直接处理容器，即使在调试时（比如查看日志），通常也会调用 `kubectl logs deployment / your-app -f` 而不是查看特定的容器。尽管有可能会调用 `-c container_name`。 `-f` 会加在日志命令的尾部。

### Deployments

在 Kubernetes 中创建任何类型的资源时，它将在后台使用 Deployment。一个 Deployment 对象描述当前应用程序的期望状态。你可以用这个对象做一些工作，例如，更新 Pods，或者对于不同状态下的 Service，你可以进行更新或推出新版本的应用程序。您不直接控制 ReplicaSet（如稍后所述），但可以控制 Deployment 对象来创建和管理 ReplicaSet。

### Services

默认情况下，Pod 会得到一个 IP 地址。然而，因为 Pods 在 Kubernetes 中是一个不稳定的东西，所以你需要更持久的东西。队列、mysql、内部API、前端，这些需要长时间运行并且需要在一个静态的，不变的IP或最好是 DNS 记录之后。

为此，Kubernetes 提供可定义可访问模式的 Services。负载均衡，简单 IP 或内部 DNS。

Kubernetes 如何知道服务是否正确运行？你可以配置运行状况检查和可用性检查。运行状况检查将检查容器是否正在运行，但这并不意味着你的服务正在运行。为此，你需要在您的应用程序中对可用的端点进行可用性检查。

由于 Services 非常重要，我建议你稍后在这里阅读它们：[Services](https://kubernetes.io/docs/concepts/services-networking/service/)。预先提醒，这部分文档内容很多，有 24 个 A4 大小的页面，内容包含网络、服务和发现。但是这对于你是否决定要在生产环境中使用 Kubernetes 是至关重要的。

### DNS / Service Discovery

如果您在集群中创建服务，该服务将获取由特殊的Kubernetes Deployments 对象（被称作为 kube-proxy 和 kube-dns）提供的在 Kubernetes 中的 DNS 记录。这两个对象在集群中提供了服务发现。如果您运行了mysql服务并设置了 `clusterIP：none`，那么集群中的每个人都可以通过 ping `mysql.default.svc.cluster.local` 来访问该服务。 其中：

*   `mysql` – 服务的名称
*   `default` – 命名空间名称
*   `svc` – 服务本身
*   `cluster.local` – 本地集群域名

该域名可以通过自定义来更改。要访问集群外部的服务，必须使用 DNS供应商，再使用Nginx（例如）将IP地址绑定到记录。可以使用以下命令查询服务的公共IP地址：

*   NodePort – `kubectl get -o jsonpath="{.spec.ports[0].nodePort}" services mysql`
*   LoadBalancer – `kubectl get -o jsonpath="{.spec.ports[0].LoadBalancer}" services mysql`

### Template Files

像 Docker Compose、TerraForm 或其他服务管理工具一样，Kubernetes 也提供了配置模板的基础设施。这意味着你很少需要手工做任何事情。

例如，请看下面使用 yaml 文件来配置 nginx 部署的模板：

```
apiVersion: apps/v1
kind: Deployment #(1)
metadata: #(2)
    name: nginx-deployment
    labels: #(3)
    app: nginx
spec: #(4)
    replicas: 3 #(5)
    selector:
    matchLabels:
        app: nginx
    template:
    metadata:
        labels:
        app: nginx
    spec:
        containers: #(6)
        - name: nginx
        image: nginx:1.7.9
        ports:
        - containerPort: 80
```

在这个简单的部署中，我们做了以下工作：

*   (1) 使用 `kind` 属性定义模板的类型
*   (2) 添加可识别此部署的元数据以及使用 label 创建每一个资源 (3)
*   (4) 然后描述所需要的状态规格。
*   (5) 对于 nginx 应用程序，包含 3 个 `replicas`
*   (6) 这是关于容器的模板定义。这里配置的 Pod 包含一个 name 为 nginx 的容器。其中，使用 1.7.9 版本的 nginx 镜像（这个例子中使用的是 Docker），暴露的端口号为：80




### ReplicaSet

ReplicaSet 是低级复制管理器。 它确保为应用程序运行正确数量的复制。 但是，当部署处于较高级别，应始终管理 ReplicaSets。你很少需要直接使用 ReplicaSets，除非您有一个需要控制复制细节的特殊案例。

### DaemonSet

请记住我是如何解释 Kubernetes 始终使用标签的。DaemonSet 是一个控制器，用于确保守护程序应用程序始终在具有特定标签的节点上运行。

例如：您希望所有标有 `logger` 或 `mission_critical` 的节点运行记录器/审计服务守护程序。然后你创建一个 DaemonSet，并给它一个名为 `logger` 或 `mission_critical` 的节点选择器。Kubernetes 将寻找具有该标签的节点。始终确保它将有一个守护进程的实例在其上运行。因此，在该节点上运行的每个都可以在本地访问该守护进程。

在我的应用程序中，NSQ 守护进程可能是一个 DaemonSet。为了确保它在具有接收器组件的节点上运行，我采用 `receiver` 标记一个节点，并用 `receiver` 应用程序选择器指定一个 DaemonSet。

DaemonSet 具有 ReplicaSet 的所有优点。它是可扩展的并由Kubernetes管理它。这意味着，所有的生命周期事件都由 Kube 处理，确保它永不消亡，并且一旦发生，它将立即被替换。

### Scaling

在 Kubernetes 中进行 scaling 是微不足道的。ReplicaSets 负责管理 Pod 的实例数量，如 nginx 部署中所看到的，使用“replicas：3”设置。我们应该以允许 Kubernetes 运行它的多个副本的方式编写我们的应用程序。

当然这些设置是巨大的。你可以指定哪些复制必须在什么节点上运行，或者在各种等待时间等待实例出现的时间。你可以在这里阅读关于此主题的更多信息：[Horizontal Scaling](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/) 和此处：[Interactive Scaling with Kubernetes](https：/ /kubernetes.io/docs/tutorials/kubernetes-basics/scale-interactive/)，当然还有一个 [ReplicaSet](https://kubernetes.io/docs/concepts/workloads/controllers/replicaset/) 控件的详细信息 所有的 scaling 都可以在 Kubernetes 中实现。

### Kubernetes 总结

这是一个处理容器编排的便利工具。 它的基本单位是具有分层的架构的 Pods。顶层是 Deployments，通过它处理所有其他资源。它高度可配置，提供了一个用于所有调用的API，因此可能不会运行 `kubectl`，而是可以编写自己的逻辑将信息发送到 Kubernetes API。

Kubernetes 现在支持所有主要的云提供商，它完全是开源的，随意贡献！如果你想深入了解它的工作方式，请查看代码：[Kubernetes on Github](https://github.com/kubernetes/kubernetes)。

## Minikube

我将使用 [Minikube](https://github.com/kubernetes/minikube/)。Minikube 是一个本地 Kubernetes 集群模拟器。尽管模拟多个节点并不是很好，但如果只是着手去学习并在本地折腾一下的话，这种方式不需要任何的开销，是极好的。Minikube是基于虚拟机的，如果需要的话，可以使用 VirtualBox 等进行微调。

所有我将要使用的 kube 模板文件可以在这里找到：[Kube files](https://github.com/Skarlso/kube-cluster-sample/tree/master/kube_files)。

**注意：**如果稍后想要使用 scaling 但注意到复制总是处于“Pending”状态，请记住 minikube 仅使用单个节点。它可能不允许同一节点上有多个副本，或者只是明显耗尽了资源。您可以使用以下命令检查可用资源：

```
kubectl get nodes -o yaml
```

## 创建容器

Kubernetes 支持大部分容器。我将要使用 Docker。对于我构建的所有服务，存储库中都包含一个 Dockerfile。我鼓励你去研究它们。他们大多数都很简单。对于 Go 服务，我正在使用最近引入的多阶段构建。Go 服务是基于 Alpine Linux 的。人脸识别服务是 Python实现的。NSQ 和 MySQL 正在使用他们自己的容器。

## 上下文

Kubernetes 使用命名空间。如果你没有指定任何命名空间，它将使用 `default` 命名空间。我将永久设置一个上下文以避免污染默认命名空间。 你可以这样做：

```
❯ kubectl config set-context kube-face-cluster --namespace=face
Context "kube-face-cluster" created.
```

一旦它创建完毕，你也必须开始使用上下文，如下所示：

```
❯ kubectl config use-context kube-face-cluster
Switched to context "kube-face-cluster".
```

在此之后，所有 `kubectl` 命令将使用命名空间 `face`。

## 部署应用

Pods 和 Services 概述：

![kube deployed](https://skarlso.github.io/img/kube_deployed.png)

### MySQL

我要部署的第一个 Service 是我的数据库。

我正在使用位于此处的 Kubernetes 示例 [Kube MySQL](https://kubernetes.io/docs/tasks/run-application/run-single-instance-stateful-application/#deploy-mysql)，它符合我的需求。请注意，该配置文件正在使用明文密码。我将按照此处所述 [Kubernetes Secrets](https://kubernetes.io/docs/concepts/configuration/secret/)做一些安全措施。

如文档中描述的那样，我使用保密的 yaml 在本地创建了一个秘钥文件。

```
apiVersion: v1
kind: Secret
metadata:
    name: kube-face-secret
type: Opaque
data:
    mysql_password: base64codehere
```

我通过以下命令创建了base64代码：

```
echo -n "ubersecurepassword" | base64
```

这是您将在我的部署yaml文件中看到的内容：

```
...
- name: MYSQL_ROOT_PASSWORD
    valueFrom:
    secretKeyRef:
        name: kube-face-secret
        key: mysql_password
...
```

另外值得一提的是：它使用一个 volume 来保存数据库。volume 定义如下：

```
...
        volumeMounts:
        - name: mysql-persistent-storage
            mountPath: /var/lib/mysql
...
        volumes:
        - name: mysql-persistent-storage
        persistentVolumeClaim:
            claimName: mysql-pv-claim
...
```

`presistentVolumeClain` 在这里是关键。这告诉 Kubernetes 这个资源需要一个持久的 volume。如何提供它是从用户抽象出来的。你可以确定 Kubernetes 将提供 volume。它与 Pods 类似。要阅读详细信息，请查看此文档：[Kubernetes Persistent Volumes](https://kubernetes.io/docs/concepts/storage/persistent-volumes)。

使用以下命令完成部署 mysql 服务：

```
kubectl apply -f mysql.yaml
```

`apply` vs `create`。简而言之，`apply` 被认为是声明性的对象配置命令，而 `create` 则是命令式的。这意味着现在“create”通常是针对其中一项任务的，比如运行某些东西或创建部署。而在使用 apply 时，用户不会定义要采取的操作。这将由 Kubernetes 根据集群的当前状态进行定义。因此，当没有名为 `mysql` 的服务时，我调用 `apply -f mysql.yaml`，它会创建服务。再次运行时，Kubernetes 不会做任何事情。但是，如果我再次运行 `create`，它会抛出一个错误，说明服务已经被创建。

有关更多信息，请查看以下文档：[Kubernetes Object Management](https://kubernetes.io/docs/concepts/overview/object-management-kubectl/overview/)，[Imperative Configuration](https：// kubernetes .io / docs / concepts / overview / object-management-kubectl / imperative-config /)，[Declarative Configuration](https://kubernetes.io/docs/concepts/overview/object-management-kubectl/declarative-config/)）。

要查看进度信息，请运行：

```
# 描述整个进程
kubectl describe deployment mysql
# 仅显示 pod
kubectl get pods -l app=mysql
```

输出应该与此类似：

```
...
    Type           Status  Reason
    ----           ------  ------
    Available      True    MinimumReplicasAvailable
    Progressing    True    NewReplicaSetAvailable
OldReplicaSets:  <none>
NewReplicaSet:   mysql-55cd6b9f47 (1/1 replicas created)
...
```

或者在 `get pods` 的情况下:

```
NAME                     READY     STATUS    RESTARTS   AGE
mysql-78dbbd9c49-k6sdv   1/1       Running   0          18s
```

要测试实例，请运行以下代码片段：

```
kubectl run -it --rm --image=mysql:5.6 --restart=Never mysql-client -- mysql -h mysql -pyourpasswordhere
```

** 需要了解的是 **：如果你现在更改密码，重新应用 yaml 文件更新容器是不够的。由于数据库持续存在，因此密码将不会更改 你必须使用 `kubectl delete -f mysql.yaml` 删除整个部署。

运行 `show databases` 时应该看到以下内容。

```
If you don't see a command prompt, try pressing enter.
mysql>
mysql>
mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| kube               |
| mysql              |
| performance_schema |
+--------------------+
4 rows in set (0.00 sec)

mysql> exit
Bye
```

你还会注意到我已经在这里安装了一个文件：[Database Setup SQL](https://github.com/Skarlso/kube-cluster-sample/blob/master/database_setup.sql)到容器中。MySQL 容器自动执行这些。该文件将引导一些数据以及我将要使用的模式。

volume 定义如下：

```
    volumeMounts:
    - name: mysql-persistent-storage
    mountPath: /var/lib/mysql
    - name: bootstrap-script
    mountPath: /docker-entrypoint-initdb.d/database_setup.sql
volumes:
- name: mysql-persistent-storage
    persistentVolumeClaim:
    claimName: mysql-pv-claim
- name: bootstrap-script
    hostPath:
    path: /Users/hannibal/golang/src/github.com/Skarlso/kube-cluster-sample/database_setup.sql
    type: File
```

要检查引导脚本是否成功，请运行以下命令：

```
~/golang/src/github.com/Skarlso/kube-cluster-sample/kube_files master*
❯ kubectl run -it --rm --image=mysql:5.6 --restart=Never mysql-client -- mysql -h mysql -uroot -pyourpasswordhere kube
If you don't see a command prompt, try pressing enter.

mysql> show tables;
+----------------+
| Tables_in_kube |
+----------------+
| images         |
| person         |
| person_images  |
+----------------+
3 rows in set (0.00 sec)

mysql>
```

这结束了数据库服务设置。可以使用以下命令查看该服务的日志：

```
kubectl logs deployment/mysql -f
```

### NSQ 查找

NSQ 查找将作为内部服务运行，它不需要从外部访问。所以我设置了 `clusterIP：None`，这会告诉 Kubernetes 这项服务是一项无头（headless）的服务。这意味着它不会被负载均衡，并且不会是单一的 IP 服务 DNS 将会基于服务选择器。

我们定义的 NSQ Lookup 选择器是：

```
selector:
matchLabels:
    app: nsqlookup
```

因此，内部 DNS 将如下所示：`nsqlookup.default.svc.cluster.local`。

无头服务在这里详细描述：[Headless Service](https://kubernetes.io/docs/concepts/services-networking/service/#headless-services)。

基本上它和 MySQ L一样，只是稍作修改。如前所述，我使用的是 NSQ 自己的 Docker 镜像，名为 `nsqio / nsq`。所有的 nsq 命令都在那里，所以 nsqd 也将使用这个镜像，只是命令有所不同。对于 nsqlookupd，命令是：

```
command: ["/nsqlookupd"]
args: ["--broadcast-address=nsqlookup.default.svc.cluster.local"]
```

你可能会问什么是 `--broadcast-address`？默认情况下，nsqlookup 将使用 `hostname` 作为广播地址 当消费者运行回调时，它会尝试连接到如下内容：`http：// nsqlookup-234kf-asdf：4161 / lookup?topics = image`。请注意 `nsqlookup-234kf-asdf` 是容器的主机名。通过将广播地址设置为内部 DNS，回调将为：`http：//nsqlookup.default.svc.cluster.local：4161 / lookup?topic = images`。这将按预期工作。

NSQ 查找还需要两个端口进行转发：一个用于广播，一个用于 nsqd 回调。这些在 Dockerfile 中公开，然后 在Kubernetes 模板中使用。像这个：

在容器模板中：

```
ports:
- containerPort: 4160
    hostPort: 4160
- containerPort: 4161
    hostPort: 4161
```

在服务模板中：

```
spec:
    ports:
    - name: tcp
    protocol: TCP
    port: 4160
    targetPort: 4160
    - name: http
    protocol: TCP
    port: 4161
    targetPort: 4161
```

name 是 Kubernetes 需要的。

要创建此服务，我使用与以前相同的命令：

```
kubectl apply -f nsqlookup.yaml
```

到这里，有关于 nsqlookupd 的就结束了。

### 接收器

这是一个更复杂的问题。接收器会做三件事情：

*   创建一些 deployments
*   创建 nsq 守护进程
*   向公众提供服务

#### Deployments

它创建的第一个 deployment 对象是它自己的。Receiver的容器是 `skarlso / kube-receiver-alpine`。

#### Nsq 守护进程

Receiver 启动一个 nsq 守护进程。如前所述，接收者用它自己运行 nsqd。它是这样做的，因此可以在本地而不是通过网络进行通信。通过让接收器执行此操作，它们将在同一节点上结束。

NSQ 守护进程还需要一些调整和参数。

```
ports:
- containerPort: 4150
    hostPort: 4150
- containerPort: 4151
    hostPort: 4151
env:
- name: NSQLOOKUP_ADDRESS
    value: nsqlookup.default.svc.cluster.local
- name: NSQ_BROADCAST_ADDRESS
    value: nsqd.default.svc.cluster.local
command: ["/nsqd"]
args: ["--lookupd-tcp-address=$(NSQLOOKUP_ADDRESS):4160", "--broadcast-address=$(NSQ_BROADCAST_ADDRESS)"]
```

你可以看到设置了 lookup-tcp-address 和 broadcast-address 这两个参数。查找 tcp 地址是 nsqlookupd 服务的 DNS。广播地址是必要的，就像 nsqlookupd 一样，所以回调工作正常。

#### 面向大众的服务

现在，这是我第一次部署面向公众的服务。这里有两种选择。我可以使用 LoadBalancer，由于这个 API 可以承受很大的负载。如果这将在生产环境部署，那么它应该使用这一个。

我在本地做只部署单个节点的，所以称为“NodePort”就足够了。一个 `NodePort` 在一个静态端口上暴露每个节点 IP 上的服务。如果未指定，它将在 30000-32767 之间的主机上分配一个随机端口。但它也可以被配置为一个特定的端口，在模板文件中使用 `nodePort`。要使用此服务，请使用 `<NodeIP>：<NodePort>`。如果配置了多个节点，则 LoadBalancer 可以将它们复用到单个 IP。

有关更多信息，请查看此文档：[Publishing Service](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services---service-types)。

综合起来，我们会得到一个接收服务，其模板如下：

```
apiVersion: v1
kind: Service
metadata:
    name: receiver-service
spec:
    ports:
    - protocol: TCP
    port: 8000
    targetPort: 8000
    selector:
    app: receiver
    type: NodePort
```

对于 8000 上的固定节点端口，必须提供 `nodePort` 的定义：

```
apiVersion: v1
kind: Service
metadata:
    name: receiver-service
spec:
    ports:
    - protocol: TCP
    port: 8000
    targetPort: 8000
    selector:
    app: receiver
    type: NodePort
    nodePort: 8000
```

### 图像处理器

图像处理器是我处理传递图像以识别的地方。它应该有权访问 nsqlookupd，mysql 和人脸识别服务的 gRPC 端点。这实际上是相当无聊的服务。事实上，它甚至不是一项服务。它不会公开任何内容，因此它是第一个部署的组件。为简洁起见，以下是整个模板：

```
---
apiVersion: apps/v1
kind: Deployment
metadata:
    name: image-processor-deployment
spec:
    selector:
    matchLabels:
        app: image-processor
    replicas: 1
    template:
    metadata:
        labels:
        app: image-processor
    spec:
        containers:
        - name: image-processor
        image: skarlso/kube-processor-alpine:latest
        env:
        - name: MYSQL_CONNECTION
            value: "mysql.default.svc.cluster.local"
        - name: MYSQL_USERPASSWORD
            valueFrom:
            secretKeyRef:
                name: kube-face-secret
                key: mysql_userpassword
        - name: MYSQL_PORT
            # TIL: 如果这里的 3306 没有引号，kubectl 会出现错误
            value: "3306"
        - name: MYSQL_DBNAME
            value: kube
        - name: NSQ_LOOKUP_ADDRESS
            value: "nsqlookup.default.svc.cluster.local:4161"
        - name: GRPC_ADDRESS
            value: "face-recog.default.svc.cluster.local:50051"
```

这个文件中唯一有趣的地方是用于配置应用程序的大量环境属性。请注意 nsqlookupd 地址和 grpc 地址。

要创建此部署，请运行：

```
kubectl apply -f image_processor.yaml
```

### 人脸识别

人脸识别别服务是一个简单的，只有图像处理器才需要服务。它的模板如下：

```
apiVersion: v1
kind: Service
metadata:
    name: face-recog
spec:
    ports:
    - protocol: TCP
    port: 50051
    targetPort: 50051
    selector:
    app: face-recog
    clusterIP: None
```

更有趣的部分是它需要两个 volume。这两 volume 是 `known_people` 和 `unknown_people`。你能猜到他们将包含什么吗？是的，图像。“known_people” volume 包含与数据库中已知人员关联的所有图像。`unknown_people` volume 将包含所有新图像。这就是我们从接收器发送图像时需要使用的路径; 那就是挂载点所指向的地方，在我的情况下是 `/ unknown_people`。 基本上，路径必须是人脸识别服务可以访问的路径。

现在，通过 Kubernetes 和 Docker部署 volume 很容易。它可以是挂载的 S3 或某种类型的 nfs，也可以是从主机到客户机的本地挂载。也会存在其他可能性。为了简单起见，我将使用本地安装。

安装一个 volume 分两部分完成。首先，Dockerfile 必须指定 volume：

```
VOLUME [ "/unknown_people", "/known_people" ]
```

其次，Kubernetes 模板需要在 MySQL 服务中添加 `volumeMounts`，不同之处在于 `hostPath` 并不是声称的 volume：

```
volumeMounts:
- name: known-people-storage
    mountPath: /known_people
- name: unknown-people-storage
    mountPath: /unknown_people
volumes:
- name: known-people-storage
hostPath:
    path: /Users/hannibal/Temp/known_people
    type: Directory
- name: unknown-people-storage
hostPath:
    path: /Users/hannibal/Temp/
    type: Directory
```

我们还需要为人脸识别服务设置 `known_people` 文件夹配置。这是通过环境变量完成的：

```
env:
- name: KNOWN_PEOPLE
    value: "/known_people"
```

然后 Python 代码将查找图像，如下所示：

```
known_people = os.getenv('KNOWN_PEOPLE', 'known_people')
print("Known people images location is: %s" % known_people)
images = self.image_files_in_folder(known_people)
```

其中 `image_files_in_folder` 函数如下：

```
def image_files_in_folder(self, folder):
    return [os.path.join(folder, f) for f in os.listdir(folder) if re.match(r'.*\.(jpg|jpeg|png)', f, flags=re.I)]
```

Neat.

现在，如果接收方收到一个请求（并将其发送到更远的线路），与下面的请求类似。

```
curl -d '{"path":"/unknown_people/unknown220.jpg"}' http://192.168.99.100:30251/image/post
```

它会在 `/ unknown_people` 下寻找名为 unknown220.jpg 的图像，在 unknown_folder 中找到与未知图像中的人相对应的图像，并返回匹配图像的名称。

查看日志，你会看到如下内容：

```
# Receiver
❯ curl -d '{"path":"/unknown_people/unknown219.jpg"}' http://192.168.99.100:30251/image/post
got path: {Path:/unknown_people/unknown219.jpg}
image saved with id: 4
image sent to nsq

# Image Processor
2018/03/26 18:11:21 INF    1 [images/ch] querying nsqlookupd http://nsqlookup.default.svc.cluster.local:4161/lookup?topic=images
2018/03/26 18:11:59 Got a message: 4
2018/03/26 18:11:59 Processing image id:  4
2018/03/26 18:12:00 got person:  Hannibal
2018/03/26 18:12:00 updating record with person id
2018/03/26 18:12:00 done
```

这样，所有服务就部署完成了。

### 前端

最后，还有一个小型的 web 应用程序，它能够方便地展示数据库中的信息。这也是一个面向公众的接收服务，其参数与接收器相同。

它看起来像这样：

![frontend](https://skarlso.github.io/img/kube-frontend.png)

### 总结

我们现在正处于部署一系列服务的阶段。回顾一下我迄今为止使用的命令：

```
kubectl apply -f mysql.yaml
kubectl apply -f nsqlookup.yaml
kubectl apply -f receiver.yaml
kubectl apply -f image_processor.yaml
kubectl apply -f face_recognition.yaml
kubectl apply -f frontend.yaml
```

由于应用程序不会在启动时分配连接，因此可以按任意顺序排列。（除了 image_processor 的 NSQ 消费者。）

如果没有错误，使用 `kubectl get pods` 查询运行 pod 的 kube 应该显示如下：

```
❯ kubectl get pods
NAME                                          READY     STATUS    RESTARTS   AGE
face-recog-6bf449c6f-qg5tr                    1/1       Running   0          1m
image-processor-deployment-6467468c9d-cvx6m   1/1       Running   0          31s
mysql-7d667c75f4-bwghw                        1/1       Running   0          36s
nsqd-584954c44c-299dz                         1/1       Running   0          26s
nsqlookup-7f5bdfcb87-jkdl7                    1/1       Running   0          11s
receiver-deployment-5cb4797598-sf5ds          1/1       Running   0          26s
```

运行中的 `minikube service list`：

```
❯ minikube service list
|-------------|----------------------|-----------------------------|
|  NAMESPACE  |         NAME         |             URL             |
|-------------|----------------------|-----------------------------|
| default     | face-recog           | No node port                |
| default     | kubernetes           | No node port                |
| default     | mysql                | No node port                |
| default     | nsqd                 | No node port                |
| default     | nsqlookup            | No node port                |
| default     | receiver-service     | http://192.168.99.100:30251 |
| kube-system | kube-dns             | No node port                |
| kube-system | kubernetes-dashboard | http://192.168.99.100:30000 |
|-------------|----------------------|-----------------------------|
```

### 滚动更新

滚动更新过程中会发生什么？

![kube rotate](https://skarlso.github.io/img/kube_rotate.png)

正如在软件开发过程中发生的那样，系统的某些部分需要/需要进行更改。那么，如果我改变其中一个组件而不影响其他组件，同时保持向后兼容性而不中断用户体验，我们的集群会发生什么？幸运的是 Kubernetes 可以提供帮助。

我诟病的是 API 一次只能处理一个图像。不幸的是，这里没有批量上传选项。

#### 代码

目前，我们有以下处理单个图像的代码段：

```
// PostImage 处理图像的文章。 将其保存到数据库
// 并将其发送给 NSQ 以供进一步处理。
func PostImage(w http.ResponseWriter, r *http.Request) {
...
}

func main() {
    router := mux.NewRouter()
    router.HandleFunc("/image/post", PostImage).Methods("POST")
    log.Fatal(http.ListenAndServe(":8000", router))
}
```

我们有两种选择：用 `/ images / post` 添加一个新端点，并让客户端使用它，或者修改现有的端点。

新客户端代码的优势在于，如果新端点不可用，它可以退回到提交旧的方式。然而，旧客户端代码没有这个优势，所以我们无法改变我们的代码现在的工作方式。考虑一下：你有90台服务器，并且你做了一个缓慢的滚动更新，在更新的同时一次只取出一台服务器。如果更新持续一分钟左右，整个过程大约需要一个半小时才能完成（不包括任何并行更新）。

在此期间，你的一些服务器将运行新代码，其中一些将运行旧代码。调用是负载均衡的，因此你无法控制哪些服务器会被击中。如果客户试图以新的方式进行调用，但会触及旧服务器，则客户端将失败。客户端可以尝试并回退，但是由于你删除了旧版本，它将不会成功，除非它仅仅是一个机会，用新代码击中服务器（假设没有设置粘滞会话）。

另外，一旦所有服务器都更新完毕，旧客户端将无法再使用你的服务。

现在，你可以争辩说，你不想永远保留你的代码的旧版本。这在某种意义上是正确的。这就是为什么我们要修改旧代码，只需稍微增加一点就可以调用新代码。这样，一旦所有客户端都被迁移了，代码就可以简单地被删除而不会有任何问题。

#### 新的端点

我们来添加一个新的路径方法：

```
...
router.HandleFunc("/images/post", PostImages).Methods("POST")
...
```

更新旧版本以调用带有修改后版本的新版本，如下所示：

```
// PostImage 处理图像的文章。 将其保存到数据库
// 并将其发送给 NSQ 以供进一步处理。
func PostImage(w http.ResponseWriter, r *http.Request) {
    var p Path
    err := json.NewDecoder(r.Body).Decode(&p)
    if err != nil {
        fmt.Fprintf(w, "got error while decoding body: %s", err)
        return
    }
    fmt.Fprintf(w, "got path: %+v\n", p)
    var ps Paths
    paths := make([]Path, 0)
    paths = append(paths, p)
    ps.Paths = paths
    var pathsJSON bytes.Buffer
    err = json.NewEncoder(&pathsJSON).Encode(ps)
    if err != nil {
        fmt.Fprintf(w, "failed to encode paths: %s", err)
        return
    }
    r.Body = ioutil.NopCloser(&pathsJSON)
    r.ContentLength = int64(pathsJSON.Len())
    PostImages(w, r)
}
```

那么，命名可能会更好，但你应该得到基本的想法。我正在修改传入的单个路径，将它包装成新的格式并发送给新的端点处理程序。就是这样！ 还有一些修改。要查看它们，请查看此PR：[Rolling Update Bulk Image Path PR](https://github.com/Skarlso/kube-cluster-sample/pull/1)。

现在，可以通过两种方式调用接收器：

```
# 单个路径:
curl -d '{"path":"unknown4456.jpg"}' http://127.0.0.1:8000/image/post

# 多元路径:
curl -d '{"paths":[{"path":"unknown4456.jpg"}]}' http://127.0.0.1:8000/images/post
```

在这里，客户端被访问。通常情况下，如果客户端是服务，我会修改它，以防万一新的端点抛出一个 404，它会尝试下一个。

为简洁起见，我不修改 NSQ 和其他用来批量图像处理的操作，他们仍然会一个一个接收。这就当作业留给你们来做了。

#### 新的镜像

要执行滚动更新，我必须首先从接收器服务创建一个新镜像。

```
docker build -t skarlso/kube-receiver-alpine:v1.1 .
```

一旦完成，我们可以开始推出更改。

#### 滚动更新

在 Kubernetes 中，您可以通过多种方式配置滚动更新：

##### 手动更新

如果我在我的配置文件中使用了一个名为 `v1.0` 的容器版本，那么更新只是简单地调用：

```
kubectl rolling-update receiver --image:skarlso/kube-receiver-alpine:v1.1
```

如果在部署期间出现问题，我们总是可以回滚。

```
kubectl rolling-update receiver --rollback
```

它将恢复以前的版本。 不需要大惊小怪，没有任何麻烦。

##### 应用一个新的配置文件

手动更新的问题在于它们不在源代码控制中。

考虑一下：有些东西已经改变，一些服务器手动更新以做一个快速的“补丁修复”，但没有人目睹它，并且没有记录。一个新的人出现并对模板进行更改并将模板应用到群集。所有服务器都会更新，然后突然出现服务中断。

长话短说，更新后的服务器已经被覆盖，因为该模板没有反映手动完成的工作。

推荐的方法是更改​​模板以使用新版本，并使用 `apply` 命令应用模板。

Kubernetes 建议使用 ReplicaSets 进行部署应处理分发这意味着滚动更新必须至少有两个副本。如果少于两个副本存在，则更新将不起作用（除非 `maxUnavailable` 设置为 1）。我增加了 yaml 的副本数量。我还为接收器容器设置了新的镜像版本。

```
    replicas: 2
...
    spec:
        containers:
        - name: receiver
        image: skarlso/kube-receiver-alpine:v1.1
...
```

看看处理情况，这是你应该看到的：

```
❯ kubectl rollout status deployment/receiver-deployment
Waiting for rollout to finish: 1 out of 2 new replicas have been updated...
```

您可以通过指定模板的 `strategy` 部分添加其他部署配置设置，如下所示：

```
strategy:
type: RollingUpdate
rollingUpdate:
    maxSurge: 1
    maxUnavailable: 0
```

有关滚动更新的更多信息，请参见以下文档：[Deployment Rolling Update](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#rolling-back-a-deployment), [Updating a Deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#updating-a-deployment), [Manage Deployments](https://kubernetes.io/docs/concepts/cluster-administration/manage-deployment/#updating-your-application-without-a-service-outage), [Rolling Update using ReplicaController](https://kubernetes.io/docs/tasks/run-application/rolling-update-replication-controller/)。

**MINIKUBE 的用户注意**：由于我们在具有一个节点和一个应用程序副本的本地机器上执行此操作，我们必须将 `maxUnavailable` 设置为 `1`; 否则 Kubernetes 将不允许更新发生，并且新版本将保持 `Pending` 状态。这是因为我们不允许存在没有运行容器的服务，这基本上意味着服务中断。

### Scaling

用 Kubernetes 来 scaling 比较容易。由于它正在管理整个集群，因此基本上只需将一个数字放入所需副本的模板中即可使用。

迄今为止这是一篇很棒的文章，但时间太长了。我正在计划编写一个后续行动，我将通过多个节点和副本真正扩展 AWS 的功能; 再加上 [Kops](https://github.com/kubernetes/kops) 部署 Kubernetes 集群。敬请期待！

### 清理

```
kubectl delete deployments --all
kubectl delete services -all
```

## 写在最后

女士们，先生们。我们用 Kubernetes 编写，部署，更新和扩展了（当然还不是真的）分布式应用程序。

如果您有任何问题，请随时在下面的评论中聊天。我非常乐意解答。

我希望你享受阅读它，虽然这很长， 我正在考虑将它分成多篇博客，但是有一个整体的的，一个页面指南是有用的，并且可以很容易地找到，保存和打印。

感谢您的阅读。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
