> * 原文地址：[Make Node.js Core Bigger](https://medium.com/node-js-javascript/make-node-js-core-bigger-97ca7ef62b77#.7ofxzzhpt)
* 原文作者：[Mikeal](https://medium.com/@mikeal?source=post_header_lockup)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[imink]()
* 校对者：

# Make Node.js Core Bigger #
# 让 Node.js 核心库更大 # 

In defense of a larger Node.js Core.
捍卫使用更大的 Node.js 核心库

Node.js currently has the smallest standard library of any comparable platform. Combined with great ecosystem tooling like [npm](https://npmjs.org/) this approach has been a huge success.
Node.js 目前在各类适配的平台上使用最小的标准库。配合使用强大的生态工具比如 [npm](https://npmjs.org/)，使用很小的标准库就能够让 Node.js 取得巨大的成功。

This success has created a culture in Node.js that is militant about small re-usable modules, a large ecosystem, and a small core. There’s even a fairly vocal push to make the *existing* Node.js Core surface area **smaller**.
这种成功让 Node.js 的开发形成了一种文化，那就是更倾向于使用体积较小的可复用模块，规模较大的生态系统，同时配合体积较小的核心库。有相当一部分的呼声努力让 Node.js 核心库变得更小。

[**Spotlight #6: "Small Core" - Keeping Node Core Small with Sam Roberts and Thomas Watson**](https://changelog.com/spotlight/6) 

Lost in the enthusiasm for our ecosystem is the role of what Node.js *did* include in its standard library played on *enabling* that ecosystem.
让人们对生态系统抱有热枕是 Node.js 所擅长的，这其中 Node.js 的标准库对生态系统起到了很大作用。

As new technologies emerge there continues to be a need for Node.js Core to set compatibility standards in order for our ecosystem to thrive.
随着新生技术的不断涌现，Node.js 核心库需要不断增强自身的适配性，这样才能促使 Node.js 生态系统的繁荣发展。

#### Not having require(‘http’) would have been a disaster. ####
#### 不使用 require(‘http’) 将会是一场灾难。####

When Node.js started all comparable platforms had standards to connect an HTTP “server” to a “framework.”
当 Node.js 最开始出现时候，所有的类似平台都有一套标准的方法用来关联 HTTP “服务器” 和 “框架”。

[CGI](https://www.w3.org/CGI/) (Perl), [WSGI](https://en.wikipedia.org/wiki/Web_Server_Gateway_Interface) (Python), and [Rack](https://en.wikipedia.org/wiki/Rack_%28web_server_interface%29) (Ruby) are all essentially the same thing, a way to remove the HTTP parsing from the API most developers will actually write their applications to: their web framework. This is particularly important for platforms with poor concurrency because they rely on external web servers (Apache, Nginx, etc) to manage incoming connections and related parsing.
[CGI](https://www.w3.org/CGI/) (Perl), [WSGI](https://en.wikipedia.org/wiki/Web_Server_Gateway_Interface) (Python), 和 [Rack](https://en.wikipedia.org/wiki/Rack_%28web_server_interface%29) (Ruby) 本质上都是同一种东西，程序员们通过 web 框架来构建API，对 HTTP 进行分析。这对于低并发的平台来说是特别重要的，因为程序员可以依赖外部的 web 服务器 (Apache, Nginx, etc) 来管理接收的连接，同时进行相关的请求分析。

When Node.js started in 2009 CommonJS had already defined similar standard for JavaScript called [JSGI](http://wiki.commonjs.org/wiki/JSGI). Support for this standard already existed in other JS platforms like Narwhal and there was pressure to implement it in Node.js as well.
在 2009 年 Node.js 刚开始的时候，CommonJS 已经为 JavaScript 定义了一套类似的标准，叫做 [JSGI](http://wiki.commonjs.org/wiki/JSGI)。针对该标准的服务支持在其他 JS 平台上已经有了比如 Narwhal，Node.js 版本的实现也呼之欲出。

Early Node.js contributor and future npm author [isaacs](https://github.com/isaacs) put together a version of JSGI called [EJSGI](https://github.com/isaacs/ejsgi) (Evented-JSGI) that was compatible with Node.js’ async concurrency model; but this wasn’t the route Node.js ended up taking.
早期的 Node.js 贡献者同时也是后来的 npm 作者 [isaacs](https://github.com/isaacs) 开发了一个 JSGI 版本叫做 [EJSGI](https://github.com/isaacs/ejsgi) (Evented-JSGI)，它能够适配 Node.js 的异步并发模型；但这不是 Node.js 最后的归路。

Instead, Node.js went **much farther** than other platforms. Node.js essentially prescribed the “framework” layer of API and bundled it with the **entire server implementation**. While on the surface Node.js had a smaller total standard library that its contemporaries, it actually went much farther in what it did define.
相反的，Node.js 比其他平台要走得更远。Node.js 基本规定了 API 层面的 “框架”，并将此与 **整个服务器的实现** 捆绑了起来。表面上，Node.js 和它同时期的平台相比有更小的标准库，但实际上它要比自己早期做的事情走的更远。

### Frameworks can be ecosystem poison. ###
### 框架会成为生态系统的毒药 ###

Back in 2009, you could look at Ruby and Python and the multitude of web frameworks available for each and see what the problem was. A diversity of modules is only good for an ecosystem if they are actually compatible with one another. Since frameworks create their own vertical plugin systems they end up with component ecosystems that are incompatible with one another.
回到 2009 年，你可以观察到 Ruby 和 Python 以及其他众多 web 框架所面临的问题。一个模块所带来的多样性只有与其他模块真正适配了才能给生态系统带来好处。因为大多数框架都发明了与自身适配的纵向的插件系统， 但那些插件最终却难以和其他框架适配。

Node.js’ decision to define this layer inverted that trend, forcing a high level of compatibility between modules built for HTTP. When frameworks eventually did emerge they extended the standard API rather than creating entirely incompatible APIs of their own. This meant that most of the modules built for theses frameworks were compatible with one another and that modules written for the “standard” HTTP API worked with every framework.
Node.js 在这种层面上的决定逆转了之前提到的趋势，它迫使那些构建在 HTTP 层面上的模块具有高度的适配性。当框架最终呈现出来的时候，它实际上是扩展了标准库，而不是发明了只能够适配自身的API。这就意味着绝大多数服务于不同框架的模块是相互适配的，而那些用来构建 “标准” HTTP API 的模块则适用于任何一个框架。

A lot of attention is paid to the **size** of the Node.js ecosystem because it’s the largest in the world. Lost in our admiration over its size is the fact that those modules have the **highest level of compatibility** with one another compared to other platforms. That compatibility is all the result of standardized patterns defined by Node.js Core like Streams, Modules, error first callbacks, and to lesser recognized APIs like require(‘http’).
因为 Node.js 拥有世界上最大的生态系统，Node.js 自身的体积大小就值得关注了。同时也因为 Node.js 的模块要比其他平台或者框架有更好的适配性，我们往往过分关注 Node.js 的好处而忽略它自身的大小。这种适配性实际上是 Node.js 核心所定义的标准化模式所带来的，比如 流处理，模块化，错误优先回调，以及不那么被人关注的 API 比如 require(‘http’)。

### Standards belong in Core. ###
### 标准化属于核心库 ###

Maintaining the reference implementations of standards is a burden, there’s no doubt about that. Node.js Core’s stream library will always lag behind the one in npm. *But that doesn’t mean that it doesn’t belong in Core.*
维护标准库的样例实现（译者注：reference implementations 指的是用来强调软件概念的一种实现方式，具体请参考wiki）毫无疑问是一种负担。Node.js 核心库当中的流式处理库的开发在 npm 中总是会慢一拍。*但这不意味着他不属于核心库*

In order for standards to actually reach a critical mass of adoption in the ecosystem, in order for them to truly be relied upon, they have to be included in Core. There are great standards outside of Core in the Node.js ecosystem but none with enough adoption that they can be taken for granted.
为了让标准库能够真正的大规模应用在生态系统当中，并且足够的可靠，这些标准库必须包含在核心库当中。在 Node.js 核心库的生态系统之外，事实上有很多优秀的标准库，但是都没有被理所应当的应用起来。

[Abstract Blob Store](https://github.com/maxogden/abstract-blob-store) is a fantastic standard, one that I try to use whenever possible. While many influential Node.js developers conform to this standard it is nowhere near the point of adoption that it can always be relied upon. Several cloud services still don’t have an implementation and it’s nowhere near the point where service providers conform to it by default, in contrast to the standards defined by Node.js Core.
[Abstract Blob Store](https://github.com/maxogden/abstract-blob-store) 是一个我不会错过的优秀的标准库。然而许多有影响力的 Node.js 开发者都认为它目前还不足以可靠到在具体项目中去使用它。有几家云服务提供商仍然没有该库的实现，并且相对于那些已经被 Node.js 核心库规范化的标准库而言 ，它还远远没有到被默认使用的地步。


The reason we try to keep things out of Core is to encourage innovation in the ecosystem. Standardization is a process of ***discouraging*** a particular type of innovation that limits compatibility. Standardization requires that we de-value and discourage un-compliant innovation. Including these standards in Core discourages competitive standards in the ecosystem **and that’s exactly what we want**.
我们之所以让很多库不在核心库当中是为了鼓励在生态系统中的创新。标准化是一种不提倡特定类型创新的过程，因为这种特定类型的创新会阻碍适配性。标准化要求我们鼓励和看重那些具备适配性的创新。同时核心库当中的标准库也不提倡在生态系统中让标准库互相竞争。以上正是我们想要的。

In the future we’ll want to add standard APIs for technologies like HTTP/2 because we’ll want to replicate the highly compatible ecosystem for HTTP/2 that we have for HTTP/1.1.
将来，我们会在 Node.js 中加入一些新技术比如 HTTP/2 标准的API，因为我们想像当年对待 HTTP/1.1 那样，加入对 HTTP/2 的支持，让整个生态系统具有高度的适配性。
