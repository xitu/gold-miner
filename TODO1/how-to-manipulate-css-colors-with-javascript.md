> * 原文地址：[How to manipulate CSS colors with JavaScript](https://blog.logrocket.com/how-to-manipulate-css-colors-with-javascript-fb547113a1b8)
> * 原文作者：[Adam Giese](https://medium.com/@adamgiese)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-manipulate-css-colors-with-javascript.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-manipulate-css-colors-with-javascript.md)
> * 译者：
> * 校对者：

# How to manipulate CSS colors with JavaScript

![](https://cdn-images-1.medium.com/max/3840/1*74prqSnfQ5ppH58DbLUqcA.jpeg)

## Color models 101

I know you’re here to learn about manipulating colors — and we’ll get there. But before we do, we need a baseline understanding of how CSS notates colors. CSS uses two different color models: RGB and HSL. Let’s take a quick look at both.

### RGB

An initialism for “red, green, blue,” [RGB](https://codepen.io/AdamGiese/full/5783951de51e0db0f569d5abbd9cb2f7) consists of three numbers that each signify how much light of its respective color is included in the resulting end color. In CSS, each of these numbers is in the range of 0–255 and would be written as comma-separated parameters of the CSS `rgb` function. For example, `rgb(50,100,0)`.

RGB is an “additive” color system, which means that the higher each number is, the brighter the end color will be. If all values are equal, the color will be grayscale; if all values are zero, the result will be black; and if all values are 255, the result will be white.

Alternatively, you can notate RGB colors using the hexadecimal notation, in which each color’s integer is converted from base 10 to base 16. For example, `rgb(50,100,0)` would be `#326400`.

Although I usually find myself reaching for RGB (particularly hexadecimal) out of habit, I often find that it is hard to read and especially hard to manipulate. Enter HSL.

### HSL

An initialism for “hue, saturation, light,” [HSL](https://codepen.io/AdamGiese/full/989988044f3b8cf6403e3c60f56dd612) also consists of three values. The hue value corresponds to the position on the color wheel and is represented by a CSS angle value; most commonly, deg units are used.

Saturation, represented by a percentage, refers to the intensity of the color. When saturation is 100 percent, it is fully colored; the less saturation, the less color, until it reaches grayscale at 0 percent.

Lightness, also represented by a percentage, refers to how bright a color is. “Regular” brightness is 50 percent. A lightness of 100 percent will be pure white, and 0 percent lightness will be pure black, regardless of the hue and saturation values.

I find HSL to be a more intuitive model. Relations between colors are more immediately evident, and manipulation of colors tends to be as simple as tweaking just one of the numbers.

![](https://cdn-images-1.medium.com/max/4800/1*wV7zU6J05BL3bphzMlB2rA.png)

## Conversion between color models

Both the RGB and HSL color models break down a color into various attributes. To convert between the syntaxes, we first need to calculate these attributes.

With the exception of hue, each value we have discussed can be represented as a percentage. Even the RGB values are byte-sized representations of percentages. In the formulas and functions below, these percentages will be represented by decimals between 0 and 1.

I would like to note that I will not cover the math for these in depth; rather, I will briefly go over the original mathematical formula and then convert it into a JavaScript formula.

### Calculating lightness from RGB

Lightness is the easiest of the three HSL values to calculate. Mathematically, the formula is displayed as follows, where `M` is the maximum of the RGB values and `m` is the minimum:

![The mathematic formula for lightness](https://cdn-images-1.medium.com/max/2000/0*mZxFLQvMNraVQWQS.png)

Here is the same formula as a JavaScript function:

```
const rgbToLightness = (r,g,b) => 
    1/2 * (Math.max(r,g,b) + Math.min(r,g,b));
```

### Calculating saturation from RGB

Saturation is only slightly more complicated than lightness. If the lightness is either 0 or 1, then the saturation value will be 0. Otherwise, it follows the mathematical formula below, where `L` represents lightness:

![The mathematical formula for saturation](https://cdn-images-1.medium.com/max/2000/0*xZf55x3WTTJUIAG3.png)

As JavaScript:

```
const rgbToSaturation = (r,g,b) => {
  const L = rgbToLightness(r,g,b);
  const max = Math.max(r,g,b);
  const min = Math.min(r,g,b);
  return (L === 0 || L === 1)
   ? 0
   : (max - min)/(1 - Math.abs(2 * L - 1));
};
```

### Calculating hue from RGB

The formula for calculating the hue angle from RGB coordinates is a bit more complex:

![The mathematical formula for hue](https://cdn-images-1.medium.com/max/2000/0*oLI0PhBJhkE8BK_e.png)

As JavaScript:

```
const rgbToHue = (r,g,b) => Math.round(
  Math.atan2(
    Math.sqrt(3) * (g - b),
    2 * r - g - b,
  ) * 180 / Math.PI
);
```

The multiplication of `180 / Math.PI` at the end is to convert the result from radians to degrees.

### Calculating HSL

All of these functions can be wrapped into a single utility function:

```
const rgbToHsl = (r,g,b) => {
  const lightness = rgbToLightness(r,g,b);
  const saturation = rgbToSaturation(r,g,b);
  const hue = rgbToHue(r,g,b);
  return [hue, saturation, lightness];
}
```

### Calculating RGB from HSL

Before jumping into calculating RGB, we need a few prerequisite values.

First is the “chroma” value:

![The mathematical formula for chroma](https://cdn-images-1.medium.com/max/2000/0*Noxj7Gk7KGYqGfvx.png)

We also have a temporary hue value, whose range we will use to decide which “segment” of the hue circle we belong on:

![The mathematical formula for hue prime](https://cdn-images-1.medium.com/max/2000/0*DgjQEdahvhEjn60j.png)

Next, we have an “x” value, which will be used as the middle (second-largest) component value:

![The mathematical formula for a temporary “x” value](https://cdn-images-1.medium.com/max/2000/0*rmrqPF1miT7a-O-O.png)

We have an “m” value, which is used to adjust each of the values for lightness:

![The mathematical formula for lightness match](https://cdn-images-1.medium.com/max/2000/0*TwM-2sYH0uEJhu35.png)

Depending on the hue prime value, the `r`, `g`, and `b` values will map to `C`, `X`, and `0`:

![The mathematical formula for RGB values without accounting for lightness](https://cdn-images-1.medium.com/max/2000/0*k1pxEnWMU-rDQYIG.png)

Lastly, we need to map each value to adjust for lightness:

![The mathematical formula to account for lightness with RGB](https://cdn-images-1.medium.com/max/2000/0*Vlii9C8Cum3apLK-.png)

Putting all of this together into a JavaScript function:

```
const hslToRgb = (h,s,l) => {
  const C = (1 - Math.abs(2 * l - 1)) * s;
  const hPrime = h / 60;
  const X = C * (1 - Math.abs(hPrime % 2 - 1));
  const m = l - C/2;
  const withLight = (r,g,b) => [r+m, g+m, b+m];

if (hPrime <= 1) { return withLight(C,X,0); } else
  if (hPrime <= 2) { return withLight(X,C,0); } else
  if (hPrime <= 3) { return withLight(0,C,X); } else
  if (hPrime <= 4) { return withLight(0,X,C); } else
  if (hPrime <= 5) { return withLight(X,0,C); } else
  if (hPrime <= 6) { return withLight(C,0,X); }

}
```

### Creating a color object

For ease of access when manipulating their attributes, we will be dealing with a JavaScript object. This can be created by wrapping the previously written functions:

```
const rgbToObject = (red,green,blue) => {
  const [hue, saturation, lightness] = rgbToHsl(red, green, blue);
  return {red, green, blue, hue, saturation, lightness};
}

const hslToObject = (hue, saturation, lightness) => {
  const [red, green, blue] = hslToRgb(hue, saturation, lightness);
  return {red, green, blue, hue, saturation, lightness};
}
```

### Example

I highly encourage you to spend some time [playing with this example](https://codepen.io/AdamGiese/full/86b353c35a8bfe0868a8b48683faf668). Seeing how each of the attributes interacts when you adjust the others can give you a deeper understanding of how the two color models fit together.

## Color manipulation

Now that we have the ability to convert between color models, let’s look at how we can manipulate these colors!

### Update attributes

Each of the color attributes we have covered can be manipulated individually, returning a new color object. For example, we can write a function that rotates the hue angle:

```
const rotateHue = rotation => ({hue, ...rest}) => {
  const modulo = (x, n) => (x % n + n) % n;
  const newHue = modulo(hue + rotation, 360);

return { ...rest, hue: newHue };
}
```

The `rotateHue` function accepts a `rotation` parameter and returns a new function, which accepts and returns a color object. This allows for the easy creation of new “rotation” functions:

```
const rotate30 = rotateHue(30);
const getComplementary = rotateHue(180);

const getTriadic = color => {
  const first = rotateHue(120);
  const second = rotateHue(-120);
  return [first(color), second(color)];
}
```

Along the same lines, you can write functions to `saturate` or `lighten` a color — or, inversely, `desaturate` or `darken`.

```
const saturate = x => ({saturation, ...rest}) => ({
  ...rest,
  saturation: Math.min(1, saturation + x),
});

const desaturate = x => ({saturation, ...rest}) => ({
  ...rest,
  saturation: Math.max(0, saturation - x),
});

const lighten = x => ({lightness, ...rest}) => ({
  ...rest,
  lightness: Math.min(1, lightness + x)
});

const darken = x => ({lightness, ...rest}) => ({
  ...rest,
  lightness: Math.max(0, lightness - x)
});
```

### Color predicates

In addition to color manipulation, you can write “predicates” — that is, functions that return a Boolean value.

```
const isGrayscale = ({saturation}) => saturation === 0;
const isDark = ({lightness}) => lightness < .5;
```

## Dealing with color arrays

### Filters

The JavaScript `[].filter` method accepts a predicate and returns a new array with all the elements that “pass.” The predicates we wrote in the previous section can be used here:

```
const colors = [/* ... an array of color objects ... */];
const isLight = ({lightness}) => lightness > .5;
const lightColors = colors.filter(isLight);
```

### Sorting

To sort an array of colors, you first need to write a “comparator” function. This function takes two elements of an array and returns a number to denote the “winner.” A positive number indicates that the first element should be sorted first, and a negative indicates the second should be sorted first. A zero value indicates a tie.

For example, here is a function for comparing the lightness of two colors:

```
const compareLightness = (a,b) => a.lightness - b.lightness;
```

Here is a function that compares saturation:

```
const compareSaturation = (a,b) => a.saturation - b.saturation;
```

In an effort to prevent duplication in our code, we can write a higher-order function to return a comparison function to compare any attribute:

```
const compareAttribute = attribute =>
  (a,b) => a[attribute] - b[attribute];

const compareLightness = compareAttribute('lightness');
const compareSaturation = compareAttribute('saturation');
const compareHue = compareAttribute('hue');
```

### Averaging attributes

You can average the specific attributes of an array of colors by composing various JavaScript array methods. First, you can calculate the average of an attribute by summing with reduce and dividing by the array length:

```
const colors = [/* ... an array of color objects ... */];
const toSum = (a,b) => a + b;
const toAttribute = attribute => element => element[attribute];
const averageOfAttribute = attribute => array =>
  array.map(toAttribute(attribute)).reduce(toSum) / array.length;
```

You can use this to “normalize” an array of colors:

```
/* ... continuing */

const normalizeAttribute = attribute => array => {
  const averageValue = averageOfAttribute(attribute)(array);
  const normalize = overwriteAttribute(attribute)(averageValue);
  return normalize(array);
}

const normalizeSaturation = normalizeAttribute('saturation');
const normalizeLightness = normalizeAttribute('lightness');
const normalizeHue = normalizeAttribute('hue');
```

## Conclusion

Colors are an integral part of the web. Breaking down colors into their attributes allows for the smart manipulation of colors and opens the door to all sorts of possibilities.

## Plug: LogRocket, a DVR for web apps

![[https://logrocket.com/signup/](https://logrocket.com/signup/)](https://cdn-images-1.medium.com/max/7104/1*s_rMyo6NbrAsP-XtvBaXFg.png)

[LogRocket](https://logrocket.com/signup/) is a frontend logging tool that lets you replay problems as if they happened in your own browser. Instead of guessing why errors happen, or asking users for screenshots and log dumps, LogRocket lets you replay the session to quickly understand what went wrong. It works perfectly with any app, regardless of framework, and has plugins to log additional context from Redux, Vuex, and @ngrx/store.

In addition to logging Redux actions and state, LogRocket records console logs, JavaScript errors, stacktraces, network requests/responses with headers + bodies, browser metadata, and custom logs. It also instruments the DOM to record the HTML and CSS on the page, recreating pixel-perfect videos of even the most complex single-page apps.

[Try it for free.](https://logrocket.com/signup/)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
