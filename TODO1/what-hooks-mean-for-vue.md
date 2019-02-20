> * 原文地址：[What Hooks Mean for Vue](https://css-tricks.com/what-hooks-mean-for-vue/)
> * 原文作者：[Sarah Drasner](https://css-tricks.com/author/sdrasner/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/what-hooks-mean-for-vue.md](https://github.com/xitu/gold-miner/blob/master/TODO1/what-hooks-mean-for-vue.md)
> * 译者：
> * 校对者：

# What Hooks Mean for Vue

Not to be confused with [Lifecycle Hooks](https://css-tricks.com/intro-to-vue-3-vue-cli-lifecycle-hooks/#article-header-id-1), [Hooks](https://reactjs.org/docs/hooks-intro.html) were introduced in React in v16.7.0-alpha, and a proof of concept was released for Vue a few days after. Even though it was proposed by React, it’s actually an important composition mechanism that has benefits across JavaScript framework ecosystems, so we’ll spend a little time today discussing what this means.

Mainly, Hooks offer a more explicit way to think of reusable patterns — one that avoids rewrites to the components themselves and allows disparate pieces of the stateful logic to seamlessly work together.

### The initial problem

In terms of React, the problem was this: classes were the most common form of components when expressing the concept of state. Stateless functional components were also quite popular, but due to the fact that they could only really render, their use was limited to presentational tasks.

Classes in and of themselves present some issues. For example, as React became more ubiquitous, stumbling blocks for newcomers did as well. In order to understand React, one had to understand classes, too. Binding made code verbose and thus less legible, and an understanding of `this` in JavaScript was required. There are also some optimization stumbling blocks that classes present, [discussed here](https://reactjs.org/docs/hooks-intro.html#classes-confuse-both-people-and-machines).

In terms of the reuse of logic, it was common to use patterns like render props and higher-order components, but we’d find ourselves in similar “[pyramid of doom](https://en.wikipedia.org/wiki/Pyramid_of_doom_(programming))” — style implementation hell where nesting became so heavily over-utilized that components could be difficult to maintain. This led me to ranting drunkenly at Dan Abramov, and nobody wants that.

Hooks address these concerns by allowing us to define a component's stateful logic using only function calls. These function calls become more compose-able, reusable, and allows us to express composition in functions while still accessing and maintaining state. When hooks were announced in React, people were excited — you can see some of the benefits illustrated here, with regards to how they reduce code and repetition:

> Took [@dan_abramov](https://twitter.com/dan_abramov?ref_src=twsrc%5Etfw)'s code from [#ReactConf2018](https://twitter.com/hashtag/ReactConf2018?src=hash&ref_src=twsrc%5Etfw) and visualised it so you could see the benefits that React Hooks bring us. [pic.twitter.com/dKyOQsG0Gd](https://t.co/dKyOQsG0Gd)
> 
> — Pavel Prichodko (@prchdk) [October 29, 2018](https://twitter.com/prchdk/status/1056960391543062528?ref_src=twsrc%5Etfw)

In terms of maintenance, simplicity is key, and Hooks provide a single, functional way of approaching shared logic with the potential for a smaller amount of code.

### Why Hooks in Vue?

You may read through this and wonder what Hooks have to offer in Vue. It seems like a problem that doesn’t need solving. After all, Vue doesn’t predominantly use classes. Vue offers stateless functional components (should you need them), but why would we need to carry state in a functional component? [We have mixins](https://css-tricks.com/using-mixins-vue-js/) for composition where we can reuse the same logic for multiple components. Problem solved.

I thought the same thing, but after talking to Evan You, he pointed out a major use case I missed: mixins can’t consume and use state from one to another, but Hooks can. This means that if we need chain encapsulated logic, it’s now possible with Hooks.

Hooks achieve what mixins do, but avoid two main problems that come with mixins:

*   They allows us to pass state from one to the other.
*   They make it explicit where logic is coming from.

If we’re using more than one mixin, it’s not clear which property was provided by which mixin. With Hooks, the return value of the function documents the value being consumed.

So, how does that work in Vue? We mentioned before that, when working with Hooks, logic is expressed in function calls that become reusable. In Vue, this means that we can group a data call, a method call, or a computed call into another custom function, and make them freely compose-able. Data, methods, and computed now become available in functional components.

### Example

Let’s go over a really simple hook so that we can understand the building blocks before we move on to an example of composition in Hooks.

#### useWat?

OK, here’s were we have, what you might call, a crossover event between React and Vue. The `use` prefix is a React convention, so if you look up Hooks in React, you’ll find things like `useState`, `useEffect`, etc. [More info here.](https://reactjs.org/docs/hooks-overview.html#-state-hook)

In [Evan’s live demo](https://codesandbox.io/s/jpqo566289), you can see where he’s accessing `useState` and `useEffect` for a render function.

If you’re not familiar with render functions in Vue, it might be helpful [to take a peek at that](https://vuejs.org/v2/guide/render-function.html).

But when we’re working with Vue-style Hooks, we’ll have — you guessed it — things like: `useData`, `useComputed`, etc.

So, in order for us look at how we'd use Hooks in Vue, I created a sample app for us to explore.

详见视频演示：https://css-tricks.com/wp-content/uploads/2019/01/hooks-demo-shorter.mp4

[Demo Site](https://sdras.github.io/vue-hooks-foodapp/)

[GitHub Repo](https://github.com/sdras/vue-hooks-foodapp)

In the src/hooks folder, I've created a hook that prevents scrolling on a `useMounted` hook and reenables it on `useDestroyed`. This helps me pause the page when we're opening a dialog to view content, and allows scrolling again when we're done viewing the dialog. This is good functionality to abstract because it would probably be useful several times throughout an application.

```
import { useDestroyed, useMounted } from "vue-hooks";

export function preventscroll() {
  const preventDefault = (e) => {
    e = e || window.event;
    if (e.preventDefault)
      e.preventDefault();
    e.returnValue = false;
  }

  // keycodes for left, up, right, down
  const keys = { 37: 1, 38: 1, 39: 1, 40: 1 };

  const preventDefaultForScrollKeys = (e) => {
    if (keys[e.keyCode]) {
      preventDefault(e);
      return false;
    }
  }

  useMounted(() => {
    if (window.addEventListener) // older FF
      window.addEventListener('DOMMouseScroll', preventDefault, false);
    window.onwheel = preventDefault; // modern standard
    window.onmousewheel = document.onmousewheel = preventDefault; // older browsers, IE
    window.touchmove = preventDefault; // mobile
    window.touchstart = preventDefault; // mobile
    document.onkeydown = preventDefaultForScrollKeys;
  });

  useDestroyed(() => {
    if (window.removeEventListener)
      window.removeEventListener('DOMMouseScroll', preventDefault, false);

    //firefox
    window.addEventListener('DOMMouseScroll', (e) => {
      e.stopPropagation();
    }, true);

    window.onmousewheel = document.onmousewheel = null;
    window.onwheel = null;
    window.touchmove = null;
    window.touchstart = null;
    document.onkeydown = null;
  });
} 
```

And then we can call it in a Vue component like this, in AppDetails.vue:

```
<script>
import { preventscroll } from "./../hooks/preventscroll.js";
...

export default {
  ...
  hooks() {
    preventscroll();
  }
}
</script>
```

We're using it in that component, but now we can use the same functionality throughout the application!

#### Two Hooks, understanding each other

We mentioned before that one of the primary differences between hooks and mixins is that hooks can actually pass values from one to another. Let's look at that with a simple, albeit slightly contrived, example.

Let's say in our application we need to do calculations in one hook that will be reused elsewhere, and something else that needs to use that calculation. In our example, we have a hook that takes the window width and passes it into an animation to let it know to only fire when we're on larger screens.

详见视频演示：https://css-tricks.com/wp-content/uploads/2019/01/hook-logo.mp4

In the first hook:

```
import { useData, useMounted } from 'vue-hooks';

export function windowwidth() {
  const data = useData({
    width: 0
  })

  useMounted(() => {
    data.width = window.innerWidth
  })

  // this is something we can consume with the other hook
  return {
    data
  }
}
```

Then, in the second we use this to create a conditional that fires the animation logic:

```
// the data comes from the other hook
export function logolettering(data) {
  useMounted(function () {
    // this is the width that we stored in data from the previous hook
    if (data.data.width > 1200) {
      // we can use refs if they are called in the useMounted hook
      const logoname = this.$refs.logoname;
      Splitting({ target: logoname, by: "chars" });

      TweenMax.staggerFromTo(".char", 5,
        {
          opacity: 0,
          transformOrigin: "50% 50% -30px",
          cycle: {
            color: ["red", "purple", "teal"],
            rotationY(i) {
              return i * 50
            }
          }
        },
        ...
```

Then, in the component itself, we'll pass one into the other:

```
<script>
import { logolettering } from "./../hooks/logolettering.js";
import { windowwidth } from "./../hooks/windowwidth.js";

export default {
  hooks() {
    logolettering(windowwidth());
  }
};
</script>
```

Now we can compose logic with Hooks throughout our application! Again, this is a contrived example for the purposes of demonstration, but you can see how useful this might be for large scale applications to keep things in smaller, reusable functions.

### Future plans

**Vue Hooks are already available to use today with Vue 2.x, but are still experimental**. We’re planning on integrating Hooks into Vue 3, but will likely deviate from React’s API in our own implementation. We find React Hooks to be very inspiring and are thinking about how to introduce its benefits to Vue developers. We want to do it in a way that complements Vue's idiomatic usage, so there's still a lot of experimentation to do.

You can get started by [checking out the repo here](https://github.com/yyx990803/vue-hooks). Hooks will likely become a replacement for mixins, so although the feature still in its early stages, it’s probably a concept that would be beneficial to explore in the meantime.

_(Sincere thanks to Evan You and Dan Abramov for proofing this article.)_

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
