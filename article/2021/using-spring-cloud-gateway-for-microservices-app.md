> * 原文地址：[Using Spring cloud gateway for microservices app](https://sairavvatts.medium.com/using-spring-cloud-gateway-for-microservices-app-40985e8351)
> * 原文作者：[Sairav Vatts](https://sairavvatts.medium.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/using-spring-cloud-gateway-for-microservices-app.md](https://github.com/xitu/gold-miner/blob/master/article/2021/using-spring-cloud-gateway-for-microservices-app.md)
> * 译者：
> * 校对者：

# Using Spring cloud gateway for microservices app

An API Gateway acts as a **reverse proxy** sitting between client and micro services, **routing requests from client side to various micro-services**. User/client makes a request to a **single host (gateway server)** and need not know all the microservices servers, just **single entry point to your application**.

![API Gateway Basic](https://miro.medium.com/max/1106/1*eC8sTN553I4wPpGDo_L4gg.png)

Web & Mobile Client calling gateway instead of individual service host machines.

## Why API Gateway?

* [**Layer 7 routing and load balancing**](https://www.nginx.com/resources/glossary/layer-7-load-balancing/) =\> enables the [load balancer](https://www.nginx.com/resources/glossary/load-balancing/) to make **smarter load‑balancing decisions**, and to apply optimizations and changes to the content (such as compression and encryption). That means **based on the content of the request , the routing can be done to specific serves which stores that particular content**. Check the example [here](https://www.nginx.com/resources/glossary/layer-7-load-balancing/).
* **Modify Requests & Reponse** =\> incoming requests can be modified based a logic using filters, similarly outgoing reponse can be modified at gateway layer before going out.
* **Handling cross-cutting concerns** =\> Authentication& authorization (Centralized Security), SSL termination, logging can be handled at the gateway server which reduces significant development on the end microservices side.

## Spring Cloud Gateway & Reactive Programming

We will be using **Spring cloud gateway (**SCG**)** which is built on top of

- **\> Spring Framework 5**

- **\> [**Project Reactor**](https://projectreactor.io/) **and**

- **\> Spring Boot 2.0** .

SCG supports [**non-blocking APIs**](https://stackoverflow.com/a/56806022/3820753)  , asynchronous request processing, as opposed to blocking apis which work on a **thread per request model**. Async (**non-blocking**) systems operate differently, **with generally one thread handling large number of requests and responses**.

* When a request comes, a servlet thread is assigned to it and instead of waiting for each request to complete processing, thread asks for the callback → “when the processing is done, call me back“ and moves on to serve other incoming requests. There is **no blocking of thread** in case the service has any operation that is time consuming like db operation or other processing. When that processing or db operation is completed, thread is notified that data is ready to be sent back and the response is returned back to the client.

A very good explaination is given on Defog Tech YT video [here](https://youtu.be/M3jNn3HMeWg?t=182).

**The lifecycle of the request and response is handled through events and callbacks**. Hence lesser number of threads would be required as single thread will be able to serve multiple incoming requests and thread will not be blocked sitting idle with each request.

- **Zuul Gateway**— Blocking

- **Zuul2 and Spring Cloud Gateway** — Non-blocking

## Now lets get to code using Spring Cloud Gateway with Springboot

> Note — We have a random application already running at 9091 port . We will aim to add a gateway and route our requests to that application.

1. Create a simple Springboot app from [**Spring Initilizr**](https://start.spring.io/) and add these important dependencies for gateway application pom.xml:

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

We can provide the routing configuration with Spring Cloud Gateway either in properties file or in Java. We will be using yml file to configure:

2. create application.yml:

```
server:  
  port: 8085spring:  
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

The configuration is pretty intuitive , lets break it down , as gateways’ main purpose is routing, you can see that as a major block of the config “routes”.

“-id” — is a unique identifier for this route. (you can name the route anything)

“uri” — is the microservice / target host and port here the incoming request needs to be routed to.

“[predicates](https://cloud.spring.io/spring-cloud-gateway/reference/html/#gateway-request-predicates-factories)” — It is a condition that when the request follows, the routing is performed to the micro-service running at the uri host server.

3. Let’s run this application and hit the gateway api and it should redirect to the service running at port 9091.

Currently the application running at 9091 gives the following response:

![](https://miro.medium.com/max/60/1*XSn2FBqIR_B5jYgmxSS6RA.png?q=20)

![](https://miro.medium.com/max/2740/1*XSn2FBqIR_B5jYgmxSS6RA.png)

So, **now if we hit the gateway api, we should be redirected to this service**. Let’s hit the same request with gateway host and port. My gateway app is running at 8085 as you can see in the config.

![](https://miro.medium.com/max/60/1*CtL5gwmxOjkM8msNaWFnWQ.png?q=20)

![](https://miro.medium.com/max/2748/1*CtL5gwmxOjkM8msNaWFnWQ.png)

We can see, **the request sent to gateway app has been routed to service running at localhost 9091**.

=\> Apart from path predicate , there are several [other predicates](https://cloud.spring.io/spring-cloud-gateway/reference/html/#gateway-request-predicates-factories) that are available in SCG like [hostname pattern](https://cloud.spring.io/spring-cloud-gateway/reference/html/#the-host-route-predicate-factory) , [before route](https://cloud.spring.io/spring-cloud-gateway/reference/html/#the-before-route-predicate-factory) (route requests coming before certain timestamp), [after route](https://cloud.spring.io/spring-cloud-gateway/reference/html/#the-after-route-predicate-factory)(route requests coming after certain timestamp) etc. All predicates can be clubbed in the below fashion:

```
server:  
  port: 8085spring:  
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

So as long as the request is made before Jan-20–2022, it will successfully route to application running at localhost 9091.

## Now Let’s try to modify the outgoing response using filters:

```
server:  
  port: 8085spring:  
  application:  
    name: gateway cloud:  
    gateway:  
      routes:  
      - id: order-service  
        uri: [http://localhost:9091/](http://localhost:9091/)  
        predicates:  
        - Path=/orders  
        filters:  
        - AddResponseHeader=X-Request-color, blue
```

Here, we have added a filter i.e AddResponseHeader (one of many [filter factories](https://cloud.spring.io/spring-cloud-gateway/reference/html/#gatewayfilter-factories) available) , that will **add the header “X-Request-color” with value “blue” in the response**, and obviously the predicate condition is respected . So, for all the incoming requests having path “/orders” will be routed to “http://localhost:9091/” and their response will have an **additional header (X-Request-color -> blue)**.

## Let’s hit the gateway api on postman and test it:

![Spring Cloud Gateway — Postman Response with filter](https://miro.medium.com/max/60/1*viJfGCzHXiylRzFQjN-9CQ.png?q=20)

![Spring Cloud Gateway — Postman Response with filter](https://miro.medium.com/max/2736/1*viJfGCzHXiylRzFQjN-9CQ.png)

As you can see, we have an additional header in the response for the request that followed the predicate condition.

A very good and easily understandable example is shown [here](https://youtu.be/puIJ1Mn9_LE?t=753) in **SpringDeveloper channel in YT** that contains Java style of adding the routes in the gateway application.

To summarise, this was a basic example of what is API gateway, why and how Spring Cloud gateway to be used for better performance and reactive micro-service architecture.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
