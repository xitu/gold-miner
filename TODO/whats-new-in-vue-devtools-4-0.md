> * 原文地址：[What’s new in Vue Devtools 4.0](https://medium.com/the-vue-point/whats-new-in-vue-devtools-4-0-9361e75e05d0)
> * 原文作者：[Guillaume CHAU](https://medium.com/@Akryum?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/whats-new-in-vue-devtools-4-0.md](https://github.com/xitu/gold-miner/blob/master/TODO/whats-new-in-vue-devtools-4-0.md)
> * 译者：
> * 校对者：

# What’s new in Vue Devtools 4.0

A big update was released to the Vue devtools just a few days ago. Let’s dive into the new features and improvements! 🎄

### Editable component data

You can now modify the data of your component directly in the Component inspector pane.

1. Select a component
2. Under the `data` section in the inspector, mouse over a field
3. Click on the pencil icon
4. Submit your changes by clicking on the done icon or by hitting Enter. You can hit Escape to cancel the edition

<iframe width="700" height="525" src="https://www.youtube.com/embed/xeBRtXLrQYA" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>

The content of the field is the serialized JSON value. For example, if you want to enter a string, type `"hello"` with the double-quotes. An array should look like `[1, 2, "bar"]` and an object like `{ "a": 1, "b": "foo" }` .

Currently, the values of following types can be edited:

* `null` and `undefined`
* `String`
* Literal: `Boolean` , `Number` , `Infinity` , `-Infinity` and `NaN`
* Arrays
* Plain objects

For the Arrays and Plain objects, you can add and remove items using the dedicated icons. You can also rename object keys.

<iframe width="700" height="525" src="https://www.youtube.com/embed/fx1zjvHryJ0" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>

A warning will be displayed if the input isn’t valid JSON. However, some values like `undefined` or `NaN` can be typed directly for more convenience.

More types will be supported in future releases!

#### Quick Edit

Some types of value can be edited in a single click with the ‘Quick Edit’ feature.

Booleans can be toggled directly with the checkbox icon:

<iframe width="700" height="525" src="https://www.youtube.com/embed/llNJapRZaHo" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>

Numbers can be incremented or decremented with the plus or minus icons:

<iframe width="700" height="525" src="https://www.youtube.com/embed/ZCToaOpId0w" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>

You can use some keyboard modifiers to increment or decrement the value faster.

### Open component in editor

If you are using vue-loader or Nuxt in your project, you can now open the selected component in your favorite code editor (provided it is a Single-File Component).

1. Follow this [setup guide](https://github.com/vuejs/vue-devtools/blob/master/docs/open-in-editor.md) (if you are using Nuxt, you don’t need to do anything)
2. In the Component inspector, mouse over the component name — you should see a tooltip with the file path
3. Click on the component name and it will open in your editor

<iframe width="700" height="525" src="https://www.youtube.com/embed/XBKStgyhY18" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>

### Show the original component names

PR by [manico](https://github.com/manico)

By default, all the component names are formatted into CamelCase. You can disable this by toggling the ‘Format component names’ button in the Components tab. This settings will be remembered and it will also be applied to the Events tab.

<iframe width="700" height="393" src="https://www.youtube.com/embed/PoZmEcCdSbU" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>

### Inspecting components just got easier

While you have the Vue devtools open, you can right-click on a component to inspect it:

![](https://cdn-images-1.medium.com/max/800/1*8fhP5VTb6uev-8HfI4stYw.png)

Right-click a component in the page

You can also programmatically inspect a component using the `$inspect` special method:

```
<template>
  <div>
    <button @click="inspect">Inspect me!</button>
  </div>
</template>

<script>
export default {
  methods: {
    inspect () {
      this.$inspect()
    }
  }
}
</script>
```

Use the `$inspect` method in your components.

Either way, the components tree will be expanded to the newly selected component automatically.

### Filter events by component

PR by [eigan](https://github.com/eigan)

You can now filter the Events history by the components that emitted the events. Type `<` followed by the name of the component or part of it:

<iframe width="700" height="393" src="https://www.youtube.com/embed/wytquoUPSFo" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>

### Vuex inspector filter

PR by [bartlomieju](https://github.com/bartlomieju)

The Vuex inspector has now a filter input:

<iframe width="700" height="393" src="https://www.youtube.com/embed/T095k5hI_pA" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>

### Vertical layout

PR by [crswll](https://github.com/crswll)

When the devtools are not wide enough, they will now switch to an handy vertical layout. You can move the divider between the top and bottom panes just like in the default horizontal mode.

<iframe width="700" height="525" src="https://www.youtube.com/embed/33tJ_md8bX8" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>

### Improved scroll-to-component

By default, selecting a component will no longer scroll the view to it. Instead, you need to click the new ‘Scroll into view’ icon:

![](https://cdn-images-1.medium.com/max/800/1*TJEfzB4ifK8t-5kpbZieRw.png)

Click on the eye icon to scroll to the component.

It will now center the component on the screen.

### Collapsible inspectors

The sections of the different inspectors can now be collapsed. You can use keyboard modifier to collapse them all or expand them all in one click. This is very useful if you are, let’s say, only interested in the mutations details of the Vuex tab.

<iframe width="700" height="393" src="https://www.youtube.com/embed/bblGueKPsjE" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>

### And more!

* The ‘Inspect DOM’ button is now hidden if the environment doesn’t have this feature — by [michalsnik](https://github.com/michalsnik)
* `-Infinity` is now supported — by [David-Desmaisons](https://github.com/David-Desmaisons)
* The event hook had an issue fixed by [maxushuang](https://github.com/maxushuang)
* Some code was cleaned by [anteriovieira](https://github.com/anteriovieira)
* Date, RegExp, Component support is improved (and time-traveling should work with those types now)
* The devtools are now using [v-tooltip](https://github.com/Akryum/v-tooltip) for rich tooltips and popovers (also fixing some issues)

If you already have the extension, it should update automatically to `4.0.1` . You can also install it [on Chrome](https://chrome.google.com/webstore/detail/vuejs-devtools/nhdogjmejiglipccpnnnanhbledajbpd) and [on Firefox](https://addons.mozilla.org/fr/firefox/addon/vue-js-devtools/).

**Thank you for all the contributors that helped make this big update possible!**

If you find an issue or have a new feature to suggest, please [share it](https://new-issue.vuejs.org/?repo=vuejs/vue-devtools)!

* * *

### What’s next?

A new release should arrive pretty soon with even more features like selecting a component in the page (color picker-style) and some UI improvements.

We also have a few things in the works, like a standalone Vue devtools app that will allow debugging any environment (not just Chrome and Firefox), a brand new Routing tab and an improved support for `Set` and `Map` types.

Stay tuned!


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
