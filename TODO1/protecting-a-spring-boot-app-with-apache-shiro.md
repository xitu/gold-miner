> * 原文地址：[Protecting a Spring Boot App With Apache Shiro](https://dzone.com/articles/protecting-a-spring-boot-app-with-apache-shiro)
> * 原文作者：[Brian Demers](https://dzone.com/users/279365/demers.html)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/protecting-a-spring-boot-app-with-apache-shiro.md.md](https://github.com/xitu/gold-miner/blob/master/TODO1/protecting-a-spring-boot-app-with-apache-shiro.md)
> * 译者：
> * 校对者：

# Protecting a Spring Boot App With Apache Shiro

My favorite thing about Apache Shiro is how easy it makes handling authorization. You can use a role-based access control (RBAC) model of assigning roles to users and then permissions to roles. This makes dealing with the inevitable requirements change simple. Your code does not change, just the permissions associated with the roles. In this post I want to demonstrate just how simple it is, using a Spring Boot application and walking through how I’d handle the following scenario:

Your boss (The Supreme Commander) shows up at your desk and tells you the current volunteer (Stormtrooper) registration application needs have different access roles for the different _types_ of employees.

*   Officers can register new _“volunteers”_
*   Underlings (you and I) only have read access the volunteers
*   Anyone from outside the _organization_ doesn’t have any access to the _“volunteers”_
*   It should go without saying the Supreme Commander has access to everything

## Start With a REST Application

To get started, grab this [Spring Boot example](https://github.com/oktadeveloper/shiro-spring-boot-example). It’ll get you started with a set of REST endpoints which expose CRUD operations to manage a list of Stormtroopers. You’ll be adding authentication and authorization using [Apache Shiro](https://shiro.apache.org/). All of the code is up on [Github](https://github.com/bdemers/shiro-spring-boot-example).

Using the Apache Shiro Spring Boot starter is all you need, just add the dependency to your pom. (where `${shiro.version}` is at least 1.4.0):

```xml
<dependency>
 <groupId>org.apache.shiro</groupId>
 <artifactId>shiro-spring-boot-web-starter</artifactId>
 <version>${shiro.version}</version>
</dependency>
```

Jumping into the code we will start with our `StormtrooperController`, and simply add annotations:

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

In the code block above, you’re using Shiro’s `@RequiresRoles` annotation to describe your use-case. You’ll notice the logical `OR` to allow any of these roles access. This is great, your code is done, it was pretty easy to add, just a single line.

You could stop here but, roles are not that flexible, and if you put them directly in your code you’re now tightly coupled to those names/IDs.

## Stop Using Roles

Imagine your application has been deployed and is working fine, the following week your _boss_ stops by your desk and tells you to to make some changes:

*   Officers need to be able to update troopers
*   He feels that the term ‘admin’ is fine for most superiors, but is not suitable to the Dark Lord

Fine, you say, easy enough, you can just make a few small changes to the method signatures:

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

After another round of testing the deployment and you’re back in action!

Wait, take a step back. Roles are great for simple use cases and making a change like this would work fine, but you know this will be changed again. Instead of changing your code every time the requirements change slightly, let’s decouple the roles and what they represent from your code. Instead, use permissions. Your method signatures will look like this:

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

By using Shiro’s `@RequiresPermissions` annotation, this code would work with the original requirements and the new requirements without modification. The only thing that changes is how you map those permissions to roles, and in turn, to users. This could be done externally from your application in a database, or for this example a simple properties file.

**NOTE:** This example uses static usernames and passwords all stored as clear text, this is fine for a blog post, but seriously, manage your passwords [correctly](https://stormpath.com/blog/password-security-right-way)!

To meet the original requirements, the role-to-permission mapping would look like this:

```ini
role.admin = troopers:*
role.officer = troopers:create,  troopers:read
role.underling = troopers:read
```

For the updated requirements, you would just change the file slightly to add the new ‘emperor’ role, and grant officers the ‘update’ permission:

```ini
role.emperor = *
role.admin = troopers:*
role.officer = troopers:create,troopers:read,troopers:update
role.underling = troopers:read
```

If the permission syntax looks a little funny to you, take a look at [Apache Shiro’s Wildcard Permission](https://shiro.apache.org/permissions.html) documentation for an in depth explanation.

## Apache Shiro and Spring

We’ve already covered the Maven dependencies and the actual REST controller, but our application will also need a `Realm` and error handling.

If you take a look at the `SpringBootApp` class, you will notice a few things that were NOT in the [original example](https://github.com/stormpath/jaxrs-spring-blog-example/blob/master/spring-boot/src/main/java/com/stormpath/example/springboot/SpringBootApp.java).

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

First, you have defined a Shiro `Realm`. A a realm is simply a user-store specific DAO. Shiro supports many different types of Realms out of the box (Active Directory, LDAP, Database, file, etc.).

Next up you have the `ShiroFilterChainDefinition`, which you’ve configured to allow BASIC authentication but NOT required it by using the ‘permissive’ option. This way your annotations configure everything. Instead of using annotations (or in addition to using them) you could define your [permission to URL mappings](https://shiro.apache.org/web.html#default-filters) with Ant-style paths. This example would look something like:
  
```java
chainDefinition.addPathDefinition("/troopers/**", "authcBasic, rest[troopers]");
```

This would map any resource starting with the path `/troopers` to require BASIC authentication, and use the [‘rest’ filter](https://shiro.apache.org/static/current/apidocs/org/apache/shiro/web/filter/authz/HttpMethodPermissionFilter.html) which based on the HTTP request method, appends a CRUD action to the permission string. For example an HTTP `GET` would map to ‘read’ so the full permission string for a ‘GET’ request would be `troopers:read`(just like you did with your annotations).

## Exception Handling

The last bit of code you have handles exceptions.

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

The first two handle Shiro exceptions and simply set the status to 401 or 403. A 401 for invalid or missing user/passwords, and a 403 for any valid logged in user that does NOT have access to the resource. Lastly, you’ll want to handle any `NotFoundException` with a 404 and return a JSON serialized `ErrorMessage` object.

## Fire it Up!

If you put all of this together, or you just grab the code from [GitHub](https://github.com/oktadeveloper/shiro-spring-boot-example), you can start the application using `mvn spring-boot:run`. Once you have everything running you can start making requests!

```bash
$ curl http://localhost:8080/troopers
HTTP/1.1 401
Content-Length: 0
Date: Thu, 26 Jan 2017 21:12:41 GMT
WWW-Authenticate: BASIC realm="application"
```

Don’t forget, you need to authenticate!

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

A `404` looks like this:

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

## Learn More About Apache Shiro

This example has shown how easy it is to integrate Apache Shiro into a Spring Boot application, how using permissions allow for greater flexibility over roles, and all it takes is a single Annotation in your controller.

At Stormpath we were happy to be able to commit our support to Apache Shiro, and we’ve carried that commitment forward to Okta. Look forward to more Shiro content from our team, including tutorials on using Shiro with Okta and OAuth plus how to add an AngularJS frontend to this _volunteer_ application. Stay tuned, the Empire needs YOU!

If you have questions on this example you can send them to [Apache Shiro’s user list](http://shiro.apache.org/mailing-lists.html), me on [Twitter](https://twitter.com/briandemers), or just leave them in the comments section below!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
