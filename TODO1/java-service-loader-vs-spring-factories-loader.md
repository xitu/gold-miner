> * 原文地址：[Java Service Loader vs. Spring Factories Loader](https://dzone.com/articles/java-service-loader-vs-spring-factories-loader)
> * 原文作者：[Nicolas Frankel](https://dzone.com/users/293758/nfrankel.html)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/.md](https://github.com/xitu/gold-miner/blob/master/TODO1/.md)
> * 译者：
> * 校对者：

# Java Service Loader vs. Spring Factories Loader

### Java and Spring offer loading capabilities to achieve IoC at the module level. They are pretty similar, with Spring being a little more flexible.

Inversion of Control is not only possible at the class level, but at the module level. OSGi has been doing it for a long time. However, there are IoC approaches directly available in Java, as well as in Spring.

## Java Service Loader

Out-of-the-box, the Java API offers a specific form of Inversion of Control. It’s implemented by the [Service Loader](https://docs.oracle.com/javase/6/docs/api/java/util/ServiceLoader.html) class. It is designed to locate implementation classes of an interface on the classpath. This way allows to discover which available implementations of an interface are available on the classpath _at runtime_, and thus paves the way for modules designed around a clean separation between an API module — _i.e._ JAR, and multiple implementation modules.

This is the path chosen by the logging framework, SLF4J. SLF4J itself is just the API, while different implementations are available (_e.g. Logback, Log4J, etc.). SLF4J clients only interact with the SLF4J API, while the implementation available on the classpath takes care of the nitty-gritty details at runtime.

It’s implemented as a file located in the `META-INF/services` folder of a JAR. The name of the file is the fully qualified name of the interface, while its content is a list of qualified names of available implementations. For example, for an interface `ch.frankel.blog.serviceloader.Foo`, there must be a file named `META-INF/services/ch.frankel.blog.serviceloader.Foo` which content might look like this:

``` java
ch.frankel.blog.serviceloader.FooImpl1
ch.frankel.blog.serviceloader.FooImpl2
```

Note that the classes listed above must implement the `ch.frankel.blog.serviceloader.Foo` interface.

From a code perspective, it’s very straightforward:

``` java
ServiceLoader<Foo> loader = ServiceLoader.load(Foo.class);
loader.iterator();
```

## Service Loader Spring integration

Core Spring offers an integration with the above Service Loader via the factory beans. For example, the following code assumes there will be a least of candidate implementations:

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

Obviously, this requires further operations to get the data in the right form (hint: it’s a linked list).

## Spring Factories Loader

In parallel to the Java Service Loader, Spring offers another Inversion of Control implementation. There’s only a single property file involved, it must be named `spring.factories` and located under `META-INF`. From a code perspective, the file is read through the `SpringFactoriesLoader.loadFactories()`**static** method - yes, for Spring, it’s quite a shock.

Client code couldn’t get any simpler:

``` java
List<Foo> foos = SpringFactoriesLoader.loadFactories(Foo.class, null);
```

Note that the second argument is the _optional_ class loader.

Compared to the Java Service Loader, the differences are two-fold:

1.  Whether one file format is better _.i.e._ more readable or more maintainable, than the other is a matter of personal taste.
2.  There’s no requirement in `spring.factories` for the key to be an interface and for the values to implement it. For example, Spring Boot uses this approach to handle auto-configuration beans: the key is an annotation _i.e._`org.springframework.boot.autoconfigure.EnableAutoConfiguration`while values are classes annotated with `@Configuration`. This allows for a much more flexible design, if used wisely.

Sources for this article can be found on [GitHub](https://github.com/nfrankel/serviceloader) in Maven format.

**To go further:**

*   [Java Service Loader](https://docs.oracle.com/javase/tutorial/ext/basics/spi.html)
*   [Java Service Loader Spring integration Javadoc](http://docs.spring.io/spring/docs/current/javadoc-api/org/springframework/beans/factory/serviceloader/package-summary.html)
*   [Spring Factories Loader Javadoc](http://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/core/io/support/SpringFactoriesLoader.html)


> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
