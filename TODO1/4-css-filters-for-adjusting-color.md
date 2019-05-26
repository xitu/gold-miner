4 CSS Filters For Adjusting Color
=================================

SVG offers a non-destructive way to change some color properties of an image or graphic. Unfortunately some of those changes are more cumbersome to make than others. CSS filters allow you to non-destructively change some properties of color as well and in a less cumbersome way than SVG.

The last couple of weeks I've been talking about CSS filters as an alternative to SVG filters. First I offered [an introduction](http://vanseodesign.com/css/css-filters-introduction/) and showed you an example of the blur() filter-function and then I walked through the [url() and drop-shadow() filter-functions](http://vanseodesign.com/css/drop-shadow-filter/) and provided examples for each.

Today I want to walk you through four more CSS filter-functions all of which are shortcuts to different types and values of the SVG filter primitive feColorMatrix.

The feColorMatrix Filter Primitive
----------------------------------

The feColorMatrix primitive can be used as a general way to change some of the [fundamental properties of color](http://vanseodesign.com/web-design/hue-saturation-and-lightness/) in an element. As the name implies, the primitive makes use of a matrix of values to add different filter effects.

Four different CSS filter-functions exist to replicate effects you can create with [feColorMatrix](http://vanseodesign.com/web-design/svg-filter-primitives-fecolormatrix/). It's one example where a single SVG primitive can do more than any one CSS filter-function.

Here are the four CSS filters.

-   grayscale()
-   hue-rotate();
-   saturate();
-   sepia();

Let's walk through each of them and change the colors of what is likely a familiar image, if you've been following along with this series.

![](http://www.vanseodesign.com/blog/wp-content/uploads/2013/09/strawberry-fields.jpg)

The grayscale() filter-function
-------------------------------

The grayscale() filter-function converts an image to grayscale.

|  |

grayscale() = grayscale( [ <number> | <percentage> ] )

 |

You determine the proportion to convert the image by supplying either a percentage or a number between 0.0 and 1.0. 100% (or 1.0) is full conversion to [grayscale](http://vanseodesign.com/web-design/luminance-working-in-grayscale/) and 0% (or 0.0) leads to no conversion. Values between 0.0 and 1.0 or 0% and 100% are linear multipliers of the effect. Negative values are not allowed.

In this first example I applied 100% grayscale to my Strawberry Fields image using the value 1 in the filter-function.

|  |

.strawberry {

 |
|  |

 filter: grayscale(1);

 |
|  |

}

 |

The original image contains a lot of gray as it is, but I think you can see the effect of the filter as now all color has been removed.

![](http://www.vanseodesign.com/blog/wp-content/uploads/2013/09/strawberry-fields.jpg)

For comparison here's the matrix the filter-function replaces. To be fair there's an easier way to use feColorMatrix to remove color by setting the type attribute to saturate. I'll show you that in a bit.

|  |

<filter id="grayscale">

 |
|  |

 <feColorMatrix type="matrix"

 |
|  |

 values="(0.2126 + 0.7874 * [1 - amount]) (0.7152 - 0.7152 * [1 - amount]) (0.0722 - 0.0722 * [1 - amount]) 0 0

 |
|  |

 (0.2126 - 0.2126 * [1 - amount]) (0.7152 + 0.2848 * [1 - amount]) (0.0722 - 0.0722 * [1 - amount]) 0 0

 |
|  |

 (0.2126 - 0.2126 * [1 - amount]) (0.7152 - 0.7152 * [1 - amount]) (0.0722 + 0.9278 * [1 - amount]) 0 0 0 0 0 1 0"/>

 |
|  |

</filter>

 |

Still, this is definitely a case where the CSS filter-function is a lot easier to use. The only reason I knew to use this particular matrix is because I found an example using it online. I didn't need to search for the value 1 in the filter-function.

The hue-rotate() filter-function
--------------------------------

The hue-rotate() filter-function changes the hue of every pixel in the element by the amount you specify.

|  |

hue-rotate() = hue-rotate( <angle> )

 |

The angle is set in degrees and you do need to specify the units as deg. An angle of 0deg leaves the element unchanged as does a any multiple of 360deg (720deg, 1080deg, 1440px, etc.).

In this example I rotated the hue 225 degrees.

|  |

.strawberry {

 |
|  |

 filter: hue-rotate(225deg);

 |
|  |

}

 |

The value turns the red and yellow flowers into flowers that contain more pinks, purples, and blues.

![](http://www.vanseodesign.com/blog/wp-content/uploads/2013/09/strawberry-fields.jpg)

Here's the SVG filter for comparison. The CSS is still simpler, however in this case, not by a lot.

|  |

<filter id="hue-rotate">

 |
|  |

 <feColorMatrix type="hueRotate" values="225"/>

 |
|  |

</filter>

 |

The saturate() filter-function
------------------------------

CSS also provides a saturate() filter-function that you can use to saturate or desaturate an element.

|  |

saturate() = saturate( [ <number> | <percentage> ] )

 |

As with the grayscale function, the value defines the proportion of the conversion. 0% (or 0.0) results in a completely desaturated element and 100% (1.0) leaves the element unchanged. Values in between are linear multipliers of the effect.

Here I set the filter to 50% saturation.

|  |

.strawberry {

 |
|  |

 filter: saturate(0.5);

 |
|  |

}

 |

Which results in the image below.

![](http://www.vanseodesign.com/blog/wp-content/uploads/2013/09/strawberry-fields.jpg)

Negative values are not allowed, but you can can provide values greater than 100% or 1.0 to super-saturate the element. Here's the image again with 900% saturation applied ( filter:saturate(9); ).

![](http://www.vanseodesign.com/blog/wp-content/uploads/2013/09/strawberry-fields.jpg)

Like saturate(), the corresponding SVG filter is relatively simple.

|  |

<filter id="saturate">

 |
|  |

 <feColorMatrix type="saturate" values="0.5"/>

 |
|  |

</filter>

 |

I mentioned earlier that you can set the type attribute to saturate for a simpler way to use feColorMatrix to create a grayscale image. All you have to do is set the value to 0 to completely desaturate the image, which produces the same as setting it to 100% grayscale.

The sepia() filter-function
---------------------------

Finally there's the sepia() filter-function, which converts an image to sepia.

|  |

sepia() = sepia( [ <number> | <percentage> ] )

 |

This should be familiar by now, but the value defines the proportion of the conversion. 100% (1.0) is completely sepia while 0% (0.0) leaves the image unchanged and values in between are linear multipliers of the effect.

Negative values are not allowed. You can supply a value greater than 100% or 1.0, but it won't increase the effect.

Here I set the sepia function to 75%

|  |

.strawberry {

 |
|  |

 filter: sepia(75%);

 |
|  |

}

 |

And here's how it looks.

![](http://www.vanseodesign.com/blog/wp-content/uploads/2013/09/strawberry-fields.jpg)

There is no sepia type for feColorMatrix so to get the same sepia effect you need to use another matrix.

|  |

<filter id="sepia">

 |
|  |

 <feColorMatrix type="matrix"

 |
|  |

 values="(0.393 + 0.607 * [1 - amount]) (0.769 - 0.769 * [1 - amount]) (0.189 - 0.189 * [1 - amount]) 0 0

 |
|  |

 (0.349 - 0.349 * [1 - amount]) (0.686 + 0.314 * [1 - amount]) (0.168 - 0.168 * [1 - amount]) 0 0

 |
|  |

 (0.272 - 0.272 * [1 - amount]) (0.534 - 0.534 * [1 - amount]) (0.131 + 0.869 * [1 - amount]) 0 0 0 0 0 1 0"/>

 |
|  |

</filter>

 |

I take it you agree that using the CSS filter-function is again the easier of the two options, even if the SVG offers greater flexibility in what you can do.

Closing Thoughts
----------------

All four of the CSS filter-functions I walked through today are shortcuts for the feColorMatrix filter primitive. Two of them replace complicated matrices and the other two replace a specific type of the primitive.

I hope you agree that all four of these filter-functions are easy enough to understand and use. I doubt you'll have much difficulty working with them or figuring out what values to use to adjust your images and graphics.
