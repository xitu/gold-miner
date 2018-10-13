> * 原文地址：[Adaptive Serving using JavaScript and the Network Information API](https://dev.to/addyosmani/adaptive-serving-using-javascript-and-the-network-information-api-331p)
> * 原文作者：[Addy Osmani](https://dev.to/addyosmani)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/adaptive-serving-using-javascript-and-the-network-information-api.md](https://github.com/xitu/gold-miner/blob/master/TODO1/adaptive-serving-using-javascript-and-the-network-information-api.md)
> * 译者：
> * 校对者：

# Adaptive Serving using JavaScript and the Network Information API

**`navigator.connection.effectiveType` is useful for delivering different assets based on the quality of the user's network connection.**

[![](https://res.cloudinary.com/practicaldev/image/fetch/s--Ktkd6j7d--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://thepracticaldev.s3.amazonaws.com/i/4z66d75fid8fje27lp2y.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--Ktkd6j7d--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://thepracticaldev.s3.amazonaws.com/i/4z66d75fid8fje27lp2y.png)

[effectiveType](https://developer.mozilla.org/en-US/docs/Web/API/NetworkInformation/effectiveType) is a property of the [Network Information API](http://w3c.github.io/netinfo/), exposed to JavaScript via the [navigator.connection](https://developer.mozilla.org/en-US/docs/Web/API/Navigator/connection) object. In Chrome, you can drop the following into DevTools to see your effective connection type (ECT):

```
console.log(navigator.connection.effectiveType); // 4G
```

Possible values for `effectiveType` are 'slow-2g', '2g', '3g', or '4g'. On slow connections this capability allows you to improve how quickly pages load by serving lower-quality versions of resources.

Before Chrome 62, we only exposed the theoretical network connection type to developers (via `navigator.connection.type`) rather than the network quality actually experienced by the client.

Chrome's implementation of effective connection type is now determined using a combination of recently observed round-trip times (rtt) and downlink values.

It summarizes measured network performance as the cellular connection type (e.g. 2G) most similar, even if the actual connection is WiFi. i.e. picture you're on Starbucks WiFi, but your actual effective network type is 2G or 3G.

[![](https://res.cloudinary.com/practicaldev/image/fetch/s--T54UF-7H--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://thepracticaldev.s3.amazonaws.com/i/wqeuhx12frs3k126bmrv.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--T54UF-7H--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://thepracticaldev.s3.amazonaws.com/i/wqeuhx12frs3k126bmrv.png)

What about responding to changes in network quality? We can use the `connection.onchange` event listener to monitor for connection changes:

```
function onConnectionChange() {
    const { rtt, downlink, effectiveType,  saveData } = navigator.connection;

    console.log(`Effective network connection type: ${effectiveType}`);
    console.log(`Downlink Speed/bandwidth estimate: ${downlink}Mb/s`);
    console.log(`Round-trip time estimate: ${rtt}ms`);
    console.log(`Data-saver mode on/requested: ${saveData}`);
}

navigator.connection.addEventListener('change', onConnectionChange)
```

Below is a quick test where I emulated a "Low-end mobile" profile in DevTools and was able to switch from "4g" to "2g" conditions:

[![](https://res.cloudinary.com/practicaldev/image/fetch/s--gdIz0VyD--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://thepracticaldev.s3.amazonaws.com/i/t9zadl65erjhll14zbcp.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--gdIz0VyD--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://thepracticaldev.s3.amazonaws.com/i/t9zadl65erjhll14zbcp.png)

`effectiveType` is supported in Chrome, Opera and Firefox on Android. A number of other network quality hints are available on `navigator.connection`, including `rtt`, `downlink` and `downlinkMax`.

An open-source project I've used `effectiveType` in was a Vue.js [Google Doodles](https://oodle-demo.firebaseapp.com) app. Using data-binding, we were able to set a `connection` property to either `fast` or `slow` based on ECT values. Roughly:

```
if (/\slow-2g|2g|3g/.test(navigator.connection.effectiveType)) {
  this.connection = "slow";
} else {
  this.connection = "fast";
}
```

This allowed us to conditionally render different output (a video vs. a low-res image) depending on the user's effective connection type.

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

Max Böck wrote an interesting article about [network-aware components](https://mxb.at/blog/connection-aware-components/) using React. He similarly highlighted how to render different components based on the network speed:

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

Note: You can pair `effectiveType` with Service Workers to adapt to when users are offline in addition to slower effective connection types.

For debugging, you can override the network quality estimate using the Chrome flag "force-effective-connection-type" which can be set from chrome://flags. DevTools Network emulation can provide a limited debugging experience for ECT too.

`effectiveType` values are also exposed via [Client Hints](https://www.chromestatus.com/features/5407907378102272) allowing developers to convey Chrome's network connection speed to servers.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
