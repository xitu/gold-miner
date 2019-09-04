> * 原文地址：[Checking The Network Connection With a React Hook](https://medium.com/the-non-traditional-developer/checking-the-network-connection-with-a-react-hook-ec3d8e4de4ec)
> * 原文作者：[Justin Travis Waith-Mair](https://medium.com/@want2code)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/checking-the-network-connection-with-a-react-hook.md](https://github.com/xitu/gold-miner/blob/master/TODO1/checking-the-network-connection-with-a-react-hook.md)
> * 译者：
> * 校对者：

# Checking The Network Connection With a React Hook

![Photo by [NASA](https://unsplash.com/@nasa?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://miro.medium.com/max/6646/0*kVB651dEu92o-J-l)

Front end development is a unique set of challenges. It lives in a world of design, user experience, and engineering at the same time. Our jobs as front end engineers are to “engineer” delightful experiences using design, UX, and UI logic.

In a world of highspeed dedicated internet connections becoming more and more commonplace, one of those often-overlooked experiences is what to do in your experience based on if the client is no longer online. Often times we just take for granted that we will be online, but that isn’t always the case. More and more web usage is being handled over mobile phones which is never able to be reliable. Wifi is getting better, but Wifi dead zones do exist. Even those who are hard-wired can be a broken utility cable away from being kicked off that dedicated highspeed connection.

The point of this article is not to get into the UI/UX on what best practices you should do when a client is no longer online. Instead, I am intending to get you past the most important hurdle of them all: Actually determining if you are online in the context of a React Component.

## The Navigator Object

Before we get into the aspect of implementing this in a hook, I think it’s important to understand how JavaScript can determine if it is online or not. This information is found using the Navigator object. What is the Navigator object? Simply put it is an object of read-only data about the state and identity of the specific browser using your data. It has properties such as geolocation, userAgent, and many other things including if you are online or not. As always, I would recommend checking out the [documentation found over at MDN regarding the Navigator object](https://developer.mozilla.org/en-US/docs/Web/API/Navigator).

You access the Navigator object from the global window object like so: `window.navigator` and from there you can then access one of the many properties that it has available. The specific property we are looking for is the `onLine` property. Take special note on the casing. It’s NOT online it is camel-cased, onLine.

## Using It In a Hook

The obvious first thing we need is some state to keep track of whether we are online and return that from our custom hook:

```js
import {useState} from 'react';

function useNetwork(){
    const [isOnline, setOnline] = useState(window.navigator.onLine);
 
    return isOnline;
}
```

This is good for when the component mounts, but what happens if the client goes offline after it mounts? Luckily there are two events we can listen for that we can use to trigger an update to your state. To do this we need the useEffect hook, like this:

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

As you can see we are listening to two events, `offline` and `online` and then updating the state when the event is triggered. Anyone who has dealt with hooks and event listeners will see two obvious problems. The first is that we need to return a cleanup function from this useEffect callback so that React can remove our event listeners.

The second is that if inorder to remove an event listener, you need to provide the same function, so it knows which listener to remove. Passing in another arrow function that looks the same is not a going to remove the event listener even if the function ‘looks’ and ‘acts’ the same. So here is how we will update our hook:

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

We have now saved off the function into a variable that we can pass into both the add and remove event listener. Now we are ready to build a unique experience for our customers depending on if they are still online or not.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
