> * 原文地址：[20 Go Packages You Can Use in Your Next Project](https://medium.com/vacatronics/20-go-packages-you-can-use-in-your-next-project-7515426559c0)
> * 原文作者：[Fernando Souza](https://medium.com/@cleberdsouza)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/20-go-packages-you-can-use-in-your-next-project.md](https://github.com/xitu/gold-miner/blob/master/article/2021/20-go-packages-you-can-use-in-your-next-project.md)
> * 译者：[tmpbook](https://github.com/tmpbook)
> * 校对者：[PassionPenguin](https://github.com/PassionPenguin), [kamly](https://github.com/kamly)

# 可以在下一个项目中使用的 20 个 Go 三方库

![图片由 [Todd Quackenbush](https://unsplash.com/@toddquackenbush?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) 上传至 [Unsplash](https://unsplash.com/s/photos/tool?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)](https://cdn-images-1.medium.com/max/11326/1*NCjLkoVD6wGtnhJ_5phUhA.jpeg)

[Go](https://golang.org/doc/) 是一门很棒的语言。它诞生于 2007 年，您可以使用它构建几乎所有种类的应用程序。它既像解释型语言一样易于编写，又像编译型语言一样快速高效。同时还考虑到了并发与多核计算。您甚至可以编写可以驱动[嵌入式](https://tinygo.org/)[设备](https://medium.com/vacatronics/lets-go-embedded-with-esp32-cb6bb3043bd0)的程序。

像 [Kubernetes](https://github.com/kubernetes/kubernetes)，[Consul](https://github.com/hashicorp/consul) 还有 [NSQ](https://nsq.io/) 这些非常不错的项目都是由 Go 语言编写。

仅使用 Go 的[标准库](https://golang.org/pkg/)，您就可以构建出不错的应用程序。

幸运的是，Go 拥有一个充满活力的社区，可以创建和共享许多三方库，您可以使用它们来加速和优化开发。本文我们会介绍其中的一部分。

> **Note**: 一定别忘记查看这个 GitHub 仓库：[Awesome Go](https://github.com/avelino/awesome-go) 它包含了大量的 Go 项目、第三方库还有其它资源。

## Golang-Set

一个试图在 Go 中模仿 Python 主要特性：Set 数据结构的库。使用示例：

```Go
package main
 
import (
    "fmt"
    "github.com/deckarep/golang-set"
)
 
 
func main() {
    requiredClasses := mapset.NewSet()
    requiredClasses.Add("Cooking")
    requiredClasses.Add("English")
    requiredClasses.Add("Math")
    requiredClasses.Add("Biology")

    electiveClasses := mapset.NewSet()
    electiveClasses.Add("Welding")
    electiveClasses.Add("Music")
 
    allClasses := requiredClasses.Union(electiveClasses)
    fmt.Println(allClasses) // Cooking, English, Math, Biology, Welding, Music
    
    fmt.Println(electiveClasses.Contains("Cooking")) //false
    fmt.Println(electiveClasses.Cardinality()) // 3
}
```

您可以在[此处](https://github.com/deckarep/golang-set)了解更多信息。

## Go kit

它是实现微服务的工具包。会帮您实现分布式系统的基础功能，这样您可以专注于业务逻辑。

如果您想在解决方案中使用微服务架构，『Go kit 将帮助您结构化的构建服务，并帮您避开常见的坑，伴随您的项目一起成长』。

您可以在[此处](https://github.com/go-kit/kit)了解更多信息。

## GRequests

它是著名的 Python [requests](https://requests.readthedocs.io/en/master/) 三方库的『克隆』。您可以轻松的发出 HTTP 请求，上传、下载文件或将返回序列化为 JSON 或者 XML。

如果您使用过 Python 相关的库，使用它时会非常舒服。

```Go
package main

import (
  "log"
  "fmt"
  "github.com/levigross/grequests"
)

func main() {
  resp, err := grequests.Get("http://httpbin.org/get", nil)
  if err != nil {
    log.Fatalln("Unable to make request:", err)
  }
  
  fmt.Println(resp.String())
}
```

## Ws

第三方库 [ws](https://pkg.go.dev/github.com/gobwas/ws) 为 [Websocket](https://en.wikipedia.org/wiki/WebSocket) 协议实现了客户端和服务端。它具有一些不错的功能，如零拷贝升级和底层 API（其中底层 API 在您想写自己的逻辑是很有用）。

您可以在[此处](https://github.com/gobwas/ws)了解更多信息。

## Email

强大而灵活的电子邮件三方库。它提供了更人性化的接口来使用 Go 发送电子邮件。

您可以已非常清晰的方式添加附件、发送文本、HTML 消息或添加自定义标题。

```Go
package main

import (
  "github.com/jordan-wright/email"
)

func main() {
  e := email.NewEmail()
  e.From = "Jordan Wright <test@gmail.com>"
  e.To = []string{"test@example.com"}
  e.Cc = []string{"test_cc@example.com"}
  e.Subject = "Awesome Subject"
  e.Text = []byte("Text Body is, of course, supported!")
  e.HTML = []byte("<h1>Fancy HTML is supported, too!</h1>")
  e.Send("smtp.gmail.com:587", smtp.PlainAuth("", "test@gmail.com", "password123", "smtp.gmail.com"))
}

```

您可以在[此处](https://github.com/jordan-wright/email)了解更多信息。

## Gin

Github 上 start 数量超过 44k，最受欢迎的 Go 三方库之一。它是一个 Web 框架，专注生产力与性能。

它有很多功能，例如自定义中间件，提供静态文件服务，处理多种数据格式，HTML 渲染等。

如果您想开发一个 API 或 Web 应用程序，您绝对应该考虑使用 [Gin](https://github.com/gin-gonic/gin)。

## Fuzzy

Go 三方库，提供与 Sublime，VsCode 等编辑器样式相同的字符串模糊匹配功能。

它仅依赖 Go 标准库，并且速度很快，如果您要向应用程序添加搜索功能，它会是一个不错的选择。

Github 地址在[这](https://github.com/sahilm/fuzzy)。

![](https://cdn-images-1.medium.com/max/2000/0*MHy_yztfQo_5ceL7)

## Authboss

身份验证是现代 Web 应用程序所必须的部分。编写一个全功能的组件可能很麻烦，而且您大概率也会遗漏一些东西。

该三方库旨在帮助您实现身份验证系统，帮您节省时间的同时避免一些可能会犯的错误。

您可以在[此处](https://github.com/volatiletech/authboss)了解更多信息。

## Uuid

该三方库提供了 [UUID](https://en.wikipedia.org/wiki/Universally_unique_identifier) 的纯 Go 实现，同时支持创建和解析。

它同时支持版本 1 到版本 5，而且非常易用。

```Go
package main

import (
 "fmt"
 "github.com/gofrs/uuid"
)

func main() {
 // Creating UUID Version 4
 // panic on error
 u1 := uuid.Must(uuid.NewV4())
 fmt.Printf("UUIDv4: %s\n", u1)

 // Parsing UUID from string input
 u2, err := uuid.FromString("6ba7b810-9dad-11d1-80b4-00c04fd430c8")
 if err != nil {
  fmt.Printf("Something went wrong: %s", err)
  return
 }
 fmt.Printf("Successfully parsed: %s", u2)
}
```

您可以在[此处](https://github.com/gofrs/uuid)了解更多信息。

## Gorm

如果要实现一些 API 功能，则很有可能需要连接数据库。尽管您可以手动执行此操作，但是使用 ORM 可以节省大量的时间。

[Gorm](https://gorm.io/)是绝佳的 Go ORM 三方库。您可以使用其模型创建、关联、钩子、事务等其它很棒的功能。

如果您要和数据库打交道，是很有必要使用它的。

## GraphQL

如果您想支持 [GraphQL](https://graphql.org/)，您可以用它，它提供了查询、更新和订阅。

您可以在[此处](https://github.com/graphql-go/graphql)了解更多信息。

![Source [here](https://github.com/onsi/ginkgo).](https://cdn-images-1.medium.com/max/3092/0*DMqByNp79q_gLoKt)

## Ginkgo

社区抱怨最多的问题就是 testing 标准库的功能太弱。

Ginkgo 扩展了 [testing](https://golang.org/pkg/testing/) 标准库，允许富有变现力的 BDD（[行为驱动开发](https://en.wikipedia.org/wiki/Behavior-driven_development)）类型的测试。

```Go
package books_test

import (
 _ "github.com/onsi/ginkgo/ginkgo"
)

Describe("the strings package", func() {
  Context("strings.Contains()", func() {
    When("the string contains the substring in the middle", func() {
      It("returns `true`", func() {
        Expect(strings.Contains("Ginkgo is awesome", "is")).To(BeTrue())
      })
    })
  })
})
```

您可以在[此处](http://onsi.github.io/ginkgo/)了解更多信息。

## Errors

出色的错误处理三方库。主要功能是和官方的方式一样处理错误，不同的是添加了注释而不会丢失原始错误的上下文（文件和行号）。

如[文档](https://github.com/juju/errors)所属，使用本三方库错误处理变成了这样：

```Go
if err := SomeFunc(); err != nil {
  return errors.Annotate(err, "more context")
}
```

这样可以节省大量时间，特别是当我们在排查烦人的 bug 时。

![Source [here](https://github.com/spf13/cobra).](https://cdn-images-1.medium.com/max/2134/0*hnh5EndaQhAun6hm.png)

## Cobra

它不仅可以帮您构建 CLI 程序，还可以帮您创建结构合理的应用。

它具有命令嵌套，flag，智能建议，帮助生成等功能。

如果您需要创建一个 CLI 程序，[cobra](https://github.com/spf13/cobra) 是您必用的三方库之一。

## Logrus

另一个流程的 Go 三方库 Logrus 是一个结构化的记录器，它为本地日志标准库提供了全面的扩展。

您还可以添加一些钩子，以便在发生特定级别的错误时执行。

您可以在[此处](https://github.com/sirupsen/logrus)了解更多信息。

## Dateparse

有了这个库，您可以在不知道格式的情况下解析日期字符串。它可以读取字节并使用状态机找到正确的格式。

```Go
t, err := dateparse.ParseAny("3/1/2014")
```

您可以在[此处](https://github.com/araddon/dateparse)了解更多信息。

## Gonum

一组 Go 的数值处理三方库。它包含矩阵、统计、微积分等三方库。

如果您需要在代码中包含一些数学相关操作，那您一定要使用它。它会帮您节省时间并提供给您科学一致的代码。

您可以在[此处](https://www.gonum.org/)了解更多信息。

## Gopsutil

另一个受 [Python 包](https://pypi.org/project/psutil/)启发的库。您可以使用它从不同平台上取回运行中进程和系统的利用率的相关信息。

如果需要对系统资源和进程进行监控，那它会很有用。

```Go
package main

import (
    "fmt"
    "github.com/shirou/gopsutil/v3/mem"
)

func main() {
    v, _ := mem.VirtualMemory()

    // almost every return value is a struct
    fmt.Printf("Total: %v, Free:%v, UsedPercent:%f%%\n", v.Total, v.Free, v.UsedPercent)

    // convert to JSON. String() is also implemented
    fmt.Println(v)
}
```

您可以在[此处](https://github.com/shirou/gopsutil)了解更多信息。

![Source [here](https://fyne.io/).](https://cdn-images-1.medium.com/max/3008/0*4qYylK17SMS_rNMU.png)

## Fyne

您可以使用 [Fyne](https://fyne.io/) 三方库创建漂亮的桌面和移动端 GUI 程序。

它基于 Material Design，具有高可用性，支持组件，布局等友好特性，它被设计的非常易于开发。

您可以在[此处](https://github.com/fyne-io/fyne)了解更多信息。

## Ants

Go 语言的一个很好的特性是并发支持和 [goroutines](https://www.geeksforgeeks.org/goroutines-concurrency-in-golang/)。但是管理一个应用程序中的所有协程是非常有挑战性的。

[ants](https://github.com/panjf2000/ants) 实现了一个自动批量管理和回收 goroutines 的池。它具有非阻塞机制，可以在不使应用程序崩溃的情况下处理 panic。

如果您需要创建一个涉及并发的应用程序，那您一定要尝试一下[这个库](https://github.com/panjf2000/ants)。

## 最后

Go 是一门非常棒的语言，它有非常棒的标准库。但是即使有标准库的支持，有时候我们仍然需要一些额外的帮助。

社区已经提供了很多优秀的三方库，它们可以帮助您节省时间，这样您就不需要重复造轮子或者重复实现易用的接口。

如果您知道这里没有列出的其他很棒的三方库，请留下评论。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
