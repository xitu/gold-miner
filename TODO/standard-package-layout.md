> * 原文地址：[Standard Package Layout](https://medium.com/@benbjohnson/standard-package-layout-7cdbc8391fc1)
> * 原文作者：[Ben Johnson](https://medium.com/@benbjohnson?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/standard-package-layout.md](https://github.com/xitu/gold-miner/blob/master/TODO/standard-package-layout.md)
> * 译者：[steinliber](https://github.com/steinliber)
> * 校对者：[Albert](https://github.com/Albertao)

# 标准化的包布局

![](https://cdn-images-1.medium.com/max/2000/1*9ViDbBWP6oIcfMvtc3n8_w.jpeg)

一般来说是使用 Vendoring 作为包管理工具。在 Go 社区已经可以看到一些重要的问题，但是有一个问题在社区中很少被提及，即应用的包布局。

我曾经参与编写过的每一个 Go 应用对这个问题似乎都有不同的答案， _我该如何组织我的代码？_ 。一些应用会把所有的东西都放到一个包里，而其它应用则会选择按照类型或模块来组织代码。如果没有一个适用于整个团队的策略，你将发现代码会散布在你应用不同包里面。对于 Go 应用程序包布局的设计我们需要一个更好的标准。

我提议有一个更好的方式。通过遵循一些简单的规则我们就可以解耦我们的代码，使之更易于测试并且可以使我们的项目有一致的结构，在深入探讨这个方式之前，让我们来看下目前人们组织项目一些最常见的方式。

* * *

_更新：我收到了很多关于这种方式非常棒的反馈，其中最多的是想要看到一个使用这种方式构建的应用。于是我已经开始重新写一系列文章记录使用这种包布局方式来构建应用，叫做 [_Building WTF Dial_](https://medium.com/@benbjohnson/wtf-dial-domain-model-9655cd523182)._

###  常见的有缺陷的方式

现在似乎有几种通用的 Go 应用组织方式，它们都有各自的缺陷。

#### 方法 #1： 单个包

把你所有的代码都扔进一个包，对于一个小的应用来说这样就可以很好的工作。它消除了产生循环依赖问题的可能，因为在你的应用代码中并没有任何依赖。

我曾经看到过使用这种方式构建超过 10K 行代码的应用 [SLOC](https://en.wikipedia.org/wiki/Source_lines_of_code)。但是一旦代码量超过这个数量，定位和独立你的代码将会变得非常困难。

#### 方法 #2: Rails 风格布局

另一种组织你代码的方式是根据它的功能类型。比如说，把所有你的 [处理器](https://golang.org/pkg/net/http/#Handler)，控制器，模型代码都分别放在独立的包中。我之前看到很多前 [Rails](http://rubyonrails.org/) 开发者(包括我自己)都使用这种方式来组织代码。

但是使用这种方式有两个问题。首先你的命名将会变得糟糕透顶，你最终会得到类似 _controller.UserController_ 这样的命名，在这种命名中你重复了包名和类型名。对于命名，我是一个有执念的人。我相信当你在去除无用代码时名称是你最好的文档。好的名称也是高质量代码的代表，当其他人读代码时总是最先注意到这个。

更大的问题在于循环依赖。你不同的功能类型也许需要互相引用对方。只有当你维护单向依赖关系时，这个应用才能够工作，但是在很多时候维护单向依赖并不简单。

#### 方法 #3：根据模块组织代码

这个方式类似于前面的 Rails 风格布局，但是我们是使用模块来组织代码而不是功能。比如说，你或许会有一个 _user_ 包和一个 _account_ 包。

我们发现使用这种方式也会遇到之前同样的问题。我们最后也会遇到像 _users.User._ 这样可怕的命名。如果我们的 _accounts.Controller_ 需要和 _users.Controller_ 进行交互，那么我们同样会遇到相同的循环依赖问题，反之亦然。

### 一个更好的方式

我在项目使用的包组织策略涉及到以下4个简单的原则：

1. Root 包是用于域类型的
2. 通过依赖关系来组织子包
3. 使用一个共享的 _mock_ 子包
4. __Main__ 包将依赖关系联系到一起

这些规则帮助隔离我们的包并且在整个应用中定义了一个清晰的领域语言。让我们来看看这些规则在实践中是如何使用的。

### #1. Root 包是用于域类型的

你的应用有一种用于描述数据和进程是如何交互的逻辑层面的高级语言。这就是你的域。如果你有一个电子商务应用，那你的域就会涉及到客户，账户，信用卡支付，以及存货等内容。如果你的应用是 Facebook，你的域就会是用户，点赞以及用户间的关系。这些是不依赖于你基础技术的东西。

我把我的域类型放在 root 保存。这个包只包含了简单的数据类型，比如说包含用户信息的  _User_ 结构或者是获取和保存用户数据的 _UserService_ 接口。

这个 root 包会像以下这样：

```
package myapp

type User struct {
	ID      int
	Name    string
	Address Address
}

type UserService interface {
	User(id int) (*User, error)
	Users() ([]*User, error)
	CreateUser(u *User) error
	DeleteUser(id int) error
}
```

这使你的 root 包变的非常简单。你也可以在这个包里放包含执行操作的类型，但是它们应该只依赖于其它的域类型。比如说，你可以在这个包加一个定期轮询 _UserService_ 的类型。但是，它不应该调用外部服务或者将数据保存到数据库。这些是实现细节。

_root 包不应该依赖于你应用中的其它任何包_

### #2. 通过依赖关系来组织子包

如果你的 root 包并不允许有外部依赖，那么我们就必须把这些依赖放到子包里。在这种包布局的方式中，子包就相当于你域和实现之间的适配器。

比如说，你的 _UserService_ 可能是由 PostgreSQL 数据库提供支持。你可以在应用中引入一个叫做 _postgres_ 的子包用来提供 _postgres.UserService_ 的实现。

```
package postgres

import (
	"database/sql"

	"github.com/benbjohnson/myapp"
	_ "github.com/lib/pq"
)

// UserService represents a PostgreSQL implementation of myapp.UserService.
type UserService struct {
	DB *sql.DB
}

// User returns a user for a given id.
func (s *UserService) User(id int) (*myapp.User, error) {
	var u myapp.User
	row := db.QueryRow(`SELECT id, name FROM users WHERE id = $1`, id)
	if row.Scan(&u.ID, &u.Name); err != nil {
		return nil, err
	}
	return &u, nil
}

// implement remaining myapp.UserService interface...
```

这样就隔离了我们对 PostgreSQL 的依赖关系，从而简化了测试，并为我们将来迁移到其它数据库提供了一种简单的方法。如果你打算支持像 [BoltDB](https://github.com/boltdb/bolt) 这种数据库的实现，就可以把它看作是一个可插拔体系结构。

这也为你实现层级提供了一种方式。比如说你想要在 Postgresql 前面加一个内存缓存 [LRU cache](https://en.wikipedia.org/wiki/Cache_algorithms)。你可以添加一个 _UserCache_ 类型来包装你的 Postgresql 实现。

```
package myapp

// UserCache wraps a UserService to provide an in-memory cache.
type UserCache struct {
        cache   map[int]*User
        service UserService
}

// NewUserCache returns a new read-through cache for service.
func NewUserCache(service UserService) *UserCache {
        return &UserCache{
                cache: make(map[int]*User),
                service: service,
        }
}

// User returns a user for a given id.
// Returns the cached instance if available.
func (c *UserCache) User(id int) (*User, error) {
	// Check the local cache first.
        if u := c.cache[id]]; u != nil {
                return u, nil
        }

	// Otherwise fetch from the underlying service.
        u, err := c.service.User(id)
        if err != nil {
        	return nil, err
        } else if u != nil {
        	c.cache[id] = u
        }
        return u, err
}
```

我们也可以在标准库中看到使用这种方式组织代码。_io._ [_Reader_](https://golang.org/pkg/io/#Reader) 是一个用于读取字节的域类型，它的实现是通过组织依赖关系 _tar._[_Reader_](https://golang.org/pkg/archive/tar/#Reader)，_gzip._[_Reader_](https://golang.org/pkg/compress/gzip/#Reader)，
_multipart._[_Reader_](https://golang.org/pkg/mime/multipart/#Reader) 来实现的。在标准库中也可以看到层级方式，经常可以看到 _os._[_File_](https://golang.org/pkg/os/#File) 被 _bufio._[_Reader_](https://golang.org/pkg/bufio/#Reader)，_gzip._[_Reader_](https://golang.org/pkg/compress/gzip/#Reader)， _tar._[_Reader_](https://golang.org/pkg/archive/tar/#Reader) 这样一个个层级封装。

#### 依赖之间的依赖

依赖关系并不是孤立的。你可以把 _User_ 数据保存在 Postgresql 中，而把金融交易数据保存在像 [Stripe](https://stripe.com/) 这样的第三方服务。在这种情况下我们用一个逻辑上的域类型来封装对 Stripe 的依赖，让我们把它叫做 _TransactionService_ 。

通过把我们的  _TransactionService_ 添加到  _UserService_ ，我们解耦了我们的两个依赖。

```
type UserService struct {
        DB *sql.DB
        TransactionService myapp.TransactionService
}
```

现在我们的依赖只通过共有的领域语言交流。这意味着我们可以把 Postgresql 切换为 MySQL 或者把 Strip 切换为另一个支付的内部处理器而不用担心影响到其它的依赖。

#### 不要只对第三方的依赖添加这个限制

这听起来虽然有点奇怪，但是我也使用这种方式来隔离对标准库的依赖关系。例如 _net/http_ 包只是另一种依赖。我们可以通过在应用中包含一个 _http_ 子包来隔离对它的依赖。

有一个名称与它所包装依赖相同的包看起来似乎很奇怪，但是这只是内部实现。除非你允许你应用的其它部分使用 _net/http_ ，否则在你的应用中就不会有命名冲突。复制 _http_ 名称的好处在于它要求你把所有 HTTP 相关代码都隔离到 _http_ 包中。

```
package http

import (
        "net/http"
        
        "github.com/benbjohnson/myapp"
)

type Handler struct {
        UserService myapp.UserService
}

func (h *Handler) ServeHTTP(w http.ResponseWriter, r *http.Request) {
        // handle request
}
```

现在，你的  _http.Handler_  就像是一个在域和 HTTP 协议之前的适配器。

### #3. 使用一个共享的 mock 子包

因为我们的依赖通过域接口已经和其它的依赖隔离了，所以我们可以使用这些连接点来注入模拟实现。

这里有几个像 [GoMock](https://github.com/golang/mock) 的模拟库来帮你生成模拟数据，但是我个人更喜欢自己写。我发现许多的模拟工具都过于复杂了。

我使用的模拟非常简单。比如说，一个对  _UserService_ 的模拟就像下面这样：

```
package mock

import "github.com/benbjohnson/myapp"

// UserService represents a mock implementation of myapp.UserService.
type UserService struct {
        UserFn      func(id int) (*myapp.User, error)
        UserInvoked bool

        UsersFn     func() ([]*myapp.User, error)
        UsersInvoked bool

        // additional function implementations...
}

// User invokes the mock implementation and marks the function as invoked.
func (s *UserService) User(id int) (*myapp.User, error) {
        s.UserInvoked = true
        return s.UserFn(id)
}

// additional functions: Users(), CreateUser(), DeleteUser()
```

这个模拟让我可以注入函数到任何使用 _myapp.UserService_ 的接口来验证参数，返回预期的数据或者注入失败。

假设我们想测试我们上面构建的 _http.Handler_ ：

```
package http_test

import (
	"testing"
	"net/http"
	"net/http/httptest"

	"github.com/benbjohnson/myapp/mock"
)

func TestHandler(t *testing.T) {
	// Inject our mock into our handler.
	var us mock.UserService
	var h Handler
	h.UserService = &us

	// Mock our User() call.
	us.UserFn = func(id int) (*myapp.User, error) {
		if id != 100 {
			t.Fatalf("unexpected id: %d", id)
		}
		return &myapp.User{ID: 100, Name: "susy"}, nil
	}

	// Invoke the handler.
	w := httptest.NewRecorder()
	r, _ := http.NewRequest("GET", "/users/100", nil)
	h.ServeHTTP(w, r)
	
	// Validate mock.
	if !us.UserInvoked {
		t.Fatal("expected User() to be invoked")
	}
}
```

我们的模拟完全隔离了我们的单元测试，让我们只测试 HTTP 协议的处理。

### #4. __Main__ 包将依赖关系联系到一起

当所有这些依赖包独立维护时，你可能想知道如何把它们聚合到一起。这就是 _main_ 包的工作。

#### Main 包布局

一个应用可能会产生多个二进制文件， 所以我们使用 Go 的惯例把我们的 _main_ 包作为 _cmd_ 包的子目录。 比如，我们的项目中可能有一个 _myapp_ 服务二进制文件，还有一个用于在终端管理服务 的 _myappctl_ 客户端二进制文件。我们的包将像这样布局：

```
myapp/
    cmd/
        myapp/
            main.go
        myappctl/
            main.go
```

#### 在编译时注入依赖

"依赖注入"这个词已经成了一个不好的说法，它让人联想到 [Spring](https://projects.spring.io/spring-framework/) 冗长的XML文件。然而，这个术语所代表的真正含义只是要把依赖关系传递给我们的对象，而不是要求对象构建或者找到这个依赖关系本身。

在 _main_ 包中我们可以选择哪些依赖注入到哪些对象中。因为 _main_ 包只是简单的连接了各部分，所以 _main_ 中的代码往往是比较小和琐碎的。

```
package main

import (
	"log"
	"os"
	
	"github.com/benbjohnson/myapp"
	"github.com/benbjohnson/myapp/postgres"
	"github.com/benbjohnson/myapp/http"
)

func main() {
	// Connect to database.
	db, err := postgres.Open(os.Getenv("DB"))
	if err != nil {
		log.Fatal(err)
	}
	defer db.Close()

	// Create services.
	us := &postgres.UserService{DB: db}

	// Attach to HTTP handler.
	var h http.Handler
	h.UserService = us
	
	// start http server...
}
```

注意到你的 _main_ 包也是一个适配器很重要。他把所有终端连接到你的域。

### 结论

应用设计是一个难题。尽管做出了这么多的设计决策，如果没有一套坚实的原则来指导，那你的问题只会变的更糟。我们已经列举了 Go 应用布局设计的几种方式，并且我们也看到了很多它们的缺陷。

我相信从依赖关系的角度来看待设计会使代码组织的更简单，更加容易理解。首先我们设计我们的领域语言，然后我们隔离我们的依赖关系，之后介绍了使用 mock 来隔离我们的测试，最后我们把所有东西都在 _main_ 包中绑了起来。

可以在下一个你设计的应用中考虑下这些原则。如果有您有任何问题或者想讨论这个设计，请在 Twitter 上 @[benbjohnson](https://twitter.com/benbjohnson)与我联系，或者在[Gopher slack](https://gophersinvite.herokuapp.com/) 查找 _benbjohnson_  来找到我。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。


