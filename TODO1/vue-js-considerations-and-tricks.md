> * 原文地址：[Vue.js — Considerations and Tricks](https://blog.webf.zone/vue-js-considerations-and-tricks-fa7e0e4bb7bb)
> * 原文作者：[Harshal Patil](https://blog.webf.zone/@mistyHarsh)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/vue-js-considerations-and-tricks.md](https://github.com/xitu/gold-miner/blob/master/TODO1/vue-js-considerations-and-tricks.md)
> * 译者：
> * 校对者：

# Vue.js — Considerations and Tricks

![](https://cdn-images-1.medium.com/max/1600/1*Agh6VagdEwoIziUUnbxgOg.png)

Vue.js is great. However, when you start building large scale JavaScript applications, you will start to hit the boundaries of the Vue.js. These boundaries are not really the limitations of the framework; rather these are the important design decisions that Vue.js team had taken from time to time.

Unlike React or Angular, Vue.js caters to different level of developers. It is friendly, easy-to-use for beginners and equally flexible for experts. It doesn’t try to shy away from DOM. Instead, it plays well with it.

Having said this, this article is more like a catalog of some of the great **discussions, issues and tricks** I have come across on my way to Vue.js enlightenment. Understanding these key design aspects helped us while building our large scale web applications.

Again, these discussion are valid as of today, May 18th, 2018. When framework upgrades, underlying browser and JS API will change, they may not be valid and intuitive.

* * *

#### 1. Why Vue.js doesn’t use ES classes out-of-box for component?

If you are coming from Angular-like framework or some backend OOP heavy language, your first question will be — why not classes for components?

Vue.js creator, [Evan You](https://medium.com/@youyuxi), has nicely answered this question in this GitHub comment:

- [**Use standard JS classes instead of custom syntax? · Issue #2371 · vuejs/vue**](https://github.com/vuejs/vue/issues/2371#issuecomment-284052430 "https://github.com/vuejs/vue/issues/2371#issuecomment-284052430")

There are three main reason why not classes as default mechanism:

1.  ES Classes are not good enough to meet the needs of Vue.js current API. ES Classes are not fully evolved and often criticized as a step in wrong direction. Classes with private fields and decorators once stabilized (Stage 3 at least) may help.
2.  ES Classes serve good only those who are familiar with Class based languages. It easily excludes large community of web that doesn’t use sophisticated build tools or transpilers.
3.  **Building great UI component hierarchy is about great component composition. It is not about great inheritance hierarchy. Unfortunately, ES classes are better at the latter.**

* * *

#### 2. How can I build my own abstract component?

If building large scale web application is not enough, you have some crazy idea to implement an abstract component like `<transition>` or `<router-view>`. There was definitely a discussion about this, but it really did not sail through.

- [**Any plan for docs of abstract components? · Issue #720 · vuejs/vuejs.org**](https://github.com/vuejs/vuejs.org/issues/720 "https://github.com/vuejs/vuejs.org/issues/720")

But fear not, with good understanding of slots, you can build your own abstract components. There is a very good blog post explaining how to do that.

- [**Writing Abstract Components with Vue.js**](https://alligator.io/vuejs/vue-abstract-components/ "https://alligator.io/vuejs/vue-abstract-components/")

But still think twice before you do that. We have always relied on mixins and plain functions to solve some corner case scenarios. Just think of mixins as your abstract components:

- [**How do I extend another VueJS component in a single-file component? (ES6 vue-loader)**](https://stackoverflow.com/a/35964246/5723098 "https://stackoverflow.com/a/35964246/5723098")

* * *

#### 3. I am not really comfortable with Vue.js Single File Component Approach. I am more happy with Separate HTML, CSS and JavaScript.

Nobody has stopped you from doing so. If you are old school Separation of Concern philosopher who like to literally put separate things into separate files or you hate code editor’s erratic behavior around `.vue` files, then it is certainly possible. All you have to do:

```
<!--https://vuejs.org/v2/guide/single-file-components.html -->

<!-- my-component.vue -->
<template src="./my-component.html"></template>
<script src="./my-component.js"></script>
<style src="./my-component.css"></style>
```

However, immediately next question comes up —**Do I always need 4 files (vue + html + js + css) for my component. Can I somehow get rid of** `**.vue**` **files?** Answer is definitely yes, you can do that. Use `vue-template-loader`.

- [**ktsn/vue-template-loader**: vue-template-loader - Vue.js 2.0 template loader for webpack](https://github.com/ktsn/vue-template-loader "https://github.com/ktsn/vue-template-loader")

My colleguage has written a great post about it:

- [**Using vue-template-loader with Vue.js to Compile HTML Templates**: Using vue-template-loader to eliminate need for .vue files in Vue apps, if you're feeling so inclined!](https://alligator.io/vuejs/vue-template-loader/ "https://alligator.io/vuejs/vue-template-loader/")

* * *

### 4. Functional Components

Thanks to React.js, functional components are craze now a days albeit for a good reason. They are **fast, stateless and easy to test**. However, there are gotchas.

#### 4.1 Why can’t I use class based @Component decorator for Functional Components?

Again coming back to classes, it should be noted that classes are a data structures that are meant to hold local state. If functional components are stateless, then is there really no point inhaving @Component decorator.

The relevant discussion is available at:

- [**How to create functional component in @Component? · Issue #120 · vuejs/vue-class-component**](https://github.com/vuejs/vue-class-component/issues/120 "https://github.com/vuejs/vue-class-component/issues/120")

#### 4.2 External classes and styles are not applied to Functional components

Functional components do not have class and style binding like normal components. One has to manually apply these binding within render function

- [**DOM class attribute not rendered properly with functional components · Issue #1014 ·…**](https://github.com/vuejs/vue-loader/issues/1014 "https://github.com/vuejs/vue-loader/issues/1014")

- [**class attribute ignored on functional components · Issue #7554 · vuejs/vue**](https://github.com/vuejs/vue/issues/7554 "https://github.com/vuejs/vue/issues/7554")

#### 4.3 Functional components are always re-rendered?

> TLDR: Be careful when using **statuful** **components** inside functional components

- [**Functional components are re-rendered when props are unchanged. · Issue #4037 · vuejs/vue**](https://github.com/vuejs/vue/issues/4037#issuecomment-258164999 "https://github.com/vuejs/vue/issues/4037#issuecomment-258164999")

Functional components are **eager** meaning render function of the component gets directly called. This also means that you should:

> Avoid using stateful component directly within render function because that will create different component definition on every call to render function.

**Functional component are better used if they are leaf components**. It should be noted that this same behavior also applies to React.js.

#### 4.4 How to emit an event from Vue.js Functional component?

Emitting an event from Functional component is not straight forward. Unfortunately, there is nothing mentioned in the docs about this. `$emit` method is not available within functional component. Following stack overflow question will help in this regard:

- [**How to emit an event from Vue.js Functional component?**: This is explained in the docs Passing Attributes and Events to Child Elements/Components: If you are using...](https://stackoverflow.com/questions/50288996/how-to-emit-an-event-from-vue-js-functional-component "https://stackoverflow.com/questions/50288996/how-to-emit-an-event-from-vue-js-functional-component")

* * *

#### 5. Vue.js Transparent wrapper components

Transparent wrapper component wraps some DOM structure and yet expose events for that DOM structure instead of root DOM element. For example,

```
<!-- Wrapper component for input -->
<template>
    <div class="wrapper-comp">
        <label>My Label</label>
        <input @focus="$emit('focus')" type="text"/>
    </div>
</template>
```

Here we are really interested in `input` tag and not with root `div` element as it is mostly added for styling and cosmetic purpose. The user of this component might be interested in several events from input like `blur`, `focus`, `click`, `hover`, etc. **It means we have to re-emit each event**. Our component would look like this.

```
<!-- Wrapper component for input -->
<template>
    <div class="wrapper-comp">
        <label>My Label</label>
        <input type="text"
            @focus="$emit('focus')"
            @click="$emit('click')"
            @blur="$emit('blur')"
            @hover="$emit('hover')"
        />
    </div>
</template>
```

Now that is **anti-DRY and looks messy**. Simple solution is to simply rebind your event listeners to required DOM elements using `vm.$listeners` property on Vue instance:

```
<!-- Notice the use of $listeners -->
<template>
    <div class="wrapper-comp">
        <label>My Label</label>
        <input v-on="$listeners" type="text"/>
    </div>
</template>
<!-- Uses: @focus event will bind to internal input element -->
<custom-input @focus="onFocus"></custom-input>
```

* * *

#### 6. Why you cannot v-on or emit from the slot

I have often seen developers trying to emit event from a slot or to listen for events on a slot. That is simply not possible.

Component `slot` is provided by calling/parent component. It means all the events should associated with the calling component. Trying to listen for those changes means your parent and child component are tightly coupled and there is another route to do that which is explainly beautifully by [Evan You](https://medium.com/@youyuxi):

- [**Is it possible to emit event from component inside slot · Issue #4332 · vuejs/vue**](https://github.com/vuejs/vue/issues/4332#issuecomment-263444492 "https://github.com/vuejs/vue/issues/4332#issuecomment-263444492")

- [**Suggestion: v-on on slots · Issue #4781 · vuejs/vue**](https://github.com/vuejs/vue/issues/4781 "https://github.com/vuejs/vue/issues/4781")

* * *

#### 7. Slot within a slot (Read grandchildren slot)

At some point, you will encounter this scenario. Imagine you have a component, say **A**, that accepts some slots. Following the principles of composition, you build another component **B** using component **A**. Now you take component **B** and use it in component **C**.

> Question is — How do you pass slot from component **C** to component **A?**

**Answer to this question depends on what you use?** If you use render function, then it is pretty trivial. Render function of component B will be:

```
// Render function for component B
function render(h) {
    return h('component-a', {
        // Passing slots as they are to component A
        scopedSlot: this.$scopedSlots
    }
}
```

However, if you use template based render function, then you are out of luck. Fortunately, there is a progress happening on this issue and we may have something for template based components:

- [**feat(core): support passing down scopedSlots with v-bind by yyx990803 · Pull Request #7765 ·…**](https://github.com/vuejs/vue/pull/7765 "https://github.com/vuejs/vue/pull/7765")

* * *

Hopefully, this post has given in insights into Vue.js design considerations and some tips/tricks to play with advanced scenarios in Vue.js.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
