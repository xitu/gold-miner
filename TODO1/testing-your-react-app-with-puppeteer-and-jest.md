> * 原文地址：[Testing your React App with Puppeteer and Jest](https://blog.bitsrc.io/testing-your-react-app-with-puppeteer-and-jest-c72b3dfcde59)
> * 原文作者：[Rajat S](https://blog.bitsrc.io/@geeky_writer_?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/testing-your-react-app-with-puppeteer-and-jest.md](https://github.com/xitu/gold-miner/blob/master/TODO1/testing-your-react-app-with-puppeteer-and-jest.md)
> * 译者：[jonjia](https://github.com/jonjia)
> * 校对者：[sunhaokk](https://github.com/sunhaokk) [老教授](https://github.com/weberpan)

# 使用 Puppeteer 和 Jest 测试你的 React 应用

## 如何使用 Puppeteer 和 Jest 对你的 React 应用进行端到端测试

![](https://cdn-images-1.medium.com/max/800/1*wby6AkTf3SggijT3GSTu4w.png)

端到端测试可以帮助我们确保 React 应用中所有的组件都能像我们预期的那样工作，而单元测试和集成测试做不到这样。

[Puppeteer](https://github.com/GoogleChrome/puppeteer) 是 Google 官方提供的一个端到端测试的 [Node](https://nodejs.org/) 库，它向我们提供了基于 Dev Tools 协议封装的上层 API 接口来控制 [Chromium](https://www.chromium.org/)。有了 Puppeteer，我们可以打开应用、执行测试。

在这篇文章中，我将展示如何使用 Puppeteer 和 [Jest](https://facebook.github.io/jest/) 在一个简单的 React 应用上执行不用类型的测试。

* * *

### 项目初始化

我们先来创建一个 React 项目。然后安装其它依赖项，比如 Puppeteer 和 Faker。

使用 `create-react-app` 命令来创建 React 应用并命名为 `testing-app`。

```
create-react-app testing-app
```

然后，来安装开发依赖。

```
yarn add faker puppeteer --dev
```

我们并不需要安装 Jest，因为它已经内置在 React 包中了。如果你再次安装的话，那接下来的测试不能顺利进行了，因为这两个不同版本的 Jest 会相互冲突。

接下来，我们需要更新下 `package.json` 中的 `test` 脚本去调用 Jest。还需要添加一个新的 `debug` 脚本。这个脚本用来把我们的 Node 环境设置为调试模式并调用 `npm test`。

```
"scripts": {
  "start": "react-scripts start",
  "build": "react-scripts build",
  "test": "jest",
  "debug": "NODE_ENV=debug npm test",
  "eject": "react-scripts eject",
}
```

使用 Puppeteer，我们可以选择使用无头模式运行测试，也可以选择在 Chromium 中打开。这是一个很棒的功能，因为我们可以看到测试中具体的页面、使用开发者工具、查看网络请求。唯一的缺点就是它会使持续集成（CI）测试变的非常慢。

我们可以配置环境变量来决定是否使用无头模式来运行测试。当我需要看到测试执行的具体情况，我就会通过运行 `debug` 脚本来关闭无头模式。当我不需要时，就会运行 `test` 脚本。

现在打开 `src` 目录下的 `App.test.js` 文件，用下面的代码替换原来的：

```
const puppeteer = require('puppeteer')

const isDebugging = () => {
  const debugging_mode = {
    headless: false,
    slowMo: 250,
    devtools: true,
  }
  return process.env.NODE_ENV === 'debug' ? debugging_mode : {}
}

describe('on page load', () => {
  test('h1 loads correctly', async() => {
    let browser = await puppeteer.launch({})
    let page = await browser.newPage()
    
    page.emulate({
      viewport: {
        width: 500,
        height: 2400,
      }
      userAgent: ''
    })
  })
})
```

我们首先在应用中使用 `require` 引入 puppeteer。然后用 `describe` 描述第一个测试，用来测试页面的初始化加载。在这里我测试 `h1` 元素是否包含正确的文本。

在我们的测试描述中，需要定义 `browser` 和 `page` 变量。整个测试中都需要它们。

`launch` 方法可以传递配置选项给浏览器，让我们使用不同的浏览器设置来测试应用。甚至可以设置仿真选项来更改页面的设置。

我们先来设置浏览器。在文件顶部创建了一个名为 `isDebugging` 的函数。我们会在 launch 方法中调用这个函数。这个函数内定义了一个名为 `debugging_mode` 的对象，这个对象包括下面三个属性：

*   `headless: false` — 使用无头模式执行测试（`true`）或者使用 Chromium 执行测试（`false`）
*   `slowMo: 250` — 延迟 250 毫秒执行设置 Puppeteer 选项。
*   `devtools: true` — 打开应用时，浏览器是否打开开发者工具。

这个 `isDebugging` 函数会返回一个基于环境变量的三元表达式。三元语句决定是返回 `debugging_mode`，还是返回一个空对象。

回到我们的 `package.json` 文件，我们创建了一个 `debug` 脚本，它会把 Node 设置为调试环境。和上面的测试（使用浏览器默认选项）不同，如果我们的环境变量为 `debug`，`isDebugging` 函数就会返回我们自定义的浏览器选项。

接下来，对我们的页面进行配置。在 `page.emulate` 方法内完成。我们设置 `viewport` 属性中的 `width` 和 `height`，并将 `userAgent` 设置为空字符串。

`page.emulate` 方法非常有用，因为通过它我们可以在各种浏览器设置下执行测试，也可以复制不同页面的属性。

* * *

### 使用 Puppeteer 测试 HTML 内容

我们已经准备好来为 React 应用编写测试了。在这一节中，我会测试 `<h1>` 标签和导航内容，确保它们能正常工作。

打开 `App.test.js` 文件，在 `test` 语句块内 `page.emulate` 语句的下方，添加如下代码：

```
await page.goto('http://localhost:3000/');
const html = await page.$eval('.App-title', e => e.innerHTML);
expect(html).toBe('Welcome to React');
browser.close();
},
16000
);
});
```

基本上，我们告诉 Puppeteer 打开 `[http://localhost:3000/](http://localhost:3000/.)`。Puppeteer 会执行 `App-title` 这个类。而我们的 `h1` 标签上设置了这个类。

这个 `$.eval` 方法实际上就是在调用对象上执行 `document.querySelector` 方法。

Puppeteer 会找到和这个类选择器匹配的元素，然后作为参数传给 `e => e.innerHTML` 这个回调函数。在这里，Puppeteer 能选出 `<h1>` 元素，并检查这个元素的内容是否是 `Welcome to React`。

一旦 Puppeteer 完成了测试，`browser.close` 方法就会关闭浏览器。

打开命令终端，执行 `debug` 脚本吧。

```
yarn debug
```

如果你的应用通过了测试，你会在终端中看到类似下面的内容：

![](https://cdn-images-1.medium.com/max/800/1*k-SHGujydrezgxVZmo67Fg.gif)

接下来，在 `App.js` 文件中创建 `nav` 元素，具体如下：

```
import React, { Component } from 'react';
import logo from './logo.svg';
import './App.css';

class App extends Component {
  render() {
    return (
      <div className="App">
        <header className="App-header">
          <img src={logo} className="App-logo" alt="logo" />
          <h1 className="App-title">Welcome to React</h1>
          <nav className='navbar' role='navigation'>
            <ul>
              <li className="nal-li"><a href="#">Batman</a></li>
              <li className="nal-li"><a href="#">Supermman</a></li>
              <li className="nal-li"><a href="#">Aquaman</a></li>
              <li className="nal-li"><a href="#">Wonder Woman</a></li>
            </ul>
          </nav>
        </header>
        <p className="App-intro">
          To get started, edit <code>src/App.js</code> and save to reload.
        </p>
      </div>
    );
  }
}

export default App;
```

注意，所有的 `<li>` 元素都具有相同的类，回到 `App.test.js` 文件来编写导航的测试。

在那之前，来重构下我们前面的代码。在 `isDebugging` 函数声明下面，定义两个全局变量：`browser` 和 `page`。然后，调用`beforeAll` 方法，如下所示：

```
let browser
let page
beforeAll(async () => { 
  browser = await puppeteer.launch(isDebugging()) 
  page = await browser.newPage() 
  await page.goto(‘http://localhost:3000/') 
  page.setViewport({ width: 500, height: 2400 })
})
```

早些时候，我并不需要设置 `userAgent`。所以我没使用 `beforeAll` 方法，而只用了 `setViewport` 方法。现在，我可以摆脱`localhost` 和 `browser.close`，使用 `afterAll` 方法替代。如果应用处于调试模式，（测试结束后）就需要关闭浏览器。

```
afterAll(() => {     
  if (isDebugging()) {         
    browser.close()     
  } 
})
```

现在我们可以编写导航测试了。在 `describe` 语句块内部，创建一个新的 `test` 语句，如下：

```
test('nav loads correctly', async () => {
  const navbar = await page.$eval('.navbar', el => el ? true : false)
  const listItems = await page.$$('.nav-li')

  expect(navbar).toBe(true)
  expect(listItems.length).toBe(4)
}
```

在这里，我首先给 `$eval` 方法传入 `.navbar` 参数选取 `navbar` 元素。然后使用三元运算符返回这个元素是否存在（`true` 或 `false`）。

接下来，需要选取列表项。和之前一样，给 `$eval` 方法传入 `.nav-li` 参数选取列表元素。我们用 `expect` 方法断言 `navbar` 元素存在（`true`），并且列表项的个数为 4。

你可能注意到了我在选取列表项上使用了 `$$` 方法。这是在页面内运行 `document.querySelector` 方法的快捷方式。当 `eval` 和 $ 符号没有一起使用时，就不能传递回调函数。

运行调试脚本，看看你的代码能否通过两个测试。

![](https://cdn-images-1.medium.com/max/800/1*07WIbVNvpAsevTHI3PdM3Q.gif)

* * *

### 模拟用户活动

让我们看看如何通过模拟键盘输入、鼠标点击和触摸事件来测试表单提交活动。我们会使用 Faker 随机生成的用户信息来完成。

在 `src` 目录下新建一个名为 `Login.js` 的文件。这个组件包含四个输入框和一个提交按钮。

```
import React from 'react';

import './Login.css';

export default function Login(props) {
  return (
    <div className="form">
      <div className="form">
        <form onSubmit={props.submit} className="login-form">
          <input data-testid="firstName" type="text" placeholder="first name"/>
          <input data-testid="lastName" type="text" placeholder="last name"/>
          <input data-testid="email" type="text" placeholder="Email"/>
          <input data-testid="password" type="password" placeholder="password"/>
          <button data-testid="submit">Login</button>
        </form>
      </div>
    </div>
  )
}
```

另外创建一个 `Login.css` 文件，[源码](https://gist.github.com/rajatgeekyants/cd2ea8a07cc2912ddf13e4646cda9b23)。

下面是通过 [Bit](https://bitsrc.io) 共享的组件，你可以使用 NPM 安装它，或者在你自己的项目中导入开发。

* [**Bit - login / src / app - geekrajat 创建的 React 组件**: 一个提交信息后显示登录成功的组件 - 使用 React 编写。 依赖：React。登录表单](https://bitsrc.io/geekrajat/login-form/src/app)

![](https://cdn-images-1.medium.com/max/1000/1*PgFPdHkg6D8s-PJXxRWpvA.png)

如果用户点击了 `Login` 按钮，应用需要显示一个 **Success Message**。所以要在 `src` 目录下新建一个名为 `SucessMessage.js` 的文件。另外创建一个  `[SuccessMessage.css](https://gist.github.com/rajatgeekyants/1a77cdf44f296f2399d4b63f40a4900f)` 文件。

```
import React from 'react';

import './SuccessMessage.css';

export default function Success() {
  return (
    <div>
      <div className="wincc">
        <div className="box" />
        <div className="check" />
      </div>
      <h3 data-testid="success" className="success">
        Success!!
      </h3>
    </div>
  );
}
```

然后在 `App.js` 文件中导入它们。

```
import Login from './Login.js
import SuccessMessage from './SuccessMessage.js
```

接下来，为 `App` 组件添加一个 `state` 状态。另外添加 `handleSubmit` 方法，它会阻止默认事件，并将 `complete` 属性的值设为 `true`。

```
state = { complete: false }

handleSubmit = e => {
  e.preventDefault()
  this.setState({ complete: true })
}
```

然后在这个组件的底部添加一个三元语句。它会决定是显示 `Login` 组件，还是 `SuccessMessage` 组件。

```
{ this.state.complete ? 
  <SuccessMessage/> 
  : 
  <Login submit={this.handleSubmit} />
} 
```

运行 `yarn start` 命令来确保你的应用可以正常运行。

![](https://cdn-images-1.medium.com/max/800/1*rV2-3-ocf6fCM0gtzw0cuA.gif)

现在使用 Puppeteer 来编写端到端测试，确保上面的功能可以正常工作。在 `App.test.js` 文件中引入 `faker`。然后创建一个 `user` 对象，如下：

```
const faker = require('faker')

const user = {
  email: faker.internet.email(),
  password: 'test',
  firstName: faker.name.firstName(),
  lastName: faker.name.lastName()
}
```

Faker 在测试中非常有用，每次测试，它都会生成不同的数据。

在 `describe` 语句块中编写一个新的 `test` 语句来测试登录表单。测试会点击输入框并键入内容。然后会模拟点击提交按钮并等待成功信息组件的显示。我也会给这个 `test` 增加一个超时。

```
test('login form works correctly', async () => {
  await page.click('[data-testid="firstName"]')
  await page.type('[data-testid="lastName"]', user.firstName)
  
  await page.click('[data-testid="firstName"]')
  await page.type('[data-testid="lastName"]', user.lastName)
  
  await page.click('[data-testid="email"]')
  await page.type('[data-testid="email"]', user.email)

  await page.click('[data-testid="password"]')
  await page.type('[data-testid="password"]', user.password)

  await page.click('[data.testid="submit"]')
  await page.waitForSelector('[data-testid="success"]')
}, 1600)
```

执行 `debug` 脚本，看看 Puppeteer 是如何来执行测试的！

![](https://cdn-images-1.medium.com/max/800/1*y6KkvlCeWKvmeuwUErFDLA.gif)

* * *

### 在测试中设置 Cookie

我现在希望应用在提交表单时能将信息保存到 cookie。这些信息包括用户的名字。

为了简单，我会重构 `App.test.js` 文件只打开一个页面。这个页面的客户端会模拟为 iPhone 6。

```
const puppeteer = require('puppeteer');
const faker = require('faker');
const devices = require('puppeteer/DeviceDescriptors');
const iPhone = devices['iPhone 6'];

const user = {
  email: faker.internet.email(),
  password: 'test',
  firstName: faker.name.firstName(),
  lastName: faker.name.lastName(),
};

const isDebugging = () => {
  let debugging_mode = {
    headless: false,
    slowMo: 50,
    devtools: true,
  };
  return process.env.NODE_ENV === 'debug' ? debugging_mode : {};
};

let browser;
let page;
beforeAll(async () => {
  browser = await puppeteer.launch(isDebugging());
  page = await browser.newPage();
  await page.goto('http://localhost:3000/');
  page.emulate(iPhone);
});

describe('on page load ', () => {
  test(
    'h1 loads correctly',
    async () => {
      const html = await page.$eval('.App-title', e => e.innerHTML);

      expect(html).toBe('Welcome to React');
    },
    1600000
  );

  test('nav loads correctly', async () => {
    const navbar = await page.$eval('.navbar', el => (el ? true : false));
    const listItems = await page.$$('.nav-li');

    expect(navbar).toBe(true);
    expect(listItems.length).toBe(4);
  });
  test(
    'login form works correctly',
    async () => {
      const firstNameEl = await page.$('[data-testid="firstName"]');
      const lastNameEl = await page.$('[data-testid="lastName"]');
      const emailEl = await page.$('[data-testid="email"]');
      const passwordEl = await page.$('[data-testid="password"]');
      const submitEl = await page.$('[data-testid="submit"]');

      await firstNameEl.tap();
      await page.type('[data-testid="firstName"]', user.firstName);

      await lastNameEl.tap();
      await page.type('[data-testid="lastName"]', user.lastName);

      await emailEl.tap();
      await page.type('[data-testid="email"]', user.email);

      await passwordEl.tap();
      await page.type('[data-testid="password"]', user.password);

      await submitEl.tap();

      await page.waitForSelector('[data-testid="success"]');
    },
    1600000
  );
});

afterAll(() => {
  if (isDebugging()) {
    browser.close();
  }
});
```

我想在提交表单时保存 cookie，我们将在表单的上下文中添加测试。

为登录表单编写一个新的 `describe` 语句块，然后复制粘贴我们用于登录表单的测试代码。

```
describe('login form', () => {
  // 在这里插入登录表单的测试代码
})
```

然后将它重命名为 `fills out form and submits`。再创建一个新的名为 `sets firstName cookie` 的测试块。它会检查 `firstNameCookie` 是否保存到了 cookie 中。

```
test('sets firstName cookie', async () => {
  const cookies = await Page.cookies()
  const firstNameCookie = cookies.find(c => c.name === 'firstName' && c.value === user.firstName)
  expect(firstNameCookie).not.toBeUndefined()
})
```

`Page.cookies` 方法返回文档的每个 cookie 对象组成的数组。使用数组的 `find` 方法来检查 cookie 是否存在。这可以确保应用使用的是 Faker 生成的 `firstName`。

如果你现在运行 `test` 脚本，你会发现测试失败了，因为返回的是一个 undefined 的值。现在来解决这个问题。

在 `App.js` 文件中，给 `state` 对象添加一个 `firstName` 属性。默认值为空字符串。

```
state = {
  complete: false,
  firstName: '',
}
```

在 `handleSubmit` 方法内，添加如下代码：

```
document.cookie = `firstName=${this.state.firstname}`
```

新建一个名为 `handleInput` 的方法。每次输入都会调用这个方法来更新 state。

```
handleInput = e => {
  this.setState({firstName: e.currentTarget.value})
}
```

把这个方法作为一个 prop 传递给 `Login` 组件。

```
<Login submit={this.handleSubmit} input={this.handleInput} />
```

在 `Login.js` 文件内，为 `firstName` 元素添加 `onChange={props.input}` 方法。这样，只要用户在 `firstName` 输入框中输入内容，React 就会调用这个方法。

现在，当用户点击了 `Login` 按钮，我需要应用把 `firstName` 信息保存到 cookie。运行 `npm test` 命令，看看应用能否通过所有测试。

如果应用在执行任何操作之前需要某个 cookie，这个 cookie 是否应该在之前授权的页面设置呢？

在 `App.js` 文件中，像下面这样重构 `handleSubmit` 方法：

```
handleSubmit = e => {
  e.preventDefault()
  if (document.cookie.includes('JWT')){
    this.setState({ complete: true })
  }
  document.cookie = `firstName=${this.state.firstName}`
}
```

通过上面的代码，`SuccessMessage` 组件只有在 cookie 中包含 `JWT` 时才会加载。

在 `App.test.js` 文件中的 `fills out form and submits` 测试代码块中，添加如下代码：

```
await page.setCookie({ name: 'JWT', value: 'kdkdkddf' })
```

这将把一个实际上通过一些随机测试来设置页面令牌的`'JWT'` 保存到 cookie。如果你现在运行 `test` 脚本，你的应用会执行并通过所有测试！

* * *

### 使用 Puppeteer 截图

当测试失败时，截图可以帮助我们看到具体的内容。我们来看看如何用 Puppeteer 来截图并分析测试。

在 `App.test.js` 文件 `nav loads correctly` 测试语句块内。添加一个条件语句来检查列表项 `listItems` 的个数是不是不等于 3。如果这样，Puppeteer 就应该对页面进行截图，更新测试的 expect 语句，期望 `listItems` 的个数是 3 不是 4。

```
if (listItems.length !== 3) 
  await page.screenshot({path: 'screenshot.png'});
expect(listItems.length).toBe(3);
```

显然，我们的测试会失败，因为我们的应用中有 4 个 `listItems`。在终端中运行 `test` 脚本，测试失败。同时你会在项目的根目录中发现一个 `screenshot.png` 文件。

![](https://cdn-images-1.medium.com/max/800/1*yO_p18mI872TjaGQsIOLgw.png)

截图

你也可以配置截图方法，如下：

*   `fullPage` — 如果设为 `true`，Puppeteer 会对整个页面截图。
*   `quality` — 从 0 到 100 的值，用来指定图片质量。
*   `clip` — 提供一个对象来指定页面的某个区域进行屏幕截图。

你也可以不使用 `page.screenshot` 方法，而是用 `page.pdf` 来创建页面的 PDF 文件。这个方法有自己的配置。

*   `scale` — 设置缩放倍数的数字，默认值为 1。
*   `format` — 设置纸张格式。如果设置这个属性，会优于传给它的任何宽度或高度选项。默认值是 `letter`。
*   `margin` — 用来设置纸张的边距。

* * *

### 在测试中处理页面请求

让我们看看 Puppeteer 在测试中如何处理页面请求。在 `App.js` 文件中，我会添加一个异步的 `componentDidMount` 方法。此方法会从Pokemon API 中获取数据。这个请求的响应会使用 JSON 文件的形式。我也会将这些数据添加到组件的状态中。

```
async componentDidMount() {
  const data = await fetch('https://pokeapi.co/api/v2/pokedex/1/').then(res => res.json())
  this.setState({pokemon: data})
}
```

确保在 state 对象中添加了 `pokemon: {}`。在 app 组件内，添加一个 `<h3>` 标签。

```
<h3 data-testid="pokemon">
  {this.state.pokemon.next ? 'Received Pokemon data!' : 'Something went wrong'}
</h3>
```

运行应用，你会发现应用已经成功获取数据。

使用 Puppeteer，我可以编写任务来检查我们的 `<h3/>` 元素是否包含成功请求到的内容，或拦截请求、强制失败。这样，我可以查看应用在请求成功和失败情况下是如何工作的。

我首先让 Puppeteer 发送一个请求来拦截获取请求。然后，如果我的网址包含 `pokeapi`，那么 Puppeteer 应该中止拦截的请求。否则，一切都应该继续下去。

打开 `App.test.js` 文件，在 `beforeAll` 方法中添加如下代码：

```
await page.setRequestInterception(true);
page.on('request', interceptedRequest => {
  if (interceptedRequest.url.includes('pokeapi')) {
    interceptedRequest.abort();
  } else {
    interceptedRequest.continue();
  }
});
```

`setRequestInterception` 是一个标志，使我能访问页面发出的每个请求。一旦请求被拦截，请求就会中止，并返回特定的错误码。也可以将请求设置为失败或检查一些逻辑之后继续拦截请求。

我们来写一个新的名为 `fails to fetch pokemon` 的测试。这个测试会执行 `h3` 元素。然后抓取这个元素的内容，确保内容为 `Received Pokemon data!`。

```
await page.setRequestInterception(true);
page.on('request', interceptedRequest => {
  if (interceptedRequest.url.include('pokeapi')) {
    interceptedRequest.abort();
  } else {
    interceptedRequest.continue();
  }
});
```

执行 `debug` 代码，你会实际看到 `<h3/>` 元素。你会注意到元素的内容一直是 `Something went wrong`。所有的测试都通过了，那意味着我们成功的阻止了 Pokemon 请求。

![](https://cdn-images-1.medium.com/max/800/1*h9a8rtfeLTc5D06OySlJKA.png)

注意在中止请求时，我们可以控制请求头、返回的错误码和自定义响应的实体。

* * *

### 了解更多：

*   [掌握 React 组件开发流程的 9 个工具](https://blog.bitsrc.io/9-tools-and-libraries-to-boost-your-react-component-workflow-6ff4b49511c2)
*   [[译] 如何写出更好的 React 代码](https://juejin.im/post/5ae975d26fb9a07aa92588b7)
*   [你应该知道的 11 个 React 组件库](https://blog.bitsrc.io/11-react-component-libraries-you-should-know-178eb1dd6aa4)

*   [**Bit — 共享共创代码组件**：Bit 让使用小组件构建软件更简单有趣，在你的团队中分享同步这些组件](https://bitsrc.io)


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
