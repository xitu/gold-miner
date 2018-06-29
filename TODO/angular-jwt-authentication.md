> * 原文地址：[Angular Security - Authentication With JSON Web Tokens (JWT): The Complete Guide](https://blog.angular-university.io/angular-jwt-authentication/)
> * 原文作者：[angular-university](https://blog.angular-university.io)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/angular-jwt-authentication.md](https://github.com/xitu/gold-miner/blob/master/TODO/angular-jwt-authentication.md)
> * 译者：[Raoul1996](https://github.com/Raoul1996)
> * 校对者：[Tina92](https://github.com/Tina92)、[realYukiko](https://github.com/realYukiko)

# Angular 安全 —— 使用 JSON 网络令牌（JWT）的身份认证：完全指南
本文是在 Angular 应用中设计和实现基于 JWT（JSON Web Tokens）身份验证的分步指南。

我们的目标是系统的讨论**基于 JWT 的认证设计和实现**，衡量取舍不同的设计方案，并将其应用到某个 Angular 应用特定的上下文中。

我们将追踪一个 JWT 从被认证服务器创建开始，到它被返回到客户端，再到它被返回到应用服务器的全程，并讨论其中涉及的所有的方案以及做出的决策。

由于身份验证同样需要一些服务端代码，所以我们将同时显示这些信息，以便我们可以掌握整个上下文，并且看清楚各个部分之间如何协作。

服务端代码是 Node/Typescript，Angular 开发者对这些应该是非常熟悉的。但是涵盖的概念并不是特定于 Node 的。

如果你使用另一种服务平台，主需要在 [jwt.io](https://jwt.io) 上为你的平台选择一个 JWT 库，这些概念仍然适用。

### 目录
在这篇文章中，我们将介绍以下主题：

* 第一步 —— 登陆页面
  * 基于 JWT 的身份验证  
  * 用户在 Angular 应用中登录
  * 为什么要使用单独托管的登陆页面？
  * 在我们的单页应用（SPA）中直接登录
* 第二步 —— 创建基于 JWT 的用户会话
  * 使用 [node-jsonwebtoken](https://github.com/auth0/node-jsonwebtoken) 创建 JWT 会话令牌
* 第三步 —— 将 JWT 返回到客户端
  * 在哪里存储 JWT 会话令牌？
  * Cookie 与 Local Storage
* 第四步 —— 在客户端存储使用 JWT  
  * 检查用户过期时间
* 第五步 —— 每次请求携带 JWT 发回到服务器  
  * 如何构建一个身份验证 HTTP 拦截器
* 第六步 —— 验证用户请求
  * 构建用于 JWT 验证的定制 Express 中间件
  * 使用 [express-jwt](https://github.com/auth0/express-jwt) 配置 JWT 验证中间件
  * 验证 JWT 签名 —— RS256
  * RS256 与 HS256
  * JWKS (JSON Web 密钥集) 终节点和密钥轮换
  * 使用 [node-jwks-rsa](https://github.com/auth0/node-jwks-rsa) 实现 JWKS 密钥轮换
* 总结

所以无需再费周折（without further ado），我们开始学习基于 JWT 的 Angular 的认证吧！

### 基于 JWT 的用户会话
首先介绍如何使用 JSON 网络令牌来建立用户会话：简而言之，JWT 是数字签名以 URL 友好的字符串格式编码的 JSON 有效载荷（payload）。

JWT 通常可以包含任何有效载荷，但最常见的用例是使用有效载荷来定义用户会话。

JWT 的关键在于，我们只需要检查令牌本身验证签名就可以确定它们是否有效，而无需为此单独联系服务器，不需要将令牌保存到内存中，也不需要在请求的时候保存到服务器或内存中。

如果使用 JWT 身份验证，则它们将至少包含用户 ID 和过期时间戳。

如果你想要深入了解有关 JWT 格式的详细信息（包括最常用的签名类型如何工作），请参阅本文后面的 [JWT: The Complete Guide to JSON Web Tokens](https://blog.angular-university.io/angular-jwt) 一文。

如果想知道 JWT 是什么样子的话，下面是一个例子：

```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIzNTM0NTQzNTQzNTQzNTM0NTMiLCJleHAiOjE1MDQ2OTkyNTZ9.zG-2FvGegujxoLWwIQfNB5IT46D-xC4e8dEDYwi6aRM
```

你可能会想：这看起来不像 JSON！那么 JSON 在哪里？

为了看到它，让我们回到 [jwt.io](https://jwt.io/) 并将完成的 JWT 字符串粘贴到验证工具中，然后我们就能看到 JSON 的有效内容：

```
{
  "sub": "353454354354353453",
  "exp": 1504699256
}
```
查看 [raw01.ts](https://gist.github.com/jhades/2375d4f784938d28eaa41f321f8b70fe#file-01-ts) ❤托管于 [GitHub](https://github.com)

`sub` 属性包含用户标识符，`exp` 包含用户过期时间戳.这种类型的令牌被称为不记名令牌（Bearer Token），意思是它标识拥有它的用户，并定义一个用户会话。

> 不记名令牌是用户名/密码组合的签名临时替换！

如果想进一步了解 JWT，请看看[这里](https://blog.angular-university.io/angular-jwt)。对于本文的其余部分，我们将假定 JWT 是一个包含可验证 JSON 有效载荷的字符串，它定义了一个用户会话。

实现基于 JWT 的身份验证第一步是发布不记名令牌并将其提供给用户，这是登录/注册页面的主要目的。

### 第一步 —— 登陆页面
身份验证以登陆页面开始，该页面可以托管在我们的域中或者第三方域中。在企业场景中，登陆页面一般会托管在单独的服务器上。这是公司范围内单点登录解决方案的一部分。

在公网（Public Internet）上，登录页面也可能是：

* 由第三方身份验证程序（如 Auth0）托管
* 在我们的单页应用中可用的登录页面路径或模式下直接使用。

单独托管的登录页面是一种安全性的改进，因为这样密码永远不会直接由我们的应用代码来处理。

单独托管的登录页面可以具有最少量的 JavaScript 甚至完全没有，并且可以将其做到不论看起来还是用起来都像是整体应用的一部分的效果。

但是，用户在我们应用中通过内置登录页面登录也是一种可行且常用的解决方案，所以我们也会介绍一下。

### 直接在 SPA 应用上的登录页面
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
把我们所有的客户端身份验证逻辑放在一个集中的应用范围内的单个 `AuthService`（认证服务）中将帮助我们保持我们代码的组织结构。

这样，如果以后我们需要更改安全提供者或者重构我们的安全逻辑，我们只需要改变这个类。

在这个服务里，我们将使用一些 JavaScript API 来调用第三方服务，或者使用 Angular HTTP Client 进行 HTTP POST 调用。

这两种方案的目标是一致的：通过 POST 请求将用户和密码组合通过网络传送到认证服务器，以便验证密码并启动会话。

以下是我们如何使用 Angular HTTP Client 构建自己的 HTTP POST：

```
@Injectable()
export class AuthService {
     
    constructor(private http: HttpClient) {
    }
      
    login(email:string, password:string ) {
        return this.http.post<User>('/api/login', {email, password})
            // 这只是一个 HTTP 调用, 
            // 我们还需要去处理 token 的接收
        	.shareReplay();
    }
}
```
       
查看 [raw03.ts](https://gist.github.com/jhades/2375d4f784938d28eaa41f321f8b70fe#file-03-ts) ❤托管于 [GitHub](https://github.com)

我们调用的 `shareReplay` 可以防止这个 Observable 的接收者由于多次订阅而意外触发多个 POST 请求。

在处理登录响应之前，我们先来看看请求的流程，看看服务器上发生了什么。

### 第二步 —— 创建 JWT 会话令牌
无论我们在应用级别使用登录页面还是托管登录页面，处理登录 POST 请求的服务器逻辑是相同的。

目标是在这两种情况下都会验证密码并建立一个会话。如果密码是正确的，那么服务器将会发出一个不记名令牌，说：

> 该令牌的持有者的专业 ID 是 353454354354353453, 该会话在接下来的两个小时有效

然后服务器应该对令牌进行签名并发送回用户浏览器！关键部分是 JWT 签名：这是防止攻击者伪造会话令牌的唯一方式。

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

          // 将 JWT 发回给用户
          // TODO - 多种可选方案                              
    }
    else {
        // 发送状态 401 Unauthorized（未经授权）
        res.sendStatus(401); 
    }
}
```
查看 [raw04.ts](https://gist.github.com/jhades/2375d4f7849应用38d28eaa41f321f8b70fe#file-04-ts) ❤托管于 [GitHub](https://github.com)

代码很多，我们逐行分解：

* 我们首先创建一个 Express 应用
* 接下来，我们配置 `bodyParser.json()` 中间件，使 Express 能够从 HTTP 请求体中读取 JSON 有效载荷
* 然后，我们定义了一个名为 `loginRoute` 的路由处理程序，如果服务器收到一个目标地址是 `/api/login` 的 POST 请求，就会触发它

在 `loginRoute` 方法中，我们有一些代码展示了如何实现登录路由：

* 由于 `bodyParser.json()` 中间件的存在，我们可以使用 `req.body` 访问 JSON 请求主体有效载荷。
* 我们先从请求主体中检索电子邮件和密码
* 然后我们要验证密码，看看它是否正确
* 如果密码错误，那么我们返回 HTTP 401 状态码表示未经授权
* 如果密码正确，我们从检索用户专用标识开始
* 然后我们使用用户 ID 和过期时间戳创建一个普通的 JavaScript 对象，然后将其发送回客户端
* 我们使用 [node-jsonwebtoken](https://github.com/auth0/node-jsonwebtoken) 库对有效载荷进行签名，然后选择 RS256 签名类型（稍后详细介绍）
* `.sign()` 调用结果是 JWT 字符串本身

总而言之，我们验证了密码并创建一个 JWT 会话令牌。现在我们已经对这个代码的工作原理有了一个很好的了解，让我们来关注使用了 RS256 签名的包含用户会话详细信息的 JWT 签名的关键部分。

为什么签名的类型很重要？因为没有理解它，我们就无法理解应用程序服务端上对相关令牌的验证代码。

#### 什么是 RS256 签名?

RS256 是基于 RSA 的 JWT 签名类型，是一种广泛使用的公钥加密技术。

> 使用 RS256 签名的主要优点之一是我们可以将创建令牌的能力与验证他们的能力分开。

如果您想知道如何手动重现它们，可以阅读 [JWT 指南](https://blog.angular-university.io/angular-authentication-jwt/)中使用此类签名的所有优点。

简而言之，RS256 签名的工作方式如下：

* 私钥（如我们的代码中的 `RSA_PRIVATE_KEY`）用于对 JWT 进行签名
* 一个公钥用来验证它们
* 这两个密钥是不可互换的：它们只能标记 token，或者只能验证，它们中的任何一个都不能同时做这两件事

### 为什么用 RS256?

为什么使用公钥加密签署 JWT ？以下是一些安全和运营优势的例子：

* 我们只需要在认证服务器部署签名私钥，不是在多个应用服务器使用相同认证服务器。
* 我们不必为了同时更改每个地方的共享密钥而以协同的方式关闭认证服务器和应用服务器。
* 公钥可以在 URL 中公布并且被应用服务器在启动时以及定时自动读取。

最后一部分是一个很好的特性：能够发布验证密钥给我们内置的密钥轮换或者撤销，我们将在这篇文章中实现！

这是因为（使用 RS256）为了启用一个新的密钥对，我们只需要发布一个新的公钥，并且我们会看到这个公钥。

### RS256 vs HS256

另一个常用的签名是 HS256，没有这些优势。

HS256 仍然是常用的，但是例如 Auth0 等供应商现在都默认使用 RS256。如果你想了解有关 HS256，RS256 和 JWT 签名的更多信息，请查看这篇[文章](https://blog.angular-university.io/angular-authentication-jwt/)

抛开我们使用的签名类型不谈，我们需要将新签名的令牌发送回用户浏览器。

### 第三步 —— 将 JWT 发送回客户端

我们有几种不同的方式将令牌发回给用户，例如：

* 在 Cookie 中
* 在请求正文中
* 在一个普通的 HTTP 头

#### JWT 和 Cookie

让我们从 cookie 开始，为什么不使用 Cookie 呢？JWT 有时候被称为 Cookie 的替代品，但这是两个完全不同的概念。 Cookie 是一种浏览器数据存储机制，可以安全地存储少量数据。

该数据可以是诸如用户首选语言之类的任何数据。但它也可以包含诸如 JWT 的用户识别令牌。

因此，我们可以将 JWT 存储在 Cookie 中！然后，我们来谈谈使用 Cookie 存储 JWT 与其他方法相比较的优点和缺点。

#### 浏览器如何处理 Cookie

Cookie 的一个独特之处在于，浏览器会自动为每个请求附加到特定域和子域的 Cookie 到 HTTP 请求的头部。

这就意味着，如果我们将 JWT 存储到了 Cookie 中，假设登录页面和应用共享一个根域，那么在客户端上，我们不需要任何其他的的逻辑，就可以让 Cookie 随每一个请求发送到应用服务器。

然后，让我们把 JWT 存储到 Cookie 中，看看会发生什么。下面是我们对登录路由的实现，发送 JWT 到浏览器，存入 ：


```
... continuing the implementation of the Express login route

// this is the session token we created above
const jwtBearerToken = jwt.sign(...);

// set it in an HTTP Only + Secure Cookie
res.cookie("SESSIONID", jwtBearerToken, {httpOnly:true, secure:true});
```
查看 [raw05.ts](https://gist.github.com/jhades/2375d4f784938d28eaa41f321f8b70fe#file-05-ts) ❤托管于 [GitHub](https://github.com)

除了使用 JWT 值设置 Cookie 外，我们还设置了一些我们将要讨论的安全属性。

#### Cookie 独特的安全属性 —— HttpOnly 和安全标志

Cookie 另一个独特之处在于它有着一些与安全相关的属性，有助于确保数据的安全传输。

一个 Cookie 可以标记为“安全”，这意味着如果浏览器通过 HTTPS 连接发起了请求，那么它只会附加到请求中。

一个 Cookie 同样可以被标记为 Http Only，这就意味着它 **根本不能** 被 JavaScript 代码访问！请注意，浏览器依旧会将 Cookie 附加到对服务器的每个请求中，就像使用其他 Cookie 一样。

这意味着，当我们删除 HTTP Only 的 Cookie 的时候，我们需要向服务器发送请求，例如注销用户。

#### HTTP Only Cookie 的优点

HTTP Only 的 Cookie 的一个优点是，如果应用遭受脚本注入攻击（或称 XSS），在这种荒谬的情况下， Http Only 标志仍然会阻止攻击者访问 Cookie ，阻止使用它冒充用户。

Secure 和 Http Only 标志经常可以一起使用，以获得最大的安全性，这可能使我们认为 Cookie 是存储 JWT 的理想场所。

但是 Cookie 也有一些缺点，那么我们来谈谈这些：这将有助于我们知晓在 JWT 中存储 Cookie 是否是一种适合我们应用的好方案。（译者注：原文是 “this will help us decide if storing cookies in a JWT is a good approach for our application”，但是上面的部分讲的是将 JWT 存入 Cookie 中，所以译者认为原文有误，但是还是选择尊重原文）

#### Cookie 的缺点 —— XSRF（跨站请求伪造）

将不记名令牌存储在 Cookie 中的应用，因此（因为这个 Cookie）遭受的攻击被称为跨站请求伪造（Cross-Site Request Forgery），也成为 XSRF 或者 CSRF。下面是其原理：

* 有人发给你一个链接，并且你点击了它
* 这个链接向受到攻击的网站最终发送了一个 HTTP 请求，其中包含了所有链接到该网站的 Cookie
* 如果你登陆了网站，这意味着包含我们 JWT 不记名令牌的 Cookie 也会被转发，这是由浏览器自动完成的
* 服务器接收到有效的 JWT，因此服务器无法区分这是攻击请求还是有效请求

这就意味着攻击者可以欺骗用户代表他去执行某些操作，只需要发送一封电子邮件或者公共论坛上发布链接即可。

这个攻击不像看起来那么吓人，但问题是执行起来很简单：只需要一封电子邮件或者社交媒体上的帖子。

我们会在后文详细介绍这种攻击，现在需要知道的是，如果我们选择将我们的 JWT 存储到 Cookie 中，那么我们还需要对 XSRF 进行一些防御。

好消息是，所有的主流框架都带有防御措施，可以很容易地对抗 XSRF，因为它是一个众所周知的漏洞。

就像是发生过很多次一样，Cookie 设计上鱼和熊掌不能兼得：使用 Cookie 意味着利用 HTTP Only 可以很好的防御脚本注入，但是另一方面，它引入了一个新的问题 —— XSRF。

#### Cookie 和第三方认证提供商

在 Cookie 中接收会话 JWT 的潜在问题是，我们无法从处理验证逻辑的第三方域接收到它。

这是因为在 `app.example.com` 运行的应用不能从 `security-provider.com` 等其他域访问 Cookie。
因此在这种情况下，我们将无法访问包含 JWT 的 Cookie，并将其发送到我们的服务器进行验证，这个问题导致了 Cookie 不可用。

#### 我们可以得到两个方案中的最优解吗？

第三方认证提供商可能会允许我们在我们自己网站的可配置子域名中运行外部托管的登录页面，例如 `login.example.com`。

因此，将所有这些解决方案中最好的部分组合起来是有可能的。下面是解决方案的样子：

* 将外部托管的登录页面托管到我们自己的子域 `login.example.com` 上，`example.com` 上运行应用
* 该页面设置了仅包含 JWT 的 HTTP Only 和 Secure 的 Cookie，为我们提供了很好的保护，以低于依赖窃取用户身份的多种类型的 XSS 攻击
* 此外，我们需要添加一些 XSRF 防御功能，这里有一个很好理解的解决方案

这将为我们提供最大限度的保护，防止密码和身份令牌被盗：

* 应用永远不会获取密码
* 应用代码从不访问会话 JWT，只访问浏览器
* 该应用的请求不容易被伪造（XSRF）

这种情况有时用于企业门户，可以提供很好的安全功能。但是这需要我们的登录页面支持托管到自定义域，且使用了安全提供程序或企业安全代理。

但是，此功能（登录页面托管到自定义子域）并不总是可用，这使得 HTTP Only Cookie 方法可能失效。

如果你的应用属于这种情况，或者你正寻找不依赖 Cookie 的替代方案，那么让我们回到最初的起点，看看我们可以做什么。

#### 在 HTTP 响应正文中发送回 JWT

具有 HTTP Only 特性的 Cookie 是存储 JWT 的可靠选择，但是还会有其他很好的选择。例如我们不使用 Cookie，而是在 HTTP 响应体中将 JWT 发送回客户端。

我们不仅要发送 JWT 本身，而且还要将过期时间戳作为单独的属性发送。

的确，过期时间戳在 JWT 中也可以获取到，但是我们希望让客户端能够简单地获得会话持续时间，而不必要为此再安装一个 JWT 库。

以下使我们如何在 HTTP 响应体中将 JWT 发送回客户端：

```
... 继续 Express 登录路由的实现

// 这是我们上面创建的会话令牌
const jwtBearerToken = jwt.sign(...);

// 将其放入 HTTP 响应体中
res.status(200).json({
  idToken: jwtBearerToken, 
  expiresIn: ...
});

```
查看 [raw06.ts](https://gist.github.com/jhades/2375d4f784938d28eaa41f321f8b70fe#file-06-ts) ❤托管于 [GitHub](https://github.com)

这样，客户端将收到 JWT 及其过期时间戳。

#### 为了不使用 Cookie 存储 JWT 所进行的设计妥协

不使用 Cookie 的优点是我们的应用不再容易受到 XSRF 攻击，这是这种方法的优点之一。

但是这同样意味着我们将不得不添加一些客户端代码来处理令牌，因为浏览器将不再为每个向应用服务器发送的请求转发它。

这也意味着，在成功的脚本注入攻击的情况下，攻击者此时可以读取到 JWT 令牌，而存储到 HTTP Only Cookie 则不可能读取到。

这是与选择安全解决方案有关的设计折衷的一个好例子：通常是安全与便利的权衡。

让我们继续跟随我们的 JWT 不记名令牌的旅程。由于我们将 JWT 通过请求体发回给客户端，我们需要阅读并处理它。（译者注：原文是“Since we are sending the JWT back to the client in the request body”，译者认为应该是响应体（response body），但是尊重原文）


### 第四步 —— 在客户端存储使用 JWT

一旦我们在客户端收到了 JWT，我们需要把它存储在某个地方。否则，如果我们刷新浏览器，它将会丢失。那么我们就必须要重新登录了。

有很多地方可以保存 JWT（Cookie 除外）。本地存储（Local Storage）是存储 JWT 的实用场所，它是以字符串的键值对的形式存储的，非常适合存储少量数据。

请注意，本地存储具有同步 API。让我们来看看实用本地存储的登录与注销逻辑的实现：

```
import * as moment from "moment";

@Injectable()
export class AuthService {

    constructor(private http: HttpClient) {

    }

    login(email:string, password:string ) {
        return this.http.post<User>('/api/login', {email, password})
            .do(res => this.setSession) 
            .shareReplay();
    }
          
    private setSession(authResult) {
        const expiresAt = moment().add(authResult.expiresIn,'second');

        localStorage.setItem('id_token', authResult.idToken);
        localStorage.setItem("expires_at", JSON.stringify(expiresAt.valueOf()) );
    }          

    logout() {
        localStorage.removeItem("id_token");
        localStorage.removeItem("expires_at");
    }

    public isLoggedIn() {
        return moment().isBefore(this.getExpiration());
    }

    isLoggedOut() {
        return !this.isLoggedIn();
    }

    getExpiration() {
        const expiration = localStorage.getItem("expires_at");
        const expiresAt = JSON.parse(expiration);
        return moment(expiresAt);
    }    
}
```          
查看 [raw07.ts](https://gist.github.com/jhades/2375d4f784938d28eaa41f321f8b70fe#file-07-ts) ❤托管于 [GitHub](https://github.com)

让我们分析一下这个实现过程中发生了什么，从 login 方法开始：

* 我们接收到包含 JWT 和 `expiresIn` 属性的 login 调用的结果，并直接将它传递给 `setSession` 方法
* 在 `setSession` 中，我们直接将 JWT 存储到本地存储中的 `id_token` 键值中
* 我们使用当前时间和 `expiresIn` 属性计算过期时间戳
* 然后我们还将过期时间戳保存为本地存储中 `expires_at` 条目中的一个数字值

### 在客户端使用会话信息

现在我们在客户端拥有全部的会话信息，我们可以在客户端应用的其余部分使用这些信息。

例如，客户端应用需要知道用户是否登陆或者注销，以判断某些比如登录/注销菜单按钮这类的 UI 元素的显示与否。

这些信息现在可以通过 `isLoggedIn()`, `isLoggedOut()` 和 `getExpiration()` 获取。


### 对服务器的每次请求都携带 JWT

现在我们已经将 JWT 保存在用户浏览器中，让我们继续追随其在网络中的旅程。

让我们来看看如何使用它来让应用服务器知道一个给定的 HTTP 请求属于特定用户。这是认证方案的全部要点。

以下是我们需要做的事情：我们需要用某种方式为 HTTP 附加 JWT，并发送到应用服务器。

然后应用服务器将验证请求并将其链接到用户，只需要检查 JWT，检查其签名并从有效内容中读取用户标识。

为了确保每个请求都包含一个 JWT，我们将使用一个 Angular HTTP 拦截器。

### 如何构建一个身份验证 HTTP 拦截器

以下是 Angular 拦截器的代码，用于为每个请求附加 JWT 并发送给应用服务器：

```
@Injectable()
export class AuthInterceptor implements HttpInterceptor {

    intercept(req: HttpRequest<any>,
              next: HttpHandler): Observable<HttpEvent<any>> {

        const idToken = localStorage.getItem("id_token");

        if (idToken) {
            const cloned = req.clone({
                headers: req.headers.set("Authorization",
                    "Bearer " + idToken)
            });

            return next.handle(cloned);
        }
        else {
            return next.handle(req);
        }
    }
}

``` 
查看 [raw08.ts](https://gist.github.com/jhades/2375d4f784938d28eaa41f321f8b70fe#file-08-ts) ❤托管于 [GitHub](https://github.com)

那么让我们来分解以下这个代码是如何工作：

* 我们首先直接从本地存储检索 JWT 字符串
* 请注意，我们没有在这里注入 AuthService，因为这里会导致循环依赖错误
* 然后我们将检查 JWT 是否存在
* 如果 JWT 不存在，那么请求将通过服务器进行修改
* 如果 JWT 存在，那么我们就克隆 HTTP 头，并添加额外的认证（Authorization）头，其中将包含 JWT

并且在此处，最初在认证服务器上创建的 JWT 现在会随着每个请求发送到应用服务器。

我们来看看应用服务器如何使用 JWT 来识别用户。

### 验证服务端的 JWT
为了验证请求，我们需要从 `Authorization` 头中提取 JWT，并检查时间戳和用户标识符。

我们不希望将这个逻辑应用到所有的后端路由，因为某些路由是所有用户公开访问的。例如，如果我们建立了自己的登陆和注册路由，那么这些路由应该可以被所有用户访问。

另外，我们不希望在每个路由基础上都重复验证逻辑，因此最好的解决方案是创建一个 Express 认证中间件，并将其应用于特定的路由。

假设我们已经定义了一个名为 `checkIfAuthenticated` 的 express 中间件，这是一个可重用的函数，它只在一个地方包含认证逻辑。

以下是我们如何将其应用于特定的路由：

```
import * as express from 'express';

const app: Application = express();

// ... 定义 checkIfAuthenticated 中间件
// 检查用户是否仅在某些路由进行身份验证
app.route('/api/lessons')
    .get(checkIfAuthenticated, readAllLessons);
```

查看 [raw10.ts](https://gist.github.com/jhades/2375d4f784938d28eaa41f321f8b70fe#file-10-ts) ❤托管于 [GitHub](https://github.com)

在这个例子中，`readAllLessons` 是一个 Express 路由，如果一个 GET 请求到达 `/api/lessons` Url，它就会提供一个 JSON 列表。

我们已经通过在 REST 端点之前应用 `checkIfAuthenticated` 中间件，使得这个路由只能被认证的用户访问，这意味着中间件功能的顺序很重要。

如果没有有效的 JWT，`checkIfAuthenticated` 中间件将会报错，或允许请求通过中间件链继续。

在 JWT 存在的情况下，如果签名正确但是过期，中间件也需要抛出错误。请注意，在使用基于 JWT 的身份验证的任何应用中，所有这些逻辑都是相同的。

我们可以使用 [node-jsonwebtoken](https://github.com/auth0/node-jsonwebtoken) 自己编写的中间件，但是这个逻辑很容易出错，所以我们使用第三方库。

### 使用 express-jwt 配置 JWT 验证中间件

为了创建 `checkIfAuthenticated` 中间件，我们将使用 [express-jwt](https://github.com/auth0/express-jwt) 库。

这个库可以让我们快速创建常用的基于 JWT 的身份验证设置的中间件，所以我们来看看如何使用它来验证 JWT，比如我们在登录服务中创建 JWT（使用 RS256 签名）。

首先假定我们首先在服务器的文件系统中安装了签名验证公钥。以下是我们如何使用它来验证 JWT：

```
const expressJwt = require('express-jwt');

const RSA_PUBLIC_KEY = fs.readFileSync('./demos/public.key');

const checkIfAuthenticated = expressJwt({
    secret: RSA_PUBLIC_KEY
}); 

app.route('/api/lessons')
    .get(checkIfAuthenticated, readAllLessons);
```
查看 [raw11.ts](https://gist.github.com/jhades/2375d4f784938d28eaa41f321f8b70fe#file-11-ts) ❤托管于 [GitHub](https://github.com)

现在让我们逐行分解代码：

* 我们通过从文件系统读取公钥来开始，这将用于验证 JWT
* 此密钥只能用于验证现有的 JWT，而不能创建和签署新的 JWT
* 我们将公钥传递给了 `express-jwt`，并且我们得到一个准备使用的中间件函数！

如果认证头没有正确签名的 JWT，那么这个中间件将会抛出错误。如果 JWT 签名正确，但是已经过期，中间件也会抛出错误。

如果我们想要改变默认的异常处理方法，比如不将异常抛出。而是返回一个状态码 401 和一个 JSON 负载的消息，这也是[可以的](https://github.com/auth0/express-jwt#error-handling)。

使用 RS256 签名的主要优点之一是我们不需要像我们在这个例子中所做的那样，在应用服务器上安装公钥。

想象一下，服务器上有几个正在运行的实例：在任何地方同时替换公钥都会出现问题。

#### 利用 RS256 签名

由认证服务器在公开访问的 URL 中**发布**用于验证 JWT 的公钥。而不是在应用服务器上安装公钥。

这给我们带来了很多好处，比如说可以简化密钥轮换和撤销。如果我们需要一个新的密钥对，我们只需要发布一个新的公钥。

通常密钥周期轮换期间内，我们会将两个密钥发布和激活一段时间，这段时间一般大于会话时序时间，目的是不中断用户体验，然而撤销可能会更有效。

攻击者可以使用公钥，但是这没有危险。攻击者可以使用公钥进行攻击的唯一方法是验证现有 JWT 签名，可是这对攻击者无用。

攻击者无法使用公钥伪造新创建的 JWT，或者以某种方式使用公钥猜测私钥签名值。（译者注：这一部分主要涉及的是对称加密和非对称加密，感觉说的很啰嗦）

现在的问题是，如何发布公钥？

### JWKS (JSON Web 密钥集) 端点和密钥轮换

JWKS 或者 [JSON Web 密钥集](https://auth0.com/docs/jwks) 是用于在 REST 端点中基于 JSON 标准发布的公钥。

这种类型的端点输出有点吓人，但好消息是我们不必直接使用这种格式，因为有一个库直接使用了它：

```
{
  "keys": [
    {
      "alg": "RS256",
      "kty": "RSA",
      "use": "sig",
      "x5c": [
        "MIIDJTCCAg2gAwIBAgIJUP6A\/iwWqvedMA0GCSqGSIb3DQEBCwUAMDAxLjAsBgNVBAMTJWFuZ3VsYXJ1bml2LXNlY3VyaXR5LWNvdXJzZS5hdXRoMC5jb20wHhcNMTcwODI1MTMxNjUzWhcNMzEwNTA0MTMxNjUzWjAwMS4wLAYDVQQDEyVhbmd1bGFydW5pdi1zZWN1cml0eS1jb3Vyc2UuYXV0aDAuY29tMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAwUvZ+4dkT2nTfCDIwyH9K0tH4qYMGcW\/KDYeh+TjBdASUS9cd741C0XMvmVSYGRP0BOLeXeaQaSdKBi8uRWFbfdjwGuB3awvGmybJZ028OF6XsnKH9eh\/TQ\/8M\/aJ\/Ft3gBHJmSZCuJ0I3JYSBEUrpCkWjkS5LtyxeCPA+usFAfixPnU5L5lyacj3t+dwdFHdkbXKUPxdVwwkEwfhlW4GJ79hsGaGIxMq6PjJ\/\/TKkGadZxBo8FObdKuy7XrrOvug4FAKe+3H4Y5ZDoZZm5X7D0ec4USjewH1PMDR0N+KUJQMRjVul9EKg3ygyYDPOWVGNh6VC01lZL2Qq244HdxRwIDAQABo0IwQDAPBgNVHRMBAf8EBTADAQH\/MB0GA1UdDgQWBBRwgr0c0DYG5+GlZmPRFkg3+xMWizAOBgNVHQ8BAf8EBAMCAoQwDQYJKoZIhvcNAQELBQADggEBACBV4AyYA3bTiYWZvLtYpJuikwArPFD0J5wtAh1zxIVl+XQlR+S3dfcBn+90J8A677lSu0t7Q7qsZdcsrj28BKh5QF1dAUQgZiGfV3Dfe4\/P5wUaaUo5Y1wKgFiusqg\/mQ+kM3D8XL\/Wlpt3p804dbFnmnGRKAJnijsvM56YFSTVO0JhrKv7XeueyX9LpifAVUJh9zFsiYMSYCgBe3NIhIfi4RkpzEwvFIBwtDe2k9gwIrPFJpovZte5uvi1BQAAoVxMuv7yfMmH6D5DVrAkMBsTKXU1z3WdIKbrieiwSDIWg88RD5flreeTDaCzrlgfXyNybi4UTUshbeo6SdkRiGs="
      ],
      "n": "wUvZ-4dkT2nTfCDIwyH9K0tH4qYMGcW_KDYeh-TjBdASUS9cd741C0XMvmVSYGRP0BOLeXeaQaSdKBi8uRWFbfdjwGuB3awvGmybJZ028OF6XsnKH9eh_TQ_8M_aJ_Ft3gBHJmSZCuJ0I3JYSBEUrpCkWjkS5LtyxeCPA-usFAfixPnU5L5lyacj3t-dwdFHdkbXKUPxdVwwkEwfhlW4GJ79hsGaGIxMq6PjJ__TKkGadZxBo8FObdKuy7XrrOvug4FAKe-3H4Y5ZDoZZm5X7D0ec4USjewH1PMDR0N-KUJQMRjVul9EKg3ygyYDPOWVGNh6VC01lZL2Qq244HdxRw",
      "e": "AQAB",
      "kid": "QzY0NjREMjkyQTI4RTU2RkE4MUJBRDExNzY1MUY1N0I4QjFCODlBOQ",
      "x5t": "QzY0NjREMjkyQTI4RTU2RkE4MUJBRDExNzY1MUY1N0I4QjFCODlBOQ"
    }
  ]
}
```
查看 [raw12.ts](https://gist.github.com/jhades/2375d4f784938d28eaa41f321f8b70fe#file-12-ts) ❤托管于 [GitHub](https://github.com)

关于这种格式的一些细节：`kid` 代表密钥标识符，而 `x5c` 属性是公钥本身（它是 x509 证书链）。

再次强调，我们不必要编写代码来使用这种格式，但是我们需要对这个 REST 端点中发生的事情有一点了解：他只是简单地发布一个公钥。


### 使用 `node-jwks-rsa` 库实现 JWT 密钥轮换

由于公钥的格式是标准化的，我们需要的是一种读取密钥的方法，并将其传递给 `express-jwt` ，如此以便它可以代替从文件系统中读取出来的公钥。

而这正是 [node-jwks-rsa](https://github.com/auth0/node-jwks-rsa) 库让我们做的！我们来看看这个库的运作：

```
const jwksRsa = require('jwks-rsa');
const expressJwt = require('express-jwt');

const checkIfAuthenticated = expressJwt({
    secret: jwksRsa.expressJwtSecret({
        cache: true,
        rateLimit: true,
        jwksUri: "https://angularuniv-security-course.auth0.com/.well-known/jwks.json"
    }),
    algorithms: ['RS256']
});

app.route('/api/lessons')
    .get(checkIfAuthenticated, readAllLessons);

```
查看 [raw14.ts](https://gist.github.com/jhades/2375d4f784938d28eaa41f321f8b70fe#file-14-ts) ❤托管于 [GitHub](https://github.com)

这个库通过 `jwksUri` 属性指定 URL 读取公钥，并使用其验证 JWT 签名。我们需要做的只是匹配网址，如果需要的话还需要设置一些额外参数。

#### 使用 JWT 端点的配置选项

建议将 `cache` 属性设置为 true，以防每次都检索公钥。默认情况下，一个密钥会保留 10 小时，然后再检查它是否有效，同时最多缓存 5 个密钥。

`rateLimit` 属性也应该被启用，以确保库每分钟不会向包含公钥服务器发起超过 10 个请求。

这是为了避免出现拒绝服务的情况，由于某种情况（包括攻击，但也许是一个 bug），公共服务器会不断进行公钥轮换。

这将使应用服务器很快停止，因为它有很好的内置防御措施！如果你想要更改这些默认参数，请查看[库文档](https://github.com/auth0/node-jwks-rsa#caching)来获取更多详细信息。

这样，我们已经完成了 JWT 的网络之旅！

* 我们已经在应用服务器中创建并签名了一个 JWT
* 我们已经展示了如何在客户端使用 JWT 并将其随每个 HTTP 请求发送回服务器
* 我们已经展示了应用服务器如何验证 JWT，并将每个请求链接到给定用户

我们已经讨论了这个往返过程中涉及到的多个设计方案。让我们总结一下我们所学到的。

### 总结和结论

将认证和授权等安全功能委派给第三方基于 JWT 的提供商或者产品比以往更加合适，但这并不意味着安全性可以透明地添加到应用中。

即使我们选择了第三方认证提供商或企业级单点登录解决方案，如果没有其他可以用来理解我们所选的产品或者库的文档，我们至少也要知道其中关于 JWT 的一些处理细节。

我们仍然需要自己做很多安全设计方案，选择库和产品，选择关键配置选项，如 JWT 签名类型，设置托管登录页面（如果可用），并放置一些非常关键的、很容易出错安全相关代码。

希望这篇文章对你有帮助并且你能喜欢它！如果您有任何问题或者意见，请在下面的评论区告诉我，我将尽快回复您。

如果有更多的贴子发布，我们将通知你订阅我们的新闻列表。

### 相关链接

[Auth0 的 JWT 手册](https://auth0.com/e-books/jwt-handbook)

[浏览 RS256 和 JWKS](https://auth0.com/blog/navigating-rs256-and-jwks/)

[爆破 HS256 是可能的: 使用强密钥在签署 JWT 的重要性](https://auth0.com/blog/brute-forcing-hs256-is-possible-the-importance-of-using-strong-keys-to-sign-jwts/)

[JSON Web 密钥集（JWKS）](https://auth0.com/docs/jwks)

### YouTube 上提供的视频课程

看看 Angular 大学的 Youtube 频道，我们发布了大约 25％ 到三分之一的视频教程，新视频一直在出版。

[订阅](http://www.youtube.com/channel/UC3cEGKhg3OERn-ihVsJcb7A?sub_confirmation=1) 获取新的视频教程：

<iframe width="560" height="315" src="https://www.youtube.com/embed/PRQCAL_RMVo?list=PLOa5YIicjJ-VF39NLCZ304G6GDjvpJEca" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>

## Angular 上的其他帖子

同样可以看看其他很受欢迎的帖子，你可能会觉得有趣：

* [Angular 入门 —— 开发环境最佳实践使用 Yarn、Angular CLI，设置 IDE](http://blog.angular-university.io/getting-started-with-angular-setup-a-development-environment-with-yarn-the-angular-cli-setup-an-ide/)
* [SPA 应用有什么好处？什么是 SPA？](http://blog.angular-university.io/why-a-single-page-application-what-are-the-benefits-what-is-a-spa/)
* [Angular 智能组件与演示组件：有什么区别，什么时候使用哪一个，为什么？](http://blog.angular-university.io/angular-2-smart-components-vs-presentation-components-whats-the-difference-when-to-use-each-and-why)
* [Angular 路由 —— 如何使用 Bootstrap 4 和 嵌套路由建立一个导航菜单](http://blog.angular-university.io/angular-2-router-nested-routes-and-nested-auxiliary-routes-build-a-menu-navigation-system/)
* [Angular 路由 —— 延伸导游，避免常见陷阱](http://blog.angular-university.io/angular2-router/)
* [Angular 组件 —— 基础](http://blog.angular-university.io/introduction-to-angular-2-fundamentals-of-components-events-properties-and-actions/)
* [如何使用可观察数据服务构建 Angular 应用 —— 避免陷阱](http://blog.angular-university.io/how-to-build-angular2-apps-using-rxjs-observable-data-services-pitfalls-to-avoid/)
* [Angular 形式的介绍 —— 模板驱动与模型驱动](http://blog.angular-university.io/introduction-to-angular-2-forms-template-driven-vs-model-driven/)
* [Angular ngFor —— 了解所有功能，包括 trackBy，为什么它不仅仅适用于数组？](http://blog.angular-university.io/angular-2-ngfor/)
* [Angular 大学实践 —— 如何用 Angular 构建 SEO 友好的单页面应用](http://blog.angular-university.io/angular-2-universal-meet-the-internet-of-the-future-seo-friendly-single-page-web-apps/)
* [Angular 的更正变化如何真正的起作用？](http://blog.angular-university.io/how-does-angular-2-change-detection-really-work/)


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
