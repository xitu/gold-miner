> 原文地址：[Using Spring cloud gateway for microservices app](https://sairavvatts.medium.com/using-spring-cloud-gateway-for-microservices-app-40985e8351)
> * 原文作者：[Sairav Vatts](https://sairavvatts.medium.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/using-spring-cloud-gateway-for-microservices-app.md](https://github.com/xitu/gold-miner/blob/master/article/2021/using-spring-cloud-gateway-for-microservices-app.md)
> * 译者：[greycode](https://github.com/greycodee)
> * 校对者：[qq1120637483](https://github.com/qq1120637483)、[PassionPenguin](https://github.com/PassionPenguin)

# 使用 Spring cloud gateway 作为微服务网关

API 网关作为客户端和微服务之间的反向代理, **它会将客户端的请求路由到各个微服务**。客户端只需要向**单个主机（网关服务）**发送请求，而不需要知道所有微服务的服务器地址，每个微服务只有网关一个入口点。

![API Gateway Basic](https://miro.medium.com/max/1106/1*eC8sTN553I4wPpGDo_L4gg.png)

Web 和移动客户端调用网关而不是单个服务主机。

## 为什么是 API 网关?

* [**7 层路由和负载均衡**](https://www.nginx.com/resources/glossary/layer-7-load-balancing/) =\> 使[负载均衡器](https://www.nginx.com/resources/glossary/load-balancing/) 做出更智能的负载均衡策略，并且可以对内容进行优化和更改（比如压缩和加密）。这意味着可以根据请求的内容来路由到指定的微服务。可以看看[示例](https://www.nginx.com/resources/glossary/layer-7-load-balancing/)。
* **修改请求和响应** =\> 可以使用 Filter 过滤器来更改传入的 Request 请求，同样响应 Response 也可以在响应给客户端前在网关层进行修改。
* **处理横切关注点** =\> 身份认证和授权（统一认证），SSL Termination，日志可以放在网关服务上进行处理，从而减少终端微服务的重复开发。

## Spring Cloud Gateway 和响应编程

我们使用的 **Spring cloud gateway (**SCG**)** 主要是基于以下几个项目构建的

- **\> Spring Framework 5**

- **\>** [**Project Reactor**](https://projectreactor.io/)

- **\> Spring Boot 2.0** 

SCG 支持 [**非阻塞 API**](https://stackoverflow.com/a/56806022/3820753)，异步请求处理，与在**每个请求模型的线程上**工作的阻塞 API 有所不同。 异步（**非阻塞**）系统的运行方式与平常的不太一样，通常它是**一个线程处理大量的请求和响应**。

* 当一个请求进来，会立刻为该请求分配一个 Servlet 线程，而不需要等待其他请求处理完成，线程需要回调 →『当处理完成后请回调我』并继续处理其他传入的请求。服务器有任何耗时的操作都**不会阻塞线程** ，比如数据库操作或者处理其他事情。当数据库操作或其他事情处理完成后，线程会被通知数据已经准备好发回并响应给客户端。

[Defog Tech 的 YouTube 视频](https://youtu.be/M3jNn3HMeWg?t=182)对此有更好的解释。

**请求和响应的生命周期通过事件和回调来进行处理**. 因此只需要较小数量的线程就可以，因为单个线程可以处理多个传入的请求，而且线程不会因为每个请求而被阻塞。

- **Zuul 网关** —— 阻塞

- **Zuul2 和 Spring Cloud Gateway** —— 非阻塞

## 使用 Spring Cloud Gateway 和 Springboot 来编写代码

> 注意 —— 我们有一个程序运行在 9091 端口上。我们的目标是添加一个网关来将我们的请求路由到那个应用程序上。

1. 使用 [**Spring Initilizr**](https://start.spring.io/) 来创建一个简单的 Springboot 程序，然后在 pom.xml 中添加网关的重要依赖：

```
<dependency>    
  <groupId>org.springframework.boot</groupId>  
  <artifactId>spring-boot-starter-webflux</artifactId>  
</dependency><dependency>  
  <groupId>org.springframework.cloud</groupId>  
  <artifactId>spring-cloud-starter-gateway</artifactId>         
  <version>2.1.3.RELEASE</version>  
</dependency>
```

我们可以在属性配置文件或 Java 代码中为 Spring Cloud Gateway 设置路由配置。这里我们将使用 yml 文件来进行配置：

2. 创建 application.yml:

```yml
server:  
  port: 8085
  
spring:  
  application:  
    name: gateway     
  cloud:       
    gateway:         
      routes:         
        - id: order-route          
          uri: http://localhost:9091/  
          predicates:                                                                
          - Path=/orders
```

配置非常直观，让我们来一步一步的讲解它。网关的主要用途是路由，你可以看到配置路由的 `routes` 字段  

`-id` — 是这个路由的唯一标识符。（你可以将它设置为任意值，但是要全局唯一）

`uri` — 传入的请求需要被路由到的微服务或目标主机和端口。

[`predicates`](https://cloud.spring.io/spring-cloud-gateway/reference/html/#gateway-request-predicates-factories) — 这是请求条件，当满足条件时，路由会执行到运行在 uri 主机服务器上的微服务。

3. 让我们运行这个应用程序，并且请求网关 API，不出意外的话它应该会被转发到运行在 9091 端口上的服务。

直接请求运行在 9091 端口上的服务将得到以下响应：

![](https://miro.medium.com/max/2740/1*XSn2FBqIR_B5jYgmxSS6RA.png)

所以，**现在如果我们请求网关 API，我们应该会被转发到这个服务上**。让我们对网关发出相同的请求。从配置中你可以看到我的网关运行在 8085 端口上。

![](https://miro.medium.com/max/2748/1*CtL5gwmxOjkM8msNaWFnWQ.png)

我们可以看到，**发送到网关的请求被路由到了运行在 localhost:9091 的服务上。**

=\> 除了 path 谓词，SCG 还有一些[其他的谓词](https://cloud.spring.io/spring-cloud-gateway/reference/html/#gateway-request-predicates-factories)， 比如像 [主机名模式](https://cloud.spring.io/spring-cloud-gateway/reference/html/#the-host-route-predicate-factory) , [before route](https://cloud.spring.io/spring-cloud-gateway/reference/html/#the-before-route-predicate-factory)（路由所有在特定时间戳之间到来的请求），[after route](https://cloud.spring.io/spring-cloud-gateway/reference/html/#the-after-route-predicate-factory)（路由所有在特定时间之后到来的请求）等等。所有谓词都可以按以下方式组合：

```yml
server:  
  port: 8085
  
spring:  
  application:  
    name: gateway     
  cloud:       
    gateway:         
      routes:         
        - id: order-route          
          uri: http://localhost:9091/  
          predicates:                                                                
          - Path=/orders  
          - Before=2022-01-20T17:42:47.789-07:00[America/Denver]
```

所以只要在 2022-01-20 之前发出请求，就能成功路由到运行在 localhost:9091 的服务上。

## 让我们尝试用 Filter 过滤器修改 Response：

```
server:  
  port: 8085

spring:  
  application:  
    name: gateway   
  cloud:  
    gateway:  
      routes:  
      - id: order-service  
        uri: [http://localhost:9091/](http://localhost:9091/)  
        predicates:  
        - Path=/orders  
        filters:  
        - AddResponseHeader=X-Request-color, blue
```

这里我们添加了一个 AddResponseHeader 过滤器（[更多过滤器请点击查看](https://cloud.spring.io/spring-cloud-gateway/reference/html/#gatewayfilter-factories)），它将在 Response 上添加一个值为 `blue` 的 `X-Request-color` 响应头，显然谓词条件得到了遵守。所以，对于所有传入的请求中，地址是 `/orders` 的将会被路由到 `http://localhost:9091/`，并且它们的 Response 响应中将有**额外添加的 header（X-Request-color -> blue）**。

## 在 postman 上测试网关 API：

![Spring Cloud Gateway — Postman Response with filter](https://miro.medium.com/max/2736/1*viJfGCzHXiylRzFQjN-9CQ.png)

正如你所见，我们在遵循谓词条件的请求中的 Response 响应头上有额外添加的 header 参数。

[**Youtube 中的 SpringDeveloper**](https://youtu.be/puIJ1Mn9_LE?t=753) 演示了一个非常好且易于理解的示例，其中包含在网关应用程序中添加路由的 Java 风格。

总而言之，这是对于什么是 API 网关、为什么以及如何使用 Spring Cloud 网关以获得更好的性能和反应式微服务架构的基本示例。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
