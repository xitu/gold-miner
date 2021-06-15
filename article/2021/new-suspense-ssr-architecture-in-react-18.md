> * 原文地址：[New Suspense SSR Architecture in React 18](https://github.com/reactwg/react-18/discussions/37)
> * 原文作者：[]()
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/new-suspense-ssr-architecture-in-react-18.md](https://github.com/xitu/gold-miner/blob/master/article/2021/new-suspense-ssr-architecture-in-react-18.md)
> * 译者：
> * 校对者：

# New Suspense SSR Architecture in React 18

## Overview

React 18 will include architectural improvements to React server-side rendering (SSR) performance. These improvements are substantial and are the culmination of several years of work. Most of these improvements are behind-the-scenes, but there are some opt-in mechanisms you'll want to be aware of, especially if you *don't* use a framework.

The primary new API is `pipeToNodeWritable`, which you can read about in [Upgrading to React 18 on the Server](https://github.com/reactwg/react-18/discussions/22). We plan to write more about it in detail as it's not final and there are things to work out.

The primary existing API is `<Suspense>`.

This page is a high-level overview of the new architecture, its design, and the problems it solves.

## tl;dr

Server-side rendering (abbreviated to "SSR" in this post) lets you generate HTML from React components on the server, and send that HTML to your users. SSR lets your users see the page's content before your JavaScript bundle loads and runs.

SSR in React always happens in several steps:

- On the server, fetch data for the entire app.
- Then, on the server, render the entire app to HTML and send it in the response.
- Then, on the client, load the JavaScript code for the entire app.
- Then, on the client, connect the JavaScript logic to the server-generated HTML for the entire app (this is "hydration").

The key part is that each step had to finish for the entire app at once before the next step could start. This is not efficient if some parts of your app are slower than others, as is the case in pretty much every non-trivial app.

React 18 lets you use `<Suspense>` to break down your app into smaller independent units which will go through these steps independently from each other and won't block the rest of the app. As a result, your app's users will see the content sooner and be able to start interacting with it much faster. The slowest part of your app won't drag down the parts that are fast. These improvements are automatic, and you don't need to write any special coordination code for them to work.

This also means that `React.lazy` "just works" with SSR now. Here's a [demo](https://codesandbox.io/s/github/facebook/react/tree/master/fixtures/ssr2?file=/src/App.js).

*(If you don't use a framework, you will need to change the exact way the HTML generation is [wired up](https://codesandbox.io/s/github/facebook/react/tree/master/fixtures/ssr2?file=/server/render.js:590-1736).)*

## What Is SSR?

When the user loads your app, you want to show a fully interactive page as soon as possible:

![](https://camo.githubusercontent.com/8b2ae54c1de6c1b24d9080d2a50a68141f7f57252803543c30cc69cdd4b82fa1/68747470733a2f2f717569702e636f6d2f626c6f622f5963474141416b314234322f784d50644159634b76496c7a59615f3351586a5561413f613d354748716b387a7939566d523255565a315a38746454627373304a7553335951327758516f3939666b586361)

This illustration uses the green color to convey that these parts of the page are interactive. In other words, all their JavaScript event handlers are already attached, clicking buttons can update the state, and so on.

However, the page can't be interactive before the JavaScript code for it fully loads. This includes both React itself and your application code. For non-trivial apps, much of the loading time will be spent downloading your application code.

If you don't use SSR, the only thing the user will see while JavaScript is loading is a blank page:

![](https://camo.githubusercontent.com/7fac45f105cd741a94db77234465c4c85843b1e6f902b21bbdb1fe5b52d25a05/68747470733a2f2f717569702e636f6d2f626c6f622f5963474141416b314234322f39656b30786570614f5a653842764679503244652d773f613d6131796c464577695264317a79476353464a4451676856726161375839334c6c726134303732794c49724d61)

This is not great, and this is why we recommend using SSR. SSR lets you render your React components *on the server* into HTML and send it to the user. HTML is not very interactive (aside from simple built-in web interactions like links and form inputs). However, it lets the user *see something* while the JavaScript is still loading:

![](https://camo.githubusercontent.com/e44ee4be56e56e74da3b9f7f5519ca6197b24e9c34488df933140950f1b31c38/68747470733a2f2f717569702e636f6d2f626c6f622f5963474141416b314234322f534f76496e4f2d73625973566d5166334159372d52413f613d675a6461346957316f5061434668644e36414f48695a396255644e78715373547a7a42326c32686b744a3061)

Here, the grey color illustrates that these parts of the screen are not fully interactive yet. The JavaScript code for your app has not loaded yet, so clicking buttons doesn't do anything. But especially for content-heavy websites, SSR is extremely useful because it lets users with worse connections start reading or looking at the content while JavaScript is loading.

When both React and your application code loads, you want to make this HTML interactive. You tell React: "Here's the `App` component that generated this HTML on the server. Attach event handlers to that HTML!" React will render your component tree in memory, but instead of generating DOM nodes for it, it will attach all the logic to the existing HTML.

This process of rendering your components and attaching event handlers is known as "hydration". It's like watering the "dry" HTML with the "water" of interactivity and event handlers. (Or at least, that's how I explain this term to myself.)

After hydration, it's "React as usual": your components can set state, respond to clicks, and so on:

![](https://camo.githubusercontent.com/98a383f6de8ee2bde7516dc540aae6d9bb02a074c43c201ef6746bf3b8450420/68747470733a2f2f717569702e636f6d2f626c6f622f5963474141416b314234322f715377594e765a58514856423970704e7045344659673f613d6c3150774c4844306b664a61495971474930646a53567173574a345544324c516134764f6a6f4b7249785161)

You can see that SSR is kind of a "magic trick". It doesn't make your app fully interactive faster. Rather, it lets you show a non-interactive version of your app sooner, so that the user can look at the static content while they wait for JS to load. However, this trick makes a huge difference for people with poor network connections, and improves the perceived performance overall. It also helps you with search engine ranking, both due to easier indexing and due to better speed.

> **Note**: don't confuse SSR with Server Components. Server Components are a more experimental feature that is still in research and likely won't be a part of the initial React 18 release. You can learn about Server Components [here](https://reactjs.org/blog/2020/12/21/data-fetching-with-react-server-components.html). Server Components are complementary to SSR, and will be a part of the recommended data fetching approach, but this post is not about them.*

## What Are the Problems with SSR Today?

The approach above works, but in many ways it's not optimal.

### You have to fetch everything before you can show anything

One problem with SSR today is that it does not allow components to "wait for data". With the current API, by the time you render to HTML, you must already have all the data ready for your components on the server. This means that you have to collect *all* the data on the server before you can start sending *any* HTML to the client. This is quite inefficient.

For example, let's say you want to render a post with comments. The comments are important to show early, so you want to include them in the server HTML output. But your database or API layer is slow, which is out of your control. Now you have to make some hard choices. If you exclude them from the server output, the user won't see them until JS loads. But if you include them in the server output, you have to delay sending the rest of the HTML (for example, the navigation bar, the sidebar, and even the post content) until the comments have loaded and you can render the full tree. This is not great.

> As a side note, some data fetching solutions repeatedly try to render the tree to HTML and throw away the result until the data has been resolved because React doesn't provide a more ergonomic option. We'd like to provide a solution that doesn't require such extreme compromises.

### You have to load everything before you can hydrate anything

After your JavaScript code loads, you'll tell React to "hydrate" the HTML and make it interactive. React will "walk" the server-generated HTML while rendering your components, and attach the event handlers to that HTML. For this to work, the tree produced by your components in the browser must match the tree produced by the server. Otherwise React can't "match them up!" A very unfortunate consequence of this is that you have to load the JavaScript for *all* components on the client before you can start hydrating *any* of them.

For example, let's say that the comments widget contains a lot of complex interaction logic, and it takes a while to load JavaScript for it. Now you have to make a hard choice again. It would be good to render comments on the server to HTML in order to show them to the user early. But because hydration can only be done in a single pass today, you can't start hydrating the navigation bar, the sidebar, and the post content until you've loaded the code for the comments widget! Of course, you could use code splitting and load it separately, but you would have to exclude comments from the server HTML. Otherwise React won't know what to do with this chunk of HTML (where's the code for it?) and delete it during hydration.

### You have to hydrate everything before you can interact with anything

There is a similar issue with hydration itself. Today, React hydrates the tree in a single pass. This means that once it's started hydrating (which is essentially calling your component functions), React won't stop until it's finished doing this for the entire tree. As a consequence, you have to wait for **all** components to be hydrated before you can interact with *any* of them.

For example, let's say the comments widget has expensive rendering logic. It might work fast on your computer, but on a low-end device running all of that logic is not cheap and may even lock up the screen for several seconds. Of course, ideally we wouldn't have such logic on the client at all (and that's something that Server Components can help with). But for some logic it's unavoidable because it determines what the attached event handlers should do and is essential to interactivity. As a result, once the hydration starts, the user can't interact with the navigation bar, the sidebar, or the post content, until the full tree is hydrated. For navigation, this is especially unfortunate since the user may want to navigate away from this page altogether---but since we're busy hydrating, we're keeping them on the current page they no longer care about.

### How can we solve these problems?

There is one thing in common between these problems. They force you to choose between doing something early (but then hurting UX because it blocks all other work), or doing something late (but hurting UX because you've wasted time).

This is because there is a "waterfall": fetch data (server) → render to HTML (server) → load code (client) → hydrate (client). Neither of the stages can start until the previous stage has finished for the app. This is why it's inefficient. Our solution is to break the work apart so that we can do each of these stages for a part of the screen instead of entire app.

This is not a novel idea: for example, [Marko](https://tech.ebayinc.com/engineering/async-fragments-rediscovering-progressive-html-rendering-with-marko/) is one of JavaScript web frameworks that implements a version of this pattern. The challenge was in how to adapt a pattern like this to the React programming model. It took a while to solve. We introduced the `<Suspense>` component for this purpose in 2018. When we introduced it, we only supported it for lazy-loading code on the client. But the goal was to integrate it with the server rendering and solve these problems.

Let's see how to use `<Suspense>` in React 18 to solve these issues.

## React 18: Streaming HTML and Selective Hydration

There are two major SSR features in React 18 unlocked by Suspense:

- Streaming HTML on the server. To opt into it, you'll need to switch from `renderToString` to the new `pipeToNodeWritable` method, as [described here](https://github.com/reactwg/react-18/discussions/22).
- Selective Hydration on the client. To opt into it, you'll need to [switch to `createRoot`](https://github.com/reactwg/react-18/discussions/5) on the client and then start wrapping parts of your app with `<Suspense>`.

To see what these features do and how they solve the above problems, let's return to our example.

### Streaming HTML before all the data is fetched

With today's SSR, rendering HTML and hydration are "all or nothing". First you render all HTML:

```source-js
<main>
  <nav>
    <!--NavBar -->
    <a href="/">Home</a>
   </nav>
  <aside>
    <!-- Sidebar -->
    <a href="/profile">Profile</a>
  </aside>
  <article>
    <!-- Post -->
    <p>Hello world</p>
  </article>
  <section>
    <!-- Comments -->
    <p>First comment</p>
    <p>Second comment</p>
  </section>
</main>
```

The client eventually receives it:

![](https://camo.githubusercontent.com/e44ee4be56e56e74da3b9f7f5519ca6197b24e9c34488df933140950f1b31c38/68747470733a2f2f717569702e636f6d2f626c6f622f5963474141416b314234322f534f76496e4f2d73625973566d5166334159372d52413f613d675a6461346957316f5061434668644e36414f48695a396255644e78715373547a7a42326c32686b744a3061)

Then you load all the code and hydrate the entire app:

![](https://camo.githubusercontent.com/8b2ae54c1de6c1b24d9080d2a50a68141f7f57252803543c30cc69cdd4b82fa1/68747470733a2f2f717569702e636f6d2f626c6f622f5963474141416b314234322f784d50644159634b76496c7a59615f3351586a5561413f613d354748716b387a7939566d523255565a315a38746454627373304a7553335951327758516f3939666b586361)

But React 18 gives you a new possibility. You can wrap a part of the page with `<Suspense>`.

For example, let's wrap the comment block and tell React that until it's ready, React should display the `<Spinner />` component:

```source-js
<Layout>
  <NavBar />
  <Sidebar />
  <RightPane>
    <Post />
    <Suspense fallback={<Spinner />}>
      <Comments />
    </Suspense>
  </RightPane>
</Layout>
```

By wrapping `<Comments>` into `<Suspense>`, we tell React that it doesn't need to wait for comments to start streaming the HTML for the rest of the page. Instead, React will send the placeholder (a spinner) instead of the comments:

![](https://camo.githubusercontent.com/484be91b06f3f998b3bda9ba3efbdb514394ab70484a8db2cf5774e32f85a2b8/68747470733a2f2f717569702e636f6d2f626c6f622f5963474141416b314234322f704e6550316c4253546261616162726c4c71707178413f613d716d636f563745617955486e6e69433643586771456961564a52637145416f56726b39666e4e564646766361)

Comments are nowhere to be found in the initial HTML now:

```source-js
<main>
  <nav>
    <!--NavBar -->
    <a href="/">Home</a>
   </nav>
  <aside>
    <!-- Sidebar -->
    <a href="/profile">Profile</a>
  </aside>
  <article>
    <!-- Post -->
    <p>Hello world</p>
  </article>
  <section id="comments-spinner">
    <!-- Spinner -->
    <img width=400 src="spinner.gif" alt="Loading..." />
  </section>
</main>
```

The story doesn't end here. When the data for the comments is ready on the server, React will send additional HTML into the same stream, as well as a minimal inline `<script>` tag to put that HTML in the "right place":

```source-js
<div hidden id="comments">
  <!-- Comments -->
  <p>First comment</p>
  <p>Second comment</p>
</div>
<script>
  // This implementation is slightly simplified
  document.getElementById('sections-spinner').replaceChildren(
    document.getElementById('comments')
  );
</script>
```

As a result, even before React itself loads on the client, the belated HTML for comments will "pop in":

![](https://camo.githubusercontent.com/e44ee4be56e56e74da3b9f7f5519ca6197b24e9c34488df933140950f1b31c38/68747470733a2f2f717569702e636f6d2f626c6f622f5963474141416b314234322f534f76496e4f2d73625973566d5166334159372d52413f613d675a6461346957316f5061434668644e36414f48695a396255644e78715373547a7a42326c32686b744a3061)

This solves our first problem. Now you don't have to fetch all the data before you can show anything. If some part of the screen delays the initial HTML, you don't have to choose between delaying *all* HTML or excluding it from HTML. You can just allow that part to "pop in" later in the HTML stream.

Unlike traditional HTML streaming, it doesn't have to happen in the top-down order. For example, if the *sidebar* needs some data, you can wrap it in Suspense, and React will emit a placeholder and continue with rendering the post. Then, when the sidebar HTML is ready, React will stream it along with the `<script>` tag that inserts it in the right place--- even though the HTML for the post (which is further in the tree) has already been sent! There is no requirement that data loads in any particular order. You specify where the spinners should appear, and React figures out the rest.

> **Note**: for this to work, your data fetching solution needs to integrate with Suspense. Server Components will integrate with Suspense out of the box, but we will also provide a way for standalone React data fetching libraries to integrate with it.*

### Hydrating the page before all the code has loaded

We can send the initial HTML earlier, but we still have a problem. Until the JavaScript code for the comments widget loads, we can't start hydrating our app on the client. If the code size is large, this can take a while.

To avoid large bundles, you would usually use "code splitting": you would specify that a piece of code doesn't need to load synchronously, and your bundler will split it off into a separate `<script>` tag.

You can use code splitting with `React.lazy` to split off the comments code from the main bundle:

```source-js
import { lazy } from 'react';

const Comments = lazy(() => import('./Comments.js'));

// ...

<Suspense fallback={<Spinner />}>
  <Comments />
</Suspense>
```

Previously, this did not work with server rendering. (To the best of our knowledge, even popular workarounds forced you to choose between either opting out of SSR for code-split components or hydrating them after all their code loads, somewhat defeating the purpose of code splitting.)

But in React 18, `<Suspense>` lets you hydrate the app before the comment widget has loaded.

From the user's perspective, initially they see non-interactive content that streams in as HTML:

![](https://camo.githubusercontent.com/484be91b06f3f998b3bda9ba3efbdb514394ab70484a8db2cf5774e32f85a2b8/68747470733a2f2f717569702e636f6d2f626c6f622f5963474141416b314234322f704e6550316c4253546261616162726c4c71707178413f613d716d636f563745617955486e6e69433643586771456961564a52637145416f56726b39666e4e564646766361)

![](https://camo.githubusercontent.com/e44ee4be56e56e74da3b9f7f5519ca6197b24e9c34488df933140950f1b31c38/68747470733a2f2f717569702e636f6d2f626c6f622f5963474141416b314234322f534f76496e4f2d73625973566d5166334159372d52413f613d675a6461346957316f5061434668644e36414f48695a396255644e78715373547a7a42326c32686b744a3061)

Then you tell React to hydrate. The code for comments isn't there yet, but it's okay:

![](https://camo.githubusercontent.com/4892961ac26f8b8dacbd53189a8d3fd1b076aa16fe451f8e2723528f51b80f66/68747470733a2f2f717569702e636f6d2f626c6f622f5963474141416b314234322f304e6c6c3853617732454247793038657149635f59413f613d6a396751444e57613061306c725061516467356f5a56775077774a357a416f39684c31733349523131636f61)

This is an example of Selective Hydration. By wrapping `Comments` in `<Suspense>`, you told React that they shouldn't block the rest of the page from streaming---and, as it turns out, from hydrating, too! This means the second problem is solved: you no longer have to wait for all the code to load in order to start hydrating. React can hydrate parts as they're being loaded.

React will start hydrating the comments section after the code for it has finished loading:

![](https://camo.githubusercontent.com/8b2ae54c1de6c1b24d9080d2a50a68141f7f57252803543c30cc69cdd4b82fa1/68747470733a2f2f717569702e636f6d2f626c6f622f5963474141416b314234322f784d50644159634b76496c7a59615f3351586a5561413f613d354748716b387a7939566d523255565a315a38746454627373304a7553335951327758516f3939666b586361)

Thanks to Selective Hydration, a heavy piece of JS doesn't prevent the rest of the page from becoming interactive.

### Hydrating the page before all the HTML has been streamed

React handles all of this automatically, so you don't need to worry about things happening in an unexpected order. For example, maybe the HTML takes a while to load even as it's being streamed:

![](https://camo.githubusercontent.com/484be91b06f3f998b3bda9ba3efbdb514394ab70484a8db2cf5774e32f85a2b8/68747470733a2f2f717569702e636f6d2f626c6f622f5963474141416b314234322f704e6550316c4253546261616162726c4c71707178413f613d716d636f563745617955486e6e69433643586771456961564a52637145416f56726b39666e4e564646766361)

If the JavaScript code loads earlier than all HTML, React doesn't have a reason to wait! It will hydrate the rest of the page:

![](https://camo.githubusercontent.com/ee5fecf223cbbcd6ca8c80beb99dbea40ccbacf1b281f4cf8ac6970c554eefa3/68747470733a2f2f717569702e636f6d2f626c6f622f5963474141416b314234322f384c787970797a66786a4f4a753475344e44787570413f613d507a6a534e50564c61394a574a467a5377355776796e56354d715249616e6c614a4d77757633497373666761)

When the HTML for the comments loads, it will appear as non-interactive because JS is not there yet:

![](https://camo.githubusercontent.com/4892961ac26f8b8dacbd53189a8d3fd1b076aa16fe451f8e2723528f51b80f66/68747470733a2f2f717569702e636f6d2f626c6f622f5963474141416b314234322f304e6c6c3853617732454247793038657149635f59413f613d6a396751444e57613061306c725061516467356f5a56775077774a357a416f39684c31733349523131636f61)

Finally, when the JavaScript code for the comments widget loads, the page will become fully interactive:

![](https://camo.githubusercontent.com/8b2ae54c1de6c1b24d9080d2a50a68141f7f57252803543c30cc69cdd4b82fa1/68747470733a2f2f717569702e636f6d2f626c6f622f5963474141416b314234322f784d50644159634b76496c7a59615f3351586a5561413f613d354748716b387a7939566d523255565a315a38746454627373304a7553335951327758516f3939666b586361)

### Interacting with the page before all the components have hydrated

There is one more improvement that happened behind the scenes when we wrapped comments in a `<Suspense>`. Now their hydration no longer blocks the browser from doing other work.

For example, let's say the user clicks the sidebar while the comments are being hydrated:

![](https://camo.githubusercontent.com/6cc4eeef439feb3c17d0ac09c701c0deffe170c60a039afa8c0b85d7d4b9c9ef/68747470733a2f2f717569702e636f6d2f626c6f622f5963474141416b314234322f5358524b357573725862717143534a3258396a4769673f613d77504c72596361505246624765344f4e305874504b356b4c566839384747434d774d724e5036374163786b61)

In React 18, hydrating content inside Suspense boundaries happens with tiny gaps in which the browser can handle events. Thanks to this, the click is handled immediately, and the browser doesn't appear stuck during a long hydration on a low-end device. For example, this lets the user navigate away from the page they're no longer interested in.

In our example, only comments are wrapped in Suspense, so hydrating the rest of the page happens in a single pass. However, we could fix this by using Suspense in more places! For example, let's wrap the sidebar as well:

```source-js
<Layout>
  <NavBar />
  <Suspense fallback={<Spinner />}>
    <Sidebar />
  </Suspense>
  <RightPane>
    <Post />
    <Suspense fallback={<Spinner />}>
      <Comments />
    </Suspense>
  </RightPane>
</Layout>
```

Now *both* of them can be streamed from the server after the initial HTML containing the navbar and the post. But this also has a consequence on hydration. Let's say the HTML for both of them has loaded, but the code for them has not loaded yet:

![](https://camo.githubusercontent.com/9eab3bed0a55170fde2aa2f8ac197bc06bbe157b6ee9446c7e0749409b8ed978/68747470733a2f2f717569702e636f6d2f626c6f622f5963474141416b314234322f78744c50785f754a55596c6c6746474f616e504763413f613d4e617972396c63744f6b4b46565753344e374e6d625335776a39524473344f63714f674b7336765a43737361)

Then, the bundle containing the code for both the sidebar and the comments loads. React will attempt to hydrate both of them, starting with the Suspense boundary that it finds earlier in the tree (in this example, it's the sidebar):

![](https://camo.githubusercontent.com/6542ff54670ab46abfeb816c60c870ad6194ab15c09977f727110e270517b243/68747470733a2f2f717569702e636f6d2f626c6f622f5963474141416b314234322f424333455a4b72445f72334b7a4e47684b33637a4c773f613d4778644b5450686a6a7037744b6838326f6533747974554b51634c616949317674526e385745713661447361)

But let's say the user starts interacting with the comments widget, for which the code is also loaded:

![](https://camo.githubusercontent.com/af5a0db884da33ba385cf5f2a2b7ed167c4eaf7b1e28f61dac533a621c31414b/68747470733a2f2f717569702e636f6d2f626c6f622f5963474141416b314234322f443932634358744a61514f4157536f4e2d42523074413f613d3069613648595470325a6e4d6a6b774f75615533725248596f57754e3659534c4b7a49504454384d714d4561)

React will *record* that the click happened, and prioritize hydrating the comments instead because it's more urgent:

![](https://camo.githubusercontent.com/f76a33458a3e698125063884035e7f126104bc2c27c30c02fe8e9ebdf3048c7b/68747470733a2f2f717569702e636f6d2f626c6f622f5963474141416b314234322f5a647263796a4c49446a4a304261385a53524d546a513f613d67397875616d6c427756714d77465a3567715a564549497833524c6e7161485963464b55664f554a4d707761)

After the comments have hydrated, React "replay" the recorded click event (by dispatching it again) and let your component respond to the interaction. Then, now that React has nothing urgent to do, React will hydrate the sidebar:

![](https://camo.githubusercontent.com/64ea29524fa1ea2248ee0e721d1816387127507fd3d73a013f89266162b20fba/68747470733a2f2f717569702e636f6d2f626c6f622f5963474141416b314234322f525a636a704d72424c6f7a694635625a792d396c6b773f613d4d5455563334356842386e5a6e6a4a4c3875675351476c7a4542745052373963525a354449483471644b4d61)

This solves our third problem. Thanks to Selective Hydration, we don't have to "hydrate everything in order to interact with anything". React starts hydrating everything as early as possible, and it prioritizes the most urgent part of the screen based on the user interaction. The benefits of Selective Hydration become more obvious if you consider that as you adopt Suspense throughout your app, the boundaries will become more granular:

![](https://camo.githubusercontent.com/dbbedbfe934b41a8b4e4ed663d66e94c3e748170df599c20e259680037bc506c/68747470733a2f2f717569702e636f6d2f626c6f622f5963474141416b314234322f6c5559557157304a38525634354a39505364315f4a513f613d39535352654f4a733057513275614468356f6932376e61324265574d447a775261393739576e566e52684561)

In this example, the user clicks the first comment just as the hydration starts. React will prioritize hydrating the content of all parent Suspense boundaries, but will skip over any of the unrelated siblings. This creates an illusion that hydration is instant because components on the interaction path get hydrated first. React will hydrate the rest of the app right after.

In practice, you would likely add Suspense close to the root of your app:

```source-js
<Layout>
  <NavBar />
  <Suspense fallback={<BigSpinner />}>
    <Suspense fallback={<SidebarGlimmer />}>
      <Sidebar />
    </Suspense>
    <RightPane>
      <Post />
      <Suspense fallback={<CommentsGlimmer />}>
        <Comments />
      </Suspense>
    </RightPane>
  </Suspense>
</Layout>
```

With this example, the initial HTML could include the `<NavBar>` content, but the rest would stream in and hydrate in parts as soon the associated code is loaded, prioritizing the parts that the user has interacted with.

> *Note: You might be wondering how your app can work in this not-fully-hydrated state. There are a few subtle details in the design that make it work. For example, instead of hydrating each individual component separately, hydration happens for entire `<Suspense>` boundaries. Since `<Suspense>` is already used for content that doesn't appear right away, your code is resilient to its children not being immediately available. React always hydrates in the parent-first order, so the components always have their props set. React holds off from dispatching events until the entire parent tree from the point of the event is hydrated. Finally, if a parent updates in a way that causes the not-yet-hydrated HTML to become stale, React will hide it and replace it with the `fallback` you specified until the code has loaded. This ensures the tree appears consistent to the user. You don't need to think about it, but that's what makes it work.*

## Demo

We've prepared a [demo you can try](https://codesandbox.io/s/github/facebook/react/tree/master/fixtures/ssr2?file=/src/App.js) to see how the new Suspense SSR Architecture works. It is artifically slowed down, so you can adjust the delays in `server/delays.js`:

- `API_DELAY` lets you make the comments take longer to fetch on the server, showcasing how the rest of the HTML can be sent early.
- `JS_BUNDLE_DELAY` lets you delay the `<script>` tags from loading, showcasing how the comment widget's HTML "pops in" even before React and your application bundle have been downloaded.
- `ABORT_DELAY` lets you see the server "giving up" and handing off rendering to the client if fetching on the server takes too long.

## In Conclusion

React 18 offers two major features for SSR:

- Streaming HTML lets you start emitting HTML as early as you'd like, streaming HTML for additional content together with the `<script>` tags that put them in the right places.
- Selective Hydration lets you start hydrating your app as early as possible, before the rest of the HTML and the JavaScript code are fully downloaded. It also prioritizes hydrating the parts the user is interacting with, creating an illusion of instant hydration.

These features solve three long-standing problems with SSR in React:

- You no longer have to wait for all the data to load on the server before sending HTML. Instead, you start sending HTML as soon as you have enough to show a shell of the app, and stream the rest of the HTML as it's ready.
- You no longer have to wait for all JavaScript to load to start hydrating. Instead, you can use code splitting together with server rendering. The server HTML will be preserved, and React will hydrate it when the associated code loads.
- You no longer have to wait for all components to hydrate to start interacting with the page. Instead, you can rely on Selective Hydration to prioritize the components the user is interacting with, and hydrate them early.

The `<Suspense>` component serves as an opt-in for all of these features. The improvements themselves are automatic inside React and we expect them to work with the majority of existing React code. This demonstrates the power of expressing loading states declaratively. It may not look like a big change from `if (isLoading)` to `<Suspense>`, but it's what unlocks all of these improvements.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
