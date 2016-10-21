>* 原文链接 : [jQuery 3.0 Final Released!](https://blog.jquery.com/2016/06/09/jquery-3-0-final-released/)
* 原文作者 : [Timmy Willison](https://blog.jquery.com/author/timmywil/)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [Dwight](https://github.com/ldhlfzysys)
* 校对者: [buccoji](https://github.com/buccoji), [thanksdanny](https://github.com/thanksdanny)

# jQuery 终于发布了

从2014年10月开发到现在，jQuery 3.0终于发布了！我们的目的是创造一个更苗条、更快的jQuery版本（并且考虑到了向后兼容性）。我们已经删除了旧的IE浏览器的解决方案支持并且采用了一些更现代化的 web API。它是2.x分支的延续，并且加入了几项我们认为早该加入的重大改变。虽然 1.12 和 2.2 分支在短时间内会继续收到关键的补丁，但不会有新的功能和重大更改。jQuery 3.0是jQuery的未来。如果你需要支持IE6-8，你可以继续使用1.12的最新版本。

虽然一下升级到了3.0版本，我们预计在升级现有代码的时候不会发生太多问题。当然，此次主版本号的更新有着打破一切的大改变，但我们希望这些改变不会破坏大多数人的代码。

为了帮助大家升级，我们有一个全新的升级指南 [3.0 Upgrade Guide](https://jquery.com/upgrade-guide/3.0/)。和迁移插件 [jQuery Migrate 3.0 plugin](https://github.com/jquery/jquery-migrate#migrate-older-jquery-code-to-jquery-30) 来帮助你定位代码的兼容问题。 你对这些变化的反馈将极大的帮助我们，所以请尝试在你现有的代码和插件里使用它们。

你可以从 jQuery CDN 获取这些文件, 或直接链接它们:

[https://code.jquery.com/jquery-3.0.0.js](https://code.jquery.com/jquery-3.0.0.js)

[https://code.jquery.com/jquery-3.0.0.min.js](https://code.jquery.com/jquery-3.0.0.min.js)

通过 npm 安装:

    npm install jquery@3.0.0

此外，我们已经发布 jQuery Migrate 3.0（迁移插件）。我们极度推荐使用它来解决迁移jQuery 3.0时遇到的所有问题。你可以在这里获取这些文件：

[https://code.jquery.com/jquery-migrate-3.0.0.js](https://code.jquery.com/jquery-migrate-3.0.0.js)

[https://code.jquery.com/jquery-migrate-3.0.0.min.js](https://code.jquery.com/jquery-migrate-3.0.0.min.js)

    npm install jquery-migrate@3.0.0

在这里查看更多关于升级 jQuery 1.x 和 2.x 到 3.0 过程中 jQuery Migrate 的帮助信息：
[the jQuery Migrate 1.4.1 blog post](http://blog.jquery.com/2016/05/19/jquery-migrate-1-4-1-released-and-the-path-to-jquery-3-0/).

### 精简版

最后，此次发布我们还加入了一些新东西。有时你并不需要ajax，或者在众多独立库中你只需要一个用于 ajax 请求的库。以往，更简单的方式是使用CSS和类的组合操作来满足所有的web动画需求。针对普通版的jQuery包含ajax和effects modules（效果模块），我们发布了没有这些内容的精简版。总而言之，精简版删除了ajax,effects和已经废弃的代码。jQuery的大小和对加载性能的影响已经微乎其微，但是精简版仍在gzip压缩下比普通版小了6k左右，23.6k vs 30k。这些文件也都可以在npm包和CDN获得。

[https://code.jquery.com/jquery-3.0.0.slim.js](https://code.jquery.com/jquery-3.0.0.slim.js)

[https://code.jquery.com/jquery-3.0.0.slim.min.js](https://code.jquery.com/jquery-3.0.0.slim.min.js)

此版本是通过我们的自定义建构 API 生成，因此你可以按照自己的需求来选择添加或剔除某些模块。更多的信息请看： [jQuery README](https://github.com/jquery/jquery/blob/master/README.md#how-to-build-your-own-jquery)。


##  jQuery UI 和 jQuery Mobile 的兼容


虽然大部分是没有问题的，但是有几个jQuery UI和jQuery Mobile的兼容问题已经在即将发布的版本里被解决，如果你发现问题，请记住它有可能已经在上游被解决，用[jQuery Migrate 3.0 plugin](http://code.jquery.com/jquery-migrate-3.0.0.js)来修复它，新版本预计很快发布。

## 主要的变化

这些发布中，高亮的地方表示重要的新特性、改进和bug修复。你可以在[3.0 Upgrade Guide](https://jquery.com/upgrade-guide/3.0/)挖掘更详细的信息。完整的问题解决列表在我们的[GitHub bug tracker](https://github.com/jquery/jquery/issues?q=is%3Aissue+milestone%3A3.0.0)。如果你看了 3.3.0-rc1的博客帖子，以下说的和博客里是一样的。

### jQuery.Deferred 已经兼容 Promises/A+ 规范


jQuery.Deferred 对象已经升级兼容 Promises/A+ 和 ES2015 规范，且已在[Promises/A+ Compliance Test Suite](https://github.com/promises-aplus/promises-tests)验证。这意味着`.then()`方法会有一些重大的改变。Legacy行为可以通过使用现在不宜用的.pipe()方法(具有签名认证)来代替.then()使用来重新获取

1.  在`.then()` 抛出异常变成一个拒绝值。以前，异常在回调里被一路抛出。任何deferred对象依靠deferred抛出异常的方式都无法解决问题。

#### 示例: 未捕获异常 vs. 拒绝值

    var deferred = jQuery.Deferred();
    deferred.then(function() {
      console.log("first callback");
      throw new Error("error in callback");
    })
    .then(function() {
      console.log("second callback");
    }, function(err) {
      console.log("rejection callback", err instanceof Error);
    });
    deferred.resolve();

在以前，“first callback” 将会打印，异常会被抛出。然后就会终止，"second callback" 和 “rejection callback” 都不会被打印。在新版里，符合标准的行为是你将会看到 "rejection callback" 和 `true` 被打印，`err` 是第一个回调的拒绝值。

2.  通过`.then()`创建Deferred的resolution状态现在是被它的回调函数控制-异常将会是拒绝值（rejection values）且 non-thenable 返回的结果是 fulfillment 值。而之前的版本中，拒绝处理 （rejection handler）返回的结果是 rejection 值

#### 示例: 来自拒绝回调函数的返回值

    var deferred = jQuery.Deferred();
    deferred.then(null, function(value) {
      console.log("rejection callback 1", value);
      return "value2";
    })
    .then(function(value) {
      console.log("success callback 2", value);
      throw new Error("exception value");
    }, function(value) {
      console.log("rejection callback 2", value);
    })
    .then(null, function(value) {
      console.log("rejection callback 3", value);
    });
    deferred.reject("value1");

以前，将会打印“rejection callback 1 value1”, “rejection callback 2 value2”, 和 “rejection callback 3 undefined”.

现在，符合标准的行为是打印“rejection callback 1 value1”, “success callback 2 value2″, 和 “rejection callback 3 [object Error]”

3.  回调通常是异步的，即使Deferred已被解决。在这之前，这些回调一经绑定会同步执行。

#### 示例: 异步 vs 同步

    var deferred = jQuery.Deferred();
    deferred.resolve();
    deferred.then(function() {
      console.log("success callback");
    });
    console.log("after binding");

以前，会先打印 “success callback” 然后打印 “after binding”。现在，先打印 “after binding” 然后打印 “success callback”.

#### 重要：当捕获异常时有利于在浏览器中进行调试，通过拒绝回调函数来处理异常非常具有陈述性。当与promises打交道时，记住至少要增加一个拒绝回调函数。否则，任何错误都不会提示。

我们写了一个插件用来调试 Deferreds 的 Promises/A+ 兼容性。如果在控制台无法看到错误的详细信息和来源，可查阅这里[jQuery Deferred Reporter Plugin](https://github.com/dmethvin/jquery-deferred-reporter).

`jQuery.when` 升级后可以接受所有thenable 对象，包括原生的 Promise 对象。

[https://github.com/jquery/jquery/issues/1722](https://github.com/jquery/jquery/issues/1722)  
[https://github.com/jquery/jquery/issues/2102](https://github.com/jquery/jquery/issues/2102)

### 为 Deferreds 添加 .catch()

`catch()`方法在promise 对象中的别名是 `.then(null, fn)`。

[https://github.com/jquery/jquery/issues/2102](https://github.com/jquery/jquery/issues/2102)

### 错误情况不静默失败

也许在夜深人静的时候，你突然会想“window的offset是多少？”，然后你意识到这是一个疯狂的问题 —— window哪来的offset？

在过去，jQuery 也尝试过去返回*某些东西*而不是抛出异常。在这个window的offset问题的例子里，在jQuery 3.0里答案是`{ top: 0, left: 0 }`，这种情况下，疯狂的问题会抛出错误而不是被默默的忽略了。请在这个版本里试试所有以来jQuery的代码是否会影藏类似无效的输入。

[https://github.com/jquery/jquery/issues/1784](https://github.com/jquery/jquery/issues/1784)

### 删除弃用的事件别名

`.load`, `.unload`, 和 `.error`, 在jQuery 1.8后被废弃，使用 `.on()` 来注册监听器。

[https://github.com/jquery/jquery/issues/2286](https://github.com/jquery/jquery/issues/2286)

### 动画现在使用`requestAnimationFrame`

在支持`requestAnimationFrame` API的平台上，除IE9和Android4.4外，几乎被广泛支持。jQuery现在也将使用这个API来处理动画。这将让动画更加顺滑、更少的cpu消耗，在移动端也将更省电。

jQuery在几年前曾尝试使用`requestAnimationFrame`。但现存代码有有几个[严重兼容性问题](http://blog.jquery.com/2011/09/01/jquery-1-6-3-released/)不得不推迟。我们认为通过在浏览器选显卡显示的时候暂定动画处理好了大部分问题，但是，所有依赖动画的代码想要实时执行是不切合实际的。

### jQuery自定义选择器的大提速

感谢来自谷歌的 Paul Irish的检测工作，我们发现当`:visible`这种的自定义选择器在同一份文件中被多次执行时，大量额外的运算可以省略跳过。现在这一类的运算速度提升了 17 倍！

要记住的是，尽管有了这些改进，但像 `:visible` 和 `:hidden` 这类选择器耗时代价还是很高的，因为依赖浏览器上的元素是否已经展示出来。在最坏的情况下，这可能需要在完全重算CSS样式和页面布局后才能执行。大部分情况我们不能阻止你去使用它，但我们建议你可以测试一下你的页面，看看这些选择器是否造成了性能问题。

这些改动其实在1.12/2.2就已经完成了，但是我们还是想在jQuery 3.0里重申一次。

[https://github.com/jquery/jquery/issues/2042](https://github.com/jquery/jquery/issues/2042)

如上面提到的，[升级指南](https://jquery.com/upgrade-guide/3.0/) 已为各位备好，除了有助于升级，还列出了更多显著的变化。

