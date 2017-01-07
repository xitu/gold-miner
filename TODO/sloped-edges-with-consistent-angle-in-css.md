> * 原文地址：[Sloped edges with consistent angle in CSS](https://kilianvalkhof.com/2017/design/sloped-edges-with-consistent-angle-in-css/)
* 原文作者：[Kilian Valkhof](https://kilianvalkhof.com/about/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

# Sloped edges with consistent angle in CSS

If you look above this text, you can see that the header of this blog has a sloped edge. It’s one of my favorite things about this site’s new design. The technique I used has a consistent angle regardless of screen size, can show background images and only needs one HTML element and no pseudo elements. Here’s how I did that.

### Requirements

In short, there were a couple of requirements I had with regards to the implementation.

- Look consistent regardless of screen sizes

- Support (and properly clip) background images and foreground text

- Work across devices (don’t care too much about IE)

If I could also keep the HTML and CSS as simple as possible, then that would be a bonus, but not a requirement.

### Initial Idea

My first idea for the sloped edges was to use rotation transforms on the entire element. That quickly leads down a path of increasing complexity.


    header {
      width:100%;
      transform:rotate(2deg);
    }
    
![Markdown](http://i1.piimg.com/1949/1d093c8548f75a19.png)

Rotating the element means that we see some of the background in the top left and top right corners. That’s fine, we can deal with that by making the inner element wider, and add some negative offset so it correctly covers the top left and top right corners:

    header {
      width:110%;
      top:-5%;
      left:-5%;
      transform:rotate(2deg);
    }

![Markdown](http://p1.bpimg.com/1949/66ff9fc9c670e1ae.png)

And then add an overflow:hidden; to the page or extra element so you don’t get weird horizontal scroll bars:

    body {
      overflow:hidden;
    }
    
    header {
      width:110%;
      top:-5%;
      left:-5%;
      transform:rotate(2deg);
    }

![Markdown](http://p1.bpimg.com/1949/700c21ecaaea3afb.png)

This actually looks great, but what if you add text in there?

![Markdown](http://p1.bpimg.com/1949/5da407e3b90930fb.png)

We now have text not only at an angle, but also slightly outside of the viewport. To make it fit properly inside the viewport again, we need to rotate the text in the opposite direction and then and offset it.

    body {
      overflow:hidden;
    }
    
    header {
      width:110%;
      top:-5%;
      left:-5%;
      transform:rotate(2deg);
    }
    
    header p {
      margin-left:5%;
      transform:rotate(-2deg);
    }
    
![Markdown](http://p1.bpimg.com/1949/6df39c8be4aca467.png)

Up until now, This works fine. The problem starts when you go from a fixed-width scale to a responsive scale. Here’s the same element, just wider:

![Markdown](http://p1.bpimg.com/1949/8aedc93d0b8ecbd0.png)

The top right has a little page peeking out again. The only way to deal with that, is to increase the area of the header outside of the viewport. This happens with every screen size increase and makes it increasingly complex, and thus, brittle. 

Additionally, There is quite a bit of aliasing (pixellation around the edge) going on when using transforms. This will undoubtedly improve with new browser releases, but for now it just doesn’t look that nice. 

### ::after pseudo-element

Another technique often used is to add the transform to an ::after pseudo-element as opposed to the element itself. This has a few benefits compared to the code above: 

- No need to worry about the page peeking out from the top left or top right

- No need to rotate the contents back

So let’s try it:

    header::after {
      position:absolute;
      content: " ";
      display:block;
      left:-5%;
      bottom:-10px;
      transform:rotate(2deg);
      width:110%;
    }

![Markdown](http://p1.bpimg.com/1949/e535b8233927267d.png)

*(opacity overlapping so you can see where the elements are)* That works, but you need to offset the after element such that it’s overlapping the bottom edge fully, and like in the examples above, you also need to make it slightly wider just so you don’t get the visible edges on the left or right. I disabled the overflow:hidden;  here so you can see where the ::after element extends to.

You will need to have the same solid background color for both the header and the ::after elements to make this effect convincing.

#### ::after pseudo element with a border

In CSS, you can use a combination of visible and transparent borders to get visible triangles, which can stand in for a sloped edge. Let’s try the ::after with an angled border:


    header::after {
      position:absolute;
      content: " ";
      display:block;
      left:0;
      bottom:-20px;
      width:100%;
      border-style: solid;
      border-width: 0 100vw 20px 0;
      border-color: transparent rgba(0,0,0,0.4) transparent transparent;
    }

![Markdown](http://p1.bpimg.com/1949/c75f78837f853d67.png)

This looks good, has much better anti-aliasing and it mostly works if you make the width larger too (provided you use a relative size for your border width):

![Markdown](http://p1.bpimg.com/1949/76a5ed38dd1203f3.png)

Instead of a border, another technique I’ve seen is to use an SVG as a 100% width and 100% height background image for your ::after element, thought this amounts to the same result. 

Up until now, the border definitely looks the best, and it’s not *too* much code, but it’s still not ideal for a couple of reasons:

- Another element that’s absolutely positioned that you need to keep in mind

- It’s hard to control the angle you want and keep it consistent

- You are limited to using solid background colors

Up until this point none of my examples used background images (it’s complex enough on its own) but the background image was something I really wanted in my header and footer. ::after pseudo-elements would not support the effect at all. The itself-transformed header would also pose additional problems when positioning the background.

So all the above options have downsides in the complexity they bring in terms of code, or the inflexibility when it comes to getting a consistent look across screen sizes. 

### Using Clip-Path

With both transforms and ::after borders out, that left me with `clip-path`. 

Clip-path is not [especially well supported](http://caniuse.com/#feat=css-clip-path), with just Webkit, Blink and Gecko browsers supporting it and the latter one needing an SVG element. Luckily for me, I can get away with that on my personal blog. Clip Path it is!

Adding a clip-path is straightforward, you can use the polygon function to describe a trapezium[[1]](#footnote-1) (a rectangle with a sloped edge) like this:

    header {
      clip-path: polygon(
        0 0, /* left top */
        100% 0, /* right top */ 
        100% 100%, /* right bottom */
        0 90% /* left bottom */
      );
    }

![Markdown](http://p1.bpimg.com/1949/4c7bbf165dd54283.png)

And this works great! It works in all the ways the transform and border methods did not. You can add a background image, there is nothing funny going on with overflows, the edge is *sharp* and I just need that single `<header>` element.

The only caveat is that, because we describe the polygon in relation to its element, if the width of the element changes in relation to its height the angle of the slope changes. Something that looks like a massive angle on a cellphone would hardly look like a slope at all on a retina screen. Here’s the same exact same clip-path on a wider element:

![Markdown](http://p1.bpimg.com/1949/3c22c81581343388.png)

Here the slope is much less acute and the effect is lessened. What we want is the slope to be consistent regardless of the width of the element. The way I achieved that is by **using viewport-width (vw) units**. 

### Calculating based on width

By using percentages in the polygon notation, you are making the points dependent on the height of an element. If we want to keep the slope consistent when the width changes, we need to allow that to change the height values too. If we change them in an equal measure, then the slope will stay consistent. 

The way to do this is by using viewport width units to determine how far from the bottom of the element the left bottom point should be. In CSS we can do this using the calc function: 

    header {
      clip-path: polygon(
        0 0,
        100% 0,
        100% 100%,
        0 **calc(100% - 6vw)**
      );
    }

Changing the width will now *lower the position of the lower left point*, creating an effect where the slope remains the same. 

If you want the slope to be at the top of your element, it would actually be simpler: the first line would become “6vw 0”, and you would not even need a calc().

At this point, feel free to scroll up to the header (or down to the footer) and resize your browser to see the effect in action.

### Firefox support

Unfortunately, Firefox only supports SVG polygons for describing a clip path, so until support lands in Firefox, people will see different angles in it.

Creating a clip-path for Firefox requires some knowledge of SVG. SVG clipPaths are described in either real values such as pixels, or fractions between 0 and 1 for percentages. SVG has an attribute called `clipPathUnits="objectBoundingBox"` which you can use to tell your browser to take the dimensions of your element, and apply the clip-path to that. Without it, it would use the SVG’s dimensions. If you combine using fractional values and using the object bounding box, you basically get the polygon I described above:


    <svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
      <defs>
        <clipPath id="header" clipPathUnits="objectBoundingBox">
          <polygon points="0 0, 1 0, 1 1, 0 0.87" />
        </clipPath>
      </defs>
    </svg>

If you look at the definition of the points, then you can see that it’s very similar to how we define them in the CSS clip-path example. Referencing this file in your CSS looks like this:

    @-moz-document url-prefix() {
      header {
        clip-path: url(path/to/yoursvgfile.svg#header)
      }
    }

The @moz-document is a cheat to prevent the rule from being applied in other browsers. Alternatively, as [Sven Wolfermann](https://twitter.com/maddesigns/status/816673011369701381) pointed out, just specify your url() clip-path *before* your polygon() clip-path and Firefox will fall back to it automatically. When Firefox adds support, [slated for mid-april of 2017](http://jensimmons.com/post/jan-4-2017/slicing-your-page), it will automatically start using polygon() too. 

Apart from not having a consistent angle across screen sizes, it has all the benefits that a css-defined clip-path has, such as the element being in normal flow, a nicely anti-aliased edge and backgrounds applying like you’d expect them to. 

### Sloped edges with consistent angle in CSS

So that’s how you create sloped edges with a consistent angle in CSS, that doesn’t need `overflow:hidden`, allow you to use backgrounds and can be done with just a single element. 

If you have comments or improvements on this technique, please let me know on [Twitter](https://twitter.com/kilianvalkhof) or [email me](/contact)!

*[[1]](#footnote-ref-1) Thanks to my math teacher girlfriend for telling me the proper name for this shape.*
