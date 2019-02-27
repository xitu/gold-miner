> * 原文地址：[Build your Own OAuth2 Server in Go: Client Credentials Grant Flow](https://hackernoon.com/build-your-own-oauth2-server-in-go-7d0f660732c3)
> * 原文作者：[Cyan Tarek](https://hackernoon.com/@cyantarek)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/build-your-own-oauth2-server-in-go.md](https://github.com/xitu/gold-miner/blob/master/TODO1/build-your-own-oauth2-server-in-go.md)
> * 译者：
> * 校对者：

# Build your Own OAuth2 Server in Go: Client Credentials Grant Flow

![](https://cdn-images-1.medium.com/max/2600/0*mtbIDJPdV4cD8Xgo)

Hello, in today’s article, I will show you how you can build your own OAuth2 server just like google, facebook, github etc.

This will be very helpful if you want to build a production ready public or private API. So let’s get started.

### What is OAuth2?

Open Authorization Version 2.0 is known as OAuth2. It’s one kind of protocol or framework to secure RESTful Web Services. OAuth2 is very powerful. Now a days, majority of the REST API are protected with OAuth2 due to it’s rock solid security.

#### OAuth2 has two parts

01. Client

02. Server

### OAuth2 Client

![](https://cdn-images-1.medium.com/max/1600/0*ojCsrGLMlae6xw62.png)

If you’re familiar with this screen, you know what I’m talking about. Anyway, Let me explain the story behind the image:

You’re building a user facing application that works with user’s github repositories. For example: CI tools like TravisCI, CircleCI, Drone etc.

But user’s github account is secured and no one can access it if the owner doesn’t want. So how do these CI tools access user’s github account and repositories?

Easy.

Your application will ask the user

> **“In order to work with us, you need to give read access to your github repos. Do you agree?”**

Then the user will say

> **“Yes I do. And do whatever needs to do”.**

Then your application will contact github’s authority to grant access to that particular user’s github account. Github will check if it’s true and ask that user to authorize. Then github will issue an ephemeral token to the client.

Now, when your application needs to access it after the authentication and authorization, it needs to send the access token with the request so that github will think:

> **“Oh, the access token looks familiar, may be we have given that to you. Ok, you can access”**

That’s the long story. Days have changed, now you don’t need to go to github authority physically each time (we never had to do that). Everything can be done automatically.

But how?

![](https://cdn-images-1.medium.com/max/1600/0*wGuxcdSwF1vaOaH9)

This is a UML sequence diagram of what I have talked couple of minutes ago. Just graphical representation.

From the above picture, we found some important things.

**OAuth2 has 4 roles:**

01. User — The end user who will use your application

02. Client — The application you’re building that will use github account and the user will use

03. Auth Server — The server that deals with the main OAuth things

04. Resource Server — The server that has the protected resources. For example github

Client sends OAuth2 request to the auth server on behalf of the user.

Building an OAuth2 client is neither easy nor hard. Sounds funny, right? We’ll do that in the next part.

But in this part, we’ll go to the other side of the world. We’ll build our own OAuth2 Server. Which is not easy but juicy.

Ready? Let’s go

### OAuth2 Server

You may ask me

> **“Wait a minute Cyan, why building an OAuth2 server?”**

Did you forget man? I have said this earlier. Ok, let me tell you again.

Imagine, you’re building a very useful application that gives accurate weather information (there are plenty of this kind of api out there). Now you want to make it open so that public can use it or you want to make money with it.

Whatever the case is, you need to protect your resources from un-authorized access or malicious attacks. In order to do that you need to secure your API resources. Here comes the OAuth2 thingy. Bingo!

From the picture above, we can see that we need place an Auth Server in front of our REST API Resource Server. That’s what we’re talking about. The Auth Server will be built using OAuth2 specification. Then we’ll become the github of the first picture, hahahaha just kidding.

The primary goal of the OAuth2 server is to provide access token to the client. That’s why OAuth2 Server is also known as OAuth2 Provider, because they provide token.

Enough talking.

**There are four types of OAuth2 server based of the Grant Flow type:**

01. Authorization Code Grant

02. Implicit Grant

03. Client Credentials Grant

04. Password Grant

If you want to know more about OAuth2, check out [**this**](https://itnext.io/an-oauth-2-0-introduction-for-beginners-6e386b19f7a9) awesome article.

For this article, we’ll use **Client Credentials Grant Type**. So let’s dig in

### Client Credentials Grant Flow Based Server

When implementing Client Credentials Grant Flow based OAuth2 Server, we need to know couple of things.

In this grant type, there’s no user interaction (i.e. signup, sign-in). Two things needed, and they are the **client_id** and the **client_secret**. With this two things, we can obtain **access_token**. Client is the 3rd party application. When you need to access resource server without the user or only by the client application, then this grant type is simple and best suited.

![](https://cdn-images-1.medium.com/max/1600/0*7X5b1VSQ2zC4MMin.png)

Here’s a UML Sequence Diagram of it.

### Coding

To build this, we need to rely on an awesome Go package

First of all, let’s build a simple API server as Resource Server

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

Run the server and send a Get Request to [http://localhost:9096/protected](http://localhost:5555/protected)

You’ll get response.

What kind of protected server it is?

Though the endpoint name is protected, but anyone can access it. So we need to protect it with OAuth2.

Now we’ll write our authorization server

#### Routes

01. **/credentials** for issuing client credentials (client_id and client_secret)

02. **/token** to issue token with client credentials

We need to implement these two routes.

Here’s the preliminary setup

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

Here we created one manager, client store and the auth server itself.

Here’s the **/credentials** route

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

It creates two random string, one for client_id and another for client_secret. Then saves them to the client store. And return them as response. That’s it. We used in memory store, but we can store them in redis, mongodb, postgres etc.

Here’s the **/token** route:

```
http.HandleFunc("/token", func(w http.ResponseWriter, r *http.Request) {
   srv.HandleTokenRequest(w, r)
})
```

It’s very simple. It passes the request and response to the appropriate handler so that the servwr can decode all the necessary data from the request payload.

So here’s our overall code:

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

Run the code and go to [http://localhost:9096/credentials](http://localhost:9096/credentials) route to register and get client_id and client_secret

Now go to this URL http://localhost:9096/token?grant_type=client_credentials&client_id=2e14f7dd&client_secret=c729e9d0&scope=all

You”ll get the access_token with expiry time and some other information.

Now we got our access_token. But our /protected route is still un-protected. We need to setup a way that will check if a valid token exists with each client request. If yes, then we give the client access. Otherwise not.

We can do this with a middleware.

Writing middleware in go is ao much fun if you know what you are doing. Here’s the middleware:

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

This will check if a valid token is given with the request and take action based on that.

Now we need to put this middleware in front of our /protected route using adapter/decorator pattern

```
http.HandleFunc("/protected", validateToken(func(w http.ResponseWriter, r *http.Request) {
   w.Write([]byte("Hello, I'm protected"))
}, srv))
```

Now the whole code looks like this:

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

Now run the server and try to access **/protected** endpoint without the **access_token** as URL Query. Then try to give wrong **access_token**. Either way, the auth server will stop you.

Now get the **credentials** and **access_token** again from the server and send request to the protected endpoint :

http://localhost:9096/test?access_token=YOUR_ACCESS_TOKEN

Bingo! You’ll get access to it.

So we’ve learned how to setup our own OAuth2 Server using Go.

In the next part, we’ll build our OAuth2 client in Go. And in the last part, we’ll build the **Authorization Code Grant Type Based Server** with user login and authorization.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
