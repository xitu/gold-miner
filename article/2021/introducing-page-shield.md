> * 原文地址：[Page Shield: Protect User Data In-Browser](https://blog.cloudflare.com/introducing-page-shield/)
> * 原文作者：[Justin Zhou](https://blog.cloudflare.com/author/justin-zhou)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/introducing-page-shield.md](https://github.com/xitu/gold-miner/blob/master/article/2021/introducing-page-shield.md)
> * 译者：
> * 校对者：

# Page Shield: Protect User Data In-Browser

![](https://blog.cloudflare.com/content/images/2021/03/image3-31.png)

Today we're excited to introduce Page Shield, a client-side security product customers can use to detect attacks in end-user browsers.

Starting in 2015, a hacker group named [Magecart](https://sansec.io/what-is-magecart) stole payment credentials from online stores by infecting third-party dependencies with malicious code. The infected code would be requested by end-user browsers, where it would execute and access user information on the web page. After grabbing the information, the infected code would send it to the hackers, where it would be resold or used to launch additional attacks such as credit card fraud and identity theft.

Since then, other targets of such [supply chain attacks](https://en.wikipedia.org/wiki/Supply_chain_attack) have included Ticketmaster, Newegg, British Airways, and more. The British Airways attack stemmed from the compromise of one of their self-hosted JavaScript files, exposing nearly 500,000 customers’ data to hackers. The attack resulted in GDPR fines and the [largest class-action privacy suit in UK history](https://www.bloomberg.com/news/articles/2021-01-12/british-airways-faces-biggest-class-action-suit-over-data-breach). In total, millions of users have been affected by these attacks.

Writing secure code within an organization is challenging enough without having to worry about third-party vendors. Many SaaS platforms serve third-party code to millions of sites, meaning a single compromise could have devastating results. Page Shield helps customers monitor these potential attack vectors and prevent confidential user information from falling into the hands of hackers.

Earlier this week, [we announced Remote Browser Isolation](https://blog.cloudflare.com/browser-isolation-for-teams-of-all-sizes/) for all as a way to mitigate client-side attacks in your employee’s browsers. Page Shield is continuing Cloudflare’s push into client-side security by helping mitigate attacks aimed at your customers.

## Background

A Magecart-style attack is a type of software supply chain attack carried out in a user’s browser. Attackers target the hosts of third-party JavaScript dependencies and gain control over the source code served to browsers. When the infected code executes, it often attempts to steal sensitive data that end-users enter into the site such as credit card details during a checkout flow.

These attacks are challenging to detect because many application owners trust third-party JavaScript to function as intended. Because of this trust, third-party code is rarely audited by the application owner. In many cases, Magecart attacks have lasted months before detection.

Data exfiltration isn’t the only risk stemming from software supply chains. In recent years we’ve also seen hackers modify third-party code to show fraudulent advertisements to users. Users click through these advertisements and go to phishing sites, where their personal information is stolen by the hackers. Other JavaScript malware has mined cryptocurrencies for the attackers using end-user resources, damaging site performance.

So what can application owners do to protect themselves? Existing browser technologies such as Content Security Policy (CSP) and Subresource Integrity (SRI) provide some protection against client-side threats, but have some drawbacks.

CSP enables application owners to send an allowlist to the browser, preventing any resource outside of those listed to execute. While this can prevent certain cross-site scripting attacks (XSS), it fails to detect when existing resources change from benign to malicious states. Managing CSP is also operationally challenging as it requires developers to update the allowlist every time a new script is added to the site.

SRI enables application owners to specify an expected file hash for JavaScript and other resources. If the fetched file doesn’t match the hash, it is blocked from executing. The challenge with SRI is vendors update their code often, and in certain cases serve different files to different end-users. We’ve also found that JavaScript vendors will sometimes serve versioned files with different hashes to end-users due to small differences such as spacing. This could result in SRI blocking legitimate files by no fault of the application owner.

## Script Monitor is the first available Page Shield feature

Script Monitor is the beginning of Cloudflare’s ambition for Page Shield. When turned on, it records your site’s JavaScript dependencies over time. As new JavaScript dependencies appear, we alert you so you can investigate if they are expected changes to your site. This helps you identify if bad actors modified your application to request a new, malicious JavaScript file. Once the beta is complete, this initial feature set will be made available to Business and Enterprise customers at no extra charge.

## How does Script Monitor work?

Because of Cloudflare’s unique position between application origin servers and end-users, we can modify responses before they reach end-users. In this case, we’re adding an additional Content-Security-Policy-Report-Only header to pages as they pass through our edge. When JavaScript files attempt to execute on the page, browsers will send a report back to Cloudflare. As we are using a report-only header, there’s no requirement for application owners to maintain allowlists for relevant insights.

For each report we see, we compare the JavaScript file with the historic dependencies of that zone and check if the file is new. If it is, we fire an alert so customers can investigate and determine whether the change was expected.

![The Script Monitor UI located under Firewall -> Page Shield](https://blog.cloudflare.com/content/images/2021/03/image1-40.png)

The Script Monitor UI located under Firewall -> Page Shield

As a beta participant, you will see the Page Shield tab under the Firewall section of your zone dashboard. There, you can find the Script Monitor table tracking your zone’s JavaScript dependencies. For each dependency, you can view the first seen date, last seen date, and host domain that it was detected on.

![Email notification example for new JavaScript dependencies found](https://blog.cloudflare.com/content/images/2021/03/image2-34.png)

Email notification example for new JavaScript dependencies found

You can also configure Script Monitor notifications in the dashboard. These notifications send alerts to email or PagerDuty whenever a new JavaScript file is requested by your site.

## Looking forward

Our mission is to help build a better Internet. This extends to end-user browsers, where we’ve seen an alarming increase in attacks over the past several years. With Page Shield, we will help applications detect and mitigate these elusive attacks to keep their user’s sensitive information safe.

We are already building code change detection into Script Monitor. Code change detection will periodically fetch your application’s JavaScript dependencies and analyze their behavior. When new code behavior is detected to existing files, we will alert you so you can review the change and determine if the new code is a benign update or an infected piece of code.

Coming after code change detection is intelligent analysis of JavaScript files. While alerting application owners when their dependencies change provides insight into files of interest, we can do better. We’ve worked with our security partners to acquire samples of Magecart JavaScript and have proven we can accurately classify malicious JavaScript samples. We plan to refine our techniques further and eventually begin alerting Page Shield customers when we believe their dependencies are malicious.

We’ve talked to our customers and understand that maintaining CSP allowlists is operationally challenging. If new client-side JavaScript is deployed without being added to the allowlist, then that new code will be blocked by browsers. That’s why we will use our position as a reverse-proxy to ship negative security model blocking. This will allow application owners to block individual scripts without having to maintain an allowlist, ensuring customers can ship new code without the cumbersome overhead.

## Sign up for the beta

Starting today, all Business and Enterprise customers can sign up [here](https://www.cloudflare.com/waf/page-shield/) to join the closed beta for Page Shield. By joining the beta, customers will be able to activate Script Monitor and begin monitoring their site’s JavaScript.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
