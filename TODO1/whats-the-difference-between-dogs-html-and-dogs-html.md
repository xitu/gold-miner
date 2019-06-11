> * 原文地址：[What’s the difference between ./dogs.html and /dogs.html?](https://css-tricks.com/whats-the-difference-between-dogs-html-and-dogs-html/)
> * 原文作者：[CHRIS COYIER](https://css-tricks.com/author/chriscoyier/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/whats-the-difference-between-dogs-html-and-dogs-html.md](https://github.com/xitu/gold-miner/blob/master/TODO1/whats-the-difference-between-dogs-html-and-dogs-html.md)
> * 译者：[Shery](https://github.com/shery)
> * 校对者：[Kasheem Lew](https://github.com/kasheemlew) [Cherry](https://github.com/sunshine940326)

# ./dogs.html 和 /dogs.html 间有什么区别？

它们**都是** **URL 路径**。但是他们名字不同。

```html
<!-- 相对于当前所在目录（相对路径） -->
<a href="./dogs.html">Dogs</a>

<!-- 相对于根目录（绝对路径） -->
<a href="/dogs.html">Dogs</a>
```

还有完整 URL 路径，如下所示：

```html
<!-- 完整 URL 路径 -->
<a href="https://website.com/dogs.html">Dogs</a>
```

全限定 URL 的功能再明显不过 —— 它会指向一个确切的页面。所以，让我们再来看看前两个例子。

假设你的网站上有这样的目录结构：

```
public/
├── index.html
└── animals/
    ├── cats.html
    └── dogs.html
```

如果你在 `cats.html` 上放置了一个链接到 `/dogs.html`（一个“绝对”路径）的超链接，那么它将指向 404 页面 —— 这个网站的根目录那一层没有 `dogs.html` 文件！在路径开头的 `/` 意味着__“从**最底层**开始，然后再往上”__（`public/` 是最底层到目录）。

那个在 `cats.html` 上的链接需要写成 `./dogs.html`（从当前文件所在目录开始）或 `/animals/dogs.html`（明确说明要从哪个目录开始）。

当然，目录结构越复杂，绝对 URL 越长。

```
public/
├── animals/
  └── pets/
      ├── c/
      |   └── cats.html
      └── d/
          └── dogs.html
```

在这样的结构下，就想要从 `dogs.html` 链接到 `cats.html` 而言，URL 肯定是其中之一...

```html
<!-- 注意两个点，它表示源文件所在目录的上一级目录 -->
<a href="../c/cats.html">cats</a>

<!-- 或者相对于根目录 -->
<a href="/animals/pets/c/cats.html">cats</a>
```

在这种情况下值得注意的是，如果 `animals/` 被重命名为 `animal/`，就会使得绝对链接失效，但是相对链接仍会有效。这可能是使用绝对链接的缺点。当你使用绝对链接时，改变路径将会影响你的链接。

我们只研究了 HTML 文件中链接到 HTML 文件的情形，但基本上这个思路对于网页（和计算机）是通用的。例如，在 CSS 文件中，你可能有下面这样的代码：

```css
body {
  /* 当前文件所在目录下的 /images 目录里的图片 */
  background-image: url(./images/pattern.png);
}
```

...在这种情况下是正确的：

```
public/
├── images/
|   └── pattern.png
├──index.html
└── style.css
```

但是如果你移动了 CSS 文件...

```
public/
├── images/
|   └── pattern.png
├── css/
|   └── style.css
└── index.html
```

...紧接着就会出问题，是因为你的 CSS 文件现在嵌套在另一个目录中，引用路径变得更深。你需要使用两个点再次回到当前文件所在目录的上一级目录，例如 `../images/pattern.png`。

并不是哪种 URL 格式比另一种格式好 —— 它只取决于你认为当时怎样更有用、更直观。

对我来说，我在思考哪些东西最不可能改变。对于类似图像资源的东西，我发现我不太可能移动它，因此使用绝对 URL 路径（例如 `/images/pattern.png`）链接它似乎是最安全的。但是为了链接到恰好位于同一目录中的所有文档，使用相对链接的方式似乎更安全。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
