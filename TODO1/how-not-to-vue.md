> * 原文地址：[How not to Vue: A list of bad things I’ve found on my new job](https://itnext.io/how-not-to-vue-18f16fe620b5)
> * 原文作者：[Anton Kosykh](https://itnext.io/@kelin2025?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-not-to-vue.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-not-to-vue.md)
> * 译者：
> * 校对者：

# How not to Vue 

## A list of bad things I’ve found on my new job

![](https://cdn-images-1.medium.com/max/800/1*pWo4h-AhSfgyFHDlAkchcw.png)

Here’s what some people do.

Not so long ago, I got a new job. And when I saw the code base for the first time, it terrified me. Here I want to show the things you should avoid in Vue.js applications. 

### Static properties in data/computed

There are no reason to pass static properties to `data` and especially in `computed`. When you do it, Vue makes these properties reactive but it’s unnecessary.

![](https://cdn-images-1.medium.com/max/800/1*TUsVw4rEJwhw2iFuSyEWkw.png)

**DON’T**. phone and city have useless reactivity.

![](https://cdn-images-1.medium.com/max/800/1*HYgxVfj99dt-yaGIeSABGw.png)

**DO**. Pass them to `$options`. It’s shorter and no useless work here.

### Thinking that non-reactive data will be reactive

Remember: Vue is not wizard. Vue doesn’t know when your _cookies_ update.

I mentioned cookies because my colleague spent 2 hours to understand why his computed property doesn’t update.

![](https://cdn-images-1.medium.com/max/800/1*mSQ5DXcLOlFK6vfdz-Gyjw.png)

**DON’T**. Computed properties should be based only on Vue reactive data. Otherwise, it just won’t work.

![](https://cdn-images-1.medium.com/max/800/1*Q7HhvYfTsHNUZLMcnptbhw.png)

**DO**. Update your non-reactive things manually.

Also, I recommend you not to use any side-data in computed properties. There should be no side effects in your computed properties. It will save you a lot of time. Believe me.

### Mixins with things that should be done once

Mixins are fine **somebody closes post right now…** Mixins are fine in some cases:

1. Creating plugins that modifies Vue instance, giving new features.
2. Using common specific methods in different components/throughout the application.

But one man made a global mixin with very slow actions in `mounted` hook. Why not? Because it is being called on **each** component mount but may be called only once as well.

I won’t show this code. Instead, to make it clearer, I’ll show you a simpler example.

![](https://cdn-images-1.medium.com/max/800/1*qCp4mZoUYKb2PPoqDFeByA.png)

**DON’T.** Avoid doing this in mixins. It will be called on each component mount when you don’t need that.

![](https://cdn-images-1.medium.com/max/800/1*7-g24ZUvldsPh8XIIPaxTw.png)

**DO.** Do this work in the root instance. It will be called only once. You still have access to the result using `$root`.

#### Incorrect work with setTimout/setInterval

At an interview, one of frontend developers in my team asked me if we can use timeouts/intervals in components. I answered “Yes” and wanted explain how to do it correctly _but I was blamed as incompetent_.

I dedicate this part to a man after whose code I have to maintain now.

![](https://cdn-images-1.medium.com/max/800/1*FxPRflqqk8K6wRr4jUyFBQ.png)

**DON’T.** You can use intervals. But you forget to use `**clearInterval** and will get error on component unmount`.

![](https://cdn-images-1.medium.com/max/800/1*7kBqD5KNSkCTTpP2O7FUgw.png)

**DO.** Use `**clearInterval**` in `beforeDestroy` hook to clear intervals.

![](https://cdn-images-1.medium.com/max/800/1*Tmr7GIY7saojZkOPoVQfuQ.png)

**DO.** If you don’t want to care about, use [**vue-timers**](https://github.com/kelin2025/vue-timers).

### Mutating parents

Thing that I really don’t like in Vue and want to be removed (Evan, please).

I see no real use cases to use `$parent`. It makes components inflexible and may confuse you with unexpected problems.

![](https://cdn-images-1.medium.com/max/800/1*MYb4iAVzlvQPZDWqCnJM0w.png)

**DON’T.** Vue will warn you if you’ll try to mutate `props` but **Vue can’t detect mutations via** `**$parent**`.

![](https://cdn-images-1.medium.com/max/800/1*pJkabHNu8Gx7f4UMM07FMg.png)

**DO.** Use events emitter and listen to events. Also, `v-model` directive is just sugar for `value` prop + `input` event.

![](https://cdn-images-1.medium.com/max/800/1*yypns5Qp2y_t7HrsPT5O7g.png)

**DO.** Vue has one more sugar: `.sync` modifier that updates `prop` on `update:prop` event.

### If/else form validation

I was really confused when I’ve found forms with manual validation. It generates lots of useless boilerplate code.

![](https://cdn-images-1.medium.com/max/800/1*yn_pt6eFfOIz-RvMEA30gQ.png)

**DON’T.** I was terrified by similar code in my new project. Don’t be foolish, there are a lot of solutions for that

![](https://cdn-images-1.medium.com/max/800/1*omOSNM6WmpsYSN3C4dy4dw.png)

**DO.** Use [**vuelidate**](https://monterail.github.io/vuelidate/). Just one line with validation rules for each field. Clean and declarative code.

![](https://cdn-images-1.medium.com/max/800/1*_4S2iHw93lSS_GIeceJ_YA.png)

**DO.** I also made a small [**plugin**](https://github.com/Kelin2025/vuelidate-forms) that allows you to declare form data and validations with one object.

### Instead of conclusion

It’s not all sins that junior Vue.js developers do, and I’m sure that this list may be infinite. But I think it‘s quite enough.

So, what _“interesting”_ things did you see in Vue.js projects? Respond here if you have what to tell :).

Thanks for reading! And don’t repeat dumb errors :) Special thanks to people who contribute to [**carbon.now.sh**](https://carbon.now.sh/). It’s really nice!


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
