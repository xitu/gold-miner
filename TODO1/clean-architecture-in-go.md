> * 原文地址：[Clean Architecture in Go: An example of clean architecture in Go using gRPC](https://medium.com/@hatajoe/clean-architecture-in-go-4030f11ec1b1)
> * 原文作者：[Yusuke Hatanaka](https://medium.com/@hatajoe?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/clean-architecture-in-go.md](https://github.com/xitu/gold-miner/blob/master/TODO1/clean-architecture-in-go.md)
> * 译者：[yuwhuawang](https://github/yuwhuawang)
> * 校对者：[https://github.com/lihanxiang](lihanxiang), [tmpbook](https://github.com/tmpbook)

# Go 语言的整洁架构之道

## 一个使用 gRPC 的 Go 项目整洁架构例子

### 我想告诉你的是

整洁架构是现如今是非常知名的架构了。然而我们也许并不太清楚实现的细节。
因此我试着创造一个有着整洁架构的使用 gRPC 的 Go 项目。

* [hatajoe/8am: Contribute to hatajoe/8am development by creating an account on GitHub.](https://github.com/hatajoe/8am "https://github.com/hatajoe/8am")

这个小巧的项目是个用户注册的例子。请随意在本文下面回复。

### 结构

8am 基于整洁架构，项目结构如下。

```
% tree
.
├── Makefile
├── README.md
├── app
│   ├── domain
│   │   ├── model
│   │   ├── repository
│   │   └── service
│   ├── interface
│   │   ├── persistence
│   │   └── rpc
│   ├── registry
│   └── usecase
├── cmd
│   └── 8am
│       └── main.go
└── vendor
    ├── vendor packages
    |...
```

最外层目录包括三个文件夹：

*   app：应用包根目录
*   cmd：主包目录
*   vendor：一些第三方包目录

整洁架构有一些概念性的层次，如下所示：

![](https://cdn-images-1.medium.com/max/800/1*B7LkQDyDqLN3rRSrNYkETA.jpeg)

一共有 4 层，从外到内分别是蓝色，绿色，红色和黄色。我把应用目录表示为除了蓝色之外的三种颜色：

*   接口：绿色层
*   用例：红色层
*   领域：黄色层

整洁架构最重要的就是让接口穿过每一层。

### 实体 — 黄色层

在我看来, 实体层就像是分层架构里的领域层。
因此为了避变和领域驱动设计里的实体概念弄混，我把这一层叫做应用/领域层。

应用/领域包括三个包：

*   模型：包含聚合，实体和值对象
*   存储库：包含聚合对象的仓库接口
*   服务：包括依赖模型的应用服务

我将会解释每一个包的实现细节。

#### 模型

模型包含如下用户聚合：

> 这并不是真正的聚合，但是我希望你们可以将来在本地运行的时候，加入各种各样的实体和值对象。

```
package model

type User struct {
	id    string
	email string
}

func NewUser(id, email string) *User {
	return &User{
		id:    id,
		email: email,
	}
}

func (u *User) GetID() string {
	return u.id
}

func (u *User) GetEmail() string {
	return u.email
}
```

聚合就是一个事务的边界，这个事务是用来保证业务规则的一致性。因此，一个存储库就对应着一个聚合。

#### 存储库

在这一层，存储库应该只是接口，因为它不应该知晓持久化的实现细节。而且持久化也是这一层的非常重要的精髓。

用户聚合存储的实现如下：

```
package repository

import "github.com/hatajoe/8am/app/domain/model"

type UserRepository interface {
	FindAll() ([]*model.User, error)
        FindByEmail(email string) (*model.User, error)
        Save(*model.User) error
}
```

FindAll 获取了系统里所有被保存的用户。Save 则是把用户保存到系统中。我再次强调，这一层不应该知道对象被保存或者序列化到哪里了。

#### 服务

服务层是不应该包含在模型层中的业务逻辑集合。举个例子，该应用不允许任何已经存在的邮箱地址注册。如果这个验证在模型层做，我们就发现如下的错误：

```
func (u *User) Duplicated(email string) bool {
        // Find user by email from persistence layer...
}
```

`Duplicated 函数`和 `User` 模型没有关联。  
为了解决这个问题，我们可以增加服务层，如下所示：

```
type UserService struct {
        repo repository.UserRepository
}

func (s *UserService) Duplicated(email string) error {
        user, err := s.repo.FindByEmail(email)
        if user != nil {
            return fmt.Errorf("%s already exists", email)
        }
        if err != nil {
            return err
        }
        return nil
}
```

* * *

实体包括业务逻辑和穿过其他层的接口。
业务逻辑应该包含在模型和服务中，并且不应该依赖其他层。如果我们需要访问其他层，我们需要通过存储库接口。通过这样反转依赖，我们可以使这些包更加隔离，更加易于测试和维护。

### 用例 —— 红色层

用例是应用一次操作的单位。在 8am 中，列出用户和注册用户就是两个用例。这些用例的接口表示如下：

```
type UserUsecase interface {
    ListUser() ([]*User, error)
    RegisterUser(email string) error
}
```

为什么是接口？因为这些用例是在接口层 —— 绿色层被使用。在跨层的时候，我们都应该定义成接口。

__UserUsecase__ 简单实现如下：

```
type userUsecase struct {
    repo    repository.UserRepository
    service *service.UserService
}

func NewUserUsecase(repo repository.UserRepository, service *service.UserService) *userUsecase {
    return &userUsecase {
        repo:    repo,
        service: service,
    }
}

func (u *userUsecase) ListUser() ([]*User, error) {
    users, err := u.repo.FindAll()
    if err != nil {
        return nil, err
    }
    return toUser(users), nil
}

func (u *userUsecase) RegisterUser(email string) error {
    uid, err := uuid.NewRandom()
    if err != nil {
        return err
    }
    if err := u.service.Duplicated(email); err != nil {
        return err
    }
    user := model.NewUser(uid.String(), email)
    if err := u.repo.Save(user); err != nil {
        return err
    }
    return nil
}
```

__userUsercase__ 依赖两个包。__UserRepository__ 接口和 __*service.UserService*__ 结构体。当使用者初始化用例时，这两个包必须被注入。通常这些依赖都是通过依赖注入容器解决，这个后文会提到。

ListUser 这个用例会取到所有已经注册的用户，RegisterUser 用例是如果同样的邮箱地址没有被注册的话，就用该邮箱把新用户注册到系统。

有一点要注意，**User** 不同于 **model.User. model.User** 也许包含很多业务逻辑，但是其他层最好不要知道这些具体逻辑。所以我为用例 users 定义了 DAO 来封装这些业务逻辑。

```
type User struct {
    ID    string
    Email string
}

func toUser(users []*model.User) []*User {
    res := make([]*User, len(users))
    for i, user := range users {
        res[i] = &User{
            ID:    user.GetID(),
            Email: user.GetEmail(),
        }
    }
    return res
}
```

* * *

所以，为什么服务是具体实现而不是接口呢？因为服务不依赖于其他层。相反的，存储库贯穿了其他层，并且它的实现依赖于其他层不应该知道的设备细节，因此它被定义为接口。我认为这是这个架构中最重要的事情了。

### 接口 —— 绿色层

这一层放置的都是操作 API 接口，关系型数据库的存储库或者其他接口的边界的具体对象。在本例中，我加了两个具体物件，内存存取器和 gRPC 服务。

#### 内存存取器

我加了具体用户存储库作为内存存取器。

```
type userRepository struct {
    mu    *sync.Mutex
    users map[string]*User
}

func NewUserRepository() *userRepository {
    return &userRepository{
        mu:    &sync.Mutex{},
        users: map[string]*User{},
    }
}

func (r *userRepository) FindAll() ([]*model.User, error) {
    r.mu.Lock()
    defer r.mu.Unlock()

    users := make([]*model.User, len(r.users))
    i := 0
    for _, user := range r.users {
        users[i] = model.NewUser(user.ID, user.Email)
        i++
    }
    return users, nil
}

func (r *userRepository) FindByEmail(email string) (*model.User, error) {
    r.mu.Lock()
    defer r.mu.Unlock()

    for _, user := range r.users {
        if user.Email == email {
            return model.NewUser(user.ID, user.Email), nil
        }
    }
    return nil, nil
}

func (r *userRepository) Save(user *model.User) error {
    r.mu.Lock()
    defer r.mu.Unlock()

    r.users[user.GetID()] = &User{
        ID:    user.GetID(),
        Email: user.GetEmail(),
    }
    return nil
}
```

这是存储库的具体实现。如果我们想要把用户保存到数据库或者其他地方的话，需要实现一个新的存储库。尽管如此，我们也不需要修改模型层。这太神奇了。

 __User__ 只在这个包里定义。这也是为了解决不同层之间解封业务逻辑的问题。

```
type User struct {
    ID    string
    Email string
}
```

#### gRPC 服务

我认为 gRPC 服务也应该在接口层。在目录 `app/interface/rpc` 下可以看到：

```
% tree
.
├── rpc.go
└── v1.0
    ├── protocol
    │   ├── user_service.pb.go
    │   └── user_service.proto
    ├── user_service.go
    └── v1.go
```

`protocol` 文件夹包含了协议缓存 DSL 文件 (user_service.proto) 和生成的 RPC 服务
代码 (user_service.pb.go)。

`user_service.go` 是 gRPC 的端点处理程序的封装：

```
type userService struct {
    userUsecase usecase.UserUsecase
}

func NewUserService(userUsecase usecase.UserUsecase) *userService {
    return &userService{
        userUsecase: userUsecase,
    }
}

func (s *userService) ListUser(ctx context.Context, in *protocol.ListUserRequestType) (*protocol.ListUserResponseType, error) {
    users, err := s.userUsecase.ListUser()
    if err != nil {
        return nil, err
    }

    res := &protocol.ListUserResponseType{
        Users: toUser(users),
    }
    return res, nil
}

func (s *userService) RegisterUser(ctx context.Context, in *protocol.RegisterUserRequestType) (*protocol.RegisterUserResponseType, error) {
    if err := s.userUsecase.RegisterUser(in.GetEmail()); err != nil {
        return &protocol.RegisterUserResponseType{}, err
    }
    return &protocol.RegisterUserResponseType{}, nil
}

func toUser(users []*usecase.User) []*protocol.User {
 res := make([]*protocol.User, len(users))
    for i, user := range users {
        res[i] = &protocol.User{
            Id:    user.ID,
            Email: user.Email,
        }
    }
    return res
}
```

__userService__ 仅依赖用例接口。  
如果你想使用其它层（如：GUI）的用例，你可以按照你的方式实现这个接口。

`v1.go` 是使用依赖注入容器的对象依赖性解析器：

```
func Apply(server *grpc.Server, ctn *registry.Container) {
    protocol.RegisterUserServiceServer(server, NewUserService(ctn.Resolve("user-usecase").(usecase.UserUsecase)))
}
```

`v1.go` 把从 __*registry.Container*__ 取回的包应用在 gRPC 服务上。

最后，让我们看看依赖注入容器的实现。

#### 注册

注册是解决对象依赖性的依赖注入容器。
我用的依赖注入容器是 github.com/sarulabs/di。

[sarulabs/di: go (golang) 的依赖注入容器。请注册 GitHub 账号来为 sarulabs/di 开发做贡献](https://github.com/sarulabs/di "https://github.com/sarulabs/di")

github.com/surulabs/di 可以被这样简单的使用：

```
type Container struct {
    ctn di.Container
}

func NewContainer() (*Container, error) {
    builder, err := di.NewBuilder()
    if err != nil {
        return nil, err
    }

    if err := builder.Add([]di.Def{
        {
            Name:  "user-usecase",
            Build: buildUserUsecase,
        },
    }...); err != nil {
        return nil, err
    }

    return &Container{
        ctn: builder.Build(),
    }, nil
}

func (c *Container) Resolve(name string) interface{} {
    return c.ctn.Get(name)
}

func (c *Container) Clean() error {
    return c.ctn.Clean()
}

func buildUserUsecase(ctn di.Container) (interface{}, error) {
    repo := memory.NewUserRepository()
    service := service.NewUserService(repo)
    return usecase.NewUserUsecase(repo, service), nil
}
```

在上面的例子里，我用 `buildUserUsecase` 函数把字符串 `user-usecase` 和具体的用例实现联系起来。这样我们只要在一个地方注册，就可以替换掉任何用例的具体实现。

* * *

感谢你读完了这篇入门。欢迎提出宝贵意见。如果你有任何想法和改进建议，请不吝赐教！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
