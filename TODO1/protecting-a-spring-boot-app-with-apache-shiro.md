> * 原文地址：[Protecting a Spring Boot App With Apache Shiro](https://dzone.com/articles/protecting-a-spring-boot-app-with-apache-shiro)
> * 原文作者：[Brian Demers](https://dzone.com/users/279365/demers.html)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/protecting-a-spring-boot-app-with-apache-shiro.md.md](https://github.com/xitu/gold-miner/blob/master/TODO1/protecting-a-spring-boot-app-with-apache-shiro.md)
> * 译者：[lihanxiang](https://github.com/lihanxiang)
> * 校对者：[Mirosalva](https://github.com/Mirosalva)、[HearFishle](https://github.com/HearFishle)

# 用 Apache Shiro 来保护一个 Spring Boot 应用

对于 Apache Shiro，我最欣赏的一点是它能够轻易地处理应用的授权行为。你能够使用基于角色的访问控制模型来对用户进行角色分配，以及对角色进行权限分配。这使得处理一些不可避免的行为变得简单。你不需要改动代码，只需修改角色权限。在这篇文章中，我想展示它的易用性，用一个 Spring Boot 程序来介绍我是如何处理以下场景的：

你的老大（最高指挥官）出现在你的桌旁并告诉你，当前的志愿者（士兵）注册应用需要针对不同的员工类别分配不同的权限。

*   长官能够注册新加入的**志愿者**
*   下属（你我这样的人员）只有阅读志愿者资料的权限
*   **组织**外部的任何人都无法访问**志愿者**的资料
*   毋庸置疑的是，老大拥有所有权限

## 从 REST 应用来开始

首先，来看看这个 [Spring Boot 的例子](https://github.com/oktadeveloper/shiro-spring-boot-example)。它会帮助你从一些进行 CRUD 操作的 REST 接入点来管理一个士兵名单。你将用 [Apache Shiro](https://shiro.apache.org/) 来添加身份验证和角色授权。所有代码已上传至 [Github](https://github.com/bdemers/shiro-spring-boot-example)。

要使用 Apache Shiro, 你所需要做的就是使用 Spring Boot 的 starter，只要在 pom 文件里加入你所需要的依赖（`${shiro.version}` 至少需要在 1.4.0 之上）：

```xml
<dependency>
 <groupId>org.apache.shiro</groupId>
 <artifactId>shiro-spring-boot-web-starter</artifactId>
 <version>${shiro.version}</version>
</dependency>
```

接下来看看代码，从 `StormtrooperController` 开始，只需要添加一些注解：

```java
@RestController
@RequestMapping(path = "/troopers", produces = MediaType.APPLICATION_JSON_UTF8_VALUE)
public class StormtrooperController {

    private final StormtrooperDao trooperDao;

    @Autowired
    public StormtrooperController(StormtrooperDao trooperDao) {
        this.trooperDao = trooperDao;
    }

    @GetMapping()
    @RequiresRoles(logical = Logical.OR, value = {"admin", "officer", "underling"})
    public Collection<Stormtrooper> listTroopers() {
        return trooperDao.listStormtroopers();
    }

    @GetMapping(path = "/{id}")
    @RequiresRoles(logical = Logical.OR, value = {"admin", "officer", "underling"})
    public Stormtrooper getTrooper(@PathVariable("id") String id) throws NotFoundException {
        Stormtrooper stormtrooper = trooperDao.getStormtrooper(id);
        if (stormtrooper == null) {
            throw new NotFoundException(id);
        }
        return stormtrooper;
    }

    @PostMapping()
    @RequiresRoles(logical = Logical.OR, value = {"admin", "officer"})
    public Stormtrooper createTrooper(@RequestBody Stormtrooper trooper) {
        return trooperDao.addStormtrooper(trooper);
    }

    @PostMapping(path = "/{id}")
    @RequiresRoles("admin")
    public Stormtrooper updateTrooper(@PathVariable("id") String id, @RequestBody Stormtrooper updatedTrooper) throws NotFoundException {
        return trooperDao.updateStormtrooper(id, updatedTrooper);
    }

    @DeleteMapping(path = "/{id}")
    @ResponseStatus(value = HttpStatus.NO_CONTENT)
    @RequiresRoles("admin")
    public void deleteTrooper(@PathVariable("id") String id) {
        trooperDao.deleteStormtrooper(id);
    }

}
```

在以上的代码块中，使用 Shiro 的 `@RequiresRoles` 注释来指定角色。你会看到用逻辑符 `OR` 来为任何拥有这种角色的人赋予权限。这很棒，只需要添加一行注解，你的代码就已经完成了。

你的代码可以到此为止，但是，使用角色的方式并不是那么灵活，如果直接在代码中使用，就会导致代码与这些名字的紧密耦合。

## 不再使用角色

想象一下，你的应用已被部署，并且正常工作了，过了一星期，你的**老大**来到桌旁，叫你做一些改动：

*   长官要能够更新士兵的资料
*   他觉得“管理员”这个称呼对于大部分长官来说没问题，但它不适合大魔王

好，你觉得这个并不难，只需要对方法签名做一点小改动：

```java
@GetMapping()
@RequiresRoles(logical = Logical.OR, value = {"emperor", "admin", "emperor", "officer", "underling"})
public Collection<Stormtrooper> listTroopers()

@GetMapping(path = "/{id}")
@RequiresRoles(logical = Logical.OR, value = {"emperor", "admin", "officer", "underling"})
public Stormtrooper getTrooper(@PathVariable("id") String id) throws NotFoundException

@PostMapping()
@RequiresRoles(logical = Logical.OR, value = {"emperor", "admin", "officer"})
public Stormtrooper createTrooper(@RequestBody Stormtrooper trooper)

@PostMapping(path = "/{id}")
@RequiresRoles(logical = Logical.OR, value = {"emperor", "admin", "officer"})
public Stormtrooper updateTrooper(@PathVariable("id") String id, @RequestBody Stormtrooper updatedTrooper) throws NotFoundException

@DeleteMapping(path = "/{id}")
@ResponseStatus(value = HttpStatus.NO_CONTENT)
@RequiresRoles(logical = Logical.OR, value = {"emperor", "admin"})
public void deleteTrooper(@PathVariable("id") String id)
```

在又一轮的测试与部署之后，你的工作完成了！

等等，往回退一步，在简单的用例中，角色能够起到很棒的作用，这种类型的变更也运行良好，然而你知道代码还有下次改动。与其每次都因为一些小需求而修改代码，还不如将角色从代码中分离。替换的方式是改用赋予权限。你的方法签名将会变成这样：

```java
@GetMapping()
@RequiresPermissions("troopers:read")
public Collection<Stormtrooper> listTroopers()

@GetMapping(path = "/{id}")
@RequiresPermissions("troopers:read")
public Stormtrooper getTrooper(@PathVariable("id") String id) throws NotFoundException

@PostMapping()
@RequiresPermissions("troopers:create")
public Stormtrooper createTrooper(@RequestBody Stormtrooper trooper)

@PostMapping(path = "/{id}")
@RequiresPermissions("troopers:update")
public Stormtrooper updateTrooper(@PathVariable("id") String id, @RequestBody Stormtrooper updatedTrooper) throws NotFoundException

@DeleteMapping(path = "/{id}")
@ResponseStatus(value = HttpStatus.NO_CONTENT)
@RequiresPermissions("troopers:delete")
public void deleteTrooper(@PathVariable("id") String id)
```

通过使用 Shiro 的 `@RequiresPermissions` 注解，就能够在不进行代码修改的同时满足原始需求和新需求。唯一要做的就是将权限映射到对应的角色，也就是我们的用户。这件事能够在外部程序中完成，比如数据库，或者像本例中一个简单的配置文件。

**值得注意的是:** 在这个例子中，用户名和密码都是明文存储的，这对于博客的文章来说没什么问题，但是，严格来说，你需要[正确地](https://stormpath.com/blog/password-security-right-way)管理你的密码！

为了实现原来的需求，角色-权限的映射是这样的：

```ini
role.admin = troopers:*
role.officer = troopers:create,  troopers:read
role.underling = troopers:read
```

对于后续的需求，只需要在文件中加入 『emperor』 角色，以及给长官们添加 “update” 权限：

```ini
role.emperor = *
role.admin = troopers:*
role.officer = troopers:create,troopers:read,troopers:update
role.underling = troopers:read
```

如果你觉得这授权语句的语法看上去有点奇怪，可以从 [Apache Shiro 的通配符授权](https://shiro.apache.org/permissions.html) 文档中来获得一些深入的了解。

## Apache Shiro 和 Spring

我们已经介绍了 Maven 依赖和 REST 控制器，但我们的应用还需要一个 `Realm` 和异常处理机制。

如果你看过 `SpringBootApp` 类，你就会注意到有一些不在[样例](https://github.com/stormpath/jaxrs-spring-blog-example/blob/master/spring-boot/src/main/java/com/stormpath/example/springboot/SpringBootApp.java)中的东西。

```java
@Bean
public Realm realm() {

 // uses 'classpath:shiro-users.properties' by default
 PropertiesRealm realm = new PropertiesRealm();

 // Caching isn't needed in this example, but we can still turn it on
 realm.setCachingEnabled(true);

 return realm;

}

@Bean

public ShiroFilterChainDefinition shiroFilterChainDefinition() {

 DefaultShiroFilterChainDefinition chainDefinition = new DefaultShiroFilterChainDefinition();

 // use permissive to NOT require authentication, our controller Annotations will decide that

 chainDefinition.addPathDefinition("/**", "authcBasic[permissive]");

 return chainDefinition;

}

@Bean
public CacheManager cacheManager() {

 // Caching isn't needed in this example, but we will use the MemoryConstrainedCacheManager for this example.

 return new MemoryConstrainedCacheManager();

}
```

首先，你先定义一个 Shiro 的 `Realm`。realm 只是一个特定的存储用户的 DAO，Shiro 支持多种不同类型的 Realm (活动目录、LDAP、数据库和文件等等)。

接下来看看 `ShiroFilterChainDefinition`，你配置了允许基本的身份验证功能，但是并不是通过『permissive』选项来获取这个功能。这样你的注释就可以配置所有内容了。你可以使用 Ant 样式的路径来定义 [URL 映射权限](https://shiro.apache.org/web.html#default-filters)，而不是使用注解（或者使用一些其他的）。这个例子看起来是这样子的：
  
```java
chainDefinition.addPathDefinition("/troopers/**", "authcBasic, rest[troopers]");
```

这样做将所有以 `/troopers` 开头的资源映射到要求基本身份验证，并且使用 [‘rest’ 过滤器](https://shiro.apache.org/static/current/apidocs/org/apache/shiro/web/filter/authz/HttpMethodPermissionFilter.html)，它基于 HTTP 请求方法，且在权限字符串后附加了一个 CRUD 操作。举个例子，一个 HTTP`GET` 方法会映射到 ‘read’，所以对于一个 `GET` 请求的完整权限字符串为`troopers:read`（就像你用注解做的那样）。

## 异常处理

代码中的最后一部分就是异常处理了

```java
@ExceptionHandler(UnauthenticatedException.class)
@ResponseStatus(HttpStatus.UNAUTHORIZED)
public void handleException(UnauthenticatedException e) {

 log.debug("{} was thrown", e.getClass(), e);

}

@ExceptionHandler(AuthorizationException.class)
@ResponseStatus(HttpStatus.FORBIDDEN)
public void handleException(AuthorizationException e) {

 log.debug("{} was thrown", e.getClass(), e);

}

@ExceptionHandler(NotFoundException.class)
@ResponseStatus(HttpStatus.NOT_FOUND)
public @ResponseBody ErrorMessage handleException(NotFoundException e) {

 String id = e.getMessage();

 return new ErrorMessage("Trooper Not Found: "+ id +", why aren't you at your post? "+ id +", do you copy?");

}
```

前两个处理 Shiro 异常的例子，只是简单的将状态码改至 401 或 403。401 针对的是用户名/密码的无效或缺失，403 是因为已登录的用户无权访问受限资源。最后，你将要用 404 来处理 `NotFoundException`，并且返回一个 JSON 序列化的 `ErrorMessage` 对象。

## 火力全开！

如果你把这些组合起来，或者你直接从 [GitHub](https://github.com/oktadeveloper/shiro-spring-boot-example)上把代码搬过来，你就能用 `mvn spring-boot:run` 来启动应用。一旦运行起来，你就能够开始发送请求了！

```bash
$ curl http://localhost:8080/troopers
HTTP/1.1 401
Content-Length: 0
Date: Thu, 26 Jan 2017 21:12:41 GMT
WWW-Authenticate: BASIC realm="application"
```

别忘了，你需要验证你的身份！

```bash
$ curl --user emperor:secret http://localhost:8080/troopers
HTTP/1.1 200
Content-Type: application/json;charset=UTF-8
Date: Thu, 26 Jan 2017 21:14:17 GMT
Transfer-Encoding: chunked

[
 {
 "id": "FN-0128",
 "planetOfOrigin": "Naboo",
 "species": "Twi'lek",
 "type": "Sand"
 },
 {
"id": "FN-1383",
"planetOfOrigin": "Hoth",
"species": "Human",
"type": "Basic"
},
{
"id": "FN-1692",
"planetOfOrigin": "Hoth",
"species": "Nikto",
"type": "Marine"
},

...
```

一个 `404` 是这样的：

```bash
$ curl --user emperor:secret http://localhost:8080/troopers/TK-421
HTTP/1.1 404
Content-Type: application/json;charset=UTF-8
Date: Thu, 26 Jan 2017 21:15:54 GMT
Transfer-Encoding: chunked

{
 "error": "Trooper Not Found: TK-421, why aren't you at your post? TK-421, do you copy?"
}
```

## 了解更多有关 Apache Shiro 的信息

这个例子演示了如何轻松将 Apache Shiro 集成至 Spring Boot 应用，以及如何使用权限来增大角色的灵活性，所有的这些只需要在控制器中加一条注解。

我们很高兴能够为 Apache Shiro 做出贡献，并且将这一贡献转发至 Okta 了。期待我们团队能够推出更多 Shiro 的内容，包括给 Okta 和 OAuth 的 Shiro 使用手册以及如何在此**志愿者**应用程序中添加 AngularJS 前端代码。请继续关注，帝国需要你！

关于这个例子，如果你有任何疑问，请将它们发送至 [Apache Shiro 的用户列表](http://shiro.apache.org/mailing-lists.html)或者是我的 [Twitter](https://twitter.com/briandemers) 账户，也可以直接在下方评论区留言！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
