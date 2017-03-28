* 原文地址：[How I built a web server using Go — and on ChromeOS](https://medium.freecodecamp.com/how-i-built-a-web-server-using-go-and-on-chromeos-3b83e4c2da5f#.rwir5yc1k)
* 原文作者：[Peter GleesonFollow](https://medium.freecodecamp.com/@petergleeson1?source=post_header_lockup)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[xiaoyusilen](http://xiaoyu.world)
* 校对者：[nicebug](https://github.com/nicebug)，[steinliber](https://github.com/steinliber)


# 如何在 ChromeOS 下用 Go 搭建 Web 服务 #

## Linux →ChromeOS →Android →Linux Emulator ##

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/2000/0*jHeP1Jefk_56SFZY.jpg">

图片来自 [WikiMedia](https://upload.wikimedia.org/wikipedia/commons/6/69/Wikimedia_Foundation_Servers-8055_35.jpg) 

有时会有人问我：「你究竟为什么要用 Chromebook 做 Web 开发呢？」。大家似乎不相信我能够在一台定位为简单易用的机器上学习全栈 Web 开发。

事实上我对在圣诞打折季买的这玩意没有抱太大的期望。我觉得它就是个带有编辑器和浏览器的低成本设备，可以随时随地学习前端开发和看 YouTube。此外，我也十分热衷于「云计算」这个概念，它代表着未来的趋势。

事实证明，这个小的机器居然有带给我意外惊喜的本事。它的启动速度实在是快，电池续航能力很强，并且在无处不在的「云」的帮助下，你几乎可以做所有你可以在其他机器上完成的事情。另外，我选择的机型有一个触摸屏，它可以向后翻折不同的角度而成为一个平板电脑，或者像「帐篷」一样立起来，或者摆成任何你觉得看着很酷的姿势。

在过去几个星期中，我对后端开发更感兴趣（一部分原因是因为我对 CSS 实在是抓狂）。我学习了关于如何在 Chromebook 上安装 Ubuntu Linux（如果我理解的正确的话，ChromeOS 就是基于 Linux 内核基础上开发的）。本来我是要安装 Ubuntu 的，但是它涉及到切换到开发者模式的步骤，并且需要抹掉本地存储并且要关闭 ChromeOS 中所有出色的安全功能。由于以上原因我决定找其他解决方案。

我发现 ChromeOS 运行的特别好。Google 已经在一些 Chromebook 机型上安装了一些 Android 应用，除了设计和用户体验不是很好之外，Android 手机上可以运行的任何程序都可以顺利地在 ChromeOS 上运行。例如，我安装了一个叫 [Termux](https://termux.com/) 的应用，它是一个在 Android 上不需要 root 权限的 Linux 模拟器。最近我一直在摆弄这个模拟器，现在我可以告诉你，[Fredrik Fornwall](https://medium.com/@fornwall) 做的这东西太棒了，令我印象深刻。

我照着 [Aurélien Giraud](https://medium.com/@aurerua) 写的几篇[文章](https://medium.freecodecamp.com/building-a-node-js-application-on-android-part-1-termux-vim-and-node-js-dfa90c28958f)开始搭建环境。惊喜的是，还没用一杯咖啡的工夫，我就在 Chromebook 上运行起了 Node.js 的服务和一个 NeDB 数据库，而且根本不需要切换到开发者模式。如果你有个安卓设备，我强烈建议你收藏下 Aurélien 的教程并且照着试试。不需要多久，就能在手机上运行起来一个 Node.js 服务。

虽然现在我用 Node 用的很爽，但是我也对一些写服务端的语言感兴趣，打算挑出几个作为深入研究的备选语言。[Go](https://tour.golang.org/welcome/1) 是我正在学习的语言之一，它是 Google 在 2009 年推出的。现在已经变得十分热门，名列 2016 年[年度编程语言](http://insights.dice.com/2017/01/10/go-tiobe-programming-language-2016/)之中。

Go 在某些方面很像 C 和 C++，并且它的设计确实受到了它们的影响。然而，创建 Go 的主要动机是不喜欢这些历史悠久语言的复杂性。因此，Go 特意设计成一种更容易使用的语言。

#### 能简单多少？ ####

例如，Go 语言中没有「while」循环。涉及到循环的时候，你有且只有一个选择：就是「for」循环。

```go
//一个经典的「while」循环

for i < 1000 {
   //循环体
   i++
}
```

Go 语言中类型推导是可选的。你可以用标准写法声明并且初始化一个变量，也可以用简易的方法来隐式的赋值。或采取一个快捷方式和隐式分配类型。

```go
var x int = 2

//等同于

x := 2
```

「if」和「else」的语句很简单：

```go
x := 5

if x > 10 {
   fmt.Println("Greater than 10")
} else {
     fmt.Println("Less than or equal to 10")
}
```

同时 Go 的编译速度也很快，并且标准库中也提供了各种有用的包，这些包在网上都有很棒的文档。并且它们在很多[项目](https://en.wikipedia.org/wiki/Go_%28programming_language%29#Projects_using_Go)中被使用，包括一些家喻户晓的名字例如 Google，Dropbox，Soundcloud，Twitch 以及 Uber。

我认为如果 Go 对这些公司来说都足够好的话，那么可能也值得你看一看。对于任何一个准备迈出他后端开发的第一步的人而言，我结合在 Termux 上使用 Go 的经验整理出了一些教程。如果你有一个 Android 设备，或者有一台在 Google Play 有访问权限的 Chromebook 上的，那么安装并且运行 Termux，我们就可以开始了。

如果你有一个常规的 Linux 设备，也可以使用 Termux！Termux的教程对于[任何支持 Go 的平台](https://golang.org/doc/install)都是通用的。

#### 从 Termux 开始 ####

像其他的 Android 应用一样，Termux 只需要到应用商店搜索并点击安装，可以十分简单的下载安装到你的设备上。装好之后打开它你就会看见一个简洁的空命令行。这里我强烈推荐使用物理键盘（内置，USB 或者蓝牙键盘都可以），如果手头没有键盘，那么推荐你去下载一个叫「Hacker’s Keyboard」的安卓软件。

正如 Aurélien 去年的教程中所说，Termux 很少被预装。所以在终端中运行以下命令：

```shell
$ apt update
$ apt upgrade
$ apt install coreutils
```

好。现在所有的东西都是最新的了，coreutils 将会帮助你更容易的切换到对应的文件目录。让我们看看我们现在在目录中的哪个位置。

```shell
$ pwd
```

这个命令会返回一个路径，会展示当前所在目录的位置。如果我们没有在 /home 下，那让我们到「home」文件夹下看看那里面有什么：

```shell
$ cd $HOME && ls
```

好，让我们为 Go 教程新建一个目录，然后到那个目录去。然后我们可以创建一个文件叫做「server.go」。

```shell
$ mkdir go-tutorial && cd go-tutorial
$ touch server.go
```

如果我们输入「ls」，我们可以在目录中看到这个文件。现在，让我们先找一个文本编辑器。Aurélien 的教程推荐你使用 Vim，如果你喜欢用它，那就尽管用它。这里还有一个对待「初学者更加友好」的编辑器 nano。我们安装它，然后打开我们的 server.go 文件。

```shell
$ apt install nano
$ nano server.go
```

棒！现在我们可以敲尽可能多的我们喜欢的代码了。但是在我们开始之前，让我们先安装一下 Go 编译器，因为我们需要编译器才能使我们的代码工作。使用 Ctrl+X 退出 nano，然后在命令行中输入：

```shell
$ apt install golang
```

现在，让我们回到 nano，然后开始写我们的服务端的代码。

#### 搭建一个简单的 Web 服务 ####

我们将写一个简单的程序来启动一个提供 HTML 页面的服务，这个页面让用户输入密码登录并且可以看到欢迎信息（或者如果密码错误的话会看到「对不起，请重试」这类的消息）。在 nano 中，我们写入以下代码：

```go
//搭建一个 Web 服务

package main

import (
   "fmt"
   "net/http"
)
```

我们目前所做的是创建了一个包。Go 程序通常是在包中运行的。这是存储和组织代码的一种方式，并且让你可以更好更方便的调用其他包中的方法。事实上，这也是我们接下来要做的事情。我们已经告诉 Go 导入「fmt」包以及标准库中「net」包下的「http」包。这些包中的方法可以让我们可以使用「格式化 I/O」以及处理 HTTP 请求和响应。

现在，让我们在网上做这个东西。我们继续写下以下代码：

```go
func main() {
   http.ListenAndServe(":8080",nil)
   fmt.Println("Server is listening at port 8080")
}
```

像 C，C++，Java 等等，Go 程序从一个 main() 函数开始。我们已经告诉服务器去监听 8080 端口的请求（可以任意选择一个不同的数字），并且打印一个信息让我们知道它正在做什么。

好了！让我们保存这个文件（Ctrl+O），退出（Ctrl+X）然后运行我们的程序。在命令行中输入：

```
go run server.go
```

这个命令将会让 Go 编译器编译并且运行这个程序。短暂的暂停后，程序应该运行了。你将希望看到以下输出：

```
Server is listening at port 8080
```

棒！你的服务器正在监听 8080 端口的请求，不幸的是，它不知道如何处理它接收到的请求，因为我们没有告诉它如何回应。这就是下一步，使用 Ctrl+C 结束服务程序，然后在 nano 中重新打开 server.go。

#### 发送响应 ####

我们需要服务器去「处理」请求，然后返回适当的响应。幸运的是，我们导入的「http」包使这些变得很容易。

为了可读性更好，我们在 import() 和 main() 之间插入以下代码。我们可以在 main() 下面继续写代码，实际上在任意位置都是可以的，只要你喜欢就好。

无论如何，让我们来写一个处理函数。

```go
func handler (write http.ResponseWriter, req *http.Request) {
   fmt.Fprint(write, "<h1>Hello!</h1>")
}
```

这个函数有两个参数，**write** 和 **req**。这两个参数的类型被定义为在「http」包中定义的 **ResponseWriter** 和 ***Request**，然后我们让服务中写一些 HTML 作为响应。

为了使用这个函数，我们需要在 main() 函数中调用它，添加下面这些加粗的代码：

```go
func main() {
   http.ListenAndServe(":8080",nil)
   fmt.Println("Server is listening at port 8080")
   http.HandleFunc("/", handler)
}
```

我们添加的这一行从「http」包中调用 HandleFunc()。这个方法需要两个参数。第一个参数是一个字符串，第二个使用我们刚刚写的 handle() 函数。我们让服务器用 handle() 处理对 web 根目录下「/」的所有请求。

保存并且关闭 server.go，然后到控制台，再次启动服务。

```
go run server.go
```

同样，我们应该看到输出信息，让我们知道服务器正在监听请求。那么，为什么我们不发送请求呢？打开你的 Web 浏览器并且访问 [http://localhost:8080/](http://localhost:8080)。

Chromebook 对于其他浏览器的使用有着较大的限制，但是我发现 Chrome 在连接到任何本地端口的时候会有些不好用。从应用商店中下载 Mozilla Firefox for Android 可以解决这个问题。

或者，你想完全留在 Termux（为什么不呢？），那就试试 Lynx。这是 1992 年推出的一个基于文本的浏览器。这里没有图片，没有 CSS，当然也没有 JavaScript。不过对于本教程来说是完全够用的，安装并运行它：

```shell
$ apt install lynx
$ lynx localhost:8080
```

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/1000/1*akBwgTRiLA3WG5PqpGJ2eQ.png">

在 Termux 中运行的 Lynx 浏览器中查看 Medium 的主页

如果一切顺利，你应该在你选择的浏览器中看到一个标题「Hello！」。如果没有，回到 nano 然后检查 server.go 的代码。我第一次发现的错误包括在 import() 语句使用大括号 {}，而不是括号。还有搞错了一些看上去像是点的逗号（也许我应该用 Ctrl+Alt+「+」来放大 Termux 中的字）。

#### 世界上最独特的网站 ####

我们的服务现在用一个较短的 HTML 来响应 HTTP 请求。虽然算不上是下一个 Facebook，但是比我们之前距离更近了一些。我们来让它变得更有趣一点。

总结一下：我们要做一个页面，要求用户输入密码。如果密码输入错误，用户会收到一条警告消息。如果密码输入正确，用户就会看到一个「欢迎！」的消息。因为它是你自己机器上的服务，所以只有你知道密码，因此它是一个**非常**独特的网站。

首先，我们把 HTML 响应变得更有趣一些。让我们回到我们之前写的 `handler()`。粘贴所有以下的代码，以粗体替代已经存在的内容（全部都在一行）。一定要小心引用的部分！我在开始和结束的地方用了双引号，在 HTML 的部分用了单引号。确保一致。

```go
func handler (write http.ResponseWriter, req *http.Request) {
   fmt.Fprint(write, "<h1>Login</h1><form action='/log-in/' method='POST'> Password:<br> <input type='password' name='pass'><br> <input type='submit' value='Go!'></form>")
}
```

当我们运行服务的时候，HTML 应该呈现以下页面：

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*akpgU8Iox9RqGoOC0SC40A.png">

前台：Mozilla Firefox for Android；后台：Lynx for Termux。

现在我感觉我已经有点熟悉HTML了。简单来说，我们有一个头和一个表单。表单的「action」属性被设为「/log-in/」它的方法被设置为 POST。有两个输入字段：一个用于输入密码，另一个用于提交表单。密码字段被叫做「pass」。我们稍后会用到这些名字。

现在如果我们输入密码并且提交会发生什么？我们要向服务器发出另一个 HTTP请求（「/log-in/」），因此我们需要写另一个处理这个请求的方法。回到 Termux，在你选择的编辑器中打开 server.go。

我们要再写另一个函数（就我而言，我会在 handler() 和 main() 之间写，但是你可以按照适合你的方法去做）。这是另一个处理 HTTP 「/log-in/」请求的方法，这是在用户提交我们之前做的表单时发出的。

```go
func loginHandler (write http.ResponseWriter, req *http.Request){

   password := req.FormValue("pass")

   if password == "let-me-in" {
                fmt.Fprint(write, "<h1>Welcome!</h1>")

   } else {
         fmt.Fprint(write, "<h3>Wrong password! Try again.</h3>")
   }

}
```

和之前一样，这个方法有两个参数，**write** 和 **req**，它们也被定义为「http」包中已定义的相同类型。

然后我们创建一个叫做 **password** 的变量，我们把它设置成等于请求表单中「pass」的值。注意使用「:=」的隐式类型赋值，我们可以这样做是因为密码字段的值将始终作为字符串发送。

接下来是一个「if」语句，使用「==」比较运算符来检查密码是否与「let-me-in」的一致。这当然取决于我们如何定义正确的密码。你可以把这个字符串改成任何你喜欢的。

如果字符串是相同的，你就登录成功了！现在，我们输出了一个无聊的「欢迎」的消息。我们接下来将会修改这个。

否则，如果字符串不一致，我们就会输出「重试」的消息。同样，我们可以使这个变得更加有趣。首先，如果密码表单仍然可供用户使用，这将是有用的。添加以下加粗的代码。是和之前的 HTML 一样形式的密码：

```go
func loginHandler (write http.ResponseWriter, req *http.Request){

password := req.FormValue("pass")

if password == "let-me-in" {
                fmt.Fprint(write, "<h1>Welcome!</h1>")

} else {
         fmt.Fprint(write, "**<h1>Login</h1><form action='/log-in/' method='POST'> Password:<br> <input type='password' name='pass'><br> <input type='submit' value='Go!'></form>**<h3 **style='color: white; background-color: red'**>Wrong password! Try again.</h3>")
   }

}
```

我还在「重试」消息里添加了一些简单的样式。你也可以不加，但是为什么不呢？让我们也对「欢迎」消息做同样的处理：

```go
func loginHandler (write http.ResponseWriter, req *http.Request){

password := req.FormValue("pass")

if password == "let-me-in" {
                fmt.Fprint(write, "**<h1 style='color: white; background-color: navy; font-size: 72px'>**Welcome!</h1>")

} else {
         fmt.Fprint(write, "<h1>Login</h1><form action='/log-in/' method='POST'> Password:<br> <input type='password' name='pass'><br> <input type='submit' value='Go!'></form><h3 style='color: white; background-color: red'>Wrong password! Try again.</h3>")
   }

}
```

差不多了！我们写了 loginHandler() 函数，但在我们的 main() 函数中没有引用它。添加以下加粗的代码：

```go
func main() {
   http.ListenAndServe(":8080",nil)
   fmt.Println("Server is listening at port 8080")
   http.HandleFunc("/", handler)
   http.HandleFunc("/log-in/", loginHandler)
}
```

至此，我们已经告诉服务如果它接收到一个「/log-in/」的请求（这将随时发生在用户点击提交按钮的时候），它使用 `loginHandle()` 方法做出响应。我们已经完成了！server.go 的全部代码应该与以下代码一致：

```go
//搭建一个 Web 服务

package main

import (
   "fmt"
   "net/http"
)

func handler (write http.ResponseWriter, req *http.Request) {
   fmt.Fprint(write, "**<**h1>Login</h1><form action='/log-in/' method='POST'> Password:<br> <input type='password' name='pass'><br> <input type='submit' value='Go!'></form>")
}

func loginHandler (write http.ResponseWriter, req *http.Request){
   password := req.FormValue("pass")
   if password == "let-me-in" {
                fmt.Fprint(write, "<h1 style='color: white;       background-color: navy; font-size: 72px'>Welcome!</h1>")
   } else {
         fmt.Fprint(write, "<h1>Login</h1><form action='/log-in/' method='POST'> Password:<br> <input type='password' name='pass'><br> <input type='submit' value='Go!'></form><h3 style='color: white; background-color: red'>Wrong password! Try again.</h3>")
   }
}

func main() {
   http.ListenAndServe(":8080",nil)
   fmt.Println("Server is listening at port 8080")
   http.HandleFunc("/", handler)
   http.HandleFunc("/log-in/", loginHandler)
}
```

保存并且退出 nano，然后到命令行，我们让 Go 编译器去编译我们的服务程序。这个命令只需要编译程序一次，此后我们就可以随时运行它。

```
go build server.go
```

给它一点时间去编译，然后输入下面的命令：

```
./server
```

你应该看到和之前一样的「监听」信息。现在，如果你打开浏览器并且输入 [http://localhost:8080](http://localhost:8080)，你将会被要求输入密码。如果我们输入的不正确，我们就会看到下面的界面：

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/1000/1*RKnDclkFGuf1vHIJk8Y25w.png">

不对！

反之，如果我们输入正确的密码：

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/1000/1*pDsiYj8so6H1KcMEjiMZxw.png">

Firfox 看上去似乎比 Lynx 更热情一些…

#### 结语 ####

如果你已经看了这篇文章，我希望你可以喜欢这个教程，并发现它对你有帮助。我把读者放在和我一样的位置上 — 对于web全栈开发十分感兴趣并且打算学习服务端知识的新手。

当然，我们在这里创建的这个简单的登录页面还有很长的路要走。你不会像我们做的一样将 HTML 写入 handler 函数中（我正打算看看 Go 的 HTML 包有一些不错的可选的模板），也不会在「if」语句中写出正确的密码。最好有一个存储密码和用户名的数据库，你的服务器每次收到登录请求时会去查询。

为此，Termux 提供了一个 SQLite 包，并且 Node.js 中提供了各种数据库的包。这个教程的一个很酷的延展方向是可以去创建一个保存用户名以及对应密码的数据库，并且允许新的用户加入。你需要添加另外一个输入项，并修改 loginHanlder() 函数。

我已经表达了我对于 Termux 的观点 — 它很棒，我希望它能够适于用更多的应用。不光是 Go 和 Node.js，我同样用它成功的写过并且编译和运行了简单的 C，C++，CoffeeScript，PHP 以及 Python 3.6等语言的代码，并且仍然有一些其他语言我没有尝试过（有人试过 Erlang/Lua/PicoLisp吗？）

至于 Go，第一次使用令我非常满意。我喜欢它专注于简易性，并且我喜欢它的语法，而且它的文档很容易理解，它让我可以根据我的理解去开发。一个初学者的意见是有价值的，这点就像是 C++ 和 Python 的结合。在某种程度上，这可能恰好是它的意义所在！

#### 译者注

感谢大家的阅读，首先，这是一篇 Go 语言的入门文章，不过作者的代码有一点小问题，发表前我已经向作者提出问题，暂时还没有收到回复，收到回复后会在文章中更新，现在根据我的理解稍作分析，这是作者的最后一段代码：

```go
func main() {
   http.ListenAndServe(":8080",nil)
   fmt.Println("Server is listening at port 8080")
   http.HandleFunc("/", handler)
   http.HandleFunc("/log-in/", loginHandler)
}
```

监听是阻塞的执行，内部一直 runloop 等待网络请求，不退出。所以监听一旦打开，后续代码都不会执行，直到按 ctrl+c 强制结束。这一点，我们从 `ListenAndServe` 的源码中看出：

```go
// ListenAndServe always returns a non-nil error.
func ListenAndServe(addr string, handler Handler) error {
	server := &Server{Addr: addr, Handler: handler}
	return server.ListenAndServe()
}
```

因此作者的代码中执行到 `http.ListenAndServe(":8080",nil)` 后，后续代码都不会继续执行。所以这里应该先设置访问路由，再监听端口。否则这段代码是无法出现预期效果的。修改后代码如下：

```go
func main() {
   http.HandleFunc("/", handler)
   http.HandleFunc("/log-in/", loginHandler)
   fmt.Println("Server is listening at port 8080")
   http.ListenAndServe(":8080",nil)
}
```

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。