# Cache-Control for Civilians

The best request is the one that never happens: in the fight for fast websites, avoiding the network is far better than hitting the network at all. To this end, having a solid caching strategy can make all the difference for your visitors.

That being said, more and more often in my work I see lots of opportunities being left on the table through unconsidered or even completely overlooked caching practices. Perhaps it's down to the heavy focus on first-time visits, or perhaps it's a simple lack of awareness and knowledge? Whatever it is, let's have a bit of a refresher.

## `Cache-Control`

One of the most common and effective ways to manage the caching of your assets is via the `Cache-Control` HTTP header. This header applies to individual assets, meaning everything on our pages can have a very bespoke and granular cache policy. The amount of control we're granted makes for very intricate and powerful caching strategies.

A `Cache-Control` header might look something like this:

```
Cache-Control: public, max-age=31536000

```

`Cache-Control` is the header, and each of `public` and `max-age=31536000` are*directives*. The `Cache-Control` header can accept one or more directives, and it is these directives, what they really mean, and their optimum use-cases that I want to cover in this post.

## `public` and `private`

`public` means that any caches may store a copy of the response. This includes CDNs, proxy servers, and the like. The `public` directive is often redundant, as the presence of other directives (such as `max-age`) are implicit instructions that caches may store a copy.

`private`, on the other hand, is an explicit instruction that only the end recipient of the response (the *client*, or *the browser*) may store a copy of the file. While `private` isn't a security feature in and of itself, it is intended to prevent public caches (such as a CDN) storing a response that contains information unique to one user.

## `max-age`

`max-age` defines a unit of time in seconds (relative to the time of the request) for which the response is deemed 'fresh'.

```
Cache-Control: max-age=60
```

This `Cache-Control` header tells the browser that it can use this file from the cache for the next 60 seconds without having to worry about revalidating it. Once the 60 seconds is up, the browser will head back to the server to revalidate the file.

If the server has a new file for the browser to download, it will respond with a `200`response, download the new file, the old file will be ejected from the HTTP cache, the new file will replace it, and will honour its caching headers.

If the server doesn't have a fresher copy that needs downloading, the server responds with a `304` response, doesn't need to download any new file, and will update the cached copy with the new headers. This means that, if the `Cache-Control: max-age=60` header is still present, the cached file's 60 seconds starts again. 120 seconds overall cache time for one file.

