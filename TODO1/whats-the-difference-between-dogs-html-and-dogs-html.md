> * 原文地址：[What’s the difference between ./dogs.html and /dogs.html?](https://css-tricks.com/whats-the-difference-between-dogs-html-and-dogs-html/)
> * 原文作者：[CHRIS COYIER](https://css-tricks.com/author/chriscoyier/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/whats-the-difference-between-dogs-html-and-dogs-html.md](https://github.com/xitu/gold-miner/blob/master/TODO1/whats-the-difference-between-dogs-html-and-dogs-html.md)
> * 译者：
> * 校对者：

# What’s the difference between ./dogs.html and /dogs.html?

They are _both_ **URL paths**. They have different names, though.

```html
<!-- root-relative -->
<a href="./dogs.html">Dogs</a>

<!-- absolute -->
<a href="/dogs.html">Dogs</a>
```

There are also fully-qualified URLs that would be like:

```html
<!-- fully qualified -->
<a href="https://website.com/dogs.html">Dogs</a>
```

Fully-qualified URL's are pretty obvious in what they do — that link takes you to that exact place. So, let's look those first two examples again.

Say you have a directory structure like this on your site:

```
public/
├── index.html
└── animals/
    ├── cats.html
    └── dogs.html
```

If you put a link on `cats.html` that links to `/dogs.html` (an "absolute" path), it's going to 404 — there is no `dogs.html` at the base/root level of this site! The `/` at the beginning of the path means _"start at the **very bottom** level and go up from there"_ (with `public/` being the very bottom level).

That link on `cats.html` would need to be written as either `./dogs.html` (start one directory back and work up) or `/animals/dogs.html` (explicitly state which directory to start at).

Absolute URLs get longer, naturally, the more complex the directory structure.

```
public/
├── animals/
  └── pets/
      ├── c/
      |   └── cats.html
      └── d/
          └── dogs.html
```

With a structure like this, for `dogs.html` to link to `cats.html`, it would have to be either...

```html
<!-- Notice the TWO dots, meaning back up another folder level -->
<a href="../c/cats.html">cats</a>

<!-- Or absolute -->
<a href="/animals/pets/c/cats.html">cats</a>
```

It's worth noting in this scenario that if `animals/` was renamed `animal/`, then the relative link would still work, but the absolute link would not. That can be a downside to using absolute links. When you're that specific, making a change to the path will impact your links.

We've only looked at HTML linking to HTML, but this idea is universal to the web (and computers, basically). For example, in a CSS file, you might have:

```css
body {
  /* Back up one level from /images and follow this path */
  background-image: url(./images/pattern.png);
}
```

...which would be correct in this situation:

```
public/
├── images/
|   └── pattern.png
├──index.html
└── style.css
```

But if you were to move the CSS file...

```
public/
├── images/
|   └── pattern.png
├── css/
|   └── style.css
└── index.html
```

...then that becomes wrong because your CSS file is now nested in another directory and is referencing paths from a deeper level. You'd need to back up another folder level again with two dots, like `../images/pattern.png`.

One URL format isn't better than another — it just depends on what you think is more useful and intuitive at the time.

For me, I think about what is the least likely thing to change. For something like an image asset, I find it very unlikely that I'll ever move it, so linking to it with an absolute URL path (e.g. `/images/pattern.png`) seems the safest. But for linking documents together that all happen to be in the same directory, it seems safer to link them relatively.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
