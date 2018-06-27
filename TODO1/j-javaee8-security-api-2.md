> * 原文地址：[Get started with the Java EE 8 Security API Part 2: Web authentication with HttpAuthenticationMechanis](https://www.ibm.com/developerworks/java/library/j-javaee8-security-api-2/index.html)
> * 原文作者：[Alex Theedom](https://developer.ibm.com/author/alex.theedom)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/j-javaee8-security-api-2.md](https://github.com/xitu/gold-miner/blob/master/TODO1/j-javaee8-security-api-2.md)
> * 译者：
> * 校对者：

# 从 Java EE 8 Security API 开始 —— 第二部分

## 基于 HttpAuthenticationMechanism 认证

使用 Java EE 8 新的注解驱动的 HTTP 身份验证机制的经典和自定义 Servlet 身份验证。

关于本系列：

期待已久的 [Java EE Security API (JSR 375)](https://jcp.org/en/jsr/detail?id=375) 将 Java 企业级安全带入云计算和微服务时代的新纪元。本系列的文章将向您展示如何简化新的安全机制，以及 Java EE 跨容器安全的标准化处理，然后在启用云的项目中使用它们。 

[本系列的第一篇文章](https://www.ibm.com/developerworks/library/j-javaee8-security-api-1/index.html)概述了 [Java EE Security API (JSR 375)](https://jcp.org/en/jsr/detail?id=375)，包括对新的高级接口的介绍：`HttpAuthenticationMechanism`、`IdentityStore` 和 `SecurityContext`。本文将深入理解这三部分中的第一部分，您将学习如何在 Java web 示例应用程序中使用 `HttpAuthenticationMechanism` 来设置并配置用户身份验证。

`HttpAuthenticationMechanism` 接口是 Java™ EE HTTP 新的身份验证机制的核心。它拥有三个内置的 CDI（上下文和依赖注入）实现，它们会自动实例化，然后供 CDI 容器调用。这些内置实现支持 Servlet 4.0 指定的三种经典身份验证方案：基本 HTTP 身份验证、基于表单的身份验证和自定义表单身份验证

除了内置的身份验证方法，您还可以使用 `HttpAuthenticationMechanism` 来开发自定义身份验证。如果需要支持指定协议和身份验证令牌，可以选择此选项。一些 servlet 容器还可以提供自定义的 `HttpAuthenticationMechanism` 实现。

本文中，您将亲自体验 `HttpAuthenticationMechanism` 接口及其三个内置实现。我还将向您演示如何编写自定义 `HttpAuthenticationMechanism` 身份验证机制。

[获取代码](https://github.com/readlearncode/Java-EE-8-Sampler/tree/master/security-1-0)

## 安装 Soteria

我们将使用 Java EE 8 Security API 指南来实现 [Soteria](https://github.com/javaee/security-soteria)，通过 `HttpAuthenticationMechanism` 来研究可访问的内置身份验证机制和自定义的身份验证机制。您可以使用两种方法中的一种来获取 Soteria。

### 1. 在您的 POM 中，显式指定 Soteria

在您的 POM 中，使用以下 Maven 坐标来指定 Soteria：

##### 清单 1. Soteria 项目的 Maven 坐标

```
<dependency>
  <groupId>org.glassfish.soteria</groupId>
  <artifactId>javax.security.enterprise</artifactId>
  <version>1.0</version>
</dependency>
```

### 2. 使用内置的 Java EE 8 坐标

符合 Java EE 8 的服务器将拥有自己的新的 Java EE 8 Security API 实现，或者它们依赖于 Sotoria 的实现。无法如何，你都需要 Java EE 8 的坐标。

##### 清单 2. Java EE 8 的 Maven 坐标

```
<dependency>
 <groupId>javax</groupId>
 <artifactId>javaee-api</artifactId>
 <version>8.0</version>
 <scope>provided</scope>
</dependency>
```

## 内置身份验证机制

内置的 HTTP 身份验证机制支持 [Servlet 4.0（第 13.6 章节）](https://javaee.github.io/servlet-spec/downloads/servlet-4.0/servlet-4_0_FINAL.pdf)指定的身份验证方式。下一章节我将向您演示如何使用注解来启用三种身份验证机制，以及如何在 Java web 应用程序中设置和实现每种机制。

### @BasicAuthenticationMechanismDefinition

`@BasicAuthenticationMechanismDefinition` 注解触发 Servlet 4.0（第 13.6.1 章节）定义的 HTTP 基本身份验证。它有一个可选参数 `realmName`，它通过 `WWW-Authenticate` 报头指定发送 realm 的名称。清单 3 演示了如何为名为 `user-realm` 的 realm 触发 HTTP 基本身份验证。

##### 清单 3. HTTP 基本身份验证机制

```
@BasicAuthenticationMechanismDefinition(realmName="user-realm")
@WebServlet("/user")
@DeclareRoles({ "admin", "user", "demo" })
@ServletSecurity(@HttpConstraint(rolesAllowed = "user"))
public class UserServlet extends HttpServlet { … }
```

### @FormAuthenticationMechanismDefinition

`@FormAuthenticationMechanismDefinition` 注解引起 Servlet 4.0 规范定义中（第 13.6.3 章节）基于表单的身份验证。它有一个必须配置的选项。`loginToContinue` 选项接受配置的 `@LoginToContinue` 注解，该注解允许应用程序提供 "login to continue" 的功能。您可以选择使用合理的默认值或为此功能指定四个特性中的一个。

在清单 4 中，登录页面 URI 被指定为 `/login-servlet`。如果身份验证失败，流将传递到 `/login-servlet-fail`。

##### 清单 4. 基于表单的身份验证机制

```
@FormAuthenticationMechanismDefinition(
	loginToContinue = @LoginToContinue(
		   loginPage = "/login-servlet",
		   errorPage = "/login-servlet-fail"
		   )
)
@ApplicationScoped
public class ApplicationConfig { ... }
```

要设置跳转到登录页面的方式，请使用 `useForwardToLogin` 选项。如果需要将此选项设置为“转发”或者“重定向”，则应该显式声明 `true` 或者 `false`，缺省值为 `true`。或者，您可以通过传递给选项 `useForwardToLoginExpression` 的 EL 表达式来设置该值。

`@LoginToContinue` 具有合理的默认值。登录页面被设置为 `/login`，同时错误页面被设置为 `/login-error`。

### @CustomFormAuthenticationMechanismDefinition

`@CustomFormAuthenticationMechanismDefinition` 注解为自定义登录表单提供了配置选项。在清单 5 中，你可以发现网站的登录页面被标识为 `login.do`。登录页面设置为 `@CustomFormAuthenticationMechanismDefinition` 注解的`loginPage` 参数的 `loginToContinue` 参数的值。注意，`loginToContinue` 是唯一的参数，而且是可选的。

##### 清单 5. 自定义表单配置

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

清单 6 演示了 `login.do` 的登录页面，它是一个登录 backing bean 支持的 JSF（JavaServer Pages）页面，如清单 7 所示。

##### 清单 6. login.do JSF 登录页面

```
<form jsf:id="form">
   <p>
       <strong>Username</strong>
       <input jsf:id="username" type="text" jsf:value="#{loginBean.username}" />
   </p>
   <p>
       <strong>Password</strong>
       <input jsf:id="password" type="password" jsf:value="#{loginBean.password}" />
   </p>
   <p>
       <input type="submit" value="Login" jsf:action="#{loginBean.login}" />
   </p>
</form>
```

登录 backing bean 使用 `SecurityContext` 实例来执行身份验证，如清单 7 所示。如果验证成功，将授予用户对资源的访问权；否则，流将传递给错误页面。在本例中，它将用户转发到默认的 URI `/login-error`。

##### 清单 7. 登录 backing bean

```
@Named
@RequestScoped
public class LoginBean {
  
   @Inject
   private SecurityContext securityContext;

   @Inject
   private FacesContext facesContext;

   private String username, password;
  
   public void login() {
      
       Credential credential = new UsernamePasswordCredential(username, new Password(password));
      
       AuthenticationStatus status = securityContext.authenticate(
           getRequestFrom(facesContext),
           getResponseFrom(facesContext),
           withParams().credential(credential));
      
       if (status.equals(SEND_CONTINUE)) {
           facesContext.responseComplete();
       } else if (status.equals(SEND_FAILURE)) {
           addError(facesContext, "Authentication failed");
       }
      
   }
   // 为了简洁而省略一些方法
}
```

## 编写一个自定义 HttpAuthenticationMechanism

在大多数场景中，您会发现这三个内置的实现已经足以满足您的需求。在某些场景中，您可能更喜欢编写自己的 `HttpAuthenticationMechanism` 接口实现。本节中，我将介绍如何编写自定义的 `HttpAuthenticationMechanism` 接口。

为了确保 Java 应用程序可以使用它，您需要将 `HttpAuthenticationMechanism` 接口实现为具有 `@ApplicationScope` 的 CDI bean。接口定义了以下三种方法：

*   `validateRequest()` 身份验证的 HTTP 请求。
*   `secureResponse()` 保护 HTTP 相应消息。
*   `cleanSubject()` 清除提供的主体和凭据的主题。

`HttpServletRequest`、`HttpServletResponse` 和  `HttpMessageContext` 方法都接受相同的参数类型。它们都映射在由容器提供的 [JASPIC Server Auth Module](https://github.com/trajano/server-auth-modules) 接口所定义的对应方法上。当在 `Server Auth` 上调用 JASPIC 方法时，它将委托给您自定义的 `HttpAuthenticationMechanism`。

##### 清单 8. 自定义 HttpAuthenticationMechanism 的实现

```
@ApplicationScoped
public class CustomAuthenticationMechanism implements HttpAuthenticationMechanism {

   @Inject
   private IdentityStoreHandler idStoreHandler;

   @Override
   public AuthenticationStatus validateRequest(HttpServletRequest req, 
   											   HttpServletResponse res, 
											   HttpMessageContext msg) {
       // use idStoreHandler to authenticate and authorize access
       return msg.responseUnauthorized(); // other responses available
   }
}
```

## 在 HTTP 请求期间执行方法

在 HTTP 请求期间，在固定时刻调用 `HttpAuthenticationMechanism` 实现的方法。图 1 描述了在 `Filter` 和 `HttpServlet` 实例上调用每个方法的时间。

##### 图 1. 方法调用顺序

![方法调用顺序](https://www.ibm.com/developerworks/java/library/j-javaee8-security-api-2/MethodCallSequence.png)

在执行 `doFilter()` 或 `service()` 方法之前调用 `validateRequest()` 方法，并在 `HttpServletResponse` 实例上调用 `authenticate()`。此方法的目的是允许调用方进行身份验证。为了进行这个操作，方法应该拥有调用方 `HttpRequest` 和 `HttpResponse` 实例的访问权限。它可以使用这些来获取请求的身份验证信息，也可以为了调用方重定向到 OAuth 提供者而进行写入操作。完成身份验证之后，它可以使用 `HttpMessageContext` 实例来告知身份验证的状态。

在执行 `doFilter()` 或者 `service()` 之后调用 `secureResponse()` 方法。它在 servlet 或 过滤器生成的响应上提供后置处理功能。加密是该方法的潜在功能。

在调用 `HttpServletRequest` 实例上的 `logout()` 方法之后，调用 `cleanSubject()` 方法。此方法还可用于删除注销时间后与用户相关的状态。

`HttpMessageContext` 接口有一个 `HttpAuthenticationMechanism` 实例可以用来与调用它的 `ServerAuthModule` 进行通信的方法。

## 自定义示例：使用 cookie 进行身份验证

正如我之前提及的那样，您通常会编写一个自定义实现来提供内置选项中不可用的功能。一个示例是，在身份验证流中使用 cookie。

在类的级别中，您可以使用可选的 `@RememberMe` 注解来有效地“记住”用户身份验证，并在每个请求中自动应用它。

##### 清单 9. 在自定义的 HttpAuthenticationMechanism 中使用 @RememberMe

```
@RememberMe(
       cookieMaxAgeSeconds = 3600
)
@ApplicationScoped
public class CustomAuthenticationMechanism implements HttpAuthenticationMechanism { … }
```

这个注解有 8 个配置选项，每一个选项都有合理的默认值，因此您不必手动实现它们：

*   **`cookieMaxAgeSeconds`** 设置 “remember me” cookie 的生命周期。
*   **`cookieMaxAgeSecondsExpression`** 是 cookieMaxAgeSeconds的 EL 版本。
*   **`cookieSecureOnly`** 指定只能通过安全方法（HTTPS）访问 cookie。
*   **`cookieSecureOnlyExpression`** 是 cookieSecureOnly 的 EL 版本。
*   **`cookieHttpOnly`** 表示只有 HTTP 请求才能发送 cookie。
*   **`cookieHttpOnlyExpression`** 是 cookieHttpOnly 的 EL 版本。
*   **`cookieName`** 设置 cookie 的名称、
*   **`isRememberMe`** "remember me" 的开关。
*   **`isRememberMeExpression`** 是 isRememberMe 的 EL 版本。

`RememberMe`功能被作为**拦截器绑定**而实现。容器将拦截对 `validateRequest()` 和 `cleanSubject()` 方法的调用。当对包含 `RememberMe` cookie 实现的调用，调用 `validateRequest()`方法时，它将尝试对调用方进行身份验证。如果成功，通知 `HttpMessageConext` 登录事件；否则 cookie 将被移出。拦截 `cleanSubject()` 方法只需删除 cookie 并完成注销请求。

## 第二部分结论

新的 `HttpAuthenticationMechanism` 接口是 Java EE 8 中 web 身份验证的核心。它内置的三种身份验证支持 Servlet 4.0 中指定的经典身份验证方法，而且也很容易为自定义实现进行接口扩展。在本教程中，您学习了如何使用注解来调用和配置  `HttpAuthenticationMechanism` 的内置机制，以及如何为特殊用例编写自定义机制。我鼓励您用下面的小测验来测试您所学到的东西。

这篇文章深入地介绍新的 Java EE 8 Security API 的三个主要组件中的第一个。接下来的两篇文章将介绍 `IdentityStore` 和 `SecurityContext` API 的实践。

## 测试您的掌握程度

1.  三种默认的 `HttpAuthenticationMechanism` 实现是什么？
    1.  `@BasicFormAuthenticationMechanismDefinition`
    2.  `@FormAuthenticationMechanismDefinition`
    3.  `@LoginFormAuthenticationMechanismDefinition`
    4.  `@CustomFormAuthenticationMechanismDefinition`
    5.  `@BasicAuthenticationMechanismDefinition`
2.  一下哪两个注释会引发基于表单的身份验证？
    1.  `@BasicAuthenticationMechanismDefinition`
    2.  `@BasicFormAuthenticationMechanismDefinition`
    3.  `@FormAuthenticationMechanismDefinition`
    4.  `@FormBasedAuthenticationMechanismDefinition`
    5.  `@CustomFormAuthenticationMechanismDefinition`
3.  下列哪两项是基于身份验证的有效配置？
    1.  `@BasicAuthenticationMechanismDefinition(realmName="user-realm")`
    2.  `@BasicAuthenticationMechanismDefinition(userRealm="user-realm")`
    3.  `@BasicAuthenticationMechanismDefinition(loginToContinue = @LoginToContinue)`
    4.  `@BasicAuthenticationMechanismDefinition`
    5.  `@BasicAuthenticationMechanismDefinition(realm="user-realm")`
4.  下列哪三项是基于表单的身份验证的有效配置？
    1.  `@FormAuthenticationMechanismDefinition(loginToContinue = @LoginToContinue)`
    2.  `@FormAuthenticationMechanismDefinition`
    3.  `@FormBasedAuthenticationMechanismDefinition`
    4.  `@FormAuthenticationMechanismDefinition(loginToContinue = @LoginToContinue(useForwardToLoginExpression = "${appConfigs.forward}"))`
    5.  `@FormBasedAuthenticationMechanismDefinition(loginToContinue = @LoginToContinue)`
5.  在 HTTP 请求期间，按照什么顺序，在 `HttpAuthenticationMechanism`、`Filter` 和 `HttpServlet` 实现上调用方法？
    1.  `doFilter()`, `validateRequest()`, `service()`, `secureResponse()`
    2.  `validateRequest()`, `doFilter()`, `secureResponse()`, `service()`
    3.  `validateRequest()`, `service()`, `doFilter()`, `secureResponse()`
    4.  `validateRequest()`, `doFilter()`, `service()`, `secureResponse()`
    5.  `service()`, `secureResponse()`, `doFilter()`, `validateRequest()`
6.  如何为 `RememberMe` cookie 设置最长有效时间？
    1.  `@RememberMe(cookieMaxAge = (units = SECONDS, value = 3600)`
    2.  `@RememberMe(maxAgeSeconds = 3600)`
    3.  `@RememberMe(cookieMaxAgeSeconds = 3600)`
    4.  `@RememberMe(cookieMaxAgeMilliseconds = 3600000)`
    5.  `@RememberMe(cookieMaxAgeSeconds = "3600")`

[检查您的答案](http://www.ibm.com/developerworks/library/j-javaee8-security-api-2/quiz-answers.html)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
