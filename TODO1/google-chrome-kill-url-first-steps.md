> * 原文地址：[GOOGLE TAKES ITS FIRST STEPS TOWARD KILLING THE URL](https://www.wired.com/story/google-chrome-kill-url-first-steps/)
> * 原文作者：[wired.com](https://www.wired.com/story/google-chrome-kill-url-first-steps/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/google-chrome-kill-url-first-steps.md](https://github.com/xitu/gold-miner/blob/master/TODO1/google-chrome-kill-url-first-steps.md)
> * 译者：
> * 校对者：

# GOOGLE TAKES ITS FIRST STEPS TOWARD KILLING THE URL

![](https://media.wired.com/photos/5c50d1e7ffef4d2c9d62f609/master/w_1164,c_limit/Google%20Takes%20Its%20First%20Steps%20Toward%20Killing%20the%20URL.jpg)

In September, members of Google's Chrome security team put forth a [radical proposal](https://www.wired.com/story/google-wants-to-kill-the-url/): Kill off URLs as we know them. The researchers aren't actually advocating a change to the web's underlying infrastructure. They do, though, want to rework how browsers convey what website you're looking at, so that you don't have to contend with increasingly long and unintelligible URLs—and the fraud that has [sprung up](https://www.wired.com/story/phishing-schemes-use-encrypted-sites-to-seem-legit/) around them. In a talk at the Bay Area Enigma security conference on Tuesday, Chrome usable security lead Emily Stark is wading into the controversy, detailing Google's first steps toward more robust website identity.

Stark emphasizes that Google isn't trying to induce chaos by eliminating URLs. Rather, it wants to make it harder for hackers to capitalize on user confusion about the identity of a website. Currently, the endless haze of complicated URLs gives attackers cover for effective scams. They can create a malicious link that seems to lead to a legitimate site, but actually automatically redirects victims to a phishing page. Or they can design malicious pages with URLs that look similar to real ones, hoping victims won't notice that they're on G00gle rather than Google. With so many URL shenanigans to combat, the Chrome team is already at work on two projects aimed at bringing users some clarity.

"What we’re really talking about is changing the way site identity is presented," Stark told WIRED. "People should know easily what site they’re on, and they shouldn’t be confused into thinking they’re on another site. It shouldn’t take advanced knowledge of how the internet works to figure that out."

The Chrome team's efforts so far focus on figuring out how to detect URLs that seem to deviate in some way from standard practice. The foundation for this is an open source tool called TrickURI, launching in step with Stark's conference talk, that helps developers check that their software is displaying URLs accurately and consistently. The goal is to give developers something to test against so they know how URLs are going to look to users in different situations. Separate from TrickURI, Stark and her colleagues are also working to create warnings for Chrome users when a URL seems potentially phishy. The alerts are still in internal testing, because the complicated part is developing heuristics that correctly flag malicious sites without dinging legitimate ones.*

For Google users, the first line of defense against phishing and other online scams is still the company's [Safe Browsing platform](https://www.wired.com/story/google-safe-browsing-oral-history/). But the Chrome team is exploring complements to Safe Browsing that specifically focus on flagging sketchy URLs.

Google

"Our heuristics for detecting misleading URLs involve comparing characters that look similar to each other and domains that vary from each other just by a small number of characters," Stark says. "Our goal is to develop a set of heuristics that pushes attackers away from extremely misleading URLs, and a key challenge is to avoid flagging legitimate domains as suspicious. This is why we're launching this warning slowly, as an experiment."

Google says it hasn't started rolling out the warnings to the general user population while the Chrome team refines those detection capabilities. And while URLs may not be going anywhere anytime soon, Stark emphasizes that there is more in the works on how to get users to focus on important parts of URLs and to refine how Chrome presents them. The big challenge is showing people the parts of URLs that are relevant to their security and online decision-making, while somehow filtering out all the extra components that make URLs hard to read. Browsers also sometimes need to help users with the opposite problem, by expanding shortened or truncated URLs.

"The whole space is really challenging because URLs work really well for certain people and use cases right now, and lots of people love them," Stark says. "We’re excited about the progress we’ve made with our new open source URL-display TrickURI tool and our exploratory new warnings on confusable URLs."

The Chrome security team has taken on internet-wide security issues before, developing fixes for them in Chrome and then throwing Google's weight around to motivate everyone to adopt the practice. The strategy has been particularly successful over the past five years in stimulating a [movement toward universal adoption](https://www.wired.com/2016/11/googles-chrome-hackers-flip-webs-security-model/) of HTTPS web encryption. But [critics of the approach](https://www.wired.com/story/google-chrome-https-not-secure-label/) fear the drawbacks of Chrome's power and ubiquity. The same influence that has been used for positive change could be misdirected or abused. And with something as foundational as URLs, critics fear that the Chrome team could land on website identity display tactics that are good for Chrome but don't actually benefit the rest of the web. Even seemingly minor changes to Chrome's privacy and security posture can have [major impacts](https://www.wired.com/story/google-chrome-login-privacy/) on the web community.

Additionally, a trade-off of that ubiquity is being beholden to risk-averse corporate customers. "URLs as they work now are often unable to convey a risk level users can quickly identify," says Katie Moussouris, founder of the responsible vulnerability disclosure firm Luta Security. "But as Chrome grows in enterprise adoption, rather than the consumer space, their ability to radically change visible interfaces and underlying security architecture will be reduced by the pressure of their customers. Great popularity comes not only with great responsibility to keep people safe, but to minimize churn in features, usability, and backwards compatibility."

If it all sounds like a lot of confusing and frustrating work, that's exactly the point. The next question will be how the Chrome team's new ideas perform in practice, and whether they really wind up making you safer on the web.

*_Correction January 29, 10:30pm: This story originally stated that TrickURI uses machine learning to parse URL samples and test warnings for suspicious URLs. It has been updated to reflect that the tool instead assesses whether software displays URLs accurately and consistently._

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
