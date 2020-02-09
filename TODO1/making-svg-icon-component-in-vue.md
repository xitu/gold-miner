> * 原文地址：[Making SVG Icon Component in Vue](https://medium.com/js-dojo/making-svg-icon-component-in-vue-cb7fac70e758)
> * 原文作者：[Achhunna Mali](https://medium.com/@achhunna)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/making-svg-icon-component-in-vue.md](https://github.com/xitu/gold-miner/blob/master/TODO1/making-svg-icon-component-in-vue.md)
> * 译者：
> * 校对者：

# Making SVG Icon Component in Vue

#### A Cool Way to Use SVGs Like Icon Fonts

![Photo by [Harpal Singh](https://unsplash.com/@aquatium?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/12000/0*bac2YeLYkqgbsZuH)

After considering [reasons](https://www.keycdn.com/blog/icon-fonts-vs-svgs) to migrate vector icons from icon fonts to inline SVGs, I looked for a solution in Vue.js to replace icon fonts with SVGs, while still maintaining the flexibility and easy-of-use of using icon fonts — ability to change the size, color and other attributes easily through CSS.

One popular method is to use `v-html` directive and `html-loader` npm module to import SVGs into our Vue template and modify the rendered `\<svg>` element in Vue’s `mounted()` lifecycle method. Styles can then be applied directly to the `\<svg>` or to its parent and everything can be wrapped in a component for reusability.

## Creating Svg-icon Component

Let’s create `Svg-icon.vue` component file with three props.

1. `icon` string prop to pass the `.svg` filename to import
2. `hasFill` boolean prop which tells the component if `fill` property will be used to change the color of the `\<svg>` element, default is false i.e. no `fill`
3. `growByHeight` boolean prop to determine to use `height` or `width` to scale relative to the `font-size`, default is true i.e. use `height`

```Vue
<script>
function recursivelyRemoveFill(el) {
    if (!el) {
        return;
    }
    el.removeAttribute('fill');
    [].forEach.call(el.children, child => {
        recursivelyRemoveFill(child);
    });
}
export default {
    name: 'svg-icon',
    props: {
        icon: {
            type: String,
            default: null
        },
        hasFill: {
            type: Boolean,
            default: false
        },
        growByHeight: {
            type: Boolean,
            default: true
        },
    },
    mounted() {
        if (this.$el.firstElementChild.nodeName === 'svg') {
            const svgElement = this.$el.firstElementChild;
            const widthToHeight = (svgElement.clientWidth / svgElement.clientHeight).toFixed(2);
            if (this.hasFill) {
                // recursively remove all fill attribute of element and its nested children
                recursivelyRemoveFill(svgElement);
            }
            // set width and height relative to font size
            // if growByHeight is true, height set to 1em else width set to 1em and remaining is calculated based on widthToHeight ratio
            if (this.growByHeight) {
                svgElement.setAttribute('height', '1em');
                svgElement.setAttribute('width', `${widthToHeight}em`);
            } else {
                svgElement.setAttribute('width', '1em');
                svgElement.setAttribute('height', `${1 / widthToHeight}em`);
            }
            svgElement.classList.add('svg-class');
        }
    }
}
</script>

<template>
    <div v-html="require(`html-loader!../assets/svg/${icon}.svg`)" class="svg-container"></div>
</template>

<style lang="scss" scoped>
.svg-container {
    display: inline-flex;
}
.svg-class {
    vertical-align: middle;
}
</style>
```

We pass the icon `.svg` file to `html-loader` in `require()` method which stringifies it and is rendered into `\<svg>` element by `v-html` directive.

The `mounted()` lifecycle method is where all modifications to the `\<svg>` element happen.

* Set either `height` or `width` attribute of the `\<svg>` element to `1em` (relative to 1x the `font-size`) determined by `growByHeight` and use `widthToHeight` for the other. Since not all SVGs are square shaped, we calculate `widthToHeight` ratio from the rendered element so that the SVG scales proportionately to its original dimensions as the parent’s `font-size` property changes.
* In order to set the `fill` attribute of the `\<svg>` element, we need override the inline `fill` that comes with the SVG file. When `hasFill` is true, we recursively remove fill attributes from `\<svg>` element and its children. Then adding a `fill` value using CSS selector to its parent or the `\<svg>` element will do the trick.
* Additional DOM attributes like `class` can also be added to the element which can be used to scoped-styling in the component

---

## Creating Smile Icon

Let’s create a smile icon using icon fonts from [Font Awesome](https://fontawesome.com/icons/smile?style=solid) as well as our `Svg-icon` component.

![smile-solid, credit: [https://fontawesome.com/license](https://fontawesome.com/license)](https://cdn-images-1.medium.com/max/2276/1*TegYEwSxB4dJEFql2T1k9A.png)

#### Using Icon Fonts

```Vue
<template>
  <i class="fas fa-smile smile-icon"></i>
</template>

<style lang="scss" scoped>
.smile-icon {
  font-size: 24px;
  color: #aaa;

  &:hover {
    color: #666;
  }
}
</style>
```

The CSS selector for `.smile-icon` class sets the `font-size` and `color` of the icon along with `:hover` psuedo-class.

#### Using Svg-icon Component

```Vue
<script>
import SvgIcon from './components/Svg-icon';

export default {
  name: 'my-component',
  components: {
    'svg-icon': SvgIcon,
  },
}
</script>

<template>
  <div class="smile-icon">
    <svg-icon icon="smile-solid" :hasFill="true"></svg-icon>
  </div>
</template>

<style lang="scss" scoped>
.smile-icon {
  font-size: 24px;
  fill: #aaa;

  &:hover {
    fill: #666;
  }
}
</style>
```

Above implementation is identical to the icon fonts method, except for the `.smile-icon` class is in the parent element and `color` attribute is replaced by `fill` in the `Svg-icon` component case. We also need to ensure that the `smile-solid.svg` file is in the path that’s specified in our `Svg-icon` component’s `require()` method ( `./assets/svg/` ).

#### Rendered HTML

This is the rendered HTML that `v-html` outputs. Note: all `fill` attributes are removed and `height` and `width` attributes are added to `\<svg>` .

```html
<div class="smile-icon">
  <svg height="1em" width="1em" aria-hidden="true" focusable="false" data-prefix="fas" data-icon="smile" class="svg-inline--fa fa-smile fa-w-16" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 496 512">
    <path d="M248 8C111 8 0 119 0 256s111 248 248 248 248-111 248-248S385 8 248 8zm80 168c17.7 0 32 14.3 32 32s-14.3 32-32 32-32-14.3-32-32 14.3-32 32-32zm-160 0c17.7 0 32 14.3 32 32s-14.3 32-32 32-32-14.3-32-32 14.3-32 32-32zm194.8 170.2C334.3 380.4 292.5 400 248 400s-86.3-19.6-114.8-53.8c-13.6-16.3 11-36.7 24.6-20.5 22.4 26.9 55.2 42.2 90.2 42.2s67.8-15.4 90.2-42.2c13.4-16.2 38.1 4.2 24.6 20.5z">
    </path>
  </svg>
</div>
```

---

## Transitioning to SVGs

![Credit: [https://tympanus.net](https://tympanus.net)](https://cdn-images-1.medium.com/max/2000/1*gbV6Hisa64jh0tb5ughaig.gif)

Since SVGs are considered the way of the future, it is good to migrate away from using icon fonts while still retaining the ease of use that icon fonts provide. The `Svg-icon` component is an example of how we can use available libraries to abstract away the messy parts of `\<svg>` element, while mimicking the good part of using icon fonts!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
