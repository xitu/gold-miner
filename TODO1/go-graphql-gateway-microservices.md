> * 原文地址：[Using GraphQL with Microservices in Go](https://outcrawl.com/go-graphql-gateway-microservices/)
> * 原文作者：[Tin Rabzelj](https://outcrawl.com/authors/tin-rabzelj)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/go-graphql-gateway-microservices.md](https://github.com/xitu/gold-miner/blob/master/TODO1/go-graphql-gateway-microservices.md)
> * 译者：[Changkun Ou](https://github.com/changkun)
> * 校对者：[razertory](https://github.com/razertory)

# 使用 Go 编写微服务及其 GraphQL 网关

![](https://outcrawl.com/static/cover-4772a81f84b65ba37535f8c41959eeaa-08884.jpg)

几个月前，一个优秀的 GraphQL Go 包 [vektah/gqlgen](https://github.com/vektah/gqlgen) 开始流行。本文描述了在 Spidey 项目（一个在线商店的基本微服务）中如何实现 GraphQL。

下面列出的一些代码可能存在一些缺失，完整的代码请访问 [GitHub](https://github.com/tinrab/spidey)。

## 架构

Spidey 包含了三个不同的服务并暴露给了 GraphQL 网关。集群内部的通信则通过 [gRPC](https://grpc.io) 来完成。

账户服务管理了所有的账号；目录服务管理了所有的产品；订单服务则处理了所有的订单创建行为。它会与其他两个服务进行通信来告知订单是否正常完成。

![Architecture](https://outcrawl.com/static/architecture-7b089f424d0abd2c29eb2d51ed362550-0381e.jpg)

独立的服务包含三层：**Server 层**、**Service 层**以及**Repository 层**。服务端作负责通信，也就是 Spidey 中使用 gRPC。服务则包含了业务逻辑。仓库则负责对数据库进行读写操作。

## 起步

运行 Spidey 需要 [Docker](https://docs.docker.com/install/)、 [Docker Compose](https://docs.docker.com/compose/install/)、 [Go](https://golang.org/doc/install)、 [Protocol Buffers](https://github.com/google/protobuf) 编译器及其 Go 插件以及非常有用的 [vektah/gqlgen](https://github.com/vektah/gqlgen) 包。

你还需要安装 [vgo](https://www.godoc.org/golang.org/x/vgo)（一个处于早期开发阶段的包管理工具）。工具 [dep](https://github.com/golang/dep) 也是一种选择，但是包含的 `go.mod` 文件会被忽略。

> 译注：在 Go 1.11 中 vgo 作为官方集成的 Go Modules 发布，已集成在 go 命令中，使用 go mod 进行使用，指令与 vgo 基本一致。

## Docker 设置

每个服务在其自身的子文件夹中实现，并至少包含一个 `app.dockerfile` 文件。`app.dockerfile` 文件用户构建数据库镜像。

```
account
├── account.proto
├── app.dockerfile
├── cmd
│   └── account
│       └── main.go
├── db.dockerfile
└── up.sql
```

所有服务通过外部的 [docker-compose.yaml](https://github.com/tinrab/spidey/blob/master/docker-compose.yaml) 定义。

下面是截取的一部分关于 Account 服务的内容：

```yaml
version: "3.6"

services:
  account:
    build:
      context: "."
      dockerfile: "./account/app.dockerfile"
    depends_on:
      - "account_db"
    environment:
      DATABASE_URL: "postgres://spidey:123456@account_db/spidey?sslmode=disable"
  account_db:
    build:
      context: "./account"
      dockerfile: "./db.dockerfile"
    environment:
      POSTGRES_DB: "spidey"
      POSTGRES_USER: "spidey"
      POSTGRES_PASSWORD: "123456"
    restart: "unless-stopped"
```

设置 `context` 的目的是保证 `vendor` 目录能够被复制到 Docker 容器中。所有服务共享相同的依赖、某些服务还依赖其他服务的定义。

## 账户服务

账户服务暴露了创建以及索引账户的方法。

### 服务

账户服务的 API 定义的接口如下：

[account/service.go](https://github.com/tinrab/spidey/blob/master/account/service.go)

```go
type Service interface {
  PostAccount(ctx context.Context, name string) (*Account, error)
  GetAccount(ctx context.Context, id string) (*Account, error)
  GetAccounts(ctx context.Context, skip uint64, take uint64) ([]Account, error)
}

type Account struct {
  ID   string `json:"id"`
  Name string `json:"name"`
}
```

实现需要用到 Repository：

```go
type accountService struct {
  repository Repository
}

func NewService(r Repository) Service {
  return &accountService{r}
}
```

这个服务负责了所有的业务逻辑。`PostAccount` 函数的实现如下：

```go
func (s *accountService) PostAccount(ctx context.Context, name string) (*Account, error) {
  a := &Account{
    Name: name,
    ID:   ksuid.New().String(),
  }
  if err := s.repository.PutAccount(ctx, *a); err != nil {
    return nil, err
  }
  return a, nil
}
```

它将线路协议解析处理为服务端，并将数据库处理为 Repository。

### 数据库

一个账户的数据模型非常简单：

```sql
CREATE TABLE IF NOT EXISTS accounts (
  id CHAR(27) PRIMARY KEY,
  name VARCHAR(24) NOT NULL
);
```

上面定义数据的 SQL 文件会复制到 Docker 容器中执行。

[account/db.dockerfile](https://github.com/tinrab/spidey/blob/master/account/db.dockerfile)

```
FROM postgres:10.3

COPY up.sql /docker-entrypoint-initdb.d/1.sql

CMD ["postgres"]
```

PostgreSQL 数据库通过下面的 Repository 接口进行访问：

[account/repository.go](https://github.com/tinrab/spidey/blob/master/account/repository.go)

```
type Repository interface {
  Close()
  PutAccount(ctx context.Context, a Account) error
  GetAccountByID(ctx context.Context, id string) (*Account, error)
  ListAccounts(ctx context.Context, skip uint64, take uint64) ([]Account, error)
}
```

Repository 基于 Go 标准库 SQL 包进行封装：

```
type postgresRepository struct {
  db *sql.DB
}

func NewPostgresRepository(url string) (Repository, error) {
  db, err := sql.Open("postgres", url)
  if err != nil {
    return nil, err
  }
  err = db.Ping()
  if err != nil {
    return nil, err
  }
  return &postgresRepository{db}, nil
}
```

### gRPC

账户服务的 gRPC 服务定义了下面的 Protocol Buffer：

[account/account.proto](https://github.com/tinrab/spidey/blob/master/account/account.proto)

```protobuf
syntax = "proto3";
package pb;

message Account {
  string id = 1;
  string name = 2;
}

message PostAccountRequest {
  string name = 1;
}

message PostAccountResponse {
  Account account = 1;
}

message GetAccountRequest {
  string id = 1;
}

message GetAccountResponse {
  Account account = 1;
}

message GetAccountsRequest {
  uint64 skip = 1;
  uint64 take = 2;
}

message GetAccountsResponse {
  repeated Account accounts = 1;
}

service AccountService {
  rpc PostAccount (PostAccountRequest) returns (PostAccountResponse) {}
  rpc GetAccount (GetAccountRequest) returns (GetAccountResponse) {}
  rpc GetAccounts (GetAccountsRequest) returns (GetAccountsResponse) {}
}
```

由于这个包被设置为了 `pb`，于是生成的代码可以从 `pb` 子包导入使用。

gRPC 的代码可以使用 Go 的 `generate` 指令配合 [account/server.go](https://github.com/tinrab/spidey/blob/master/account/server.go) 文件最上方的注释进行编译生成：

[account/server.go](https://github.com/tinrab/spidey/blob/master/account/server.go)

```go
//go:generate protoc ./account.proto --go_out=plugins=grpc:./pb
package account
```

运行下面的命令就可以将代码生成到 `pb` 子目录：

```bash
$ go generate account/server.go
```

服务端作为 `Service` 服务接口的适配器，对应转换了请求和返回的类型。

```go
type grpcServer struct {
  service Service
}

func ListenGRPC(s Service, port int) error {
  lis, err := net.Listen("tcp", fmt.Sprintf(":%d", port))
  if err != nil {
    return err
  }
  serv := grpc.NewServer()
  pb.RegisterAccountServiceServer(serv, &grpcServer{s})
  reflection.Register(serv)
  return serv.Serve(lis)
}
```

下面是 `PostAccount` 函数的实现：

```go
func (s *grpcServer) PostAccount(ctx context.Context, r *pb.PostAccountRequest) (*pb.PostAccountResponse, error) {
  a, err := s.service.PostAccount(ctx, r.Name)
  if err != nil {
    return nil, err
  }
  return &pb.PostAccountResponse{Account: &pb.Account{
    Id:   a.ID,
    Name: a.Name,
  }}, nil
}
```

### 用法

gRPC 服务端在 [account/cmd/account/main.go](https://github.com/tinrab/spidey/blob/master/account/cmd/account/main.go) 文件中进行初始化：

```go
type Config struct {
  DatabaseURL string `envconfig:"DATABASE_URL"`
}

func main() {
  var cfg Config
  err := envconfig.Process("", &cfg)
  if err != nil {
    log.Fatal(err)
  }

  var r account.Repository
  retry.ForeverSleep(2*time.Second, func(_ int) (err error) {
    r, err = account.NewPostgresRepository(cfg.DatabaseURL)
    if err != nil {
      log.Println(err)
    }
    return
  })
  defer r.Close()

  log.Println("Listening on port 8080...")
  s := account.NewService(r)
  log.Fatal(account.ListenGRPC(s, 8080))
}
```

客户端结构体的实现位于 [account/client.go](https://github.com/tinrab/spidey/blob/master/account/client.go) 文件中。这样账户服务就可以在无需了解 RPC 内部实现的情况下进行实现，我们之后再来详细讨论。

```go
account, err := accountClient.GetAccount(ctx, accountId)
if err != nil {
  log.Fatal(err)
}
```

## 目录服务

目录服务负责处理 Spidey 商店的商品。它实现了类似于账户服务的功能，但是使用了 Elasticsearch 对商品进行持久化。

### 服务

目录服务遵循下面的接口：

[catalog/service.go](https://github.com/tinrab/spidey/blob/master/catalog/service.go)

```go
type Service interface {
  PostProduct(ctx context.Context, name, description string, price float64) (*Product, error)
  GetProduct(ctx context.Context, id string) (*Product, error)
  GetProducts(ctx context.Context, skip uint64, take uint64) ([]Product, error)
  GetProductsByIDs(ctx context.Context, ids []string) ([]Product, error)
  SearchProducts(ctx context.Context, query string, skip uint64, take uint64) ([]Product, error)
}

type Product struct {
  ID          string  `json:"id"`
  Name        string  `json:"name"`
  Description string  `json:"description"`
  Price       float64 `json:"price"`
}
```

### 数据库

 Repository 基于 Elasticsearch [olivere/elastic](https://github.com/olivere/elastic) 包进行实现。

[catalog/repository.go](https://github.com/tinrab/spidey/blob/master/catalog/repository.go)

```go
type Repository interface {
  Close()
  PutProduct(ctx context.Context, p Product) error
  GetProductByID(ctx context.Context, id string) (*Product, error)
  ListProducts(ctx context.Context, skip uint64, take uint64) ([]Product, error)
  ListProductsWithIDs(ctx context.Context, ids []string) ([]Product, error)
  SearchProducts(ctx context.Context, query string, skip uint64, take uint64) ([]Product, error)
}
```

由于 Elasticsearch 将文档和 ID 分开存储，因此实现的一个商品的辅助结构没有包含 ID：

```go
type productDocument struct {
  Name        string  `json:"name"`
  Description string  `json:"description"`
  Price       float64 `json:"price"`
}
```

将商品插入到数据库中：

```go
func (r *elasticRepository) PutProduct(ctx context.Context, p Product) error {
  _, err := r.client.Index().
    Index("catalog").
    Type("product").
    Id(p.ID).
    BodyJson(productDocument{
      Name:        p.Name,
      Description: p.Description,
      Price:       p.Price,
    }).
    Do(ctx)
  return err
}
```

### gRPC

目录服务的 gRPC 服务定义在 [catalog/catalog.proto](https://github.com/tinrab/spidey/blob/master/catalog/catalog.proto) 文件中，并在 [catalog/server.go](https://github.com/tinrab/spidey/blob/master/catalog/server.go) 中进行实现。与账户服务不同的是，它没有在服务接口中定义所有的 endpoint。

[catalog/catalog.proto](https://github.com/tinrab/spidey/blob/master/catalog/catalog.proto)

```protobuf
syntax = "proto3";
package pb;

message Product {
  string id = 1;
  string name = 2;
  string description = 3;
  double price = 4;
}

message PostProductRequest {
  string name = 1;
  string description = 2;
  double price = 3;
}

message PostProductResponse {
  Product product = 1;
}

message GetProductRequest {
  string id = 1;
}

message GetProductResponse {
  Product product = 1;
}

message GetProductsRequest {
  uint64 skip = 1;
  uint64 take = 2;
  repeated string ids = 3;
  string query = 4;
}

message GetProductsResponse {
  repeated Product products = 1;
}

service CatalogService {
  rpc PostProduct (PostProductRequest) returns (PostProductResponse) {}
  rpc GetProduct (GetProductRequest) returns (GetProductResponse) {}
  rpc GetProducts (GetProductsRequest) returns (GetProductsResponse) {}
}
```

尽管 `GetProductRequest` 消息包含了额外的字段，但通过 ID 的搜索与索引实现。

下面的代码展示了 `GetProducts` 函数的实现：

[catalog/server.go](https://github.com/tinrab/spidey/blob/master/catalog/server.go)

```go
func (s *grpcServer) GetProducts(ctx context.Context, r *pb.GetProductsRequest) (*pb.GetProductsResponse, error) {
  var res []Product
  var err error
  if r.Query != "" {
    res, err = s.service.SearchProducts(ctx, r.Query, r.Skip, r.Take)
  } else if len(r.Ids) != 0 {
    res, err = s.service.GetProductsByIDs(ctx, r.Ids)
  } else {
    res, err = s.service.GetProducts(ctx, r.Skip, r.Take)
  }
  if err != nil {
    log.Println(err)
    return nil, err
  }

  products := []*pb.Product{}
  for _, p := range res {
    products = append(
      products,
      &pb.Product{
        Id:          p.ID,
        Name:        p.Name,
        Description: p.Description,
        Price:       p.Price,
      },
    )
  }
  return &pb.GetProductsResponse{Products: products}, nil
}
```

它决定了当给定何种参数来调用何种服务函数。其目标是模拟 REST HTTP 的 endpoint。

对于 `/products?[ids=...]&[query=...]&skip=0&take=100` 形式的请求，只有设计一个 endpoint 来完成 API 调用会相对容易一些。

## Order 服务

Order 订单服务就比较棘手了。他需要调用账户和目录服务来验证请求，因为一个订单只能给一个特定的账号和一个存在的商品进行创建。

### Service

`Service` 接口定义了通过账户创建和索引全部订单的接口。

[order/service.go](https://github.com/tinrab/spidey/blob/master/order/service.go)

```go
type Service interface {
  PostOrder(ctx context.Context, accountID string, products []OrderedProduct) (*Order, error)
  GetOrdersForAccount(ctx context.Context, accountID string) ([]Order, error)
}

type Order struct {
  ID         string
  CreatedAt  time.Time
  TotalPrice float64
  AccountID  string
  Products   []OrderedProduct
}

type OrderedProduct struct {
  ID          string
  Name        string
  Description string
  Price       float64
  Quantity    uint32
}
```

### 数据库

一个订单可以包含多个商品，因此数据模型必须支持这种形式。下面的 `order_products` 表描述了 ID 为 `product_id` 的订购产品以及此类产品的数量。而  `product_id` 字段必须可以从目录服务进行检索。

[order/up.sql](https://github.com/tinrab/spidey/blob/master/order/up.sql)

```sql
CREATE TABLE IF NOT EXISTS orders (
  id CHAR(27) PRIMARY KEY,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL,
  account_id CHAR(27) NOT NULL,
  total_price MONEY NOT NULL
);

CREATE TABLE IF NOT EXISTS order_products (
  order_id CHAR(27) REFERENCES orders (id) ON DELETE CASCADE,
  product_id CHAR(27),
  quantity INT NOT NULL,
  PRIMARY KEY (product_id, order_id)
);
```

`Repository` 接口很简单：

[order/repository.go](https://github.com/tinrab/spidey/blob/master/order/repository.go)

```go
type Repository interface {
  Close()
  PutOrder(ctx context.Context, o Order) error
  GetOrdersForAccount(ctx context.Context, accountID string) ([]Order, error)
}
```

但实现它却并不简单。

一个订单必须使用事务机制分两步插入，然后通过 join 语句进行查询。

从数据库中读取订单需要解析一个表状结构数据读取到对象结构中。下面的代码基于订单 ID 将商品读取到订单中：

```go
orders := []Order{}
order := &Order{}
lastOrder := &Order{}
orderedProduct := &OrderedProduct{}
products := []OrderedProduct{}

// 将每行读取到 Order 结构体
for rows.Next() {
  if err = rows.Scan(
    &order.ID,
    &order.CreatedAt,
    &order.AccountID,
    &order.TotalPrice,
    &orderedProduct.ID,
    &orderedProduct.Quantity,
  ); err != nil {
    return nil, err
  }
  // 读取订单
  if lastOrder.ID != "" && lastOrder.ID != order.ID {
    newOrder := Order{
      ID:         lastOrder.ID,
      AccountID:  lastOrder.AccountID,
      CreatedAt:  lastOrder.CreatedAt,
      TotalPrice: lastOrder.TotalPrice,
      Products:   products,
    }
    orders = append(orders, newOrder)
    products = []OrderedProduct{}
  }
  // 读取商品
  products = append(products, OrderedProduct{
    ID:       orderedProduct.ID,
    Quantity: orderedProduct.Quantity,
  })

  *lastOrder = *order
}

// 添加最后一个订单 (或者第一个 :D)
if lastOrder != nil {
  newOrder := Order{
    ID:         lastOrder.ID,
    AccountID:  lastOrder.AccountID,
    CreatedAt:  lastOrder.CreatedAt,
    TotalPrice: lastOrder.TotalPrice,
    Products:   products,
  }
  orders = append(orders, newOrder)
}
```

### gRPC

Order 服务的 gRPC 服务端需要在实现时与账户和目录服务建立联系。

Protocol Buffers 定义如下：

[order/order.proto](https://github.com/tinrab/spidey/blob/master/order/order.proto)

```protobuf
syntax = "proto3";
package pb;

message Order {
  message OrderProduct {
    string id = 1;
    string name = 2;
    string description = 3;
    double price = 4;
    uint32 quantity = 5;
  }

  string id = 1;
  bytes createdAt = 2;
  string accountId = 3;
  double totalPrice = 4;
  repeated OrderProduct products = 5;
}

message PostOrderRequest {
  message OrderProduct {
    string productId = 2;
    uint32 quantity = 3;
  }

  string accountId = 2;
  repeated OrderProduct products = 4;
}

message PostOrderResponse {
  Order order = 1;
}

message GetOrderRequest {
  string id = 1;
}

message GetOrderResponse {
  Order order = 1;
}

message GetOrdersForAccountRequest {
  string accountId = 1;
}

message GetOrdersForAccountResponse {
  repeated Order orders = 1;
}

service OrderService {
  rpc PostOrder (PostOrderRequest) returns (PostOrderResponse) {}
  rpc GetOrdersForAccount (GetOrdersForAccountRequest) returns (GetOrdersForAccountResponse) {}
}
```

运行订单服务需要传递其他服务的 URL：

[order/server.go](https://github.com/tinrab/spidey/blob/master/order/server.go)

```go
type grpcServer struct {
  service       Service
  accountClient *account.Client
  catalogClient *catalog.Client
}

func ListenGRPC(s Service, accountURL, catalogURL string, port int) error {
  accountClient, err := account.NewClient(accountURL)
  if err != nil {
    return err
  }

  catalogClient, err := catalog.NewClient(catalogURL)
  if err != nil {
    accountClient.Close()
    return err
  }

  lis, err := net.Listen("tcp", fmt.Sprintf(":%d", port))
  if err != nil {
    accountClient.Close()
    catalogClient.Close()
    return err
  }

  serv := grpc.NewServer()
  pb.RegisterOrderServiceServer(serv, &grpcServer{
    s,
    accountClient,
    catalogClient,
  })
  reflection.Register(serv)

  return serv.Serve(lis)
}
```

创建订单涉及调用帐户服务、检查帐户是否存在、然后对产品执行相同操作。计算总价时还需要读取产品价格。你不会希望用户能传入自己的商品的总价。

```go
func (s *grpcServer) PostOrder(
  ctx context.Context,
  r *pb.PostOrderRequest,
) (*pb.PostOrderResponse, error) {
  // 检查账户是否存在
  _, err := s.accountClient.GetAccount(ctx, r.AccountId)
  if err != nil {
    log.Println(err)
    return nil, err
  }

  // 获取订单商品
  productIDs := []string{}
  for _, p := range r.Products {
    productIDs = append(productIDs, p.ProductId)
  }
  orderedProducts, err := s.catalogClient.GetProducts(ctx, 0, 0, productIDs, "")
  if err != nil {
    log.Println(err)
    return nil, err
  }

  // 构造商品
  products := []OrderedProduct{}
  for _, p := range orderedProducts {
    product := OrderedProduct{
      ID:          p.ID,
      Quantity:    0,
      Price:       p.Price,
      Name:        p.Name,
      Description: p.Description,
    }
    for _, rp := range r.Products {
      if rp.ProductId == p.ID {
        product.Quantity = rp.Quantity
        break
      }
    }

    if product.Quantity != 0 {
      products = append(products, product)
    }
  }

  // 调用服务实现
  order, err := s.service.PostOrder(ctx, r.AccountId, products)
  if err != nil {
    log.Println(err)
    return nil, err
  }

  // 创建订单响应
  orderProto := &pb.Order{
    Id:         order.ID,
    AccountId:  order.AccountID,
    TotalPrice: order.TotalPrice,
    Products:   []*pb.Order_OrderProduct{},
  }
  orderProto.CreatedAt, _ = order.CreatedAt.MarshalBinary()
  for _, p := range order.Products {
    orderProto.Products = append(orderProto.Products, &pb.Order_OrderProduct{
      Id:          p.ID,
      Name:        p.Name,
      Description: p.Description,
      Price:       p.Price,
      Quantity:    p.Quantity,
    })
  }
  return &pb.PostOrderResponse{
    Order: orderProto,
  }, nil
}
```

当请求特定账户的订单时，由于需要产品的详情，因此调用目录服务是有必要的。

## GraphQL 服务

GraphQL schema 的定义在 [graphql/schema.graphql](https://github.com/tinrab/spidey/blob/master/graphql/schema.graphql) 文件中：

```graphql
scalar Time

type Account {
  id: String!
  name: String!
  orders: [Order!]!
}

type Product {
  id: String!
  name: String!
  description: String!
  price: Float!
}

type Order {
  id: String!
  createdAt: Time!
  totalPrice: Float!
  products: [OrderedProduct!]!
}

type OrderedProduct {
  id: String!
  name: String!
  description: String!
  price: Float!
  quantity: Int!
}

input PaginationInput {
  skip: Int
  take: Int
}

input AccountInput {
  name: String!
}

input ProductInput {
  name: String!
  description: String!
  price: Float!
}

input OrderProductInput {
  id: String!
  quantity: Int!
}

input OrderInput {
  accountId: String!
  products: [OrderProductInput!]!
}

type Mutation {
  createAccount(account: AccountInput!): Account
  createProduct(product: ProductInput!): Product
  createOrder(order: OrderInput!): Order
}

type Query {
  accounts(pagination: PaginationInput, id: String): [Account!]!
  products(pagination: PaginationInput, query: String, id: String): [Product!]!
}
```

`gqlgen` 工具会生成一堆类型，但是还需要对 `Order` 模型进行一些控制，在 [graphql/types.json](https://github.com/tinrab/spidey/blob/master/graphql/types.json) 文件中进行制定，从而不会自动生成模型：

```json
{
  "Order": "github.com/tinrab/spidey/graphql/graph.Order"
}
```

现在可以手动实现 `Order` 结构了：

[graphql/graph/models.go](https://github.com/tinrab/spidey/blob/master/graphql/graph/models.go)

```go
package graph

import time "time"

type Order struct {
  ID         string           `json:"id"`
  CreatedAt  time.Time        `json:"createdAt"`
  TotalPrice float64          `json:"totalPrice"`
  Products   []OrderedProduct `json:"products"`
}
```

生成类型的指令在 [graphql/graph/graph.go](https://github.com/tinrab/spidey/blob/master/graphql/graph/graph.go) 顶部：

```go
//go:generate gqlgen -schema ../schema.graphql -typemap ../types.json
package graph
```

通过下面的命令运行：

```bash
$ go generate ./graphql/graph/graph.go
```

GraphQL 服务端引用了所有其他服务。

[graphql/graph/graph.go](https://github.com/tinrab/spidey/blob/master/graphql/graph/graph.go)

```go
type GraphQLServer struct {
  accountClient *account.Client
  catalogClient *catalog.Client
  orderClient   *order.Client
}

func NewGraphQLServer(accountUrl, catalogURL, orderURL string) (*GraphQLServer, error) {
  // 连接账户服务
  accountClient, err := account.NewClient(accountUrl)
  if err != nil {
    return nil, err
  }

  // 连接目录服务
  catalogClient, err := catalog.NewClient(catalogURL)
  if err != nil {
    accountClient.Close()
    return nil, err
  }

  // 连接订单服务
  orderClient, err := order.NewClient(orderURL)
  if err != nil {
    accountClient.Close()
    catalogClient.Close()
    return nil, err
  }

  return &GraphQLServer{
    accountClient,
    catalogClient,
    orderClient,
  }, nil
}
```

`GraphQLServer` 结构体需要实现所有生成的 resolver。修改（Mutation）可以在 [graphql/graph/mutations.go](https://github.com/tinrab/spidey/blob/master/graphql/graph/mutations.go) 中找到，查询（Query）则可以在 [graphql/graph/queries.go](https://github.com/tinrab/spidey/blob/master/graphql/graph/queries.go) 中找到。

修改操作通过调用相关服务客户端传入参数进行实现：

```go
func (s *GraphQLServer) Mutation_createAccount(ctx context.Context, in AccountInput) (*Account, error) {
  ctx, cancel := context.WithTimeout(ctx, 3*time.Second)
  defer cancel()

  a, err := s.accountClient.PostAccount(ctx, in.Name)
  if err != nil {
    log.Println(err)
    return nil, err
  }

  return &Account{
    ID:   a.ID,
    Name: a.Name,
  }, nil
}
```

查询能够互相嵌套。在 Spidey 中，查询账户还可以查询其订单，见 `Account_orders` 函数。

```go
func (s *GraphQLServer) Query_accounts(ctx context.Context, pagination *PaginationInput, id *string) ([]Account, error) {
  // 会被首先调用
  // ...
}

func (s *GraphQLServer) Account_orders(ctx context.Context, obj *Account) ([]Order, error) {
  // 然后执行这个函数，返回 "obj" 账户的订单
  // ...
}
```

## 总结

执行下面的命令就可以运行 Spidey：

```bash
$ vgo vendor
$ docker-compose up -d --build
```

然后你就可以在浏览器中访问 [http://localhost:8000/playground](http://localhost:8000/playground) 来使用 GraphQL 工具创建一个账户了：

```graphql
mutation {
  createAccount(account: {name: "John"}) {
    id
    name
  }
}
```

返回结果为：

```json
{
  "data": {
    "createAccount": {
      "id": "15t4u0du7t6vm9SRa4m3PrtREHb",
      "name": "John"
    }
  }
}
```

然后可以创建一些产品：

```graphql
mutation {
  a: createProduct(product: {name: "Kindle Oasis", description: "Kindle Oasis is the first waterproof Kindle with our largest 7-inch 300 ppi display, now with Audible when paired with Bluetooth.", price: 300}) { id },
  b: createProduct(product: {name: "Samsung Galaxy S9", description: "Discover Galaxy S9 and S9+ and the revolutionary camera that adapts like the human eye.", price: 720}) { id },
  c: createProduct(product: {name: "Sony PlayStation 4", description: "The PlayStation 4 is an eighth-generation home video game console developed by Sony Interactive Entertainment", price: 300}) { id },
  d: createProduct(product: {name: "ASUS ZenBook Pro UX550VE", description: "Designed to entice. Crafted to perform.", price: 300}) { id },
  e: createProduct(product: {name: "Mpow PC Headset 3.5mm", description: "Computer Headset with Microphone Noise Cancelling, Lightweight PC Headset Wired Headphones, Business Headset for Skype, Webinar, Phone, Call Center", price: 43}) { id }
}
```

注意返回的 ID 值：

```json
{
  "data": {
    "a": {
      "id": "15t7jjANR47uODEPUIy1od5APnC"
    },
    "b": {
      "id": "15t7jsTyrvs1m4EYu7TCes1EN5z"
    },
    "c": {
      "id": "15t7jrfDhZKgxOdIcEtTUsriAsY"
    },
    "d": {
      "id": "15t7jpKt4VkJ5iHbwt4rB5xR77w"
    },
    "e": {
      "id": "15t7jsYs0YzK3B7drQuf1mX5Dyg"
    }
  }
}
```

然后发起一些订单：

```graphql
mutation {
  createOrder(order: { accountId: "15t4u0du7t6vm9SRa4m3PrtREHb", products: [
    { id: "15t7jjANR47uODEPUIy1od5APnC", quantity: 2 },
    { id: "15t7jpKt4VkJ5iHbwt4rB5xR77w", quantity: 1 },
    { id: "15t7jrfDhZKgxOdIcEtTUsriAsY", quantity: 5 }
  ]}) {
    id
    createdAt
    totalPrice
  }
}
```

根据返回结果检查返回的费用：

```json
{
  "data": {
    "createOrder": {
      "id": "15t8B6lkg80ZINTASts92nBzyE8",
      "createdAt": "2018-06-11T21:18:18Z",
      "totalPrice": 2400
    }
  }
}
```

完整代码请查看 [GitHub](https://github.com/tinrab/spidey)。


> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
