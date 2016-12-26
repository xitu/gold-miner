>* 原文链接 : [Developing small JavaScript components WITHOUT frameworks](https://jack.ofspades.com/developing-small-javascript-components-without-frameworks/)
* 原文作者 : [Jack Tarantino](https://github.com/jacopotarantino)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [L9m](https://github.com/L9m/)
* 校对者: [wild-flame](https://github.com/wild-flame), [hikerpig](https://github.com/hikerpig)

# 怎样在不使用框架的基础上开发一个 Javascript 组件

许多开发者（包括我）犯的一个错误是当遇到问题时他们总是自上而下地考虑问题。他们想问题的时候，总是从考虑框架（Framework），插件（Plugin），预处理器（Pre-processors），后处理器（Post-processors），面向对象模式（objected-oriented patterns）等等这些方面出发，他们也可能会从他们以前看过的一篇文章来考虑。而这时如果有一个生成器（Generator）的话，他们当然也愿意使用生成器提供的脚手架（Scaffold）来解决这样的问题。但是随着使用所有这些优秀的工具和强大的插件，我们往往忽略了，我们到底要构建什么，以及我们为什么要构建。在大多数场景下，我们实际上并不需要 _任何_  的这些框架！我们在 _没有_ 使用任何 JavaScript 框架和工具的情况下构建了一个简单组件实例。这篇文章给想给那些中高级程序员提个醒，其实不用框架和膨胀软件（Bloatware）也可以做事。当然，这里的经验和代码示例对初级工程师们来说也是易懂和实用的。

我们要建立一个公司员工列表（通常我说的是一个最近推文或某事的列表但他们现在需要你建立一个应用访问他们的 API，挺复杂的）。我们的产品经理想要在公司网站首页上放上最近员工的列表，并且要做到自动更新。这个列表要包括新员工的照片，名字，所在城市等信息。没什么夸张的，对吧？那么，在目前情况下，比方说公司首页是和其他代码库是分开的，而且它已经用 jQuery 做了几个动画效果。那么，这是我们的假设：

*   一个半自动更新列表
*   单页面
*   你是这个项目唯一的开发者
*   时间和资源都是无限的
*   这个页面上已经用了 jQuery

所以你从何处下手呢？你是否立即要用 Angular ？因为你知道你不花时间使用一个 `$scope.employees` 和 `ng-repeat` 。你是否要用 React ？因为它在列表中插入员工标签 **很快** 。亦或是切换到静态网页然后使用 Webpack？然后你就能用 Jade 写 HTML 用Sass 写 CSS ？因为说实话谁还会看原始的标签。不想骗你，最后一个对我 _真的_ 很有吸引力。但是我们真的需要它吗？正确的答案是 'no' 。这些东西并不能切实解决我们手上的问题。而且他们让软件栈方面变得更加令人困惑。想想如果下次另一个工程师，特别是初级工程师来接手这个项目；当另一个工程师只是做较小修改时，你并不想要他被这些花哨功能所困惑。所以，我们简单组件的代码是什么样的呢？

    <ul class="employee-list js-employee-list"></ul>  

就是它。这就是我们所有开始的地方。你可能注意到我给这个 div 添加的第二个类是以 `js-` 开始的。如果你不熟悉这种模式的话，这样做是因为我想向以后的开发者表明这个组件与 JavaScript 关联。这种方式我们就能够区分 _只是_ 为 JS 做交互的类和 只是和 CSS 绑定的类。它能让重构更容易。现在，让我们最后让这个列表变得美观 _一点_ 。（读者注意：我可能是世界上最糟的设计师）。我更喜欢使用像一种 BEM 和 SMACSS 的 CSS 结构，但是为了这个例子更简洁，这些名称和结构就先这样保留吧：

    * { box-sizing: border-box; }

    .employee-list {
      background: lavender;
      padding: 2rem 0.5rem;
      border: 1px solid royalblue;
      border-radius: 0.5rem;
      max-width: 320px;
    }

那么现在我给列表添加一些样式，虽然还没完成，但这是个过程。现在，增加一个示例员工：

    <ul class="employee-list js-employee-list">  
      <li class="employee">
        <!--   占位图服务真是很好用   -->
        <img src="http://placebeyonce.com/100-100" alt="Photo of Beyoncé" class="employee-photo">
        <div class="employee-name">Beyoncé Knowles</div>
        <div class="employee-location">Santa Monica, CA</div>
      </li>
    </ul>  

    .employee {
      list-style: none;
    }

    .employee + .employee {
      padding-top: 0.5rem;
    }

    .employee:after {
      content: ' ';
      height: 0;
      display: block;
      clear: both;
    }

    .employee-photo {
      float: left;
      padding: 0 0.5rem 0.5rem 0;
    }

棒极了！所以现在我们有一个拥有简单样式和布局的一个员工列表。那么，接下来是什么？员工的数量应该可能不只有一个。我们需要自动获取他们。我们来获取员工数据：

    // 用一个 IIFE 包裹代码，从而使它们与其他代码隔离开。
    (() => {
      // 严格模式用来防止错误和确保 ES6 特性可用
      'use strict'

      // 我们使用 jQuery 的 ajax 方法确保代码简洁
      // 从 randomuser.me 拉取数据 作为我们 'employee API' 的数据源
      // （记住这是一个假的推文列表(a fake tweet list)）
      $.ajax({
        url: 'https://randomuser.me/api/',
        dataType: 'json',
        success: (data) => {
          // 成功！我们得到数据！
          alert(JSON.stringify(data))
        }
      })
    })()

很棒！我们获得了员工数据，其间没有依靠框架和复杂的预处理器，也没有花两小时争论要选用哪个脚手架工具。目前我们使用 `alert` 函数 来替代测试框架以确保数据符合我们的预期。现在，我们需要通过一些模版解析数据去插入到 `.employee-list` 中。所以 完成之后然后来制作模版：

    $.ajax({
      url: 'https://randomuser.me/api/',
      // query string parameters to append
      data: {
        results: 3
      },
      dataType: 'json',
      success: (data) => {
          // 成功！我们获得数据！
        let employee = `<li class="employee">
            <img src="${data.results[0].picture.thumbnail}" alt="Photo of ${data.results[0].name.first}" class="employee-photo">
            <div class="employee-name">${data.results[0].name.first} ${data.results[0].name.last}</div>
            <div class="employee-location">${data.results[0].location.city}, ${data.results[0].location.state}</div>
          </li>`
          $('.js-employee-list').append(employee)
        }
      })

好极了！现在我们有了一个获取用户的脚本，把用户插入模版中，然后将模版呈现在页面上。虽然有点马虎而且只能处理一个用户。现在到重构的时间了：

    // 把员工信息转换成一块标签
    function employee_markup (employee) {  
      return `<li class="employee">
        <img src="${employee.picture.thumbnail}" alt="Photo of ${employee.name.first}" class="employee-photo">
        <div class="employee-name">${employee.name.first} ${employee.name.last}</div>
        <div class="employee-location">${employee.location.city}, ${employee.location.state}</div>
      </li>`
    }

    $.ajax({
      url: 'https://randomuser.me/api/',
      dataType: 'json',
      // 查询字符串参数
      data: {
        results: 3
      },
      success: (data) => {
        // 成功！ 我们获得了数据
        let employees_markup = ''
        data.results.forEach((employee) => {
          employees_markup += employee_markup(employee)
        })
        $('.js-employee-list').append(employees_markup)
      }
    })

现在你得到了！一个没有使用框架和任何构建流程的功能完备的小 JavaScript 组件。包含注释在内它只有 66 行代码并且完全可以扩展添加一个动画，连接，分析，之类的功能。查看以下完成的组件：

<iframe height='266' scrolling='no' src='//codepen.io/jacopotarantino/embed/MyGVOv/?height=266&theme-id=0&default-tab=js,result&embed-version=2' frameborder='no' allowtransparency='true' allowfullscreen='true' style='width: 100%;'>See the Pen <a href='http://codepen.io/jacopotarantino/pen/MyGVOv/'>MyGVOv</a> by jacopotarantino (<a href='http://codepen.io/jacopotarantino'>@jacopotarantino</a>) on <a href='http://codepen.io'>CodePen</a>.
</iframe>

源代码 [MyGVOv](http://codepen.io/jacopotarantino/pen/MyGVOv/) 作者： jacopotarantino ([@jacopotarantino](http://codepen.io/jacopotarantino)) 在 [CodePen](http://codepen.io).

现在，显然这只是一个非常非常简单的组件而且可能不能满足你特定项目的所有需求。如果你保持简单的想法，你能坚持无框架这个原则做到更多。或者，如果你的需求很多但复杂度较低，可以考虑像 Webpack 这样的构建工具。构建工具（在这个主题上）并不完全像 框架和插件它们那样完成事情。构建工具并不会在最后服务用户的代码中添加臃肿的东西，它只存在于你的工具箱中。因为我们的目标是从框架中剥离并为我们的使用者创造更好体验，和对自己来说则是创造更好管理的代码。Webpack 能处理大量繁杂的事务从而让你专注于更有意思的事。我在我的 [UI Component Generator](https://github.com/jacopotarantino/generator-ui-component) 用了它，其中还引入了非常小的框架和工具可以让你去写没有冗余的大量功能代码。当你不用 JavaScript 框架，事情可能很快变得"原始"而且代码可能变得令人困惑。所以，当你做这些组件时，要考虑一种代码结构并且坚持它。一致性是确保代码优雅的关键。

记住，最重要的是你一定要测试和给你代码编写文档。
“不写代码文档，等于没写” - [@mirisuzanne](https://twitter.com/mirisuzanne)

## 彩蛋

我做了一次标题党，而我使用了 jQuery。这只是为了简洁起见，我并不赞成使用 jQuery，你并不需要它。对于这些好奇，其实可以利用下面的原生代码来重写那些超级易懂的代码。

### 原生 JavaScript 的 AJAX 请求

不幸地这个代码没有任何简化，但你可以自己用相对少的代码来实现。

    (() => {
      'use strict'

      // 创建一个新的 XMLHttpRequest。这是在无框架情况下使用 AJAX 的方法
      const xhr = new XMLHttpRequest()
      // 声明 HTTP 请求方法和地址
      xhr.open('GET', 'https://randomuser.me/api/?results=3')
      // in a GET request what you send doesn't matter GET 请求
      // in a POST request this is the request body
      xhr.send(null)

      // 等待 'readystatechange' 状态改变去触发 xhr 对象
      xhr.onreadystatechange = function () {
        //等待 xhr 成功成功返回
        if (xhr.readyState !== 4 ) { return }
        // 非 200 状态时输出错误信息
        if (xhr.status !== 200) { return console.log('Error: ' + xhr.status) }

        // 一切正常！输出响应
        console.log(xhr.responseText)
      }
    })()

### 用原生 JavaScript 进行 DOM 插入

现在浏览器们基本接受了 jQuery 的选择器，这个超级简单。

    (() => {
      'use strict'

      const employee_list = document.querySelector('.js-employee-list')
      const employees_markup = `
        <li class="employee"></li>
        <li class="employee"></li>
        <li class="employee"></li>
      `
      employee_list.innerHTML = employees_markup
    })()

就这么简单！

### 没有采用 ES6 特性

除非是的你工作需要，否则我真的不推荐回退到 ES5，下面这些是 ES6 可以代替的。

#### 字符串插值

用 ``Photo of ${employee}.`` 替换所有的 `'Photo of ' + employee + '.'`

#### `let` 和 `const`

这个例子中的 `var` 关键字都可以用  `let` 和 `const` 关键字替代，但你自己代码你要当心。

#### 箭头函数

用 `(employee) => {` 替换 `function (employee) {` 。 再提醒一次，这个例子中代码可以被替代，但是你自己的代码你要当心。`let`， `const`，和箭头函数和 `var` 和 `function` 的作用域不同，并且如果你的代码马虎，没有结构化，在它们之间切换可能会破坏你的代码。


