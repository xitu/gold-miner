> * 原文地址：[Why Svelte won’t kill React](https://medium.com/javascript-in-plain-english/why-svelte-wont-kill-react-3cfdd940586a)
> * 原文作者：[Kit Isaev](https://medium.com/@nikis05)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/why-svelte-wont-kill-react.md](https://github.com/xitu/gold-miner/blob/master/TODO1/why-svelte-wont-kill-react.md)
> * 译者：
> * 校对者：

# Why Svelte won’t kill React

#### Is status quo to blame for that? Or is React simply better?

When I just started reading Svelte docs I found it quite inspiring and was going to write a eulogy about it on Medium. After reading a couple of articles from the official blog and from the community I realised that this is not going to happen, because I noticed some signs of a common rhetoric in the JavaScript world — a rhetoric that upsets me **a lot.**

> Hey, remember that problem that the powerful minds of the humanity have been trying to solve for 30 years? I’ve just found a universal solution! Why didn’t it conquer the world yet? Should be obvious. Facebook’s marketing team is plotting against us.

In my opinion it is okay to say your tool is revolutionary compared to existing ones. And it is hard to be fully unbiased about your own creation, I get it. Here is a positive example — I think Vue does a [really good job](https://vuejs.org/v2/guide/comparison.html) comparing itself to other solutions out there. Yes, there are some doubtable statements I don’t agree with, but they are communicating a constructive message:

> We have this approach, here are some other existing approaches. We believe ours is better, here is why. And here are some common counter arguments.

The official Svelte blog, on the contrary, ends up mind tricking the reader by showing only one side of the coin, sometimes through upfront false statements about web technologies and other libs (I will be mostly referring to React simply because I know it better). So in today’s article I will be primarily roasting Svelte just to balance it out. That being said, I still think there’s a brilliant idea behind it and I’ll tell you why at the end of the article 😊

![[imgflip.com](https://imgflip.com/i/122lno)](https://cdn-images-1.medium.com/max/2000/1*w4uLFcsyeLWeVetzq0VgqQ.jpeg)

## What is Svelte?

Svelte is a tool for building user interfaces. Unlike more popular frameworks — like React and Vue — that utilise virtual DOM to emit efficient DOM updates from component outputs, Svelte uses static analysis to create DOM updating code in build-time¹. Here is what a Svelte component looks like:

**App.svelte**

```
<script>
 import Thing from './Thing.svelte';

let things = [
  { id: 1, color: '#0d0887' },
  { id: 2, color: '#6a00a8' },
  { id: 3, color: '#b12a90' },
  { id: 4, color: '#e16462' },
  { id: 5, color: '#fca636' }
 ];

function handleClick() {
  things = things.slice(1);
 }
</script>

<button on:click={handleClick}>
 Remove first thing
</button>

{#each things as thing}
 <Thing color={thing.color}/>
{/each}
```

**Thing.svelte**

```
<script>
 export let color;
</script>

<p>
 <span style="background-color: {color}">current</span>
</p>

<style>
 span {
  display: inline-block;
  padding: 0.2em 0.5em;
  margin: 0 0.2em 0.2em 0;
  width: 4em;
  text-align: center;
  border-radius: 0.2em;
  color: white;
 }
</style>
```

An equivalent React component:

```
import React, {useState} from 'react'
import styled from 'styled-components';

const things = [
  { id: 1, color: '#0d0887' },
  { id: 2, color: '#6a00a8' },
  { id: 3, color: '#b12a90' },
  { id: 4, color: '#e16462' },
  { id: 5, color: '#fca636' }
 ];

const Block = styled.span`
  display: inline-block;
  padding: 0.2em 0.5em;
  margin: 0 0.2em 0.2em 0;
  width: 4em;
  text-align: center;
  border-radius: 0.2em;
  color: white;
  background-color: ${props => props.backgroundColor}
`;

const Thing = ({color}) => {
  return (
    <p>
      <Block backgroundColor={color} />
    </p>
  );
}

export const App = () => {
  const [things, setThings] = useState(things);
  const removeFirstThing = () => setThings(things.slice(1))
  return (
    <>
      <button onClick={removeFirstThing} />
      {things.map(thing =>
        <Thing key={thing.key} color={thing.color} />
      }
    </>
  );
}
```

#### Svelte is not a framework — it is a language

It does not just add Vue-like “single file components” with `<script>` and `<style>`. It adds a few constructs to the language to solve one of the most complex problems in UI development — state management.

[My previous article](https://medium.com/swlh/what-is-the-best-state-container-library-for-react-b6989a45f236) covers various approaches to solving this problem in React using the means of JavaScript. Svelte takes advantage from its position as compiler to make reactivity a language feature². There are two new language constructs in Svelte that serve this purpose.

* `$:` operator before a clause [makes this clause reactive](https://svelte.dev/tutorial/reactive-declarations), i.e. it will be re-executed each time some of the variables it reads from updates. A statement can be an assignment (aka “dependent” or “derived” variable), or a code block or a call (aka “effect”). This is somewhat similar to MobX approach but built into language.
* `$` operator [creates a subscription to a store](https://svelte.dev/tutorial/auto-subscriptions) (state container) that is automatically cancelled when the component is unmounted

Svelte’s reactivity concept allows using regular JS variables as state — no need for state container. But does it really improve the DX?

![[reddit.com](https://www.reddit.com/r/PrequelMemes/comments/arg2rb/when_people_think_obiwan_only_says_i_dont_think/)](https://cdn-images-1.medium.com/max/2000/1*c0shUq7fn3MHYBr39JJvQQ.jpeg)

## Svelte’s Reactivity

> The original promise of React was that you could re-render your entire app on every single state change without worrying about performance. In practice, I don’t think that’s turned out to be accurate. If it was, there’d be no need for optimizations like `shouldComponentUpdate` (which is a way of telling React when it can safely skip a component) — Rich Harris, maintainer of Svelte³
>
> The real problem is that programmers have spent far too much time worrying about efficiency in the wrong places and at the wrong times; **premature optimization is the root of all evil (or at least most of it) in programming**. — Donald Knuth, American computer scientist⁴

First of all, let’s make it clear. Even if you don’t have any single `shouldComponentUpdate` in your code, React **does not** re-render your entire app on every single state change. It is a very simple thing to check — all you need to do is add a `console.log` call to the root component of your app.

![](https://cdn-images-1.medium.com/max/2000/1*ZykZcYuvyFsz-kHNRIJTpg.png)

In this particular case, `App` will not be re-rendered unless `isAuthorized` state changes. No change to any of the child components will cause the `App` component to re-render. Components are only re-rendered if their own state changes, or when triggered by React Context, or during parent component re-render.

The latter case creates space for so called **wasted renders** — a situation when it is known in advance that parent re-render won’t cause any change in child’s DOM hierarchy, but the child is still re-rendered. This happens when child props are unchanged or when this particular kind of change isn’t supposed to affect what’s visible on the screen. To avoid wasted renders you can define shouldComponentUpdate (or use `React.memo` as a more modern functional alternative).

#### Optimizations must be exceptional, not default

In the vast majority of cases there’s nothing wrong about wasted renders. They take so little resources that it is simply undetectable for a human eye. In fact, comparing each component’s props to its previous props shallowly (I’m not even talking about deeply) can be more resource extensive then simply re-rendering the entire subtree. That’s why React falls back to shouldComponentUpdate: () => true by default. Moreover, React team even removed the “highlight updates” feature from dev tools because people used to obsessively haunt wasted renders with no reasoning behind it⁵.

This is a very dangerous practice as each optimization means making assumptions. If you are compressing an image you make an assumption that some payload can be cut out without seriously affecting the quality, if you are adding a cache to your backend you assume that the API will return same results. A correct assumption allows you to spare resources. A false assumption introduces a bug in your app. That’s why optimizations should be done consciously.

Svelte chooses a reverse approach. It will not re-run your component’s code on update unless explicitly told to do so, using the `$:` operator. I don’t want to spend dozens of hours searching for a place where I forgot to add one and trying to figure out why my app is not working — so that my users could enjoy a 20ms faster re-render. If there is a heavy component once in a while, I will optimize it, but it is an extremely rare occasion. It would be pointless to revolve my DX around it.

#### Svelte’s optimizations are not optimal

By the way, if we get technical, Svelte’s checks whether an update is required are not always optimal. Let’s assume I have a component with very expensive computation, and it accepts a prop with the following shape: Array\<{id: string, otherProps}>. Assuming that I know that ids are unique and array items are immutable, I could use the following code to figure out whether an update is necessary:

```
const shouldUpdate = (prevArr, nextArr) => {
  if (prevArr.length !== nextArr.length) return true;
  return nextArr.some((item, index) => item.id !== prevArr[index].id)
}
```

There is no way to specify custom reaction comparators in Svelte, it will fall back to this to compare arrays:

```
export function safe_not_equal(a, b) { 
  return a != a ? b == b : a !== b 
    || ((a && typeof a === 'object') || typeof a === 'function');
}
```

I understand that I could use some third party memoization tool **on top of** the Svelte’s comparator, but my point here is — there is no magic pill, optimizations “out of the box” often turn out to have limitations.

#### Inexpressive state updates

Whenever you need to update state in React you must call `setState`. In order to get your state updated in Svelte:

> …the name of the updated variable must appear on the left hand side of the assignment.

Svelte magically adds a call to internal runtime invalidate function that triggers reaction. This can bring up some crazy patterns.

```
const foo = obj.foo;
foo.bar = 'baz';
obj = obj; // If you don't do this, update will not happen
```

Updating an array using `push` or other mutating methods also doesn’t automatically trigger a component update. So you have to use array or object spread:

```
arr = [...arr, newItem];
obj = {...obj, updatedValue: newValue};
```

Basically same as in React, except that in React you make a function call and pass updated state to it, whereas in Svelte you have an illusion that you are working with regular mutable variables. Which kind of reduces the whole point of this magic to “hey look how cool, Svelte is a compiler”.

## Virtual DOM

> Virtual DOM is valuable because it allows you to build apps without thinking about state transitions, with performance that is **generally good enough —** Rich Harris, maintainer of Svelte⁶

Almost every article in the Svelte blog claims that virtual DOM [is an unnecessary overhead](https://svelte.dev/blog/virtual-dom-is-pure-overhead), and quite a high one, that can be easily replaced with pre-generated DOM updaters at no cost. But is this statement correct? Partially.

![[quickmeme.com](http://www.quickmeme.com/meme/362wa3)](https://cdn-images-1.medium.com/max/2000/1*jomQ-J1bF6mx8eziWMnMww.jpeg)

#### Does virtual DOM add overhead?

Yes, totally. vDOM is not a feature, just adding it into your app doesn’t magically make the underlying “real” DOM and the browser faster. It is just one of the possible ways to convert declarative code that is easy to write, read and debug into efficient imperative DOM manipulations that are relatively cheap to execute.

But is overhead always bad? I believe no — otherwise Svelte maintainers would have to write their compiler in Rust or C, because garbage collector is a single biggest overhead of JavaScript. I guess when making decisions about the stack of the compiler, they made a tradeoff — how high the overhead is vs the benefits the community gets in exchange. In this case, the overhead is relatively low — you don’t have a compiler constantly running on your device, you just run it from time to time, there is relatively little computation involved and a few seconds don’t make a big impact on UX. On the other hand, because Svelte is based on JavaScript and targets JavaScript as execution environment, having the tool written in TS/JS provides relatively huge benefits to the DX— everyone who is interested in the tool — and thus might want to contribute or might need to study the compiler sources — is likely to know JavaScript.

So overhead is always a tradeoff. Is it worth the cost in case of the virtual DOM?

#### The cost of virtual DOM

How much time does it take to download, parse and render a React app?

The first question is answered by Rich Harris himself:

> We’re shipping too much code to our users. Like a lot of front end developers, I’ve been in denial about that fact, thinking that it was fine to serve 100kb of JavaScript on page load — just use [one less .jpg!](https://twitter.com/miketaylr/status/227056824275333120)⁷

But then he makes a note:

> 100kb of .js isn’t equivalent to 100kb of .jpg. It’s not just the network time that’ll kill your app’s startup performance, but the time spent parsing and evaluating your script, during which time the browser becomes completely unresponsive.⁷

Sounds serious, let’s do some measurements using Audit tool of Google Chrome. Luckily we have this possibility thanks to [realworld.io](https://realworld.io):

[React-redux](https://react-redux.realworld.io/):

![](https://cdn-images-1.medium.com/max/2000/1*SA3Uq_pUV82XGQ7JoK6yMw.png)

[Svelte](https://realworld.svelte.dev/):

![](https://cdn-images-1.medium.com/max/2000/1*apQnSN_tRBq7z_U0D3p_Rg.png)

The difference is 0,15 seconds — which means it is negligible.

But what about benchmarks? [Benchmarks](https://github.com/krausest/js-framework-benchmark) that Svelte blog refers to show that it takes React 430.7ms to swipe 1000 rows, whereas Svelte can do this in 51.8ms.

But this metric is not reliable because this particular operation is a weak spot of React due to [reconciliation assumptions](https://reactjs.org/docs/reconciliation.html) made by React — this scenario is very rare in real world apps, and same benchmarks show that the difference between React and Svelte in almost all other cases is negligible as well.

![Svelte an React-redux on hooks comparation](https://cdn-images-1.medium.com/max/2000/1*toE8L_WfxGiuMn16chedjQ.png)

And it’s time that we finally realise that those benchmarks should be taken with a grain of salt. We have windowing and virtualization, and rendering 1000 rows at a time is a bad idea anyway. Seriously, did you ever do it?

![[tenor.com](https://tenor.com/view/well-then-your-are-lost-you-are-lost-obi-wan-kenobi-starwars-gif-7897510)](https://cdn-images-1.medium.com/max/2000/1*qvW2rqknyPnztVy4KTUfzA.png)

But Svelte maintainers claim vDOM is completely unnecessary — why waste **any** resources then?

#### Killer feature of vDOM

There is a killer feature of vDOM that Svelte has nothing to replace with. It is the ability to treat component hierarchy as an object.

React code:

```
const UnorderedList = ({children}) => (
  <ul>
    {
      children.map((child, i) => <li key={i}>{child}</li>
    }
  </ul>
)

const App = () => (
  <UnorderedList>
    <a href="http://example.com">Example</a>
    <span>Example</span>
    Text
  </UnorderedList>
);
```

This is a very simple task for React and literally impossible for Svelte. Because templates are not Turing-complete, and if they were, they would require vDOM. It might seem like a small thing but for me it is more than a valid reason to add an extra of 0.15–0.25 seconds to my app’s time-to-interactive. This is exactly what we need the vDOM for — we might not need it for reactive state updates, conditional rendering or list rendering, but as long as we have it we can treat our component hierarchy as fully dynamic and controllable object. You cannot code a serious fully declarative app without this feature.

## Temporary limitations (could be fixed in the future)

Here are a couple of additional reasons to not use Svelte that could potentially be fixed. But this would require a tremendous amount of community effort, which will not happen as long as costs outweigh benefits.

#### No TypeScript support

Because Svelte is using templates it would be very hard to implement full TypeScript support with props checks that we enjoy in React. This would require either serious changes in the Microsoft TypeScript implementation (which it is not likely to happen because Svelte is much less influential than React), or a fork of some sort which would need constant maintenance. Code generation is also an option, but running a codegen on each subtle change in element hierarchy is a terrible DX.

#### Immaturity

> Consider interoperability. Want to npm install cool-calendar-widget and use it in your app? Previously, you could only do that if you were already using (a correct version of) the framework that the widget was designed for – if `cool-calendar-widget` was built in React and you're using Angular then, well, hard cheese. But if the widget author used Svelte, apps that use it can be built using whatever technology you like. — Rich Harris, maintainer of Svelte⁷

I already have whatever tools I can imagine for React — a dozen of GraphQL clients, over 30 form state managers, hundreds of DateTime inputs.

![NPM search for “svelte”](https://cdn-images-1.medium.com/max/2000/1*1M853tgrdLL2y9YnUp_Otw.png)

![NPM search for “react”](https://cdn-images-1.medium.com/max/2000/1*PNnZjKUyyHMDT6UBd9PBJQ.png)

This would have been a killer feature back in 2013, but now it doesn’t matter anymore.

## Bright future?

Despite above described limitations, I think Svelte actually brings up an invaluable idea. Yes, you cannot fully express a modern app through templates without sacrificing flexibility and code reusability. But **the vast majority** of things that our apps are doing are just conditional and list rendering. Then again, if I’m only using onChange={e => setState(e.target.value)} and render a dozen of `\<div>`‘s in my components, why do I need support for keyboard events, wheel events and ContentEditable in my bundle?

To be honest, I don’t believe Svelte in its current form can defeat React and conquer the world. It would be cool though to have a framework that does not add any specific limitations but 100% tree shakes all of the unused parts. And produces some build-time hints about its proper execution that could be used in runtime.

## A note on readability

We already know that the key feature of Svelte is not performance (benefits are negligible), not magic (there are caveats that are so unnatural for JavaScript that you’ll have hard time reasoning about them, + lack of dev tools adds extra fun) and not interoperability (would be a major thing back in 2014, but today we have almost everything for “the big three” of React-NG-Vue). But what about readability?

> It’s unusual for the difference to be **quite** so obvious — in my experience, a React component is typically around 40% larger than its Svelte equivalent — Rich Harris, maintainer of Svelte⁸.

![[youtube.com](https://www.youtube.com/watch?v=byP3lzjuQH4)](https://cdn-images-1.medium.com/max/2000/1*H3YESgYacAyOpH31TVVNSQ.jpeg)

You only write each piece of code once and read many times. I know that it is the matter of taste and a debatable thing, I find JSX and regular javascript flow operators a lot more readable than any sort of `{#blocks}` and directives. I used to be a big fan of Vue before the peak of its popularity. Then at some moment I just stumbled upon limitations and inexpressiveness of templates and started to use JSX everywhere — and because JSX was not a typical thing for Vue I switched to React over time. I don’t want to make a step back.

---

**Thanks for reading! 😍**

I hope you enjoyed this article. If you have notes, want to discuss or debate — you are wholeheartedly welcome in the comments!

---

References:

[1]: [https://svelte.dev/](https://svelte.dev/)

[2]: [https://github.com/sveltejs/rfcs/blob/master/text/0001-reactive-assignments.md](https://github.com/sveltejs/rfcs/blob/master/text/0001-reactive-assignments.md)

[3]: [https://svelte.dev/blog/virtual-dom-is-pure-overhead](https://svelte.dev/blog/virtual-dom-is-pure-overhead)

[4]: [https://en.wikiquote.org/wiki/Donald_Knuth](https://en.wikiquote.org/wiki/Donald_Knuth)

[5]: [https://www.reddit.com/r/reactjs/comments/cqx554/introducing_the_new_react_devtools/ex1r9nb/](https://www.reddit.com/r/reactjs/comments/cqx554/introducing_the_new_react_devtools/ex1r9nb/)

[6]: [https://svelte.dev/blog/virtual-dom-is-pure-overhead](https://svelte.dev/blog/virtual-dom-is-pure-overhead)

[7]: [https://svelte.dev/blog/frameworks-without-the-framework](https://svelte.dev/blog/frameworks-without-the-framework)

[8]: [https://svelte.dev/blog/write-less-code](https://svelte.dev/blog/write-less-code)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
