> * 原文地址：[webpack bits: Getting the most out of the CommonsChunkPlugin()](https://medium.com/webpack/webpack-bits-getting-the-most-out-of-the-commonschunkplugin-ab389e5f318#.hn8v7ul1f)
> * 原文作者：[Sean T. Larkin](https://medium.com/@TheLarkInn?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：
> * 校对者：

# webpack bits: Getting the most out of the CommonsChunkPlugin() #

From time to time, the webpack core team loves to get the community involved on Twitter, and share bits and pieces of [knowledge in a fun and informative way](https://twitter.com/TheLarkInn/status/842817690951733248).

![Markdown](http://i4.buimg.com/1949/614a949156a09f9e.png)


This time, the “rules to the game” were simple. Install `webpack-bundle-analyzer`, generate a fancy colorful image of all of your bundles, and share it with me. In return, the webpack team offered to help identify any potential issues we could spot!

### What did we find? ###

The most common theme was code duplication: Libraries, components, code was duplicated across multiple [sync or async] bundles!

### Case One: Many vendor bundles with duplicate code ###

![Markdown](http://i4.buimg.com/1949/4861f2a4f8e4ad74.png)

[Swizec Teller](https://medium.com/@swizec) was kind enough to share one of his builds (which in fact is built for over 8–9 standalone single-page applications ). I chose this example out of all of them because there so many great techniques we can identify from it. So lets look at this in more detail:

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/2000/1*Mt5awEvcigXceRDpZRX4Dw.png">

Closest to the “FoamTree” icon is the application code itself, meanwhile, anything that was used from node_modules is to the far left ending in “_vendor.js”

We can infer quite a few things from this (without looking at the actual configuration).

Each single-page app is using a `new CommonsChunkPlugin` that targets just that entry point, and its vendor code. This creates a bundle with only modules that come from node_modules folder, and another bundle with just application code. The configuration portion was even provided:

![Markdown](http://i4.buimg.com/1949/5a6138ec9a638b46.png)

    Object.keys(activeApps)
      .map(app => new webpack.optimize.CommonsChunkPlugin({
        name: `${app}_vendor`,
        chunks: [app],
        minChunks: isVendor
      }))

The `activeApps` variable most likely represents each of the individual entry points.

#### Areas of Opportunity ####

Below are a few areas that I circled that could use some improvement.

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*D4m4sa9X1V05y7I7ZCMbZA.png">

#### “Meta” caching ####

What we see above is many large libraries like momentjs, lodash, and jquery being used across 6 or more vendor bundles. The strategy for adding all vendors into a separate bundle is good, but we should also apply that same strategy across *all vendor bundles*.

I suggested that [Swizec](https://medium.com/@swizec) add the following at the ***end of his plugins array***:

    new webpack.optimize.CommonsChunkPlugin({
      children: true, 
      minChunks: 6
    })

What we are telling webpack is the following:

> *Hey webpack, look across all chunks (including the vendor ones that were generated) and move any modules that occur in at least 6 chunks to a separate file.*

![Markdown](http://i4.buimg.com/1949/e78d1afe76a28e8c.png)


![Markdown](http://i4.buimg.com/1949/34e0c53c6bcbebc0.png)

As you can see now, all of those modules were extracted into a separate file, and on top of that, [Swizec](https://medium.com/@swizec) reported that this decreased overall application sizes by 17%!

### Case Two: Duplicate vendors across async chunks:

![Markdown](http://i4.buimg.com/1949/6c6cf1a954d205cf.png)

So this amount of duplication wasn’t as severe in terms of overall code size, however, when you look at the full size image below, you can see the exact same 3 modules across every async chunk.

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/2000/1*yRCgk_pzDpkMfQGKpCO_HA.jpeg">

Async chunks are ones containing “[number].[number].js” in their filename

As you can see above, the same 2–3 components are used across all 40–50 async bundles. So how do we solve this with `CommonsChunkPlugin?`

#### Create an async Commons Chunk ####

The technique will be very similar to the first, however we will need to set the `async` property in the configuration option, to `true` as seen below:

    new webpack.optimize.CommonsChunkPlugin({
      async: true, 
      children: true, 
      filename: "commonlazy.js"
    });

In the same way — webpack will scan all chunks and look for common modules. Since `async: true`, only code split bundles will be scanned. Because we did not specify `minChunks` the value defaults to 3. So what webpack is being told is:

> *Hey webpack, look through all normal [aka lazy loaded] chunks, and if you find the same module that appears across 3 or more chunks, then separate it out into a separate async commons chunk.*

Here is what the result was:

![Markdown](http://i4.buimg.com/1949/626cbab70072f442.png)


Now the async chunks are extremely tiny, and all of that code has been aggregated into one file called `commonlazy.js` . Since these bundle were already pretty tiny, the size impact wasn’t very noticeable until second visit. Now there is far less data being shipped per code split bundle and we are saving users load time and data consumption by placing those common modules into a separate cacheable chunk.

#### More control: minChunks function ####

![Markdown](http://i4.buimg.com/1949/4c434dda7236e0e0.png)

So what if you want to have more control? There are scenarios where you don’t want to have a single shared bundle because not every lazy/entry chunk may use it. The `minChunks` property also takes a function!! This can be your “filtering predicate” for what modules are added to your newly created bundle. Below are examples of

    new webpack.optimize.CommonsChunkPlugin({
      filename: "lodash-moment-shared-bundle.js", 
      minChunks: function(module, count) { 
        return module.resource && /lodash|moment/.test(module.resource) && count >= 3
      }
    })

The example above says:

> *Yo webpack, when you come across a module whos absolute path matches lodash or momentjs, and occurs across 3 separate entries/chunks, then extract those modules into a separate bundle.*

You could apply this same behavior to async bundles by setting `async: true` also!

#### Even moar control

![Markdown](http://i4.buimg.com/1949/4c434dda7236e0e0.png)

With this `minChunks` you can create smaller subsets of cacheable vendors for specific entries and bundles. In the end, you may wind up with something that looks like this:

    function lodashMomentModuleFilter(module, count) {
      return module.resource && /lodash|moment/.test(module.resource) && count >= 2;
    }

    function immutableReactModuleFilter(module, count) {
      return module.resource && /immutable|react/.test(module.resource) && count >=4
    }

    new webpack.optimize.CommonsChunkPlugin({
      filename: "lodash-moment-shared-bundle.js", 
      minChunks: lodashMomentModuleFilter
    })

    new webpack.optimize.CommonsChunkPlugin({
      filename: "immutable-react-shared-bundle.js", 
      minChunks: immutableReactModuleFilter
    })

### There is no silver bullet! ### 

`CommonsChunkPlugin()` may be powerful, but keep in mind that each one of these examples is tailored to the application it is applied to. So before you copy-pasta these snippets in, take advice from [Sam Saccone](https://medium.com/@samccone) and [Paul Irish](https://medium.com/@paul_irish) and [MPDIA](https://youtu.be/6m_E-mC0y3Y?t=11m38s) first to make sure you apply the right solution.

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/600/1*ca-C6QCv9ANIJ05lR8wm_w.png">

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/600/1*BGLLxCDDczXd9hxO47eTcw.png">

Always understand your process before applying solutions!

### Where can I find more examples? ###

These are just a sampling of options and uses for `CommonsChunkPlugin()`. To find more, check out our `[/examples](https://github.com/webpack/webpack/tree/master/examples)`[ directory](https://github.com/webpack/webpack/tree/master/examples) in our webpack/webpack core GitHub repo! If you have a great idea for more, feel free and submit a [Pull Request](https://github.com/webpack/webpack/blob/master/CONTRIBUTING.md)!

No time to help contribute? Want to give back in other ways? Become a Backer or Sponsor to webpack by [donating to our open collective](https://opencollective.com/webpack). Open Collective not only helps support the Core Team, but also supports contributors who have spent significant time improving our organization on their free time! ❤
