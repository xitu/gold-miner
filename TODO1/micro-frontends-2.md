> * 原文地址：[Micro Frontends](https://martinfowler.com/articles/micro-frontends.html)
> * 原文作者：[Cam Jackson](https://camjackson.net/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/micro-frontends-2.md](https://github.com/xitu/gold-miner/blob/master/TODO1/micro-frontends-2.md)
> * 译者：[lihaobhsfer](https://github.com/lihaobhsfer)
> * 校对者：[动力小车](https://github.com/Stevens1995), [柯小基](https://github.com/lgh757079506)

# 微前端：未来前端开发的新趋势 — 第二部分

做好前端开发不是件容易的事情，而比这更难的是扩展前端开发规模以便于多个团队可以同时开发一个大型且复杂的产品。本系列文章将描述一种趋势，可以将大型的前端项目分解成许多个小而易于管理的部分，也将讨论这种体系结构如何提高前端代码团队工作的有效性和效率。除了讨论各种好处和代价之外，我们还将介绍一些可用的实现方案和深入探讨一个应用该技术的完整示例应用程序。

> **建议按照顺序阅读本系列文章：**
>
> * [微前端：未来前端开发的新趋势 — 第一部分](https://github.com/xitu/gold-miner/blob/master/TODO1/micro-frontends-1.md)
> * [微前端：未来前端开发的新趋势 — 第二部分](https://github.com/xitu/gold-miner/blob/master/TODO1/micro-frontends-2.md)
> * [微前端：未来前端开发的新趋势 — 第三部分](https://github.com/xitu/gold-miner/blob/master/TODO1/micro-frontends-3.md)
> * [微前端：未来前端开发的新趋势 — 第四部分](https://github.com/xitu/gold-miner/blob/master/TODO1/micro-frontends-4.md)

## 示例

想象一个网页，消费者可以在上面点外卖。表面上看起来这是一个很简单的概念，但是如果想把它做好，有非常多的细节需要考虑。

* 应该有一个引导页，消费者可以在这里浏览和搜索餐厅。这些餐厅可以通过任意数量的属性搜索或者过滤，包括价格、菜系或先前订单。
* 每一个餐厅都需要它自己的页面来显示菜单，并允许消费者选择他们想点什么，并有折扣、套餐、特殊要求这些选项。
* 消费者应该有一个用户页面来查看订单历史、追踪外卖并自定义支付选项。

![一个餐饮外卖网站的线框图](https://martinfowler.com/articles/micro-frontends/wireframe.png)

图 4：一个餐饮外卖网页可能会有几个相当复杂的页面。

每个页面都足够复杂到需要一个团队来完成。每个团队都理应能够独立地开发他们负责的页面。他们需要能够开发、测试、部署、维护他们的代码，并无需担心与其他团队的冲突与协调。我们的消费者，看到的仍然应该是一个完整、无缝的网页。

在文章接下来的部分里，当我们需要示例代码或者情景时，我们将会使用这个应用作为例子。

* * *

## 集成方式

根据前文相对宽松的定义，多种方法都能被叫做微前端。在这一节中我们会看一些例子并讨论它们的优劣。这些方法中共有一个相对自然的架构 —— 总体上讲，应用中的每一个页面都有一个微前端，然后还有唯一一个**容器应用**，用于：

* 渲染公用页面元素，如页眉页脚
* 解决跨页面的一些需求，如授权和导航
* 将多个微前端集成到页面上，并告知每个微前端何时在哪渲染自己

![一个用方框画出不同部分的网页。一个方框包含了整个页面，标记为“容器应用”，另一个方框包括了主要内容（全局页面标题和导航除外），标记为“浏览微前端”](https://martinfowler.com/articles/micro-frontends/composition.png)

图 5：你通常可以从页面结构推出你的架构

### 服务端模板编写

我们从一个很常见的前端开发方法开始 —— 在服务器端基于一些模板和代码片段渲染 HTML 页面。我们有一个 `index.html` 文件，包含所有公用的页面元素，然后我们用服务器端的 `includes` 来加入从 HTML 文件片段提取的页面内容：

```
<html lang="en" dir="ltr">
  <head>
    <meta charset="utf-8">
    <title>Feed me</title>
  </head>
  <body>
    <h1>🍽 Feed me</h1>
    <!--# include file="$PAGE.html" -->
  </body>
</html>
```

我们用 Nginx 来提供这个文件，配置 `$PAGE` 变量，将其与请求的 URL 匹配。
```
server {
    listen 8080;
    server_name localhost;

    root /usr/share/nginx/html;
    index index.html;
    ssi on;

    # 重定向 / 至 /browse
    rewrite ^/$ http://localhost:8080/browse redirect;

    # 根据URL确定要插入哪个 HTML 片段
    location /browse {
      set $PAGE 'browse';
    }
    location /order {
      set $PAGE 'order';
    }
    location /profile {
      set $PAGE 'profile'
    }

    # 所有位置都应经 index.html 渲染
    error_page 404 /index.html;
}
```

这是一个相对标准的服务端组合。我们能够将其称为微前端的原因是，我们将代码分离，这样每一部分代码都是一个自我包含的领域概念，并能够被一个独立的团队开发。我们没有看到的是，这些不同的 HTML 文件最后如何到了服务器端，但是我们假设每一个页面都有它们自己的部署流程，允许我们对一个页面部署修改，同时不影响或者无需考虑其他页面。

对于更大的独立性，每一个微前端都可以由独立的服务器来负责渲染，并由一个服务器负责向剩下的发送请求。使用精心设计的缓存来存储响应，这种实施方案不会影响延迟。

![一个流程图，展示浏览器向“容器应用服务器”发送请求，该服务器随后向“浏览微前端服务器”或“订单微前端服务器”发送请求](https://martinfowler.com/articles/micro-frontends/ssi.png)

图 6：每一个服务器都可以独立构建和部署

这个例子展示为何微前端不是一个新技术，并且不需要很复杂。只要我们仔细考虑我们的设计决定如何影响代码库和团队的自治，我们就能获取同样多的便利，无论我们的技术栈是什么。

### 构建时集成

我们有时会看到一种方法，即以一个包来发布每一个微前端，然后由容器应用引入这些包作为库依赖。我们示例应用的容器的 `package.json` 可能是这样：

```
{
  "name": "@feed-me/container",
  "version": "1.0.0",
  "description": "A food delivery web app",
  "dependencies": {
    "@feed-me/browse-restaurants": "^1.2.3",
    "@feed-me/order-food": "^4.5.6",
    "@feed-me/user-profile": "^7.8.9"
  }
}
```

乍一看这可能有道理。它产出单个可部署的 JavaScript 包，和往常一样，允许我们从我们多样的应用中解耦公用依赖。然而，这个方法意味着，为了在产品任意一个部分发布修改，我们必须重新编译和发布每一个微前端。如同微服务一样，我们已经体会过了这种**因循守旧的发布流程**带来的痛苦，以至于我们强烈反对在微前端使用同样的方法。

踩过了将应用分为离散的、可独立开发测试的代码库带来的所有的坑，我们就不再介绍发布阶段的耦合问题了。我们需要找到一个在运行时集成微前端的方法，而非构造时方法。

### 通过 iframes 运行时集成

将应用组合到浏览器的一个最简便的方法便是使用 iframe。其特性让使用独立的子页面构建一个页面变得简单。它也提供了一个不错的分离性，包括样式和全局变量互不干扰。

```
<html>
  <head>
    <title>Feed me!</title>
  </head>
  <body>
    <h1>Welcome to Feed me!</h1>

    <iframe id="micro-frontend-container"></iframe>

    <script type="text/javascript">
      const microFrontendsByRoute = {
        '/': 'https://browse.example.com/index.html',
        '/order-food': 'https://order.example.com/index.html',
        '/user-profile': 'https://profile.example.com/index.html',
      };

      const iframe = document.getElementById('micro-frontend-container');
      iframe.src = microFrontendsByRoute[window.location.pathname];
    </script>
  </body>
</html>
```

和[服务端的引入选项](#服务端模板编写)一样，用 iframes 构建页面不是一个新的技术，而且可能不是很令人兴奋。但如果我们重温[之前提过](https://github.com/xitu/gold-miner/blob/master/TODO1/micro-frontends-1.md#%E4%BC%98%E7%82%B9)的微前端的好处，iframes 几乎都有，只要我们仔细考虑如何将应用分成独立部分、如何构建团队。

我们经常看到很多人不愿意选择 iframes。虽然部分原因似乎是直觉感觉 iframe 有点“糟糕”，但人们也有很好的理由不使用它们。上面提到的简单隔离确实会使它们比其他选项更不灵活。在应用程序的不同部分之间构建集成可能很困难，因此它们使路由，历史记录和深层链接变得更加复杂，并且它们对使页面完全响应性提出了一些额外的挑战。

### 通过 JavaScript 运行时集成

我们将要讨论的下一个方法可能是最灵活的、团队采用最频繁的一个。每一个微前端都用 `<script>` 标签放入页面，在加载时会暴露一个全局函数作为入口。容器应用接下来决定挂载哪个微前端，并调用相关函数告诉一个微前端何时在哪渲染。

```
<html>
  <head>
    <title>Feed me!</title>
  </head>
  <body>
    <h1>Welcome to Feed me!</h1>

    <!-- 这些脚本不会立即渲染任何元素 -->
    <!-- 相反它们将每一个入口函数挂载在 `window` 上 -->
    <script src="https://browse.example.com/bundle.js"></script>
    <script src="https://order.example.com/bundle.js"></script>
    <script src="https://profile.example.com/bundle.js"></script>

    <div id="micro-frontend-root"></div>

    <script type="text/javascript">
      // 这些全局函数会通过上面的脚本挂在 window 对象上
      const microFrontendsByRoute = {
        '/': window.renderBrowseRestaurants,
        '/order-food': window.renderOrderFood,
        '/user-profile': window.renderUserProfile,
      };
      const renderFunction = microFrontendsByRoute[window.location.pathname];

      // 决定好入口函数之后，我们现在调用它，给它提供元素的 ID 来告诉它在哪里渲染
      renderFunction('micro-frontend-root');
    </script>
  </body>
</html>
```

以上显然是一个比较初始的例子，但它演示了基本技术。与构建时集成不同，我们可以独立部署每个 `bundle.js` 文件。与 iframe 不同，我们有充分的灵活性来以我们偏好的方式构建微前端之间的集成。我们可以通过多种方式扩展上述代码，例如，只根据需要下载每个 JavaScript 包，或者在呈现微前端时传入和传出数据。

这一方法的灵活性，与独立部署性结合，使它成为了我们的默认选择，并且是最为常见的一种选择。当我们到了[完整示例](https://github.com/xitu/gold-miner/blob/master/TODO1/micro-frontends-2.md#案例详解)时我们将会探索这方面的更多细节。

### 通过网页组件运行时集成

前面这种方法的一个变种就是，对于每一个微前端，定义一个 HTML 自定义元素让容器来构建，而非定义一个全局函数来让容器调用。

```
<html>
  <head>
    <title>Feed me!</title>
  </head>
  <body>
    <h1>Welcome to Feed me!</h1>

    <!-- 这些脚本不会立即渲染任何元素 -->
    <!-- 相反它们每一个都定义一个自定义元素类型 -->
    <script src="https://browse.example.com/bundle.js"></script>
    <script src="https://order.example.com/bundle.js"></script>
    <script src="https://profile.example.com/bundle.js"></script>

    <div id="micro-frontend-root"></div>

    <script type="text/javascript">
      // 这些元素类型是由上述脚本定义的
      const webComponentsByRoute = {
        '/': 'micro-frontend-browse-restaurants',
        '/order-food': 'micro-frontend-order-food',
        '/user-profile': 'micro-frontend-user-profile',
      };
      const webComponentType = webComponentsByRoute[window.location.pathname];

      // 决定了正确的网页组件，我们现在创建了一个实体并把它挂在 document 上
      const root = document.getElementById('micro-frontend-root');
      const webComponent = document.createElement(webComponentType);
      root.appendChild(webComponent);
    </script>
  </body>
</html>
```

这里的最终结果与前面的示例非常相似，主要区别在于选择以 “网页组件方式” 进行操作。如果您喜欢网页组件规范，并且您喜欢使用浏览器提供的功能，那么这是一个不错的选择。如果你更喜欢在容器应用程序和微前端之间定义自己的接口，那么你可能更喜欢前面的示例。

* * *

## 样式

CSS 作为一种语言本质上是全局的，继承和级联的，传统上没有模块系统，命名空间或封装。其中一些功能确实存在，但通常缺乏浏览器支持。在微观前沿领域，许多这些问题都在恶化。例如，如果一个团队的微前端有一个样式表，上面写着 `h2 { color: black; }`，另一个人说 `h2 { color: blue; }`，并且这两个选择器都附加到同一页面，然后有人就会不高兴了！这不是一个新问题，但由于这些选择器是由不同团队在不同时间编写的，而且代码可能分散在不同的代码库中，因此更难以发现。

近几年来，人们想出了很多解决方案来使 CSS 更易于管理。有些人选择使用严格的命名规范，比如 [BEM](http://getbem.com/)，来确保选择器只会在想要的地方起作用。另外一部分人则选择不仅仅依赖于开发者规则，使用一个预处理器，如 [SASS](https://sass-lang.com/)，其选择器嵌套可以用做一种命名空间。一种更新的解决方案是将所有样式以程序的方式，用 [CSS modules](https://github.com/css-modules/css-modules) 或者众多 [CSS-in-JS](https://mxstbr.com/thoughts/css-in-js/) 库的一个来应用，以保证样式只应用在开发者想要的地方。或者，[shadow DOM](https://developer.mozilla.org/en-US/docs/Web/Web_Components/Using_shadow_DOM) 也以一种更加基于平台的方式提供样式分离。

你选择的方法并不重要，只要你找到一种方法来确保开发人员可以彼此独立地编写样式，并确信他们的代码在组合到单个应用程序中时可以预测。

* * *

## 共享组件库

我们在上面提到过，微前端的视觉一致性很重要，其中一种方法是开发一个共享的，可重用的 UI 组件库。总的来说，我们认为这是一个好主意，虽然很难做好。创建这样一个库的主要好处是通过重用代码减少工作量，并提供视觉一致性。此外，你的组件库可以作为一个样式​​指南，它可以是开发人员和设计人员之间的一个很好的协作点。

最容易出错的地方之一就是过早地创建太多这些组件。创建一个包含所有应用程序所需的所有常见视觉效果的[基础框架](https://martinfowler.com/bliki/FoundationFramework.html)很有吸引力，但是，经验告诉我们，在实际使用它们之前，很难（如果不是不可能的话）猜测组件的API应该是什么，这会导致组件早期的大量波动。出于这个原因，我们更愿意让团队在他们需要的时候在他们的代码库中创建自己的组件，即使这最初会导致一些重复。允许模式自然出现，一旦组件的API变得明显，你可以使用 [harvest](https://martinfowler.com/bliki/HarvestedFramework.html) 将重复的代码放入共享库中并确信这些已经被证明有效。

最明显的可供分享的组件是比较“傻”的视觉基元，如图标，标签和按钮。我们也可以共享一些复杂组件，他们可能会包含大量的 UI 逻辑，如自动补全和下拉菜单搜索框。或者是可排序、可过滤的分页表。但是，请务必确保共享组件仅包含 UI 逻辑，并且不包含业务或域逻辑。将域逻辑放入共享库时，它会在应用程序之间创建高度耦合，并增加更改的难度。因此，例如，通常不应该尝试共享一个 `ProductTable`，它会包含关于“产品”究竟是什么以及应该如何表现的各种假设。这种域建模和业务逻辑属于微前端的应用程序代码，而不是共享库中。

与任何共享的内部库一样，围绕其所有权和治理存在一些棘手的问题。一种模式是说作为共享资产，“每个人”拥有它，但在实践中，这通常意味着**没有人**拥有它。它很快就会充满杂乱的风格不一致的代码，没有明确的约定或技术愿景。另一方面，如果共享库的开发完全集中化，那么创建组件的人与使用它们的人之间将存在很大的脱节。我们看到的最好的模型是任何人都可以为库做出贡献的模型，但是有一个[保管人](https://martinfowler.com/bliki/ServiceCustodian.html)（一个人或一个团队）负责确保这些贡献的质量，一致性和有效性。维护共享库的工作需要强大的技术技能，还需要培养许多团队之间协作所需的人员技能。

> **建议按照顺序阅读本系列文章：**
>
> * [微前端：未来前端开发的新趋势 — 第一部分](https://github.com/xitu/gold-miner/blob/master/TODO1/micro-frontends-1.md)
> * [微前端：未来前端开发的新趋势 — 第二部分](https://github.com/xitu/gold-miner/blob/master/TODO1/micro-frontends-2.md)
> * [微前端：未来前端开发的新趋势 — 第三部分](https://github.com/xitu/gold-miner/blob/master/TODO1/micro-frontends-3.md)
> * [微前端：未来前端开发的新趋势 — 第四部分](https://github.com/xitu/gold-miner/blob/master/TODO1/micro-frontends-4.md)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
