>* 原文链接 : [Lazy Loading Images? Don’t Rely On JavaScript!](http://robinosborne.co.uk/2016/05/16/lazy-loading-images-dont-rely-on-javascript/)
* 原文作者 : Robin Osborne
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者:



So much of the internet is now made up of pages containing loads of images; just visit your favourite shopping site and scroll through a product listing page for an example of this.

As you can probably imagine, bringing in all of these images when the page loads can add unnecessary bloat, causing the user to download lots of data they may not see. It can also make the page slow to interact with, due to the page layout constantly changing as new images load in, causing the browser to reprocess the page.

One popular method to deal with this is to “Lazy Load” the images; that is, to only load the images just before the user will need to see them.

If this technique is applied to the “above the fold” content – i.e., the first average viewport-sized section of the page – then the user can get a significantly faster first view experience.

## So everyone should always do this, right?

Before we get on to that, let’s look at how this is usually achieved. It’s so easy to find a suitable jQuery plugin or angularjs module that a simple install command later and you’re almost done; just add a new attribute to image tags or JavaScript method to process the images you want to delay loading for.

So surely this is a no-brainer?

Let’s look at what we’re actually trying to achieve here; display some images on a web page (achievable with html alone), but delay when they appear (needs more than just html).

The jquery or angularjs solutions have a dependency on JavaScript, jquery, and angularjs; what if the browser doesn’t support JavaScript? What if the user doesn’t want to download a bloating library or two or three when all you’re trying to achieve is an image load delay?

What if any number of browser toolbars, extensions, plugins, adverts, etc has a JavaScript error; now your user can’t see more than a page of images! Seems pretty daft, right?

## Progressively Enhanced Lazy Loading Images

Given the potential limitations, let’s work on a solution that can handle all my concerns:  
a. works without JavaScript (i.e., lazy loading is an enhancement)  
b. vanilla js – no dependencies on jquery or angularjs  
c. works with _broken_ JavaScript (i.e., the browser supports JavaScript, but there’s a js error somewhere which causes your script to break; might not even be your fault!)

Approaching this logically, it makes sense to use a data attribute on an image element, and swap that for the src attribute when the element is getting close to the viewport. Something like:

    <img
    src="1x1.gif" 
    class="lazy" 
    data-src="real-image.jpg" 
    alt="Laziness"
    width="300px" />

and then some JavaScript like:

    var lazy = document.getElementsByClassName('lazy');

    for(var i=0; i<lazy.length; i++){
     lazy[i].src = lazy[i].getAttribute('data-src');
    }

### a) No JavaScript

Seems like a logical first step. So how could we change this to support no JavaScript? With a bit of html repetition perhaps:

    <img
    src="1x1.gif" 
    class="lazy" 
    data-src="real-image.jpg" 
    alt="Laziness"
    width="300px" />

    <noscript>
        <img 
        src="real-image.jpg" 
        alt="Laziness"
        width="300px" />
    </noscript>

That would mean that the lazy loading would be ignored if JavaScript is disabled. I did a quick check on the network usage for code like this and can confirm that a basic `noscript` `img` check using the code above does not cause multiple requests! You’d assume not, but it’s worth checking!

### b) no jQuery/angularjs

Using the html above, we can write the following JavaScript method to do the `data-src` to `src` switching:

    function lazyLoad(){
        var lazy =
        document.getElementsByClassName('lazy');

        for(var i=0; i<lazy.length; i++){
           lazy[i].src = 
               lazy[i].getAttribute('data-src');
        }
    }

Then let’s create a simple event wiring up helper for cross-browser support (since we’re not using jQuery):

    function registerListener(event, func) {
        if (window.addEventListener) {
            window.addEventListener(event, func)
        } else {
            window.attachEvent('on' + event, func)
        }
    }

And the register the `lazyload` method to execute when the page loads.

    registerListener('load', lazyLoad);

Now when the page loads we’re getting all images with the `lazy` class and loading them using JavaScript; this certainly delays the loading, but it’s not intelligent.

Sounds like I need a bit of viewport logic. Something like this (as nicked from StackOverflow):

    function isInViewport(el){
        var rect = el.getBoundingClientRect();

    return (
        rect.bottom >= 0 && 
        rect.right >= 0 && 

        rect.top <= (
        window.innerHeight || 
        document.documentElement.clientHeight) && 

        rect.left <= (
        window.innerWidth || 
        document.documentElement.clientWidth)
     );
    }

I’ll also need to add the viewport check:

    function lazyLoad(){
        var lazy = 
        document.getElementsByClassName('lazy');

        for(var i=0; i<lazy.length; i++) {
            if(isInViewport(lazy[i])){
               lazy[i].src =
                lazy[i].getAttribute('data-src');
            }
        }
     }

and register the `scroll` event:

    registerListener('scroll', lazyLoad);

> This is _bad_, mkay? You shouldn’t be changing the page whilst the user is scrolling. This is meant to be an example implementation of lazy loading; please feel free to improve it!

Now we’ve got a page that will only load the images within the viewport, and will load all images normally if JavaScript is disabled.

You can check it out here: [http://codepen.io/rposbo/pen/xVddNr](http://codepen.io/rposbo/pen/xVddNr)

### Quick bit of refactoring

Before moving on to the “broken JavaScript” requirement, I want to tidy up the code a bit; right now it will check all `lazy` images on every scroll event, _even if they’ve already been loaded_.

This isn’t a big deal for my demo, but it may be suboptimal for pages with more images. Plus it just feels messy! I want to remove images that have already been loaded from the `lazy` array.

Firstly, let’s move the `lazy` array to a shared variable and set it in a function that’s called on load:

    var lazy = [];

    function setLazy(){
     lazy = document.getElementsByClassName('lazy');
    }

    registerListener('load', setLazy);

Ok, now we have all lazy images in that shared array but I need to keep it up to date. I’m going to remove the `data-src` attribute once I’ve used it, then filter all lazy images:

    function lazyLoad(){
        for(var i=0; i<lazy.length; i++){
            if(isInViewport(lazy[i])){
                if (lazy[i].getAttribute('data-src')){
                    lazy[i].src = 
                     lazy[i].getAttribute('data-src');

                    // remove the attribute
                    lazy[i].removeAttribute('data-src');
                }
            }
        }

        cleanLazy();
    }

    function cleanLazy(){
        lazy = 
            Array.prototype.filter.call(
                lazy, 
                function(l){ 
                    return l.getAttribute('data-src');
                 }
            );
    }

That feels better. Now the `lazy` array will always contain only those images that have not been loaded yet. However it’s doing quite a lot during an `onscroll` event, as mentioned before.

This version can be found at: [http://codepen.io/rposbo/pen/ONmgVG](http://codepen.io/rposbo/pen/ONmgVG)

### c) Broken JavaScript

I love this requirement; it’s a tricky one to solve. If the browser says it supports JavaScript, then the `noscript` tags will be ignored. However, the browser may still fail to execute JavaScript for any of the reasons I mentioned at the start, or more.

#### How about this?

1.  Load enough images to fill the viewport un-lazily; i.e., just regular `img` tags with their `src` attributes set
2.  Under those images have a link to a new page that is _completely_ un-lazy – i.e., a whole page full of plain old `<img>` tags
3.  Hide all `lazy` images using css
4.  Use JavaScript to remove the link and remove the css that hides the lazy images

Let’s follow this through: if the page loads and JavaScript breaks, the user will see one screen of images (1) and a link to “view more” (2) which will take them to a full page (anchored to where they left off).

If the page loads and JavaScript is ok, the link will not be there (4) and the lazy load images will flow into view as intended (3).

Let’s try it out. You can use your own site’s analytics to see what the average user’s resolution is, and calculate how many items would fit in their initial viewport in order to decide where to put this “under the fold” link (2):

    <div id="viewMore">
        <a href="flatpage.html#more">View more</a>
    </div>

> Assume `flatpage.html` is just a non-lazy version of the same page, with an anchor element at the same point in the list of items.

Now let’s initially hide the lazy load images too (3). I’m surrounding them with a new element:

    <span id="nextPage" class="hidden">
        // all lazy load items go here
    </span>

and the css for that class:

     .hidden {display:none;}

This will capture those users with broken JavaScript by showing an initial viewport and a link to the full page. To re-enable the lazy load for users with working JavaScript, I’m just doing this in my `setLazy` function (4):

    // delete the view more link
    document.getElementById('listing')
        .removeChild(
            document.getElementById('viewMore')
        );

    // display the lazy items
    document.getElementById('nextPage')
        .removeAttribute('class');

The resulting code looks like this:


```
<html>
<head>
    <style>
        .item {width:300px; display: inline-block; }
        .item .itemtitle {font-weight:bold; font-size:2em;}
        .hidden {display:none;}
    </style>
</head>
<body>
    <h1>Amalgam Comics Characters</h1>
<div id="listing">

    <!-- first few items are loaded normally -->
    <div class="item">
        <img 
            src="http://static9.comicvine.com/uploads/scale_medium/0/229/305993-131358-dark-claw.jpg" 
            alt="Dark Claw"
            width="300px" />
        <span class="itemtitle">Dark Claw</span>
    </div>
    
    <div class="item">
        <img 
            src="http://static6.comicvine.com/uploads/scale_super/3/31666/706536-supersoldier8.jpg" 
            alt="Super Soldier"
            width="300px" />
        <span class="itemtitle">Super Soldier</span>
    </div>
    
    <div class="item">
        <img 
            src="http://static3.comicvine.com/uploads/scale_super/3/36899/732353-spidey.jpg" 
            alt="Spider Boy"
            width="300px" />
        <span class="itemtitle">Spider Boy</span>
    </div>
    
    <!-- everything after this is lazy -->
    <div id="viewMore">
        <a href="flatpage.html#more">View more</a>
    </div>
    <span id="nextPage" class="hidden">
        
    <div class="item">
        <img 
            src="http://spacergif.org/spacer.gif" 
            class="lazy" 
            data-src="http://vignette1.wikia.nocookie.net/amalgam/images/7/7c/Iron_Lantern.jpg/revision/latest?cb=20110828093145" 
            alt="Iron Lantern"
            width="300px" />
        <noscript>
            <img 
                src="http://vignette1.wikia.nocookie.net/amalgam/images/7/7c/Iron_Lantern.jpg/revision/latest?cb=20110828093145" 
                alt="Iron Lantern"
                width="300px" />
        </noscript>
        <span class="itemtitle">Iron Lantern</span>
    </div>
    
    <div class="item">
        <img 
            src="http://spacergif.org/spacer.gif" 
            class="lazy" 
            data-src="http://static6.comicvine.com/uploads/scale_super/0/1867/583722-amalgam_amazon1.jpg" 
            alt="Amazon"
            width="300px" />
        <noscript>
            <img 
                src="http://static6.comicvine.com/uploads/scale_super/0/1867/583722-amalgam_amazon1.jpg" 
                alt="Amazon"
                width="300px" />
        </noscript>
        <span class="itemtitle">Amazon</span>
    </div>
    
    <div class="item">
        <img 
            src="http://spacergif.org/spacer.gif" 
            class="lazy" 
            data-src="http://static4.comicvine.com/uploads/scale_super/0/1867/583727-bizarnage1.jpg" 
            alt="Bizarnage"
            width="300px" />
        <noscript>
            <img 
                src="http://static4.comicvine.com/uploads/scale_super/0/1867/583727-bizarnage1.jpg" 
                alt="Bizarnage"
                width="300px" />
        </noscript>
        <span class="itemtitle">Bizarnage</span>
    </div>
    
    <div class="item">
        <img 
            src="http://spacergif.org/spacer.gif" 
            class="lazy" 
            data-src="http://static1.comicvine.com/uploads/scale_super/0/1867/583724-amcatsai1.jpg" 
            alt="Catsai"
            width="300px" />
        <noscript>
            <img 
                src="http://static1.comicvine.com/uploads/scale_super/0/1867/583724-amcatsai1.jpg" 
                alt="Catsai"
                width="300px" />
        </noscript>
        <span class="itemtitle">Catsai</span>
    </div>
    
    <div class="item">
        <img 
            src="http://spacergif.org/spacer.gif" 
            class="lazy" 
            data-src="http://static4.comicvine.com/uploads/scale_super/0/1867/583743-moonwing1.jpg" 
            alt="Moonwing"
            width="300px" />
        <noscript>
            <img 
                src="http://static4.comicvine.com/uploads/scale_super/0/1867/583743-moonwing1.jpg" 
                alt="Moonwing"
                width="300px" />
        </noscript>
        <span class="itemtitle">Moonwing</span>
    </div>
    
    <div class="item">
        <img 
            src="http://spacergif.org/spacer.gif" 
            class="lazy" 
            data-src="http://static5.comicvine.com/uploads/scale_super/0/1867/583739-hawkeyei.jpg" 
            alt="Hawkeye"
            width="300px" />
        <noscript>
            <img 
                src="http://static5.comicvine.com/uploads/scale_super/0/1867/583739-hawkeyei.jpg" 
                alt="Hawkeye"
                width="300px" />
        </noscript>
        <span class="itemtitle">Hawkeye</span>
    </div>
    
    <div class="item">
        <img 
            src="http://spacergif.org/spacer.gif" 
            class="lazy" 
            data-src="http://static3.comicvine.com/uploads/scale_super/0/1867/583733-ammrcury1.jpg" 
            alt="Mercury"
            width="300px" />
        <noscript>
            <img 
                src="http://static3.comicvine.com/uploads/scale_super/0/1867/583733-ammrcury1.jpg" 
                alt="Mercury"
                width="300px" />
        </noscript>
        <span class="itemtitle">Mercury</span>
    </div>
    
    <div class="item">
        <img 
            src="http://spacergif.org/spacer.gif" 
            class="lazy" 
            data-src="http://static2.comicvine.com/uploads/scale_super/0/1867/583737-drfate3.jpg" 
            alt="Dr. Strangefate"
            width="300px" />
        <noscript>
            <img 
                src="http://static2.comicvine.com/uploads/scale_super/0/1867/583737-drfate3.jpg" 
                alt="Dr. Strangefate"
                width="300px" />
        </noscript>
        <span class="itemtitle">Dr. Strangefate</span>
    </div>

  </span>
 </div>

<script>
var lazy = [];
registerListener('load', setLazy);
registerListener('load', lazyLoad);
registerListener('scroll', lazyLoad);
registerListener('resize', lazyLoad);
function setLazy(){
    document.getElementById('listing').removeChild(document.getElementById('viewMore'));
    document.getElementById('nextPage').removeAttribute('class');
    
    lazy = document.getElementsByClassName('lazy');
    console.log('Found ' + lazy.length + ' lazy images');
} 
function lazyLoad(){
    for(var i=0; i<lazy.length; i++){
        if(isInViewport(lazy[i])){
            if (lazy[i].getAttribute('data-src')){
                lazy[i].src = lazy[i].getAttribute('data-src');
                lazy[i].removeAttribute('data-src');
            }
        }
    }
    
    cleanLazy();
}
function cleanLazy(){
    lazy = Array.prototype.filter.call(lazy, function(l){ return l.getAttribute('data-src');});
}
function isInViewport(el){
    var rect = el.getBoundingClientRect();
    
    return (
        rect.bottom >= 0 && 
        rect.right >= 0 && 
        rect.top <= (window.innerHeight || document.documentElement.clientHeight) && 
        rect.left <= (window.innerWidth || document.documentElement.clientWidth)
     );
}
function registerListener(event, func) {
    if (window.addEventListener) {
        window.addEventListener(event, func)
    } else {
        window.attachEvent('on' + event, func)
    }
}
</script>
</body>
</html>

```

Or play in the pen: [http://codepen.io/rposbo/pen/EKmXvo](http://codepen.io/rposbo/pen/EKmXvo)

## Summary

As you can see, it is certainly possible to achieve lazy loading images (and other content, should you want to) whilst still allowing for both broken JavaScript and a complete lack of JavaScript support.

There’s a github repo to show the difference between the main listing page and the “flat” listing page as a more “realistic” implementation: [https://github.com/rposbo/lazyloadimages](https://github.com/rposbo/lazyloadimages)

This repo shows how you might implement the solution in .Net, passing the same dynamically generated collection of items to both listing pages.

