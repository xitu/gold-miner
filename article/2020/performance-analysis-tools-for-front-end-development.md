> * 原文地址：[8 Performance Analysis Tools for Front-End Development](https://blog.bitsrc.io/performance-analysis-tools-for-front-end-development-a7b3c1488876)
> * 原文作者：[Mahdhi Rezvi](https://medium.com/@mahdhirezvi)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/performance-analysis-tools-for-front-end-development.md](https://github.com/xitu/gold-miner/blob/master/article/2020/performance-analysis-tools-for-front-end-development.md)
> * 译者：
> * 校对者：

# 8 Performance Analysis Tools for Front-End Development

![](https://cdn-images-1.medium.com/max/2560/1*WIIXp_ny48NehrJCWsJy6Q.jpeg)

You can have the most beautiful and engaging website in the world, if it does not load quickly on the browser, people would tend to skip it. Although there are many performance rules out there, at the end of the day, it all comes down to load time.

According to [Jakob Nielson](https://www.nngroup.com/articles/website-response-times/), here are things you should remember when building your website.

* Under 100 milliseconds is perceived as instantaneous.
* A 100ms to 300ms delay is perceptible.
* One second is about the limit for the user’s flow of thought to stay uninterrupted. They will sense the delay, but they can manage.
* 47% of consumers expect a web page to load in two seconds or less
* 40% of consumers will wait no more than three seconds for a web page to render before abandoning the site.
* 10 seconds is around the limit for keeping the user’s attention. Most users would leave your site after 10 seconds.

Read more about these statistics over [here](https://www.hobo-web.co.uk/your-website-design-should-load-in-4-seconds/) and [here](https://www.nngroup.com/articles/website-response-times/).

---

As you can see, it is clearly evident that you need to make sure your pages load quickly as possible even on the poorest of network connections. Easier said than done.

To help you achieve this ultimate goal — here’s my list of recommended tools for performance analyst.

## 1. PageSpeed Insights

This is a [free service](https://developers.google.com/speed/pagespeed/insights/) that analyzes the content of a web page, and then generates suggestions to make that page faster. It provides you with key metrics such as First Contentful Paint, Total Blocking Time and much more. The metrics are categorized as Field Data, Origin Summary, Lab Data, Opportunities, Diagnostics and Passed Audits. It also provides you with suggestions for further improvements.

PageSpeed works entirely on performance and uses a mix of lab and real-world data to build a comprehensive report on the speed of a website. Below is the PageSpeed Insight result for my [portfolio website](https://thisismahdhi.ml). As you can see, there is not enough real-world speed data for the summary.

![Screenshot by Author](https://cdn-images-1.medium.com/max/6696/1*ONiEtpxiMc3KitaT7OiYRw.png)

Pasting individual URLs isn’t feasible at the enterprise level. This problem can be solved by running [Automated Google PageSpeed Tests](https://pagespeedplus.com/blog/automating-google-pagespeed-testing) with PageSpeedPlus. It scans the complete site for you every week and provides the results in a user-friendly report. You can also check the PageSpeed API [here](https://developers.google.com/speed/docs/insights/v5/get-started).

## 2. Lighthouse

[Lighthouse](https://developers.google.com/web/tools/lighthouse) is an automated open-source tool that helps analyze various perspectives of a web page like Performance but also further items like SEO, Accessibility, Best Practices and whether the site meets the requirement of a PWA.

You can simply run this tool in Chrome developer tools, from the command line or even as a Node module. All you have to do is to provide a URL and Lighthouse runs a series of audits and tells you how the site performed. Each audit has a reference doc explaining why the audit is important, as well as how to fix it.

![Google Lighthouse — Screenshot by Author](https://cdn-images-1.medium.com/max/6492/1*YjmPZ4M8Q6KTZik_6-2NaA.png)

Another great use of Lighthouse is integrating the API into your own systems to run the audits programmatically. For example, if you wanted to prevent releases that don’t meet SEO and Performance standards, you could use the Lighthouse to run the tests on demand.

## 3. WebPageTest

This is a [free tool](https://www.webpagetest.org/) that allows you to test your website speed using browsers such as Chrome with real user connection speeds. You have options such as Advanced Testing, Simple Testing, Visual Comparison and Traceroute. You have a lot of options such as multi-step transactions, video capture, content blocking and much more. Your final results will produce rich diagnostic information including resource loading waterfall charts, Page Speed optimization checks with suggestions for improvements.

Web page test also provides the page statistics on the first view and repeated view along with the details of server responses.

![Screenshot by Author](https://cdn-images-1.medium.com/max/2642/1*3MrD-mCHa-vN3bP3zTQ6-Q.png)

## 4. Pingdom

[Pingdom](https://speedcurve.com/) is another powerful analysis service that provides you with tons of functionality. It provides a comprehensive summary of server responses of the page requests, page load time, size and the request analysis. You are able to analyze your site from locations all over the world. You are provided with suggestions to improve your page score as well.

My favourite feature is the filtered summary where you are given summaries about the website content and requests. I found this very helpful to get an overall idea of the content being served on my web page.

![Screenshot by Author](https://cdn-images-1.medium.com/max/2542/1*KHVSkyoFYveQ_mcahOpo-g.png)

## 5. SiteSpeed

[SiteSpeed](https://www.sitespeed.io/) is an open-source set of tools that allow you to monitor and measure the performance of your web site. You can get started with a docker image or by installing the NPM package. As there are several tools being provided, you should be able to choose a tool that suits you best. You can find out more about the tools on the [official website](https://www.sitespeed.io/).

Although SiteSpeed is free, it will cost you to set up the servers and keep them running. If you do not own servers, SiteSpeed recommends you to get a [Digital Ocean](https://www.digitalocean.com/) optimized droplets with 2 vCPUs or on [AWS](https://aws.amazon.com/) c5.large, storing the data at S3.

![SiteSpeed Homepage — Screenshot by Author](https://cdn-images-1.medium.com/max/2662/1*n5FITnS0PUegqchHkSS2eg.png)

## 6. Calibre

[Calibre](https://calibreapp.com/) is an all in one performance monitoring suite that helps you monitor and audit your website’s performance. It also allows you to simulate real-world conditions by specifying test server locations, managing ad preferences of the simulation and even mimicking mobile devices. It also allows you to set budgets and helps you stay within them by providing you with performance regressions.

It also comes with [much more features](https://calibreapp.com/features) that cannot be explained in this short article. I highly suggest you check out their [website](https://calibreapp.com/).

![Calibre Homepage — Screenshot by Author](https://cdn-images-1.medium.com/max/2674/1*ZwqTNsAkVqH5HPe2Ggmy8w.png)

## 7. SpeedCurve

[SpeedCurve](https://speedcurve.com/) captures real user data and reflects on the actual client’s experience of our website. It also allows you to compare your site with your competitors by providing a benchmark feature. This would allow you to keep ahead of the competition at all times. You are also able to generate filmstrip of the actual loading progress of your site.

SpeedCurve also provides you with Synthetic monitoring. Synthetic monitoring is a simulation of your website in a controlled environment. You are able to customize options like the speed of the network, the device, the operating system and much more.

![SpeedCurve Homepage — Screenshot by Author](https://cdn-images-1.medium.com/max/2666/1*S3aC2hbCDQz7dfvDJsd_kg.png)

## 8. SpeedTracker

[SpeedTracker](https://speedtracker.org/) is a tool that runs on top of [WebPageTest](https://www.webpagetest.org/) and makes regular performance tests on your website and shows a visualisation of how the various performance metrics evolve over time. This allows you to assess your website continuously and to see how your new features impact the performance on your website. You can also define budgets and get alerts via email and Slack.

This tool is being used by big names such as BBC, University of Connecticut and Red Bull TV.

![SpeedTracker Homepage — Screenshot by Author](https://cdn-images-1.medium.com/max/2658/1*FfMBnmPxWZUYUc6GeNfHUA.png)

---

You can do quite a lot with the help of the above tools, but to make your website up to the standard, you might need to take things a step up. I found this awesome article by Vitaly Friedman that literally covered the A-Z on website optimization on the front-end. I highly suggest you have a look.

[**Front-End Performance Checklist 2020 (PDF, Apple Pages, MS Word)**](https://www.smashingmagazine.com/2020/01/front-end-performance-checklist-2020-pdf-pages/)

Happy Coding!!

---

**Resources**

[PageSpeedPlus](https://pagespeedplus.com/blog/pagespeed-insights-vs-lighthouse)
[Techbeacon](https://techbeacon.com/app-dev-testing/web-performance-testing-18-free-open-source-tools-consider)
[Dzone](https://dzone.com/articles/client-side-performance-testing)
[Blog article by Jacob Tan](https://medium.com/@jacobtan/tackling-front-end-performance-strategy-tools-and-techniques-12ca542052e7)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
