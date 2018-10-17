> * 原文地址：[Adaptive Serving using JavaScript and the Network Information API](https://dev.to/addyosmani/adaptive-serving-using-javascript-and-the-network-information-api-331p)
> * 原文作者：[Addy Osmani](https://dev.to/addyosmani)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/adaptive-serving-using-javascript-and-the-network-information-api.md](https://github.com/xitu/gold-miner/blob/master/TODO1/adaptive-serving-using-javascript-and-the-network-information-api.md)
> * 译者：[Raoul1996](https://github.com/Raoul1996)
> * 校对者：[Guangping](https://github.com/GpingFeng)、[CoderMing](https://github.com/CoderMing)

# 使用 JavaScript 和网络信息 API 实现自适应服务

**`navigator.connection.effectiveType` 可以根据用户的网络连接质量得出不同的结果**


[![](https://res.cloudinary.com/practicaldev/image/fetch/s--Ktkd6j7d--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://thepracticaldev.s3.amazonaws.com/i/4z66d75fid8fje27lp2y.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--Ktkd6j7d--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://thepracticaldev.s3.amazonaws.com/i/4z66d75fid8fje27lp2y.png)

[effectiveType](https://developer.mozilla.org/en-US/docs/Web/API/NetworkInformation/effectiveType) 是 [Network Information API](http://w3c.github.io/netinfo/) 的一个属性，在 JavaScript 中通过 [navigator.connection](https://developer.mozilla.org/en-US/docs/Web/API/Navigator/connection) 对象在调用。在 Chrome 浏览器中，你可以把以下内容放入 DevTools 中来查看有效的连接类型（ECT）：

```
console.log(navigator.connection.effectiveType); // 4G
```

`effectiveType` 可取值有 'slow-2g'、'2g'、'3g' 或者 '4g'。在网速慢的时候，此功能可以让你通过提供较低质量的资源来提高页面的加载速度。

在 Chrome 62 之前，我们只向开发者公布了理论上的网络连接类型（通过 `navigator.connection.type`）而不是客户端实际的网络连接质量。

Chrome 的有效连接类型目前是使用最近观察到的往返时间（rtt）和下行链路值的组合来确定。

它将测量到的网络连接性能总结为最接近的蜂窝网络连接类型（比如 2G），即使你实际连接的的 WiFi。如图所示，你连接了星巴克的WiFi，但是实际上你的有效网络类型是 2G 或者 3G。

[![](https://res.cloudinary.com/practicaldev/image/fetch/s--T54UF-7H--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://thepracticaldev.s3.amazonaws.com/i/wqeuhx12frs3k126bmrv.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--T54UF-7H--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://thepracticaldev.s3.amazonaws.com/i/wqeuhx12frs3k126bmrv.png)

如何应对网络连接质量的变化呢？我们可以通过 `connection.onchange` 事件监听器来监听网络变化：

```
function onConnectionChange() {
    const { rtt, downlink, effectiveType,  saveData } = navigator.connection;

    console.log(`有效网络连接类型: ${effectiveType}`);
    console.log(`估算的下行速度/带宽: ${downlink}Mb/s`);
    console.log(`估算的往返时间: ${rtt}ms`);
    console.log(`打开/请求数据保护模式: ${saveData}`);
}

navigator.connection.addEventListener('change', onConnectionChange)
```

下面是一个快速测试，我在 DevTools 中模拟了一个 “低网速的手机” 的配置，并且能够从 “4g” 切换到 ”2g“:

[![](https://res.cloudinary.com/practicaldev/image/fetch/s--gdIz0VyD--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://thepracticaldev.s3.amazonaws.com/i/t9zadl65erjhll14zbcp.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--gdIz0VyD--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://thepracticaldev.s3.amazonaws.com/i/t9zadl65erjhll14zbcp.png)

`effectiveType` 在安卓上的 Chrome、Opera 和 Firefox 得到了支持，有些其它的网络质量提示可以在 `navigator.connection` 中查看，包括 `rtt`，`downlink` 和 `downlinkMax`。

我在基于 Vue.js 的开源项目 —— [Google Doodles](https://oodle-demo.firebaseapp.com) 应用中使用过 effectiveType。基于 ECT 值，我们可以通过使用数据绑定就能够把 `connection` 属性设置为 `fast` 或者 `slow`。大致如下：

```
if (/\slow-2g|2g|3g/.test(navigator.connection.effectiveType)) {
  this.connection = "slow";
} else {
  this.connection = "fast";
}
```

这可以让我们去根据用户的有效连接类型呈现不同的输出（视频或者低分辨率图片）。

```
   <template>
      <div id="home">
        <div v-if="connection === 'fast'">
          <!-- 1.3MB video -->
          <video class="theatre" autoplay muted playsinline control>
            <source src="/static/img/doodle-theatre.webm" type="video/webm">
            <source src="/static/img/doodle-theatre.mp4" type="video/mp4">
          </video>
        </div>
        <!-- 28KB image -->
        <div v-if="connection === 'slow'">
          <img class="theatre" src="/static/img/doodle-theatre-poster.jpg">
        </div>
      </div>
   </template>
```

[![](https://res.cloudinary.com/practicaldev/image/fetch/s--_tvmKtK---/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://thepracticaldev.s3.amazonaws.com/i/8jukzhdu62nbghw0cfx3.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--_tvmKtK---/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://thepracticaldev.s3.amazonaws.com/i/8jukzhdu62nbghw0cfx3.png)

Max Böck 写了一篇关于使用 React [网络感知组件](https://mxb.at/blog/connection-aware-components/)的文章，蛮有意思。他提出了如何根据网络速度渲染不同的组件：

```
switch(connectionType) {
    case '4g':
        return <Video src={videoSrc} />

    case '3g':
        return <Image src={imageSrc.hires} alt={alt} />

    default:
        return <Image src={imageSrc.lowres} alt={alt} />
}
```

注意：你可以将 `effectiveType` 和 Service Workers 搭配使用来应对由于慢速连接而离线了的用户。

调试的话，你可以使用 Chrome flag "force-effective-connection-type" 来覆写网络质量估算，这个 flag 可以在 chrome://flags 中设置。DevTools 网络模拟也可以也可以为 ETC 提供有限的调试体验。

`effectiveType` 值也同样可以通过[客户端提示](https://www.chromestatus.com/features/5407907378102272)公开，允许开发者将 Chrome 的网络连接速度传达给服务器。


> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
