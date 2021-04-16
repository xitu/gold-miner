> * 原文地址：[20 Go Packages You Can Use in Your Next Project](https://medium.com/vacatronics/20-go-packages-you-can-use-in-your-next-project-7515426559c0)
> * 原文作者：[Fernando Souza](https://medium.com/@cleberdsouza)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/20-go-packages-you-can-use-in-your-next-project.md](https://github.com/xitu/gold-miner/blob/master/article/2021/20-go-packages-you-can-use-in-your-next-project.md)
> * 译者：
> * 校对者：

# 20 Go Packages You Can Use in Your Next Project

![Photo by [Todd Quackenbush](https://unsplash.com/@toddquackenbush?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) on [Unsplash](https://unsplash.com/s/photos/tool?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)](https://cdn-images-1.medium.com/max/11326/1*NCjLkoVD6wGtnhJ_5phUhA.jpeg)

[Go](https://golang.org/doc/) is an amazing language that you can use to build almost any kind of program. Developed in 2007, it has the ease of an interpreted language while also being fast and efficient as a compiled language. It was also built thinking about concurrency and getting advantage of the multicore machines. You can even write programs to [embedded](https://tinygo.org/) [devices](https://medium.com/vacatronics/lets-go-embedded-with-esp32-cb6bb3043bd0).

Since then, a lot of nice programs and tools have been created using Go, such as [Kubernetes](https://github.com/kubernetes/kubernetes), [Consul](https://github.com/hashicorp/consul), and [NSQ](https://nsq.io/).

With only the [standard packages](https://golang.org/pkg/) from Go you already can build a nice application.

Fortunately, Go has a vibrant community that creates and shares a lot of libraries that you can use to improve your development. Let’s see some of them in this article.

> **Note**: you definitely should check the [Awesome Go](https://github.com/avelino/awesome-go) github repository, which has a huge list of Go projects, libraries, and resources.

## Golang-Set

An attempt to mimic the primary features of the set data structure from Python into Go. An example of the use:

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

You can know more about it [here](https://github.com/deckarep/golang-set).

## Go kit

It is a toolkit to implement microservices. It handles the basic about a distributed system, so you can focus on your business logic.

If you want to adopt a microservice architecture in your solution, “Go kit will help you structure and build out your services, avoid common pitfalls, and write code that grows with grace”.

Check out [here](https://github.com/go-kit/kit).

## GRequests

It is a Go “clone” of the famous Python [requests](https://requests.readthedocs.io/en/master/) library. You can easily do a HTTP request, upload/download a file, or serialize a response into JSON or XML.

If you have worked with Python, you will feel very comfortable using it.

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

The [package ws](https://pkg.go.dev/github.com/gobwas/ws) implements a client and server for the [WebSocket](https://en.wikipedia.org/wiki/WebSocket) protocol. It has some nice features, such as zero-copy upgrade and low-level API in case you want to write your own logic.

You can know more about it [here](https://github.com/gobwas/ws).

## Email

A robust and flexible email library. It provides a more human interface to send emails using Go.

You can add attachments, send text / html messages, or add custom headers, in a very clear way.

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

You can know more about it [here](https://github.com/jordan-wright/email).

## Gin

With more than 44k stars on Github, it is one of the most popular Go library. It is a web framework, and it focus on productivity and performance.

It has a lot of features, such as middleware customization, serving static files, handle multiple data formats, and HTML rendering.

If you want to develop an API or a Web application, you should definitely consider using [Gin](https://github.com/gin-gonic/gin).

## Fuzzy

Go library that provides a fuzzy string matching in the same style as Sublime, VSCode, etc.

It only depends on the Go standard library, and it is fast. It is a good choice if you want to add a search functionality to your application.

Github [here](https://github.com/sahilm/fuzzy).

![](https://cdn-images-1.medium.com/max/2000/0*MHy_yztfQo_5ceL7)

## Authboss

Authentication is a mandatory part of any modern web application. Creating all the necessary boilerplate can be cumbersome, and you can actually miss something.

This library aims to help you implement an authentication system, saving you time and avoid some mistakes that you might do.

Check the documentation [here](https://github.com/volatiletech/authboss).

## Uuid

This package provides a pure Go implementation of [UUID,](https://en.wikipedia.org/wiki/Universally_unique_identifier) supporting both creation and parsing.

It supports from version 1 to 5, and it is simple to use.

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

More information [here](https://github.com/gofrs/uuid).

## Gorm

If you are implement an API, there are good chances you will need to connect to a database. While you can do this by hand, using a ORM can save you a lot of time.

[Gorm](https://gorm.io/) is a fantastic ORM library for Go. You can create models, associations, hooks, transactions, and a lot more nice features.

It is also a mandatory library if you want to work with a database.

## Graphql

If you want to add support to [GraphQL](https://graphql.org/), then this is your package. It supports queries, mutations, and subscriptions.

Check the Github [here](https://github.com/graphql-go/graphql).

![Source [here](https://github.com/onsi/ginkgo).](https://cdn-images-1.medium.com/max/3092/0*DMqByNp79q_gLoKt)

## Ginkgo

One of the biggest complains of the community is the poor native Go testing packages.

Ginkgo extends standard [testing](https://golang.org/pkg/testing/) package, allowing expressive BDD ([Behavior-Driven Development](https://en.wikipedia.org/wiki/Behavior-driven_development)) style tests.

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

Check the documentation [here](http://onsi.github.io/ginkgo/).

## Errors

Outstanding library for error handling. The main feature is to handle the error identical to the official way, but with the addition of an annotation without losing the original error context (files and line numbers).

As stated in the [documentation](https://github.com/juju/errors), the error handling becomes:

```Go
if err := SomeFunc(); err != nil {
  return errors.Annotate(err, "more context")
}
```

This can save a lot of time during your development or even when trying to find that annoying bug.

![Source [here](https://github.com/spf13/cobra).](https://cdn-images-1.medium.com/max/2134/0*hnh5EndaQhAun6hm.png)

## Cobra

It is both a library to create CLI programs as well as a program to help you create a well-structure application.

It has great features as nested commands, flags, intelligent suggestions, help generation, and more.

If you need to create a CLI program, [cobra](https://github.com/spf13/cobra) is the only tool you need.

## Logrus

Another popular library for Go, Logrus is a structured logger that provides a comprehensive extension for the native logging package.

You can also add some hooks to be executed when a certain error level occurred.

Check the [documentation](https://github.com/sirupsen/logrus) to see how to use it.

## Dateparse

With this library you can parse date strings without knowing the format. It reads the bytes and uses a state machine to find the correct format.

```Go
t, err := dateparse.ParseAny("3/1/2014")
```

Check the [documentation](https://github.com/araddon/dateparse) for more examples.

## Gonum

A set of numeric libraries for Go. It contains libraries for matrices, statistics, integration, differentiation, among others.

If you need to include some mathematics in your code, you have to use it. It saves you time and gives you a consistent scientific code.

Check the [documentation](https://www.gonum.org/) for how to use.

## Gopsutil

Another library that was inspired by a [Python package](https://pypi.org/project/psutil/). You can retrieve information about running process and system utilization on different platforms.

It is useful to monitor your system resources and processes.

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

Check the documentation [here](https://github.com/shirou/gopsutil).

![Source [here](https://fyne.io/).](https://cdn-images-1.medium.com/max/3008/0*4qYylK17SMS_rNMU.png)

## Fyne

You can create a beautiful GUI application for desktop and mobile using the nice [Fyne](https://fyne.io/) package.

It is based on Material Design, so it has nice features of usability, widgets, layouts, and it is designed to be easy to develop.

Check out the [documentation](https://github.com/fyne-io/fyne).

## Ants

A nice feature of the Go language is the concurrency support and the [goroutines](https://www.geeksforgeeks.org/goroutines-concurrency-in-golang/). But managing all the routines in an application can be really challenging.

The [ants](https://github.com/panjf2000/ants) library implements a pool that manage and recycle a massive number of goroutines, automatically. It has nonblocking mechanisms and handle panic without crashing an application.

If you need to create an application that uses concurrency, you should definitely check [this library](https://github.com/panjf2000/ants) out.

## Conclusion

Go is a fantastic language, with nice features from the standard library. But even with support, sometimes you need an extra help.

The community has already built a lot of great libraries that can help you, either by saving your time, so you don’t need to implement again, or by creating an easy to use interface.

If you know another awesome library that is not listed here, leave a comment.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
