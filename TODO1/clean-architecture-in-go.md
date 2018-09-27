> * 原文地址：[Clean Architecture in Go: An example of clean architecture in Go using gRPC](https://medium.com/@hatajoe/clean-architecture-in-go-4030f11ec1b1)
> * 原文作者：[Yusuke Hatanaka](https://medium.com/@hatajoe?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/clean-architecture-in-go.md](https://github.com/xitu/gold-miner/blob/master/TODO1/clean-architecture-in-go.md)
> * 译者：
> * 校对者：

# Clean Architecture in Go

## An example of clean architecture in Go using gRPC

### What I want to tell you

Clean architecture is well known architecture these days. However, we may not know about details of the implementation very well.  
So I tried to make one example that is conscious of clean architecture in Go using gRPC.

* [hatajoe/8am: Contribute to hatajoe/8am development by creating an account on GitHub.](https://github.com/hatajoe/8am "https://github.com/hatajoe/8am")

This small project represents user registration example. Please feel free to respond anything.

### The Structure

8am is based on clean architecture, the project structure is like below.

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

The top directory contains three directories:

*   app: application package root directory
*   cmd: main package directory
*   vendor: several vendor packages directory

Clean architecture has some conceptual layer like below:

![](https://cdn-images-1.medium.com/max/800/1*B7LkQDyDqLN3rRSrNYkETA.jpeg)

There are 4 layers, blue, green, red and yellow layers there in order from the outside. I represented these layers except blue to the app directory:

*   interface: the green layer
*   usecase: the red layer
*   domain: the yellow layer

The most important thing about clean architecture is to make interfaces through each layer.

### Entities — the yellow layer

IMO, the Entities layer looks like a domain layer of the layered architecture.  
So I named this layer to app/domain due to that is confused with the entity of DDD.

app/domain has three packages:

*   model: has aggregate, entity and value object
*   repository: has repository interfaces of aggregate
*   service: has application services that depend on several models

I explain what detail of implementation for each package.

#### model

model has user aggregate like below:

> This is not actually aggregate, but I hope you will be on a premise that various entity and value object will be added in the future.

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

The aggregate is the boundary of a transaction in order to keep their consistency of business rules. Thus there is one repository against the one aggregate.

#### repository

In this layer, the repository is just an interface because of that should not know about the detail of persistence implementation. But also persistence is an important essence for this layer.

implementation of the user aggregate repository is:

```
package repository

import "github.com/hatajoe/8am/app/domain/model"

type UserRepository interface {
	FindAll() ([]*model.User, error)
        FindByEmail(email string) (*model.User, error)
        Save(*model.User) error
}
```

FindAll fetches all users who are persisted in the system. And Save persists user to the system. I say it again, this layer should not know what where is the object is saved or serialized.

#### service

The service layer is gathered business logic that should not be included in the model. For example, this application don’t allow existing email address registration. If model has this validation, we will get to feel something wrong like below:

```
func (u *User) Duplicated(email string) bool {
        // Find user by email from persistence layer...
}
```

`Duplicated function` is not related to `User` model.  
For solving this, we can add the service layer like below:

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

Entities contain business logic and interface through the other layers.  
Business logic should be included in the model and service, and should not be depended any other layers. If we need to access any other layer, we should through the layers using repository interface. By inverting the dependencies like this, may packages to be isolated, more testable and maintainable.

### Use Cases — the red layer

Use cases are unit of the one operation for application.  
In 8am, listing user and user registration are defined as use case.  
Those use cases are represented this interface below:

```
type UserUsecase interface {
    ListUser() ([]*User, error)
    RegisterUser(email string) error
}
```

Why is it an interface? This is because use case is used from interface layer — the green layer. We should always define interface if we are going to through between layers.

_UserUsecase_ implementation is simple like below:

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

_userUsercase_ depend two packages _repository.UserRepository_ interface and _*service.UserService_ struct. These two packages are must injected when use case initialize by use case user. Those dependencies are solved by DI container in normally, this will be wrote later in this entry.

ListUser use case fetch all registered users and RegisterUser use case register a user to the system if it is not registered same email address.

One point, the _User_ is not _model.User. model.User_ may has many business knowledges, but other layers should not better to know about that. So I defined DAO for use case users due to encapsulate the knowledges.

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

So, why do you think about this service is used as concrete implementation instead of using interface? This is because that this service depends no other layers. Conversely, the repository through layers and the implementation depends detail of devices that should not known from other layer, thus that was defined an interface. I think this is a most important thing in this architecture.

### Interface — the green layer

This layer is placed the concrete object like handler of the API endpoint, repository of the RDB or other boundaries for interfaces. In this case, I added two concrete objects that memory storage accessor and gRPC service.

#### Memory storage accessor

I added concrete user repository as memory storage accessor.

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

This is concrete implementation of repository. We’ll need to another implementation if we need to persist the user to the RDB or other. But even in such case, we don’t need to change the model layer. The model layer is depending for only repository interface, and not interest for this implementation detail. This is amazing.

This _User_ is defined for only in this package. This also for solving about decapsulating of knowledge through between the layers.

```
type User struct {
    ID    string
    Email string
}
```

#### gRPC service

I think gRPC service is also included the interface layer.  
These are defined `app/interface/rpc` directory like below:

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

`protocol` directory contains protocol buffers DSL file(user_service.proto) and generated RPC service code(user_service.pb.go).

`user_service.go` is the wrapper of gRPC endpoint handler:

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

_userService_ depends for only use case interface.  
If you want to use use case from another layer (e.g, CUI), you can implement in this interface layer as you like.

`v1.go` is resolver of object dependencies using DI container:

```
func Apply(server *grpc.Server, ctn *registry.Container) {
    protocol.RegisterUserServiceServer(server, NewUserService(ctn.Resolve("user-usecase").(usecase.UserUsecase)))
}
```

`v1.go` apply package that was retrieved from _*registry.Container_ to gRPC service.

At the last, let’s take a look about DI container implementation.

#### registry

The registry is DI container that resolve dependency of object.  
I have been used github.com/sarulabs/di as DI container.

[sarulabs/di: Dependency injection container in go (golang). Contribute to sarulabs/di development by creating an account on GitHub.](https://github.com/sarulabs/di "https://github.com/sarulabs/di")

github.com/surulabs/di can be used easily:

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

For example in above, I associate `user-usecase` string with concrete use case implementation by using `buildUserUsecase` function. Thus we can replace any concrete implementation of use case in one place registry.

* * *

Thank you for reading this entry. Feedback is welcome. You have any ideas and improvements feel free to respond me!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
