> * 原文地址：[Java Service Loader vs. Spring Factories Loader](https://dzone.com/articles/java-service-loader-vs-spring-factories-loader)
> * 原文作者：[Nicolas Frankel](https://dzone.com/users/293758/nfrankel.html)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/java-service-loader-vs-spring-factories-loader.md](https://github.com/xitu/gold-miner/blob/master/TODO1/java-service-loader-vs-spring-factories-loader.md)
> * 译者：[HearFishle](https://github.com/HearFishle)
> * 校对者：[Endone](https://github.com/Endone)

# Java Service Loader vs. Spring Factories Loader
# Java Service Loder 对比 spring Factories Loader
### Java and Spring offer loading capabilities to achieve IoC at the module level. They are pretty similar, with Spring being a little more flexible.
### Java 和 Spring 都提供了方式来实现模块层的 IoC(译者注：Inversion of Control 控制反转)。两者实现的功能很类似，不过 Spring 提供的功能更灵活一些。
Inversion of Control is not only possible at the class level, but at the module level. OSGi has been doing it for a long time. However, there are IoC approaches directly available in Java, as well as in Spring.
IoC 并不仅限于解决模块内类与类之间的依赖耦合问题，其同样适用于模块与模块之间。OSGi 一直致力于这方面的工作。但其实 Java 和 Spring 都提供了对 IoC 的支持。
## Java Service Loader
## Java Service Loader
Java 本身提供了一种很简便的方式来支持 IoC，它通过使用[Service Loader] (https://docs.oracle.com/javase/6/docs/api/java/util/ServiceLoader.html) 来实现，其可以获取到工程类路径内指定接口的实现类。这使我们可以在运行期间获知类路径内包含哪些可用的实现类，从而做到接口定义和多个实现模块（jar包）之间的依赖解耦
This is the path chosen by the logging framework, SLF4J. SLF4J itself is just the API, while different implementations are available (_e.g. Logback, Log4J, etc.). SLF4J clients only interact with the SLF4J API, while the implementation available on the classpath takes care of the nitty-gritty details at runtime.

SLF4J 作为一个日志框架正是使用了这个方法。SLF4J 本身只提供日志操作接口,其他的日志系统基于这些接口进行实现（如 Logback, Log4J等）。用户只需通过调用 SLF4J 的接口来记录日志，而具体的实现则交由工程类路径中可用的实现类来执行。

It’s implemented as a file located in the `META-INF/services` folder of a JAR. The name of the file is the fully qualified name of the interface, while its content is a list of qualified names of available implementations. For example, for an interface `ch.frankel.blog.serviceloader.Foo`, there must be a file named `META-INF/services/ch.frankel.blog.serviceloader.Foo` which content might look like this:

为了使用 Service Loader，首先需要在类所在工程的类路径下面建立 META-INF/services 目录，然后根据接口名在该目录创建一个文件。该文件的文件名必须是接口的完全限定名，其内容是可用实现的限定名列表。例如，对于 ch.frankel.blog.serviceloader.Foo这个接口，文件完整路径为 META-INF/services/ch.frankel.blog.serviceloader.Foo，文件的内容可能是如下这样的：

``` java
ch.frankel.blog.serviceloader.FooImpl1
ch.frankel.blog.serviceloader.FooImpl2
```

Note that the classes listed above must implement the `ch.frankel.blog.serviceloader.Foo` interface.
其中包含的类必须实现 ch.frankel.blog.serviceloader.Foo 接口。。
From a code perspective, it’s very straightforward:
使用Service Loader获取实现类的代码非常简单：
``` java
ServiceLoader<Foo> loader = ServiceLoader.load(Foo.class);
loader.iterator();
```

## Service Loader Spring integration
## Service Loader 的 Spring 实现
Core Spring offers an integration with the above Service Loader via the factory beans. For example, the following code assumes there will be a least of candidate implementations:
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

Obviously, this requires further operations to get the data in the right form (hint: it’s a linked list).
很明显，从调用返回来看，需要进一步操作才能得到正确实现类(注意：serviceListFactoryBean 是一个链表)
## Spring Factories Loader
## Spring Factories Loader
In parallel to the Java Service Loader, Spring offers another Inversion of Control implementation. There’s only a single property file involved, it must be named `spring.factories` and located under `META-INF`. From a code perspective, the file is read through the `SpringFactoriesLoader.loadFactories()`**static** method - yes, for Spring, it’s quite a shock.
除了集成 Java 的 Service Loader 之外，Spring 还提供了另一种 IoC 的实现。其只需要添加一个简单的配置文件，文件名必须为 spring.factories 并且放到 META-INF 下。从代码的角度看，这个文件通过 SpringFactoriesLoader.loadFactories()static method 来读取。Spring 的这个实现确实让你吃惊。
Client code couldn’t get any simpler:
调用的代码非常简单：
``` java
List<Foo> foos = SpringFactoriesLoader.loadFactories(Foo.class, null);
```

Note that the second argument is the _optional_ class loader.
上面第二个可选参数是类加载器
Compared to the Java Service Loader, the differences are two-fold:
相对于 Java Service Loader，主要有两方面的区别：
1.  Whether one file format is better _.i.e._ more readable or more maintainable, than the other is a matter of personal taste.
2.  There’s no requirement in `spring.factories` for the key to be an interface and for the values to implement it. For example, Spring Boot uses this approach to handle auto-configuration beans: the key is an annotation _i.e._`org.springframework.boot.autoconfigure.EnableAutoConfiguration`while values are classes annotated with `@Configuration`. This allows for a much more flexible design, if used wisely.
1. 通过一个文件来配置是否比其他方式更好，更可读，更可维护，这取决于个人喜好。
2. 文件中的配置项的键和值不一定分别是接口和其实现类。例如，Spring Boot 使用这种方法来初始化类实例：配置中键内容为一个注解，如 org.springframework.boot.autoconfigure.EnableAutoConfiguration，而值是则可以是标注了 @Configuration 注解的类。如果灵活使用，可以去完成更多更复杂的设计。
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
