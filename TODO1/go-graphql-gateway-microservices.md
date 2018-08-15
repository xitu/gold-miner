> * 原文地址：[Using GraphQL with Microservices in Go](https://outcrawl.com/go-graphql-gateway-microservices/)
> * 原文作者：[Tin Rabzelj](https://outcrawl.com/authors/tin-rabzelj)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/go-graphql-gateway-microservices.md](https://github.com/xitu/gold-miner/blob/master/TODO1/go-graphql-gateway-microservices.md)
> * 译者：
> * 校对者：

# Using GraphQL with Microservices in Go

![](https://outcrawl.com/static/cover-4772a81f84b65ba37535f8c41959eeaa-08884.jpg)

A few months ago, a really nice Go package [vektah/gqlgen](https://github.com/vektah/gqlgen) for GraphQL became popular. This article describes how GraphQL is implemented in "Spidey", an exemplary microservices based online store.

Some parts listed below are missing, but complete source code is available on [GitHub](https://github.com/tinrab/spidey).

## Architecture

Spidey encompasses three services that are exposed to the user through a GraphQL gateway. Communication within the cluster is through [gRPC](https://grpc.io).

Account service manages accounts and catalog manages products. Order service deals with creating orders. It talks to the other two services to properly validate orders.

![Architecture](https://outcrawl.com/static/architecture-7b089f424d0abd2c29eb2d51ed362550-0381e.jpg)

Individual services have three layers: **server**, **service** and **repository**. **Server** is responsible for communication, in Spidey's case its gRPC. **Service** contains any business logic. **Repository** is responsible for writing and reading data from a database.

## Getting started

Running Spidey requires [Docker](https://docs.docker.com/install/), [Docker Compose](https://docs.docker.com/compose/install/), [Go](https://golang.org/doc/install), [Protocol Buffers](https://github.com/google/protobuf) compiler and its [Go](https://developers.google.com/protocol-buffers/docs/reference/go-generated) plugin, and the super cool [vektah/gqlgen](https://github.com/vektah/gqlgen) package.

You'll also need [vgo](https://www.godoc.org/golang.org/x/vgo) tool, which is in early stages of development. The [dep](https://github.com/golang/dep) tool will work as well, but included `go.mod` file will be ignored.

## Docker setup

Each service is implemented in its own subdirectory and contains at least `app.dockerfile` file. The `db.dockerfile` is used to build the database image.

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

All services are defined inside [docker-compose.yaml](https://github.com/tinrab/spidey/blob/master/docker-compose.yaml) file.

Here's an extract for the account service:

```
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

The context is specifically set to ensure that `vendor` directory can be copied inside the Docker container. All services share the same dependencies and some need each other's definitions.

## Account service

Account service exposes functions for creating and retrieving accounts.

### Service

API of the account service is defined with the following interface:

[account/service.go](https://github.com/tinrab/spidey/blob/master/account/service.go)

```
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

Implementation needs a reference to the repository.

```
type accountService struct {
  repository Repository
}

func NewService(r Repository) Service {
  return &accountService{r}
}
```

The service is responsible for any business logic. The `PostAccount` functions is implemented like this:

```
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

It leaves parsing wire format to the server and dealing with a database to the repository.

### Database

Data model for an account is very simple:

```
CREATE TABLE IF NOT EXISTS accounts (
  id CHAR(27) PRIMARY KEY,
  name VARCHAR(24) NOT NULL
);
```

The above data definition SQL file will be copied and executed inside the Docker container.

[account/db.dockerfile](https://github.com/tinrab/spidey/blob/master/account/db.dockerfile)

```
FROM postgres:10.3

COPY up.sql /docker-entrypoint-initdb.d/1.sql

CMD ["postgres"]
```

PostgreSQL database is accessed through a repository interface.

[account/repository.go](https://github.com/tinrab/spidey/blob/master/account/repository.go)

```
type Repository interface {
  Close()
  PutAccount(ctx context.Context, a Account) error
  GetAccountByID(ctx context.Context, id string) (*Account, error)
  ListAccounts(ctx context.Context, skip uint64, take uint64) ([]Account, error)
}
```

Repository is implemented as a wrapper over the Go's standard library SQL package.

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

The gRPC service is defined with the following Protocol Buffers file:

[account/account.proto](https://github.com/tinrab/spidey/blob/master/account/account.proto)

```
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

Because the `package` is set to `pb`, the generated code will be available from the `pb` subpackage.

gRPC code is generated with the command specified at the top of [account/server.go](https://github.com/tinrab/spidey/blob/master/account/server.go) file and by using Go's generate command.

[account/server.go](https://github.com/tinrab/spidey/blob/master/account/server.go)

```
//go:generate protoc ./account.proto --go_out=plugins=grpc:./pb
package account
```

Running the following command will generate code inside `pb` subdirectory.

```
$ go generate account/server.go
```

Server works as an adapter over the `Service` interface, and transforming request and response types accordingly.

```
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

Here's how the `PostAccount` functions looks like:

```
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

### Usage

gRPC server is initialized inside [account/cmd/account/main.go](https://github.com/tinrab/spidey/blob/master/account/cmd/account/main.go) file.

```
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

A client struct is implemented inside [account/client.go](https://github.com/tinrab/spidey/blob/master/account/client.go) file for convenience. With it, account service can be used without worrying about the underlying RPC implementation, as seen later on.

```
account, err := accountClient.GetAccount(ctx, accountId)
if err != nil {
  log.Fatal(err)
}
```

## Catalog service

Catalog service deals with products in the Spidey store. It's implemented similarly as the account service, but uses Elasticsearch to persist products.

### Service

Account service conforms to the following interface:

[catalog/service.go](https://github.com/tinrab/spidey/blob/master/catalog/service.go)

```
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

### Database

The repository implements abstractions over Elasticsearch by using [olivere/elastic](https://github.com/olivere/elastic) package underneath.

[catalog/repository.go](https://github.com/tinrab/spidey/blob/master/catalog/repository.go)

```
type Repository interface {
  Close()
  PutProduct(ctx context.Context, p Product) error
  GetProductByID(ctx context.Context, id string) (*Product, error)
  ListProducts(ctx context.Context, skip uint64, take uint64) ([]Product, error)
  ListProductsWithIDs(ctx context.Context, ids []string) ([]Product, error)
  SearchProducts(ctx context.Context, query string, skip uint64, take uint64) ([]Product, error)
}
```

Because Elasticsearch stores IDs separately from documents, there's a helper struct for products which doesn't contain the ID.

```
type productDocument struct {
  Name        string  `json:"name"`
  Description string  `json:"description"`
  Price       float64 `json:"price"`
}
```

Inserting products into the database involves copying over all the fields into the `productDocument` struct:

```
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

The gRPC service is defined in the [catalog/catalog.proto](https://github.com/tinrab/spidey/blob/master/catalog/catalog.proto) file, and implemented in the [catalog/server.go](https://github.com/tinrab/spidey/blob/master/catalog/server.go) file.

One notable difference from the account service is that it doesn't define all the endpoints from the service interface.

[catalog/catalog.proto](https://github.com/tinrab/spidey/blob/master/catalog/catalog.proto)

```
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

Searching and retrieving by IDs is missing, while `GetProductsRequest` message contains extra fields.

This is how the `GetProducts` functions looks like:

[catalog/server.go](https://github.com/tinrab/spidey/blob/master/catalog/server.go)

```
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

It decides what service function to call based on arguments given. The goal is to mimic how a REST HTTP endpoint would look like.

Having one endpoint, which looks like `/products?[ids=...]&[query=...]&skip=0&take=100`, is easier to work with while consuming the API.

## Order service

Order service is a bit trickier. It needs to call account and catalog services to validate requests, since an order can only be created for an account and products that exist.

### Service

The `Service` interface defines functions for creating orders and retrieving all orders made by some account.

[order/service.go](https://github.com/tinrab/spidey/blob/master/order/service.go)

```
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

### Database

An order can contain multiple products, so the data model must support that. The `order_products` table below describes an ordered product with an ID of `product_id` and the quantity of such products. The `product_id` field will have to be retrieved from the catalog service.

[order/up.sql](https://github.com/tinrab/spidey/blob/master/order/up.sql)

```
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

The `Repository` interface is very simple.

[order/repository.go](https://github.com/tinrab/spidey/blob/master/order/repository.go)

```
type Repository interface {
  Close()
  PutOrder(ctx context.Context, o Order) error
  GetOrdersForAccount(ctx context.Context, accountID string) ([]Order, error)
}
```

But the implementation is not quite so simple.

One order must be inserted in two steps using a transaction, and then selected using a join statement.

Reading an order from a database requires parsing tabular data into the object hierarchy. The code below works by traversing through returned rows and groups products into orders based on order's ID.

```
orders := []Order{}
order := &Order{}
lastOrder := &Order{}
orderedProduct := &OrderedProduct{}
products := []OrderedProduct{}

// Scan rows into Order structs
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
  // Scan order
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
  // Scan products
  products = append(products, OrderedProduct{
    ID:       orderedProduct.ID,
    Quantity: orderedProduct.Quantity,
  })

  *lastOrder = *order
}

// Add last order (or first :D)
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

The gRPC server needs to contact account and catalog services before delegating the request to the order service implementation.

The protocol is defined as follows:

[order/order.proto](https://github.com/tinrab/spidey/blob/master/order/order.proto)

```
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

Running the server requires passing in the necessary URLs for other services.

[order/server.go](https://github.com/tinrab/spidey/blob/master/order/server.go)

```
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

Creating an order involves calling the account service, to check if the account exists, and then doing the same for products. Fetching products is also required for calculating the total price, which is handled by the service. You don't want users passing in their own sum.

```
func (s *grpcServer) PostOrder(
  ctx context.Context,
  r *pb.PostOrderRequest,
) (*pb.PostOrderResponse, error) {
  // Check if account exists
  _, err := s.accountClient.GetAccount(ctx, r.AccountId)
  if err != nil {
    log.Println(err)
    return nil, err
  }

  // Get ordered products
  productIDs := []string{}
  for _, p := range r.Products {
    productIDs = append(productIDs, p.ProductId)
  }
  orderedProducts, err := s.catalogClient.GetProducts(ctx, 0, 0, productIDs, "")
  if err != nil {
    log.Println(err)
    return nil, err
  }

  // Construct products
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

  // Call service implementation
  order, err := s.service.PostOrder(ctx, r.AccountId, products)
  if err != nil {
    log.Println(err)
    return nil, err
  }

  // Make response order
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

When querying for orders made by specific account, calling the catalog service is also necessary because product details (name, price and description) are needed.

## GraphQL service

The GraphQL schema is defined inside [graphql/schema.graphql](https://github.com/tinrab/spidey/blob/master/graphql/schema.graphql) file.

```
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

The `gqlgen` tool will generate a bunch of types, but more control is needed for the `Order` model. It is specified in the [graphql/types.json](https://github.com/tinrab/spidey/blob/master/graphql/types.json) file, so the model wont be automatically generated.

```
{
  "Order": "github.com/tinrab/spidey/graphql/graph.Order"
}
```

The `Order` struct can now be implemented manually.

[graphql/graph/models.go](https://github.com/tinrab/spidey/blob/master/graphql/graph/models.go)

```
package graph

import time "time"

type Order struct {
  ID         string           `json:"id"`
  CreatedAt  time.Time        `json:"createdAt"`
  TotalPrice float64          `json:"totalPrice"`
  Products   []OrderedProduct `json:"products"`
}
```

The command for generating types is defined at the top of [graphql/graph/graph.go](https://github.com/tinrab/spidey/blob/master/graphql/graph/graph.go) file.

```
//go:generate gqlgen -schema ../schema.graphql -typemap ../types.json
package graph
```

It can be run with:

```
$ go generate ./graphql/graph/graph.go
```

GraphQL server has references to all other services.

[graphql/graph/graph.go](https://github.com/tinrab/spidey/blob/master/graphql/graph/graph.go)

```
type GraphQLServer struct {
  accountClient *account.Client
  catalogClient *catalog.Client
  orderClient   *order.Client
}

func NewGraphQLServer(accountUrl, catalogURL, orderURL string) (*GraphQLServer, error) {
  // Connect to account service
  accountClient, err := account.NewClient(accountUrl)
  if err != nil {
    return nil, err
  }

  // Connect to product service
  catalogClient, err := catalog.NewClient(catalogURL)
  if err != nil {
    accountClient.Close()
    return nil, err
  }

  // Connect to order service
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

The `GraphQLServer` struct needs to implement all generated resolvers. Mutations can be found in [graphql/graph/mutations.go](https://github.com/tinrab/spidey/blob/master/graphql/graph/mutations.go) and queries in [graphql/graph/queries.go](https://github.com/tinrab/spidey/blob/master/graphql/graph/queries.go).

Mutations call the relevant service by using its client, and passing in the arguments.

```
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

Queries can have other nested queries. In Spidey's example, querying for an account can also query its orders, as seen in the `Account_orders` function.

```
func (s *GraphQLServer) Query_accounts(ctx context.Context, pagination *PaginationInput, id *string) ([]Account, error) {
  // This will be called first
  // ...
}

func (s *GraphQLServer) Account_orders(ctx context.Context, obj *Account) ([]Order, error) {
  // Then this, to return orders from the account "obj"
  // ...
}
```

## Wrapping up

To run Spidey, execute the following commands:

```
$ vgo vendor
$ docker-compose up -d --build
```

And open [http://localhost:8000/playground](http://localhost:8000/playground) in your browser.

In the GraphQL tool presented, try creating an account:

```
mutation {
  createAccount(account: {name: "John"}) {
    id
    name
  }
}
```

Which returns:

```
{
  "data": {
    "createAccount": {
      "id": "15t4u0du7t6vm9SRa4m3PrtREHb",
      "name": "John"
    }
  }
}
```

Then create some products:

```
mutation {
  a: createProduct(product: {name: "Kindle Oasis", description: "Kindle Oasis is the first waterproof Kindle with our largest 7-inch 300 ppi display, now with Audible when paired with Bluetooth.", price: 300}) { id },
  b: createProduct(product: {name: "Samsung Galaxy S9", description: "Discover Galaxy S9 and S9+ and the revolutionary camera that adapts like the human eye.", price: 720}) { id },
  c: createProduct(product: {name: "Sony PlayStation 4", description: "The PlayStation 4 is an eighth-generation home video game console developed by Sony Interactive Entertainment", price: 300}) { id },
  d: createProduct(product: {name: "ASUS ZenBook Pro UX550VE", description: "Designed to entice. Crafted to perform.", price: 300}) { id },
  e: createProduct(product: {name: "Mpow PC Headset 3.5mm", description: "Computer Headset with Microphone Noise Cancelling, Lightweight PC Headset Wired Headphones, Business Headset for Skype, Webinar, Phone, Call Center", price: 43}) { id }
}
```

Note the returned IDs:

```
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

Then order something:

```
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

And verify the returned cost:

```
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

The entire source code is available on [GitHub](https://github.com/tinrab/spidey).


> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
