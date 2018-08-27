>* 原文链接 : [Lazy Loading Images? Don’t Rely On JavaScript!](http://robinosborne.co.uk/2016/05/16/lazy-loading-images-dont-rely-on-javascript/)
* 原文作者 : Robin Osborne
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [jk77](http://github.com/jk77me)
* 校对者: [mypchas6fans](http://github.com/mypchas6fans), [hpoenixf](http://github.com/hpoenixf)
          

# 懒加载图片？不要依赖 JavaScript ！

现在许多网页都包含加载图片, 例如:只需访问你最喜欢的购物网站，并通过产品列表页滚动。

正如你想象, 加载页面时引入所有的图片会带来不必要的臃肿, 使用户下载大量他们可能无法看到的数据, 也让页面交互变得很慢, 由于新图片载入会使得页面布局经常发生变化，从而导致浏览器重新加载页面。

一个流行的解决办法是"懒加载"这些图片，就是说, 在用户需要看到图片之前才去加载它们。

如果这项技术应用到‘头版头条’--也就是页面的第一视图部分，用户能得到明显更快的首页浏览体验。

## 因此每个人都应该这样做吗？

在回答这个问题之前，来看看通常是如何实现的。很容易就能找到一个合适的jQuery插件/angularjs模块，然后运行一条简单的安装命令，接下来的你都会做了，只需给image标签添增加一个新属性，或者是用JavaScript函数来处理延迟加载的图片。

综上所述，是不是特别容易？

我们想要达到的效果是，可以只使用html在web页面显示图片，也可以在有其他工具的时候延迟图片显示。 jquery/angularjs的解决方案都对JavaScript、jquery和angularjs有依赖，如果浏览器不支持JavaScript呢？ 如果用户不想仅仅为了实现图片懒加载而下载这些臃肿的库呢？

如果有一些浏览器工具、扩展、插件、广告等等有JavaScript错误时，你的用户就不能看到网页上的图片了，似乎不太机智吧？

## 逐步替换为懒加载图片

鉴于潜在的局限性，让我们搞一个能解决我全部的问题的方案：

a. 去JavaScript化（即：懒加载是一种增强手段)

b. vanilla js - 不依赖jquery/angularjs

c. 可以在JavaScript失效的情况下运作(即：浏览器是支持JavaScript的，但有一个地方出现了JavaScript错误，让你的脚本损坏了，甚至可能不是你的错！)

顺着这个逻辑，用一个数据属性在一个图片元素上是有道理的，并且当元素越来越接近视图时，把src属性和data-src属性进行交换，就像这样：

    <img
    src="1x1.gif" 
    class="lazy" 
    data-src="real-image.jpg" 
    alt="Laziness"
    width="300px" />

然后JavaScript代码是这样的：

    var lazy = document.getElementsByClassName('lazy');

    for(var i=0; i<lazy.length; i++){
     lazy[i].src = lazy[i].getAttribute('data-src');
    }

### a) 去JavaScript化

看起来是合理的第一步，接着我们怎么才能修改到支持去JavaScript化？ 随着一些html的重复，将成为可能：

    <img
    src="1x1.gif" 
    class="lazy" 
    data-src="real-image.jpg" 
    alt="Laziness"
    width="300px" />

    <noscript>
        <img 
        src="real-image.jpg" 
        alt="Laziness"
        width="300px" />
    </noscript>

这意味着如果JavaScript被禁用，懒加载将被忽略。我在网络使用情况中，对上述代码做了快速检查。可以确认使用这些基本的 `noscript` `img` 代码不会导致多个请求！
你不得不承认，这值得一试！

### b) 	去jQuery/angularjs化
依靠上面的HTML代码，我们可以写出下面的JavaScript函数，去做 `data-src` 到 `src` 的切换：

    function lazyLoad(){
        var lazy =
        document.getElementsByClassName('lazy');

        for(var i=0; i<lazy.length; i++){
           lazy[i].src = 
               lazy[i].getAttribute('data-src');
        }
    }

然后，让我们创建一个简单的事件连接起来做跨浏览器支持（因为我们没有使用jQuery）:

    function registerListener(event, func) {
        if (window.addEventListener) {
            window.addEventListener(event, func)
        } else {
            window.attachEvent('on' + event, func)
        }
    }

接着当页面加载时，注册 `lazyload` 函数去执行.

    registerListener('load', lazyLoad);
    
现在当页面加载时我们从 `lazy` 类获取到所有图片，并且用JavaScript去加载，这当然会延迟加载，但不够聪明。

听起来像是我需要一些视图逻辑，像这样(片段来自于StackOverflow)：

    function isInViewport(el){
        var rect = el.getBoundingClientRect();

    return (
        rect.bottom >= 0 && 
        rect.right >= 0 && 

        rect.top <= (
        window.innerHeight || 
        document.documentElement.clientHeight) && 

        rect.left <= (
        window.innerWidth || 
        document.documentElement.clientWidth)
     );
    }

还需要增加视图检查:

    function lazyLoad(){
        var lazy = 
        document.getElementsByClassName('lazy');

        for(var i=0; i<lazy.length; i++) {
            if(isInViewport(lazy[i])){
               lazy[i].src =
                lazy[i].getAttribute('data-src');
            }
        }
     }

同时注册 `scroll` 事件:

    registerListener('scroll', lazyLoad);

> 注意, 这是 _不好的_ , 你不应该当用户在滚动时改变页面。这是为了懒加载的示例实现，请有空时来改善它！

现在我们有了一个只会在视图内加载图片的页面，如果JavaScript被禁用，也会正常加载所有图片

相关文档: [http://codepen.io/rposbo/pen/xVddNr](http://codepen.io/rposbo/pen/xVddNr)

### 重构技巧

在下一个需求（支持损坏的JavaScript）之前, 我想整理一下代码。会在每个滚动事件中检查所有懒加载图片, _即使这些图片已经被加载出来_ 。

这在我的demo里不是个大问题，但在图片更多的时候不是最好的办法，而且感觉很乱！我想从 `lazy` 数组中移除已经加载完毕的图片。

首先，移动 `lazy` 数组到一个共享变量中，在一个载入时就被调用的函数中设置：

    var lazy = [];

    function setLazy(){
     lazy = document.getElementsByClassName('lazy');
    }

    registerListener('load', setLazy);

Ok, 现在我们有包含全部懒加载图片的数组了，但是我需要保持数据是最新的，然后移除使用过的 `data-src` 属性，接着过滤所有图片:

    function lazyLoad(){
        for(var i=0; i<lazy.length; i++){
            if(isInViewport(lazy[i])){
                if (lazy[i].getAttribute('data-src')){
                    lazy[i].src = 
                     lazy[i].getAttribute('data-src');

                    // remove the attribute
                    lazy[i].removeAttribute('data-src');
                }
            }
        }

        cleanLazy();
    }

    function cleanLazy(){
        lazy = 
            Array.prototype.filter.call(
                lazy, 
                function(l){ 
                    return l.getAttribute('data-src');
                 }
            );
    }

这样感觉好多了，现在 `lazy` 数组将永远只包含那些尚未加载的图像。但是正如前面提到的， `onscroll` 事件中做了大量工作。

这个版本在这里: [http://codepen.io/rposbo/pen/ONmgVG](http://codepen.io/rposbo/pen/ONmgVG)

### c) Broken JavaScript

我喜欢这个需求，棘手的挑战才有乐趣。如果浏览器支持JavaScript， `noscript` 标签会被忽略掉，可是，如我开始提到的, 浏览器可能因为某些原因不会执行JavaScript代码。


#### 下面的怎么样？
1.  在窗口中添加足够多的图片填满视图，即只用 `img`的 `src` 属性设置。
2.  在这些图像有链接到一个新页面，是 _未懒加载_ 的 - 整个页面用 `<img>` 标签填充。
3.  用css隐藏所有 `lazy` 图片。
4。 使用JavaScript移除链接，并且移除css隐藏的 `lazy` 图片。

这样想想：如果界面加载和JavaScript中断了，用户会看到满屏图片（1）并且有一个链接去“查看更多”（2），点击后会进入完整的页面（从他们离开的地方）。

如果界面加载和JavaScript都是OK的，这个链接就不会在那（4），懒加载图片会随之进入视图。

让我们来尝试一下。您可以使用自己网站的分析，看看普通用户的分辨率是什么，以及计算有多少子元素都适合在其初始视图，以决定把这个“查看更多”链接放在哪里（2）：

    <div id="viewMore">
        <a href="flatpage.html#more">View more</a>
    </div>

> 假如 `flatpage.html` 只是一个非懒加载版本的同一页，用在项目列表中的相同点的元素。

现在开始隐藏懒加载图片（3），在周围增加了一个新元素:

    <span id="nextPage" class="hidden">
        // all lazy load items go here
    </span>

这个类的css代码:

     .hidden {display:none;}

下面代码会捕获Javascript代码运行出错的用户，并显示一个初始视图，还有一个到整个界面的链接。
JavaScript代码正常的用户将会重新启用懒加载，我在 `setLazy` 函数做这些逻辑（4）：

    // delete the view more link
    document.getElementById('listing')
        .removeChild(
            document.getElementById('viewMore')
        );

    // display the lazy items
    document.getElementById('nextPage')
        .removeAttribute('class');

最终代码:


```
<html>
<head>
    <style>
        .item {width:300px; display: inline-block; }
        .item .itemtitle {font-weight:bold; font-size:2em;}
        .hidden {display:none;}
    </style>
</head>
<body>
    <h1>Amalgam Comics Characters</h1>
<div id="listing">

    <!-- first few items are loaded normally -->
    <div class="item">
        <img 
            src="http://static9.comicvine.com/uploads/scale_medium/0/229/305993-131358-dark-claw.jpg" 
            alt="Dark Claw"
            width="300px" />
        <span class="itemtitle">Dark Claw</span>
    </div>
    
    <div class="item">
        <img 
            src="http://static6.comicvine.com/uploads/scale_super/3/31666/706536-supersoldier8.jpg" 
            alt="Super Soldier"
            width="300px" />
        <span class="itemtitle">Super Soldier</span>
    </div>
    
    <div class="item">
        <img 
            src="http://static3.comicvine.com/uploads/scale_super/3/36899/732353-spidey.jpg" 
            alt="Spider Boy"
            width="300px" />
        <span class="itemtitle">Spider Boy</span>
    </div>
    
    <!-- everything after this is lazy -->
    <div id="viewMore">
        <a href="flatpage.html#more">View more</a>
    </div>
    <span id="nextPage" class="hidden">
        
    <div class="item">
        <img 
            src="http://spacergif.org/spacer.gif" 
            class="lazy" 
            data-src="http://vignette1.wikia.nocookie.net/amalgam/images/7/7c/Iron_Lantern.jpg/revision/latest?cb=20110828093145" 
            alt="Iron Lantern"
            width="300px" />
        <noscript>
            <img 
                src="http://vignette1.wikia.nocookie.net/amalgam/images/7/7c/Iron_Lantern.jpg/revision/latest?cb=20110828093145" 
                alt="Iron Lantern"
                width="300px" />
        </noscript>
        <span class="itemtitle">Iron Lantern</span>
    </div>
    
    <div class="item">
        <img 
            src="http://spacergif.org/spacer.gif" 
            class="lazy" 
            data-src="http://static6.comicvine.com/uploads/scale_super/0/1867/583722-amalgam_amazon1.jpg" 
            alt="Amazon"
            width="300px" />
        <noscript>
            <img 
                src="http://static6.comicvine.com/uploads/scale_super/0/1867/583722-amalgam_amazon1.jpg" 
                alt="Amazon"
                width="300px" />
        </noscript>
        <span class="itemtitle">Amazon</span>
    </div>
    
    <div class="item">
        <img 
            src="http://spacergif.org/spacer.gif" 
            class="lazy" 
            data-src="http://static4.comicvine.com/uploads/scale_super/0/1867/583727-bizarnage1.jpg" 
            alt="Bizarnage"
            width="300px" />
        <noscript>
            <img 
                src="http://static4.comicvine.com/uploads/scale_super/0/1867/583727-bizarnage1.jpg" 
                alt="Bizarnage"
                width="300px" />
        </noscript>
        <span class="itemtitle">Bizarnage</span>
    </div>
    
    <div class="item">
        <img 
            src="http://spacergif.org/spacer.gif" 
            class="lazy" 
            data-src="http://static1.comicvine.com/uploads/scale_super/0/1867/583724-amcatsai1.jpg" 
            alt="Catsai"
            width="300px" />
        <noscript>
            <img 
                src="http://static1.comicvine.com/uploads/scale_super/0/1867/583724-amcatsai1.jpg" 
                alt="Catsai"
                width="300px" />
        </noscript>
        <span class="itemtitle">Catsai</span>
    </div>
    
    <div class="item">
        <img 
            src="http://spacergif.org/spacer.gif" 
            class="lazy" 
            data-src="http://static4.comicvine.com/uploads/scale_super/0/1867/583743-moonwing1.jpg" 
            alt="Moonwing"
            width="300px" />
        <noscript>
            <img 
                src="http://static4.comicvine.com/uploads/scale_super/0/1867/583743-moonwing1.jpg" 
                alt="Moonwing"
                width="300px" />
        </noscript>
        <span class="itemtitle">Moonwing</span>
    </div>
    
    <div class="item">
        <img 
            src="http://spacergif.org/spacer.gif" 
            class="lazy" 
            data-src="http://static5.comicvine.com/uploads/scale_super/0/1867/583739-hawkeyei.jpg" 
            alt="Hawkeye"
            width="300px" />
        <noscript>
            <img 
                src="http://static5.comicvine.com/uploads/scale_super/0/1867/583739-hawkeyei.jpg" 
                alt="Hawkeye"
                width="300px" />
        </noscript>
        <span class="itemtitle">Hawkeye</span>
    </div>
    
    <div class="item">
        <img 
            src="http://spacergif.org/spacer.gif" 
            class="lazy" 
            data-src="http://static3.comicvine.com/uploads/scale_super/0/1867/583733-ammrcury1.jpg" 
            alt="Mercury"
            width="300px" />
        <noscript>
            <img 
                src="http://static3.comicvine.com/uploads/scale_super/0/1867/583733-ammrcury1.jpg" 
                alt="Mercury"
                width="300px" />
        </noscript>
        <span class="itemtitle">Mercury</span>
    </div>
    
    <div class="item">
        <img 
            src="http://spacergif.org/spacer.gif" 
            class="lazy" 
            data-src="http://static2.comicvine.com/uploads/scale_super/0/1867/583737-drfate3.jpg" 
            alt="Dr. Strangefate"
            width="300px" />
        <noscript>
            <img 
                src="http://static2.comicvine.com/uploads/scale_super/0/1867/583737-drfate3.jpg" 
                alt="Dr. Strangefate"
                width="300px" />
        </noscript>
        <span class="itemtitle">Dr. Strangefate</span>
    </div>

  </span>
 </div>

<script>
var lazy = [];
registerListener('load', setLazy);
registerListener('load', lazyLoad);
registerListener('scroll', lazyLoad);
registerListener('resize', lazyLoad);
function setLazy(){
    document.getElementById('listing').removeChild(document.getElementById('viewMore'));
    document.getElementById('nextPage').removeAttribute('class');
    
    lazy = document.getElementsByClassName('lazy');
    console.log('Found ' + lazy.length + ' lazy images');
} 
function lazyLoad(){
    for(var i=0; i<lazy.length; i++){
        if(isInViewport(lazy[i])){
            if (lazy[i].getAttribute('data-src')){
                lazy[i].src = lazy[i].getAttribute('data-src');
                lazy[i].removeAttribute('data-src');
            }
        }
    }
    
    cleanLazy();
}
function cleanLazy(){
    lazy = Array.prototype.filter.call(lazy, function(l){ return l.getAttribute('data-src');});
}
function isInViewport(el){
    var rect = el.getBoundingClientRect();
    
    return (
        rect.bottom >= 0 && 
        rect.right >= 0 && 
        rect.top <= (window.innerHeight || document.documentElement.clientHeight) && 
        rect.left <= (window.innerWidth || document.documentElement.clientWidth)
     );
}
function registerListener(event, func) {
    if (window.addEventListener) {
        window.addEventListener(event, func)
    } else {
        window.attachEvent('on' + event, func)
    }
}
</script>
</body>
</html>

```

实时预览代码: [http://codepen.io/rposbo/pen/EKmXvo](http://codepen.io/rposbo/pen/EKmXvo)

## 总结

正如你看到的，的确实现了懒加载图片（包括你想了解的其他内容），同时对损坏的JavaScript和不支持JavaScript的条件下进行了兼容。


这有一个GitHub仓库作为实践，展示了主页面和“flat”列表页的区别：[https://github.com/rposbo/lazyloadimages](https://github.com/rposbo/lazyloadimages)

此仓库还展示了在.NET中实现的解决方案，通过相同的动态生成items到两个列表页。


