> * 原文地址：[Get started with the Java EE 8 Security API Part 1: Java enterprise security for cloud and microservices platforms](https://www.ibm.com/developerworks/java/library/j-javaee8-security-api-1/index.html)
> * 原文作者：[Alex Theedom](https://developer.ibm.com/author/alex.theedom)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/j-javaee8-security-api-1.md](https://github.com/xitu/gold-miner/blob/master/TODO1/j-javaee8-security-api-1.md)
> * 译者：
> * 校对者：

# 从 Java EE 8 Security API 开始 —— 第一部分

## 面向云和微服务平台的 Java 企业级安全

新的 HttpAuthenticationMechanism、IdentityStore 和 SecurityContext 接口概述

关于这个系列：

期待已久的 [Java EE Security API (JSR 375)](https://jcp.org/en/jsr/detail?id=375) 将 Java 企业级安全带入云计算和微服务时代的新纪元。本系列的文章将向您展示如何简化新的安全机制，以及 Java EE 跨容器安全的标准化处理，然后在启用云的项目中使用它们。

经验丰富的 Java™ 开发者应该了解，Java 并不会受到缺乏 Java 安全机制的影响。选项包括 [Java 容器授权协议说明](https://jcp.org/aboutJava/communityprocess/mrel/jsr115/index3.html) （JACC），[Java 身份认证服务提供器](https://jcp.org/aboutJava/communityprocess/mrel/jsr196/index2.html) （JASPIC），以及大量第三方特定容器的 API 安全和配置管理解决方案。

问题不在于缺乏选择，而在于缺乏企业标准。没有标准，导致几乎没有任何可以激励供应商始终如一地实现核心特性的动力，比如，身份验证、独有解决方案的新技术更新。比如，上下文和依赖注入（CDI）以及表达式语言（EL），或者与云和微服务架构的安全发展保持同步。

本系列介绍了 Java EE 新的安全性 API，首先会概述 API 及其三个主要接口：`HttpAuthenticationMechanism`、`IdentityStore` 和 `SecurityContext`。

[获取代码](https://github.com/readlearncode/Java-EE-8-Sampler/tree/master/security-1-0)

## Java EE 新的安全标准

Java EE 安全规范的开发得力于 2014 [Java EE 8 问卷调查](https://blogs.oracle.com/theaquarium/java-ee-8-survey-final-results)，社区的反馈推动了 Java EE 安全规范的开发步伐。简化和标准化 Java 企业级安全是许多调查对象优先考虑的事项。一旦成立，JSR 375专家组将确定以下问题：

*   构成 Java EE 的各种 EJB 和 servlet 容器定义了类似的与安全相关的 API，但语法存在细微差别。例如，servlet 检查用户角色时，调用是 `HttpServletRequest.isUserInRole(String role)`，而 EJB 则调用 `EJBContext.isCallerInRole(String roleName)`。
*   实现像 JACC 这样的现有安全机制，困难重重，而 JASPIC 也很难被正确使用。
*   现有机制无法充分利用现代 Java EE 的编程特性，例如上下文和依赖注入（CDI）。
*   没有可移值性方法来控制如何在后端跨容器时，进行身份验证。
*   对于管理标识存储或者角色和权限的配置，没有标准的支持。
*   部署自定义身份验证规则，没有标准支持。

这些是 JSR 375 旨在解决的主要问题。同时，该规范通过定义用于身份验证、身份存储、角色和权限以及跨容器授权的可移值性 API，促使开发者能够自行管理和控制安全性。

Java EE Security API 的优点在于它提供了一种配置身份存储和身份验证机制的替代方法，但并不能取代现有的安全机制。Java EE Security API 授权开发人员以一致的和可移值的方式启用 Java EE web 应用程序的安全性 —— 无论是否具有特定于供应商的或者独有的解决方案。

## Java EE Security API 有什么？

Java EE Security API 1.0 版本包含了初始提交草案的一个子集，而且侧重于本地云应用程序相关的技术。这些特性是：

*   用于身份验证的 API
*   身份存储 API
*   上下文安全的 API

这些特性与所有 Java EE 安全实现的新的标准化术语结合在一起。剩余的特性（计划包含在下一个版本中）是：

*   密码别名 API
*   角色/权限分配 API
*   授权拦截器 API

## web 安全认证

Java EE 平台已经指定了两种用于验证 Web 应用程序用户的机制:[Servlet 4.0](https://jcp.org/en/jsr/detail?id=369) (JSR 369) 提供适用于一般应用程序配置的声明式机制。对于健壮性有更高需求，[JASPIC](https://jcp.org/aboutJava/communityprocess/mrel/jsr196/index2.html) 定义了一个叫作 `ServerAuthModule` 的服务提供者接口，它支持开发认证模块来处理任何凭证类型。此外，[Servlet 容器配置文件](https://docs.oracle.com/cd/E19226-01/820-7695/gizel/index.html)指定了如何将 JASPIC 与 servlet 容器集成。

这两种机制都是有意义和有效的，但对于 web 应用程序开发者来说，每种机制都存在其自身的局限性。

servlet 容器机制被限制为只支持 Servlet 4.0 定义的小部分凭据类型，而且它无法支持与调用方的复杂交互。它也无法为应用程序提供一种方法，以确定调用者是根据所需的身份存储进行身份验证的。

相反，JASPIC 非常优秀，而且有很好的延展性，但它的使用也相当复杂。编码 `AuthModule`，并且将其与 web 容器对齐以进行身份验证使用，可能会非常难以处理。除此以外，由于 JASPIC 没有声明式配置，也没有明确的方式来重载编程注册的 `AuthModule`。

Java EE Security API 通过一个新的接口 `HttpAuthenticationMechanism` 解决了其中一些问题。新接口本质上是 JASPIC `ServerAuthModule` 接口的一个简化版 servlet 容器变体，它利用了现有的机制，同时削弱了它们的限制。

`HttpAuthenticationMechanism` 实例是容器负责提供注入的 CDI bean。`HttpAuthenticationMechanism` 接口的其他实现可以由应用程序或或 servlet 容器提供。注意，`HttpAuthenticationMechanism` 仅由 servlet 容器指定。

## 支持 Servlet 4.0 身份验证

Java EE 容器必须为 Servlet 4.0 规范中定义的三种身份认证提供 `HttpAuthenticationMechanism` 实现。这三种实现是：

*   基本 HTTP 身份验证（部分 13.6.1）
*   基于表单的身份验证（部分 13.6.3）
*   自定义表单身份验证（部分 13.6.3.1）

每个实现都由相关注解的存在触发：

*   `@BasicAuthenticationMechanismDefinition`
*   `@FormAuthenticationMechanismDefinition`
*   `@CustomFormAuthenticationMechanismDefinition`

当遇到这些注解之一时，容器会实例化相关机制的实例，并使其立即可用。

在规范中，不再需要像 Servlet 4.0 所要求的那样，在 `web.xml` 中的 `<login-config>` 元素之间指定身份验证机制。事实上，部署过程可能会失败 —— 至少要忽略 `web.xml` 的配置 —— 如果它们存在于基于 HttpAuthentication 机制的注解时。

让我们看看每种机制的示例是如何运行的。

### 基本的 HTTP 身份验证

`@BasicAuthenticationMechanismDefinition` 注解触发 Servlet 4.0 定义的基本 HTTP 身份验证。清单 1 列举了一个示例。只有配置参数是可选的，而且允许指定 realm。

##### 清单 1. 基本的 HTTP 身份验证

```
@BasicAuthenticationMechanismDefinition(realmName="${'user-realm'}")
@WebServlet("/user")
@DeclareRoles({ "admin", "user", "demo" })
@ServletSecurity(@HttpConstraint(rolesAllowed = "user"))
public class UserServlet extends HttpServlet { … }
```

**什么是 realm？**

服务器资源可以划分为单独的受保护控件。在这种情况下，每个用户都将拥有自己的身份验证模式和授权数据库，其中包含受同源策略控制的用户和组。这个用户和组的数据库称为 **realm**。 

### 基于表单的身份验证

`@FormAuthenticationMechanismDefinition` 注解用于基于表单的身份验证。它有一个必要的参数 `loginToContinue`，用于配置 web 应用程序的登录页面、错误页面和重定向或转发特性。在清单 2 中，您可以看到登录页面是用 URL 定义的， `useForwardToLoginExpression` 是使用表达式语言（EL）配置的。不需要向 `@LoginToContinue` 注解传递任何参数，因为实现会提供默认值。

##### 清单 2. 基于表单的身份验证

```
@FormAuthenticationMechanismDefinition(
   loginToContinue = @LoginToContinue(
       loginPage="/login-servlet",
       errorPage="/error",
       useForwardToLoginExpression="${appConfig.forward}"
   )
)
@ApplicationScoped
public class ApplicationConfig { ... }
```

### 自定义表单认证

`@CustomFormAuthenticationMechanismDefinition` 注解触发内置自定义表单身份验证。清单 3 给出了一个示例。

##### 清单 3. 自定义表单认证

```
@CustomFormAuthenticationMechanismDefinition(
   loginToContinue = @LoginToContinue(
       loginPage="/login.do"
   )
)
@WebServlet("/admin")
@DeclareRoles({ "admin", "user", "demo" })
@ServletSecurity(@HttpConstraint(rolesAllowed = "admin"))
public class AdminServlet extends HttpServlet { ... }
```

自定义表单身份验证旨在更好地与 JavaServer Pages (JSF) 和相关的 Java EE 技术保持一致性。`login.do` 页面显示后，用户名和密码由登录页面的后台 bean 输入并处理。

## 标识存储 API

**标识存储**是存储用户标识数据的数据库。如用户名、组成员和用于验证的凭据信息。Java EE Security API 提供了一个名为 `IdentityStore` 的抽象标识存储。类似于 `JAAS LoginModule` 接口，`IdentityStore` 用于与标识存储进行交互，以便对用户进行身份验证并检索组成员身份。

正如规范所描述的，`IdentityStore` 被 `HttpAuthenticationMechanism` 的实现所使用，但这不是一项要求， `IdentityStore` 可以独立存在，供任何其他身份验证机制使用。尽管如此，使用 `IdentityStore` 和 `HttpAuthenticationMechanism` 使应用程序能够以可移值和标准化的方式控制用于身份验证的身份存储，在大部分用例场景中，都推荐使用。

`IdentityStore` API 包括一个 `IdentityStoreHandler` 接口，`HttpAuthenticationMechanism` 必须委托它来验证用户凭据。之后，`IdentityStoreHandler` 调用 `IdentityStore` 实例。`Identity` 存储实现不是直接使用的，而是通过专门的处理程序进行交互的。

`IdentityStoreHandler` 可以针对多个 `IdentityStores` 进行身份验证，并且以 `CredentialValidationResult` 示例的形式返回结果。无论凭据是否有效，该对象只有传递凭据的作用，或者它可以是包含下述任何信息的丰富对象：

*   `[CallerPrincipal](https://javaee.github.io/security-api/apidocs/javax/security/enterprise/CallerPrincipal.html)`
*   主体所属的一组集合
*   调用者的名称或者 LDAP 可分辨的名称
*   标识存储中调用方的唯一标识

标识存储按顺序进行查询，这取决于每个 `IdentityStore` 实现的优先级。存储列表被解析了两次：首先用于身份验证，然后用于授权。

作为开发者，你可以通过实现 `IdentityStore` 接口来实现自己的轻量级标识存储，或者您可以使用为 LDAP 和 RDBMS 内置的 `IdentityStores` 的其中一种。它们是通过将配置细节传递给适当的注解来初始化的 —— `@LdapIdentityStoreDefinition` 或者 `@DataBaseIdentityStoreDefinition`。

### 配置内置的 IdentityStore

最简单的标识存储是**数据库存储**。它是通过 `@DataBaseIdentityStoreDefinition` 注解进行配置的。正如清单 4 所演示的那样，这两个内置的数据存储注解基于 Java EE 7 中已有的 `[@DataStoreDefinition](https://docs.oracle.com/javaee/7/api/javax/annotation/sql/DataSourceDefinition.html)` 注解。

清单 4 演示了如何配置数据库身份存储。这些配置选项本身就进行了自我解释，而且如果您曾经配置过数据库定义，应该会很熟悉。

##### 清单 4. 配置数据库标识存储

```
@DatabaseIdentityStoreDefinition(
   dataSourceLookup = "${'java:global/permissions_db'}",
   callerQuery = "#{'select password from caller where name = ?'}",
   groupsQuery = "select group_name from caller_groups where caller_name = ?",
   hashAlgorithm = PasswordHash.class,
   priority = 10
)
@ApplicationScoped
@Named
public class ApplicationConfig { ... }
```

注意，清单 4 中的优先级要设置为 10.在发现多个标识存储并确定相对于其他存储的迭代顺序时使用。人数越少，优先级越高。

LDAP 的配置如清单 5 所描述的那样，非常简单。如果您有 LDAP 语义配置方面的经验，您会发现这里的选项非常熟悉。

##### 清单 5. 配置 LDAP 标识存储

```
@LdapIdentityStoreDefinition(
   url = "ldap://localhost:33389/",
   callerBaseDn = "ou=caller,dc=jsr375,dc=net",
   groupSearchBase = "ou=group,dc=jsr375,dc=net"
)
@DeclareRoles({ "admin", "user", "demo" })
@WebServlet("/admin")
public class AdminServlet extends HttpServlet { ... }
```

### 自定义 IdentityStore

设计您自己的轻量级标识存储非常简单。您需要实现 `IdentityStore` 接口，至少要实现 `validate()` 方法。接口上有四种方法，它们都有默认的实现方式。`validate()` 方法是运行标识存储所需的最小值。它接受 `Credential` 实例，然后返回 `CredentialValidationResults` 实例。

在清单 6 中，`validate()` 方式接收一个包含要验证的登录凭据的 `UsernamePasswordCredential` 实例。然后返回一个  `CredentialValidationResults` 的实例。如果简单的配置逻辑促使身份验证成功，则使用用户名和用户所属组配置该对象。如果身份验证失败，那么 `CredentialValidationResults` 实例只包含状态标志 `INVALID`。

##### 清单 6. 定制化的轻量级标识存储

```
@ApplicationScoped
public class LiteWeightIdentityStore implements IdentityStore {
   public CredentialValidationResult validate(UsernamePasswordCredential userCredential) {
       if (userCredential.compareTo("admin", "pwd1")) {
           return new CredentialValidationResult("admin", 
		       new HashSet<>(asList("admin", "user", "demo")));
       }
       return INVALID_RESULT;
   }
}
```

注意，实现是基于 `@ApplicationScope` 注解的。这是必需的，因为 `IdentityStoreHandler` 保存对 CDI 容器管理的所有 `IdentityStore` bean 实例的引用。`@ApplicationScope` 注解确保实例是 CDI 管理的 bean，这对整个应用程序来说，都是可用的。

为了使用轻量级标识存储，你可以向自定义 `HttpAuthenticationMechanism` 注入 `IdentityStoreHandler`，就像清单 7 演示的那样。

##### 清单 7. 向自定义 HttpAuthenticationMechanism 注入 LiteWeightIdentityStore

```
@ApplicationScoped
public class LiteAuthenticationMechanism implements HttpAuthenticationMechanism {
   @Inject
   private IdentityStoreHandler idStoreHandler;
   @Override
   public AuthenticationStatus validateRequest(HttpServletRequest req, 
											   HttpServletResponse res, 
											   HttpMessageContext context) {
       CredentialValidationResult result = idStoreHandler.validate(
               new UsernamePasswordCredential(
                       req.getParameter("name"), req.getParameter("password")));
       if (result.getStatus() == VALID) {
           return context.notifyContainerAboutLogin(result);
       } else {
           return context.responseUnauthorized();
       }
   }
}
```

## SecurityContext API

`IdentityStore` 和 `HttpAuthenticationMechanism` 将用户的身份验证和授权完美结合，但是自身的声明式模型尚未成型。**Programmatic security** 使 web 应用程序能执行授权或拒绝访问应用程序资源所需的检查，`SecurityContext` API 提供了这一功能性需求。

目前，Java EE 容器在实现安全上下文对象的方式上并不一致。例如，servlet 容器提供一个 `HttpServletRequest` 实例，在该实例上调用 `getUserPrincipal()` 方法来获取表示用户身份的 `[UserPrincipal](https://docs.oracle.com/javase/8/docs/api/java/nio/file/attribute/UserPrincipal.html)`。EJB 容器提供了不同命名的 `EJBContext` 实例，在该实例上调用同名方法。同时，如果需要测试用户是否属于某个角色，则必须在 `HttpServletRequest` 实例上调用 `isUserRole()` 方法，然后在 EJBContext 实例上调用 `isCallerInRole()`。

**什么是 security context？**  

在 Java 企业级应用程序中，**security context** 提供了对与当前经过身份验证的用户关联的安全相关信息的访问。SecurityContext API 的目标是在所有 servlet 和 EJB 容器中提供对应应用程序安全上下文的访问一致性。

新的 `SecurityContext` 提供了跨 Java EE 容器的一致性机制，用于获取身份验证和授权信息。新的 Java EE  Security 规范要求至少在 servlet 和 EJB 中使用 `SecurityContext`。服务器供应商也可以在其他容器中实现。

### SecurityContext 接口方法

`SecurityContext` 接口提供了用于编程安全性的入口点，并且是可注入类型。它有五种方法（都默认为未实现），以下是方法的列表和用途：

*   **Principal getCallerPrincipal();** 如果当前调用者未进行身份验证，则返回 null，否则返回特定于平台的主体，表明当前用户的名称已通过验证。
*   **<T extends Principal> Set<T> getPrincipalsByType(Class<T> pType);** 从通过身份验证的调用者的主题中，返回给定类型的所有主体；如果未找到 `pType` 类型，或者当前用户未进行身份验证，则返回一个空集。
*   **boolean isCallerInRole(String role);** 确定指定用户中是否包括调用方；如果未授权，则返回 false。
*   **boolean hasAccessToWebResource(String resource, String... methods);** 确定调用方是否可以通过所提供的方法访问给定 web 资源。
*   **AuthenticationStatus authenticate(HttpServletRequest req, HttpServletResponse res, AuthenticationParameters param);**: 通知容器应该启动或与调用方继续以基于 HTTP 身份验证的方式进行会话。因为依赖于 `HttpServletRequest` 和 `HttpServletResponse` 实例，所以此方法仅在 servlet 容器中运行。

我们将快速查看使用这些方法其中之一来检查用户对 web 资源的访问。

## 使用 SecutiytContext：示例

清单 8 演示了如何使用 `hasAccessToWebResource()` 方法测试调用方对指定 HTTP 方法的给定 web 资源的访问。在这种情况下，将 `SecurityContext` 实例注入到 servlet 中，并在 `doGet()` 方法中使用，测试调用方  URI `/secretServlet` 的 servlet 的 `GET` 方法的访问。

##### 清单 8. 调用方的 web 资源访问测试

```
@DeclareRoles({"admin", "user", "demo"})
@WebServlet("/hasAccessServlet")
public class HasAccessServlet extends HttpServlet {
  
   @Inject
   private SecurityContext securityContext;
   @Override
   public void doGet(HttpServletRequest req, HttpServletResponse res) 
			throws ServletException, IOException {
       boolean hasAccess = securityContext.hasAccessToWebResource("/secretServlet", "GET");
       if (hasAccess) {
           req.getRequestDispatcher("/secretServlet").forward(req, res);
       } else {
           req.getRequestDispatcher("/logout").forward(req, res);
       }
   }
}
```

## 第一部分的总结

新的 Java EE Security API 成功地将现有身份验证和授权机制与开发者期望的现代 Java EE 特性和技术的易用性相结合。

尽管这个 API 的初始目标是寻求以一致性和可移值性的方式解决安全性方面的问题，但仍需继续改进。在未来的版本中，JSR 375 专家组打算集成用于密码别名、角色和权限分配以及拦截器授权的 API —— 这些所有特性，最终都会进入规范的 v1.0 中。

同时，专家组也希望集成诸如密码管理与加密等特性，这些特性对于本地云和微服务应用程序中的常见使用至关重要。此外，2016 [Java EE 社区调查](https://blogs.oracle.com/theaquarium/java-ee-8-community-survey-results-and-next-steps)还表明 OAuth2 和 OpenID 被选为 Java EE 8 中包含的第三个重要特性。虽然时间的限制将这些特性排除在 v1.0 中，但是在即将发布的版本中，包含这些特性确实是有着不可忽视的理由和动机。

您已经概述了新的 Java EE Security API 的基本特性和组件，我鼓励您通过下面的快速测试来检测您所学的内容。下一篇文章将深入研究 `HttpAuthenticationMechanism` 接口及其支持的 Servlet 4.0 的三种身份验证机制。

## 测试您的理解

1.  三种默认的 `HttpAuthenticationMechanism` 实现了什么？
    1.  `@BasicFormAuthenticationMechanismDefinition`
    2.  `@FormAuthenticationMechanismDefinition`
    3.  `@LoginFormAuthenticationMechanismDefinition`
    4.  `@CustomFormAuthenticationMechanismDefinition`
    5.  `@BasicAuthenticationMechanismDefinition`
2.  以下哪两个注解将触发内置 LDAP 和 RDBMS 标识存储？
    1.  `@LdapIdentityStore`
    2.  `@DataBaseIdentityStore`
    3.  `@DataBaseIdentityStoreDefinition`
    4.  `@LdapIdentityStoreDefinition`
    5.  `@RdbmsBaseIdentityStoreDefinition`
3.  以下哪种说法是正确的？
    1.  `IdentityStore` 只用于 `HttpAuthenticationMechanism` 的实现。
    2.  `IdentityStore` 可用于任何内置或者定制的安全策略解决方案。
    3.  `IdentityStore` 只能通过注入 `IdentityStoreHandler`的实现才可以访问。
    4.  `IdentityStore` 无法通过 `HttpAuthenticationMechanism` 的实现来使用。
4.  `SecurityContext` 的目标是什么？
    1.  提供跨 servlet 和 EJB 容器对上下文安全访问的一致性。
    2.  只提供针对 EJB 容器上下文安全访问的一致性。
    3.  提供对所有容器上下文安全访问的一致性。
    4.  提供对 Servlet 容器上下文安全访问的一致性。
    5.  提供跨 EJB 容器对上下文安全访问的一致性。
5.  为什么 `HttpAuthenticationMechanism` 实现必须是 `@ApplicationScoped`？
    1.  为了确保它是 CDI 管理的 bean，而且可以供整个应用程序使用。
    2.  为了让 `HttpAuthenticationMechanism` 可以在所有应用程序级别上使用。
    3.  为了让每个用户都有一个 `HttpAuthenticationMechanism` 实例。
    4.  `JsonAdapter`.
    5.  这不是真实的说法。

[检查您的答案](https://www.ibm.com/developerworks/library/j-javaee8-security-api-1/quiz-answers.html)。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
