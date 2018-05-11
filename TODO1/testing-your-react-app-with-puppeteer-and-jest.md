> * 原文地址：[Testing your React App with Puppeteer and Jest](https://blog.bitsrc.io/testing-your-react-app-with-puppeteer-and-jest-c72b3dfcde59)
> * 原文作者：[Rajat S](https://blog.bitsrc.io/@geeky_writer_?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/testing-your-react-app-with-puppeteer-and-jest.md](https://github.com/xitu/gold-miner/blob/master/TODO1/testing-your-react-app-with-puppeteer-and-jest.md)
> * 译者：
> * 校对者：

# Testing your React App with Puppeteer and Jest

## How to use Puppeteer and Jest to perform End-to-End Testing on your React App

![](https://cdn-images-1.medium.com/max/800/1*wby6AkTf3SggijT3GSTu4w.png)

End-to-End testing helps us to assure that all the components of our React app work together as we expect, in ways which unit and integration tests can’t.

[Puppeteer](https://github.com/GoogleChrome/puppeteer) is an end-to-end testing [Node](https://nodejs.org/) library by Google which provides us with a high-level API that can control [Chromium](https://www.chromium.org/) over the dev tools protocol. It can open and run apps and perform the actions it’s given through tests.

In this post, I’ll show how to use Puppeteer + [Jest](https://facebook.github.io/jest/) to run different types of tests on a simple React app.

* * *

### Project Setup

Let’s begin by setting up a basic React App. We will install other dependencies such as Puppeteer and Faker.

Use `create-react-app` to build a React App and name it `testing-app`.

```
create-react-app testing-app
```

Now, let’s install dev dependencies.

```
yarn add faker puppeteer --dev
```

We don’t need to install Jest which is already pre-installed in the React package. If you try to install it again, your test will not work as the two Jest versions will conflict with each other.

Next, we need to update the `test` script inside `package.json` to call Jest. We will also add another script called `debug`. This script is going to set our Node environment variable to debug mode and call `npm test`.

```
"scripts": {
  "start": "react-scripts start",
  "build": "react-scripts build",
  "test": "jest",
  "debug": "NODE_ENV=debug npm test",
  "eject": "react-scripts eject",
}
```

Using Puppeteer, we can run our test headless or live inside a Chromium browser. This is a great feature to have, as it allows us to see what views, DevTools, and network requests the tests are evaluating. The only drawback is that it can make things really slow in Continuous Integrations (CI).

We can use environment variables to decide whether to run our tests headless or not. I will set up my tests in such a way that that when I want to see them evaluated, I can run the `debug` script. When I don’t, I’ll run the `test` script.

Now open the `App.test.js` file in your `src` directory and replace the pre-existing code with this:

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

We first tell our app that we `require` puppeteer. Then, we `describe` our first test, where we check on the initial page load. Here I am testing whether the `h1` tag contains the correct text.

Inside our test’s description, we need to define our `browser` and `page` variables. These are required to walk through the test.

The `launch` method helps us pass through config options to our browser, and lets us control and tests our apps in different browser settings. We can even change the settings of the browser page by setting the emulation options.

Let’s set up our browser first. I have created a function named `isDebugging` at the top of the file. We will call this function inside the launch method. This function will have an object called `debugging_mode` that contains three properties:

*   `headless: false` — Whether we want to run our tests headless (`true` ) or in the Chromium browser (`false` )
*   `slowMo: 250` — Slow down the Puppeteer operations by 250 milliseconds.
*   `devtools: true` — Whether the browser should have DevTools open (`true`) while interacting with the app.

The `isDebugging` function will then return a ternary statement that is based on the environment variable. The ternary statement decides whether the app should return the `debuggin_mode` object or an empty object.

Back in our `package.json` file, we had created a `debug` script which will set our Node environment variable to debug. Instead of our test, the `isDebugging` function is going to return our customized browser options, which is dependent on our environment variable `debug`.

Next, we are setting some options for our page. This is done inside the `page.emulate` method. We are setting the `viewport` properties of `width` and `height`, and set a `userAgent` as an empty string.

`page.emulate` is extremely helpful as it gives us the ability to run our tests under various browser options. We can also replicate different page attributes `page.emulate`.

* * *

### Testing HTML Content with Puppeteer

We are now ready to start writing tests for our React App. In this section I am going to test the `<h1>` tag and the navigation and make sure that they are working correctly.

Open the `App.test.js` file and inside the `test` block and right below the `page.emulate` declaration, write the following code:

```
await page.goto('http://localhost:3000/');
const html = await page.$eval('.App-title', e => e.innerHTML);
expect(html).toBe('Welcome to React');
browser.close();
}, // This is not new
16000
); // this is not new
}); // this is not new
```

Basically, we are telling Puppeteer to go to the url `[http://localhost:3000/](http://localhost:3000/.)`[.](http://localhost:3000/.) Puppeteer will the evaluate the `App-title` class. This class is present on our `h1` tag.

The `$.eval` method is actually running a `document.querySelector` within whatever frame it’s passed into.

The Puppeteer finds the selector that matches this class, it will pass that to the callback function `e.innerHTML`. Here, Puppeteer will be able to extract the `<h1>` element, and check if it says `Welcome to React`.

Once Puppeteer is done with the test, the `browser.close` will close the browser.

Open a command terminal and run the `debug` script.

```
yarn debug
```

If your app passes the test, you should see something like this in the console:

![](https://cdn-images-1.medium.com/max/800/1*k-SHGujydrezgxVZmo67Fg.gif)

Next, go to `App.js` and create a `nav` element like this:

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

Note that all the `<li>` elements have the same class. Go back to `App.test.js` write the navigation test.

Before we do that, let’s refactor the code we had written before. Below the `isDebugging` function, define two global variables `browser` and `page`. Now write a new function called `beforeAll` as shown below:

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

Earlier, I didn’t have anything for `userAgent`. So, I just used the `setViewport` instead of `beforeAll`. Now, I can be rid of the `localhost` and `browser.close`, and use an `afterAll`. If the app is in debugging mode, then I want to remove that browser.

```
afterAll(() => {     
  if (isDebugging()) {         
    browser.close()     
  } 
})
```

We can now go ahead and write the nav test. Inside the `describe` block, create a new `test` as shown below.

```
test('nav loads correctly', async () => {
  const navbar = await page.$eval('.navbar', el => el ? true : false)
  const listItems = await page.$$('.nav-li')

  expect(navbar).toBe(true)
  expect(listItems.length).toBe(4)
}
```

Here, I am first grabbing the `navbar` using the `$eval` function on the `.navbar` class. I am then using a ternary to return a `true` or `false` to see if the element exists.

Next, I need to grab the list items. Just like before, I am using the `$eval` function on the `nav-li` class. We are going to `expect` the `navbar` to be `true` and the length of the listItems to be equal to 4.

You may have noticed that I have used `<div class="section-content" on the `listItems`. This is shortcut way to run the `document.querySelector` all from within the page. When the `eval` is not used alongside the dollar signs, there will be no callback.

Run the debug script to see if your code can pass both the tests.

![](https://cdn-images-1.medium.com/max/800/1*07WIbVNvpAsevTHI3PdM3Q.gif)

* * *

### Replicating User Activity

Let’s see how we can test a form submission by replicating keyboard input, mouse clicks, and touchscreen events. This will be done with random user information generated using Faker.

Inside of our `src` folder create a `Login.js` file. This is just a form with four input boxes and a button to submit it.

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

Also create a `Login.css` file as shown [here](https://gist.github.com/rajatgeekyants/cd2ea8a07cc2912ddf13e4646cda9b23).

Here is the component shared with [Bit](https://bitsrc.io), so that you can install it with NPM or import and develop it right from your own project.

* [**Bit - login / src / app - React component by geekrajat**: A login component with success message on submission - written in react. Dependencies: react. A Scope for a Login Form…](https://bitsrc.io/geekrajat/login/src/app)

![](https://cdn-images-1.medium.com/max/1000/1*PgFPdHkg6D8s-PJXxRWpvA.png)

When the user clicks on the `Login` button, the app needs to show a **Success Message.** So let’s create a `SucessMessage.js` file inside the `src` folder. Add a `[SuccessMessage.css](https://gist.github.com/rajatgeekyants/1a77cdf44f296f2399d4b63f40a4900f)` file as well.

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

Let’s go ahead and import these inside our `App.js` file.

```
import Login from './Login.js
import SuccessMessage from './SuccessMessage.js
```

Next, I will add a `state` to the class `App`. I will also add a `handleSubmit` method that will prevent the default function and change the `complete`‘s value to `true`.

```
state = { complete: false }

handleSubmit = e => {
  e.preventDefault()
  this.setState({ complete: true })
}
```

I will also add a ternary statement at the bottom of the class. This will decide whether to show the `Login` or `SuccessMessage.`

```
{ this.state.complete ? 
  <SuccessMessage/> 
  : 
  <Login submit={this.handleSubmit} />
} 
```

Run `yarn start` to make sure your App is running perfectly.

![](https://cdn-images-1.medium.com/max/800/1*rV2-3-ocf6fCM0gtzw0cuA.gif)

I will now use Puppeteer to write an End-to-End test to make sure that this feature works correctly. Go to the `App.test.js` file and import `faker`. I will then create a `user` object like this:

```
const faker = require('faker')

const user = {
  email: faker.internet.email(),
  password: 'test',
  firstName: faker.name.firstName(),
  lastName: faker.name.lastName()
}
```

Faker is extremely helpful in testing as it will generate different data every time we run the test.

Write a new `test` inside the `describe` block to test the login form. The test will click into our attributes and type then into something into them. The test will then `click` the `submit` button and wait for the `success` message. I will also add a timeout to this `test`.

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

Run the `debug` script and watch how Puppeteer conducts the test!

![](https://cdn-images-1.medium.com/max/800/1*y6KkvlCeWKvmeuwUErFDLA.gif)

* * *

### Set Cookies from within the Tests

I now want the app to save a cookie to the page whenever the form is submitted. This cookie will hold the user’s first name.

For the sake of simplicity, I am going to refactor my `App.test.js` file to open only one page. This one page will emulate the iPhone 6.

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

I want to save the cookie on submission of the form, we will add the test within the context of the form.

Write a new `describe` block for the login form and then copy and paste our login form test inside it.

```
describe('login form', () => {
  // insert the login form inside it
})
```

I will also rename the test to `fills out form and submits`. Now create a new test block called `sets firstName cookie`. This test will check if the `firstNameCookie` is set.

```
test('sets firstName cookie', async () => {
  const cookies = await Page.cookies()
  const firstNameCookie = cookies.find(c => c.name === 'firstName' && c.value === user.firstName)
  expect(firstNameCookie).not.toBeUndefined()
})
```

`Page.cookies` will return an array of objects for each document cookie. I have used the array prototype method `find` to see if the cookie exists. This will ensure that the app is using the Faker-generated `firstName`.

If you run the `test` script now, you will see that the test fails because it is returning us an undefined value. Let’s take care of that now.

Inside the `App.js` file, add a `firstName` property to the `state` object. It will be an empty string.

```
state = {
  complete: false,
  firstName: '',
}
```

Inside the `handleSubmit` method, add:

```
document.cookie = `firstName=${this.state.firstname}`
```

Create a new method called `handleInput`. This will fire on each input to update the state.

```
handleInput = e => {
  this.setState({firstName: e.currentTarget.value})
}
```

Pass this method on through to the `Login` component as a prop.

```
<Login submit={this.handleSubmit} input={this.handleInput} />
```

Inside the `Login.js` file, add `onChange={props.input}` to the `firstName` input. This way, whenever the user types inside the `firstName` input, React will fire this input method.

Now I need the app to save the `firstName` cookie to the page when the user clicks on the `Login` button. Run `npm test` to see if your app passes all the tests.

What if an application needs a certain cookie be present before performing any actions, and this cookie was set on a series of previously authorized pages?

In the `App.js` file, restructure the `handleSubmit` method like this:

```
handleSubmit = e => {
  e.preventDefault()
  if (document.cookie.includes('JWT')){
    this.setState({ complete: true })
  }
  document.cookie = `firstName=${this.state.firstName}`
}
```

With this code, the `SuccessMessage.` component will load only if the document includes a `JWT`.

Inside the `App.test.js` file go to the `fills out form and submits` test block and write the following:

```
await page.setCookie({ name: 'JWT', value: 'kdkdkddf' })
```

This will set a cookie that’s actually setting a JSON web token `'JWT'` with some random test. If you run the `test` script now, your app will run all the tests and pass!

* * *

### Screenshots with Puppeteer

Screenshots can help us see what our test was looking at when it failed. Let’s see how to to take screenshots with Puppeteer and analyze our tests.

In our `App.test.js` file, take the `test` named `nav loads correctly`. Add a conditional statement to check it the length of `listItems` is not equal to 3. If that is the case, then Puppeteer should take a screenshot of the page and update the test to expect the length of `listItems` to be 3 instead of 4.

```
if (listItems.length !== 3) 
  await page.screenshot({path: 'screenshot.png'});
expect(listItems.length).toBe(3);
```

Our test will obviously fail because we have “4" `listItems` in our App. Run the `test` script in the terminal and watch the test fail. At the same time you will find a new file named `screenshot.png` in your App’s root directory.

![](https://cdn-images-1.medium.com/max/800/1*yO_p18mI872TjaGQsIOLgw.png)

The Screenshot.

You can also configure the screenshot method:

*   `fullPage` — If `true`, Puppeteer will take a screenshot of the entire page.
*   `quality` — This ranges from 0 to 100 and sets the quality of the image.
*   `clip` — This takes an object that specifies a clipping region of the page to screenshot.

You can also create PDF of the page by doing a `page.pdf` instead of `page.screenshot` . This has its own unique configurations.

*   `scale` — This is a number that refers to the web page rendering. Default value is 1.
*   `format` — This refers to the paper format. If it's set, it takes priority over any width or height options that is passed to it. Default value is `letter`
*   `margin` — This refers to the paper margins.

* * *

### Handle Page Requests in Tests

Lets see how Puppeteer handles page requests in tests. Inside the `App.js` file, I will write an asynchronous `componentDidMount` method. This method is going to fetch data from Pokemon API. The response to this fetch request is going to be in the form of a JSON file. I will also add this data to my state.

```
async componentDidMount() {
  const data = await fetch('https://pokeapi.co/api/v2/pokedex/1/').then(res => res.json())
  this.setState({pokemon: data})
}
```

Make sure to add `pokemon: {}` to the state object. Inside the app component, add this `<h3>` tag.

```
<h3 data-testid="pokemon">
  {this.state.pokemon.next ? 'Received Pokemon data!' : 'Something went wrong'}
</h3>
```

If you run your app, you will see that the app has successfully fetched data.

Using Puppeteer, I can write tasks that check the content of our `<h3/>` with successful requests, and also intercept the request and force the failure case. This way, I can se how my app works during both success and failure cases.

I am going to first make Puppeteer sent a request to intercept the fetch request. Then, if my url includes the word “pokeapi”, then Puppeteer should abort the intercepted request. Else, everything should go on as it is.

Open the `App.test.js` file and write the following code inside the `beforeAll` method.

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

The `setRequestInterception` is a flag that enables me to access each request made by the page. Once a request is intercepted, the request can be aborted with a particular error code. I can either cause a failure or just intercept the request continue after checking some conditional logic.

Let’s write a new `test` named `fails to fetch pokemon`. This test will evaluate the `h3` tag. I will then grab the inner HTML and make sure that the content inside this text is `Received Pokemon data!`.

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

Run the `debug` script so you can actually see the `<h3/>`. You will notice that the `Something went wrong` text stays the same the entire time. All of our tests pass, which means that we successfully aborted the Pokemon request.

![](https://cdn-images-1.medium.com/max/800/1*h9a8rtfeLTc5D06OySlJKA.png)

Note that when intercepting requests, we can control what headers are sent, what error codes are returned, and return custom body responses.

* * *

### Learn more:

*   [9 React tools to master your component workflow](https://blog.bitsrc.io/9-tools-and-libraries-to-boost-your-react-component-workflow-6ff4b49511c2)
*   [How to write better code in React](https://blog.bitsrc.io/how-to-write-better-code-in-react-best-practices-b8ca87d462b0)
*   [11 React component libraries you should know](https://blog.bitsrc.io/11-react-component-libraries-you-should-know-178eb1dd6aa4)

* [**Bit - Share and build with code components**: Bit helps you share, discover and use code components between projects and applications to build new features and…_](https://bitsrc.io)


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
