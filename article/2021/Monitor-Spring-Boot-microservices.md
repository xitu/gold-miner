> * 原文地址：[Monitor Spring Boot microservices](https://developer.ibm.com/tutorials/monitor-spring-boot-microservices/?mhsrc=ibmsearch_a&mhq=spring)
> * 原文作者：[Tanmay Ambre](https://developer.ibm.com/tutorials/monitor-spring-boot-microservices/?mhsrc=ibmsearch_a&mhq=spring)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/Monitor-Spring-Boot-microservices.md](https://github.com/xitu/gold-miner/blob/master/article/2021/Monitor-Spring-Boot-microservices.md)
> * 译者：[YueYongDev](https://github.com/YueYongDev)
> * 校对者：[Liang2028](https://github.com/Liang2028), [niayyy](https://github.com/nia3y)

# SpringBoot 微服务监控

> 使用 Micrometer、Prometheus 和 Grafana 为 Spring Boot 微服务构建全面的监控能力

## 介绍

在使用微服务和事件驱动架构（EDA）时，监控、日志、追踪和告警等方面的可观察性是一个架构十分重要的关注点，主要是因为：

- 大规模的部署需要集中且自动化的监控与可观测能力

* 架构的异步性和分布式性质使得关联多个组件产生的指标变得困难

解决这个架构问题可以简化架构管理，并加快解决运行时问题的周转时间。还能提供有助于做出明智的架构、设计、部署和基础设施的见解，以改善平台的非功能特性。此外，自定义指标的产出、收集和可视化可以为业务或运营带来其他有用的信息。

然而在实际的架构应用中，这个问题经常被忽略。本教程通过使用 Micrometer、Prometheus 和 Grafana 等开源工具对 Java 和 Spring Boot 微服务的可观察性进行*监控*，相信会成为该方面最佳的实践指南。

## 先决条件

在你开始本教程之前，你需要设置以下环境：

- 拥有 [Docker Compose](https://docs.docker.com/compose/) 工具的 [Docker](https://www.docker.com/) 环境
- 一个用于克隆和编辑 git repo 中的代码的 Java IDE

## 预计时间

完成本教程大约需要 2 个小时。

## 监控概述

监控工具的主要目标是：

- 监控应用程序性能
- 为利益相关者（开发团队、基础架构团队、运营用户、维护团队和商业用户）提供自助服务。
- 协助进行快速问题溯源分析（RCA）
- 建立应用程序的性能基线
- 如果使用云服务，提供云服务使用成本的监测能力，并以集成的方式监控不同的云服务

监控主要体现在以下四类行为：

- 应用的 **_指标化_** ——对应用进行指标化带来的指标度量对监控应用和维护团队以及业务用户十分重要。有许多非侵入性的方法来度量指标，最流行的是“字节码检测”、“面向切面的编程”和“JMX”。
- **_指标收集_** —— 从应用中收集指标，并将其持久化到相应的存储库中。然后，存储库需要提供一种查询和汇总数据的方法，以实现数据的可视化。市面上流行的收集器有 Prometheus、StatsD 和 DataDaog。大多数指标收集工具是时间序列存储库，并提供高级查询能力。
- **_指标可视化_** —— 可视化工具指标查询库，建立视图和仪表盘供最终用户使用。它们提供丰富的用户界面来对指标执行各种操作，例如聚合、数据下探等。
- **_告警和通知_** —— 当指标超过定义的阈值（例如 CPU 超过 80% 且持续 10 分钟），可能需要人工干预。为此，告警和通知很重要。大多数可视化工具提供了告警和通知能力。

许多开源和商业产品可用于监控。一些著名的商业产品有：AppDynamics、Dynatrace、DataDog、logdna 和 sysdig。开源工具通常被组合使用。一些非常流行的组合是 Prometheus 和 Grafana、Elastic-Logstash-Kibana (ELK) 和 StatsD + Graphite。

## 微服务监控指南

我们鼓励在所有微服务中将收集的指标类型保持一致。这有助于提高监控仪表盘的复用性，并简化指标的聚合和下探（drill-down），以便在不同层面上对其进行可视化。

### 要监控什么

微服务暴露一个 API 和（或）消费事件和消息。在处理过程中，它可能会调用自己的业务组件，例如连接到数据库，调用技术服务（缓存、审核等），调用其他微服务和（或）发送事件和消息。在这些不同的处理阶段监测指标是有益的，因为它有助于提供关于性能和异常情况的汇总分析。这反过来又有助于快速分析问题。

与事件驱动架构（EDA）和微服务相关的常用指标包括：

- **资源利用率指标**

  - 资源利用率 —— CPU、内存、磁盘利用率、网络利用率等

  - JVM 堆和 GC 指标 —— GC 开销、GC 时间、堆（及其不同区域）利用率

  - JVM 线程利用率 —— 阻塞、可运行、等待连接使用时间


- **应用程序指标**

  微服务不同架构层的可用性、延迟、吞吐量、状态、异常等，例如:

  - 控制器层 —— 用于 HTTP/REST 方法调用

  - 服务层——用于方法调用
  - 数据访问层——用于方法调用
  - 集成层——用于 RPC 调用、HTTP/REST/API 调用、消息发布、消息消费

- **技术服务利用率指标** （具体到对应的技术服务）

  - 缓存——缓存的命中率、丢失率、写入率、清理率、读取率
  - 日志——每个日志级别的日志事件数
  - 连接池——连接池的使用率、连接等待时间、连接创建时间、空闲置连接数

- **中间件指标**
  - 事件代理（Event broker）指标——可用性、消息吞吐、字节吞吐、消费滞后、（反）序列化异常、集群状态
  - 数据库指标

对于应用指标，理想情况下，微服务中每个*架构层*的入口和出口点都应该被检测。

### 微服务的关键指标特征

在监控微服务时，指标的以下三个特征很重要：

- 维度
- 时间序列/速率汇总
- 指标观点

#### 维度

维度控制了一个指标的聚合方式，以及特定指标的深入程度。它是通过向一个指标添加标签来实现的。标签是一组键值对信息（如 `name-value` ）。标签被用来限定通过对监控系统的查询来获取或聚合指标。由于大量的部署，它是监控微服务的重要特征。换句话说，多个微服务（甚至一个微服务的不同组件）会发送同名的指标。为了区分它们，你需用维度来限定指标。

例如，对于 `http_server_requests_seconds_count` 这个指标。如果有多个 API 节点（在微服务生态中就是如此），那么在没有维度的情况下，就只能在平台层面查看这个指标的聚合值。无法获得该指标在不同 API 节点分布的具体情况。在发送指标的时候，给指标添加一个 `uri` 标签，就可以获取对应的分布。看看下面的例子，它解释了这个特性。

如果 `http_server_requests_seconds_count` 使用以下标签产出指标数据：

```
http_server_requests_seconds_count{appName="samplemicrosvc",env="local",exception="None",instanceId="1",method="GET",outcome="SUCCESS",status="200",uri="/addressDetails/{addressId}",} 67.0
http_server_requests_seconds_count{appName="samplemicrosvc",env="local",exception="InternalServerError",instanceId="1",method="GET",outcome="SERVER_ERROR",status="500",uri="/userInfo/{userId}",} 39.0
http_server_requests_seconds_count{appName="samplemicrosvc",env="local",exception="None",instanceId="1",method="GET",outcome="SUCCESS",status="200",uri="/userInfo/{userId}",} 67.0
http_server_requests_seconds_count{appName="samplemicrosvc",env="local",exception="IllegalArgumentException",instanceId="1",method="GET",outcome="SERVER_ERROR",status="500",uri="/addressDetails/{addressId}",} 13.0
http_server_requests_seconds_count{appName="samplemicrosvc",env="local",exception="IllegalStateException",instanceId="1",method="GET",outcome="SERVER_ERROR",status="500",uri="/addressDetails/{addressId}",} 26.0
```

那么通过 HTTP 响应`状态`或`结果`即可将 `http_server_requests_seconds_count` 指标在 `appName` 级别、`instanceId` 级别下聚合，查询语句如下：

```
# Count distribution by status for a given environment
sum by (status) (http_server_requests_seconds_count{env="$env"})

# Count distribution by uri and status for a given environment
sum by (uri, status) (http_server_requests_seconds_count{env="$env"})

# Count distribution by uri, status and appName for a given environment
sum by (uri, status, appName) (http_server_requests_seconds_count{env="$env"})
```

标签也可以用作查询条件。请注意 `env` 标签的用法，其中 `$env` 是 Grafana 仪表板用于用户输入“环境”的变量。

#### 时间序列/速率聚合

随时间聚合指标的能力对于应用的性能分析非常重要，例如将性能与负载模式相关联，构建天/周/月的性能配置文件，以及创建应用程序的性能基线。

#### 指标视角

这是一个派生的特征，并提供了将度量组合在一起以便于可视化和使用的能力。例如：

- 描述平台所有微服务可用性状态的仪表盘
- 每个微服务的下探（详细）视图，用于查看微服务的详细指标
- 中间件组件的集群视图和详细视图，例如 Event Broker

## 检测 Spring Boot 微服务

本节介绍微服务及其 REST 控制器、服务 bean、组件 bean 和数据访问对象的检测。本文还介绍了与 EDA 或集成相关的一些组件，例如 `kafka` 中的生产者与消费者，`spring-cloud-stream` 或 `Apache Camel` 中的 camel 路由。

为了帮助微服务的监控和管理，这里我们使用了 [Spring Boot Actuator](https://docs.spring.io/spring-boot/docs/current/reference/html/production-ready-features.html#production-ready) 服务。这是一个开箱即用的、使用多个 HTTP 和 JMX 节点来监控应用程序的第三方组件，可以实现对微服务的健康状况、bean 信息、应用程序信息和环境信息的基本监控。

为了启用该功能，我们需要将 `spring-boot-starter-actuator` 添加为应用的依赖：

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-actuator</artifactId>
</dependency>
```

### 开箱即用的 Actuator 指标

将 Spring Boot Actuator 添加到微服务后，以下指标可以被直接使用：

- JVM 指标（与 GC 和线程利用率相关）
- 资源利用率指标（CPU、线程、文件描述符、JVM 堆和垃圾收集指标）
- Kafka 消费者指标
- 日志指标（Log4j2、Logback）
- 可用性指标（进程正常运行时间）
- 缓存指标（Caffeine、EhCache2、Hazelcast 或任何符合 JSR-107 的缓存）
- Tomcat 指标
- Spring 集成指标

### 自定义指标节点

Actuator 还为指标创建自定义节点。默认情况下，它存储在 `/actuator/metrics` 中。需要通过 Spring 配置暴露出来。以下是示例配置：

```yaml
management:
  endpoints:
    web:
      exposure:
        include:
          [
            "health",
            "info",
            "metrics",
            "prometheus",
            "bindings",
            "beans",
            "env",
            "loggers",
            "streamsbindings",
          ]
```

### Micrometer

为了与度量工具集成，Spring Boot Actuator 为 [Micrometer](https://micrometer.io/) 提供了自动配置。Micrometer 为包括 Prometheus 在内的大量监控系统提供了一个外观。本教程假定你对 [Micrometer 的概念](https://micrometer.io/docs/concepts) 有一定的了解。Micrometer 提供了三种收集指标的机制：

- 计数器（Counter）——通常用于计数出现、方法执行、异常等
- 计时器（Timer）——用于测量持续时间和发生次数；通常用于测量延迟
- 量规（Gauge）——单点时间度量；例如，线程数

### 与 Prometheus 集成

由于 Prometheus 使用轮询的方式来收集指标，因此集成 Prometheus 和 Micrometer 是相对简单的两步过程。

1. 添加 `micrometer-registry-prometheus` 注册。
2. 声明一个 `MeterRegistryCustomizer<PrometheusMeterRegistry>` 类型的 bean。

这是一个可选操作。但是，我推荐你这样做，因为它提供了一种自定义 `MeterRegistry`。这对通过 Micrometer 收集的指标数据而声明的**通用标签（维度）**很有用。尤其是当有很多微服务或每个微服务有多个实例时，这样做有助于数据指标的下探，常用的标记通常包括 `applicationName`、`instanceName` 和 `environment`。这允许你跨应用与实例来构建聚合数据的可视化，并能够深入到特定的实例、应用程序或环境。

配置完成后，Actuator 将暴露一个 `/actuator/prometheus` 中配置的节点 ，该端点应在 Spring 配置中启用。然后我们需要在 Prometheus 中配置一个 job，以便以指定的频率获取该节点产出的数据。

#### 将 Prometheus 依赖添加到 pom

```xml
<dependency>
    <groupId>io.micrometer</groupId>
    <artifactId>micrometer-registry-prometheus</artifactId>
</dependency>
```

#### 自定义 MetricsRegistry

利用 `MetricsRegistryCustomizer` 声明的配置类可以作为框架的一部分，以便所有微服务实现都可以复用它。可以使用系统/应用属性作为标签。

```java
@Configuration
public class MicroSvcMeterRegistryConfig {
    @Value("${spring.application.name}")
    String appName;

    @Value("${env}")
    String environment;

    @Value("${instanceId}")
    String instanceId;

    @Bean
    MeterRegistryCustomizer<PrometheusMeterRegistry> configureMetricsRegistry()
    {
        return registry -> registry.config().commonTags("appName", appName, "env", environment, "instanceId", instanceId);
    }
```

### 应用程序级别指标的检测

一些应用程序级别的指标是开箱即用的，在某些情况下，可以采用多种指标。下表总结了这些功能：

| 指标                                            | 控制器                   | 服务层组件                             | 数据访问对象                           | 业务组件                               | 技术组件                               | Kafka 消费者                             | Kafka 生产者                     | Spring 集成组件 | HTTP 客户端 | Camel 路由                         |
| :---------------------------------------------- | :----------------------- | :------------------------------------- | :------------------------------------- | :------------------------------------- | :------------------------------------- | :--------------------------------------- | :------------------------------- | :-------------- | :---------- | :--------------------------------- |
| **资源利用率**（CPU、线程、文件描述符、堆、GC） | 开箱即用的微服务实例级别 |                                        |                                        |                                        |                                        |                                          |                                  |                 |             |                                    |
| **可用性**                                      | 开箱即用的微服务实例级别 |                                        |                                        |                                        |                                        |                                          |                                  |                 |             |                                    |
| **延迟**                                        | 开箱即用的`@Timed`注释   | 通过 Spring-AOP 的自定义可重用方面完成 | 通过 Spring-AOP 的自定义可重用方面完成 | 通过 Spring-AOP 的自定义可重用方面完成 | 开箱即用的日志记录、缓存和 JDBC 连接池 | 如果使用 spring-cloud-stream，则开箱即用 | 通过自定义 MeterBinder bean 完成 | 开箱即用        | 开箱即用    | 提供部分支持。需要自定义路线仪表。 |
| **吞吐量**                                      | 开箱即用的`@Timed`注释   | 通过 Spring-AOP 的自定义可重用方面完成 | 通过 Spring-AOP 的自定义可重用方面完成 | 通过 Spring-AOP 的自定义可重用方面完成 | 开箱即用的日志记录、缓存和 JDBC 连接池 | 如果使用 spring-cloud-stream，则开箱即用 | 通过自定义 MeterBinder bean 完成 | 开箱即用        | 开箱即用    | 提供部分支持。需要自定义路线仪表。 |
| **例外**                                        | 开箱即用的`@Timed`注释   | 通过 Spring-AOP 的自定义可重用方面完成 | 通过 Spring-AOP 的自定义可重用方面完成 | 通过 Spring-AOP 的自定义可重用方面完成 | 开箱即用的日志记录、缓存和 JDBC 连接池 | 如果使用 spring-cloud-stream，则开箱即用 | 通过自定义 MeterBinder bean 完成 | 开箱即用        | 开箱即用    | 提供部分支持。需要自定义路线仪表。 |

#### 检测 REST 服务的控制器

检测 REST 控制器的最快、最简单的方法是使用 `@Timed` 注解标记在控制器或控制器的各个方法上。 `@Timed` 注解自动添加 `exception`、`method`、 `outcome`、`status`和 `uri` 标签到定时器。`@Timed` 注解也可以添加额外的标签。

#### 检测微服务的不同架构层

微服务通常具有`控制器层（Controller）`、`服务层（Service）`、`数据访问层（DAO）`和`集成层（Integration）`。添加了 `@Timed` 注解的控制器层通常不需要任何额外的检测，而对于服务层、数据访问层和集成层，开发人员通常会使用`@Service` 或者 `@Component` 注解创建自定义的 bean。与延迟、吞吐量和异常相关的指标可以为系统分析提供重要的信息。这些可以很容易地使用 Micrometer 的 `Timer` 和 `Counter` 来收集。但是，需要对代码进行检测才能应用这些指标。这时就需要使用 `spring-aop` 创建检测服务和组件的复用类，以便于在所有的微服务中使用。使用 `@Around` 和`@AfterThrowing` 注解则可以无需向服务/组件的类和方法添加任何代码生成建议指标。以下是参考指南：

- 创建可复用的注解以应用于不同类型的组件/服务。例如 `@MonitoredService`、`@MonitoredDAO` 和`@MonitoredIntegrationComponent` 这样的自定义注解，分别添加到服务，数据访问对象，和集成组件上。

- 定义多个切点来为不同类型的组件应用建议，并且这些组件包含上述注解。

- 将适当的标签应用于指标，以便可以对指标进行深入分析或切片。例如，可以使用 `componentClass`、`componentType`、`methodName` 和 `exceptionClass` 标签。使用这些自定标签和公共标签，指标将按如下方式产出：

  ```
   component_invocation_timer_count{env="local", instanceId="1", appName="samplemicrosvc", componentClass="SampleService", componentType="service", methodName="getUserInformation"} 26.0
  ```

查看以下示例注释：

```java
@Target({ElementType.TYPE})
@Retention(RetentionPolicy.RUNTIME)
public @interface MonitoredService {
}
```

下面的示例代码展示了一个简单的可复用的切面，用于检测服务类

```java
@Configuration
@EnableAspectJAutoProxy
@Aspect
public class MonitoringAOPConfig {

    @Autowired
    MeterRegistry registry;

    @Pointcut("@target(com.ibm.dip.microsvcengineering.framework.monitoring.MonitoredService) && within(com.ibm.dip..*)")
    public void servicePointcut() {
    }

    @Around("servicePointcut()")
    public Object serviceResponseTimeAdvice(ProceedingJoinPoint pjp) throws Throwable {
        return monitorResponseTime(pjp, TAG_VALUE_SERVICE_TYPE);
    }

    @AfterThrowing(pointcut = "servicePointcut()", throwing = "ex")
    public void serviceExceptionMonitoringAdvice(JoinPoint joinPoint, Exception ex)
    {
        monitorException(joinPoint, ex, TAG_VALUE_SERVICE_TYPE);
    }

    private Object monitorResponseTime(ProceedingJoinPoint pjp, String type) throws Throwable {
        long start = System.currentTimeMillis();
        Object obj = pjp.proceed();
        pjp.getStaticPart();
        long end = System.currentTimeMillis();
        String serviceClass = getClassName(pjp.getThis().getClass().getName());
        String methodName = pjp.getSignature().getName();

        Timer timer = registry.timer(METER_COMPONENT_TIMER,
                TAG_COMPONENTCLASS, serviceClass, TAG_METHODNAME, methodName, TAG_OUTCOME, SUCCESS, TAG_TYPE, type);
        timer.record((end - start), TimeUnit.MILLISECONDS);

        Counter successCounter = registry.counter(METER_COMPONENT_COUNTER,
                TAG_COMPONENTCLASS, serviceClass, TAG_METHODNAME, methodName, TAG_OUTCOME, SUCCESS, TAG_TYPE, type);
        successCounter.increment();
        return obj;
    }

    private void monitorException(JoinPoint joinPoint, Exception ex, String type)
    {
        String serviceClass = getClassName(joinPoint.getThis().getClass().getName());
        String methodName = joinPoint.getSignature().getName();
        Counter failureCounter = registry.counter(METER_COMPONENT_EXCEPTION_COUNTER, TAG_EXCEPTIONCLASS,
                ex.getClass().getName(), TAG_COMPONENTCLASS, serviceClass, TAG_METHODNAME, methodName, TAG_OUTCOME, ERROR,
                TAG_TYPE, type);
        failureCounter.increment();
    }
}
```

这会将微服务中的所有检测逻辑抽象为一组可复用的切面和注解。微服务开发人员只需在类上添加相应的注解即可。

该注解的使用实例如下，通过在 SampleService 类上标注该注解，这个类中的所有方法都会被自动作为 `serviceResponseTimeAdvice` 和 `serviceExceptionMonitoringAdvice` 的备选者。

```java
@Service
@MonitoredService
public class SampleService {
   ...
}
```

#### 检测出站 HTTP/REST 调用

出站 HTTP/REST 调用的检测由 `spring-actuator` 执行。但是，要使其正常工作，`RestTemplate` 应该从一个名为`RestTemplateBuilder` 的 bean 中获得。此外，如果提供了自定义类型的 `RestTemplateExchangeTagsProvider` bean，则可以将自定义标签添加到指标中。

以下配置类说明了这一点：

```java
    @Bean
    public RestTemplate restTemplate(RestTemplateBuilder templateBuilder)
    {
        templateBuilder = templateBuilder.messageConverters(new MappingJackson2HttpMessageConverter())
                .requestFactory(this::getClientHttpRequestFactory);
        return templateBuilder.build();
    }

    @Bean
    public RestTemplateExchangeTagsProvider restTemplateExchangeTagsProvider()
    {
        return new RestTemplateExchangeTagsProvider() {
            @Override
            public Iterable<Tag> getTags(String urlTemplate, HttpRequest request, ClientHttpResponse response) {
                Tag uriTag = (StringUtils.hasText(urlTemplate) ? RestTemplateExchangeTags.uri(urlTemplate)
                        : RestTemplateExchangeTags.uri(request));
                return Arrays.asList(RestTemplateExchangeTags.method(request), uriTag,
                        RestTemplateExchangeTags.status(response), RestTemplateExchangeTags.clientName(request),
                        Tag.of("componentClass", "httpClient"),
                        Tag.of("componentType", "integration"),
                        Tag.of("methodName", uriTag.getValue()));
            }
        };
    }
```

#### 检测 Kafka 消费者

Kafka Consumers 默认由 Actuator 检测。Actuator 和 Micrometer 收集了 30 多个与 Kafka Consumers 相关的指标。通用标签也适用于 Kafka 消费者。一些显著的指标包括 `kafka_consumer_records_consumed_total_records_total`、`kafka_consumer_bytes_consumed_total_bytes_total` 和 `kafka_consumer_records_lag_avg_records`。然后，可以按 Kafka-Topics、Kafka-partitions 等维度对它们进行分组。

#### 检测 Kafka 生产者

默认情况下，Actuator 不检测 Kafka 生产者。Kafka Producer 有自己的 Metrics 实现。要使用 Micrometer 注册这些指标，需要为每一个 `KafkaProducer<?,?>` 定义一个 `MeterBinder` 类型的 bean。这个 `MeterBinder`通过 `Micrometer Registry` 完成`量规（Gauges）`的创建与注册。使用这种方法，可以收集 50 多个 Kafka Producer 指标。通用标签和附加标签（在构建仪表期间）将为这些指标提供多个维度。

以下代码显示了一个常见的 MeterBinder 实现是什么样的：

```java
public class KafkaProducerMonitor implements MeterBinder {

    //Filter out metrics that don't produce a double
    private Set<String> filterOutMetrics;
    //Need to store the reference of the metric - else it might get garbage collected. KafkaMetric is a custom implementation that holds reference to the MetricName and KafkaProducer
    private Set<KafkaMetric> bindedMetrics;
    private KafkaProducer<?,?> kafkaProducer;
    private Iterable<Tag> tags;

    public KafkaProducerMonitor(KafkaProducer kafkaProducer, MeterRegistry registry, Iterable<Tag> tags)
    {
       ...
    }

    @Override
    public void bindTo(MeterRegistry registry) {
        Map<MetricName, ? extends Metric> metrics = kafkaProducer.metrics();
        if (MapUtils.isNotEmpty(metrics))
        {
            metrics.keySet().stream().filter(metricName -> !filterOutMetrics.contains(metricName.name()))
                    .forEach(metricName -> {
                        logger.debug("Registering Kafka Producer Metric: {}", metricName);
                        KafkaMetric metric = new KafkaMetric(metricName, kafkaProducer);
                        bindedMetrics.add(metric);
                        Gauge.builder("kafka-producer-" + metricName.name(), metric, KafkaMetric::getMetricValue)
                                .tags(tags)
                                .register(registry);
                    });
        }
    }
}
```

**注意：** _还有其他第三方组件会生成指标但未与 Micrometer 集成。在这种情况下，可以利用上述模式；一个例子是`Apache Ignite`。_

#### 集成 Camel

如果需要集成 Apache Camel ，则需要在应用程序中对 `Routes` 进行集成和处理。在路由级别获取指标也是有意义的。Camel 通过其 [`camel-micrometer`组件](https://camel.apache.org/components/latest/micrometer-component.html)为 Micrometer 提供端点。在应用程序的 pom 中添加 `camel-micrometer` 依赖项使 Micrometer 端点能够启动或停止计时器和递增计数器。这些可用于收集路由级别的指标。其他特定于 Camel 的 bean，例如 `org.apache.camel.Processor`那些 type 的，可以使用前面描述的 AOP 方法检测。

要启用 micrometer 服务，请添加 `camel-micrometer` 依赖项，如下所示：

```xml
<dependency>
    <groupId>org.apache.camel</groupId>
    <artifactId>camel-micrometer</artifactId>
</dependency>
```

要发布路由的指标，`RouteBuilder` 应向 Micrometer 发送消息，代码如下：

```java
@Override
public void configure() throws Exception {
     from(inputEndpoints).
       routeId(routeId).
       to("micrometer:timer:route_timer" + "?" + "action=start" + "&" + "routeName=<routeId>").
       to("micrometer:counter:route_counter" + "?" + "routeName=<routeId>")
       ... //other route components
       ... //and finally
       to("micrometer:timer:route_timer" + "?" + "action=stop" + "&" + "routeName=<routeId>");

}
```

#### 仪器摘要

如你所见，可以使用以下方法收集大量指标并将其推送到 Prometheus：

- Actuator 提供的开箱即用指标。
- 通过使用 AOP 和 `MeterBinder`。所有这些自定义检测代码都是可复用的，并且可以封装为一个库，供所有微服务实现使用。

这两种方法都提供了一种一致且侵入性最小的方式来收集跨多个微服务及其多个实例的指标。

## Prometheus 与其他第三方系统的集成

Prometheus 有一个健康的发展生态系统。有多个库和服务器可用于将第三方系统的指标导出到 Prometheus，这些库和服务器在 [Prometheus Exporters](https://prometheus.io/docs/instrumenting/exporters/) 进行了编排。例如，`mongodb_exporter` 可用于将 MongoDB 指标导出到 Prometheus。

`Apache Kafka` 使其指标可用于 JMX，它们可以导出到 Prometheus，下个章节将会介绍。

### 将 Kafka 与 Prometheus 集成

如果您使用 Kafka 作为消息/事件代理，那么 Kafka 指标与 Prometheus 的集成并不是开箱即用的，需要使用到 [`jmx_exporter`](https://github.com/prometheus/jmx_exporter) 这个组件。同时还需要在 Kafka 的 Brokers 上进行配置，然后 Brokers 将通过 HTTP 提供指标。`jmx_exporter` 需要配置文件 (`.yml`)。示例代码库的 `examples` 文件夹中提供了示例配置 `jmx_exporter`。

在本教程中，我们构建自定义 Kafka 映像仅用于演示目的。`jmx_exporter` 代码存储库的 README.md 中提供了构建自定义 Kafka 映像的说明。

## 在 Grafana 中构建仪表盘

一旦指标在 Prometheus Meter Registry 中注册并且 Prometheus 成功启动并运行，它将开始收集指标。这些指标现在可用于在 Grafana 中构建不同的监控仪表盘。不同的端点需要多个仪表板。建议创建以下这些仪表盘：

- **平台概览仪表盘**，提供每个微服务和平台其他软件组件（例如 Kafka）的可用性状态。这种类型的仪表板还可以报告平台级别的聚合指标`请求率`（HTTP 请求率、Kafka 消费请求率等）和`异常数量`.
- **微服务下探仪表盘**，提供微服务实例的详细指标。 在 Grafana 中声明 `variables` 很重要，它们对应于指标中使用的不同标签。例如 `appName`，`env`，`instanceId` 等。
- **中间件监控仪表盘**，提供中间件组件的详细下探视图。这些特定于中间件（例如，Kafka 仪表盘）。在这里，`变量`声明很重要，以便可以在`集群`级别和`实例`级别上观察指标。

### 使用维度进行下探和聚合

在报告指标时，会将标签添加到指标中。这些标签可在 Prometheus 查询中用于聚合或深入了解指标。例如，在平台级别，人们想查看平台中的异常总数。这可以使用以下查询轻松完成：

```
sum(component_invocation_exception_counter_total{env="$env"})
```

结果为：

![Aggregated Error Count](https://developer.ibm.com/developer/default/tutorials/monitor-spring-boot-microservices/images/Aggregated-Error-Count.PNG)

现在要在方法和异常类型级别深入研究相同的指标，Prometheus 查询将如下所示：

```
sum by(appName, instanceId, componentClass, methodName, exceptionClass)(component_invocation_exception_counter_total{env="$env", appName="$application", instance="$instance"})
```

细节信息如下：

![Error Details](https://developer.ibm.com/developer/default/tutorials/monitor-spring-boot-microservices/images/Error-Details-Metrics.PNG)

注意 `$` 变量。在仪表盘中该符号可以被定义为变量。 Grafana 将根据 Prometheus 中可用的不同指标填充它们。仪表盘的用户可以选择他们各自的填充值，这可用于动态更改指标可视化，而无需在 Grafana 中创建新的可视化。

作为另一个示例，以下 prometheus 查询可用于可视化特定微服务实例中服务 bean 的吞吐量。

```
rate(component_invocation_timer_seconds_count{instance="$instance", appName="$application", componentType="service"}[1m])",
```

### 仪表盘示例

以下仪表盘在平台级别可视化指标：

![Sample MicroServices Platform Overview Dashboard](https://developer.ibm.com/developer/default/tutorials/monitor-spring-boot-microservices/images/Sample-MicroServices-Platform-Overview-Dashboard.PNG)

该仪表盘提供：

- 所有 REST 控制器方法的 HTTP 请求率和 Kafka 消费者的消费率

- 所有微服务实例和 Kafka 集群的可用性状态。

  请注意，这里的每个可视化都是特定微服务实例的超链接，它提供导航到该微服务实例下探的详细仪表盘。

- 所有微服务实例失败的 HTTP 请求和服务错误。

- 所有微服务实例的异常细分。

### 微服务下探仪表盘示例

该仪表盘被分成多个部分，在 Grafana 中称为“行”。此仪表盘提供微服务特定实例的所有指标。请注意，它是一个单一的仪表板，具有环境、微服务、instanceId 等的用户输入。通过更改这些用户输入中的值，可以查看平台任何微服务的指标。

**注意：** _有多个屏幕截图，因为有许多指标已被可视化以进行演示。_

##### 不同的指标部分

![Different metrics sections](https://developer.ibm.com/developer/default/tutorials/monitor-spring-boot-microservices/images/Sample-MicroServices-Drilldown-Dashboard-00.PNG)

##### 微服务实例级别指标

![Microservice instance level metrics](https://developer.ibm.com/developer/default/tutorials/monitor-spring-boot-microservices/images/Sample-MicroServices-Drilldown-Dashboard-01.PNG)

##### HTTP 控制器指标

![HTTP controller metrics](https://developer.ibm.com/developer/default/tutorials/monitor-spring-boot-microservices/images/Sample-MicroServices-Drilldown-Dashboard-02.PNG)

##### 服务指标

![Service metrics](https://developer.ibm.com/developer/default/tutorials/monitor-spring-boot-microservices/images/Sample-MicroServices-Drilldown-Dashboard-03.PNG)

##### HTTP 客户端指标

![HTTP client metrics](https://developer.ibm.com/developer/default/tutorials/monitor-spring-boot-microservices/images/Sample-MicroServices-Drilldown-Dashboard-04.PNG)

##### Kafka 生产者指标

![Kafka Producer metrics](https://developer.ibm.com/developer/default/tutorials/monitor-spring-boot-microservices/images/Sample-MicroServices-Drilldown-Dashboard-05.PNG)

##### JDBC 连接池指标

![JDBC connection pool metrics](https://developer.ibm.com/developer/default/tutorials/monitor-spring-boot-microservices/images/Sample-MicroServices-Drilldown-Dashboard-06.PNG)

### Kafka 仪表盘示例

##### Kafka broker 指标

![Kafka Broker metrics](https://developer.ibm.com/developer/default/tutorials/monitor-spring-boot-microservices/images/Sample-Kafka-Monitoring-Dashboard-01.PNG)

##### Kafka 消息统计

![Kafka messaging statistics](https://developer.ibm.com/developer/default/tutorials/monitor-spring-boot-microservices/images/Sample-Kafka-Monitoring-Dashboard-02.PNG)

## 总结

通过 `spring-boot-actuator`、`micrometer` 和 `spring-aop`，监控 Spring Boot 微服务变得轻松简单。利用这些强大的框架，就可以为微服务建立全面的监控能力。

监控的一个重点是跨多个微服务及其多个实例的指标的一致性，即使有数百个微服务，这也会使得监控和故障排除变得容易和直观。

监测的另一个重点是不同的视角（viewpoints）。这可以通过使用指标的维度和速率聚合特性来实现。Prometheus 和 Grafana 等工具开箱即用地支持这一点。开发人员只需要确保产出的指标上有正确的标签（这又可以通过通用的或可复用的切面以及 Spring 配置来轻松实现）。

通过应用此指南，可以对所有微服务进行一致且全面的监控，而将侵入性的胶水代码减到最少。

#### 示例代码

本教程中提供的代码示例可在[GitHub](https://github.com/IBM/microsvcengineering)中找到。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
