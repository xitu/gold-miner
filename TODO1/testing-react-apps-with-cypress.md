> * 原文地址：[End to End Testing React Apps With Cypress](https://blog.bitsrc.io/testing-react-apps-with-cypress-658bc482678)
> * 原文作者：[Rajat S](https://medium.com/@geeky_writer_)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/testing-react-apps-with-cypress.md](https://github.com/xitu/gold-miner/blob/master/TODO1/testing-react-apps-with-cypress.md)
> * 译者：
> * 校对者：

# End to End Testing React Apps With Cypress

> A brief guide on how to run End-To-End testing on React apps with Cypress.

![](https://cdn-images-1.medium.com/max/2562/1*FoCFnUGcQvE2zqiFxitXUg.png)

When I was a junior dev I used to cringe at the thought of testing my apps. Testing is not easy. But with the help of right tools, writing tests can certainly be simpler and more fun.

Cypress is a JavaScript End-to-End Testing Framework that makes it really simple to setup, write, run, and debug tests.

If you have tried other End-to-End Testing Frameworks like Puppeteer, you will notice that these frameworks turn the browser into an air-gapped system. The more complex our app gets, the harder it will get to pass our tests. This is why most testers prefer to run there tests manually.

In this post, I will show you how Cypress can help you build tests that will run in a real browser. Cypress provides with an API for test automation that is really easy to use.

Instead of looking at a bland command terminal filled gibberish, Cypress comes with its own dashboard that will show us exactly what is happening during our tests. And, because Cypress works in the actual browser, we can also use the browser’s dev tools side-by-side with Cypress.

**Tip**: When working with **React components** you might want to remember the importance of component unit-testing. Using [**Bit**](https://bit.dev/) you can create a reusable component catalog to use in your projects, and add component tests which will run in isolation and present with visual results. Check it out.

[**Component Discovery and Collaboration · Bit**](https://bit.dev/)

Let’s dive in.

---

## Setup

Instead of creating a whole new app, I am going to use a pre-existing project and run my Cypress tests on it.

Here, I have a simple ToDo app in React.

[**rajatgeekyants/ToDo-List**](https://github.com/rajatgeekyants/ToDo-List)

![](https://cdn-images-1.medium.com/max/2000/1*sFtLSBvrjPNJkb66q1mIxQ.png)

Clone this app into your system and run `yarn install` to install the dependencies.

```
$ git clone https://github.com/rajatgeekyants/ToDo-List.git
$ yarn install
```

**Note**: You can also checkout the app on Bit. Here you will be able to import any particular component of the app, without having to care about the rest.

[**todo by geekrajat · Bit**](https://bit.dev/geekrajat/todo)

With that out of the way, I can now get to the test phase of the app. Let’s install Cypress as a **dev dependency** to our app.

```
$ yarn add cypress -D
```

Now to open Cypress, all we have to do is run this command.

```
$ node_modules/.bin/cypress open
```

This will open the Cypress CLI (or dashboard) on your system and also create a `cypress.json` file and a `cypress` folder in your app’s root directory. The `cypress` folder is where we will be writing our tests.

If you feel that the command to open Cypress is too long or hard to remember, you can go to `package.json` and create a new script:

```
"cypress": "cypress open"
```

So if you run this script with NPM/Yarn, it should open the Cypress CLI. Inside the `cypress` folder, create a test file inside the `integration` folder. Unlike your normal test files where we name them something like `App.test.js`, in Cypress, the extension for the test file is `.spec.js`.

```JavaScript
describe ('First Test', () => {
  it ('is working', () => {
    expect (true).to.equal (true);
  });
});
```

This is a very simple test that is only check it `true` is equal to `true` (which it obviously is). If you open the Cypress CLI, you will see that the new test file will be automatically listed there. Clicking on it will run the test and open the dashboard in the browser where you will be able to see the test result.

![](https://cdn-images-1.medium.com/max/2000/1*Wh46Wi_P9a90q6nwwzKJ9w.png)

This test had nothing to do with the ToDo app. It just showed how tests are run using Cypress. Let’s start writing test for our actual app now.

---

## Page Visits in Cypress

The first step in a Cypress test is to allow Cypress to visit the app in a browser. Let’s create a new test file and write the following code in it.

```JavaScript
describe ('Second Test', () => {
  it ('Visit the app', () => {
    cy.visit ('/');
  });
});
```

In the above code, I have an object named `cy`. This is a global object and gives us access to all the commands present in the Cypress API. I am using `cy` to access the `visit` command. Inside this command I am just going to pass `'/'`. Back in the root directory, go to the `cypress.json` file and write this in there:

```
{
  "baseUrl": "http://localhost:3000"
}
```

Now, make sure that you are running the app using the `start` script. Next open the Cypress CLI and run this new test file. You will see the dashboard open in the browser, and inside the dashboard our app will run like this:

![](https://cdn-images-1.medium.com/max/2400/1*kpUn1HNHVpKEXAUNPOg3CA.png)

If you notice the command log on the left, you will see that Cypress is making an XHR call in order to get the app to open inside it.

---

## Check For Focus

Here, I am going to run a test that will check if the browser is focused on the input field when it loads.

Before we do this, make sure that the `input` field in src/components/TodoList/index.js has a `className` property of `new task` alongwith the `autoFocus` property.

```
<input
  autoFocus
  className="new task"
  ref={a => (this._inputElement = a)}
  placeholder="enter task"
/>
```

Without these properties, our test will definitely fail. Create a new test file with the following code:

```JavaScript
describe ('Third Test', () => {
  it ('Focus on the input', () => {
    cy.visit ('/');
    cy.focused ().should ('have.class', 'new task');
  });
});
```

First, I `visit` the app inside the Cypress Dashboard. Once the app opens inside the dashboard, I am checking if the `focused` element has a `class` named `new task`.

![](https://cdn-images-1.medium.com/max/2000/1*egylykedXJ2NpY0K0_t4Ag.png)

---

## Testing Controlled Input

In this test, I am going to check if the controlled input accepts text and has its value set appropriately.

```JavaScript
describe ('Third Test', () => {
  it ('Accepts input', () => {
    const text = 'New Todo';
    cy.visit ('/');
    cy.get ('.new').type (text).should ('have.value', text);
  });
});
```

In this test, I first `visit` the app inside the Cypress Dashboard. Now I want Cypress to type something inside the input field. In order to find the correct selector for input field, click on the `Open Selector Playground` button and click on the input field.

![](https://cdn-images-1.medium.com/max/2000/1*MfeHIpz2_SYwcUY0raMdaQ.gif)

After getting the selector for the input field, I will make the cypress `type` some text inside it. To make sure Cypress has typed the correct text, I have used the `should` command.

![](https://cdn-images-1.medium.com/max/2000/1*pVSMDn4gdsvA3iWtucBhJg.png)

---

## Running Tests without any UI

The UI can make our app run slowly in case of large number of tests. The UI is anyway not going to be seen during Continuous Integration, so why load it at all?

To run our tests without launching Cypress UI, we first add a new script in `package.json` file.

```
"cypress:all": "cypress run"
```

By running this script, cypress will run all the tests and provide the results directly in the command terminal itself.

![](https://cdn-images-1.medium.com/max/2000/1*5ohUyAlbFGgkmO7_K2hI0w.png)

If you are worried that you did not actually get to see Cypress do the testing, Cypress will even record a video of the test that you can watch.

---

## Create End-to-End Tests in Cypress

Cypress is most useful when we use it for integration tests. But an End-to-End test makes sure that nothing is missed in the entire app.

```JavaScript
describe ('Sixth Tests', () => {
  context ('No Todos', () => {
    it ('Adds a new todo', () => {
      cy.visit ('/');
      cy.get ('.new').type ('New todo').type ('{enter}');
    });
  });
});
```

Here, I have created an end-to-end test. I first get Cypress to `visit` the app. Then Cypress will get the input using its selector `.new`. Cypress will then type the text `New Todo`. Finally I will get Cypress to mock an `enter` action, hence creating a new Todo.

![](https://cdn-images-1.medium.com/max/2000/1*wcIDOda8sVB_ROYIlCEdww.gif)

---

## What’s Next?

There are many other things that we can do with Cypress. For example, we can test variations of a feature, or we can access step-by-step logs of our tests. Plus, there is a whole lot of other things that Cypress can do with a Server-Side Rendered React App that I will try to cover in my next post.

---

## Learn more

* [**5 Tools For Faster Development In React**](https://blog.bitsrc.io/5-tools-for-faster-development-in-react-676f134050f2)
* [**Testing your React App with Puppeteer and Jest**](https://blog.bitsrc.io/testing-your-react-app-with-puppeteer-and-jest-c72b3dfcde59)
* [**How to Test React Components using Jest and Enzyme**](https://blog.bitsrc.io/how-to-test-react-components-using-jest-and-enzyme-fab851a43875)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
