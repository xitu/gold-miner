> * 原文地址：[VueJS 3.0.0 Beta: Features I’m Excited About](https://blog.bitsrc.io/vuejs-3-0-0-beta-features-im-excited-about-c70b82fac163)
> * 原文作者：[Nwose Lotanna](https://medium.com/@viclotana)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/vuejs-3-0-0-beta-features-im-excited-about.md](https://github.com/xitu/gold-miner/blob/master/TODO1/vuejs-3-0-0-beta-features-im-excited-about.md)
> * 译者：
> * 校对者：

# VueJS 3.0.0 Beta: Features I’m Excited About

![](https://cdn-images-1.medium.com/max/2560/1*RldyrFWyMYS5mhvUNmkw7g.jpeg)

As of this writing VueJS 3.0.0 is now in Beta, in this article we will look at a quick overview of the Journey to the big release as presented by the Vue team at the latest ThisDot meetup online.

![](https://cdn-images-1.medium.com/max/2952/1*jfs5yQ21kQKLCvbvuHmSXA.png)

## Vue JS

Vue JS is a very popular and progressive JavaScript library created by Evan You and 284+ members of the Vue community. It has more than 1.2 million users and consists of an approachable core library that focuses on the view layer only, and an ecosystem of supporting libraries that helps you tackle complexity in large Single-Page Applications.

#### The Eco-System

It’s quite amazing to see how vast Vue’s eco-system has become. One of the things I’m particularly excited about is the recent release of [**Bit.dev**](https://bit.dev) with support for VueJS. So, now, finally, Vue developers can publish, document, and organize reusable components in a cloud component hub (just like React developers). Every new VueJS library or tool that comes out strengthens this great framework but some are more impactful than others (not having the freedom to publish components from any codebase is a deal-breaker for many developers).

![Published React components on [Bit.dev](https://bit.dev) — now supports VueJS](https://cdn-images-1.medium.com/max/2000/1*Nj2EzGOskF51B5AKuR-szw.gif)

#### This Dot Meetup

During this pandemic period, the ThisDot meetup was held on the 16th of April online where the core team showed what is to come in the future with Vue JS and that is what we will summarize in this post.

## Performance

This new version of Vue JS is built for speed, there is a significant speed bump between version 3.0 and the previous versions of Vue. It has up to 2x better update performance and up to 3x faster for server-side renderings. The component initialization is also now more efficient, with even compiler-informed fast paths to execution. The virtual DOM was also totally re-written and this new version will be totally faster than ever.

## Tree-shaking support

Support is now also available in this version for things like tree-shaking. Most features that were optional in Vue are now tree-shakable, features like transition and v-model. This has drastically reduced the size of Vue applications, a bare-bone HelloWorld is now 13.5kb in file size and with the composition API support it can go as low as 11.75kb in file size. With all the runtime features included, a project can weigh as small as 22.5kb. This means that even with the addition of way more features, Vue 3.0 is still lighter than any 2.x version.

## Composition API

The Vue team has introduced a new way to deal with code organization, initially in the 2.x versions we used options. Options are great but it has compiler drawbacks when trying to match or access Vue logic, also having to deal with JavaScript’s this too. So the composition API is a better solution for handling these and it also comes with freedom and flexibility to use and re-use pure JS functions in your Vue components which would result to use less lines of code entirely. The composition API looks like this:

```js
<script>
export default {
         setup() {
           return {
             average(), range(), median()
           }
         }
       } 

function average() { } 
function range() { } 
function median() { }
</script>
```

Do we now lose the options API? No, rather the composition API would be used side by side with the options API. (This reminds me so much of React hooks)

## Fragments

Just like React, Vue JS will introduce fragments in Vue version 3.0.0, one of the main needs for fragments is that Vue templates can only have one tag. So a code block like this in a Vue template will return an error:

```html
<template>   
 <div>Hello</div>   
 <div>World</div>   
</template>
```

The first place I saw this idea implemented was in React 16, fragments are template wrapper tags that are used to structure your HTML code but does not alter the semantics. Like a Div tag but this time without any effect on the DOM. With fragments, manual render functions can just return arrays and it just works like you it does in React.

## Teleport

Teleports which were previously called portals are safe channels for rendering child nodes into DOM nodes outside the DOM lineage like for pop-ups and even modals. Before now, this is usually handled with a lot of pain in CSS, now Vue lets you use \<Teleport> to handle that in your template section. I believe teleport was inspired by React portals and it will be shipped with the version 3.0.0 of Vue JS.

## Suspense

Suspense is a component required during lazy loading basically used to wrap lazy components. Multiple lazy components can be wrapped with the suspense component. In the 3.0.0 version of Vue JS suspense will be introduced to wait on nested async dependencies in a nested tree and it will work well with async components.

## Better TypeScript support

Vue started to support TypeScript from versions in the 2.x and for version 3.0.0 is continuing to do so. So generating new projects with the current latest TypeScript version will be possible with Vue 3.0.0 with TSX support and no much difference between the TS and the JS code and the APIs. Class component is still supported ([vue-class-component@next](https://github.com/vuejs/vue-class-component/tree/next) is currently in alpha)

## Version 3.0.0 Status Report

Initial official release plans for the version 3.0.0 of Vue JS was slated for [first quarter of 2020](https://github.com/vuejs/vue/projects/6) according to the timeline on the project on GitHub. Starting from 16th of April 2020, the Vue version 3.0.0 is now in beta! This means that all planned request for comments have been worked on and implemented and the team’s focus is now on library integrations. There is now available an experimental support for [the Vue CLI here](https://github.com/vuejs/vue-cli-plugin-vue-next) and there is a very simple single file component support based on [Webpack here](https://github.com/vuejs/vue-next-webpack-preview).

## One more release

Vue version 2.7 which is a minor release will be out soon and it will probably be the last version in the 2.x series before the official release of the 3.0.0 version. It is going to back port compatible improvements from the version 3.0.0 and show depreciation warnings for features that would not be in 3.0.0.

## Want to support…

Chances are low but you might run into inconsistencies with the 2.x versions and you have to check if that issue’s fix has already been proposed in a RFC and if it is not, open an issue. Remember to [read the issue helper](https://new-issue.vuejs.org/?repo=vuejs/vue-next) to guide you through opening new issues.

## Conclusion

This is an overview of the features shipping with the third version of Vue JS. The team at Vue has made sure that this version is the fastest frontend framework in the market. You can view the slides to the ThisDot online meetup [here](https://t.co/7TP5ZMtjK4?amp=1), stay safe and happy hacking. What is your favorite new feature?

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
