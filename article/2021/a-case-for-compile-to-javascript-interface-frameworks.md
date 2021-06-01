> * 原文地址：[A Case for Compile to JavaScript Interface Frameworks](https://javascript.plainenglish.io/a-case-for-compile-to-javascript-interface-frameworks-a684b361884f)
> * 原文作者：[AsyncBanana](https://medium.com/@asyncbanana)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/a-case-for-compile-to-javascript-interface-frameworks.md](https://github.com/xitu/gold-miner/blob/master/article/2021/a-case-for-compile-to-javascript-interface-frameworks.md)
> * 译者：
> * 校对者：

# A Case for Compile to JavaScript Interface Frameworks

![Photo by [Ferenc Almasi](https://unsplash.com/@flowforfrank?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/10296/0*LUP7NJrirKlw-voh)

Today, web frameworks like React and Vue are extremely popular for creating modern web applications, and it is for a good reason. They help make pieces of code into reusable components and make it easy to update based on data using declarative markup.

However, almost all of them come with a performance cost because they need large runtime libraries. Also, that interface language is less powerful and more verbose because it is limited to the constraints imposed by native JavaScript.

However, solutions to this problem allow you to have better performance while using less verbose code.

These frameworks compile languages that are optimized for declarative user interface design into native JavaScript. Because they are compiled and do not need a huge runtime library, they are much smaller.

There are two main types of compile to JavaScript user interface frameworks. Some use JavaScript for actual logic, like [Svelte](https://svelte.dev/) and [Solid](https://github.com/solidjs/solid), and others use an entirely different language that typically does more than just declarative markup, like [Elm](https://elm-lang.org/) and [Mint](https://www.mint-lang.com/). We will primarily focus on frameworks like Svelte in this article. Now let's look at why to use these frameworks.

> Solid can be considered a runtime framework, but because it uses compiling to optimize code a lot, I consider it a compile to JS framework for this article.

## Compiled JavaScript is fast

Many frameworks that are compiled, especially newer ones, are much faster and lighter than runtime frameworks.

This is because they can do lots of optimization before the code runs, and they can transform the code into normal DOM manipulating JavaScript, avoiding the need for a large package.

For example, compare Svelte and Solid, which are two frameworks that utilize compiling heavily, to React* and Vue, two frameworks designed to be used in runtime.

* React does use JSX which is compiled, but that just basic syntactical sugar over `createElement` calls.

React’s and Vue’s bundle size, according to BundlePhobia, is 39.4kb GZip and 22.9kb GZip respectively.

![React’s bundle size](https://cdn-images-1.medium.com/max/2724/1*yWAVUnOXKsrwrRzTSb6kzw.png)

![Vue’s bundle size](https://cdn-images-1.medium.com/max/2684/1*eTVWVuDuNORYhxf1g5bF_w.png)

In contrast, Svelte has practically no base bundle size because it uses very few things beyond native DOM manipulation, and Solid only has some small functions to help update elements.

Because most of the package weight is the compiler, which is not included in the resulting web app, you can’t quantify the weight from Bundlephobia, but the startup times benchmark below has a reasonable estimation of the weight.

Additionally, both Solid and Svelte are significantly faster in runtime. According to the [Krausest Framework Benchmarks](https://krausest.github.io/js-framework-benchmark/2021/table_chrome_90.0.4430.72.html), Solid and Svelte are faster in startup times, DOM manipulation speed, and memory usage.

![Framework speed benchmark](https://cdn-images-1.medium.com/max/2000/1*cyKBaU7O35rKAPZJ4jsO2A.png)

![Framework startup benchmark](https://cdn-images-1.medium.com/max/2000/1*m5e36L44ph12wCOhCq576Q.png)

![Framework memory benchmark](https://cdn-images-1.medium.com/max/2000/1*EuwkvRIURVuvKk7XqphdYQ.png)

As you can see, Solid and Svelte are more optimized than React and Vue in large DOM manipulations, startup (which is impacted by script size and interpretation time), and memory usage.

Of course, you must remember, most of the time it will matter very little. But if you need more performance, then frameworks that utilize compiling UI code to optimize performance might be a good way to go.

For example, if you are developing for people on slow 2G or 3G networks, the decrease in weight brought by using Svelte might be a very helpful thing.

Also, remember that while optimized compiled frameworks might be faster than non-optimized frameworks, vanilla JavaScript will almost always be faster. But vanilla JavaScript can be more verbose and tedious, which leads us to our second point.

## Compiled Frameworks are optimized for writing less code

JavaScript was not originally designed for making declarative markup like React, and because of that, many features in React force you to use functions and methods like `useState()` instead of using normal variables, which is not bad, but not as good as it could be.

Additionally, there are much fewer features, due to most of the features needing to be shipped in the runtime. Compiling can help with this. Svelte has built-in support for reactive variables, and you can declare them using normal `let variable = value` syntax.

Additionally, you make reactive statements using just `$:` . This might seem confusing, so here are some examples.

```JavaScript
import {useState} from 'react'
export default function App() {
  let [clicks,setClicks] = useState(0)
  return (
    <div className="App">
      <h1>Clicks: {clicks}</h1>
      <button onClick={()=>{
        setClicks(clicks+1)
      }}>Click Me!</button>
    </div>
  );
}
```

```Svelte
<script>
	let clicks = 0
</script>

<h1>Clicks: {clicks}</h1>
<button on:click={()=>
	clicks++
}>Click Me!</button>
```

As you can see above, the syntax style is very different. Svelte has more of a native feel and has 1/3 less code than React.

However, ultimately, it is your choice for what syntax you want to use, but compilers just add more flexibility to the syntax. You might be thinking that the time that is taken to compile things and set up a compiler outweighs the syntax advantages, and that will lead us to the final point.

## You probably are already compiling your JavaScript

While you might not be using anything beyond native JavaScript, you probably still are compiling it, even if it is just to transform ES6 into code supported by older browsers, or it is just for minifying the code. [Create React App](https://create-react-app.dev/) uses Webpack under the hood to perform many different things to your code. In fact, React JSX, which is recommended by the React team, requires compiling to function calls that create the actual element.

Unfortunately, React does not take full advantage of that and optimize it, although they have recently made some advances in that with the new JSX transform. Additionally, [Vue Cli](https://cli.vuejs.org/) also uses Webpack under the hood. This means that while you won’t need to use a compiler, you most likely will anyway, and it is quite easy to set up.

## Conclusion

Using a framework that compiles to JavaScript is not always the answer. Some frameworks that do not compile to JavaScript are faster than ones that use compilers, and using a compiler does not automatically mean that it is a better framework.

Also, there is a wide range of how much is compiled. Some frameworks, like Alpine.js, are entirely designed to work without any build step needed.

Others, like React, only use compiling for only a small optional part of the code. Solid is also a bit like React in that it uses JSX, except that it optimizes further when compiling.

The last level of compiling is something that compiles everything, like Svelte. It is your choice how much you want to compile, and there are advantages and disadvantages for each.

I hope you have learned something from this, and thank you for reading.

**More content at[** plainenglish.io**](http://plainenglish.io)**

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
