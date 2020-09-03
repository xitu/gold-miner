> * 原文地址：[6 Ways to Speed Up Your Vue.js Application](https://medium.com/better-programming/6-ways-to-speed-up-your-vue-js-application-2673a6f1cde4)
> * 原文作者：[Aris Pattakos](https://medium.com/@aris.pattakos)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/6-ways-to-speed-up-your-vue-js-application.md](https://github.com/xitu/gold-miner/blob/master/article/2020/6-ways-to-speed-up-your-vue-js-application.md)
> * 译者：
> * 校对者：

# 6 Ways to Speed Up Your Vue.js Application

#### A checklist you can use to ensure your Vue app is lightning fast

![](https://cdn-images-1.medium.com/max/2400/1*aW-r70mA9ByajQQfiFh5hQ.png)

If you’ve ever used Google’s Pagespeed Insights or Google Lighthouse then you’ve seen this webpage performance assessment:

![](https://cdn-images-1.medium.com/max/2000/1*UzMBfW8YlXv39Mc9vfKt6Q.png)

You receive a set of statistics, then some diagnostics on how fast (or slow) your website is.

Some of the diagnostics can be pretty useful, indicating some easy fixes, unused files, and requests that are slow or take a lot of space.

Other diagnostics, such as main-thread work and Javascript execution time do show problems but they don’t really help you fix them.

In this article I’ll go through the steps you can follow to make sure your Vue application is working as fast as possible. With these steps, you’ll know exactly what to fix and you won’t have to guess anything.

---

## 1. Update Only What’s Needed

One of the nastiest issues you can run into with VueJS is rendering the same elements or list of elements more times than needed. To understand why or how this can happen we have to understand reactivity in Vue.

This example is from the official Vue.js documentation and it shows which properties are reactive and which are not. There are many reactive elements in Vue: properties assigned to the data object, computed properties, or methods that rely on reactive properties.

```JavaScript
var vm = new Vue({
  data: {
    a: 1
  }
})
// `vm.a` is now reactive

vm.b = 2
// `vm.b` is NOT reactive
```

But a plain JavaScript code, such as `{{ 'value' }}` or `{{ new Date() }}`, is not tracked by Vue as a reactive property.

So what does reactivity have to do with duplicate rendering?

Let’s say you have an array of objects like this in your `data` object:

```
values: [{id: 1, t: 'a'}, {id: 2, t: 'b'}]
```

And you’re rendering it using `v-for`:

```
<div v-for="value in values" :key="value.id">{{ value.t }}</div>
```

When a new element is added to the list Vue will re-render the whole list. Not convinced? Try writing it like this:

```
<div v-for="value in values" :key="value.id">
  {{ value.t }}
  {{ new Date() }}
</div>
```

The JavaScript `Date` object is not reactive so it doesn’t affect rendering. It will only be called if the element has to be rendered again. What you will see in this example, is that every time a value is added or removed from `values` a new Date will pop up on all rendered elements.

What should you expect in a more optimized page? You should expect only the new or changed elements to show a new `Date`, while the others should not be rendered at all.

So, what does `key` do and why are we passing it? The `key` property helps Vue understand which element is which. If the order of the array changes, `key` helps Vue shuffle the elements into place, rather than going through them one-by-one again.

Specifying a `key` is important, but it’s not enough. In order to make sure you’re getting the best performance, you need to create `Child` components. That’s right — the solution is pretty simple. You just have to divide your Vue app into small, lightweight components.

```
<item :itemValue="value" v-for="item in items" :key="item.id"></item>
```

This item component will only update if the specific item has a reactive change (for example with [Vue.set](https://vuejs.org/v2/api/#Vue-set))

The performance gain of using components to render lists is tremendous. If an element is added or removed from the array, Vue won’t render all the components one-by-one again. If the array is sorted, Vue just shuffles the elements by relying on the provided `key`.

If the component is really lightweight, you can do one better. Instead of passing a complete object like `value` you could pass a primitive property (String or Number) like `:itemText="value.t”`. With that in place, `\<item> `will only be re-rendered if the primitive values you passed have changed. This means that even reactive changes will cause an update — but it’s not needed!

---

## 2. Eliminate Duplicate Rendering

Rendering full lists or heavy elements more times than needed is quite a sneaky issue, but it’s very easy to make happen.

Let’s say you have a component that has an `entities` property in the data object.

If you followed the previous step, then you probably have a child component to render each entity.

```
<entity :entity="entity" v-for="entity in entities" :key="entity.id" />
```

The entity template looks something like this:

```Vue
<template>
  <div>
    <div>{{ user.status }}</div>
    <div>{{ entity.value }}</div>
  </div>
</template>
```

It outputs `entity.value`, but it also uses `user` from the `vuex` state. Now let’s say you have an `auth` function that refreshes the user token, or the global user property is changed in any way. This would cause the entire view to update any time something changes, even if `user.status` stays the same!

There are a few ways to handle it. A simple one would be to pass the `user.status` value as a `userStatus` prop from the parent. If the value is unchanged, Vue will not render it again since it doesn’t have to.

The key here is to be aware of the rendering dependencies. Any prop, data value, or computed value that changes can cause a re-render.

How can you identify duplicate renders?

First of all download the official [Vue.js dev tools](https://chrome.google.com/webstore/detail/vuejs-devtools/nhdogjmejiglipccpnnnanhbledajbpd?hl=en)!

Then use the “Performance tab” to measure your Vue app’s performance. Press start and stop to run a performance check, ideally during the app load.

![Vue.js dev tools Screenshot](https://cdn-images-1.medium.com/max/3710/1*uRo4r7Rbncqnrx8dbhVCtw.png)

And then go to the “Component Render” tab. If your page renders 100 components, then you should see 100 `created` events.

What’s important to note here are the `updated` events. If you have more updated events than created events, without an update in the actual values, it’s likely you have duplicate changes that lead to duplicate rendering.

This can happen if your code changes the `entities` value many times instead of batching the updates. Or it can happen if you’re using some sort of realtime database like Firestore and you’re getting more snapshots than expected. (Firestore can send many snapshots per update, especially if you have Firestore triggers that update related documents).

The solution here is to avoid changing entities more times than is necessary. In the case of Firestore snapshots, you can use debounce or throttle functions to avoid changing the `entities` property too often.

---

## 3. Optimize Event Handling

Not all events are created equal and as such you have to make sure you’re correctly optimizing for each of them.

Two great examples are `@mouseover` and `window.scroll` events. These two types of events can be triggered many times even with normal usage. If the event handlers you have in place make costly calculations, these calculations will run multiple times per second causing lag in your application. A solution is to use a debounce function to limit how many times you process these events.

---

## 4. Remove or Reduce Slow Components

When creating new components yourself, but especially when importing third-party components, you need to make sure they perform well.

You can use the Vue.js dev tools performance tab to estimate the rendering time of each component you’re using. When adding a new component, you can see how much time it takes to render in comparison with your own components.

If the new component takes considerably more time than your own components, then you may need to look at alternative components, remove it, or try to reduce its usage.

![](https://cdn-images-1.medium.com/max/2000/1*SLEt6zuG1eYEhKfq9Fxw4A.png)

---

## 5. Render Once

![](https://cdn-images-1.medium.com/max/2000/1*6PL_PU-Dg-UHrIPZutTLfw.png)

This is from the official Vue.js documentation. If you have elements that once everything is mounted should only be rendered once, you can use the v-once directive.

Let’s say you have a section in your app that requires that data does not change for the entire session. By using the v-once directive you ensure this section is only rendered once.

---

## 6. Virtual Scrolling

This is the final step towards optimizing your Vue app performance. Have you ever scrolled Facebook on desktop? (Or Twitter, or Instagram, or any popular social media app?) I bet you have! You can scroll endlessly, without the page slowing down. But if you have a huge list to render in your Vue app you will see the page slowing down the longer the page becomes.

If you decide to implement endless scrolling instead of paging, you can and should use one of these two open-source projects for virtual scrollers and rendering huge lists of items:

* [https://github.com/tangbc/vue-virtual-scroll-list](https://github.com/tangbc/vue-virtual-scroll-list)
* [https://github.com/Akryum/vue-virtual-scroller](https://github.com/Akryum/vue-virtual-scroller)

I have used both and in my experience `vue-virtual-scroll-list` is better because it’s easier to use and doesn’t rely on absolute positions that can break the UI.

---

## Conclusion

Even though this guide doesn’t account for all scenarios, these six ways cover a lot of common performance issues for Vue applications.

Achieving great front end performance is more important than you may realize. Developers usually have much better computers than the users who end up using your app. Your users may not even use computers but rather slow and outdated smartphones.

So it’s up to us, the developers, to do the best in our power and deliver an optimal user experience. You can use these six ways as a checklist to help ensure your Vue app is running smoothly for all users.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
