
> * 原文地址：[Switching Your Site to HTTPS on a Shoestring Budget](https://css-tricks.com/switching-site-https-shoestring-budget/?utm_source=SitePoint&utm_medium=email&utm_campaign=Versioning)
> * 原文作者：[CHRISTOPHER SCHMITT](https://css-tricks.com/author/schmitt/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/switching-site-https-shoestring-budget.md](https://github.com/xitu/gold-miner/blob/master/TODO/switching-site-https-shoestring-budget.md)
> * 译者：
> * 校对者：

# Switching Your Site to HTTPS on a Shoestring Budget

Google's Search Console team recently sent out an email to site owners with a warning that Google Chrome will take steps starting this October to identify and show warnings on non-secure sites that have form inputs.

Here's the notice that landed in my inbox:

![The notice from the Google Search Console team regarding HTTPS support](https://res.cloudinary.com/css-tricks/image/upload/c_scale,w_610,f_auto,q_auto/v1504368007/https-google-letter_h3h2a7.jpg)

If your site URL does not support HTTPS, then this notice directly affects you. Even if your site does not have forms, moving over to HTTPS should be a priority, as this is only one step in Google's strategy to identify insecure sites. They state this clearly in their message:

> The new warning is part of a long term plan to mark all pages served over HTTP as "not secure".

![Current Chrome's UI for a site with HTTP support and a site with HTTPS](https://res.cloudinary.com/css-tricks/image/upload/c_scale,w_401,f_auto,q_auto/v1504414046/chrome-http-secure-ui-v2_g208mc.png)

The problem is that the process of installing SSL certificates and transitioning site URLs from HTTP to HTTPS—not to mention editing all those links and linked images in existing content—sounds like a daunting task. Who has time and wants to spend the money to update a personal website for this?

I use GitHub Pages to host a number sites and projects for free—including some that use custom domain names. To that end, I wanted to see if I could quickly and inexpensively convert a site from HTTP to HTTPS. I wound up finding a relatively simple solution on a shoestring budget that I hope will help others. Let's dig into that.

## Enforcing HTTPS on GitHub Pages

Sites hosted on GitHub Pages have a simple setting to enable HTTPS. Navigate to the project's Settings and flip the switch to enforce HTTPS.

![The GitHub Pages setting to enforce HTTPS on a project](https://res.cloudinary.com/css-tricks/image/upload/c_scale,w_789,f_auto,q_auto/v1504368069/https-github-pages_iekrru.png)

## But We Still Need SSL

Sure, that first step was a breeze, but it's not the full picture of what we need to do to meet Google's definition of a secure site. The reason is that enabling the HTTPS setting neither provides nor installs a Secure Sockets Layer (SSL) certificate to a site that uses a [custom domain](https://help.github.com/articles/using-a-custom-domain-with-github-pages/). Sites that use the default web address provided by GitHub Pages are fully secure with that setting, but those of us that use a custom domain have to go the extra step of securing SSL at the domain level.

That's a bummer because SSL, while not super expensive, is yet another cost and likely one you may not want to incur when you're trying to keep costs down. I wanted to find a way around this.

## We Can Get SSL From a CDN ... for Free!

This is where Cloudflare comes in. Cloudflare is a Content Delivery Network (CDN) that also provides distributed domain name server services. What that means is that we can leverage their network to set up HTTPS. The real kicker is that they have a free plan that makes this all possible.

It's worth noting that there are a [number of good posts](https://css-tricks.com/?s=cdn) here on CSS-Tricks that tout the benefits of a CDN. While we're focused on the security perks in this post, CDNs are an excellent way to help reduce server burden and [increase performance](https://css-tricks.com/adding-a-cdn-to-your-website/).

From here on out, I'm going to walk through the steps I used to connect Cloudflare to GitHub Pages so, if you haven't already, you can [snag a free account](https://www.cloudflare.com/a/sign-up) and follow along.

### Step 1: Select the "+ Add Site" option

First off, we have to tell Cloudflare that our domain exists. Cloudflare will scan the DNS records to verify both that the domain exists and that the public information about the domain are accessible.

![Cloudflare's "Add Website" Setting](https://res.cloudinary.com/css-tricks/image/upload/c_scale,w_992,f_auto,q_auto/v1504368119/https-cloudflare-add-website_m8cxbg.png)

### Step 2: Review the DNS records

After Cloudflare has scanned the DNS records, it will spit them out and display them for your review. Cloudflare indicates that it believes things are in good standing with an orange cloud in the Status column. Review the report and confirm that the records match those from your registrar. If all is good, click "Continue" to proceed.

![The DNS record report in Cloudflare](https://res.cloudinary.com/css-tricks/image/upload/c_scale,w_959,f_auto,q_auto/v1504368181/https-cloudflare-nameservers_yvfca2.png)

### Step 3: Get the Free Plan

Cloudflare will ask what level of service you want to use. Lo and behold! There is a free option that we can select.

![Cloudflare's free plan option](https://res.cloudinary.com/css-tricks/image/upload/c_scale,w_997,f_auto,q_auto/v1504368222/https-cloudflare-free-plan_oxgbp0.png)

### Step 4: Update the Nameservers

At this point, Cloudflare provides us with its server addresses and our job is to head over to the registrar where the domain was purchased and paste those addresses into the DNS settings.

![Cloudflare provides the nameservers for updated the registrar settings.](https://res.cloudinary.com/css-tricks/image/upload/c_scale,w_976,f_auto,q_auto/v1504368295/https-cloudflare-nameservers-2_yhr2up.jpg)

It's not incredibly difficult to do this, but can be a little unnerving. Your registrar likely has instructions for how to do this. For example, here are [GoDaddy's instructions]()https://www.godaddy.com/help/set-nameservers-for-domains-hosted-and-registered-with-godaddy-12316 for updating nameservers for domains registered through their service.

Once you have done this step, your domain will effectively be mapped to Cloudflare's servers, which will act as an intermediary between the domain and GitHub Pages. However, it is a bit of a waiting game and can take Cloudflare up to 24 hours to process the request.

**If you are using GitHub Pages with a subdomain** instead of a custom domain, there is one extra step you are required to do. Head over to your GitHub Pages settings and add a CNAME record in the DNS settings. Set it to point to `<your-username>.github.io`, where `<your-username>` is, of course, your GitHub account handle. Oh, and you will need to add a CNAME text file to the root of your GitHub project which is literally a text file named CNAME with your domain name in it.

Here is a screenshot with an example of adding a GitHub Pages subdomain as a CNAME record in Cloudflare's settings:

![Adding a GitHub Pages subdomain to Cloudflare](https://res.cloudinary.com/css-tricks/image/upload/c_scale,w_985,f_auto,q_auto/v1504368357/https-cloudflare-github-pages-subdomain_mtnvep.png)

### Step 5: Enable HTTPS in Cloudflare

Sure, we've technically already done this in GitHub Pages, but we're required to do it in Cloudflare as well. Cloudflare calls this feature "Crypto" and it not only forces HTTPS, but provides the SSL certificate we've been wanting all along. But we'll get to that in just a bit. For now, enable Crypto for HTTPS.

![The Crypto option in Cloudflare's main menu](https://res.cloudinary.com/css-tricks/image/upload/c_scale,w_581,f_auto,q_auto/v1504368403/https-cloudflare-crypto_y44ged.png)

Turn on the "Always use HTTPS" option:

![Enable HTTPS in the Cloudflare settings](https://res.cloudinary.com/css-tricks/image/upload/c_scale,w_954,f_auto,q_auto/v1504368456/https-cloudflare-enable_e5povd.png)

Now any HTTP request from a browser is switched over to the more secure HTTPS. We're another step closer to making Google Chrome happy.

### Step 6: Make Use of the CDN

Hey, we're using a CDN to get SSL, so we may as well take advantage of its performance benefits while we're at it. We can speed up performance by reducing files automatically and extend browser cache expiration.

Select the "Speed" option in the settings and allow Cloudflare to auto minify our site's web assets:

![Allow Cloudflare to minify the site's web assets](https://res.cloudinary.com/css-tricks/image/upload/c_scale,w_983,f_auto,q_auto/v1504368507/https-cloudflare-minify_dzk1a4.png)

We can also set the expiration on browser cache to maximize performance:

![Set the browser cache in Cloudflare's Speed settings](https://res.cloudinary.com/css-tricks/image/upload/c_scale,w_972,f_auto,q_auto/v1504368548/https-cloudflare-cache_diayym.png)

By moving the expiration out date a longer than the default option, the browser will refrain itself from asking for a site's resources with each and every visit—that is, resources that more than likely haven't been changed or updated. This will save visitors an extra download on repeat visits within a month's time.

### Step 7: Make External Resource Secure

If you use external resources on your site (and many of us do), then those need to be served securely as well. For example, if you use a Javascript framework and it is not served from an HTTP source, that blows our secure cover as far as Google Chrome is concerned and we need to patch that up.

If the external resource you use does not provide HTTPS as a source, then you might want to consider hosting it yourself. We have a CDN now that makes the burden of serving it a non-issue.

### Step 8: Activate SSL

Woot, here we are! SSL has been the missing link between our custom domain and GitHub Pages since we enabled HTTPS in the GitHub Pages setting and this is where we have the ability to activate a free SSL certificate on our site, courtesy of Cloudflare.

From the Crypto settings in Cloudflare, let's first make sure that the SSL certificate is active:

![Cloudflare shows an active SSL certificate in the Crypto settings](https://res.cloudinary.com/css-tricks/image/upload/c_scale,w_954,f_auto,q_auto/v1504368600/https-cloudlfare-ssl_nbbkyy.png)

If the certificate is active, move to "Page Rules" in the main menu and select the "Create Page Rule" option:

![Create a page rule in the Cloudflare settings](https://res.cloudinary.com/css-tricks/image/upload/c_scale,w_962,f_auto,q_auto/v1504368647/https-cloudflare-page-rule_hzmbvv.png)

...then click "Add a Setting" and select the "Always use HTTPS" option:

![Force HTTPS on that entire domain! Note the asterisks in the formatting, which is crucial.](https://res.cloudinary.com/css-tricks/image/upload/c_scale,w_797,f_auto,q_auto/v1504368689/https-cloudflare-force-https_vgouyf.png)

After that click "Save and Deploy" and celebrate! We now have a fully secure site in the eyes of Google Chrome and didn't have to touch a whole lot of code or drop a chunk of change to do it.

## In Conclusion

Google's push for HTTPS means front-end developers need to prioritize SSL support more than ever, whether it's for our own sites, company sites, or client sites. This move gives us one more incentive to make the move and the fact that we can pick up free SSL and performance enhancements through the use of a CDN makes it all the more worthwhile.

Have you written about your adventures moving to HTTPS? Let me know in the comments and we can compare notes. Meanwhile, enjoy a secure and speedy site!


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
