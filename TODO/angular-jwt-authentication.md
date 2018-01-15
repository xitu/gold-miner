> * 原文地址：[Angular Security - Authentication With JSON Web Tokens (JWT): The Complete Guide](https://blog.angular-university.io/angular-jwt-authentication/)
> * 原文作者：[angular-university](https://blog.angular-university.io)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/angular-jwt-authentication.md](https://github.com/xitu/gold-miner/blob/master/TODO/angular-jwt-authentication.md)
> * 译者：[Raoul1996](https://github.com/Raoul1996)
> * 校对者：

# Angular 安全 —— 使用 JSON 网络令牌（JWT）验证：完全指南
本文是在 Angular 应用程序中设计和实现基于 JWT（JSON Web Tokens）身份验证的分步指南。

我们的目标是系统的讨论**基于 JWT 的认证设计和实现**，衡量取舍不同的设计方案，并将其应用到 Angular 程序特定的上下文中。

我们将追踪一个 JWT 被从认证服务器上创建开始，然后它被返回客户端，然后再回到应用服务器的全程。并且我们将讨论涉及的所有涉及方案以及做出的决策。

由于身份验证同样需要一些服务端代码，所以我们将同时显示这些信息。以便我们可以掌握整个上下文，并且看清楚各个部分之间如何协作。

服务端代码是 Node/Typescript，Angular 开发者会对这些应该是非常熟悉的。但是涵盖的概念并不是特定于 Node 的。

如果你使用另一种服务平台，主需要在 [jwt.io](https://jwt.io) 上为你的平台选择一个 JWT 库，这些概念仍然适用。

### 目录
在这篇文章中，我们将介绍一下主题：

* 第一步 —— 登陆页面
  * 基于 JWT 的身份验证  
  * 用户在 Angular 程序中登录
  * 为什么要使用单独托管的登陆页面？
  * 在我们的单页应用（SPA）中直接登录
* 第二步 —— 创建基于 JWT 的用户会话
  * 使用 [node-jsonwebtoken](https://github.com/auth0/node-jsonwebtoken) 创建 JWT 会话令牌（Session Token）
* 第三步 —— 将 JWT 返回到客户端
  * 在哪里存储 JWT 会话令牌？
  * Cookie 与 Local Storage
* 第四步 —— 在客户端存储使用 JWT  
  * 检查用户到期时间
* 第五步 —— 每次请求携带 JWT 发回到服务器  
  * 如何构建一个身份验证 HTTP 拦截器H
* 第六步 —— 验证用户请求
  * 构建用于 JWT 验证的定制 Express 中间件
  * 使用 [express-jwt](https://github.com/auth0/express-jwt) 配置 JWT 验证中间件
  * 验证 JWT 签名（Signatures）—— RS256
  * RS256 与 HS256
  * JWKS (JSON Web 密钥集) 终节点和密钥旋转
  * 使用 [node-jwks-rsa](https://github.com/auth0/node-jwks-rsa) 实现 JWKS 密钥旋转
* 总结

无需再费周折（without further ado），我们开始学习基于 JWT 的 Angular 的认证吧！

### 基于 JWT 的用户会话
首先介绍如何使用 JSON Web Tokens 来建立用户会话：简而言之，JWT 是数字签名以 URL 友好的字符串格式编码的 JSON 有效载荷（payload）。

JWT 通常可以包含任何有效载荷，但最常见的用例是使用有效载荷定于用户会话。

JWT 的关键在于，我们只需要检查令牌本身就可以确定它们是否有效，而无需为此单独联系服务器，不需要将令牌保存到内存中，也不需要在请求的时候保存到服务器。

如果使用 JWT 身份验证，则它们将至少包含用户 ID 和到期时间戳。

如果你想要深入了解有关 JWT 格式的详细信息（包括最常用的签名类型如何工作），请参阅本文后面的 [JWT: The Complete Guide to JSON Web Tokens](https://blog.angular-university.io/angular-jwt) 一文。

如果想知道 JWT 是什么样子的话，下面是一个例子：

```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIzNTM0NTQzNTQzNTQzNTM0NTMiLCJleHAiOjE1MDQ2OTkyNTZ9.zG-2FvGegujxoLWwIQfNB5IT46D-xC4e8dEDYwi6aRM
```

你可能会想：这看起来不像 JSON！那么 JSON 在哪里？

为了看到他，让我们回到 [jwt.io](https://jwt.io/) 并将完成的 JWT 字符串粘贴到验证工具中，然后我们就能看到 JSON 的有效内容：

```
{
  "sub": "353454354354353453",
  "exp": 1504699256
}
```
查看 [raw01.ts](https://gist.github.com/jhades/2375d4f784938d28eaa41f321f8b70fe#file-01-ts) ❤托管于 [GitHub](https://github.com)

`sub` 属性包含用户标识符，`exp` 包含用户到期时间戳.这种类型的令牌被称为不记名令牌（Bearer Token），意思是它标识拥有它的用户，并定义一个用户会话。

> 不记名令牌是用户名/密码组合的签名临时替换！

如果想进一步了解 JWT，请看看[这里](https://blog.angular-university.io/angular-jwt)。对于本文的其余部分，我们将假定 JWT 是一个包含可验证 JSON 有效载荷的字符串，它定义了一个用户会话。

实现基于 JWT 的身份验证第一步是发布不记名令牌并将其提供给用户，这是登录/注册页面的主要目的。

### 第一步 —— 登陆页面
身份验证以登陆页面开始，该页面可以托管在我们的域中或者第三方域中。在企业场景中，登陆页面一般会托管在单独的服务器上。这是公司范围内单点登录（ Single Sign-On）解决方案的一部分。

在公网（Public Internet）上，登录页面也可能是：

* 由第三方身份验证程序（如 Auth0）托管
* 使用直接在我们的单页应用中可用的登录页面路径或模式。

单独托管的登录页面是一种安全性的改进，因为这样密码永远不会直接由我们的应用程序代码来处理。

单独托管的登录页面可以具有最少量的 JavaScript 甚至完全没有，并且可以将其做到不论看起来还是用起来都像是整体应用程序的一部分的效果。

但是，用户在我们应用程序中通过内置登录页面登录也是一种可性行且常用的解决方案，所以我们也会介绍一下。

### 直接在 SPA 应用程序上的登录页面
如果直接在我们的 SPA 程序中创建登录页面，它将看起来是这样的：

```
@Component({
  selector: 'login',
  template: `
<form [formGroup]="form">
    <fieldset>
        <legend>Login</legend>
        <div class="form-field">
            <label>Email:</label>
            <input name="email" formControlName="email">
        </div>
        <div class="form-field">
            <label>Password:</label>
            <input name="password" formControlName="password" 
                   type="password">
        </div>
    </fieldset>
    <div class="form-buttons">
        <button class="button button-primary" 
                (click)="login()">Login</button>
    </div>
</form>`})
export class LoginComponent {
    form:FormGroup;

    constructor(private fb:FormBuilder, 
                 private authService: AuthService, 
                 private router: Router) {

        this.form = this.fb.group({
            email: ['',Validators.required],
            password: ['',Validators.required]
        });
    }

    login() {
        const val = this.form.value;

        if (val.email && val.password) {
            this.authService.login(val.email, val.password)
                .subscribe(
                    () => {
                        console.log("User is logged in");
                        this.router.navigateByUrl('/');
                    }
                );
        }
    }
}
```
查看 [raw02.ts](https://gist.github.com/jhades/2375d4f784938d28eaa41f321f8b70fe#file-02-ts) ❤托管于 [GitHub](https://github.com)

正如我们所看到的，这个页面是一个简单的表单，包含两个字段：电子邮件和密码。当用户点击登录按钮的时候，用户和密码将通过 `login()` 调用发送到客户端身份验证服务。

### 为什么要创建一个单独的认证服务器
把我们所有的客户端身份验证逻辑放在一个集中的应用程序范围内的单个 `AuthService`（认证服务）将帮助我们保持我们代码的组织。

这样，如果以后我们需要更改安全提供者或者重构我们的安全逻辑，我们只需要改变这个类。

在这个服务里边，我们将使用一些 JavaScript API 来调用第三方服务，或者使用 Angular HTTP Client 进行 HTTP POST 调用。

这两种方案的目标是一致的：通过 POST 请求将用户和密码组合通过网络传送到认证服务器，以便可以验证密码并启动会话。

以下是我们如何使用 Angular HTTP Client 构建自己的 HTTP POST：

```
@Injectable()
export class AuthService {
     
    constructor(private http: HttpClient) {
    }
      
    login(email:string, password:string ) {
        return this.http.post<User>('/api/login', {email, password})
            // this is just the HTTP call, 
            // we still need to handle the reception of the token
            .shareReplay();
    }
}
```
       
查看 [raw03.ts](https://gist.github.com/jhades/2375d4f784938d28eaa41f321f8b70fe#file-03-ts) ❤托管于 [GitHub](https://github.com)

我们调用的 `shareReplay`可以防止这个 Observable 的接收者由于多次订阅而意外触发多个 POST 请求。

在处理登录响应之前，我们先来看看请求的流程，看看服务器上发生了什么。

### 第二步 —— 创建 JWT 会话令牌
无论我们在应用程序级别使用登录页面还是托管登录页面，处理登录 POST 请求的服务器逻辑是相同的。

目标是在这两种情况下都会验证密码并建立一个会话。如果密码是正确的，那么服务器将会发出一个不记名令牌，说：

> 该令牌的持有者的专业 ID 是 353454354354353453, 该会话在接下来的两个小时有效

然后应该对令牌进行签名并发送回用户浏览器！关键部分是 JWT 签名：这是防止攻击者伪造会话令牌的唯一方式。

这是使用 Express 和 Node 包 [node-jsonwebtoken](https://github.com/auth0/node-jsonwebtoken) 创建新的 JWT 会话令牌的代码：

```
import {Request, Response} from "express";
import * as express from 'express';
const bodyParser = require('body-parser');
const cookieParser = require('cookie-parser');
import * as jwt from 'jsonwebtoken';
import * as fs from "fs";

const app: Application = express();

app.use(bodyParser.json());

app.route('/api/login')
    .post(loginRoute);

const RSA_PRIVATE_KEY = fs.readFileSync('./demos/private.key');

export function loginRoute(req: Request, res: Response) {

    const email = req.body.email,
          password = req.body.password;

    if (validateEmailAndPassword()) {
       const userId = findUserIdForEmail(email);

        const jwtBearerToken = jwt.sign({}, RSA_PRIVATE_KEY, {
                algorithm: 'RS256',
                expiresIn: 120,
                subject: userId
            }

          // send the JWT back to the user
          // TODO - multiple options available                              
    }
    else {
        // send status 401 Unauthorized
        res.sendStatus(401); 
    }
}
```
查看 [raw04.ts](https://gist.github.com/jhades/2375d4f784938d28eaa41f321f8b70fe#file-04-ts) ❤托管于 [GitHub](https://github.com)

代码很多，我们逐行分解：

* 我们首先创建一个 Express 应用程序
* 接下来，我们配置 `bodyParser.json()` 中间件，使 Express 能够从 HTTP 请求体中读取 JSON 有效载荷
* 然后，我们定义了一个名为 `loginRoute` 的路由处理程序，如果服务器收到一个 POST 请求，就会触发 `/api/login` URL

在 `loginRoute` 方法中，我们有一些代码展示了如何实现登录路由：

* 由于 `bodyParser.json()` 中间件的存在，我们可以使用 `req.body` 访问 JSON 请求主体有效载荷。
* 我们先从请求主体中检索电子邮件和密码
* 然后我们要验证密码，看看它是否正确
* 如果密码错误，那么我们发回 HTTP 状态码 401 未经授权
* 如果密码正确，我们从检索用户专用标识开始
* 然后我们使用用户 ID 和过期时间戳创建一个普通的 JavaScript 对象，然后将其发送回客户端
* 我们使用  [node-jsonwebtoken](https://github.com/auth0/node-jsonwebtoken) 库对有效载荷进行签名，然后选择 RS256 签名类型（稍后详细介绍）
* `.sign()` 调用 结果是 JWT 字符串本身

总而言之，我们验证了密码并创建一个 JWT 会话令牌。现在我们已经对这个代码的工作原理有了一个很好的了解，让我们来关注使用了 RS256 签名的包含用户会话详细信息的 JWT 签名的关键部分。

为什么签名的类型很重要？因为没有理解它，我们将无法理解我们将需要验证次令牌的应用程序服务端代码。

#### 什么是 RS256 签名?

RS256 是基于 RSA 的 JWT 签名类型，是一种广泛使用的公钥加密技术。

> 使用 RS256 签名的主要优点之一是我们可以将创建令牌的能力与验证他们的能力分开。

如果您想知道如何手动重现它们，可以阅读 [JWT 指南](https://blog.angular-university.io/angular-authentication-jwt/)中使用此类签名的所有优点。

简而言之，RS256 签名的工作方式如下：

* 私钥（如我们的代码中的 `RSA_PRIVATE_KEY`）用于对 JWT 进行签名
* 一个公钥用来验证它们
* 这两个秘钥是不可互换的：它们只能标记 token，或者只能验证它们，但是两个秘钥不能做两件事

### 为什么用 RS256?

为什么使用公钥加密签署 JWT ？ 以下是一些安全和运营优势的例子：

* 我们只需要在认证服务器部署签名私钥，而不是在使用相同认证服务器的多个应用服务器上。
* 我们不必为了同时更改每个地方的共享秘钥而以协同的方式关闭认证服务器和应用服务器。
* 公钥可以在 URL 中公布并且被应用服务器在启动时以及定时自动读取。

最后一部分是一个很好的特性：能够发布验证密钥给我们内置的密钥旋转或者撤销，我们将在这篇文章中实现！

这是因为（使用 RS256）为了启用一个新的密钥对，我们只需要发布一个新的公钥，并且我们会看到这个公钥。

### RS256 vs HS256

另一个常用的签名是 HS256，没有这些优势。

HS256 仍然是常用的，例如 Auth0 等供应商现在默认使用 RS256.如果你想了解有关 HS256，RS256 和 JWT 签名的更多信息，请查看这篇 [文章](https://blog.angular-university.io/angular-authentication-jwt/)

抛开我们使用的签名类型不谈，我们需要将新签名的令牌发送回用户浏览器。

### 第三步 —— 将 JWT 发送回客户端

我们有几种不同的方式将令牌发回给用户，例如：

* 在 Cookie 中
* 在请求正文中
* 在一个普通的 HTTP 头

#### JWT 和 Cookie

让我们从 cookie 开始，为什么不使用呢？JWT 有时候被称为 Cookie 的替代品，但这是两个完全不同的概念。 Cookie 是一种浏览器数据存储机制，可以安全地存储少量数据。

该数据可以使注诸如用户首选语言之类的任何数据。但是其也可以包含诸如 JWT 的用户识别令牌。

因此，我们可以将 JWT 存储在 cookie 中！然后，我们来谈谈使用 Cookie 存储 JWT 与其他方法相比较的优点和缺点。

#### 浏览器如何处理 Cookie

Cookie 的一个独特之处在于，浏览器会自动为每个请求附加到特定于和子域的 cookie 到 HTTP 请求的头部。

This means that if we store the JWT in a cookie, we will not need any further client logic for sending back the cookie to the application server with each request, assuming the login page and the application share the same root domain.

Let's then store our JWT in a cookie, and see what happens. Here is how we would finish the implementation of our login route, by sending the JWT back to the browser in a cookie:

Besides setting a cookie with the JWT value, we also set a couple of security properties that we are going to cover next.

#### Unique security properties of Cookies - HttpOnly and Secure Flags

Another unique aspect of Cookies is that they have some security-related properties that help with ensuring secure data transfer.

A Cookie can be marked as Secure, meaning that the browser will only append the cookie to the request if it's being made over an HTTPS connection.

A Cookie can also be marked as Http Only, meaning that it's not accessible by the Javascript code _at all_! Note that the browser will still append the cookie to each request sent back to the server, just like with any other cookie.

This means for example that in order to delete a HTTP Only cookie, we need to send a request to the server, like for example to logout the user.

#### Advantages of HTTP Only cookies

One advantage of an HTTP Only cookie is that if the application suffers, for example, a script injection attack (or XSS), the Http Only flag would still, in this disastreous scenario, prevent the attacker from getting access to the cookie and use it to impersonate the user.

The two flags Secure and Http Only can and are often used together for maximum security, which might make us think that Cookies are the ideal place for storing a JWT.

But Cookies have some disadvantages too, so let's talk about those: this will help us decide if storing cookies in a JWT is a good approach for our application.

#### Disadvantages of Cookies - XSRF

Applications with Bearer tokens stored in a Cookie suffer from a vulnerability called Cross-Site Request Forgery, also known as XSRF or CSRF. Here is how it works:

* somebody sends you a link and you click on it
* The link ends up sending an HTTP request to the site under attack containing all the cookies linked to the site
* And if you were logged into the site this means the Cookie containing our JWT bearer token will be forwarded too, this is done automatically by the browser
* The server receives a valid JWT, so there is no way for the server to distinguish this attack from a valid request

This means that an attacker could trick a user to do certain actions on its behalf, just by sending an email, or posting a link in a public forum.

This attack is less powerful than it might look but the problem is that it's very easy to perform: all it takes is an email or a post on social media.

We will cover in detail this attack in a future post, right now it's important to realize that if we choose to store our JWT in a cookie then we need to also put in place some defenses against XSRF.

The good news is that all major frameworks come with defenses that can be easily put in place against XSRF, as it's such a well-known vulnerability.

Like it happens many times, there is a design tradeoff going on here with Cookies: using them means leveraging HTTP Only which is a great defense against script injection, but on the other hand, it introduces a new problem - XSRF.

#### Cookies and Third-Party Authentication providers

A potential problem with receiving the session JWT in a cookie is that we would not be able to receive it from a third-party web domain, that handles the authentication logic.

This is because an application running on `app.example.com` cannot access cookies from another domain like `security-provider.com`.

So in that scenario, we would not be able to access the cookie containing the JWT, and send it to our server for validation, making the use of cookies unfeasible.

#### Can we get the best of the two solutions?

Third-party authentication providers might allow us to run the externally hosted login page in a configurable subdomain of our website, such as for example `login.example.com`.

So it would be possible to get the best of all these solutions combined. Here is what the solution would look like:

* an externally hosted login page running on our own subdomain `login.example.com`, and an application running on `example.com`
* that page sets an HTTP Only and Secure Cookie containing the JWT, giving us good protection against many types of XSS attacks that rely on stealing user identity
* Plus we need to add some XSRF defenses, but there are well-understood solutions for that

This would give us maximum protection against both password and identity token theft scenarios:

* the Application never gets the password in the first place
* the Application code never accesses the session JWT, only the browser
* the application is not vulnerable to request forgery (XSRF)

This scenario is sometimes used in enterprise portals and gives great security features. However, this relies on the security provider or enterprise security proxy that we are using to support a custom domain for hosted login pages.

This feature (custom subdomain for hosted login page) is however not always available, and that would render the HTTP Only cookie approach undoable.

If your application falls into that case or if you are looking for alternatives that don't rely on cookies, let's go back to the drawing board and find what else we can do.

### Sending the JWT back in the HTTP response body

Cookies with their unique HTTP Only property are a solid choice for storing JWTs, but there are other good choices available. For example, instead of cookies we are going to send the JWT back to the client in the HTTP Response body.

Not only do we want to send back the JWT itself, but it's better to send also the expiration timestamp as a separate property.

It's true that the expiration timestamp is also available inside the JWT, but we want to make it simple for the client to obtain the session duration without having to install a JWT library just for that.

Here is how we can send the JWT back to the client in the HTTP response body:

And with this, the client will receive both the JWT and its expiration timestamp.

#### Design compromises of not using Cookies for JWT storage

Not using cookies has the advantage that our application is no longer vulnerable to XSRF, which is one advantage of this approach.

But this also means that we will have to add some client code to handle the token, because the browser will no longer forward it to the application server with each request.

This also means that the JWT token is now readable by an attacker in case of a successful script injection attack, while with the HTTP Only cookie that was not possible.

This is a good example of the design compromises that are often associated with choosing a security solution: there is usually a security vs convenience trade-off going on.

Let's then continue following the journey of our JWT Bearer Token. Since we are sending the JWT back to the client in the request body, we will need to read it and handle it.

### Step 4 - Storing and using the JWT on the client side

Once we receive the JWT on the client, we need to store it somewhere, otherwise, it will be lost if we refresh the browser and would have to log in again.

There are many places where we could save the JWT (other than cookies). A practical place to store the JWT is on Local Storage, which is a key/value store for string values that is ideal for storing a small amount of data.

Note that Local Storage has a synchronous API. Let's have a look at an implementation of the login/logout logic using Local Storage:

Let's break down what is going on in this implementation, starting with the login method:

* We are receiving the result of the login call, containing the JWT and the `expiresIn` property, and we are passing it directly to the `setSession` method
* inside `setSession`, we are storing the JWT directly in Local Storage in the `id_token` key entry
* We are taking the current instant and the `expiresIn`property, and using it to calculate the expiration timestamp
* Then we are saving also the expiration timestamp as a numeric value in the `expires_at` Local Storage entry

### Using Session Information on the client side

Now that we have all session information on the client side, we can use this information in the rest of the client application.

For example, the client application needs to know if the user is logged in or logged out, in order to decide if certain UI elements such as the Login / Logout menu buttons should be displayed or not.

This information is now available via the methods `isLoggedIn()`, `isLoggedOut()` and `getExpiration()`.

### Sending The JWT to the server on each request

Now that we have the JWT saved in the user browser, let's keep tracking its journey through the network.

Let's see how we are going to use it to tell the Application server that a given HTTP request belongs to a given user, which is the whole point of the Authentication solution.

Here is what we need to do: we need with each HTTP request sent to the Application server, to somehow also append the JWT!

The application server is then going to validate the request and link it to a user, simply by inspecting the JWT, checking its signature and reading the user identifier from the payload.

To ensure that every request includes a JWT, we are going to use an Angular HTTP Interceptor.

### How to build an Authentication HTTP Interceptor

Here is the code for an Angular Interceptor, that includes the JWT with each request sent to the application server:

Let's then break down how this code works line by line:

* we first start by retrieving the JWT string from Local Storage directly
* notice that we did not inject here the `AuthService`, as that would lead to a circular dependency error
* then we are going to check if the JWT is present
* if the JWT is not present, then the request goes through to the server unmodified
* if the JWT is present, then we will clone the HTTP headers, and add an extra `Authorization` header, which will contain the JWT

And with this in place, the JWT that was initially created on the Authentication server, is now being sent with each request to the Application server.

Let's then see how will the Application server use the JWT to identify the user.

### Validating a JWT on the server side

In order to authenticate the request, we are going to have to extract the JWT from the `Authorization` header, and check the timestamp and the user identifier.

We don't want to apply this logic to all our backend routes because certain routes are publicly accessible to all users. For example, if we built our own login and signup routes, then those routes should be accessible by any user.

Also, we don't want to repeat the Authentication logic on a per route basis, so the best solution is to create an Express Authentication middleware and only apply it to certain routes.

Let's say that we have defined an express middleware called `checkIfAuthenticated`, this is a reusable function that contains the Authentication logic in only one place.

Here is how we can apply it to only certain routes:

In this example, `readAllLessons` is an Express route that serves a JSON list of lessons if a GET request hits the `/api/lessons` Url.

We have made this route accessible only to authenticated users, by applying the `checkIfAuthenticated` middleware before the REST endpoint, meaning that the order of middleware functions is important.

The `checkIfAuthenticated` middleware will either report an error if no valid JWT is present, or allow the request to continue through the middleware chain.

The middleware needs to throw an error also in the case that a JWT is present, correctly signed but expired. Note that all this logic is the same in any application that uses JWT-based Authentication.

We could write this middleware ourselves using [node-jsonwebtoken](https://github.com/auth0/node-jsonwebtoken), but this logic is easy to get wrong so let's instead use a third-party library.

### Configuring a JWT validation middleware using express-jwt

In order to create the `checkIfAuthenticated` middleware, we are going to be using the [express-jwt](https://github.com/auth0/express-jwt) library.

This library allows us to quickly create middleware functions for commonly used JWT-based authentication setups, so let's see how we would use it to validate JWTs like the ones that we created in the login service (signed using RS256).

Let's start by assuming that we had first installed the public signature validation key in the file system of the server. Here is how we could use it to validate JWTs:

Let's now break down this code line by line:

* we started by reading the public key from the file system, which will be used to validate JWTs
* this key can only be used to validate existing JWTs, and not to create and sign new ones
* we passed the public key to `express-jwt`, and we got back a ready to use middleware function!

This middleware will throw an error if a correctly signed JWT is not present in the `Authorization` header. The middleware will also throw an error if the JWT is correctly signed, but it has already expired.

If we would like to change the default error handling behavior, and instead of throwing an error, for example, return a status code 401 and a JSON payload with a message, that is [also possible](https://github.com/auth0/express-jwt#error-handling).

But one of the main advantages of using RS256 signatures is that we don't have to install the public key locally in the application server, like we did in this example.

Imagine that the server had several running instances: replacing the public key everywhere at the same time would be problematic.

#### Leveraging RS256 Signatures

Instead of installing the public key on the Application server, it's much better to have the Authentication server _publish_ the JWT-validating public key in a publicly accessible Url.

This give us a lot of benefits, such as for example simplified key rotation and revocation. If we need a new key pair, we just have to publish a new public key.

Typically during periodic key rotation, we will have the two keys published and active for a period of time larger than the session duration, in order not to interrupt user experience, while a revocation might be effective much faster.

There is no danger that the attacker could leverage the public key. The only thing that an attacker can do with the public key is to validate signatures of existing JWTs, which is of no use for the attacker.

There is no way that the attacker could use the public key to forge newly create JWTs, or somehow use the public key to guess the value of the private signing key.

The question now is, how to publish the public key?

### JWKS (JSON Web Key Set) endpoints and key rotation

JWKS or [JSON Web Key Set](https://auth0.com/docs/jwks) is a JSON-based standard for publishing public keys in a REST endpoint.

The output of this type of endpoint is a bit scary, but the good news is that we won't have to consume directly this format, as this will be consumed transparently by a library:

A couple of details about this format: `kid` stands for Key Identifier, and the `x5c` property is the public key itself (its the x509 certificate chain).

Again, we won't have to write code to consume this format, but we do need to have an overview of what is going on in this REST endpoint: its simply publishing a public key.

### Implementing JWKS key rotation using the `node-jwks-rsa` library

Since the public key format is standardized, what we need is a way of reading the key, and pass it to `express-jwt` so that it can be used instead of the public key that was read from the file system.

And that is exactly what the [node-jwks-rsa](https://github.com/auth0/node-jwks-rsa) library will allow us to do! Let's have a look at this library in action:

This library will read the public key via the URL specified in property `jwksUri`, and use it to validate JWT signatures. All we have to do is configure the URL and if needed a couple of extra parameters.

#### Configuration options for consuming the JWKS endpoint

The parameter `cache` set to true is recommended, in order to prevent having to retrieve the public key each time. By default, a key will be kept for 10 hours before checking back if its still valid, and a maximum of 5 keys are cached at the same time.

The `rateLimit` property is also enabled, to make sure the library will not make more then 10 requests per minute to the server containing the public key.

This is to avoid a denial of service scenario, were by some reason (including an attack, but maybe a bug), the public server is constantly rotating the public key.

This would bring the Application server to a halt very quickly so its great to have built-in defenses against that! If you would like to change these default parameters, have a look at the [library docs](https://github.com/auth0/node-jwks-rsa#caching) for further details.

And with this, we have completed the JWT journey through the network!

* We have created and signed a JWT in the Application server
* We have shown how the client can use the JWT and send it back to the server with each HTTP request
* we have shown how the Application server can validate the JWT, and link each request to a given user

And we have discussed the multiple design decisions involved in this roundtrip. Let's summarize what we have learned.

### Summary and Conclusions

Delegating security features like Authentication and Authorization to a third-party JWT-based provider or product is now more feasible than ever, but this does not mean that security can be added transparently to an application.

Even if we choose a third party authentication provider or an enterprise single sign-on solution, we will still have to know how JWTs work at least to some detail, if nothing else to understand the documentation of the products and libraries that we will need to choose from.

We will still have to take a lot of security design decisions ourselves, choose libraries and products, choose critical configuration options such as JWT signature types, setup hosted login pages if applicable and put in place some very critical security-related code that is easy to get wrong.

I hope that this post helps with that and that you enjoyed it! If you have some questions or comments please let me know in the comments below and I will get back to you.

To get notified when more posts like this come out, I invite you to subscribe to our newsletter:

### Related Links

[The JWT Handbook by Auth0](https://auth0.com/e-books/jwt-handbook)

[Navigating RS256 and JWKS](https://auth0.com/blog/navigating-rs256-and-jwks/)

[Brute Forcing HS256 is Possible: The Importance of Using Strong Keys in Signing JWTs](https://auth0.com/blog/brute-forcing-hs256-is-possible-the-importance-of-using-strong-keys-to-sign-jwts/)

[JSON Web Key Set (JWKS)](https://auth0.com/docs/jwks)

### Video Lessons Available on YouTube

Have a look at the Angular University Youtube channel, we publish about 25% to a third of our video tutorials there, new videos are published all the time.

[Subscribe](http://www.youtube.com/channel/UC3cEGKhg3OERn-ihVsJcb7A?sub_confirmation=1) to get new video tutorials:

## Other posts on Angular

Have also a look also at other popular posts that you might find interesting:

* [Getting Started With Angular - Development Environment Best Practices With Yarn, the Angular CLI, Setup an IDE](http://blog.angular-university.io/getting-started-with-angular-setup-a-development-environment-with-yarn-the-angular-cli-setup-an-ide/)
* [Why a Single Page Application, What are the Benefits ? What is a SPA ?](http://blog.angular-university.io/why-a-single-page-application-what-are-the-benefits-what-is-a-spa/)
* [Angular Smart Components vs Presentation Components: What's the Difference, When to Use Each and Why?](http://blog.angular-university.io/angular-2-smart-components-vs-presentation-components-whats-the-difference-when-to-use-each-and-why)
* [Angular Router - How To Build a Navigation Menu with Bootstrap 4 and Nested Routes](http://blog.angular-university.io/angular-2-router-nested-routes-and-nested-auxiliary-routes-build-a-menu-navigation-system/)
* [Angular Router - Extended Guided Tour, Avoid Common Pitfalls](http://blog.angular-university.io/angular2-router/)
* [Angular Components - The Fundamentals](http://blog.angular-university.io/introduction-to-angular-2-fundamentals-of-components-events-properties-and-actions/)
* [How to build Angular apps using Observable Data Services - Pitfalls to avoid](http://blog.angular-university.io/how-to-build-angular2-apps-using-rxjs-observable-data-services-pitfalls-to-avoid/)
* [Introduction to Angular Forms - Template Driven vs Model Driven](http://blog.angular-university.io/introduction-to-angular-2-forms-template-driven-vs-model-driven/)
* [Angular ngFor - Learn all Features including trackBy, why is it not only for Arrays ?](http://blog.angular-university.io/angular-2-ngfor/)
* [Angular Universal In Practice - How to build SEO Friendly Single Page Apps with Angular](http://blog.angular-university.io/angular-2-universal-meet-the-internet-of-the-future-seo-friendly-single-page-web-apps/)
* [How does Angular Change Detection Really Work ?](http://blog.angular-university.io/how-does-angular-2-change-detection-really-work/)


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
