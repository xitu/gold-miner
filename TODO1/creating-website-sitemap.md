> * 原文地址：[5 Easy Steps to Creating a Sitemap For a Website](https://www.quicksprout.com/creating-website-sitemap/)
> * 原文作者：[quicksprout](https://www.quicksprout.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/creating-website-sitemap.md](https://github.com/xitu/gold-miner/blob/master/TODO1/creating-website-sitemap.md)
> * 译者：
> * 校对者：

# 5 Easy Steps to Creating a Sitemap For a Website

## Everything you need for creating and submitting a sitemap for your website

When it comes to getting your website ranked, you need to take advantage of as many SEO hacks as possible. Creating a sitemap is one technique that will definitely help [improve your SEO strategy](https://www.quicksprout.com/university/how-to-optimize-your-robots-txt-file/).

## What is a sitemap?

Some of you may be more familiar with this than others. I’ll give you a quick crash course on the basics of sitemaps before I show you how to build a website sitemap on your own.

Simply put, a sitemap, or XML sitemap, is a list of different pages on a website. XML is short for “extensible markup language,” which is a way to display information on a site.  
  
I’ve consulted with so many website owners who are intimidated by this concept because sitemaps are considered a technical component of SEO. But in all reality, you don’t need to be a tech wizard or have a tech background to create a sitemap. As you’ll learn shortly, it’s really not that difficult.

## Why do you need a sitemap?

Search engines like Google are committed to displaying the most relevant results to people for any given search query. In order do this effectively, they use site crawlers to read, organize, and index information on the Internet.

XML sitemaps make it easier for search engine crawlers to read the content on your site and index the pages accordingly. As a result, this increases your chances of [boosting the SEO ranking of your website](https://www.quicksprout.com/ways-to-improve-seo-ranking/).

Your sitemap will tell search engines the location of a page on your website, when it was updated, the updating frequency, and the importance of the page as it’s related to other pages on your site. Without a proper sitemap, Google bots might think that your site has duplicate content, which will actually hurt your SEO ranking.

If you’re ready for your website to get indexed faster by search engines, just follow these five easy steps to create a sitemap.

### Step 1: Review the structure of your pages

The first thing you need to do is look at the existing content on your website and see how everything is structured.

Look at a [sitemap template](https://nationalgriefawarenessday.com/48796/website-sitemap-template) and figure out how your pages would be displayed on the table.

![website sitemap template](https://quicksprout-wpengine.netdna-ssl.com/wp-content/uploads/2019/01/website-sitemap-template.png)

This is a very basic example that’s easy to follow.

It all starts from the homepage. Then you have to ask yourself where your homepage links to. You likely already have this figured out based on the menu options on your site.

But when it comes to SEO, not all pages are created equal. You have to keep the depth of your website in mind when you’re doing this. Recognize that the pages further away from your site’s homepage will be harder to rank for.

According to [Search Engine Journal](https://www.searchenginejournal.com/website-structure-affects-seo/186553/), you should aim to create a sitemap that has a shallow depth, meaning it only takes three clicks to navigate to any page on your website. That’s much better for SEO purposes.

So you need to create a hierarchy of pages based on importance and how you want them to be indexed. Prioritize your content into tiers that follow a logical hierarchy. Here’s [an example](https://blog.hubspot.com/marketing/build-sitemap-website) to show you what I’m talking about.

![page hierarchy](https://quicksprout-wpengine.netdna-ssl.com/wp-content/uploads/2019/01/page-hierarchy.png)

As you can see, the About page links to Our Team as well as Mission & Values. Then the Our Team page links to Management and Contact Us.

The [About Us page is the most important](https://www.quicksprout.com/how-to-create-about-page/), which is why it’s part of the top-level navigation. It wouldn’t make sense to have the management page be prioritized at the same level as Products, Pricing, and Blogs, which is why it falls under third-level content.

Similarly, if the Basic pricing package was positioned above the Compare Packages page, it would throw the logical structure out of whack.

So use these visual sitemap templates to determine the organization of your pages. Some of you may already have a structure that makes sense but just needs some slight tweaking.

Remember, you want to try to set it up so every page can be reached in three clicks.

### Step 2: Code your URLs

Now that you’ve gone through and identified the importance of each page and matched that importance in your site structure, it’s time to code those URLs.

The way to do this is by formatting each URL with XML tags. If you have any experience with HTML coding, this will be a breeze for you. As I said earlier, the “ML” in XML stands for markup language, which is the same for HTML.

Even if this is new to you, it’s not that tough to figure it out. Start by getting a text editor where you can create an XML file.

[Sublime Text](https://www.sublimetext.com/) is a great option for you to consider.

![sublime text editor](https://quicksprout-wpengine.netdna-ssl.com/wp-content/uploads/2019/01/sublime-text-editor.png)

Then add the corresponding code for each URL.

* location
* last changed
* changed frequency
* priority of page

Here are some examples of how the code will look for each one.

* http://www.examplesite.com/page1
* 2019-1-10
* weekly
* 2

Take your time and make sure you go through this properly. The text editor makes your life much easier when it comes to adding this code, but it still requires you to be sharp.

### Step 3: Validate the code

Any time you code manually, human error is possible. But, for your sitemap to function properly, you can’t have any mistakes in the coding.

Fortunately, there are tools that will help validate your code to ensure the syntax is correct. There’s software available online that can help you do this. Just run a quick Google search for sitemap validation, and you’ll find something.

I like to use the [XML Sitemap Validator tool](https://www.xml-sitemaps.com/validate-xml-sitemap.html).

![xml sitemap generator](https://quicksprout-wpengine.netdna-ssl.com/wp-content/uploads/2019/01/xml-sitemap-generator.png)

This will point out any errors in your code.

For example, if you forget to add an end tag or something like that, it can quickly be identified and fixed.

### Step 4: Add your sitemap to the root and robots.txt

Locate the root folder of your website and add the sitemap file to this folder.

Doing this will actually add the page to your site as well. This is not a problem at all. As a matter of fact, lots of websites have this. Just type in a website and add “/sitemap/” to the URL and see what pops up.

Here’s an example from the [Apple](https://www.apple.com/sitemap/) website.

![apple sitemap](https://quicksprout-wpengine.netdna-ssl.com/wp-content/uploads/2019/01/apple-sitemap.png)

Notice the structure and logical hierarchy of each section. This relates back to what we discussed in the first step.

Now, this can be taken one step further. You can even look at the code on different websites by adding “/sitemap.xml” to the URL.

Here’s what that looks like on the [HubSpot](https://www.hubspot.com/sitemap.xml) website.

![hubspot sitemap](https://quicksprout-wpengine.netdna-ssl.com/wp-content/uploads/2019/01/hubspot-sitemap.png)

In addition to adding the sitemap file to your root folder, you’ll also want to add it to the robots.txt file. You’ll find this in the roots folder as well.

Basically, this to give instructions for any crawlers indexing your website.

There are a couple of different uses for the robots.txt folder. You can set this up to show search engines URLs that you don’t want them to index when they’re crawling on your site.

Let’s go back to Apple and see what their [robots.txt page](https://www.apple.com/robots.txt) looks like.

![robots.txt](https://quicksprout-wpengine.netdna-ssl.com/wp-content/uploads/2019/01/robots-txt.png)

As you can see, they have “disallow” for several pages on their site. So crawlers ignore these.

![apple sitemap files](https://quicksprout-wpengine.netdna-ssl.com/wp-content/uploads/2019/01/apple-sitemap-files.png)

However, Apple also includes their sitemap files on here as well.

Not everyone you ask will tell you to add your sitemaps to the robots.txt file. So I’ll let you decide that for yourself.

With that said, I’m definitely a firm believer in following the best practices of successful websites and businesses. If a giant like Apple uses this, it can’t be too bad of an idea for you to consider.

### Step 5: Submit your sitemap

Now that your sitemap has been created and added to your site files, it’s time to submit them to search engines.

In order to do this, you need to go through [Google Search Console](https://search.google.com/search-console/about). Some of you may already have this set up. If not, you can get started very easily.

Once you’re on the search console dashboard, navigate to Crawl > Sitemaps.

![Google search console](https://quicksprout-wpengine.netdna-ssl.com/wp-content/uploads/2019/01/google-search-console.png)

Next, click on Add/Test Sitemap on the top right corner of the screen.

This is a chance for you to test your sitemap again for any errors before you continue. Obviously, you’ll want to fix any mistakes found. Once your sitemap is free of errors, click submit and that’s it. Google will handle everything else from here. Now crawlers will index your site with ease, which will boost your SEO ranking.

## Alternative options

While these five steps are pretty simple and straightforward, some of you might be a little uncomfortable manually changing the code on your website. That’s perfectly understandable. Fortunately for you, there are plenty of other solutions that can create a sitemap for you, without having to edit the code yourself.

I’ll go through some of the top options for you to consider.

### Yoast plugin

If you have a WordPress website, you can install the [Yoast plugin](https://kb.yoast.com/kb/enable-xml-sitemaps-in-the-wordpress-seo-plugin/) to create a sitemap for your website.

Yoast gives you the option to turn your sitemap on and off with a simple toggle switch. You can find all of your XML sitemap options from the SEO tab via WordPress once the plugin has been installed.

### Screaming Frog

[Screaming Frog](https://www.screamingfrog.co.uk/xml-sitemap-generator/) is desktop software that offers a wide range of SEO tools. It’s free to use and generate a sitemap as long as the website has fewer than 500 pages. For those of you with larger websites, you’ll need to upgrade the paid version.

Screaming Frog allows you to make all of the coding changes that we talked about earlier, but without actually changing the code yourself. Instead, you follow a prompt that’s much more user-friendly, and written in plain English. Then the code for the sitemap file will be changed automatically. Here’s a screenshot to show you what I mean.

![screaming frog configuration](https://quicksprout-wpengine.netdna-ssl.com/wp-content/uploads/2019/01/screaming-frog-configuration.png)

Just navigate through the tabs, change your settings, and the sitemap file will be adjusted accordingly.

### Slickplan

I really like Slickplan because of the visual sitemap builder feature. You’ll have the opportunity to use a sitemap template, similar to the ones we looked at earlier.

From here, you can drag and drop different pages into the template to organize the structure of your website. Once you’re done, and you’re happy with the way your visual sitemap looks, you can export it as an XML file.

Slickplan is paid software, but they offer a free trial. It’s at least worth trying if you’re on the fence about purchasing a plan.

## Conclusion

If you’re ready to take your SEO strategy to the next level, you need to create a sitemap for your website.

There is no reason to be intimidated by this anymore. As you can see from this guide, it’s easy to create a sitemap in just five steps.

1. Review your pages
2. Code the URLs
3. Validate your code
4. Add the sitemap to the root and robots.txt
5. Submit the sitemap

That’s it!

For those of you who are still on the fence about manually changing code on your website, there are other options for you to consider. The Internet is full of sitemap resources, but the Yoast plugin, Screaming Frog, and Slickplan are all great choices to start.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
