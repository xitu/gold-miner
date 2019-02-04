> * 原文地址：[Google Search Operators: The Complete List (42 Advanced Operators)](https://ahrefs.com/blog/google-advanced-search-operators/)
> * 原文作者：[Joshua Hardwick](https://ahrefs.com/blog/author/joshua-hardwick/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/google-advanced-search-operators.md](https://github.com/xitu/gold-miner/blob/master/TODO1/google-advanced-search-operators.md)
> * 译者：
> * 校对者：

# Google Search Operators: The Complete List (42 Advanced Operators)

For anyone that’s been doing SEO for a while, Google advanced search operators—i.e., special commands that make regular ol’ searches seem laughably basic in comparison—are nothing new.

Here’s a Google search operator you may be familiar with.

![ahrefs site search](https://ahrefs.com/blog/wp-content/uploads/2018/05/ahrefs-site-search.gif)

the “site:” operator restricts results to only those from a specified site.

It’s easy to remember most search operators. They’re short commands that stick in the mind.

But knowing how to use them effectively is an altogether different story.

Most SEOs know the basics, but few have truly mastered them.

In this post, I’ll share 15 actionable tips to help you master search operators for SEO, which are:

1.  [Find indexation errors](#find-indexation-errors)
2.  [Find non‐secure pages (non‐https)](#find-non-secure-pages)
3.  [Find duplicate content issues](#find-duplicate-content)
4.  [Find unwanted files and pages on your site](#find-odd-files)
5.  [Find guest post opportunities](#find-guest-posts)
6.  [Find resource page opportunities](#find-resource-pages)
7.  [Find sites that feature infographics… so you can pitch YOURS](#find-infographic-sites)
8.  [Find more link prospects… AND check how relevant they are](#find-link-prospects)
9.  [Find social profiles for outreach prospects](#find-social-profiles)
10.  [Find internal linking opportunities](#find-internal-links)
11.  [Find PR opportunities by finding competitor mentions](#find-pr-opportunities)
12.  [Find sponsored post opportunities](#find-sponsored-posts)
13.  [Find Q+A threads related to your content](#find-qa-threads)
14.  [Find how often your competitors are publishing new content](#find-new-competitor-content)
15.  [Find sites linking to competitors](#find-competitor-links)

But first, here’s a complete list of all Google search operators and their functionality.

## Google Search Operators: The Complete List

Did you know that Google is constantly [killing useful operators](https://searchengineland.com/google-drops-another-search-operator-tilde-for-synonyms-164403)?

That’s why most existing lists of Google search operators are outdated and inaccurate.

For this post, I personally tested EVERY search operator I could find.

Here is a complete list of all working, non‐working, and “hit and miss” Google advanced search operators as of 2018.

![](https://ahrefs.com/blog/wp-content/uploads/2018/05/working-operators.png)

### “search term”

Force an exact‐match search. Use this to refine results for ambiguous searches, or to exclude synonyms when searching for single words.

**Example**: [“steve jobs”](https://www.google.com/search?&q=%22steve+jobs%22)

### OR

Search for X _or_ Y. This will return results related to X or Y, or both. **Note:** The pipe (|) operator can also be used in place of “OR.”

**Examples: [jobs OR gates](https://www.google.com/search?&q=jobs+OR+gates) / [jobs | gates](https://www.google.com/search?&q=jobs+%7C+gates)**

### AND

Search for X _and_ Y. This will return only results related to both X _and_ Y. **Note**: It doesn’t really make much difference for regular searches, as Google defaults to “AND” anyway. But it’s very useful when paired with other operators.

**Examples: [jobs AND gates](https://www.google.com/search?&q=jobs+AND+gates)**

### -

Exclude a term or phrase. In our example, any pages returned will be related to jobs but _not_ Apple (the company).

**Examples: [jobs -apple](https://www.google.com/search?q=jobs+-apple)**

### *

Acts as a wildcard and will match any word or phrase.

**Examples: [steve * apple](https://www.google.com/search?q=%22steve+*+apple)**

### ( )

Group multiple terms or search operators to control how the search is executed.

**Examples: [(ipad OR iphone) apple](https://www.google.com/search?q=%28ipad+OR+iphone%29+apple)**

### $

Search for prices. Also works for Euro (€), but not GBP (£) 🙁

**Examples: [ipad $329](https://www.google.com/search?q=ipad+%24329)**

### define:

A dictionary built into Google, basically. This will display the meaning of a word in a card‐like result in the SERPs.

**Examples: [define:entrepreneur](https://www.google.com/search?q=define%3Aentrepreneur)**

### cache:

Returns the most recent cached version of a web page (providing the page is indexed, of course).

**Examples: [cache:apple.com](http://webcache.googleusercontent.com/search?q=cache%3Aapple.com)**

### filetype:

Restrict results to those of a certain filetype. E.g., PDF, DOCX, TXT, PPT, etc. **Note:** The “ext:” operator can also be used—the results are identical.

**Examples: [apple filetype:pdf](https://www.google.com/search?q=apple+filetype%3Apdf) / [apple ext:pdf](https://www.google.com/search?q=apple+ext%3Apdf)**

### site:

Limit results to those from a specific website.

**Examples: [site:apple.com](https://www.google.com/search?q=site%3Aapple.com)**

### related:

Find sites related to a given domain.

**Examples: [related:apple.com](https://www.google.com/search?q=related%3Aapple.com)**

### intitle:

Find pages with a certain word (or words) in the title. In our example, any results containing the word “apple” in the title tag will be returned.

**Examples: [intitle:apple](https://www.google.com/search?q=intitle%3Aapple)**

### allintitle:

Similar to “intitle,” but only results containing _all_ of the specified words in the title tag will be returned.

**Examples: [allintitle:apple iphone](https://www.google.com/search?q=allintitle%3Aapple+iphone)**

### inurl:

Find pages with a certain word (or words) in the URL. For this example, any results containing the word “apple” in the URL will be returned.

**Examples: [inurl:apple](https://www.google.com/search?q=inurl%3Aapple)**

### allinurl:

Similar to “inurl,” but only results containing _all_ of the specified words in the URL will be returned.

**Examples: [allinurl:apple iphone](https://www.google.com/search?q=allinurl%3Aapple+iphone)**

### intext:

Find pages containing a certain word (or words) somewhere in the content. For this example, any results containing the word “apple” in the page content will be returned.

**Examples: [intext:apple](https://www.google.com/search?q=intext%3Aapple)**

### allintext:

Similar to “intext,” but only results containing _all_ of the specified words somewhere on the page will be returned.

**Examples: [allintext:apple iphone](https://www.google.com/search?q=allintext%3Aapple+iphone)**

### AROUND(X)

Proximity search. Find pages containing two words or phrases within X words of each other. For this example, the words “apple” and “iphone” must be present in the content and no further than four words apart.

**Examples: [apple AROUND(4) iphone](https://www.google.com/search?q=apple+AROUND(4))**

### weather:

Find the weather for a specific location. This is displayed in a weather snippet, but it also returns results from other “weather” websites.

**Examples: [weather:san francisco](https://www.google.com/search?q=weather%3Asan+francisco)**

### stocks:

See stock information (i.e., price, etc.) for a specific ticker.

**Examples: [stocks:aapl](https://www.google.com/search?q=stocks%3Aaapl)**

### map:

Force Google to show map results for a locational search.

**Examples: [map:silicon valley](https://www.google.com/search?q=map%3Asilicon+valley)**

### movie:

Find information about a specific movie. Also finds movie showtimes if the movie is currently showing near you.

**Examples: [movie:steve jobs](https://www.google.com/search?q=movie%3Asteve+jobs)**

### in

Convert one unit to another. Works with currencies, weights, temperatures, etc.

**Examples: [$329 in GBP](https://www.google.com/search?q=%24329+in+GBP)**

### source:

Find news results from a certain source in Google News.

**Examples: [apple source:the_verge](https://www.google.com/search?q=apple+source%3Athe_verge&tbm=nws)**

### _

Not exactly a search operator, but acts as a wildcard for Google Autocomplete.

**Example: apple CEO _ jobs**

![](https://ahrefs.com/blog/wp-content/uploads/2018/05/hit-and-miss-operators.png)

Here are the ones that are hit and miss, according to my testing:

### #..#

Search for a range of numbers. In the example below, searches related to “WWDC videos” are returned for the years 2010–2014, but not for 2015 and beyond.

**Examples: [wwdc video 2010..2014](https://www.google.com/search?q=wwdc+video+2010..2014)**

### inanchor:

Find pages that are being linked to with specific anchor text. For this example, any results with inbound links containing either “apple” or “iphone” in the anchor text will be returned.

**Examples: [inanchor:apple iphone](https://www.google.com/search?q=inanchor%3Aapple+iphone)**

### allinanchor:

Similar to “inanchor,” but only results containing _all_ of the specified words in the inbound anchor text will be returned.

**Examples: [allinanchor:apple iphone](https://www.google.com/search?q=allinanchor%3Aapple+iphone)**

### blogurl:

Find blog URLs under a specific domain. This was used in Google blog search, but I’ve found it does return some results in regular search.

**Examples: [blogurl:microsoft.com](https://www.google.com/search?q=blogurl%3Amicrosoft.com)**

Sidenote.

Google blog search discontinued in 2011

### loc:placename

Find results from a given area.

**Examples: [loc:”san francisco” apple](https://www.google.com/search?q=loc%3A%22san+francisco%22+apple)**

Sidenote.

Not officially deprecated, but results are inconsistent.

### location:

Find news from a certain location in Google News.

**Examples: [loc:”san francisco” apple](https://www.google.com/search?q=loc%3A%22san+francisco%22+apple)**

Sidenote.

Not officially deprecated, but results are inconsistent.

![](https://ahrefs.com/blog/wp-content/uploads/2018/05/not-working-operators.png)

Here are the Google search operators that have been discontinued and no longer work. 🙁

### +

Force an exact‐match search on a single word or phrase.

**Examples: [jobs +apple](https://www.google.com/search?q=jobs+%2Bapple)**

Sidenote.

You can do the same thing by using double quotes around your search.

### ~

Include synonyms. Doesn’t work, because Google now includes synonyms by default. _(Hint: Use double quotes to exclude synonyms.)_

**Examples: [~apple](https://www.google.com/search?q=~apple)**

### inpostauthor:

Find blog posts written by a specific author. This only worked in Google Blog search, not regular Google search.

**Example: inpostauthor:”steve jobs”**

Sidenote.

Google blog search was discontinued in 2011.

### allinpostauthor:

Similar to “inpostauthor,” but removes the need for quotes (if you want to search for a specific author, including surname.)

**Example: allinpostauthor:steve jobs**

### inposttitle:

Find blog posts with specific words in the title. No longer works, as this operator was unique to the discontinued Google blog search.

**Example: intitle:apple iphone**

### link:

Find pages linking to a specific domain or URL. Google killed this operator in 2017, but it does still show some results—they likely aren’t particularly accurate though. _([Deprecated in 2017](https://searchengineland.com/google-officially-killed-off-link-command-267454))_

**Examples: [link:apple.com](https://www.google.com/search?q=link%3Aapple.com)**

### info:

Find information about a specific page, including the most recent cache, similar pages, etc. _([Deprecated in 2017](https://searchengineland.com/google-changes-info-command-search-operator-dropping-useful-links-286422))_. **Note:** The `id:` operator can also be used—the results are identical.

Sidenote.

Although the original functionality of this operator is deprecated, it is still useful for finding the canonical, indexed version of a URL. Thanks to [@glenngabe](https://twitter.com/glenngabe) for pointing this one one!

**Examples: [info:apple.com](https://www.google.com/search?q=info%3Aapple.com) / [id:apple.com](https://www.google.com/search?q=id%3Aapple.com)**

### daterange:

Find results from a certain date range. Uses the [Julian date format](http://www.longpelaexpertise.com/toolsJulian.php), for some reason.

**Examples: [daterange:11278–13278](https://www.google.com/search?q=steve+jobs+daterange%3A11278-13278)**

Sidenote.

Not officially deprecated, but doesn’t seem to work.

### phonebook:

Find someone’s phone number. _([Deprecated in 2010](https://searchengineland.com/google-drops-phonebook-search-operator-56173))_

**Examples: [phonebook:tim cook](https://www.google.com/search?q=phonebook%3Atim+cook)**

### #

Searches #hashtags. Introduced for Google+; now deprecated.

**Examples: [#apple](https://www.google.com/search?q=%23apple)**

## 15 Actionable Ways to Use Google Search Operators

Now let’s tackle a few ways to put these operators into action.

My aim here is to show that you can achieve almost anything with Google advanced operators if you know how to use and combine them efficiently.

So don’t be afraid to play around and deviate from the examples below. You might just discover something new.

Bored of reading?

Check out 9 actionable Google search operator tips in Sam Oh’s [video](https://www.youtube.com/watch?v=yWLD9139Ipc).

[https://www.youtube.com/watch?v=yWLD9139Ipc](https://www.youtube.com/watch?v=yWLD9139Ipc)

Let’s go!

### 1. Find indexation errors

Google indexation errors exist for most sites.

It could be that a page that should be indexed, isn’t. Or vice‐versa.

Let’s use the `site:` operator to see how many pages Google has indexed for _ahrefs.com_.

![ahrefs site operator index](https://ahrefs.com/blog/wp-content/uploads/2018/05/ahrefs-site-operator-index.jpg)

~1,040.

Sidenote.

Google only gives [a rough approximation](https://searchengineland.com/what-you-can-learn-from-googles-site-operator-14052) when using this operator. For the full picture, check [Google Search Console](https://www.google.com/webmasters/tools/home?hl=en).

But how many of these pages are blog posts?

Let’s find out.

![ahrefs blog posts index](https://ahrefs.com/blog/wp-content/uploads/2018/05/ahrefs-blog-posts-index.jpg)

~249. That’s roughly ¼.

I know Ahrefs blog inside out, so I know this is higher than the number of posts we have.

Let’s investigate further.

![ahrefs blog weird indexation](https://ahrefs.com/blog/wp-content/uploads/2018/05/ahrefs-blog-weird-indexation.jpg)

OK, so it seems that a few odd pages are being indexed.

_(This page isn’t even live—it’s a 404)_

Such pages should be removed from the SERPs by [noindexing them](https://support.google.com/webmasters/answer/93710?hl=en).

Let’s also narrow the search to subdomains and see what we find.

![ahrefs index subdomains](https://ahrefs.com/blog/wp-content/uploads/2018/05/ahrefs-index-subdomains.jpg)

Sidenote.

Here, we’re using the wildcard (*) operator to find all subdomains belonging to the domain, combined with the exclusion operator (-) to exclude regular www results.

~731 results.

Here’s a page residing on a subdomain that _definitely_ shouldn’t be indexed. It gives a 404 error for a start.

![ahrefs indexation error](https://ahrefs.com/blog/wp-content/uploads/2018/05/ahrefs-indexation-error.jpg)

Here are a few other ways to uncover indexation errors with Google operators:

*   `site:yourblog.com/category` — find WordPress blog category pages;
*   `site:yourblog.com inurl:tag` — find WordPress “tag” pages.

### 2. Find non‐secure pages (non‐https)

HTTPs is a _must_ these days, especially for [ecommerce sites](https://ahrefs.com/blog/ecommerce-seo/).

But did you know that you can find unsecure pages with the `site:` operator?

Let’s try it for _asos.com_.

![asos unsecure 1](https://ahrefs.com/blog/wp-content/uploads/2018/05/asos-unsecure-1.jpg)

Oh my, ~2.47M unsecure pages.

It looks like ASAS don’t currently use SSL—unbelievable for such a large site.

![asos unsecure](https://ahrefs.com/blog/wp-content/uploads/2018/05/asos-unsecure.jpg)

Sidenote.

Don’t worry, Asos customers—their checkout pages are secure 🙂

But here’s another crazy thing:

ASOS is accessible at both the _https_ and _http_ versions.

![asos http https](https://ahrefs.com/blog/wp-content/uploads/2018/05/asos-http-https.gif)

And we learned all that from a simple `site:` search!

Sidenote.

I’ve noticed that sometimes, when using this tactic, pages will be indexed without the https. But when you click‐through, you will be directed to the https version. So don’t assume that your pages are unsecure just because they appear as such in Google’s index. Always click a few of them to double‐check.

Further reading

*   [We Analyzed the HTTPS Settings of 10,000 Domains and How It Affects Their SEO — Here’s What We Learned](https://ahrefs.com/blog/ssl/)
*   [HTTP vs. HTTPS for SEO: What You Need to Know to Stay in Google’s Good Graces](https://ahrefs.com/blog/http-vs-https-for-seo/)

### 3. Find duplicate content issues

Duplicate content = bad.

Here’s [a pair of Abercrombie and Fitch jeans from ASOS](http://www.asos.com/abercrombie-fitch/abercrombie-fitch-slim-fit-jeans-in-destroyed-black-wash/prd/8459420?clr=black&SearchQuery=&cid=4208&gridcolumn=1&gridrow=1&gridsize=4&pge=1&pgesize=72&totalstyles=1) with this brand description:

![asos abercrombie and fitch](https://ahrefs.com/blog/wp-content/uploads/2018/05/asos-abercrombie-and-fitch.jpg)

With third‐party brand descriptions like this, they’re often duplicated on other sites.

But first, I’m wondering how many times this copy appears on _asos.com_.

![abercrombie and fitch ahrefs duplicate same domain](https://ahrefs.com/blog/wp-content/uploads/2018/05/abercrombie-and-fitch-ahrefs-duplicate-same-domain.jpg)

~4.2K.

Now I’m wondering if this copy is even unique to ASOS.

Let’s check.

![abercrombie and fitch asos duplicate](https://ahrefs.com/blog/wp-content/uploads/2018/05/abercrombie-and-fitch-asos-duplicate.jpg)

No, it isn’t.

That’s 15 other sites with this exact same copy—i.e., duplicate content.

Sometimes duplicate content issues can arise from similar product pages, too.

For example, similar or identical products with different quantity counts.

Here’s an example from ASOS:

![asos socks quantities duplicate](https://ahrefs.com/blog/wp-content/uploads/2018/05/asos-socks-quantities-duplicate.gif)

You can see that—quantities aside—all of these product pages are the same.

But duplicate content isn’t only a problem for ecommerce sites.

If you have a blog, then people could be stealing and republishing your content without attribution.

Let’s see if anyone has stolen and republished [our list of SEO tips](https://ahrefs.com/blog/seo-tips/).

![seo tips stolen content](https://ahrefs.com/blog/wp-content/uploads/2018/05/seo-tips-stolen-content.jpg)

~17 results.

Sidenote.

You’ll notice that I excluded _ahrefs.com_ from the results using the exclusion (-) operator—this ensures that the original doesn’t appear in the search results. I also excluded the word “pinterest.” This was because I saw a lot of Pinterest results for this search, which aren’t really relevant to what we’re looking for. I could have excluded just pinterest.com (-pinterest.com), but as Pinterest has many ccTLDs, this didn’t really help things. Excluding the word “pinterest” was the best way to clean up the results.

Most of these are _probably_ syndicated content.

Still, it’s worth checking these out to make sure that they do link back to you.

Find stolen content in seconds

_[Content Explorer](https://ahrefs.com/content-explorer) \> In title > enter the title of your page/post > exclude your own site_

![content explorer syndication search](https://ahrefs.com/blog/wp-content/uploads/2018/05/content-explorer-syndication-search.jpg)

You will then see any pages (from our database of 900M\+ pieces of content) with the same title as your page/post.

In this instance, there are 5 results.

![5 results content explorer](https://ahrefs.com/blog/wp-content/uploads/2018/05/5-results-content-explorer.jpg)

Next, enter your domain under “Highlight unlinked domains.”

This will highlight any sites that don’t link back to you.

![highlight unlinked domains](https://ahrefs.com/blog/wp-content/uploads/2018/05/highlight-unlinked-domains.gif)

You can then reach out to those sites and request the addition of a source link.

FYI, this filter actually looks for links on a domain‐level rather than a page‐level. It is, therefore, possible that the site could be linking to you from another page, rather than the page in question.

### 4. Find odd files on your domain (that you may have forgotten about)

Keeping track of everything on your website can be difficult.

_(This is especially true for big sites.)_

For this reason, it’s easy to forget about old files you may have uploaded.

PDF files; Word documents; Powerpoint presentations; text files; etc.

Let’s use the `filetype:` operator to check for these on _ahrefs.com_.

![filetype operator pdf](https://ahrefs.com/blog/wp-content/uploads/2018/05/filetype-operator-pdf.jpg)

Sidenote.

Remember, you can also use the `ext:` operator—it does the same thing.

Here’s one of those files:

![ahrefs pdf file in index](https://ahrefs.com/blog/wp-content/uploads/2018/05/ahrefs-pdf-file-in-index.jpg)

I’ve never seen that piece of content before. Have you?

But we can extend this further than just PDF files.

By combining a few operators, it’s possible to return results for all supported file types at once.

![filetype operator all types](https://ahrefs.com/blog/wp-content/uploads/2018/05/filetype-operator-all-types.jpg)

Sidenote.

The filetype operator does also support things like _.asp_, _.php_, _.html_, etc.

It’s important to delete or noindex these if you’d prefer people didn’t come across them.

### 5. Find guest post opportunities

Guest post opportunities… there are TONS of ways to find them, such as:

![guest post operator write for us](https://ahrefs.com/blog/wp-content/uploads/2018/05/guest-post-operator-write-for-us.jpg)

But you already knew about that method, right!? 😉

Sidenote.

For those who haven’t seen this one before, it uncovers so‐called “write for us” pages in your niche—the pages many sites create when they’re actively seeking guest contributions.

So let’s get more creative.

First off: don’t limit yourself to “write for us.”

You can also use:

*   `“become a contributor"`
*   `“contribute to”`
*   `“write for me”` (yep—there are solo bloggers seeking guest posts, too!)
*   `“guest post guidelines”`
*   `inurl:guest-post`
*   `inurl:guest-contributor-guidelines`
*   etc.

But here’s a cool tip most people miss:

You can search for many of these at once.

![guest post multi search operator](https://ahrefs.com/blog/wp-content/uploads/2018/05/guest-post-multi-search-operator.jpg)

Sidenote.

Did you notice I’m using the pipe (“|”) operator instead of “OR” this time? Remember, it does the same thing. 🙂

You can even search for multiple footprints AND multiple keywords.

![guestpost operator multiple footprints and keywords](https://ahrefs.com/blog/wp-content/uploads/2018/05/guestpost-operator-multiple-footprints-and-keywords.jpg)

Looking for opportunities in a specific country?

Just add a `site:.tld` operator.

![guest post operators cctld](https://ahrefs.com/blog/wp-content/uploads/2018/05/guest-post-operators-cctld.jpg)

Here’s another method:

If you know of a serial guest blogger in your niche, try this:

![ryan stewart intext inurl author](https://ahrefs.com/blog/wp-content/uploads/2018/05/ryan-stewart-intext-inurl-author.jpg)

This will find every site that person has written for.

Sidenote.

Don’t forget to exclude their site to keep the results clean!

How to find even more author guest posts

_[Content Explorer](https://ahrefs.com/content-explorer) \> author search > exclude their site(s)_

For this example, let’s use our very own [Tim Soulo](https://ahrefs.com/tim).

![guest post author content explorer](https://ahrefs.com/blog/wp-content/uploads/2018/05/guest-post-author-content-explorer.jpg)

BOOM. 17 results. All of which are _probably_ guest posts.

For reference, here’s the exact search I entered into Content Explorer:

`author:”tim soulo” -site:ahrefs.com -site:bloggerjet.com`

Basically, this searches for posts by Tim Soulo. But it also excludes posts from ahrefs.com and bloggerjet.com (Tim’s personal blog).

**Note.** Sometimes you will find a few false positives in there. It depends on how common the persons name happens to be.

But don’t stop there:

You can also use Content Explorer to find sites in your niche that have never linked to you.

_Content Explorer > enter a topic > one article per domain > highlight unlinked domains_

Here’s one of the unlinked domains I found for ahrefs.com:

![unlinked domains](https://ahrefs.com/blog/wp-content/uploads/2018/05/unlinked-domains.png)

This means _marketingprofs.com_ has never linked to us.

Now, this search doesn’t tell us whether or not they have a “write for us” page. But it doesn’t really matter. The truth is that most sites are usually happy to accept guest posts if you can offer them “quality” content. It would, therefore, definitely be worth reaching out and “pitching” such sites.

Another benefit of using [Content Explorer](https://ahrefs.com/content-explorer) is that you can see stats for each page, including:

*   # of RDs;
*   DR;
*   Organic traffic estimation;
*   Social shares;
*   Etc.

You can also export the results easily. 🙂

Finally, if you’re wondering whether a specific site accepts guest posts or not, try this:

![specific site guest contribution](https://ahrefs.com/blog/wp-content/uploads/2018/05/specific-site-guest-contribution.jpg)

Sidenote.

You could add even more searches—e.g., “this is a guest article”—to the list of searches included within the parentheses. I kept this simple for demonstration purposes.

### 6. Find resource page opportunities

“Resource” pages round‐up the best resources on a topic.

Here’s what a so‐called “resource” page looks like:

![](https://ahrefs.com/blog/wp-content/uploads/2018/05/broken-link-building.gif)

All of those links you see = links to resources on other sites.

_(Ironically—given the subject nature of that particular page—a lot of those links are broken)_

Further reading

*   [A Simple (But Complete) Guide to Broken Link Building](https://ahrefs.com/blog/broken-link-building/)
*   [How to Find and Fix Broken Links (to Reclaim Valuable “Link Juice”)](https://ahrefs.com/blog/fix-broken-links/)

So if you have a cool resource on your site, you can:

1.  find relevant “resource” pages;
2.  pitch your resource for inclusion

Here’s one way to find them:

![fitness resources operator](https://ahrefs.com/blog/wp-content/uploads/2018/05/fitness-resources-operator.jpg)

But that can return a lot of junk.

Here’s a cool way to narrow it down:

![fitness resources url title operator](https://ahrefs.com/blog/wp-content/uploads/2018/05/fitness-resources-url-title-operator.jpg)

Or narrow it down even further with:

![intitle fitness numbers resources operator](https://ahrefs.com/blog/wp-content/uploads/2018/05/intitle-fitness-numbers-resources-operator.jpg)

Sidenote.

Using `allintitle:` here ensures that the title tag contains the words “fitness” AND “resources,” and also a number between 5–15.

a note about the #..# operator

I know what you’re thinking:

Why not use the `#..#` operator instead of that long sequence of numbers.

Good point!

Let’s try it:

![fail operator](https://ahrefs.com/blog/wp-content/uploads/2018/05/fail-operator.gif)

Confused? Here’s the deal:

This operator doesn’t play nicely with most other operators.

Nor does it seem to work a lot of the time anyway—it’s definitely hit and miss.

So I recommend using a sequence of numbers separated by “OR” or the pipe (“|”) operator.

It’s a bit of a hassle, but it works.

### 7. Find sites that feature infographics… so you can pitch YOURS

Infographics get a bad rap.

Most likely, this is because a lot of people create low‐quality, cheap infographics that serve no real purpose… other than to “attract links.”

But infographics aren’t always bad.

Here’s the general strategy for infographics:

1.  create infographic
2.  **pitch infographic**
3.  get featured, get link (and PR!)

But who should you pitch your infographic to?

Just any old sites in your niche?

**NO.**

You should pitch to sites that are _actually_ likely to want to feature your infographic.

The best way to do this is to find sites that have featured infographics before.

Here’s how:

![fitness infographic operator](https://ahrefs.com/blog/wp-content/uploads/2018/05/fitness-infographic-operator.jpg)

Sidenote.

It can also be worth searching within a recent date range—e.g., the past 3 months. If a site featured an infographic two years ago, that doesn’t necessarily mean they still care about infographics. Whereas if a site featured an infographic in the past few months, chances are they still regularly feature them. But as the “daterange:” operator no longer seems to work, you’ll have to do this using the in‐built filter in Google search.

But again, this can kick back some serious junk.

So here’s a quick trick:

1.  use the above search to find a good, relevant infographic (i.e., well‐designed, etc.)
2.  search for that specific infographic

Here’s an example:

![reddit guide to fitness infographic](https://ahrefs.com/blog/wp-content/uploads/2018/05/reddit-guide-to-fitness-infographic.jpg)

This found ~2 results from the last 3 months. And 450+ all‐time results.

Do this for a handful of infographics and you’ll have a good list of prospects.

Not getting great results from Google? Try this.

Have you ever noticed that when an infographic is embedded on a site, the site owner will usually include the word “infographic” in square brackets in the title tag?

**Example:**

![infographic title tag](https://ahrefs.com/blog/wp-content/uploads/2018/05/infographic-title-tag.jpg)

Unfortunately, Google search ignores square brackets (even if they’re in quotes).

But Content Explorer doesn’t.

_[Content Explorer](https://ahrefs.com/content-explorer) > search query > “AND [infographic]”_

![content explorer infographic](https://ahrefs.com/blog/wp-content/uploads/2018/05/content-explorer-infographic.jpg)

As you can see, you can also use advanced operators in CE to search for multiple terms at once. The search above finds results containing “SEO,” “keyword research,” or “link building” in the title tag, plus “[infographic].”

You can export these easily (with all associated metrics), too.

Further reading

*   [The Visual Format You Should be Using for Link Building (No, It’s NOT Infographics)](https://ahrefs.com/blog/visual-link-building/)
*   [6 Linkable Asset Types (And EXACTLY How to Earn Links With Them)](https://ahrefs.com/blog/linkable-assets/)
*   [Deconstructing Linkbait: How to Create Content That Attracts Backlinks](https://ahrefs.com/blog/link-bait/)

### 8. Find more link prospects… AND check how relevant they _really_ are

Let’s assume you’ve found a site that you want a link from.

It’s been manually vetted for relevance… and all looks good.

Here’s how to find a list of similar sites or pages:

![related google search operator](https://ahrefs.com/blog/wp-content/uploads/2018/05/related-google-search-operator.jpg)

This returned ~49 results—all of which were similar sites.

Sidenote.

In the example above, we’re looking for similar sites to Ahrefs’ blog—not Ahrefs as a whole.

want to do the same for specific pages? No problem

Let’s try our [link building guide](https://ahrefs.com/blog/link-building/).

![related link building google operator](https://ahrefs.com/blog/wp-content/uploads/2018/05/related-link-building-google-operator.gif)

That’s ~45 results, all of which are _very_ similar. 🙂

Here’s one of the results: _yoast.com/seo-blog_

I’m quite familiar with Yoast, so I know it’s a relevant site/prospect.

But let’s assume that I know nothing about this site, how could I quickly vet this prospect?

Here’s how:

1.  do a `site:domain.com` search, and note down the number of results;
2.  do a `site:domain.com [niche]` search, then also note down the number of results;
3.  divide the second number by the first—if it’s above 0.5, it’s a good, relevant prospect; if it’s above 0.75, it’s a super‐relevant prospect.

Let’s try this with _yoast.com_.

Here’s the number of results for a simple `site:` search:

![yoast simple site search](https://ahrefs.com/blog/wp-content/uploads/2018/05/yoast-simple-site-search.jpg)

And `site: [niche]`:

![yoast site niche search](https://ahrefs.com/blog/wp-content/uploads/2018/05/yoast-site-niche-search.jpg)

So that’s **3,950 / 3,330 = ~0.84**.

_(Remember, >0.75 translates to a very relevant prospect, usually)_

Now let’s try the same for a site that I know to be irrelevant: _greatist.com_.

**Number of results for `site:greatist.com`**** search: ~**18,000

**Number of results for `site:greatist.com SEO` search: ~**7

_(18,000 / 7 = ~0.0004 = a totally irrelevant site)_

**IMPORTANT!** This is a great way to quick eliminate highly‐irrelevant tactics, but it’s not foolproof—you will sometimes get strange or unenlightening results. I also want to stress that it’s certainly no replacement for manually checking a potential prospect’s website. You should ALWAYS thoroughly check a prospects site before reaching out to them. Failure to do that = [SPAMMING](https://ahrefs.com/blog/outreach/).

Here’s another way to find similar domains/prospects…

_[Site Explorer](https://ahrefs.com/site-explorer) \> relevant domain > Competing Domains_

For example, let’s assume I was looking for more SEO‐related link prospects.

I could enter _ahrefs.com/blog_ into Site Explorer.

Then check the Competing Domains.

![competing domains](https://ahrefs.com/blog/wp-content/uploads/2018/05/competing-domains.jpg)

This will reveal domains competing for the same keywords.

### 9. Find social profiles for outreach prospects

Got someone in mind that you want to reach out to?

Try this trick to find their contact details:

![tim soulo google search social profiles](https://ahrefs.com/blog/wp-content/uploads/2018/05/tim-soulo-google-search-social-profiles.jpg)

Sidenote.

You NEED to know their name for this one. This is usually quite easy to find on most websites—it’s just the contact details that can be somewhat elusive.

Here are the top 4 results:

![tim soulo social profiles](https://ahrefs.com/blog/wp-content/uploads/2018/05/tim-soulo-social-profiles.jpg)

BINGO.

You can then contact them directly via social media.

Or use some of the tips from steps #4 and #6 in [this article](https://ahrefs.com/blog/find-email-address/) to hunt down an email address.

Further reading

*   [9 Actionable Ways To Find Anyone’s Email Address \[Updated for 2018\]](https://ahrefs.com/blog/find-email-address/)
*   [11 Ways to Find ANY Personal Email Address](https://www.youtube.com/watch?v=TZFMRl3Yqwc)

### 10. Find internal linking opportunities

Internal links are important.

They help visitors to find their way around your site.

And they also bring SEO benefits (when [used wisely](https://ahrefs.com/blog/technical-seo/)).

But you need to make sure that you’re ONLY adding internal links where relevant.

Let’s say that you just published a big list of [SEO tips](https://ahrefs.com/blog/seo-tips/).

Wouldn’t it be cool to add an internal link to that post from any other posts where you talk about SEO tips?

**Definitely.**

It’s just that finding relevant places to add such links can be difficult—especially with big sites.

So here’s a quick trick:

![seo tips internal links](https://ahrefs.com/blog/wp-content/uploads/2018/05/seo-tips-internal-links.jpg)

For those of you who still haven’t gotten the hang of search operators, here’s what this does:

1.  Restricts the search to a specific site;
2.  Excludes the page/post that you want to build internal links to;
3.  Looks for a certain word or phrase in the text.

Here’s one opportunity I found with this operator:

![seo tips internal link](https://ahrefs.com/blog/wp-content/uploads/2018/05/seo-tips-internal-link.jpg)

It took me all of ~3 seconds to find this. 🙂

### 11. Find PR opportunities by finding competitor mentions

Here’s a page that mentions a competitor of ours—Moz.

![how to use moz](https://ahrefs.com/blog/wp-content/uploads/2018/05/how-to-use-moz.jpg)

Found using this advanced search:

![competitor search](https://ahrefs.com/blog/wp-content/uploads/2018/05/competitor-search.jpg)

But why no mention of Ahrefs? 🙁

Using `site:` and `intext:`, I can see that this site has mentioned us a couple of times before.

![ahrefs mentions](https://ahrefs.com/blog/wp-content/uploads/2018/05/ahrefs-mentions.gif)

But they haven’t written any posts dedicated to our toolset, as they have with Moz.

This presents an opportunity.

Reach out, build a relationship, then perhaps they _may_ write about Ahrefs.

Here’s another cool search that can be used to find competitor reviews:

![allintitle review search google](https://ahrefs.com/blog/wp-content/uploads/2018/05/allintitle-review-search-google.jpg)

Sidenote.

Because we’re using “allintitle” rather than “intitle,” this will match only results with both the word “review” and one of our competitors in the title tag.

You can build relationships with these people and get them to review your product/service too.

Go even further with Content Explorer

You can also use the “In title” search in Content Explorer to find competitor reviews.

I tried this for Ahrefs and found 795 results.

![competitor review](https://ahrefs.com/blog/wp-content/uploads/2018/05/competitor-review.png)

For clarity, here’s the exact search I used:

`review AND (moz OR semrush OR majestic) -site:moz.com -site:semrush.com -site:majestic.com`

But you can go even further by highlighting unlinked mentions.

This highlights the sites that have never linked to you before, so you can then prioritise them.

Here’s one site that has never linked to Ahrefs, yet has reviewed our competitor:

![hobo web no link](https://ahrefs.com/blog/wp-content/uploads/2018/05/hobo-web-no-link.png)

You can see that it’s a Domain Rating (DR) 79 website, so it would be well worth getting a mention on this site.

Here’s another cool tip:

Google’s `daterange:` operator is now deprecated. But you can still add a time period filter to find recent competitor mentions.

Just use the inbuilt filter.

_Tools > Any time > select time period_

![daterange filter competitor mention](https://ahrefs.com/blog/wp-content/uploads/2018/05/daterange-filter-competitor-mention.gif)

Looks like ~34 reviews of our competitors were published in the past month.

Want alerts for competitor mentions in real‐time? Do this.

_[Alerts](https://ahrefs.com/alerts) \> Mentions > Add alert_

Enter the name of your competitor… or any search query you like.

Choose a mode (either “in title” or “everywhere”), add your blocked domains, then add a recipient.

![ahrefs alerts mention](https://ahrefs.com/blog/wp-content/uploads/2018/05/ahrefs-alerts-mention.jpg)

Set your internal to real‐time (or whatever interval you prefer).

Hit “Save.”

You will now receive an email whenever your competitors are mentioned online.

### 12. Find sponsored post opportunities

Sponsored posts are paid‐for posts promoting your brand, product or service.

These are NOT link building opportunities.

[Google’s guidelines](https://support.google.com/webmasters/answer/66356?hl=en) states the following;

> _Buying or selling links that pass PageRank. This includes exchanging money for links, or posts that contain links; exchanging goods or services for links; or sending someone a “free” product in exchange for them writing about it and including a link_

This is why you should ALWAYS nofollow links in sponsored posts.

But the true value of a sponsored post doesn’t come down to links anyway.

It comes down to PR—i.e., getting your brand in front of the right people.

Here’s one way to find sponsored post opportunities using Google search operators:

![sponsored post results](https://ahrefs.com/blog/wp-content/uploads/2018/05/sponsored-post-results.jpg)

~151 results. Not bad.

Here are a few other operator combinations to use:

*   `[niche] intext:”this is a sponsored post by”`
*   `[niche] intext:”this post was sponsored by”`
*   `[niche] intitle:”sponsored post”`
*   `[niche] intitle:”sponsored post archives” inurl:”category/sponsored-post”`
*   `“sponsored” AROUND(3) “post”`

Sidenote.

The examples above are exactly that—_examples_. There are almost certainly other footprints you can use to find such posts. Don’t be afraid to try other ideas.

Want to know how much traffic each of these sites get? Do this.

Use [this Chrome bookmarklet](https://www.chrisains.com/seo-tools/extract-urls-from-web-serps/) to extract the Google search results.

_[Batch Analysis](https://ahrefs.com/batch-analysis) \> paste the URLs > select “domain/*” mode > sort by organic search traffic_

![batch analysis organic search traffic](https://ahrefs.com/blog/wp-content/uploads/2018/05/batch-analysis-organic-search-traffic.png)

Now you have a list of the sites with the most traffic, which are usually the best opportunities.

### 13. Find Q+A threads related to your content

Forums and Q+A sites are great for promoting content.

Sidenote.

Promoting != spamming. Don’t join such sites just to add your links. Provide value and drop the occasional relevant link in there in the process.

One site that comes to mind is Quora.

Quora allow you to drop relevant links throughout your answers.

![quora answer](https://ahrefs.com/blog/wp-content/uploads/2018/05/quora-answer.jpg)

an answer on Quora with a link to an SEO blog.

It’s true that these links are nofollowed.

But we’re not trying to build links here—this is about PR!

Here’s one way to find relevant threads:

![find quora threads google operator](https://ahrefs.com/blog/wp-content/uploads/2018/05/find-quora-threads-google-operator.jpg)

Don’t limit yourself to Quora, though.

This can be done with any forum or Q+A site.

Here’s the same search for Warrior Forum:

![warrior forum thread search](https://ahrefs.com/blog/wp-content/uploads/2018/05/warrior-forum-thread-search.jpg)

I also know that Warrior Forum has a search engine optimization category.

Every thread in this category has “.com/search‐engine‐optimization/” in the URL.

So I could refine my search even further with the inurl: operator.

![warrior forum inurl search](https://ahrefs.com/blog/wp-content/uploads/2018/05/warrior-forum-inurl-search.jpg)

I’ve found that using search operators like this allows you to search forum threads with more granularity than most on‐site searches.

Here’s another cool trick…

_[Site Explorer](https://ahrefs.com/site-explorer) \> quora.com > Organic Keywords > search for a niche‐relevant keyword_

You should now see relevant Quora threads sorted by estimated monthly organic traffic.

![Screen Shot 2018 05 07 at 19 39 26](https://ahrefs.com/blog/wp-content/uploads/2018/05/Screen_Shot_2018-05-07_at_19_39_26.png)

Answering such threads can lead to a nice trickle of referral traffic.

### 14. Find how often your competitors are publishing new content

Most blogs reside in a subfolder or on a subdomain.

**Examples:**

*   [ahrefs.com/blog](https://ahrefs.com/blog/)
*   blog.hubspot.com
*   blog.kissmetrics.com

This makes it easy to check how regularly competitors are publishing new content.

Let’s try this for one of our competitors—SEMrush.

![competitor blog search](https://ahrefs.com/blog/wp-content/uploads/2018/05/competitor-blog-search.png)

Looks like they have ~4.5K blog posts.

But this isn’t accurate. It includes multi‐language versions of the blog, which reside on subdomains.

![competitor blog subdomains](https://ahrefs.com/blog/wp-content/uploads/2018/05/competitor-blog-subdomains.png)

Let’s filter these out.

![](https://ahrefs.com/blog/wp-content/uploads/2018/05/competitor-blog-search.jpg)

That’s more like it. ~2.2K blog posts.

Now we know our competitor (SEMrush) has ~2.2K blog posts in total.

Let’s see how many they published in the last month.

Because the `daterange:` operator no longer works, we’ll instead use Google’s inbuilt filter.

_Tools > Any time > select time period_

![competitor blog posts month](https://ahrefs.com/blog/wp-content/uploads/2018/05/competitor-blog-posts-month.gif)

Sidenote.

Any date range is possible here. Just select “custom.”

~29 blog posts. Interesting.

FYI, that’s ~4x faster than we publish new posts. And they have ~15X more posts than us in total.

But we still get more traffic… with ~2x the value, might I add 😉

![ahrefs vs competitor](https://ahrefs.com/blog/wp-content/uploads/2018/05/ahrefs-vs-competitor.jpg)

[Quality over quantity](https://ahrefs.com/blog/increase-blog-traffic/), right!?

You can also use the `site:` operator combined with a search query to see how much content a competitor has published on a certain topic.

![competitor site topic operator](https://ahrefs.com/blog/wp-content/uploads/2018/05/competitor-site-topic-operator.gif)

### 15. Find sites linking to competitors

Competitors getting links?

What if you could also have them?

Google’s `link:` operator was officially deprecated in 2017.

But I’ve found that it does still return some results.

![competitor links search](https://ahrefs.com/blog/wp-content/uploads/2018/05/competitor-links-search.gif)

Sidenote.

When doing this, always make sure to exclude your competitors site using the “site” operator. If you don’t, you’ll also see their internal links.

~900K links.

want to see even more links?

Google’s data is heavily sampled.

It likely isn’t too accurate either.

[Site Explorer](https://ahrefs.com/site-explorer) can provide a much fuller picture of your competitor’s backlink profile.

![competitor backlinks site explorer](https://ahrefs.com/blog/wp-content/uploads/2018/05/competitor-backlinks-site-explorer.png)

~1.5 million backlinks.

That’s a lot more than Google showed us.

This is yet another instance where the time period filter can be useful.

Filtering by the last month, I can see that Moz has gained 18K\+ new backlinks.

![competitor links month](https://ahrefs.com/blog/wp-content/uploads/2018/05/competitor-links-month.gif)

Pretty useful. But this also illustrates how inaccurate this data can be.

Site Explorer picked up 35K+ links for this same period.

![35k links site explorer](https://ahrefs.com/blog/wp-content/uploads/2018/05/35k-links-site-explorer.png)

That’s almost DOUBLE!

Further reading

*   [7 Actionable Ways to Loot Your Competitors’ Backlinks](https://ahrefs.com/blog/get-competitors-backlinks/)
*   [The Ultimate Guide to Reverse Engineering Your Competitor’s Backlinks](https://ahrefs.com/blog/the-ultimate-guide-to-reverse-engineering-your-competitors-backlinks/)

## Final Thoughts

Google advanced search operators are _insanely_ powerful.

You just have to know how to use them.

But I have to admit that some are more useful than others, especially when it comes to SEO. I find myself using `site:`, `intitle:`, `intext:`, and `inurl:` on an almost daily basis. Yet I rarely use `AROUND(X)`, `allintitle:`, and many of the other more obscure operators.

I’d also add that many operators are borderline useless unless paired with another operator… or two, or three.

So do play around with them and let me know what you come up with.

I’d be more than happy to add any useful combinations you discover to the post. 🙂

![Joshua Hardwick](https://ahrefs.com/blog/wp-content/uploads/2018/04/photo-of-me-425x425.jpg)

[Joshua Hardwick](https://ahrefs.com/blog/author/joshua-hardwick/ "Posts by Joshua Hardwick")

Head of Content @ Ahrefs (or, in plain English, I'm the guy responsible for ensuring that every blog post we publish is EPIC). Founder @ [The SEO Project](http://www.theseoproject.org).


> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
