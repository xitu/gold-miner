> * 原文地址：[5 Reasons to Switch from React to Next.js](https://javascript.plainenglish.io/5-reasons-to-switch-from-react-to-next-js-f776413693d0)
> * 原文作者：[anuragkanoria](https://medium.com/@anuragkanoria)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/5-Reasons-to-Switch-from-React-to-Next-js.md](https://github.com/xitu/gold-miner/blob/master/article/2021/5-Reasons-to-Switch-from-React-to-Next-js.md)
> * 译者：
> * 校对者：


## 5 Reasons to Switch from React to Next.js

### Choosing the wrong framework can become a horrible nightmare

![Photo by [arash payam](https://unsplash.com/@arash_payam?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/7936/0*_KSkOhjmAnWJXTY9)

It was 2020 and the first lockdown had just begun. Like folks from all around the globe, I found myself having unplanned spare time.

I decided to spend this leisure time learning new technologies and ended up learning React and sharpening my Node.js skills.

I built a blogging platform, using React on the frontend and Node.js server for the backend. The platform has all the features you would expect a production-ready app to have:

 1. Multiple sign-in options( sign in with Google, Twitter, etc).

 2. Feature-rich editor to write beautiful blogs.

 3. Ability to create drafts and edit published posts.

 4. Analytics as well as an admin panel.

But this is where I learned some of the most important lessons surrounding web development.

From the user’s perspective, everything seemed fine but from a developer’s point of view, it was a nightmare maintaining the codebase.

It was at this time I understood what Next.js’s slogan *“The React Framework for Production”* truly meant.

![Source: [Next.js landing page](https://nextjs.org/)](https://cdn-images-1.medium.com/max/2672/1*sQGE3HQsLTifb1-BDf_ydg.jpeg)

There were primarily 5 main reasons why I switched from React to Next.js.

## 1. React isn’t SEO-friendly

Every blog or a production-ready site needs to be optimized for search engines, except some sites like control panel or user settings.

It’s been almost a year and still, most of the blogs of my React site don’t appear on Google Search even if I specifically search using URL and other tools.

This is after I tried my best to make React SEO-friendly by using libraries like [React Helmet](https://www.npmjs.com/package/react-helmet).

The poor SEO scores of React are because it doesn’t render on the server. On the other hand, the primary advantage of Next.js is that it supports server-side rendering.

A good SEO was needed to increase organic traffic and Next.js seemed to be the solution that guaranteed that.

However, I would like to note that it isn’t true that client-side ReactJS apps are not crawled by Google Bots. They are but the SEO isn’t as good as the one provided by Next.js.

If you want to read in detail about rendering and SEO in JavaScript apps, check my blog where I cover these topics in layman’s language.
[**A Beginner’s Guide to SEO for JavaScript Web Applications**
*After building multiple sites, here’s what I learned about organic traffic and SEO*javascript.plainenglish.io](https://javascript.plainenglish.io/a-beginners-guide-to-seo-for-javascript-web-applications-c67d55728291)

## 2. AdSense approval issues

React creates Single-Page Applications(SPAs) which is essentially a single page, loaded once.

As you navigate around the page and navigate to other pages, the data is loaded dynamically.

Although SPAs are known for being fast, responsive, and give a native-app vibe, they do have their own shortcomings.

I ran into one of the shortcomings when I was trying to monetize the site using [Google’s AdSense.](https://www.google.com/adsense/start/#/?modal_active=none)

AdSense simply didn’t detect the code they asked me to put in the index.html file, and when unexpectedly it did, it failed to find any content on the site.

This is because the blogs are loaded dynamically and AdSense needs to see genuine content before approving your site to show ads.

Upon a simple Google search, I found that it’s a common issue with many SPA sites.

This issue stems from the lack of proper server-side rendering support, another thing Next.js could easily fix.

## 3. Easier Navigation

Understanding navigation and routing in React requires one to undergo a steep learning curve, especially if the person is coming from frameworks like Vue(like myself).

Routing in React uses a package React-Router-Dom and the code can seem intimidating at first glance. [Here’s an example of what routing in React looks like.](https://reactrouter.com/web/example/basic)

Since my site was feature-rich, I had tons of pages from the expected blog and sign-in page to the FAQ and terms of service page.

Next.js simplified routing for all these pages. It offers a file-system-based router built on the concept of pages & a page is basically a React component.

Adding these “page” files to the ‘pages’ directory automatically makes it available as a route.

This greatly simplified routing and as someone coming from Vue and Nuxt, it seemed a lot familiar.

You can find more on that [here](https://nextjs.org/docs/routing/introduction).

## 4. API Routes

Next.js has in-built support for API Routes, which enables you to create quick API endpoints using the known file-based system.

Any file you place in the ‘pages/api’ directory will be treated as an API endpoint( as a Node.js serverless function).

This is an incredibly useful feature if you need to perform some server-side functions as these endpoints aren’t part of the client bundle.

For instance, if you have an input form on your site, you can send the ‘POST’ request to the API endpoint that will validate the input and store the data into a database.

This will essentially allow you to create serverless functions and it allowed me to merge my Node.js and React codebase into a single Next.js application.

The API Routes that Next.js creates is a frontend for the data that Next itself utilizes.

It can help if you are planning to create a mobile app and fetch data from the server.

## 5. Built-in Image Component

As I mentioned earlier, I built a blog site and any blog needs to have media content as well alongside text.

Just look at this blog itself, it has a few images besides written content.

[As per Next.js documentation, images take up 50% of the total bytes on web pages.](https://nextjs.org/blog/next-10#images-on-the-web:~:text=Images%20take%20up%2050%25%20of%20the%20total%20bytes%20on%20web%20pages.)

Usually, there is a limit, say 25 megabytes, on media file sizes.

Moreover, some of the loaded photos are not in the user’s viewport, that is, the user has to scroll down to the image.

Hence, many factors such as lazy-loading, compression, size & format have to be considered.

Next.js solves all these problems using Next.js Image Component and Automatic Image Optimization which replaces the <img> HTML tag.

By using it, the images are lazy-loaded by default and the browsers respect the image dimensions by leaving the space blank until the image is loaded. This avoids the image from randomly jumping in and enhances the user experience.

Additionally, Next.js ‘next/image’ component shrinks the image size on-demand using the latest formats like WebP which is 30% lighter than the JPEG counterpart.

Moreover, these optimizations take place on-demand so your build-times are not affected and images from external sources are optimized as well.

### Conclusion

React is the [most popular framework](https://www.codeinwp.com/blog/angular-vs-vue-vs-react/) and without a shadow of a doubt a must-learn in every web developer’s book.

This doesn’t however mean that React is suitable for each and every type of site. Like every other framework, React has its own share of pitfalls.

Next.js, built on top of React, aims to provide solutions to some of the React problems, while also easing the overall development by introducing in-built solutions to some of the modern challenges.

Switching from React to Next is possible but if you are starting out, it is wise to choose Next over React instead of migrating later.

That being said, using Next.js for every project and completely ditching React is not advisable either.

Every website & app is built with specific intentions and goals, which can play a vital part in choosing the right framework & libraries.

Unfortunately, in my case, I figured out that the goals of the website after I had completely built it in React, only to find that I should have used Next.js instead of React for the reasons discussed above.

Hopefully, you learned something from my mistake and will be able to choose the apt framework.

Thanks for reading!

*More content at [**plainenglish.io](https://plainenglish.io/)***
> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。