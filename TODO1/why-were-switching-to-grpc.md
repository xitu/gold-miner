> * 原文地址：[Why We’re Switching to gRPC](https://eng.fromatob.com/post/2019/05/why-were-switching-to-grpc/)
> * 原文作者：[Levin Fritz](https://github.com/lfritz)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/why-were-switching-to-grpc.md](https://github.com/xitu/gold-miner/blob/master/TODO1/why-were-switching-to-grpc.md)
> * 译者：[EmilyQiRabbit](https://github.com/EmilyQiRabbit)
> * 校对者：[wuyanan](https://github.com/wuyanan)，[suhanyujie](https://github.com/suhanyujie)

# 为什么我们要切换到 gRPC

如果你在使用微服务式架构，那么你需要作出的一个基本决策就是：服务之间应该如何交换信息？默认的方法似乎是使用 HTTP 协议发送 JSON 信息 —— 也就是使用所谓的 REST API，但是大多数人并没有认真执行 REST 的原则。使用 REST API 的 fromAtoB 就是我们最开始使用的方法，然而最近我们决定将 gRPC 作为我们新的标准。

[gRPC](https://grpc.io/) 是谷歌研发，并且已经开源的远程过程调用系统。虽然它已经存在数年之久，但我并没有在网上找到关于人们为什么使用或者不使用它的信息，所以我决定写一篇文章，阐述我们选择了 gRPC 的原因。

gRPC 最大的优势就是它使用的是高效二进制编码，这让它比 JSON/HTTP 这种模式快了很多。虽然更快的速度往往是很受欢迎的，这里还有两个对于我们而言更重要的方面：清晰的接口规范，以及对流的支持。

## gRPC 接口规范

当你创建要新的 gRPC 服务时，第一步通常是在 `.proto` 文件中定义接口。下面这段代码就是 `.proto` 文件大致的格式 —— 它是我们自己的 API 中一小部分的简化版。在这个例子中，定义了一个远程过程调用“Lookup”，以及它的输入和输出类型。

```
syntax = "proto3";

package fromatob;

// FromAtoB 是 fromAtoB 后台 API 的简化版本。
service FromAtoB {
	rpc Lookup(LookupRequest) returns (Coordinate) {}
}

// LookupRequest 是按照名称查找城市坐标的请求
message LookupRequest {
	string name = 1;
}

// Coordinate 使用经度和纬度定义了地球上的坐标
message Coordinate {
  // Latitude 是坐标的纬度，范围是 [-90, 90]。
	double latitude = 1;

  // Longitude 是坐标的经度，范围是 [-180, 180]。
	double longitude = 2;
}
```

使用了这个文件，接下来你就可以使用 `protoc` 编译器生成客户端和服务端代码，同时你也可以开始编写提供或者使用 API 的代码了。

所以，为什么这个文件能为我们带来优势，而不是冗余的工作呢？让我们再看一遍上面的代码样例。就算你从来没有用过 gRPC 或者协议缓冲（Protocol Buffer），这段代码也非常易读：例如，很容易看出，如果想要发出 `Lookup` 请求，你必须发送一个 string 类型的 `name` 参数，这个请求将会返回给你一个 `Coordinate` 类型的结果，它包含了参数 `latitude` 和 `longitude`。事实上，一旦你像例子中的那样添加了一些简单的注释，`.proto` 文件就可以作为你的服务的 API 文档了。

当然，一个真正的服务规范的内容应该要多得多，但是却不会更加复杂。只是会有更多对于方法的 `rpc` 声明和对于类型的 `message` 声明。

通过 `protoc` 生成的代码也会确保客户端或者服务端发送的数据都合乎规范。这对于调试是大有帮助的。我记得之前就曾有过两次，我负责维护的服务生成了错误格式的 JSON 数据，并且由于这个格式并没有被验证，错误仅会在用户界面出现。发现错误的唯一方法就是调试前端的 JavaScript 代码 —— 这对于一个从来没有使用过前端 JavaScript 框架的后端开发者并不容易！

## Swagger / OpenAPI

原则上来说，如果你同时使用了 HTTP/JSON API 和 [Swagger](https://swagger.io/) 或者它的继承者 [OpenAPI](https://www.openapis.org/)，你也可以获得同样的优势。下面这段代码范例也可以和 gRPC API 媲美：

```
openapi: 3.0.0

info:
  title: A simplified version of fromAtoB’s backend API
  version: '1.0'

paths:
  /lookup:
    get:
      description: Look up the coordinates for a city by name.
      parameters:
        - in: query
          name: name
          schema:
            type: string
          description: City name.
      responses:
        '200':
          description: OK
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Coordinate'
        '404':
          description: Not Found
          content:
            text/plain:
              schema:
                type: string

components:
  schemas:
    Coordinate:
      type: object
      description: A Coordinate identifies a location on Earth by latitude and longitude.
      properties:
        latitude:
          type: number
          description: Latitude is the degrees latitude of the location, in the range [-90, 90].
        longitude:
          type: number
          description: Longitude is the degrees longitude of the location, in the range [-180, 180].
```

将这段代码和 gRPC 规范相比。OpenAPI 的代码就显得**非常**难以读懂！它更加冗长，结构也更复杂（有八级缩进，不像 gRPC 的只有一级）。

使用 OpenAPI 规范进行验证也要比 gRPC 难很多。至少对于内部服务，这一切都意味着规范要么没有被写入，要么随着 API 的迭代，它们由于没有更新而变得无用了。

## 流

今年更早些的时候，我开始为我们的搜索引擎设计新的 API（想象一下我要搜索“请给我所有 2019 年 6 月 1 日从柏林到巴黎的航线”）。在我构建了第一版使用 HTTP 和 JSON 的 API 之后，我的一个同事指出，在某些情况下，我需要流式的请求结果，意味着我获取到第一个请求结果的时候，我应该开始再发送这些结果。而我设计的 API 只是返回一个简单的 JSON 数组，所以服务在获取到所有结果之前，无法发送任何请求。

前端使用这样的 API 就需要客户端发起轮询请求结果。前端发起 POST 请求来设置搜索条件，然后反复发送 GET 请求来获取结果。返回结果会包含一个可以确认搜索是否已经完成的字段。这种方式可以正常运行，但是不够优雅，并且还需要服务端使用像 Redis 这样的数据存储来缓存中间结果。新的 API 可能会被大量的更小的服务来实现，我并不希望强制它们都实现这样的逻辑。

于是，我们就决定要试一试采用 gRPC。如果你想要发送远程调用的结果，使用了 gRPC，你只需要将 `stream` 关键字添加到 `.proto` 文件中。这就是 `Search` 函数的定义：

```
rpc Search (SearchRequest) returns (stream Trip) {}
```

`protoc` 编译器生成的代码包含了一个带有 `Send` 函数的对象，我们的服务代码将会调用这个函数，来一个接一个的发送 `Trip` 对象，还会包含一个带有 `Recv` 函数的对象，而客户端代码将会调用这个函数来获取结果。从一个开发者的角度来看，这比应用轮询要简单**很多**。

## 注意事项

另外我还想提一下，gRPC 也有些缺点。它们都与工具有关，而不是协议本身的问题。

当你使用 HTTP/JSON 构建 API 的时候，你可以使用 curl、httpie 或 Postman 来做简单的测试。对于 gRPC 也有类似的工具，即 [grpcurl](https://github.com/fullstorydev/grpcurl)，但是它和 gRPC 并不是那么无缝衔接的：你必须在服务端添加 [gRPC 服务映射](https://github.com/grpc/grpc/blob/master/doc/server-reflection.md)扩展，或者在每个命令中指定对应的 `.proto` 文件。我们认为在服务端添加一个小小的可以发送简单请求的命令行工具更为简便。而 `protoc` 生成的客户端代码已经让发送请求非常简单了。

另一个更大的问题则是 Kubernete 的负载均衡，我们曾经用于 HTTP 服务的负载均衡并不非常适用于 gRPC。基本上来说，gRPC 需要的负载均衡是在应用层面而不是 TCP 连接的层面。为了解决这个问题，我们参考教程：[gRPC Load Balancing on Kubernetes without Tears](https://kubernetes.io/blog/2018/11/07/grpc-load-balancing-on-kubernetes-without-tears/)，创建了 [Linkerd](https://linkerd.io/)。

## 总结

尽管构建 gRPC API 会需要更多的前期工作，然而因此能够拥有清晰的 API 规范以及对流的支持，我们发现这些获益完全能够弥补这些前期的工作量。对于我们而言，gRPC 将会是所有我们将构建的新的内部服务的默认选择。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
