> * 原文地址：[Java Service Loader vs. Spring Factories Loader](https://dzone.com/articles/java-service-loader-vs-spring-factories-loader)
> * 原文作者：[Nicolas Frankel](https://dzone.com/users/293758/nfrankel.html)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/java-service-loader-vs-spring-factories-loader.md](https://github.com/xitu/gold-miner/blob/master/TODO1/java-service-loader-vs-spring-factories-loader.md)
> * 译者：HearFishle
> * 校对者：

# Java Service Loader vs. Spring Factories Loader
# Java Service 加载器 和 spring Factories 加载器的比较
### Java and Spring offer loading capabilities to achieve IoC at the module level. They are pretty similar, with Spring being a little more flexible.
### Java 和 spring 都提供了加载功能去实现 module 层的 IoC(译者注：Inversion of Control控制反转) 。 它两很像，不过 Spring 可能会更复杂一点。
Inversion of Control is not only possible at the class level, but at the module level. OSGi has been doing it for a long time. However, there are IoC approaches directly available in Java, as well as in Spring.
控制反转可能不止在 class 层发生，也有可能在 module 层发生。 OSGI为此长期工作。不过，在 Java 和 spring 上都有直接可用的 IoC 方法。
## Java Service Loader
## Java Service 加载器
Out-of-the-box, the Java API offers a specific form of Inversion of Control. It’s implemented by the [Service Loader](https://docs.oracle.com/javase/6/docs/api/java/util/ServiceLoader.html) class. It is designed to locate implementation classes of an interface on the classpath. This way allows to discover which available implementations of an interface are available on the classpath _at runtime_, and thus paves the way for modules designed around a clean separation between an API module — _i.e._ JAR, and multiple implementation modules.
Java API 提供了一种开箱即用的控制反转的特殊形式。它由 [Service 加载器] (https://docs.oracle.com/javase/6/docs/api/java/util/ServiceLoader.html) 实现，而设计它的目的是在类路径上定位接口的实现类。这使我们可以在运行期间发现类路径上的哪些可用实现接口是正在使用的，并且因此为那些被设计出来去分离 API module — _i.e._ JAR 和多个实现 module 的 module 做好准备。
This is the path chosen by the logging framework, SLF4J. SLF4J itself is just the API, while different implementations are available (_e.g. Logback, Log4J, etc.). SLF4J clients only interact with the SLF4J API, while the implementation available on the classpath takes care of the nitty-gritty details at runtime.

这个路径是由日志平台 SLF4J 选择的。SLF4J 本身只是一个 API,用其他的如（如 Logback, Log4J, 等等.）也能做到。SLF4J 客户端仅仅和 SLF4J 交互，而类路径上可用的实现在运行期间负责处理细节。
It’s implemented as a file located in the `META-INF/services` folder of a JAR. The name of the file is the fully qualified name of the interface, while its content is a list of qualified names of available implementations. For example, for an interface `ch.frankel.blog.serviceloader.Foo`, there must be a file named `META-INF/services/ch.frankel.blog.serviceloader.Foo` which content might look like this:

它实现后作为一个文件保存在某个 jar 包的 `META-INF/services` 文件夹里。文件名是接口的完全限定名，内容是可用实现的限定名列表。例如，对于 `ch.frankel.blog.serviceloader.Foo`这个接口，名字叫 `META-INF/services/ch.frankel.blog.serviceloader.Foo` 的文件的内容可能是如下这样的：

``` java
ch.frankel.blog.serviceloader.FooImpl1
ch.frankel.blog.serviceloader.FooImpl2
```

Note that the classes listed above must implement the `ch.frankel.blog.serviceloader.Foo` interface.
注意到列出来的类必须实现 `ch.frankel.blog.serviceloader.Foo` 接口。
From a code perspective, it’s very straightforward:
代码很简单：
``` java
ServiceLoader<Foo> loader = ServiceLoader.load(Foo.class);
loader.iterator();
```

## Service Loader Spring integration
## Service 加载器的 Spring 实现
Core Spring offers an integration with the above Service Loader via the factory beans. For example, the following code assumes there will be a least of candidate implementations:
Core Spring 通过 factory beans 提供上述 Service 加载器。例如，下面的代码提供了众多实现方法中的一种：
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
很明显，需要进一步操作才会得到正确形式的数据(注意:是一个链表)
## Spring Factories Loader
## Spring Factories 加载器
In parallel to the Java Service Loader, Spring offers another Inversion of Control implementation. There’s only a single property file involved, it must be named `spring.factories` and located under `META-INF`. From a code perspective, the file is read through the `SpringFactoriesLoader.loadFactories()`**static** method - yes, for Spring, it’s quite a shock.
类似于 Java Service 加载器，Spring 提供了另一种控制反转，只涉及一个简单的属性文件。它必须被命名为 `spring.factories` 并且放到 `META-INF` 下。从代码的角度，这个文件通过 `SpringFactoriesLoader.loadFactories()`**static** method 来被读取。是的，Spring 就是让你吃惊。
Client code couldn’t get any simpler:
客户端的代码如此省事：
``` java
List<Foo> foos = SpringFactoriesLoader.loadFactories(Foo.class, null);
```

Note that the second argument is the _optional_ class loader.
上面第二个参数是 _optional_ 类加载器
Compared to the Java Service Loader, the differences are two-fold:
对比 Java Service Loader ，有两点不同：
1.  Whether one file format is better _.i.e._ more readable or more maintainable, than the other is a matter of personal taste.
2.  There’s no requirement in `spring.factories` for the key to be an interface and for the values to implement it. For example, Spring Boot uses this approach to handle auto-configuration beans: the key is an annotation _i.e._`org.springframework.boot.autoconfigure.EnableAutoConfiguration`while values are classes annotated with `@Configuration`. This allows for a much more flexible design, if used wisely.
1. 一个文件是否比其他的更好， _.i.e._ 更可读，更可维护，这取决于个人看法。
2. `spring.factories`没有需求去把键做成接口并去实现它的值。例如， Spring Boot 使用这种方法去处理自动装配 beans：键是_i.e._ `org.springframework.boot.autoconfigure.EnableAutoConfiguration` 的注释， 而值是用 `@Configuration` 注释的类。如果灵活使用，可以去完成更多更复杂的设计。
Sources for this article can be found on [GitHub](https://github.com/nfrankel/serviceloader) in Maven format.
这篇文章的资源可以在 [GitHub](https://github.com/nfrankel/serviceloader) 的Maven 格式下找到。
**To go further:**
** 延伸阅读 :**
*   [Java Service Loader](https://docs.oracle.com/javase/tutorial/ext/basics/spi.html)
*   [Java Service Loader Spring integration Javadoc](http://docs.spring.io/spring/docs/current/javadoc-api/org/springframework/beans/factory/serviceloader/package-summary.html)
*   [Spring Factories Loader Javadoc](http://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/core/io/support/SpringFactoriesLoader.html)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
