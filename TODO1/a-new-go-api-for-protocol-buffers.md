> * 原文地址：[A new Go API for Protocol Buffers](https://blog.golang.org/a-new-go-api-for-protocol-buffers)
> * 原文作者：Joe Tsai, Damien Neil, and Herbie Ong
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/a-new-go-api-for-protocol-buffers.md](https://github.com/xitu/gold-miner/blob/master/TODO1/a-new-go-api-for-protocol-buffers.md)
> * 译者：[司徒公子](https://github.com/stuchilde)
> * 校对者：[quzhen](https://github.com/quzhen12)、[Chauncey Chen](https://github.com/colorsakura)

# Go 发布新版 Protobuf API

## 介绍

我们很高兴地宣布：发布[protocol buffers](https://developers.google.com/protocol-buffers)的 Go API 主要修订版本 —— Google 独立于编程语言的数据交换接口格式。

## 构建新 API 的动机

第一个用于 Go 的 protocol buffer 版本由 Rob Pike 在 2010 年 3 月发布，Go 的首个正式版在两年后才发布。

在第一个版本发布的数十年间，随着 Go 的发展，package 也在不断发展壮大。用户的需求也在不断的增长。

许多人希望使用 reflection（反射） package 来编写检查 protocol buffer message 的程序，[`reflect`](https://pkg.go.dev/reflect) package 提供了 Go 类型和值的视图，但是忽略了 protocol buffer 类型系统的信息。例如，我们可能希望编写一个函数来遍历日志项，清除所有标注为敏感信息的数据，标注并不是 Go 类型系统的一部分。

另一个常见的需求就是使用 protocol buffer 编译器来生成其他的数据结构，例如动态 message 类型，它能够表示在编译时类型未知的 message。

我们还观察到，时常发生问题的根源在于 [`proto.Message`](https://pkg.go.dev/github.com/golang/protobuf/proto?tab=doc#Message) 接口，该接口标识生成的 message 类型的值，对描述这些类型的行为几乎没有任何帮助。当用户创建实现该接口的类型（时常不经意间将 message 嵌入其他的结构中），并且将这些类型的值传递给期待生成 message 值的函数时，程序发生崩溃或行为难以预料。

这三个问题都有一个共同的原因，而通常的解决方法：`Message` 接口应该完全指定 message 的行为，对 `Message` 值进行操作的函数应该自由的接收任何类型，这些类型的接口都要被正确的实现。

由于不可能在保持 package API 兼容性的同时更改 `Message` 类型的现有定义，所以我们决定是时候开始开发新的、不兼容 protobuf 模块的主要版本了。

今天，我们很高兴地发布这个新模块，希望你们喜欢。

## Reflection（反射）

Reflection（反射）是新实现的旗舰特性。与 `reflect` 包提供 Go 类型和值的视图相似，[`protoreflect`](https://pkg.go.dev/google.golang.org/protobuf/reflect/protoreflect?tab=doc) 包根据 protocol buffer 类型系统提供值的视图。

完整的描述 `protoreflect` package 对于这篇文章来说太长了，但是，我们可以来看看如何编写前面提到的日志清理函数。

首先，我们将编写 `.proto` 文件来定义 [`google.protobuf.FieldOptions`](https://github.com/protocolbuffers/protobuf/blob/b96241b1b716781f5bc4dc25e1ebb0003dfaba6a/src/google/protobuf/descriptor.proto#L509) 类型的扩展名，以便我们可以将注释字段作为标识敏感信息的与否。

```go
syntax = "proto3";
import "google/protobuf/descriptor.proto";
package golang.example.policy;
extend google.protobuf.FieldOptions {
    bool non_sensitive = 50000;
}
```

我们可以使用此选项来将某些字段标识为非敏感字段。

```go
message MyMessage {
    string public_name = 1 [(golang.example.policy.non_sensitive) = true];
}
```

接下来，我们将编写一个 Go 函数，它用于接收任意 message 值以及删除所有敏感字段。

```go
// 清除 pb 中所有的敏感字段
func Redact(pb proto.Message) {
   // ...
}
```

函数接收 [`proto.Message`](https://pkg.go.dev/google.golang.org/protobuf/proto?tab=doc#Message) 参数，这是由所有已生成的 message 类型实现的接口类型。此类型是 `protoreflect` 包中已定义的别名：

```go
type ProtoMessage interface{
    ProtoReflect() Message
}
```

为了避免填充生成 message 的命名空间，接口仅包含一个返回 [`protoreflect.Message`](https://pkg.go.dev/google.golang.org/protobuf/reflect/protoreflect?tab=doc#Message) 的方法，此方法提供对 message 内容的访问。

（为什么是别名？由于 `protoreflect.Message` 有返回原始 `proto.Message` 的相应方法，我们需要避免在两个包中循环导入。）

[`protoreflect.Message.Range`](https://pkg.go.dev/google.golang.org/protobuf/reflect/protoreflect?tab=doc#Message.Range) 方法为 message 中的每一个填充字段调用一个函数。

```go
m := pb.ProtoReflect()
m.Range(func(fd protoreflect.FieldDescriptor, v protoreflect.Value) bool {
    // ...
    return true
})
```

使用描述 protocol buffer 类型的 [`protoreflect.FieldDescriptor`](https://pkg.go.dev/google.golang.org/protobuf/reflect/protoreflect?tab=doc#FieldDescriptor) 字段和包含字段值的 [`protoreflect.Value`](https://pkg.go.dev/google.golang.org/protobuf/reflect/protoreflect?tab=doc#Value) 字段来调用 range 函数。

[`protoreflect.FieldDescriptor.Options`](https://pkg.go.dev/google.golang.org/protobuf/reflect/protoreflect?tab=doc#Descriptor.Options) 方法以 `google.protobuf.FieldOptions` message 的形式返回字段选项。

```go
opts := fd.Options().(*descriptorpb.FieldOptions)
```

（为什么使用类型断言？由于生成的 `descriptorpb` package 依赖于 `protoreflect`，所以 `protoreflect` package 无法返回正确的选项类型，否则会导致循环导入的问题）

然后，我们可以检查选项以查看扩展为 boolean 类型的值：

```go
if proto.GetExtension(opts, policypb.E_NonSensitive).(bool) {
    return true // 不要删减非敏感字段
}
```

请注意，我们在这里看到的是字段**描述符**，而不是字段**值**，我们感兴趣的信息在于 protocol buffer 类型系统，而不是 Go 语言。

这也是我们已经简化了 `proto` package API 的一个示例，原来的 [`proto.GetExtension`](https://pkg.go.dev/github.com/golang/protobuf/proto?tab=doc#GetExtension) 返回一个值和错误信息，新的 [`proto.GetExtension`](https://pkg.go.dev/google.golang.org/protobuf/proto?tab=doc#GetExtension) 只返回一个值，如果字段不存在，则返回该字段的默认值。在 `Unmarshal` 的时候报告扩展解码错误。

一旦我们确定了需要修改的字段，将其清除就很简单了：

```go
m.Clear(fd)
```

综上所述，我们完整的修改函数如下：

```go
// 清除 pb 中的所有敏感字段
func Redact(pb proto.Message) {
    m := pb.ProtoReflect()
    m.Range(func(fd protoreflect.FieldDescriptor, v protoreflect.Value) bool {
        opts := fd.Options().(*descriptorpb.FieldOptions)
        if proto.GetExtension(opts, policypb.E_NonSensitive).(bool) {
            return true
        }
        m.Clear(fd)
        return true
    })
}
```


一个更加完整的实现应该是以递归的方式深入这些 message 值字段。我们希望这些简单的示例能让你更了解 protocol buffer reflection（反射）以及它的用法。

## 版本

我们将 Go protocol buffer 的原始版本称为 APIv1，新版本称为 APIv2。因为 APIv2 不支持向前兼容 APIv1，所以我们需要为每个模块使用不同的路径。

（这些 API 版本与 protocol buffer 语言的版本：`proto1`、`proto2`、`proto3` 是不同的，APIv1 和 APIv2 是 Go 中的具体实现，他们都支持 `proto2` 和 `proto3` 语言版本。）

 [`github.com/golang/protobuf`](https://pkg.go.dev/github.com/golang/protobuf?tab=overview)  模块是 APIv1。

[`google.golang.org/protobuf`](https://pkg.go.dev/google.golang.org/protobuf?tab=overview) 模块是 APIv2。我们利用需要改变导入路径来切换版本，将其绑定到不同的主机提供商上。（我们考虑了 `google.golang.org/protobuf/v2`，说得更清楚一点，这是 API 的第二个主要版本，但是从长远来看，我们认为更短的路径名是更好的选择。）

我们知道不是所有的用户都以相同的速度迁移到新的 package 版本中，有些会迅速迁移，其他的可能会无限期的停留在老版本上。甚至在一个程序中，也有可能使用不同的 API 版本，这是至关重要的。所以，我们继续支持使用 APIv1 的程序。

* `github.com/golang/protobuf@v1.3.4` 是 APIv1 最新 pre-APIv2 版本。
* `github.com/golang/protobuf@v1.4.0` 是由 APIv2 实现的 APIv1 的一个版本。API 是相同的，但是底层实现得到了新 API 的支持。该版本包含 APIv1 和 APIv2 之间的转换函数，`proto.Message` 接口来简化两者之间的转换。
* `google.golang.org/protobuf@v1.20.0` 是 APIv2，该模块取决于 `github.com/golang/protobuf@v1.4.0`，所以任何使用 APIv2 的程序都将会自动选择一个与之对应的集成 APIv1 的版本。

（为什么要从 `v1.20.0` 版本开始？为了清晰的提供服务，我们预计 APIv1 不会达到 `v1.20.0`。因此，版本号就足以区分 APIv1 和 APIv2。）

我们打算长期地保持对 APIv1 的支持。

无论使用哪个 API 版本，该组织都会确保任何给定的程序都仅使用单个 protocol buffer 来实现。它允许程序逐步采用新的 API 或者完全不采用，同时仍然获得新实现的优势。最低版本选择原则意味着程序需要保留原来的实现方法，直到维护者选择更新到新的版本（直接升级或通过更新依赖项）。

## 注意其他的一些特性

[`google.golang.org/protobuf/encoding/protojson`](https://pkg.go.dev/google.golang.org/protobuf/encoding/protojson) package 使用[规范 JSON 映射](https://developers.google.com/protocol-buffers/docs/proto3#json)将 protocol buffer message 转化为 JSON，并修复了旧 `jsonpb` package 的一些问题，这些问题很难在不影响现有用户的情况下进行更改。

 [`google.golang.org/protobuf/types/dynamicpb`](https://pkg.go.dev/google.golang.org/protobuf/types/dynamicpb) package 提供了对 message 中 `proto.Message` 的实现，用于在运行时派生 protocol buffer 类型的 message。

[`google.golang.org/protobuf/testing/protocmp`](https://pkg.go.dev/google.golang.org/protobuf/testing/protocmp) package 提供了使用  [`github.com/google/cmp`](https://pkg.go.dev/github.com/google/go-cmp/cmp) package 来比较 protocol buffer message 的函数。

[`google.golang.org/protobuf/compiler/protogen`](https://pkg.go.dev/google.golang.org/protobuf/compiler/protogen?tab=doc) package 提供了对编写 protocol 编译器插件的支持。

## 结论

`google.golang.org/protobuf` 模块是对 Go protocol buffer 支持的重大改进，为反射（reflection）、自定义 message 实现以及整洁的 API surface 提供优先的支持。我们打算用新的 API 包装的方式来永久维护原来的 API，从而使得用户可以按照自己的节奏逐步采用新的 API。

我们这次更新的目标是在解决旧 API 问题的同时，放大旧 API 的优势。当我们完成每一个新实现的组件时，我们将在 Google 的代码库中投入使用，这种逐步推出的方式使我们对新 API 的可用性、性能以及正确性都充满了信心。我相信已经准备好可以在生产环境使用了。

我们很激动地看到这个版本的发布，并且希望它能在未来十年甚至更长的时间内为 Go 生态系统持续服务。

## 相关文章

* [Working with Errors in Go 1.13](/go1.13-errors)
* [Debugging what you deploy in Go 1.12](/debugging-what-you-deploy)
* [HTTP/2 Server Push](/h2push)
* [Introducing HTTP Tracing](/http-tracing)
* [Generating code](/generate)
* [Introducing the Go Race Detector](/race-detector)
* [Go maps in action](/go-maps-in-action)
* [go fmt your code](/go-fmt-your-code)
* [Organizing Go code](/organizing-go-code)
* [Debugging Go programs with the GNU Debugger](/debugging-go-programs-with-gnu-debugger)
* [The Go image/draw package](/go-imagedraw-package)
* [The Go image package](/go-image-package)
* [The Laws of Reflection](/laws-of-reflection)
* [Error handling and Go](/error-handling-and-go)
* ["First Class Functions in Go"](/first-class-functions-in-go-and-new-go)
* [Profiling Go Programs](/profiling-go-programs)
* [A GIF decoder: an exercise in Go interfaces](/gif-decoder-exercise-in-go-interfaces)
* [Introducing Gofix](/introducing-gofix)
* [Godoc: documenting Go code](/godoc-documenting-go-code)
* [Gobs of data](/gobs-of-data)
* [C? Go? Cgo!](/c-go-cgo)
* [JSON and Go](/json-and-go)
* [Go Slices: usage and internals](/go-slices-usage-and-internals)
* [Go Concurrency Patterns: Timing out, moving on](/go-concurrency-patterns-timing-out-and)
* [Defer, Panic, and Recover](/defer-panic-and-recover)
* [Share Memory By Communicating](/share-memory-by-communicating)
* [JSON-RPC: a tale of interfaces](/json-rpc-tale-of-interfaces)
* [Third-party libraries: goprotobuf and beyond](/third-party-libraries-goprotobuf-and)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。