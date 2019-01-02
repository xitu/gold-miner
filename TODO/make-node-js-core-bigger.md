> * 原文地址：[Make Node.js Core Bigger](https://medium.com/node-js-javascript/make-node-js-core-bigger-97ca7ef62b77#.7ofxzzhpt)
* 原文作者：[Mikeal](https://medium.com/@mikeal?source=post_header_lockup)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[imink](http://github.com/imink)
* 校对者：[jifaxu](https://github.com/jifaxu) [FrankXiong](https://github.com/FrankXiong)

# 让 Node.js 核心更强大 #

捍卫使用更强大的 Node.js 核心

相对于其它平台，Node.js 拥有最小的标准库。配合使用强大的生态工具比如 [npm](https://npmjs.org/)，Node.js 已经取得了巨大的成功。

这种成功让 Node.js 的开发形成了一种文化，那就是更倾向于使用体积较小的可复用模块，规模较大的生态系统，同时配合体积较小的核心库。有不少人呼吁让 Node.js 的核心库变得更小。

[**Spotlight #6: "Small Core" - Keeping Node Core Small with Sam Roberts and Thomas Watson**](https://changelog.com/spotlight/6) 

让人们对生态系统抱有热枕是 Node.js 所擅长的，这其中 Node.js 对第三方库的标准规范对生态系统起到了很大作用。

随着新生技术的不断涌现，Node.js 核心需要建立一个关于兼容性的标准规范，这样才能促使 Node.js 生态系统的繁荣发展。

#### 不使用 require(‘http’) 将会是一场灾难。 ####

当 Node.js 最开始出现时候，所有的类似平台都有一套规范的方法用来关联 HTTP “服务器” 和 “框架”。

[CGI](https://www.w3.org/CGI/) (Perl), [WSGI](https://en.wikipedia.org/wiki/Web_Server_Gateway_Interface) (Python), 和 [Rack](https://en.wikipedia.org/wiki/Rack_%28web_server_interface%29) (Ruby) 本质上都是同一种东西，程序员们通过 web 框架来构建 API，对 HTTP 进行分析。这对于低并发的平台来说是特别重要的，因为程序员可以依赖外部的 web 服务器 (Apache, Nginx, etc) 来管理接收的连接，同时对 HTTP 进行分析。

在 2009 年 Node.js 刚开始的时候，CommonJS 已经为 JavaScript 定义了一套类似的规范，叫做 [JSGI](http://wiki.commonjs.org/wiki/JSGI)。针对该规范的服务支持在其他 JS 平台上早已存在，比如 Narwhal，Node.js 版本的实现也呼之欲出。

早期的 Node.js 贡献者同时也是后来的 npm 作者 [isaacs](https://github.com/isaacs) 开发了一个 JSGI 版本叫做 [EJSGI](https://github.com/isaacs/ejsgi) (Evented-JSGI)，它能够兼容 Node.js 的异步并发模型；但这不是 Node.js 最后的归路。

相反的，Node.js 比其他平台要走得更远。Node.js 基本规定了 API 的”框架”层，并将此与 **整个服务器的实现** 捆绑了起来。表面上，Node.js 和它同时期的平台相比有更小的标准库，但实际上它要比自己早期做的事情走的更远。

### 框架会成为生态系统的毒药 ###

回到 2009 年，你可以观察到 Ruby 和 Python 以及其他众多 web 框架所面临的问题。只有模块间相互兼容，模块多样性才有益于生态系统。因为大多数框架都发明了与自身兼容的纵向的插件系统，但那些插件最终却难以和其他框架兼容。

Node.js 定义框架层的决定逆转了之前提到的趋势，它迫使那些构建在 HTTP 层面上的模块互相之间具有同样高度的兼容性。当框架最终呈现出来的时候，它实际上是扩展了标准库，而不是发明了只能够兼容自身的 API。这就意味着绝大多数服务于不同框架的模块是相互兼容的，而那些用来构建 “标准” HTTP API 的模块则适用于任何一个框架。

Node.js 因为拥有世界上最大的生态系统而得到了广泛关注。相对于其它平台而言，如此大的生态还能保持模块间的高度兼容性这一点更是让人佩服不已。这种兼容性实际上是 Node.js 核心所定义的标准化规范所带来的，比如 Stream 、模块化、错误优先回调、以及不那么被人关注的 API，比如 require(‘http’)。

### 标准化属于核心 ###

维护标准库的样例实现（译者注：reference implementations 指的是用来强调软件概念的一种实现方式，具体请参考wiki）毫无疑问是一种负担。Node.js 自带的 stream 库总是比 npm 里的差几个版本。**但这不意味着他不属于核心**

为了让标准库能够真正的大规模应用在生态系统当中，并且足够的可靠，这些标准规范必须纳入到核心当中。在 Node.js 核心库的生态系统之外有很多优秀的标准库，但是都没有被理所应当的应用起来。

[Abstract Blob Store](https://github.com/maxogden/abstract-blob-store) 是一个我不会错过的优秀的标准库。然而许多有影响力的 Node.js 开发者都认为它目前还不足以可靠到在具体项目中去使用它。有几家云服务提供商仍然没有该库的实现，并且相对于那些已经被 Node.js 核心规范化的标准库而言 ，它还远远没有到被默认使用的地步。

我们之所以让很多库不在核心库当中是为了鼓励在生态系统中的创新。规范化是一种不提倡特定类型创新的过程。通过将这些标准规范纳入 Node.js 核心，我们希望能够阻止生态系统中各种规范间的相互竞争。

将来，我们会在 Node.js 中加入一些新技术，比如 HTTP/2 标准的 API，因为我们想像当年对待 HTTP/1.1 那样，加入对 HTTP/2 的支持，保持生态系统的高度兼容性。
