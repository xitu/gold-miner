> * 原文地址：[Selector Nesting Has Come to CSS](https://dev.to/akashshyam/selector-nesting-has-come-to-css-532i)
> * 原文作者：[Akash Shyam](https://dev.to/akashshyam)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/selector-nesting-has-come-to-css.md](https://github.com/xitu/gold-miner/blob/master/article/2021/selector-nesting-has-come-to-css.md)
> * 译者：
> * 校对者：

# Selector Nesting Has Come to CSS 🤯🤯🤯 !!!

First we had variables and now nesting in css! It seems that the functionality we get with pre-processors like Sass and Less are slowly being introduced in CSS. It's similar to what's happening between javascript and typescript. If you have noticed, a few years ago, some of the current javascript features did not exist in javascript but were implemented in typescript.

I'm not saying this is a bad thing, it's actually great! This decreases the need for pre-proccessors which need to be compiled into CSS/Javascript

That being said, selector nesting is still in the future. No browsers support it yet, but I expect this to improve. For more information, checkout the [draft](https://drafts.csswg.org/css-nesting-1/).

### [](#what-really-is-nesting)What Really Is nesting???

To explain this effectlively, I'm going to compare two code samples.

##### [](#without-nesting)Without Nesting

```
button.btn {
  color: blue;
  background: white;
  transition: .2s all ease-in;
  /* More styles for the button */
}

button.btn:hover {
  color: white;
  background: blue;
}

button.btn:focus {
   /* Add more styles */
}

button.btn-group {
  /* Some styles */ 
}

button.btn-primary {
  /* I promise, this is the last. */ 
}

```

Now let me show the same code with nesting.  

```
.btn {
  color: blue;
  background: white;
  transition: .2s all ease-in;

  &:hover {
    color: white;
    background: blue;
  }

  &:focus {
   /* Add more styles */
  }

  &-group {
    /* Some styles */ 
  }

  &-primary {
    /* You get the point right??? */ 
  }
}


```

Just like in Sass, The `&` is used to refer to the parent selector(in this case, `.btn`). That's not all, we can also nest multiple levels deep.  

```
.btn {
  color: white;
  background: cyan;

  &-container {
    margin: 10px 20px;

    &:hover {
      /* Some fancy animation */ 
    }

    & .overlay {
       /* There should always be an "&" in a nested selectors */
    }
  }
}

```

### [](#nest)@nest

This is a new `at-rule` that helps us overcome some of the limitations of nesting using the `&`. Look at the following code:  

```
.section {
    /* etc ... */
}

.section {
    /* etc ... */

    .blog {
        /* We want to reference the blog container which is inside the .section. */
    }
}

```

For this, we can use the `@nest` rule. This rule shifts the reference of the `&` to another selector we specify.  

```
.main {
    /* etc ... */

    .blog {
        @nest .section & {
                        /* The "&" refers to ".section" */
            background: red;
        }
    }
}


```

### [](#nesting-media-queries)Nesting Media Queries

For people who are familiar with Sass, the "normal" code looks like this:  

```
.section {
  @media(/* some media query */) {
    /* styles... */
  }

}

```

However, this is slightly different. In css, the styles must be enclosed in "&".  

```
  @media(/* some media query */) {
    & {
      /* styles... */
    }
  }

```

* Normal code

```
.table.xyz > th.y > p.abc {
  font-size: 1rem;
  color: white;
}

.table.xyz > th.y > p.abc-primary {
  font-size: 1.4rem;
}

```

* The Power of nesting 💪 💪 💪

```
.table.xyz > th.y > p.abc {
  font-size: 1rem;
  color: white;

  &-primary {
    font-size: 1.4rem
  }
}

```

#### [](#makes-code-more-readable)Makes code more readable

As soon as you look the code, you can go "Aha, anything between those outer curly braces is related to buttons or `.btn`! Not my business!"

### [](#a-gotcha)A gotcha

One thing to keep in mind is that any css which is after nested selectors is flat out ignored. However, any nesting that is followed is completely valid.  

```
.x {
  &-y {
    /* styles... */
  }

  a {
    /* invalid */
  }

  &-z {
    /* valid */
  }
}

```

That's it guys! Thank you for reading this post.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
