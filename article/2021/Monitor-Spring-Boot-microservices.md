> - 原文地址：[Monitor Spring Boot microservices](https://developer.ibm.com/tutorials/monitor-spring-boot-microservices/?mhsrc=ibmsearch_a&mhq=spring)
> - 原文作者：[Tanmay Ambre](https://developer.ibm.com/tutorials/monitor-spring-boot-microservices/?mhsrc=ibmsearch_a&mhq=spring)
> - 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> - 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/Monitor-Spring-Boot-microservices.md](https://github.com/xitu/gold-miner/blob/master/article/2021/Monitor-Spring-Boot-microservices.md)
> - 译者：[YueYongDev](https://github.com/YueYongDev)
> - 校对者：

# SpringBoot 微服务监控

使用 Micrometer、Prometheus 和 Grafana 为 Spring Boot 微服务构建全面的监控功能

作者：Tanmay Ambre
发布时间：2020 年 3 月 11 日

---

## 介绍

在使用微服务和事件驱动架构（EDA）风格时，监控、日志、追踪和警报等方面的可观察性是一个重要的关注点，主要是因为：

- 大量的部署需要集中且自动化的监控与可观测能力

* 架构的异步性和分布式性质使得多个组件产生的相关指标变得困难

解决这一架构问题可以简化管理，快速解决运行时的问题。它还提供了有助于做出明智的架构、设计、部署和基础设施决策的洞察力，以改善平台的非功能特性。此外，通过工程排放、收集和自定义指标的可视化，可以获得有用的业务/运营洞察力。

Addressing this architectural concern provides simplified management and quick turn-around time for resolving runtime issues. It also provides insights that can help in making informed architectural, design, deployment, and infrastructure decisions to improve non-functional characteristics of the platform. Additionally, useful business/operations insights can be obtained by engineering emission, collection ,and visualization of custom metrics.

然而，它往往是一个被忽视的架构问题。本教程介绍了使用 Micrometer、Prometheus 和 Grafana 等开源工具对 Java 和 Spring Boot 微服务的可观察性进行\*监测的准则和最佳实践。

However, it is often a neglected architectural concern. This tutorial describes guidelines and best practices for the _monitoring_ aspect of observability for Java and Spring Boot microservices using open source tools such as Micrometer, Prometheus, and Grafana.

## 先决条件

在你开始本教程之前，你需要设置以下环境。

Before you begin this tutorial, you need to set up the following environment:

- 利用 Docker Compose 实现的 Docker 环境
- A [Docker](https://www.docker.com/) environment with [Docker Compose](https://docs.docker.com/compose/)
- 一个用于克隆和编辑 git repo 中的代码的 Java IDE
- A Java IDE for cloning and editing the code in the git repo

## 预估时间

完成此教程大约会花费你 2 小时。

## 监控工作简介

监控工具的主要目标是：

- 监控应用程序性能
- 为利益相关者（开发团队、基础设施团队、操作用户、维护团队和业务用户）提供自助服务。Provide self-service to stakeholders (development team, infrastructure team, operational users, maintenance teams, and business users)
- 快速进行问题溯源分析 Assist in performing quick root cause analysis (RCA)
- 建立应用程序的性能基线 Establish the application’s performance baseline
- 如果使用云，提供使用云成本的监测能力，并以综合方式监测不同的云服务 If using cloud, provide the ability to monitor cloud usage costs, and monitor different cloud services in an integrated way

整个监控主要分为以下四类行为。Monitoring is mainly comprised of the following four sets of activities:

- 应用程序的 **_仪器化_** ——对应用程序进行仪器化带来的指标度量对应用程序监控和维护团队以及业务用户十分重要。有许多非侵入性的方法来度量指标，最流行的是 "字节码仪表"、"面向切面的编程 "和 "JMX"。
- Instrumentation\*\*\* of the application(s) – Instrumenting the application to emit the metrics that are of importance to the application monitoring and maintenance teams, as well as for the business users. There are many non-intrusive ways for emitting metrics, the most popular ones being “byte-code instrumentation,” “aspect-oriented programming,” and “JMX.”
- **_指标收集_** —— 从应用程序中收集指标，并将其持久化在一个存储库/数据存储中。然后，存储库提供了一种查询和汇总数据的方法，以实现可视化。一些流行的收集器是 Prometheus、StatsD 和 DataDaog。大多数指标收集工具是时间序列库，并提供高级查询能力。
- **_Metrics collection_** – Collecting metrics from the applications and persisting them in a repository/data-store. The repository then provides a way to query and aggregate data for visualization. Some of the popular collectors are Prometheus, StatsD, and DataDaog. Most of the metrics collection tools are time-series repositories and provide advanced querying capability.
- **_指标可视化_** —— 可视化工具查询指标库，建立视图和仪表盘供最终用户使用。它们提供丰富的用户界面，对指标进行各种操作，如汇总、下钻等。
- **_Metrics visualization_** – Visualization tools query the metrics repository to build views and dashboards for end-user consumption. They provide rich user interface to perform various kinds of operations on the metrics, such as aggregation, drill-down, and so on.
- **_警报和通知_** —— 当指标超过定义的阈值（例如 CPU 超过 80%超过 10 分钟），可能需要人工干预。为此，警报和通知很重要。大多数可视化工具提供警报和通知能力。
- **_Alerts and notifications_** – When metrics breach defined thresholds (for instance CPU is more than 80% for more than 10 minutes), human intervention might be required. For that, alerting and notifications are important. Most visualization tools provide alerting and notification ability.

有许多开放源码和商业产品可用于监测。其中一些著名的商业产品是。AppDynamics, Dynatrace, DataDog, logdna, and sysdig. 开源工具通常被组合使用。一些非常流行的组合是 Prometheus 和 Grafana，Elastic-Logstash-Kibana（ELK），以及 StatsD + Graphite。

There are many open source and commercial products available for monitoring. Some of the notable commercial products are: AppDynamics, Dynatrace, DataDog, logdna, and sysdig. Open-source tools are typically used in combination. Some of the very popular combinations are Prometheus and Grafana, Elastic-Logstash-Kibana (ELK), and StatsD + Graphite.

## 微服务监控指南

我们鼓励在所有微服务中收集统一的指标类型。这有助于提高监控大盘的复用性，并简化指标的汇总和挖掘，以便在不同层面上对其进行可视化。

### 要监控一些什么

微服务将暴露一个 API 和/或消费事件和消息。在处理过程中，它可能会调用自己的业务组件，例如连接到数据库，调用第三方服务（缓存、审核等），调用其他微服务，和/或发布事件和消息。在这些不同的处理阶段监测指标是有益的，因为它有助于提供关于性能和异常情况的汇总分析。这反过来又有助于快速分析问题。

与事件驱动架构(EDA)和微服务相关的常用度量包括：

- **资源利用率指标**

  - 资源利用率——CPU、内存、磁盘利用率、网络利用率等
  - JVM 堆和 GC 指标——GC 开销、GC 时间、堆(及其不同区域)利用率
  - JVM 线程利用率——阻塞的、可运行的、等待的连接使用时间

- **应用程序指标**

  微服务不同架构层的可用性、延迟、吞吐量、状态、异常等，例如:

  - 控制器层——用于 HTTP/REST 方法调用
  - 服务层--用于方法调用
  - 数据访问层--用于方法调用
  - 集成层--用于 RPC 调用、HTTP/REST/API 调用、消息发布、消息消费

- **技术服务利用指标** （具体到对应的技术服务）

  - 缓存 - 缓存的命中率、丢失率、写入率、清理率、读取率
  - 日志 – 每个日志级别的日志事件数
  - 连接池 - 连接池的使用率、连接等待时间、连接创建时间、空闲置连接数

- **中间件指标**
  - 事件中心（Event broker）度量 - 可用性、信息吞吐、字节吞吐、消费滞后、（去）序列化异常、集群状态
  - 数据库指标

对于应用指标，理想情况下，微服务的每个 _架构层_ 的入口和出口点都应该被检测。

### 微服务的关键度量特征

在监控微服务时，以下三个指标的特点尤为重要：

- 维度
- 时间序列/速率汇总
- 计量学观点

#### 维度

维度控制了一个指标的汇总方式，以及一个特定指标的深入程度。它是通过向一个指标添加标签来实现的。标签是一组键值对信息（如 `name-value` ）。标签被用来限定通过对监控系统的查询来获取或聚集指标。由于有大量的部署，它是监测微服务的一个重要特征。换句话说，在一个微服务生态中，多个微服务（甚至一个微服务的不同组件）会具有相同名称的指标。为了区分它们，你需用维度来限定指标。

Dimensions control how a metric is aggregated as well as the extent of drill-down of a particular metric. It is realized by adding tags to a metric. Tags is a `name=value` pair of information. Tags are used to qualify fetching or aggregation of metrics through queries to the monitoring system. It is an important characteristic for monitoring microservices due to large number of deployments. In other words, in an eco-system of microservices, multiple microservices (or even different components of a microservice) would emit metrics with same names. To distinguish between them, you qualify the metrics with dimensions.

例如，对于`http_server_requests_seconds_count`这个指标。如果有一个以上的 API 节点（在微服务生态里这种情况很常见），那么如果没有维度，就只能在平台层面上查看这个指标的汇总值。无法获得该指标在不同 API 节点分布的具体情况。在编辑指标的时候，给指标添加一个`uri`标签，就可以获取这个分布。通常下面的例子来理解该特性。

For instance, consider the metric `http_server_requests_seconds_count`. If there are more than one API endpoints (which is the case in an eco-system of microservices), then without dimensions, one can only view the aggregated values of this metric at the platform level. It won’t be possible to get a distribution across different API endpoints. Adding a `uri` tag to the metric while emitting it would enable fetching this distribution. Take a look at the following example, which explains this characteristic.

If `http_server_requests_seconds_count` is emitted with the following tags:

```
http_server_requests_seconds_count{appName="samplemicrosvc",env="local",exception="None",instanceId="1",method="GET",outcome="SUCCESS",status="200",uri="/addressDetails/{addressId}",} 67.0
http_server_requests_seconds_count{appName="samplemicrosvc",env="local",exception="InternalServerError",instanceId="1",method="GET",outcome="SERVER_ERROR",status="500",uri="/userInfo/{userId}",} 39.0
http_server_requests_seconds_count{appName="samplemicrosvc",env="local",exception="None",instanceId="1",method="GET",outcome="SUCCESS",status="200",uri="/userInfo/{userId}",} 67.0
http_server_requests_seconds_count{appName="samplemicrosvc",env="local",exception="IllegalArgumentException",instanceId="1",method="GET",outcome="SERVER_ERROR",status="500",uri="/addressDetails/{addressId}",} 13.0
http_server_requests_seconds_count{appName="samplemicrosvc",env="local",exception="IllegalStateException",instanceId="1",method="GET",outcome="SERVER_ERROR",status="500",uri="/addressDetails/{addressId}",} 26.0
```

Show more

Then the `http_server_requests_seconds_count` can be aggregated at the `appName` level, at the `instanceId` level, by HTTP response `status`, or by `outcome`, as demonstrated by the following queries:

```
# Count distribution by status for a given environment
sum by (status) (http_server_requests_seconds_count{env="$env"})

# Count distribution by uri and status for a given environment
sum by (uri, status) (http_server_requests_seconds_count{env="$env"})

# Count distribution by uri, status and appName for a given environment
sum by (uri, status, appName) (http_server_requests_seconds_count{env="$env"})
```

Show more

Tags can also be used as query criteria. Note the usage of the `env` tag, where `$env` is a Grafana dashboard’s variable for user input “_environment_.”

#### Time series/Rate aggregation

The ability to aggregate metrics over time is important for identifying patterns in the application’s performance, such as correlating performance with load patterns, building performance profile for a day/week/month, and creating application’s performance baseline.

#### Metrics viewpoints

This is a derived characteristic and provides the ability to group metrics together for ease of visualization and use. For instance:

- A dashboard that depicts the availability status of all microservices of the platform
- A drill-down (detailed) view per microservice to view the detailed metrics of a microservice
- A view cluster level and detailed view of metrics of middleware components, such as Event Broker

## Instrumenting a Spring Boot microservice

This section covers instrumentation of a microservice and its rest controllers, service beans, component beans, and data access objects. This section also covers instrumentation of kafka-consumer, kafka-producer, and camel routes, which are relevant if `kafka`, `spring-cloud-stream`, or `Apache Camel` are used for integration or EDA.

To help with the monitoring and management of a microservice, enable the [Spring Boot Actuator](https://docs.spring.io/spring-boot/docs/current/reference/html/production-ready-features.html#production-ready) by adding `spring-boot-starter-actuator` as a dependency. Multiple HTTP and JMX endpoints to monitor the application are available out of the box, including basic monitoring of a microservice’s health, beans, application information, and environment information.

Dependency addition is as follows:

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-actuator</artifactId>
</dependency>
```

Show more

### Metrics available out of the box with Actuator

Once the Spring Boot Actuator is added to the microservice, the following metrics are enabled out of the box:

- JVM metrics (related to GC and thread utilization)
- Resource utilization metrics (CPU, threads, file descriptors, JVM heap, and garbage collection metrics)
- Kafka consumer metrics
- Logger metrics (Log4j2, Logback)
- Availability metrics (process up-time)
- Cache metrics (out of the box for Caffeine, EhCache2, Hazelcast, or any JSR-107-compliant cache)
- Tomcat metrics
- Spring integration metrics

### Metrics endpoint

Actuator also creates an endpoint for metrics. By default, it is `/actuator/metrics`. It needs to be exposed through Spring configuration. The following is a sample configuration:

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

Show more

### Micrometer

To integrate with Metrics Tool, Spring Boot Actuator provides auto-configuration for [Micrometer](https://micrometer.io/). Micrometer provides a facade for a plethora of monitoring systems, including Prometheus. This tutorial assumes some level of familiarity with [Micrometer concepts](https://micrometer.io/docs/concepts). Micrometer provides three mechanisms to collect metrics:

- Counter – typically used to count occurrences, method executions, exceptions, and so on
- Timer – used for measuring time duration and also occurrences; typically used for measuring latencies
- Gauge – single point in time metric; for instance, number of threads

### Integration with Prometheus

Since Prometheus uses polls to collect metrics, it is relatively simple two-step process to integrate Prometheus and Micrometer.

1. Add the `micrometer-registry-prometheus` registry.
2. Declare a bean of type `MeterRegistryCustomizer<PrometheusMeterRegistry>`.

   This is an optional step. However, it is recommended, as it provides a mechanism to customize the `MeterRegistry`. This is useful for declaring **common tags (dimensions)** for the metrics data that would be collected by Micrometer. This helps in metrics drill-down. It is especially useful when there are a lot of microservices and/or multiple instances of each microservice. Typical common tags could be `applicationName`, `instanceName`, and `environment`. This would allow you to build aggregated visualizations across instances and applications as well as be able to drill down to a particular instance/application/environment.

Once configured, Actuator will expose an endpoint `/actuator/prometheus`, which should be enabled in Spring configuration. A job needs to be added in Prometheus through its configuration to _scrape_ this endpoint at the specified frequency.

#### Add Prometheus dependency to pom

```xml
<dependency>
    <groupId>io.micrometer</groupId>
    <artifactId>micrometer-registry-prometheus</artifactId>
</dependency>
```

Show more

#### Customize the MetricsRegistry

The configuration class that declares the `MetricsRegistryCustomizer` can be written as part of framework so that all MicroServices implementation can reuse it. Tag values can be supplied using system/application properties.

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

Show more

### Instrumentation of application-level metrics

Some application-level metrics are available out of the box and, for some, a variety of techniques can be employed. This following chart summarizes these features:

| Metrics                                                             | Controllers                                   | Service layer components                           | Data access objects                                | Business components                                | Technical components                                           | Kafka Consumers                               | Kafka Producers                       | Spring integration components | HTTP Client    | Camel routes                                                          |
| :------------------------------------------------------------------ | :-------------------------------------------- | :------------------------------------------------- | :------------------------------------------------- | :------------------------------------------------- | :------------------------------------------------------------- | :-------------------------------------------- | :------------------------------------ | :---------------------------- | :------------- | :-------------------------------------------------------------------- |
| **Resource utilization** (CPU, threads, file descriptors, heap, GC) | Out of the box at microservice instance level |                                                    |                                                    |                                                    |                                                                |                                               |                                       |                               |                |                                                                       |
| **Availability**                                                    | Out of the box at microservice instance level |                                                    |                                                    |                                                    |                                                                |                                               |                                       |                               |                |                                                                       |
| **Latency**                                                         | Out of the box with `@Timed` annotation       | Done through custom reusable aspects of Spring-AOP | Done through custom reusable aspects of Spring-AOP | Done through custom reusable aspects of Spring-AOP | Out of the box for logging, caching, and JDBC connection pools | Out of the box if spring-cloud-stream is used | Done through custom MeterBinder beans | Out of the box                | Out of the box | Partial support available. Custom instrumentation of routes required. |
| **Throughput**                                                      | Out of the box with `@Timed` annotation       | Done through custom reusable aspects of Spring-AOP | Done through custom reusable aspects of Spring-AOP | Done through custom reusable aspects of Spring-AOP | Out of the box for logging, caching, and JDBC connection pools | Out of the box if spring-cloud-stream is used | Done through custom MeterBinder beans | Out of the box                | Out of the box | Partial support available. Custom instrumentation of routes required. |
| **Exceptions**                                                      | Out of the box with `@Timed` annotation       | Done through custom reusable aspects of Spring-AOP | Done through custom reusable aspects of Spring-AOP | Done through custom reusable aspects of Spring-AOP | Out of the box for logging, caching, and JDBC connection pools | Out of the box if spring-cloud-stream is used | Done through custom MeterBinder beans | Out of the box                | Out of the box | Partial support available. Custom instrumentation of routes required. |

#### Instrumenting REST Controllers

The quickest and easiest way to instrument REST controllers is to use the `@Timed` annotation on the controller or on individual methods of the controller. `@Timed` automatically adds these tags to the timer: `exception`, `method`, `outcome`, `status`, `uri`. It is also possible to supply additional tags to the `@Timed` annotation.

#### Instrumenting different architectural layers of a microservice

A microservice would typically have _Controller_, _Service_, _DAO_, and _Integration_ layers. Controllers don’t require any additional instrumentation when `@Timed` annotation is applied to them. For Service, DAO, and Integration layers, developers create custom beans annotated with `@Service` or `@Component` annotations. Metrics related to latency, throughput, and exceptions can provide vital insights. These can be easily gathered using Micrometer’s `Timer` and `Counter` metrics. However, the code needs to be instrumented for applying these metrics. A common reusable class that instruments services and components can be created using `spring-aop`, which would be reusable across all microservices. Using `@Around` and `@AfterThrowing` advice metrics can be generated without adding any code to the service/component classes and methods. Consider the following guidelines about developing such an aspect:

- Create reusable annotations to apply to different types of Components/Services. For example, custom annotations, such as `@MonitoredService`, `@MonitoredDAO`, and `@MonitoredIntegrationComponent`, can be applied to services, data access objects, and integration components, respectively.
- Define multiple pointcuts to apply advice for different types of components and which have above-mentioned annotations on them.
- Apply appropriate tags to the metric so that drill-down or slicing of metrics is possible. For instance, tags such as `componentClass`, `componentType`, `methodName`, and `exceptionClass` can be used. With these tags and common-tags, the metric would be emitted as follows:

  ```
   component_invocation_timer_count{env="local", instanceId="1", appName="samplemicrosvc", componentClass="SampleService", componentType="service", methodName="getUserInformation"} 26.0
  ```

  Show more

Take a look at the following sample annotation:

```java
@Target({ElementType.TYPE})
@Retention(RetentionPolicy.RUNTIME)
public @interface MonitoredService {
}
```

Show more

The following code shows a sample reusable aspect that can instrument the Service classes:

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

Show more

This would abstract out all the instrumentation logic from microservices into a set of reusable aspects and annotations. The microservices developer just has to apply the respective annotations on his or her classes.

A sample instrumented Service class will have the following annotations on it. Automatically, all the methods in this Service class will become candidates for applying the `serviceResponseTimeAdvice` and `serviceExceptionMonitoringAdvice`.

```java
@Service
@MonitoredService
public class SampleService {
   ...
}
```

Show more

#### Instrumenting outbound HTTP/REST calls

Instrumentation of outbound HTTP/REST calls is provided out of the box by `spring-actuator`. However, for this to work, `RestTemplate` should be obtained from a bean `RestTemplateBuilder`. Additionally, custom tags can be added to the metrics if a custom bean of type `RestTemplateExchangeTagsProvider` is provided.

The following configuration class illustrates this:

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

Show more

#### Instrumenting Kafka Consumers

Kafka Consumers are instrumented by default by Actuator. More than 30 metrics related to Kafka Consumers are collected by Actuator and Micrometer. The common tags are also applied on the Kafka Consumers. Some of the notable metrics are `kafka_consumer_records_consumed_total_records_total`, `kafka_consumer_bytes_consumed_total_bytes_total`, and `kafka_consumer_records_lag_avg_records`. Then, using dimensions, one can group them by Kafka-Topics, Kafka-partitions, and more.

#### Instrumenting Kafka Producers

Kafka Producers are _NOT_ instrumented by Actuator by default. Kafka Producer has its own implementation of Metrics. To register these metrics with Micrometer, define a bean of type `MeterBinder` for each `KafkaProducer<?,?>`. This `MeterBinder` will create and register `Gauges` with Micrometer `Registry`. With this approach, more than 50 Kafka Producer metrics can be collected. The common tags and additional tags (during building the gauges) would provide multiple dimensions to these metrics.

The following code shows what a typical implementation of MeterBinder would look like:

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

Show more

**Note:** _There are other third-party components that emit metrics but are not integrated with Micrometer. In such cases, the pattern mentioned above can be leveraged; one example being `Apache Ignite`._

#### Camel integration

If Apache Camel is being used for integration, there would be integration and processing `Routes` in the application. It makes sense to have metrics at Route level as well. Camel provides endpoints for Micrometer through its [`camel-micrometer` component](https://camel.apache.org/components/latest/micrometer-component.html). Adding the `camel-micrometer` dependency in the application’s pom enables Micrometer endpoints to start/stop timers and increment counters. These can be used to collect route-level metrics. Other Camel-specific beans, such as those of type `org.apache.camel.Processor`, can be instrumented using the AOP approach previously described.

To enable micrometer endpoints, add `camel-micrometer` dependency as follows:

```xml
<dependency>
    <groupId>org.apache.camel</groupId>
    <artifactId>camel-micrometer</artifactId>
</dependency>
```

Show more

To publish metrics for a route, `RouteBuilder` should send messages to Micrometer, as shown in the following code:

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

Show more

#### Instrumentation summary

As you can see, a large number of metrics can be collected and pushed to Prometheus using:

- Out-of-the-box metrics provided by Actuator.
- Custom metrics through instrumenting the code using AOP and `MeterBinder`. All of this custom instrumentation code is reusable and can be built as a library, which is consumed by all microservices implementations.

Both methods provide a consistent and minimally intrusive way of collecting metrics across multiple microservices and their multiple instances.

## Prometheus integration with other third-party systems

Prometheus has a healthy development ecosystem. There are multiple libraries and servers that are available for exporting metrics of third-party systems to Prometheus, which are catalogued at [Prometheus Exporters](https://prometheus.io/docs/instrumenting/exporters/). For instance, the `mongodb_exporter` can be used to export MongoDB metrics into Prometheus.

`Apache Kafka` makes its metrics available with JMX. They can be exported into Prometheus as described in the following sections.

### Integrating Kafka with Prometheus

If you are using Kafka as your message/event broker, then integration of Kafka metrics with Prometheus is not out of the box. A [`jmx_exporter`](https://github.com/prometheus/jmx_exporter) needs to be used. This needs to be configured on the Kafka Brokers, and then the brokers will start exposing metrics over HTTP. `jmx_exporter` requires a configuration file (`.yml`). A sample configuration is provided in the `examples` folder of the `jmx_exporter` repository.

For this tutorial, we build a custom Kafka image only for the purpose of demonstration. Instructions for building a custom Kafka image with `jmx_exporter` are provided in the code repository’s README.md

## Building Dashboards in Grafana

Once the metrics are registered with Prometheus Meter Registry and Prometheus is up and running, it will start collecting the metrics. These metrics can now be used to build different monitoring dashboards in Grafana. Multiple dashboards are required for different viewpoints. It is a good practice to have these dashboards:

- **Platform overview dashboard**, which provides availability status of each microservice and other software components of the platform (for example, Kafka). This type of dashboard can also report aggregated metrics at the platform level for `request-rates` (HTTP request rates, Kafka consumption request rates, and more), and `exception counts`.
- **Microservices drill-down dashboard**, provides detailed metrics of an instance of a microservice. It is important to declare `variables` in Grafana, which correspond to different tags used in the metrics. For example, `appName`, `env`, `instanceId`, and more.
- **Middleware monitoring dashboard**, which provides a detailed drill-down view of the middleware components. These are specific to the middleware (for example, Kafka dashboard). Here, also, it is important to declare `variables` so that metrics can be observed at `cluster` level as well as at `instance` level.

### Using dimensionality for drill-down and aggregation

While reporting metrics, tags are added to the metrics. These tags can be used in Prometheus queries to aggregate or drill down on the metrics. For instance, at the platform overview level, one would like to view the total number of exceptions in the platform. This can be easily done using the following query:

```
sum(component_invocation_exception_counter_total{env="$env"})
```

Show more

This will show the count as:

![Aggregated Error Count](https://developer.ibm.com/developer/default/tutorials/monitor-spring-boot-microservices/images/Aggregated-Error-Count.PNG)

Now to drill down the same metric at method- and exception-type level, the Prometheus query would be as follows:

```
sum by(appName, instanceId, componentClass, methodName, exceptionClass)(component_invocation_exception_counter_total{env="$env", appName="$application", instance="$instance"})
```

Show more

It would produce the details as:

![Error Details](https://developer.ibm.com/developer/default/tutorials/monitor-spring-boot-microservices/images/Error-Details-Metrics.PNG)

Note the `$` variables. These are defined as variables in the dashboard. Grafana will populate them based on different metrics available in Prometheus. The user of the dashboard can choose their respective values, and that can be used to dynamically change the metric visualization without creating new visualizations in Grafana.

As an another example, consider the below prometheus query for visualizing the throughput of service beans in a particular microservice instance.

```
rate(component_invocation_timer_seconds_count{instance="$instance", appName="$application", componentType="service"}[1m])",
```

Show more

### Sample platform overview dashboard

The following dashboard visualizes metrics at platform level:

![Sample MicroServices Platform Overview Dashboard](https://developer.ibm.com/developer/default/tutorials/monitor-spring-boot-microservices/images/Sample-MicroServices-Platform-Overview-Dashboard.PNG)

It provides:

- HTTP Request Rate and Kafka Consumption Rate for all REST Controller methods and Kafka Consumers
- Availability status of all microservices instances and Kafka cluster.

  Note that each visualization in this is a hyperlink for a particular microservice instance, which provides navigation to the detailed drill-down dashboard of that microservice instance.

- Failed HTTP Requests and Service Errors for all microservices instances.
- A breakdown of exceptions for all microservices instances.

### Sample microservices drill-down dashboard

This dashboard is organized into multiple sections, called “rows” in Grafana. This dashboard provides all the metrics of a particular instance of a microservice. Note that it is a single dashboard having user inputs for environment, microservice, instanceId, and so on. By changing the values in these user inputs, one can view metrics for any microservice of the platform.

**Note:** _There are multiple screenshots, since there are many metrics that have been visualized for demonstration._

##### Different metrics sections

![Different metrics sections](https://developer.ibm.com/developer/default/tutorials/monitor-spring-boot-microservices/images/Sample-MicroServices-Drilldown-Dashboard-00.PNG)

##### Microservice instance level metrics

![Microservice instance level metrics](https://developer.ibm.com/developer/default/tutorials/monitor-spring-boot-microservices/images/Sample-MicroServices-Drilldown-Dashboard-01.PNG)

##### HTTP controller metrics

![HTTP controller metrics](https://developer.ibm.com/developer/default/tutorials/monitor-spring-boot-microservices/images/Sample-MicroServices-Drilldown-Dashboard-02.PNG)

##### Service metrics

![Service metrics](https://developer.ibm.com/developer/default/tutorials/monitor-spring-boot-microservices/images/Sample-MicroServices-Drilldown-Dashboard-03.PNG)

##### HTTP client metrics

![HTTP client metrics](https://developer.ibm.com/developer/default/tutorials/monitor-spring-boot-microservices/images/Sample-MicroServices-Drilldown-Dashboard-04.PNG)

##### Kafka Producer metrics

![Kafka Producer metrics](https://developer.ibm.com/developer/default/tutorials/monitor-spring-boot-microservices/images/Sample-MicroServices-Drilldown-Dashboard-05.PNG)

##### JDBC connection pool metrics

![JDBC connection pool metrics](https://developer.ibm.com/developer/default/tutorials/monitor-spring-boot-microservices/images/Sample-MicroServices-Drilldown-Dashboard-06.PNG)

### Sample Kafka monitoring dashboard

##### Kafka broker metrics

![Kafka Broker metrics](https://developer.ibm.com/developer/default/tutorials/monitor-spring-boot-microservices/images/Sample-Kafka-Monitoring-Dashboard-01.PNG)

##### Kafka messaging statistics

![Kafka messaging statistics](https://developer.ibm.com/developer/default/tutorials/monitor-spring-boot-microservices/images/Sample-Kafka-Monitoring-Dashboard-02.PNG)

## Conclusion

Monitoring of Spring Boot microservices is made easy and simple with `spring-boot-actuator`, `micrometer`, and `spring-aop`. Combining these powerful frameworks provides a way for building comprehensive monitoring capabilities for microservices.

An important aspect of monitoring is consistency of metrics across multiple microservices and their multiple instances, which makes monitoring and trouble-shooting easy and intuitive even when there are hundreds of microservices.

Another important aspect of monitoring is different viewpoints. This can be achieved by using dimensionality and rate aggregation characteristics of metrics. Tools such as Prometheus and Grafana support this out of the box. Developers just need to ensure that the metrics being emitted have the correct set of tags on them (this in turn can be achieved easily through reusable and common aspects, and Spring configuration).

By applying this guidance, it is possible to have consistent and comprehensive monitoring for all microservices with zero to minimal intrusive glue code.

#### Sample code

The code examples provided in this tutorial are available in [GitHub](https://github.com/IBM/microsvcengineering)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
