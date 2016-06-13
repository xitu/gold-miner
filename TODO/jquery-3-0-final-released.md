>* 原文链接 : [jQuery 3.0 Final Released!](https://blog.jquery.com/2016/06/09/jquery-3-0-final-released/)
* 原文作者 : [Timmy Willison](https://blog.jquery.com/author/timmywil/)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者:


jQuery 3.0 is now released! This version has been in the works since October 2014\. We set out to create a slimmer, faster version of jQuery (with backwards compatibility in mind). We’ve removed all of the old IE workarounds and taken advantage of some of the more modern web APIs where it made sense. It is a continuation of the 2.x branch, but with a few breaking changes that we felt were long overdue. While the 1.12 and 2.2 branches will continue to receive critical support patches for a time, they will not get any new features or major revisions. jQuery 3.0 is the future of jQuery. If you need IE6-8 support, you can continue to use the latest 1.12 release.

Despite the 3.0 version number, we anticipate that these releases shouldn’t be too much trouble when it comes to upgrading existing code. Yes, there are a few “breaking changes” that justified the major version bump, but we’re hopeful the breakage doesn’t actually affect that many people.

To assist with upgrading, we have a brand new [3.0 Upgrade Guide](https://jquery.com/upgrade-guide/3.0/). And the [jQuery Migrate 3.0 plugin](https://github.com/jquery/jquery-migrate#migrate-older-jquery-code-to-jquery-30) will help you to identify compatibility issues in your code. Your feedback on the changes will help us greatly, so please try it out on your existing code and plugins!

You can get the files from the jQuery CDN, or link to them directly:

[https://code.jquery.com/jquery-3.0.0.js](https://code.jquery.com/jquery-3.0.0.js)

[https://code.jquery.com/jquery-3.0.0.min.js](https://code.jquery.com/jquery-3.0.0.min.js)

You can also get the release from npm:

    npm install jquery@3.0.0

In addition, we’ve got the release for jQuery Migrate 3.0\. We highly recommend using this to address any issues with breaking changes in jQuery 3.0\. You can get those files here:

[https://code.jquery.com/jquery-migrate-3.0.0.js](https://code.jquery.com/jquery-migrate-3.0.0.js)

[https://code.jquery.com/jquery-migrate-3.0.0.min.js](https://code.jquery.com/jquery-migrate-3.0.0.min.js)

    npm install jquery-migrate@3.0.0

For more information about upgrading your jQuery 1.x and 2.x pages to jQuery 3.0 with the help of jQuery Migrate, see [the jQuery Migrate 1.4.1 blog post](http://blog.jquery.com/2016/05/19/jquery-migrate-1-4-1-released-and-the-path-to-jquery-3-0/).

### Slim build

Finally, we’ve added something new to this release. Sometimes you don’t need ajax, or you prefer to use one of the many standalone libraries that focus on ajax requests. And often it is simpler to use a combination of CSS and class manipulation for all your web animations. Along with the regular version of jQuery that includes the ajax and effects modules, we’re releasing a “slim” version that excludes these modules. All in all, it excludes ajax, effects, and currently deprecated code. The size of jQuery is very rarely a load performance concern these days, but the slim build is about 6k gzipped bytes smaller than the regular version – 23.6k vs 30k. These files are also available in the npm package and on the CDN:

[https://code.jquery.com/jquery-3.0.0.slim.js](https://code.jquery.com/jquery-3.0.0.slim.js)

[https://code.jquery.com/jquery-3.0.0.slim.min.js](https://code.jquery.com/jquery-3.0.0.slim.min.js)

This build was created with our custom build API, which allows you to exclude or include any modules you like. For more information, have a look at the [jQuery README](https://github.com/jquery/jquery/blob/master/README.md#how-to-build-your-own-jquery).  

## Compatibility with jQuery UI and jQuery Mobile

While most things will work, there are a few issues that jQuery UI and jQuery Mobile will be addressing in upcoming releases. If you find an issue, keep in mind that it may already be addressed upstream and using the [jQuery Migrate 3.0 plugin](http://code.jquery.com/jquery-migrate-3.0.0.js) should fix it. Expect releases soon.

## Major changes

Below are just the highlights of the major new features, improvements, and bug fixes in these releases, you can dig into more detail on the [3.0 Upgrade Guide](https://jquery.com/upgrade-guide/3.0/). A complete list of issues fixed is available on our [GitHub bug tracker](https://github.com/jquery/jquery/issues?q=is%3Aissue+milestone%3A3.0.0). If you read the blog post for 3.0.0-rc1, the below features are the same.

### jQuery.Deferred is now Promises/A+ compatible

jQuery.Deferred objects have been updated for compatibility with Promises/A+ and ES2015 Promises, verified with the [Promises/A+ Compliance Test Suite](https://github.com/promises-aplus/promises-tests). This meant we needed some major changes to the `.then()` method. Legacy behavior can be restored by replacing any use of `.then()` with the now-deprecated `.pipe()` method (which has an identical signature).

1.  An exception thrown in a `.then()` callback now becomes a rejection value. Previously, exceptions bubbled all the way up, aborting callback execution. Any deferreds relying on the resolution of the deferred that threw an exception would never have resolved.

#### Example: uncaught exceptions vs. rejection values

    var deferred = jQuery.Deferred();
    deferred.then(function() {
      console.log("first callback");
      throw new Error("error in callback");
    })
    .then(function() {
      console.log("second callback");
    }, function(err) {
      console.log("rejection callback", err instanceof Error);
    });
    deferred.resolve();

Previously, “first callback” was logged and the error was thrown. All execution was stopped. Neither “second callback” nor “rejection callback” would have been logged. The new, standards-compliant behavior is that you’ll now see “rejection callback” and `true` logged. `err` is the rejection value from the first callback.

2.  The resolution state of a Deferred created by `.then()` is now controlled by its callbacks—exceptions become rejection values and non-thenable returns become fulfillment values. Previously, returns from rejection handlers became _rejection_ values.

#### Example: returns from rejection callbacks

    var deferred = jQuery.Deferred();
    deferred.then(null, function(value) {
      console.log("rejection callback 1", value);
      return "value2";
    })
    .then(function(value) {
      console.log("success callback 2", value);
      throw new Error("exception value");
    }, function(value) {
      console.log("rejection callback 2", value);
    })
    .then(null, function(value) {
      console.log("rejection callback 3", value);
    });
    deferred.reject("value1");

Previously, this would log “rejection callback 1 value1”, “rejection callback 2 value2”, and “rejection callback 3 undefined”.

The new, standards-compliant behavior is that this will log “rejection callback 1 value1”, “**success** callback 2 value2″, and “rejection callback 3 [object Error]”.

3.  Callbacks are always invoked asynchronously, even if a Deferred has already been resolved. Previously, these callbacks were executed synchronously upon binding.

#### Example: async vs sync

    var deferred = jQuery.Deferred();
    deferred.resolve();
    deferred.then(function() {
      console.log("success callback");
    });
    console.log("after binding");

Previously, this would log “success callback” then “after binding”. Now, it will log “after binding” and then “success callback”.

#### Important: while caught exceptions had advantages for in-browser debugging, it is far more declarative (i.e. explicit) to handle them with rejection callbacks. Keep in mind that this places the responsibility on you to always add at least one rejection callback when working with promises. Otherwise, some errors might go unnoticed.

We’ve built a plugin to help in debugging Promises/A+ compatible Deferreds. If you are not seeing enough information about an error on the console to determine its source, check out the [jQuery Deferred Reporter Plugin](https://github.com/dmethvin/jquery-deferred-reporter).

`jQuery.when` has also been updated to accept any thenable object, which includes native Promise objects.

[https://github.com/jquery/jquery/issues/1722](https://github.com/jquery/jquery/issues/1722)  
[https://github.com/jquery/jquery/issues/2102](https://github.com/jquery/jquery/issues/2102)

### Added .catch() to Deferreds

The `catch()` method was added to promise objects as an alias for `.then(null, fn)`.

[https://github.com/jquery/jquery/issues/2102](https://github.com/jquery/jquery/issues/2102)

### Error cases don’t silently fail

Perhaps in a profound moment you’ve wondered, “What is the offset of a window?” Then you probably realized that is a crazy question – how can a window even have an offset?

In the past, jQuery has sometimes tried to make cases like this return _something_ rather than having them throw errors. In this particular case of asking for the offset of a window, the answer up to now has been `{ top: 0, left: 0 }` With jQuery 3.0, such cases will throw errors so that crazy requests aren’t silently ignored. Please try out this release and see if there is any code out there depending on jQuery to mask problems with invalid inputs.

[https://github.com/jquery/jquery/issues/1784](https://github.com/jquery/jquery/issues/1784)

### Removed deprecated event aliases

`.load`, `.unload`, and `.error`, deprecated since jQuery 1.8, are no more. Use `.on()` to register listeners.

[https://github.com/jquery/jquery/issues/2286](https://github.com/jquery/jquery/issues/2286)

### Animations now use `requestAnimationFrame`

On platforms that support the `requestAnimationFrame` API, which is pretty much everywhere but IE9 and Android<4.4, jquery="" will="" now="" use="" that="" api="" when="" performing="" animations.="" this="" should="" result="" in="" animations="" are="" smoother="" and="" less="" cpu="" time="" –="" save="" battery="" as="" well="" on="" mobile="" devices.<="" p="">

jQuery tried using `requestAnimationFrame` a few years back but there were [serious compatibility issues](http://blog.jquery.com/2011/09/01/jquery-1-6-3-released/) with existing code so we had to back it out. We think we’ve beaten most of those issues by suspending animations while a browser tab is out of view. Still, any code that depends on animations to always run in nearly real-time is making an unrealistic assumption.

### Massive speedups for some jQuery custom selectors

Thanks to some detective work by Paul Irish at Google, we identified some cases where we could skip a bunch of extra work when custom selectors like `:visible` are used many times in the same document. That particular case is up to 17 times faster now!

Keep in mind that even with this improvement, selectors like `:visible` and `:hidden` can be expensive because they depend on the browser to determine whether elements are actually displaying on the page. That may require, in the worst case, a complete recalculation of CSS styles and page layout! While we don’t discourage their use in most cases, we recommend testing your pages to determine if these selectors are causing performance issues.

This change actually made it into 1.12/2.2, but we wanted to reiterate it for jQuery 3.0.

[https://github.com/jquery/jquery/issues/2042](https://github.com/jquery/jquery/issues/2042)

As mentioned above, the [Upgrade Guide](https://jquery.com/upgrade-guide/3.0/) is now available for anyone ready to try out this release. Aside from being helpful in upgrading, it also lists more of the notable changes.

