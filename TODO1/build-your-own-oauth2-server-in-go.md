> * 原文地址：[Build your Own OAuth2 Server in Go: Client Credentials Grant Flow](https://hackernoon.com/build-your-own-oauth2-server-in-go-7d0f660732c3)
> * 原文作者：[Cyan Tarek](https://hackernoon.com/@cyantarek)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/build-your-own-oauth2-server-in-go.md](https://github.com/xitu/gold-miner/blob/master/TODO1/build-your-own-oauth2-server-in-go.md)
> * 译者：[shixi-li](https://github.com/shixi-li)
> * 校对者：[JackEggie](https://github.com/JackEggie), [LucaslEliane](https://github.com/LucaslEliane)

# 在 GO 语言中创建你自己的 OAuth2 服务：客户端凭据授权流程

![](https://cdn-images-1.medium.com/max/2600/0*mtbIDJPdV4cD8Xgo)

嗨，在今天的文章中，我会向大家展示怎么构建属于每个人自己的 OAuth2 服务器，就像 google、facebook 和 github 等公司一样。

如果你想构建用于生产环境的公共或者私有 API，这都会是很有帮助的。所以现在让我们开始吧。

### 什么是 OAuth2?

开放授权版本 2.0 被称为 OAuth2。它是一种保护 RESTful Web 服务的协议或者说是框架。OAuth2 非常强大。由于 OAuth2 坚如磐石的安全性，所以现在大多数的 REST API 都通过 OAuth2 进行保护。

#### OAuth2 具有两个部分

01. 客户端

02. 服务端

### OAuth2 服务端

![](https://cdn-images-1.medium.com/max/1600/0*ojCsrGLMlae6xw62.png)

如果你熟悉这个界面，你就会知道我将要说什么。但是无论熟悉与否，都让我来讲一下这个图片背后的故事吧。

你正在构建一个面向用户的应用程序，它是与用户的 github 仓库协同使用的。比如：就像是 TravisCI、CircleCI 和 Drone 等 CI 工具。

但是用户的 github 账户是被保护的，如果所有者不愿意任何人都无权访问。那么这些 CI 工具如何访问用户的 github 帐户和仓库的呢？

这其实很简单。

你的应用程序会询问用户

> **“为了与我们的服务协作，我们需要得到你的 github 仓库的读取权限。你同意吗？”**

然后这个用户就会说

> **“我同意。你们可以去做你们需要做的事儿啦。"**

然后你的应用程序会请求 github 的权限管理以获得那个特定用户的 github 访问权限。Github 会检查是否属实并要求该用户进行授权。通过之后 github 就会给这个客户端发送一个临时的令牌。

现在，当你的应用程序得到身份验证和授权以后需要访问 github 时，就需要把这个令牌在请求中间带过去，github 收到了之后就会想：

> **“咦，这个访问令牌看起来很眼熟嘛，应该是我们之前就给过你了。好，你可以访问了”**

这是一个很长的流程。但是时代已经变啦，现在你不用每次都去 github 授权中心（当然我们从来也不需要这样）。每件事都可以自动化地完成。

但是怎么完成呢？

![](https://cdn-images-1.medium.com/max/1600/0*wGuxcdSwF1vaOaH9)

这是我前几分钟讨论的内容所对应的 UML 时序图。就是一个对应的图形表示。

从上图中，我们可以发现几点重要的东西。

**OAuth2 有 4 个角色：**

01. 用户 — 最终使用你的应用程序的用户

02. 客户端 — 就是你构建的那个会使用 github 账户的应用程序，也就是用户会使用的东西

03. 鉴权服务器 — 这个服务器主要处理 OAuth 相关事务

04. 资源服务器 — 这个服务器有那些被保护的资源。比如说 github

客户端代表用户向鉴权服务器发送 OAuth2 请求。

构建一个 OAuth2 客户端不算简单但也不算困难。听起来很有趣对吧？我们会在下一个部分来实际操作。

但在这个部分，我们会去这个世界的另一面看看。我们会构建我们自己的 OAuth2 服务端。这并不简单但是很有趣。

准备好了吗？让我们开始吧

### OAuth2 服务器

你也许会问我

> **“Cyan 等一下，为什么要构建一个 OAuth2 服务器啊？”**

朋友你忘了吗？我之前说了这一点的啊。好吧，让我再次告诉你。

想象一下，你构建了一个非常棒的应用程序，它可以提供准确的天气信息（现在已经有很多这种类型的 API 了）。现在你希望把它变得开放让公众都可以使用或者你想靠它来赚钱了。

但无论什么情况，你都需要保护你的资源免受未经授权的访问或者恶意的攻击。 所以你需要保护你的 API 资源。那这里就需要用到 OAuth2 啦。对吧！

从上图中我们可以看到，鉴权服务器需要放置在 REST API 资源服务器之前。这就是我们要讨论的东西。这个鉴权服务器需要根据 OAuth2 规范构建。然后我们就会变成第一张图片里面的 github 啦，哈哈哈哈开玩笑的。

OAuth2 服务器的主要目标是给客户端提供访问的令牌。这也就是为什么 OAuth2 服务器也被称作 OAuth2 提供者，因为他们可以提供令牌。

这个解释就说这么多啦。

**基于鉴权流程有 4 种不同的 OAuth2 服务器模式：**

01. 授权码模式

02. 隐式授权模式

03. 客户端验证模式

04. 密码模式

如果你想了解更多关于 OAuth2 的东西，请看 [**这里的**](https://itnext.io/an-oauth-2-0-introduction-for-beginners-6e386b19f7a9) 精彩文章。

在本文中，我们会使用 **客户端验证模式**。咱们来深入了解一下吧。

### 基于服务器的客户端凭据授权流程

在构建基于 OAuth2 服务器的客户端凭据授权流程时，我们需要了解一些东西。

在这个授权类型里面没有用户交互 (也就是指没有注册，登录)。而是需要两个东西，它们是 **客户端 ID** 和 **客户端密钥**。有了这两个东西，我们就可以获取到 **访问令牌**。客户端就是第三方的应用程序。当需要在没有用户机制或者是仅通过客户端应用程序，想要访问资源服务器的时候，这种授权方式是简便且适合的。

![](https://cdn-images-1.medium.com/max/1600/0*7X5b1VSQ2zC4MMin.png)

这就是对应的 UML 时序图。

### 编码

为了构建这个项目，我们需要依赖一个非常棒的 Go 语言包。

首先，我们需要开发一个简单的 API 服务作为资源服务器。

```
package main

import (
	"log"
	"net/http"
)

func main() {
	http.HandleFunc("/protected", validateToken(func(w http.ResponseWriter, r *http.Request) {
		w.Write([]byte("Hello, I'm protected"))
	}, srv))

	log.Fatal(http.ListenAndServe(":9096", nil))
}
```

运行这个服务并且发送 Get 请求到 [http://localhost:9096/protected](http://localhost:5555/protected)

你会得到响应。

这个服务受到什么类型的保护呢？

即使将这个接口的名字定义为 protected，但是任何人都可以请求它。我们需要将这个接口使用 OAuth2 保护。

现在我们就要编写我们自己的授权服务。

#### 路由

01. **/credentials** 用于颁发客户端凭据 （客户端 ID 和客户端密钥）

02. **/token** 使用客户端凭据颁发令牌

我们需要实现这两个路由。

这里是初步的设置

```
package main

import (
	"encoding/json"
	"fmt"
	"github.com/google/uuid"
	"gopkg.in/oauth2.v3/models"
	"log"
	"net/http"
	"time"

	"gopkg.in/oauth2.v3/errors"
	"gopkg.in/oauth2.v3/manage"
	"gopkg.in/oauth2.v3/server"
	"gopkg.in/oauth2.v3/store"
)

func main() {
   manager := manage.NewDefaultManager()
   manager.SetAuthorizeCodeTokenCfg(manage.DefaultAuthorizeCodeTokenCfg)

   manager.MustTokenStorage(store.NewMemoryTokenStore())

   clientStore := store.NewClientStore()
   manager.MapClientStorage(clientStore)

   srv := server.NewDefaultServer(manager)
   srv.SetAllowGetAccessRequest(true)
   srv.SetClientInfoHandler(server.ClientFormHandler)
   manager.SetRefreshTokenCfg(manage.DefaultRefreshTokenCfg)

   srv.SetInternalErrorHandler(func(err error) (re *errors.Response) {
      log.Println("Internal Error:", err.Error())
      return
   })

   srv.SetResponseErrorHandler(func(re *errors.Response) {
      log.Println("Response Error:", re.Error.Error())
   })
	
   http.HandleFunc("/protected", func(w http.ResponseWriter, r *http.Request) {
		w.Write([]byte("Hello, I'm protected"))
   })

   log.Fatal(http.ListenAndServe(":9096", nil))
}
```

这里我们创建了一个管理器，用于客户端存储和鉴权服务本身。

这里是 **/credentials** 路由的实现：

```
http.HandleFunc("/credentials", func(w http.ResponseWriter, r *http.Request) {
   clientId := uuid.New().String()[:8]
   clientSecret := uuid.New().String()[:8]
   err := clientStore.Set(clientId, &models.Client{
      ID:     clientId,
      Secret: clientSecret,
      Domain: "http://localhost:9094",
   })
   if err != nil {
      fmt.Println(err.Error())
   }

   w.Header().Set("Content-Type", "application/json")
   json.NewEncoder(w).Encode(map[string]string{"CLIENT_ID": clientId, "CLIENT_SECRET": clientSecret})
})
```

它创建了两个随机字符串，一个就是客户端 ID，另一个就是客户端密钥。并把它们保存到客户端存储。然后就会返回响应。就是这样。在这里我们使用了内存存储，但我们同样可以把它们存储到 redis，mongodb，postgres 等等里面。

这里是 **/token** 路由的实现：

```
http.HandleFunc("/token", func(w http.ResponseWriter, r *http.Request) {
   srv.HandleTokenRequest(w, r)
})
```

这非常简单。它将请求和响应传递给适当的处理程序，以便服务器可以解码请求中的所有必要的数据。

所以以下就是我们的整体代码：

```
package main

import (
   "encoding/json"
   "fmt"
   "github.com/google/uuid"
   "gopkg.in/oauth2.v3/models"
   "log"
   "net/http"
   "time"

   "gopkg.in/oauth2.v3/errors"
   "gopkg.in/oauth2.v3/manage"
   "gopkg.in/oauth2.v3/server"
   "gopkg.in/oauth2.v3/store"
)

func main() {
   manager := manage.NewDefaultManager()
   manager.SetAuthorizeCodeTokenCfg(manage.DefaultAuthorizeCodeTokenCfg)

   manager.MustTokenStorage(store.NewMemoryTokenStore())

   clientStore := store.NewClientStore()
   manager.MapClientStorage(clientStore)

   srv := server.NewDefaultServer(manager)
   srv.SetAllowGetAccessRequest(true)
   srv.SetClientInfoHandler(server.ClientFormHandler)
   manager.SetRefreshTokenCfg(manage.DefaultRefreshTokenCfg)

   srv.SetInternalErrorHandler(func(err error) (re *errors.Response) {
      log.Println("Internal Error:", err.Error())
      return
   })

   srv.SetResponseErrorHandler(func(re *errors.Response) {
      log.Println("Response Error:", re.Error.Error())
   })

   http.HandleFunc("/token", func(w http.ResponseWriter, r *http.Request) {
      srv.HandleTokenRequest(w, r)
   })

   http.HandleFunc("/credentials", func(w http.ResponseWriter, r *http.Request) {
      clientId := uuid.New().String()[:8]
      clientSecret := uuid.New().String()[:8]
      err := clientStore.Set(clientId, &models.Client{
         ID:     clientId,
         Secret: clientSecret,
         Domain: "http://localhost:9094",
      })
      if err != nil {
         fmt.Println(err.Error())
      }

      w.Header().Set("Content-Type", "application/json")
      json.NewEncoder(w).Encode(map[string]string{"CLIENT_ID": clientId, "CLIENT_SECRET": clientSecret})
   })
   
   http.HandleFunc("/protected", func(w http.ResponseWriter, r *http.Request) {
		w.Write([]byte("Hello, I'm protected"))
   })
   log.Fatal(http.ListenAndServe(":9096", nil))
}
```

运行这个代码并到 [http://localhost:9096/credentials](http://localhost:9096/credentials) 路由去注册并获取客户端 ID 和客户端密钥。

现在去到这个链接 http://localhost:9096/token?grant_type=client_credentials&client_id=2e14f7dd&client_secret=c729e9d0&scope=all

你可以得到具有过期时间和一些其他信息的授权令牌。

现在我们得到了我们的授权令牌。但是我们的 /protected 路由依然没有被保护。我们需要设置一个方法来检查每个客户端的请求是否都带有有效的令牌。如果是的，我们就可以给予这个客户端授权。反之就不能给予授权。

我们可以通过一个中间件来做到这一点。

如果你知道你在做什么，那么在 golang 中编写中间件会很有趣。以下就是中间件的代码：

```
func validateToken(f http.HandlerFunc, srv *server.Server) http.HandlerFunc {
   return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
      _, err := srv.ValidationBearerToken(r)
      if err != nil {
         http.Error(w, err.Error(), http.StatusBadRequest)
         return
      }

      f.ServeHTTP(w, r)
   })
}
```

这里将检查请求是否带有有效的令牌并采取对应的措施。

现在我们需要使用 适配器/装饰者 模式来将中间件放在我们的 /protected 路由前面。

```
http.HandleFunc("/protected", validateToken(func(w http.ResponseWriter, r *http.Request) {
   w.Write([]byte("Hello, I'm protected"))
}, srv))
```

现在整个代码看起来像这样子：

```
package main

import (
   "encoding/json"
   "fmt"
   "github.com/google/uuid"
   "gopkg.in/oauth2.v3/models"
   "log"
   "net/http"
   "time"

   "gopkg.in/oauth2.v3/errors"
   "gopkg.in/oauth2.v3/manage"
   "gopkg.in/oauth2.v3/server"
   "gopkg.in/oauth2.v3/store"
)

func main() {
   manager := manage.NewDefaultManager()
   manager.SetAuthorizeCodeTokenCfg(manage.DefaultAuthorizeCodeTokenCfg)

   // token memory store
   manager.MustTokenStorage(store.NewMemoryTokenStore())

   // client memory store
   clientStore := store.NewClientStore()
   
   manager.MapClientStorage(clientStore)

   srv := server.NewDefaultServer(manager)
   srv.SetAllowGetAccessRequest(true)
   srv.SetClientInfoHandler(server.ClientFormHandler)
   manager.SetRefreshTokenCfg(manage.DefaultRefreshTokenCfg)

   srv.SetInternalErrorHandler(func(err error) (re *errors.Response) {
      log.Println("Internal Error:", err.Error())
      return
   })

   srv.SetResponseErrorHandler(func(re *errors.Response) {
      log.Println("Response Error:", re.Error.Error())
   })

   http.HandleFunc("/token", func(w http.ResponseWriter, r *http.Request) {
      srv.HandleTokenRequest(w, r)
   })

   http.HandleFunc("/credentials", func(w http.ResponseWriter, r *http.Request) {
      clientId := uuid.New().String()[:8]
      clientSecret := uuid.New().String()[:8]
      err := clientStore.Set(clientId, &models.Client{
         ID:     clientId,
         Secret: clientSecret,
         Domain: "http://localhost:9094",
      })
      if err != nil {
         fmt.Println(err.Error())
      }

      w.Header().Set("Content-Type", "application/json")
      json.NewEncoder(w).Encode(map[string]string{"CLIENT_ID": clientId, "CLIENT_SECRET": clientSecret})
   })

   http.HandleFunc("/protected", validateToken(func(w http.ResponseWriter, r *http.Request) {
      w.Write([]byte("Hello, I'm protected"))
   }, srv))

   log.Fatal(http.ListenAndServe(":9096", nil))
}

func validateToken(f http.HandlerFunc, srv *server.Server) http.HandlerFunc {
   return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
      _, err := srv.ValidationBearerToken(r)
      if err != nil {
         http.Error(w, err.Error(), http.StatusBadRequest)
         return
      }

      f.ServeHTTP(w, r)
   })
}
```

现在运行服务并在 URL 不带有 **访问令牌** 的情况下访问 **/protected** 接口。或者尝试使用错误的 **访问令牌**。在这两种方式下鉴权服务都会阻止你。

现在再次从服务器获得**认证信息** and **访问令牌** 并发送请求到受保护的接口：

http://localhost:9096/test?access_token=YOUR_ACCESS_TOKEN

对啦！你现在有权限访问啦。

现在我们已经学会了怎么使用 Go 来设置我们自己的 OAuth2 服务器。

在下一部分中。我们会在 Go 中构建我们自己的 OAuth2 客户端。并且在最后一部分，我们会基于登录和授权构建我们自己的 **基于服务器的授权码模式**。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
