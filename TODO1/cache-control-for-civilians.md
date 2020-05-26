> * 原文地址：[Cache-Control for Civilians](https://csswizardry.com/2019/03/cache-control-for-civilians/)
> * 原文作者：[Harry](https://csswizardry.com/about/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/cache-control-for-civilians.md](https://github.com/xitu/gold-miner/blob/master/TODO1/cache-control-for-civilians.md)
> * 译者：[sunui](https://github.com/sunui)
> * 校对者：[portandbridge](https://github.com/portandbridge)、[yzw7489757](https://github.com/yzw7489757)

# 写给大家看的 Cache-Control 指令配置

最好的网络请求就是无须与服务器通信的请求：在网站速度为王的比试里，避免网络完胜于使用网络。为此，使用一个可靠的缓存策略会给你的访客带来完全不同的体验。

话虽如此，在工作中我越来越频繁地看到很多实践机会被无意识地错过，甚至完全忽视做缓存这件事。大概是因为过度聚焦于首次访问，也可能单纯是因为意识和知识的匮乏。不管是为什么，我们有必要做一点相关知识的复习。

## `Cache-Control`

管理静态资源缓存最常见且有效的方式之一就是使用 `Cache-Control` HTTP 报头。这个报头独立应用于每一个资源，这意味着我们页面中的一切都可以拥有一个非常定制化、颗粒化的缓存政策。我们由此可以得到大量的控制权，得以制定异常复杂而强大的缓存策略。

一个 `Cache-Control` 报头可能是这样的：

```
Cache-Control: public, max-age=31536000
```

`Cache-Control` 就是报头字段名，`public` 和 `max-age=31536000` 是**指令**。`Cache-Control` 报头可以接受一个或多个指令，我在本文中想要讲的正是这些指令的真正含义和他们的最佳使用场景。

## `public` 和 `private`

`public` 意味着包括 CDN、代理服务器之类的任何缓存都可以存储响应的副本。`public` 指令经常是冗余的，因为其他指令的存在（例如 `max-age`）已经隐式表示响应是可以缓存的。

相比之下，`private` 是一个显式指令，表示只有响应的最终接收方（客户端或浏览器）可以缓存文件。虽然 `private` 本身并不具备安全功能，但它意在有效防止公共缓存（如 cdn）存储包含用户个人信息的响应。

## `max-age`

`max-age` 定义了一个确保响应被视为“新鲜”的时间单位（相对于请求时间，以秒计）。

```
Cache-Control: max-age=60
```

可在接下来的 60 秒缓存和重用响应。

这个 `Cache-Control` 报头告诉浏览器可以在接下来的 60 秒内从缓存中使用这个文件而不必担心是否需要重新验证。60 秒后，浏览器将回访服务器以重新验证该文件。

如果有了一个新文件供浏览器下载，服务器会返回 `200`，浏览器下载新文件，旧文件也会从 HTTP 缓存中被剔除，新的文件会接替它，并应用新缓存报头。

如果并没有新的副本供下载，服务器会返回 `304`，不需要下载新文件，使用新的报头来更新缓存副本。也就是说如果 `Cache-Control: max-age=60` 报头依然存在，缓存文件的 60 秒会重新开始。这个文件的总缓存时间是 120 秒。

**注意**：`max-age` 本身有一个巨坑，它告诉浏览器相关资源已经过期，但没有告诉这个过期版本绝对不能使用。浏览器可能使用它自己的机制来决定是否在不经验证的情况下释放文件的过期副本。这种行为有些不确定性，想确切知道浏览器会怎么做有点困难。为此，我们有一系列更为明确的指令，用来增强 `max-age`，感谢 [Andy Davies](https://twitter.com/AndyDavies) 帮我澄清了这一点。

### `s-maxage`

`s-maxage`（注意 `max` 和 `age` 之间没有 `-`）会覆盖 `max-age` 指令，但只在公共缓存中生效。`max-age` 和 `s-maxage` 结合使用可以让你针对私有缓存和公共缓存（例如代理、CDN）分别设定不同的刷新时间。

## `no-store`

```
Cache-Control: no-store
```

如果我们不想缓存文件呢？如果文件包含敏感信息怎么办？比如一个包含你银行账户信息的 HTML 页面，或者是有时效性的信息？再或者是个包含实时股价的页面？我们根本不想从缓存中存储或释放响应：我们想要的是丢掉敏感信息，获取最新的实时信息。这时候我们需要使用 `no-store`。

`no-store` 是一个非常高优先级的指令，表示不会将任何信息持久化到任何缓存中，无论是私有与否。任何带有 `no-store` 指令的资源都将始终命中网络，没有例外。

## `no-cache`

```
Cache-Control: no-cache
```

这点多数人都会困惑... `no-cache` 并不意味着 “no cache”。它意味着“在你和服务器验证过并且服务器告诉你可以使用缓存的副本之前，你`不`能使用`缓存`中的副本”。没错，听起来应该叫 `must-revalidate`！不过其实也没听起来这么简单。

事实上 `no-cache` 一个可以确保内容最新鲜的非常智能的方式，同时也可以尽可能使用更快的缓存副本。`no-cache` 总是会命中网络，因为在释放浏览器的缓存副本（除非服务器的响应的文件已更新）之前，它必须与服务器重新验证，不过如果服务器响应允许使用缓存副本，网络只会传输文件报头：文件主体可以从缓存中获取，而不必重新下载。

所以如我所言，这是一个兼顾文件新鲜度与从缓存中获取文件可能性的智能方式，缺点是它至少会为了一个 HTTP 报头响应而触发网络。

`no-cache` 一个很好的使用场景就是动态 HTML 页面获取。想想一个新闻网站的首页：既不是实时的，也不包含任何敏感信息，但理想情况下我们希望页面始终显示最新的内容。我们可以使用 `cache-control: no-cache` 来让浏览器首先回访服务器检查，如果服务器没有更新鲜的内容提供（`304`），那我们就重用缓存的版本。如果服务器有更新鲜的内容，它会返回（`200`）并且发送最新的文件。

提示：`max-age` 指令和 `no-cache` 指令一起发送是没用的，因为重新验证的时间限制是零秒。

## `must-revalidate`

更令人困惑的是，虽然上一个指令说应该叫 `must-revalidate`，但事实上 `must-revalidate` 依然是不同的东西。（这次更类似一些）

```
Cache-Control: must-revalidate, max-age=600
```

`must-revalidate` 需要一个关联的 `max-age` 指令；上文我们把它设置为 10 分钟。

如果说 `no-cache` 会立即向服务器验证，经过允许后才能使用缓存的副本，那么 `must-revalidate` 更像是一个具有宽期限的 `no-cache`。情况是这样的，在最初的十分钟浏览器**不会**（我知道，我知道...）向服务器重新验证，但是就在十分钟过去的那一刻，它又到服务器去请求，如果服务器没什么新东西，它会返回 `304` 并且新的 `Cache-Control` 报头应用于缓存的文件 —— 我们的十分钟再次开始。如果十分钟后服务器上有了一个新的文件，我们会得到 `200` 的响应和它的报文，那么本地缓存就会被更新。

`must-revalidate` 一个很适合的场景就是博客（比如我这个博客）：静态页面很少更改。当然，最新的内容是可以获取的，但考虑到我的网站很少更改，我们不需要 `no-cache` 这么下重手的东西。相反，我们会假设在十分钟内一切都好，之后再重新验证。

### `proxy-revalidate`

和 `s-maxage` 一脉相承，`proxy-revalidate` 是公共缓存版的 `must-revalidate`。它被私有缓存简单地忽略掉了。

## `immutable`

`immutable` 是一个非常新而且整洁的指令，它可以把更多有关我们所送出文件类型的信息告知浏览器 —— 文件内容是可变或者不可变吗？了解 `immutable` 是什么之前，我们先看看它要解决什么问题：

用户刷新会导致浏览器强制验证一个文件而不论文件新鲜与否，因为用户刷新往往意味着发生了这两件事之一：

1. 页面崩溃之类的；
2. 内容看起来已经过期了...

...所以我们要检查一下服务器上是否有更加新鲜的内容。

如果服务器上有一个更新鲜的内容可用，我们当然想下载它。这样我们将得到一个 `200` 响应，一个新文件，并且 —— 希望是 —— 问题已经修复了。而如果服务器上没有新文件，我们将返回 `304` 报头，没有新文件，只有整个往返请求的延迟。如果我们重新验证了大量文件且都返回 `304`，这会增加数百毫秒的不必要开销。

`immutable` 就是一种告诉浏览器一个文件永远都不会改变的方法 —— 它是**不可变的** —— 因此不要再费心重新验证它。我们可以完全减去造成延迟的往返开销。那我们说的一个可变或不可变的文件是什么意思呢？

- `style.css`：当我们更改文件内容时，我们不会更改其名称。这个文件始终存在，其内容始终可以更改。这个文件就是可变的。
- `style.ae3f66.css`：这个文件是唯一的 —— 它的命名携带了基于文件内容的指纹，所以每当文件修改我们都会得到一个全新的文件。这个文件就是不可变的。

我们会在 [Cache Busting](https://csswizardry.com/2019/03/cache-control-for-civilians/#cache-busting) 部分详细讨论这个问题。

如果我们能够以某种方式告诉浏览器我们的文件是不可变的 —— 文件内容永远不会改变 —— 那么我们也可以让浏览器知道它不必检查更新版本：永远不会有新的版本，因为一旦内容改变，它就不存在了。

这正是 `immutable` 指令所做的事情：

```
Cache-Control: max-age=31536000, immutable
```

在支持 `immutable` 的浏览器中，只要没超过 31,536,000 秒的新鲜寿命，用户刷新也不会造成重新验证。这意味着避免了响应 `304` 的往返请求，这可能会节约我们在关键路径上（[CSS blocks rendering](https://csswizardry.com/2018/11/css-and-network-performance/)）的大量延迟。在高延迟的场景里，这种节约是可感知的。

注意：千万不要给任何非不可变文件应用 `immutable`。你还应该有一个非常周全的缓存破坏策略，以防无意中将不可变文件强缓存。

## `stale-while-revalidate`

我真的真的希望 `stale-while-revalidate` 能获得更好的支持。

关于重新验证我们已经讲了很多了：浏览器启程返回服务器以检查是否有新文件可用的过程。在高延迟的场景里，重新验证的过程是可以被感知的，并且在服务器回应我们可以发布一个缓存的副本（`304`）或者下载一个新文件（`200`）之前，这段时间简直就是死时间。

`stale-while-revalidate` 提供的是一个宽限期（由我们设定），当我们检查新版本时，允许浏览器在这段宽限期期间使用过期的（旧的）资源。

```
Cache-Control: max-age=31536000, stale-while-revalidate=86400
```

这就告诉浏览器，“这个文件还可以用一年，但一年过后，额外给你一天你可以继续使用旧资源，直到你在后台重新验证了它”。

对于非关键资源来说 `stale-while-revalidate` 是一个很棒的指令，我们当然想要更新鲜的版本，但我们知道在我们检查更新的时候，如果我们依然使用旧资源不会有任何问题。

## `stale-if-error`

和 `stale-while-revalidate` 类似的方式，如果重新验证资源时返回了 `5xx` 之类的错误，`stale-if-error` 会给浏览器一个使用旧的响应的宽限期。

```
Cache-Control: max-age=2419200, stale-if-error=86400
```

这里我们让缓存的有效期为 28 天（2,419,200 秒），过后如果我们遇到内部错误就额外提供一天（86,400 秒），此间允许访问旧版本资源。

## `no-transform`

`no-transform` 和存储、服务、重新验证新鲜度之间没有任何关系，但它会告诉中间代理不得对该资源进行任何更改或**转换**。

中间代理更改响应的一个常见情况是电信提供商代表开发者**为**用户做优化：电信提供商可能会通过他们的堆栈代理图片请求，并且在他们移动网络传递给最终用户前做一些优化。

这里的问题是开发人员开始失去对资源展现的控制，而电信服务商所做的图像优化可能过于激进甚至不可接受，或者可能我们已经将图像优化到了理想程度，任何进一步的优化都没必要。

这里，我们是想要告诉中间商：不要转换我们的内容。

```
Cache-Control: no-transform
```

`no-transform` 可以与其他任何报头搭配使用，且不依赖其他指令独立运行。

当心：有的转换是很好的主意：CDN 为用户选择 Gzip 或 Brotli 编码，看是需要前者还是可以使用后者；图片转换服务自动转成 WebP 等。

当心：如果你是通过 HTTPS 运行，中间件和代理无论如何都不能改变你的数据，因此 `no-transform` 也就没用了。

## Cache Busting

讲缓存而不讲缓存破坏（Cache Busting）是不负责任的。我总是建议甚至在考虑缓存策略之前就先要解决缓存破坏策略。反过来做就是自找麻烦了。

缓存破坏解决这样的问题：“我只是告诉过浏览器在接下来的一年使用这个文件，但后来我改动了它，我不想让用户拿到新副本之前要等一整年！我该怎么做？！”

### 无缓存破坏 —— `style.css`

这是最不建议做的事情：完全没有任何缓存破坏。这是一个可变的文件，我们真的很难破坏缓存。

缓存这样的文件你要非常谨慎，因为一旦在用户的设备上，我们就几乎失去了对他们的所有控制。

尽管这个例子是一个样式表，HTML 页面也纯属这个阵营。我们不能更改一个网页的文件名，想象一下这破坏力！—— 这正是我们倾向于从不缓存它们的原因。

### 查询字符串 —— `style.css?v=1.2.14`

这里依然是一个可变的文件，但是我们在文件路径后加了个查询字符串。聊胜于无，但不尽完美。如果有什么东西把查询字符串删掉了，我们就完全回到了之前讲的没有缓存破坏的样子。很多代理服务器和 CDN 都不会缓存查询字符串，无论是通过配置（例如 Cloudflare 官方文档写到：“...从缓存服务请求时，‘style.css?something’将会被标准化成‘style.css’”）还是防御性忽略（查询字符串可能包含请求特定响应的信息）。

### 指纹 —— `style.ae3f66.css`

添加指纹是目前破坏文件缓存的首选方法。每次内容变更，文件名都会随之修改，严格地讲我们什么都不缓存：我们拿到的是一个全新的文件！这很稳健，并且允许你使用 `immutable`。如果你能在你的静态资源上实现这个，那就去干！一旦你成功实现了这种非常可靠的缓存破坏策略，你就可以使用最极致的缓存形式：

```
Cache-Control: max-age=31536000, immutable
```

#### 实施细节

这种方法的要点就是更改文件名，但它不**非得**是指纹。下面的例子都有同样的效果：

1. `/assets/style.ae3f66.css`：通过文件内容的 hash 破坏。
2. `/assets/style.1.2.14.css`：通过发行版本号破坏。
3. `/assets/1.2.14/style.css`：改变 URL 中的目录。

然而，最后一个示例**意味着**我们要对每个版本进行版本控制，而不是独立文件。这反过来意味着如果我们只想对我们的样式表做缓存破坏，我们也不得不破坏了这个版本的所有静态文件。这可能有点浪费，所以推荐选项（1）或（2）。

### `Clear-Site-Data`

缓存很难失效 —— [这是闻名于计算机科学界的难题](https://martinfowler.com/bliki/TwoHardThings.html) —— 于是有了[一个实现中的规范](https://www.w3.org/TR/clear-site-data/)，这可以帮助开发者明确地一次性清理网站域的全部缓存：`Clear-Site-Data`。

本文我不想深入探究 `Clear-Site-Data`，毕竟它不是一种 `Cache-Control` 指令，事实上它是一个全新的 HTTP 报头。

```
Clear-Site-Data: "cache"
```

给你的域下任何一个静态文件应用这个报头，就会清除整个域的缓存，而不仅是它附着的这个文件。也就是说，如果你需要给你整个网站的所有访客的缓存来个大扫除，你只需把上面这个报头加到你的 HTML 上即可。

[浏览器支持方面](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Clear-Site-Data#Browser_compatibility)，截止到本文写作只支持 Chrome、Android Webview、Firefox 和 Opera。

提示：`Clear-Site-Data` 可以接收很多指令：`"cookies"`、`"storage"`、`"executionContexts"` 和 `"*"`（显然，意思是“上述全部”）。

## 栗子及其食用方法

Okay，让我们看一些场景，以及我们可能使用的 `Cache-Control` 报头的类型。

### 在线银行网页

在线银行之类的应用页面罗列着你最近交易清单、当前余额和一些敏感的银行账户信息，它们都要求实时更新（想象一下，当你看到页面里罗列的账户余额还是一周前的你啥感觉！）而且要求严格保密（你肯定不想把你的银行账户详情存在共享缓存里（啥缓存都不好吧））。

为此，我们这样做：

```
Request URL: /account/
Cache-Control: no-store
```

根据规范，这足以防止浏览器在所有私有缓存和共享缓存中把响应持久化到磁盘中：

> `no-store` 响应指令要求缓存中**不得**存储任何关于客户端请求和服务端响应的内容。该指令适用于私有缓存和共享缓存。上文中“**不得**存储”的意思是缓存**不得**故意将信息存储到非易失性存储器中，并且在接转后**必须**尽最大努力尽快从易失性存储器中删除信息。

但如果你还不放心，也许你可以选择这样：

```
Request URL: /account/
Cache-Control: private, no-cache, no-store
```

这将明确指示不得在公共缓存（例如 CDN）中存储任何信息、始终提供最新的副本并且不要持久化任何东西。

### 实时列车时刻表页面

如果我们打算做一个显示准实时信息的页面，我们要尽可能保证用户总是看到最准确的、最实时的信息，我们使用：

```
Request URL: /live-updates/
Cache-Control: no-cache
```

这个简单的指令会让浏览器不直接未经服务器验证通过就从缓存显示响应。这意味着用户将绝不会看到过期的信息，而如果服务器上有最新信息与缓存中的相同，他们也会享受从缓存中抓取文件的好处。

这几乎对所有网站来说都是一个明智的选择：尽可能给我们最新的内容，同时尽可能让我们享受缓存带来的访问速度。

### FAQ 页面

像 FAQ 这样的页面可能很少更新，而且其内容不太可能对时间敏感。它当然没有实时运动成绩或航班状态那么重要。我们可以将这样的 HTML 页面缓存一段时间，并强制浏览器定期检查新内容，而不用每次访问都检查。我们这样设置：

```
Request URL: /faqs/
Cache-Control: max-age=604800, must-revalidate
```

这会允许浏览器缓存 HTML 页面一周时间（604,800 秒），一旦一周过去，我们需要向服务器检查更新。

当心：给同一个网站的不同页面应用不同的缓存策略会造成一个问题，在你设置 `no-cache` 的首页会请求它引用的最新的 `style.f4fa2b.css`，而在你的加了三天缓存的 FAQ 页依然指向 `style.ae3f66.css`。这种情况可能影响不大，但不容忽视。

### 静态 JS（或 CSS）App Bundle

比方说们的 `app.[fingerprint].js`，更新非常频繁 —— 几乎每次发布版本都会更新 —— 而我们也投入了工作，在文件每次更改时对其添加指纹，然后这样使用：

```
Request URL: /static/app.1be87a.js
Cache-Control: max-age=31536000, immutable
```
无所谓我们有多频繁的更新 JS：因为我们可以做到可靠的缓存破坏，我们想缓存多久就缓存多久。这个例子里我们设置成一年。之所以是一年首先是因为这已经很久了，而且浏览器无论如何也不可能把一个文件保存这么久（浏览器用于 HTTP 缓存的存储空间是限量的，他们会定期清空一部分；用户也可能自己清空缓存）。超过一年的配置大概率没什么用。

进一步讲，因为这个文件内容永不改变，我们可以指示浏览器这个文件是不可变的。一整年内我们都无须重新验证它，哪怕用户刷新页面都不需要。这样我们不仅获得了使用缓存的速度优势，还避免了重新验证造成的延迟弊端。

### 装饰性图片

想象一个伴随文章的纯装饰性照片。它不是信息图表，也不含影响页面其他部分阅读的关键内容。甚至如果它完全不见了用户都关注不到。

图片往往是要下载的重量级资源，所以我们想要缓存它；因为它在页面中没有那么关键，所以我们不需要下载最新版本；我们甚至可以在这张照片过时一点后继续使用。看看怎么做：

```
Request URL: /content/masthead.jpg
Cache-Control: max-age=2419200, must-revalidate, stale-while-revalidate=86400
```

这里我们告诉浏览器缓存 28 天（2,419,200 秒），28 天期限过后我们想向服务器检查更新，如果图片没有超过一天（86,400 秒）的过期时间，那么我们就在后台请求到最新版本后再替换它。

## 要牢记的要点

- 缓存破坏极其极其极其重要。开始做缓存策略之前，先解决好缓存破坏策略。
- 一般来说，缓存 HTML 内容是个馊主意。HTML URL 不能被破坏，毕竟 HTML 页往往是访问页面其他子资源的入口点，你会把通往静态文件的引用声明也缓存下来。这会让你（和你的用户）...一言难尽。
- 缓存 HTML 时，如果一类页面从不缓存而其他类页面有时要用缓存，这种同站不同类型的 HTML 页的不同缓存策略会导致不一致性。
- 如果你能够给你的静态资源可靠地做缓存破坏（使用指纹），那你最好一次性把所有的东西都缓存好几年，以求最优。
- 非关键内容可以用 `stale-while-revalidate` 之类的指令给一个不新鲜宽限期。
- `immutable` 和 `stale-while-revalidate` 不仅能带来缓存的传统效益，还让我们在重新验证时降低延迟成本。

尽可能避免使用网络会为用户提供更快的体验（也会给我们的基础设施更低的吞吐量，两开花）。通过对资源的详细了解和可用内容的总览，我们可以开始针对我们的应用设计做一个颗粒化、定制化且有效的缓存策略。

缓存在手，一切尽在掌控。

## 参考文献和相关阅读

- [*Caching best practices & max-age gotchas*](https://jakearchibald.com/2016/caching-best-practices/) —— [Jake Archibald](https://twitter.com/jaffathecake)，2016
- [*Cache-Control: immutable*](http://bitsup.blogspot.com/2016/05/cache-control-immutable.html) —— [Patrick McManus](https://twitter.com/mcmanusducksong)，2016
- [*Stale-While-Revalidate, Stale-If-Error Available Today*](https://www.fastly.com/blog/stale-while-revalidate-stale-if-error-available-today) —— [Steve Souders](https://twitter.com/Souders)，2014
- [*A Tale of Four Caches*](https://calendar.perfplanet.com/2016/a-tale-of-four-caches/) —— [Yoav Weiss](https://twitter.com/yoavweiss)， 2016
- [Clear-Site-Data](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Clear-Site-Data) —— MDN
- [RFC 7234 -- HTTP/1.1 Caching](https://tools.ietf.org/html/rfc7234) —— 2014

### 依吾言行事，勿观吾行仿之

在某人因我的言行不类开喷之前，有必要一提的是我自己博客的缓存策略这么差强人意，以至于我自己都看不下去了。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