Beware: There is one pretty large caveat with `max-age` on its own... `max-age` tells the browser that the asset in question is stale, but it doesn't tell the browser that it absolutely cannot use the stale version. A browser may use its own heuristics to decide that it might release a stale copy of a file without revalidating it. This behaviour is somewhat non-deterministic, so it's quite hard to know exactly what a browser will actually do. To this end, we have a series of more explicit directives that we can augment our `max-age` with. Thanks to [Andy Davies](https://twitter.com/AndyDavies) for helping me clarify this one.

### `s-maxage`

The `s-maxage` (note the absence of the `-` between `max` and `age`) will take precedence over the `max-age` directive but only in the context of shared caches. Using `max-age`and `s-maxage` in conjunction allows you to have different fresh durations for private and public caches (e.g. proxies, CDNs) respectively.


## `no-store`

```
Cache-Control: no-store
```

What if we don't want to cache a file? What if the file contains sensitive information? Perhaps it's an HTML page that contains your bank details? Or maybe the information is time-critical? Perhaps a page that contains realtime stock prices? We don't want to store or serve any responses like this from cache at all: we always want to discard sensitive information and fetch the freshest realtime information. Now we'd use `no-store`.

`no-store` is a very strong directive not to persist any information to any cache, private or otherwise. Any asset that carries the `no-store` directive will always hit the network, no matter what.

## `no-cache`

```
Cache-Control: no-cache
```

This is the one that trips most people up... `no-cache` doesn't mean 'no cache'. It means 'do `no`t serve a copy from `cache` until you've revalidated it with the server and the server said you can use the cached copy'. Right. Sounds like this should be called `must-revalidate`! Except that's not what it sounds like, either.

`no-cache` is actually a pretty smart way of always guaranteeing the freshest content, but also being able to use the much faster cached copy if possible. `no-cache` will always hit the network as it has to revalidate with the server before it can release the browser's cached copy (unless the server responds with a fresher response), but if the server responds favourably, the network transfer is only a file's headers: the body can be grabbed from cache rather than redownloaded.

So, like I say, this is a smart way to combine freshness and the possibility of getting a file from cache, but it will hit the network for at least an HTTP header response.

A good use-case for `no-cache` would be almost any dynamic HTML page. Think of a news site's homepage: it's not realtime, nor does it contain any sensitive information, but ideally we'd like the page to always show the freshest content. We can use `cache-control: no-cache` to instruct the browser to check back with the server first, and if the server has nothing newer to offer (`304`), let's reuse the cached version. In the event that the server did have some fresher content, it would respond as such (`200`) and send the newer file.

Tip: There is no use sending a `max-age` directive alongside a `no-cache` directive as the time-limit for revalidation is zero seconds.

## `must-revalidate`

Even more confusingly, while the above sounds like it should be called `must-revalidate`, it turns out `must-revalidate` is something different still (but still similar).

```
Cache-Control: must-revalidate, max-age=600
```

`must-revalidate` needs an associated `max-age` directive; above, we've set it to ten minutes.

Where `no-cache` will immediately revalidate with the server, and only use a cached copy if the server says it may, `must-revalidate` is like `no-cache` with a grace period. What happens here is that, for the first ten minutes, the browser will *not* (I know, I know...) revalidate with the server, but the moment that ten minutes passes, it's back to the server we go. If the server has nothing new for us, it responds with a `304`and the new `Cache-Control` headers are applied to the cached file---our ten minutes starts again. If, after ten minutes, there is a newer file on the server, we get a `200`response and its body, and the local cache gets updated.

A great candidate for `must-revalidate` is a blog like mine: static pages that seldom change. Sure, the latest content is desirable, but given how infrequently my site changes, we don't need anything as heavy handed as `no-cache`. Instead, let's assume everything is going to be good enough for ten minutes, then revalidate after that.

### `proxy-revalidate`

In a similar vein to `s-maxage`, `proxy-revalidate` is the public-cache specific version of `must-revalidate`. It is simply ignored by private caches.

## `immutable`

`immutable` is a pretty new and very neat directive that tells the browser a little more about the type of file we've sent it---is its content mutable or immutable? But, before we look at what `immutable` does, let's look at the problem it's solving:

A user refresh causes the browser to revalidate a file regardless of its freshness because a user refresh usually means one of two things:

1.  The page looks broken, or;
2.  content looks out of date...

...so let's check if there's anything more up to date on the server.

If there is a newer file available on the server, we definitely want to download it. As such, we'll get a `200` response, a fresh file, and---hopefully---the issue is fixed. If, however, there wasn't a new file on the server, we'll bring back a `304` header, no new file, but an entire roundtrip of latency. If we're revalidating many files that result in many `304`s, that can add up to hundreds of milliseconds of unnecessary overhead.

`immutable` is a way of telling the browser that a file will never change---it's *immutable*---and therefore never to bother revalidating it. We can completely cut out the overhead of a roundtrip of latency. What do we mean by a mutable or immutable file?

-   `style.css`: When we change the contents of this file, we don't change its name at all. The file always exists, and its content always changes. This file is mutable.
-   `style.ae3f66.css`: This file is unique---it is named with a fingerprint based on its content, so the moment that content changes, we get a whole new file. This file is immutable.

We'll discuss this in more detail in the [Cache Busting](https://csswizardry.com/2019/03/cache-control-for-civilians/#cache-busting) section.

If we can somehow communicate to the browser that our file is immutable---that its content never changes---then we can also let the browser know that it needn't bother checking for a fresher version: there would never be a fresher version as the file simply ceases to exist the moment its content changes.

This is exactly what the `immutable` directive does:

```
Cache-Control: max-age=31536000, immutable
```

In browsers that support `immutable`, a user refresh will never cause a revalidation within the 31,536,000-second freshness lifespan. This means no unnecessary roundtrips spent retrieving `304` responses, which potentially saves us a lot of latency on the critical path ([CSS blocks rendering](https://csswizardry.com/2018/11/css-and-network-performance/)). On high latency connections, this saving could be tangible.

Beware: You should not apply `immutable` to any files that are not immutable. You should also have a very robust cache busting strategy in place so that you don't inadvertently aggressively cache a file to which `immutable` has been applied.

## `stale-while-revalidate`

I really, really wish there was better support for `stale-while-revalidate`.

We've talked a lot so far about revalidation: the process of the browser making the trip back to the server to check whether a fresher file might be available. On high latency connections, the duration of revalidation alone can be noticeable, and that time is simply dead time---until we've heard from the server, we can neither release a cached copy (`304`) or download the new file (`200`).

What `stale-while-revalidate` provides is a grace period (defined by us) in which the browser is permitted to use an out of date (stale) asset while we're checking for a newer version.

```
Cache-Control: max-age=31536000, stale-while-revalidate=86400
```

This is telling the browser, 'this file is good to use for a year, but after that year is up, you have one extra day in which you may continue to serve this stale resource while you revalidate it in the background'.

`stale-while-revalidate` is a great directive for non-critical resources that, sure, we'd like the freshest version, but we know there'll be no damage caused if we use the stale response once more while we're checking for updates.

## `stale-if-error`

In a similar manner to `stale-while-revalidate`, `stale-if-error` allows the browser a grace period in which it can permissibly return a stale response if the revalidated resource returns a `5xx`-class error.

```
Cache-Control: max-age=2419200, stale-if-error=86400
```

Here, we instruct the cache that the file is fresh for 28 days (2,419,200 seconds), and that if we were to encounter an error after that time, we allow an additional day (86,400 seconds) during which we will allow a stale asset to be served.

## `no-transform`

`no-transform` doesn't have anything do with storing, serving, or revalidating freshness, but it does instruct intermediaries that they cannot modify, or *transform*, any of the response.

A common scenario in which an intermediary might modify a response is to make optimisations on behalf of developers *for* users: a telco provider might proxy image requests though their stack and make optimisations to them before passing them off to end users on mobile connections.

The issue here is that developers begin to lose control of the presentation of their resources, and the image optimisations made by the telco might be deemed too aggressive and unacceptable, or we might have already optimised the images to the ideal degree ourselves and anything further is unnecessary.

Here, we want to instruct this middleware not to transform any of our content.

```
Cache-Control: no-transform
```

The `no-transform` header can sit alongside any other directives, and needs no other directives for it to function itself.

N.B. Some transformations are a good idea: CDNs choosing between Gzip or Brotli encoding for users that need the former or could use the latter; image transformation services automatically converting to WebP; etc.

N.B. If you're running over HTTPS---which you should be---then intermediaries and proxies can't modify payloads anyway, so `no-transform` would be ineffective.

## Cache Busting

It would be irresponsible to talk about caching without talking about cache busting. I would always recommend solving your cache busting strategy before even thinking about your caching strategy. To do it the other way round is the fast-path to headaches.

Cache busting solves the problem: I just told the browser to use this file for the next year, but I just changed it and I don't want users to wait a whole year before they get the fresh copy! How can I intervene?!

### No Cache Busting -- `style.css`

This is is the least-preferred thing to do: absolutely no cache busting whatsoever. This is a mutable file that we'd really struggle to cache bust.

You should be very wary of caching any files like these, because we lose almost all control over them once they're on the user's device.

Despite this example being a stylesheet, HTML pages fall squarely into this camp. We can't change the file name of a webpage---imagine the havoc that would cause!---which is exactly why we tend not to cache them at all.

### Query String -- `style.css?v=1.2.14`

Here, we still have a mutable file, but we add a query string to its file path. While better than the nothing option, it's still not perfect. If anything were to strip that query string away, we fall back into the previous category of having no cache busting in place at all. A lot of proxy servers and CDNs will not cache anything with a query string either by configuration (e.g. from Cloudflare's own documentation: ...a request for "`style.css?something`" will be normalised to just "`style.css`" when serving from the cache.), or defensively (the query string might contain information specific to one particular response).

### Fingerprint -- `style.ae3f66.css`

Fingerprinting is by far the preferred method for cache busting a file. By literally changing the file each time its content changes, we don't technically cache bust anything: we end up with a whole new file! This is very robust, and permits the use of `immutable`. If you can implement this on your static assets, please do! Once you've managed to implement this very reliable cache busting strategy, you can use the most aggressive form of caching:

```
Cache-Control: max-age=31536000, immutable
```

#### Implementation Detail

The key to this method is the changing of the filename, but it doesn't *have* to be a fingerprint. All of the following examples have the same effect:

1.  `/assets/style.ae3f66.css`: busting with a hash of the file's contents.
2.  `/assets/style.1.2.14.css`: busting with a release version.
3.  `/assets/1.2.14/style.css`: busting by changing a directory in the URL.

However, the last example *implies* that we're versioning each release rather than each individual file. This in turn implies that if we only needed to cache bust our stylesheet, we'd also have to cache bust all of the static files for that release. This is potentially wasteful, so prefer options (1) or (2).

### `Clear-Site-Data`

Cache invalidation is hard---[famously so](https://martinfowler.com/bliki/TwoHardThings.html)---so there's [a spec currently underway](https://www.w3.org/TR/clear-site-data/) that helps developers quite definitively clear the entire cache for their site's origin in one fell swoop: `Clear-Site-Data`.

I don't want to go into too much detail in this post as `Clear-Site-Data` is not a `Cache-Control` directive, but is in fact a whole new HTTP header.

```
Clear-Site-Data: "cache"
```

Applying this header to any one of your origin's assets will clear the cache for the entire origin, not just the file to which it is attached. That means that, if you needed to hard-purge your entire site from all visitors' caches, you could apply the above header to just your HTML payload.

[Browser support](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Clear-Site-Data#Browser_compatibility), at the time of writing, is limited to Chrome, Android Webview, Firefox, and Opera.

Tip: There are a number of directives that `Clear-Site-Data` will accept:`"cookies"`, `"storage"`, `"executionContexts"`, and `"*"` (which, naturally, means 'all of the above').

## Examples and Recipes

Okay, let's take a look at some scenarios and what kinds of `Cache-Control` headers we might employ.

### Online Banking Page

Something like an online banking app page that lists your recent transactions, your current balance, and perhaps sensitive bank account details needs to be up-to-date (imagine being served a page that listed your balance as it appeared a week ago!) and also kept very private (you don't want your bank details to be stored in a shared cache (or any cache, really)).

To this end, let's go with:

```
Request URL: /account/
Cache-Control: no-store
```

As per the spec, this would be sufficient to prevent a browser persisting the response to disk at all, across private and shared caches:

> The `no-store` response directive indicates that a cache MUST NOT store any part of either the immediate request or response. This directive applies to both private and shared caches. 'MUST NOT store' in this context means that the cache MUST NOT intentionally store the information in non-volatile storage, and MUST make a best-effort attempt to remove the information from volatile storage as promptly as possible after forwarding it.

But if you wanted to be very defensive, perhaps you might opt for:

```
Request URL: /account/
Cache-Control: private, no-cache, no-store
```

This would explicitly instruct not to store anything in public caches (e.g. a CDN), to always serve the freshest possible copy, and not to persist anything to storage.

### Live Train Timetable Page

If we're building a page that displays near-realtime information, we want to guarantee that the user always sees the best, most up-to-date information we can give them, if that information exists. Let's use:

```
Request URL: /live-updates/
Cache-Control: no-cache
```

This simple directive will mean that the browser won't show a response directly from cache without checking with the server that it is allowed to. This means that a user will never be shown out of date train information, but they could benefit from grabbing file from their cache if the server dictates that the cache mirrors the latest information.

This is usually a sensible default for almost all webpages: give us the latest possible content, but let us use the speed of the cache if possible.

### FAQs Page

A page like FAQs is likely to update very infrequently, and the content on it is unlikely to be time sensitive. It's certainly not as critical as realtime sport scores or flight statuses. We can probably cache an HTML page like this for a little while and force the browser to check for fresh content periodically instead of every visit. Let's go for this:

```
Request URL: /faqs/
Cache-Control: max-age=604800, must-revalidate
```

This tells the browser to cache the HTML page for one week (604,800 seconds), and once that week is up, we need to check with the server for updates.

Beware: Having differing caching strategies for different pages within the same website could lead to a problem where your `no-cache` homepage requests the newest `style.f4fa2b.css` that it references, but your three-day cached FAQs page is still pointing at `style.ae3f66.css`. The effects of this may be slight, but it's a scenario you should be aware of.

### Static JS (or CSS) App Bundle

Let's say our `app.[fingerprint].js` updates pretty frequently---potentially with every release we do---but we've also put in the work to fingerprint the file every time it changes (good work!) then we can do something like this:

```
Request URL: /static/app.1be87a.js
Cache-Control: max-age=31536000, immutable
```

It doesn't matter that we update our JS quite frequently: because of our ability to reliably cache bust it, we can cache it for as long as we like. In this case, we've chosen to cache it for a year. I picked a year because firstly, a year is a long time, but secondly, it's pretty highly unlikely that a browser will actually hold onto a file for that long anyway (browsers have a finite amount of storage they can use for HTTP cache, so they periodically empty parts of it themselves; users may clear their own cache). Going anything beyond a year is likely to be no more effective.

Further, because this file's content never changes, we can signal to the browser that this file is immutable. We don't need to revalidate it for the whole year, even if a user refreshes the page. Not only do we get the speed benefits of using the cache, we avoid the latency penalty of revalidation.

### Decorative Image

Imagine a purely decorative photograph accompanying an article. It's not an infographic or a chart, it doesn't contain any content critical to understanding the rest of the page, and a user wouldn't even really notice if it was completely missing anyway.

Images are usually a heavy asset to download, so we want to cache it; it's not critical to the page, so we don't need to fetch the latest version; and we could probably even get away with serving the image after it's gone a little out of date. Let's do this:

```
Request URL: /content/masthead.jpg
Cache-Control: max-age=2419200, must-revalidate, stale-while-revalidate=86400
```

Here we're telling the browser to store the image for 28 days (2,419,200 seconds), that we want to check with the server for updates after that 28-day time limit, and if the image is less than one day (86,400 seconds) out of date, let's use that one while we fetch the latest version in the background.

## Key Things to Remember

-   Cache busting is vitally important. Work out your cache busting strategy before you begin work on your caching strategy.
-   Generally speaking, caching HTML---content---is a bad idea. HTML URLs can't be busted, and as your HTML page is generally the entry point into the rest of your page's subresources, you'll end up caching the references to your static assets, too. This is going to cause you (and your users) a world of frustration.
-   If you are going to cache any HTML, having different cache policies on different types of HTML page on a site could lead to inconsistencies if one class of page is always fresh and others are sometimes fetched from cache.
-   If you can reliably cache-bust (with a fingerprint) your static assets, then you might as well go all-in and cache for years at a time with an `immutable`directive for good measure.
-   Non-critical content can be given a stale grace period with directives like`stale-while-revalidate`.
-   `immutable` and `stale-while-revalidate` not only give us the traditional benefits of a cache, but they also allow us to mitigate the cost of latency while revalidating.

Avoiding the network wherever possible makes for much faster experiences for our users (and much lower throughput for our infrastructure). By having a good view of our assets, and an overview of what's available to us, we can begin to design very granular, bespoke, and effective caching strategies specific to our own applications.

Cache rules everything.

## Resources and Related Reading

-   [*Caching best practices & max-age gotchas*](https://jakearchibald.com/2016/caching-best-practices/) -- [Jake Archibald](https://twitter.com/jaffathecake), 2016
-   [*Cache-Control: immutable*](http://bitsup.blogspot.com/2016/05/cache-control-immutable.html) -- [Patrick McManus](https://twitter.com/mcmanusducksong), 2016
-   [*Stale-While-Revalidate, Stale-If-Error Available Today*](https://www.fastly.com/blog/stale-while-revalidate-stale-if-error-available-today) -- [Steve Souders](https://twitter.com/Souders), 2014
-   [*A Tale of Four Caches*](https://calendar.perfplanet.com/2016/a-tale-of-four-caches/) -- [Yoav Weiss](https://twitter.com/yoavweiss), 2016
-   [Clear-Site-Data](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Clear-Site-Data) -- MDN
-   [RFC 7234 -- HTTP/1.1 Caching](https://tools.ietf.org/html/rfc7234) -- 2014

### Do as I Say, Not as I Do

Before someone on Hacker News hauls me over the coals for my hypocrisy, it's worth noting that my own caching strategy is so sub-par that I'm not even going to go into it.
