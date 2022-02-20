> * 原文地址：[Best Practices for Cookie Notifications](https://blog.bitsrc.io/best-practices-for-cookie-notifications-956aa9ded8d5)
> * 原文作者：[Ravidu Perera](https://raviduperera.medium.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2022/best-practices-for-cookie-notifications.md](https://github.com/xitu/gold-miner/blob/master/article/2022/best-practices-for-cookie-notifications.md)
> * 译者：[jaredliw](https://github.com/jaredliw)
> * 校对者：[Z招锦](https://github.com/zenblofe)、[CarlosChenN](https://github.com/CarlosChenN)

# Cookie 通知的最佳实践

![](https://miro.medium.com/max/1400/1*F3LnyRex1n6ymjO0kAK8uQ.jpeg)

Cookie 是一些简短字符串，主要用于身份验证以建立用户会话。近些年来，cookie 也用于追踪用户信息（例如浏览器的设置和偏好）来提升网站的用户体验。

根据[通用数据保护条例 (GDPR)](https://gdpr.eu/)，所有的网站都必须通知用户关于网站在 cookie 中追踪的数据内容。

这篇文章会探讨一些 cookie 通知时应遵循的最佳实践，以尽量减少其对用户体验（UX）和用户界面（UI）的影响。

## Cookie 通知会破坏用户体验吗？

虽然通知用户 cookie 所追踪的数据非常重要，但如果其没有正确地实现，用户体验将会受到影响。

以下是 cookie 通知阻碍用户体验的一些场景。

### 1. 移动端上突兀的 cookie 通知

移动端上一个突兀的 cookie 通知例子：

![](https://miro.medium.com/max/648/1*fIM25m26dEOvn9AXxg6Cyw.jpeg)

上图这种通知会遮挡大部分的屏幕空间，从而阻碍用户访问页面上的内容。此类通知将会影响网站的可用性。

### 2. 形同虚设选项的 cookie 通知

没有拒绝选项的 cookie 通知：

![](https://miro.medium.com/max/1400/1*VrClO6qQqkadtc-IglOJyA.gif)

如上所示，没有适当的 cookie 使用描述、没有更改偏好或是拒绝选项的 cookie 通知将误导用户，并最终迫使他们接受所有的 cookie。

强制用户接受条款的 cookie 通知：

![](https://miro.medium.com/max/1400/1*RvjGTBhLkxPwXVhQQer9mQ.jpeg)

## 构建 cookie 通知的最佳实践

让我们看看一些 cookie 通知的最佳实践吧！

### 1. 正确地放置通知

Cookie 通知通常放置在页面的顶部、底部或者角落。这样使得网站的主要内容不会被通知阻挡。

放在页面角落的 cookie 通知：

![](https://miro.medium.com/max/1400/1*ZJGlv46qCAV3vJMZD4qHcA.jpeg)

最好的实践方式是将通知放在页面底部；这样一来，主要内容仍然能按预期展示，并且通知在页面中不会显得那么突兀。

推荐的 cookie 通知放置位置：

![](https://miro.medium.com/max/1400/1*j-YvaPBrmDfOi7DLlpYU9w.jpeg)

不管通知的位置如何，确保其占用最小的空间是非常重要的。

Cookie 通知也可以通过弹窗（modal view）展示。然而，这会将用户的注意力从内容上移开；我们应该谨慎地使用这种方式。可惜的是，弹窗展示现如今仍是大多数需要 cookie 同意的网站所采用的策略。

一个占用太多不必要空间的 cookie 通知：

![](https://miro.medium.com/max/1400/1*WqUQXE96jIhEzT-i2osw9Q.jpeg)

（图片来源：[awin.com](https://www.awin.com/gb)）

### 2. 移动端适配

在移动端浏览网页时，就算是一个 header 或 footer 都可能占用页面大部分的空间。

因此，我们需要确保通知是响应式的，且在移动设备上占用最少的屏幕空间。

移动端上的通知大小对比：

![](https://miro.medium.com/max/1400/1*-ytctuRnGgmqsAJ_H_rWVg.png)

上方的例子说明了在移动端上占用更少空间的 cookie 通知（图 2）能让用户感到更舒服且也不那么突兀。

### 3. 正确且具描述性的按钮

> 为用户提供简短的 cookie 使用描述和允许/拒绝/更改设定的选项。

具有描述性的 cookie 通知：

![](https://miro.medium.com/max/1204/1*WWWk7cHB5d1gi7y04qaSgg.png)

包含自定义选项和具描述性的按钮的 cookie 通知：

![](https://miro.medium.com/max/1400/1*Erxgrbp_Oe81dKbetM_YeA.jpeg)

### 4. 提供灵活的自定义功能

> 提供用户自定义 cookie 偏好的选项能让用户更好地掌控网站追踪的数据。

这些功能包括：

- 更改 cookie 偏好的设置；
- 让用户能启用非必要的 cookie 以提升用户体验；
- 不同 cookie 类别的功能概述，并附上推荐类别的指示。

包含自定义选项的 cookie 通知：

![](https://miro.medium.com/max/1400/1*aEoLyNmfTCbcybVjiM801g.gif)

在 cookie 设置里，将选项分组是非常重要的；它能帮助用户快速地确认并选择需要的组别，而不是手动选择/取消每一个子选项。

一般的 cookie 是很容易就能被删除的，但删除它们可能导致部分网站难以浏览。此外，如果不使用 cookie，用户在每次浏览网站时都得重新输入他们的数据。不同的浏览器将 cookie 存储在不同的地方。

将 cookie 设置分组的例子：

![](https://miro.medium.com/max/612/1*OsxtTBCotBzRNnPPNNQR6g.png)

为每一个 cookie 类别添加简短的说明能帮助用户确定选择哪些类别以获得更好的用户体验。

为每个 cookie 类别提供描述信息以更好地指引用户：

![](https://miro.medium.com/max/946/1*G2CCo0IbJ1VKnxxeQCwnvw.jpeg)

### 5. 默认禁用非必要的 cookie

> 默认启用运行网站必要的 cookie，并允许用户在设定里选择启用其他非必要的 cookie。

[StackExchange](https://stackexchange.com/) 默认禁用了非必要的 cookie：

![](https://miro.medium.com/max/1400/1*FjvcIYXsa0dthqNKalbc5A.jpeg)

> 注：如果网站只收集匿名数据且不违反 GDPR，你可以选择不展示 cookie 通知。

大部分的 cookie 仅用于持久化状态。Cookie 能让你在网站上保持登录状态。这意味着你每次浏览该网站时都会处于登录状态，节省了重新输入密码的时间和精力。你的账号将被退出如果你删除了你的 cookie。

某些网站也可能会使用第三方 cookie；这些 cookie 不会侵犯你的隐私，禁用这些 cookie 可能会导致网站出现问题。

### 6. 提高 cookie 通知的性能

一些网站会使用第三方管理 cookie 脚本或服务来管理 cookie 通知。

通过异步加载 cookie 脚本，我们能确保这些脚本不会阻碍页面的加载。

异步加载第三方脚本：

```html
<script src="https://mycookies.com/add-new-script.js" async>
```

然而，异步加载可能导致页面闪烁；这是因为在原始网站加载完成的不久以后页面又发生了变化。

我们可以透过一些工具（如 [CookieScript 扫描](https://cookie-script.com/)）查看 cookie 的使用情况，协助我们提升 cookie 的性能。

我的 [Medium](https://medium.com/) 页面的 cookie 报告：

![](https://miro.medium.com/max/1120/1*-WPvGdDywd4kCxvLKLzPCA.png)

# 总结

Cookie 在维持网站动态性中扮演了重要的角色。因此，网站应通过 cookie 通知告诉用户有关网站上的个人数据存储，并获取他们的同意。

开发者有责任将这些必要的通知以一种使用者有好的方式展现，尽可能地减少其对 UI 和 UX 的影响。

希望文章中讨论的这些最佳实践方案能帮助你在考虑 UI 和 UX 的情况下更好地构建 cookie 通知功能。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
