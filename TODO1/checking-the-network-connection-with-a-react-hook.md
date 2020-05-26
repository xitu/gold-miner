> * 原文地址：[使用 React Hook 来检查网络连接状态](https://medium.com/the-non-traditional-developer/checking-the-network-connection-with-a-react-hook-ec3d8e4de4ec)
> * 原文作者：[Justin Travis Waith-Mair](https://medium.com/@want2code)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/checking-the-network-connection-with-a-react-hook.md](https://github.com/xitu/gold-miner/blob/master/TODO1/checking-the-network-connection-with-a-react-hook.md)
> * 译者：[Jerry-FD](https://github.com/Jerry-FD)
> * 校对者：[TiaossuP](https://github.com/TiaossuP)、[Stevens1995](https://github.com/Stevens1995)

# 使用 React Hook 来检查网络连接状态

![拍摄来自 [NASA](https://unsplash.com/@nasa?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://miro.medium.com/max/6646/0*kVB651dEu92o-J-l)

前端开发是一项包含诸多挑战的工作。这项有趣的工作诞生于这个充满设计、用户体验和工程学的世界。我们作为前端开发者的工作是要运用设计、UX 和 UI 逻辑来给用户“打造”一个舒适的体验。

随着高速专用网络变得越来越普及，网络的正常连接已经习以为常了，但是有一个经常被忽视的问题，当你的用户失去网络连接的时候，你会怎么做，你会给用户什么样的体验。许多时候，我们认为保证网络连接是理所当然的，但现实却并不总是这样。越来越多的页面是由移动设备所展示的，这种网络可不能说是稳定的。Wifi 确实越来普及了，但是 Wifi 的死区也的确存在。就算是物理连接的网线也有可能会被踢掉而失去连接。

这篇文章的重点不是要深入到 UI/UX 中去讨论当用户丢失连接时怎么做才是最佳实践，相反，我是要帮你越过最大的障碍：在 React Component 的环境里，准确地判断你是否处于网络连接状态。

##Navigator 对象

我认为在我们深入了解怎么使用 hook 来实现这个具体功能之前，先来了解 JavaScript 是如何判定当前是否处于有网络的状态非常有意义。这个信息可以通过 Navigator 对象找到。那么什么是 Navigator 对象？可以简单的把它当做是一个只可读取的数据，它根据你的数据，包含当前浏览器的状态和特性。它有定位、userAgent 和一些其他的属性，其中就包括你当前是否处于网络连接状态。和往常一样，我建议你在 [MDN 上查阅关于 Navigator 对象的文档](https://developer.mozilla.org/en-US/docs/Web/API/Navigator)。

你可以从全局的 window 对象上获取 Navigator 对象：`window.navigator` 从这里你可以随之获得其中存在的一项或多项属性。我们想要获取的是 `onLine` 这个属性。这里我特别强调一下。它不是 online，它是驼峰命名的，onLine。

## 在 Hook 中使用

显然我们的首要任务是需要一些状态来跟踪记录我们是否在线的状态以及把它从我们的自定义 hook 中 return 出来：

```js
import {useState} from 'react';

function useNetwork(){
    const [isOnline, setOnline] = useState(window.navigator.onLine);
 
    return isOnline;
}
```

当组件正常挂载时这样做没有问题，但是如果当用户在渲染完成之后掉线我们该怎么做呢？幸运的是，我们可以监听两个事件，触发时以更新状态。为了达到这个效果我们需要使用 useEffect hook：

```js
function useNetwork(){

const [isOnline, setNetwork] = useState(window.navigator.onLine);

useEffect(() => {

window.addEventListener("offline", 
    () => setNetwork(window.navigator.onLine)
);

window.addEventListener("online", 
    () => setNetwork(window.navigator.onLine)
);

});

return isOnline;

};
```

如你所见我们监听了两个事件，`offline` 和 `online` ，当事件触发的时候随之更新状态。处理过 hooks 和事件监听的同学会立刻注意到两个问题。首先是我们需要从这个 useEffect 回调函数中 return 一个清理函数，这样的话 React 可以帮助我们移除事件的监听。

其次是想要依次移除事件的监听，你需要提供同一个函数，这样它才能明确哪一个监听器应该被移除。传入另一个看起来一样的箭头函数不会如期移除事件监听，就算这些监听函数‘长得一样’、‘功能一样‘也不行。所以下面是我们更新后的 hook：


```js
function useNetwork(){

   const [isOnline, setNetwork] = useState(window.navigator.onLine);

   const updateNetwork = () => {

      setNetwork(window.navigator.onLine);

   };

   useEffect(() => {

      window.addEventListener("offline", updateNetwork);

      window.addEventListener("online", updateNetwork);

      return () => {

         window.removeEventListener("offline", updateNetwork);

         window.removeEventListener("online", updateNetwork);

      };

   });

   return isOnline;

};
```

我们现在把函数保存在了变量里面，以此我们可以深入监听和解绑。现在我们已经准备好根据用户是否在线的状态来为用户打造一个独特的体验了。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
