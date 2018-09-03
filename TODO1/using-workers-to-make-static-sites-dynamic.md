> * 原文地址：[Using Workers To Make Static Sites Dynamic](https://blog.cloudflare.com/using-workers-to-make-static-sites-dynamic/)
> * 原文作者：[]()
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/using-workers-to-make-static-sites-dynamic.md](https://github.com/xitu/gold-miner/blob/master/TODO1/using-workers-to-make-static-sites-dynamic.md)
> * 译者：
> * 校对者：

# Using Workers To Make Static Sites Dynamic

_The following is a guest post by [Paddy Sherry](https://www.linkedin.com/in/paddy-sherry-a7420a47/), Lead Developer at Gambling.com Group. They build performance marketing websites and tools, using Cloudflare to serve to their global audience. Paddy is a Web Performance enthusiast with an interest in Serverless Computing._

> Choosing technology that is used on a large network of sites is a key architectural decision that must be correct. We build static websites but needed to find a way to make them dynamic to do things like geo targeting, restrict access and A/B testing. This post shares our experiences on what we learned when using Workers to tackle these challenges.

### Our Background

At [Gambling.com Group](https://www.gambling.com/corporate), we use Cloudflare on all of our sites so our curiosity level in Workers was higher than most. We are big fans of static websites because nothing is faster than flat HTML. We had been searching for a technology like this for some time and applied to be part of the beta program, so were one of the first to gain access to the functionality.

The reason we were so keen to experiment with Workers is that for anyone running static sites, 99% of the time, the product requirements can be met but there will always be that one occasion when some computation is needed instead of sending back a static response.

Until recently, the most suitable option would have been to add some JavaScript that fires after page load and alters the UI or fetches data from an endpoint. The drawback of this is that users see the page shifting after it loads, even if the script is loaded asynchronously. Flickering pages can be infuriating and there is nothing more irritating than trying to click a link but opening something else because the DOM changed midway through.

A common workaround is to hide the page content until all JavaScript has processed, but this leaves you exposed to a slow loading script with users seeing a white page until the browser has downloaded it. Even if all scripts are downloading quickly, there will be users with slower Internet speeds or located far away from a data centre that can respond to their request.

**Enter Cloudflare Workers**. Developers can handle these requests and respond dynamically before they even reach the server. There is no post load computation and Workers respond so fast in the background, the transition is unnoticeable.

### Our Use Cases For Workers

Since getting access to Workers we’ve been experimenting with ways to make our static sites more dynamic without changing all of the smart technology we’ve built to power our network of websites.

#### Geo-Targeting

We operate static websites around the world in many languages and use Cloudflare to serve them. Users get there from a google search or by clicking a link somewhere else on the Internet. Often, the site they land on may not be a perfect match for interests because the link they clicked wasn’t pointing at the most optimal location. For example, a user in Canada lands on a UK site and sees prices in Pounds Sterling instead of Canadian Dollars or a person in Italy lands on a US site and sees English content instead of Italian.

The conundrum of static websites is that the pages load exceptionally fast but once there, we have no further ability to tailor the experience in line with the user's preferences.

With Workers, we were able to solve this problem by reading request headers at the edge. Cloudflare detects the origin IP of the incoming request and appends a two-letter country code to a header called _‘Cf-Ipcountry.’_ We were able to write a simple worker that reads this header, checks the country code, and then redirects to the appropriate site version if it exists.

```
addEventListener('fetch', event => {
 event.respondWith(fetchAndApply(event.request))
})

async function fetchAndApply(request) {

   const country = request.headers.get('Cf-Ipcountry').toLowerCase() 
   let url = new URL(request.url)

   const target_url = 'https://' + url.hostname + '/' + country
   const target_url_response = await fetch(target_url)

   if(target_url_response.status === 200) {
       return new Response('', {
         status: 302,
         headers: {
           'Location': target_url
         }
       })     
   } else {
       return response
   }
}
```

Users are now getting a localized version of the site, which better serves their interests and the bounce rate is lower because the content is tailored to their location.

### Restricting Access To Content

With most sites, there will be occasions when a page needs to be online but not available to the public. For example, an agency demonstrating a new landing page to a client before final approval.

In some cases, companies may need many layers of security to protect their intellectual property and avoid something being seen before it is ready, but for most the information just needs to be hidden and military grade security isn't required.

With a Content Management System this is easy to do, but is difficult with a static site. Using Workers, we were able to put together a simple solution that prevents access to the page unless a certain header is present in the request, which can also be adapted to look for a query parameter.

```
addEventListener('fetch', event => {
  event.respondWith(fetchAndApply(event.request))
})

async function fetchAndApply(request) {  
  var ua = request.headers.get('user-agent');
    let url = new URL(request.url);

    if (ua.indexOf('MY-TEST-STRING')) {
        return fetch(request)
    } else {
        return new Response('Access Denied',
            { status: 403, statusText: 'Forbidden' })
    }
}
```

A page can now be hidden from the public without major investment in security or authentication technology but is still easy to access for those that need it.

#### A/B Testing

A vital tool in optimizing traffic is the insight acquired from A/B testing. While there is no shortage of powerful A/B testing tools, most require the addition of a Javascript that alters the UI after page load. In optimal conditions, this can be unnoticeable to the naked eye but not all users have the best internet speeds and some will experience flicker after the page loads. As discussed above, this is a poor experience with negative consequences.

We were able to solve this problem with a Worker that makes a call to the A/B testing script URL, fetches the code and redraws the UI before sending the altered response to the user. The result is that users see the variant when the page loads and nothing moves after the first pixel has rendered.

### Why Workers Has Removed Roadblocks For Us

Workers have allowed us to make our static sites dynamic. Of course, we could have done this with post-load Javascript but the experience for users would have been poor.

A second option would have been migrating to server rendered sites but even with an architecture shift like that, it would be difficult to have enough servers around the world to give users in all locations the same experience. It also would have been a significant IT investment to undertake such a change.

Workers, on the other hand, can be inserted at top of our architecture with no work required to install or add them. It is a matter of clicking a button in the Cloudflare dashboard and immediately gaining access to the Worker playground. There was no time lost in negotiating a trial or setting up the dev environment, which is a notorious time waster when researching any new technology or vendor.

### Why We Chose Workers Over AWS Lambda

It is important to note that Workers are not the only option in serverless computing, as that is where the industry is generally heading. While AWS Lambda is a strong contender we went with Workers because Lambda requires integration with more AWS services to get started and recent performance tests that suggest Workers are [faster than Lambda](https://blog.cloudflare.com/serverless-performance-comparison-workers-lambda/).

![](https://blog.cloudflare.com/content/images/2018/08/Screen-Shot-2018-08-15-at-12.15.55-PM-1-1.png)

While we may have chosen AWS with different requirements, Workers were still much easier to get up and running quickly.

### Improvements We Would Like To See

Despite our overwhelming approval, there are a couple of things we’d like to see added.

Accounts currently have access to a single Worker script unless you have an Enterprise plan. This means a lot of unrelated code is housed in one file and while this is not uncommon on its own, a Worker can only fire on a single URL pattern. This can feel restrictive if you want to trigger functionality on one set of pages, but not others and means that you have a series of if statements in the Worker code that determine when it should fire. It’s not unworkable but not an ideal scenario either.  
We look forward to the documentation growing with more real world examples, as the Worker Recipe exchange grows and Cloudflare continues to build out more content.

### Conclusion

We are just at the start of our journey with Cloudflare Workers. As knowledge within our team grows, we can use it to meet our product requirements when appropriate and do more advanced things that were previously impossible without post-load Javascript. Workers are still in their infancy and improvements that can be made. We’ll be following these closely and experimenting to find ways to use them as new features are released.

This guide was a high-level overview. For more in-depth explanations and code snippets, check out this [Review of Cloudflare Workers](https://leaderinternet.com/blog/cloudflare-workers-review) that explains some of the examples in detail

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
