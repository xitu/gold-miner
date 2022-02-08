> * 原文地址：[Two-way binding will make your React code better](https://medium.com/front-end-weekly/two-way-binding-will-make-your-react-code-better-f58865923538)
> * 原文作者：[Mikhail Boutylin](https://medium.com/@lahmataja-pa4vara)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2022/.md](https://github.com/xitu/gold-miner/blob/master/article/2022/two-way-binding-will-make-your-react-code-better.md)
> * 译者：
> * 校对者：

# Two-way binding will make your React code better

![](https://miro.medium.com/max/1400/1*qAhyHG_kc614Tm-dkgVbZg.jpeg)

Two-way binding allows creating synchronization between 2 entities, for example, application data and view. React out of the box, provides an api to get one-way binding. When we want to mutate the state, we need explicitly call updating callback:

![](https://miro.medium.com/max/1400/1*pe6DJAtMp35-T2_3m5mYeg.png)

This is done to provide owner to child update experience. So when the root state of the app gets updated, changes will propagate to children. This makes application data flow clear and predictable, however increases the amount of code to write.  
In order to make a two-way binding match with react update philosophy, I’ve built a library called `mlyn`. The main paradigm is that every piece of the state is readable and writable. However when you write to it, the change will bubble to the root of the state, and the root state will be updated:

![](https://miro.medium.com/max/1400/1*4Bkc9QVW0BuaAnkkV0uArQ.png)

That’s it, the engine will update the state in the same way as on the plain react example above.

![](https://miro.medium.com/max/1400/1*SMBgiqvVPFNu42bMUDUJ6w.png)

However two-way binding is not limited to the communication with UI. You can easily bind your value to the local storage. Let say you have a hook that accepts a portion of mlyn state, and target local storage key:

![](https://miro.medium.com/max/1400/1*Jk5jq8PlcKF3o-MR0ZwC7Q.png)

Now you can easily bind user name to it:

![](https://miro.medium.com/max/1400/1*t31zC1_DLjuGXP0LJ31BgA.png)

Note that you don’t need to create/pass any callbacks to update the value, it just works.  
Another use-case is when you want to make changes of the state undoable / re-doable. Once again, just pass this state to the appropriate history management hooks.

![](https://miro.medium.com/max/1400/1*YXmAnheb4irSgooDWp1YPg.png)

The `history` object will contain the api to jump to any step of the state. However, it's a bit customized 2-way binding. Whenever state gets updated, the value is pushed to the history:

![](https://miro.medium.com/max/1400/1*GhiJOFZ096s0132YjIIm_A.jpeg)

When a history entry is selected, this entry is written back to the state:

![](https://miro.medium.com/max/1400/1*6TQ_Iwan_oX8Zdqcm9QOuA.jpeg)

And note again that we don’t write a custom boilerplate for the state update, just connecting the dots. Check this [code sandbox](https://codesandbox.io/s/react-mlyn-todo-mvc-with-history-lr34k?file=/src/App.js:1514-1555) with history management for a TodoMVC app:

![](https://miro.medium.com/freeze/max/60/1*kkac5rgo0BbEfB-8VfFDrg.gif?q=20)

![](https://miro.medium.com/max/1400/1*kkac5rgo0BbEfB-8VfFDrg.gif)

For more examples on 2-way binding and `mlyn` visit [react-mlyn repo](https://github.com/vaukalak/react-mlyn).

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
