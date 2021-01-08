> * 原文地址：[Java Service Loader vs. Spring Factories Loader](https://dzone.com/articles/java-service-loader-vs-spring-factories-loader)
> * 原文作者：[Nicolas Frankel](https://dzone.com/users/293758/nfrankel.html)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/java-service-loader-vs-spring-factories-loader.md](https://github.com/xitu/gold-miner/blob/master/TODO1/java-service-loader-vs-spring-factories-loader.md)
> * 译者：[HearFishle](https://github.com/HearFishle)
> * 校对者：[Endone](https://github.com/Endone)，[ziyin feng](https://github.com/Fengziyin1234)

# Java Service Loader 对比 Spring Factories Loader

### Java 和 Spring 都提供了实现模块层的 IoC 的方式（译者注：Inversion of Control 控制反转）。两者实现的功能很类似，不过 Spring 提供的功能更灵活一些。

IoC 并不仅限于解决模块内类与类之间的依赖耦合问题，其同样适用于模块与模块之间。OSGi 一直致力于这方面的工作。但其实 Java 和 Spring 都提供了对 IoC 的支持。

## Java Service Loader

Java 本身提供了一种很简便的方式来支持 IoC，它通过使用 [Service Loader] (https://docs.oracle.com/javase/6/docs/api/java/util/ServiceLoader.html) 来实现，其可以获取到工程类路径内指定接口的实现类。这使我们可以在运行期间获知类路径内包含哪些可用的实现类，从而做到接口定义和多个实现模块（JAR 包）之间的依赖解耦。

SLF4J 作为一个日志框架正是使用了这个方法。SLF4J 本身只提供日志操作接口，其他的日志系统基于这些接口进行实现（如 Logback 和 Log4J 等）。用户只需通过调用 SLF4J 的接口来记录日志，而具体的实现则交由工程类路径中可用的实现类来执行。

为了使用 Service Loader，首先需要在类所在工程的类路径下面建立 'META-INF/services' 目录，然后根据接口名在该目录创建一个文件。该文件的文件名必须是接口的完全限定名，其内容是可用实现的限定名列表。例如，对于 `ch.frankel.blog.serviceloader.Foo` 这个接口，文件名应该是 `META-INF/services/ch.frankel.blog.serviceloader.Foo`，文件的内容可能是如下这样的：

``` java
ch.frankel.blog.serviceloader.FooImpl1
ch.frankel.blog.serviceloader.FooImpl2
```

其中包含的类必须实现 `ch.frankel.blog.serviceloader.Foo` 接口。

使用 Service Loader 获取实现类的代码非常简单：

``` java
ServiceLoader<Foo> loader = ServiceLoader.load(Foo.class);
loader.iterator();
```

## Service Loader 的 Spring 实现

核心的 Spring 库以工厂模式集成了 Java 的 Service Loader。例如，下面的代码假定工程内至少有一个可选的 Foo 接口的实现类：

``` java
@Configuration
public class ServiceConfiguration {
    @Bean
    public ServiceListFactoryBean serviceListFactoryBean() {
        ServiceListFactoryBean serviceListFactoryBean = new ServiceListFactoryBean();
        serviceListFactoryBean.setServiceType(Foo.class);
        return serviceListFactoryBean;
    }
}
Object object = serviceListFactoryBean.getObject();
```

很明显，从调用返回来看，需要进一步操作才能得到正确格式的数据（注意：serviceListFactoryBean 是一个链表）。

## Spring Factories Loader

除了集成 Java 的 Service Loader 之外，Spring 还提供了另一种 IoC 的实现。其只需要添加一个简单的配置文件，文件名必须为 `spring.factories` 并且放到 `META-INF` 下。从代码的角度看，这个文件通过静态方法 `SpringFactoriesLoader.loadFactories()` 来读取。Spring 的这个实现确实让你吃惊。
调用的代码不能再简单了：

``` java
List<Foo> foos = SpringFactoriesLoader.loadFactories(Foo.class, null);
```

上面第二个可选参数是类加载器

相对于 Java Service Loader，主要有两方面的区别：

1. 通过一个文件来配置是否比其他方式更好，更可读，更可维护，这取决于个人喜好。
2. `spring.factories` 中并没有要求键是一个接口并且实现它的值。例如，Spring Boot 使用这种方法来初始化类实例：配置中键内容为一个注解，如 `org.springframework.boot.autoconfigure.EnableAutoConfiguration`，而值是则可以是标注了 `@Configuration` 注解的类。如果灵活使用，可以去完成更多更复杂的设计。

这篇文章的资源可以在 [GitHub](https://github.com/nfrankel/serviceloader) 的 Maven 格式下找到。

**延伸阅读：**

*   [Java Service Loader](https://docs.oracle.com/javase/tutorial/ext/basics/spi.html)
*   [Java Service Loader Spring integration Javadoc](http://docs.spring.io/spring/docs/current/javadoc-api/org/springframework/beans/factory/serviceloader/package-summary.html)
*   [Spring Factories Loader Javadoc](http://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/core/io/support/SpringFactoriesLoader.html)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
