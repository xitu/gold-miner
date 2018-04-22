> * 原文地址：[How To Write Better Code In React](https://blog.bitsrc.io/how-to-write-better-code-in-react-best-practices-b8ca87d462b0)
> * 原文作者：[Rajat S](https://blog.bitsrc.io/@geeky_writer_?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-write-better-code-in-react-best-practices.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-write-better-code-in-react-best-practices.md)
> * 译者：
> * 校对者：

# How To Write Better Code In React

## 9 Useful Tips for writing better code in React: Learn about Linting, propTypes, PureComponent and more.

![](https://cdn-images-1.medium.com/max/2000/1*4ihBhwd0DygCWHN-Bo24BA.png)

[React](https://reactjs.org/) makes it painless to create interactive UIs. Design simple views for each state in your application, and React will efficiently update and render just the right components when your data changes.

In this post, I will show you a few tips that will help you become a better React Developer. I will cover a range of things from tooling to actual code style, which can help you improve your skill with React. 💪

* * *

### Let’s Talk about Linting

One thing that’s really important for writing better code is good linting. Because if we have a good set of linting rules set up, your code editor will be able to catch anything that could potentially cause a problem in your code.

But more than just catching problems, your [ES Lint](https://eslint.org/)setup will constantly make you aware of [React](https://eslint.org/) best practices.

```
import react from 'react';
/* Other imports */

/* Code */

export default class App extends React.Component {
  render() {
    const { userIsLoaded, user } = this.props;
    if (!userIsLoaded) return <Loader />;
    
    return (
      /* Code */
    )
  }
}
```

Take the code snippet above. Say you want to reference a new property called `this.props.hello` in your `render()` function. Your linter will immediately go red and say:

```
'hello' is missing in props validation (react/prop-types)
```

Linting will help you be aware of the best practices in React and shape your understanding of the code. Soon, you will start to avoid making mistakes when you write your code.

You can either head over to [ESLint](https://eslint.org) and set up a linting utility for JavaScript, or you can use [Airbnb’s JavaScript Style Guide](https://github.com/airbnb/javascript). You can also install the [React ESLint Package](https://www.npmjs.com/package/eslint-plugin-react).

* * *

### [propTypes](https://www.npmjs.com/package/prop-types) and defaultProps

In the earlier section, I talked about how my linter acted up when I tried to pass an unvalidated prop.

```
static propTypes = {
  userIsLoaded: PropTypes.boolean.isRequired,
  user: PropTypes.shape({
    _id: PropTypes.string,
  )}.isRequired,
}
```

Here, if we say that the `userIsLoaded` is not required, then we would need to add this to our code:

```
static defaultProps = {
 userIsLoaded: false,
}
```

So anytime we have a `PropType` that’s used in our component, we need to set a propType for it. As in, we need to tell React that `userIsLoaded` is always going to be a boolean value.

And again if we say that `userIsLoaded` is not required then we’re going to need to have a default prop. If it is required, then we don’t have to define a default prop for it. However, the rule also states that you shouldn’t have an ambiguous propTypes like object or array.

This is why we are using `shape` to validate `user`, which has another an `id` inside it, which has a propType of `string`, and the entire `user` object is required.

Making sure you have your `propTypes` and `defaultProps` set up on every single component that uses `props` will go a long way.

The moment those props don’t get the data that they are expecting, your error log will let you know that you are either passing in something incorrectly or something that is expecting it is not there, making error finding just way easier especially if you are writing a lot of reusable components. It also makes them a little bit more self-documenting.

#### Note:

Unlike earlier versions of React, proptypes are no longer included inside React and you will have to add them separately to your project as a dependency.

Click here to know more:

- [**prop-types**: Runtime type checking for React props and similar objects._www.npmjs.com](https://www.npmjs.com/package/prop-types)

* * *

### Know when to make new components

```
export default class Profile extends PureComponent {
  static propTypes = {
    userIsLoaded: PropTypes.bool,
    user: PropTypes.shape({
      _id: PropTypes.string,
    }).isRequired,
  }
  
  static defaultProps = {
    userIsLoaded: false,
  }
  
  render() {
    const { userIsLoaded, user } = this.props;
    if (!userIsLoaded) return <Loaded />;
    return (
      <div>
        <div className="two-col">
          <section>
            <MyOrders userId={user._id} />
            <MyDownloads userId={user._id} />
          </section>
          <aside>
            <MySubscriptions user={user} />
            <MyVotes user={user} />
          </aside>
        </div>
        <div className="one-col">
          {isRole('affiliate', user={user._id) &&
            <MyAffiliateInfo userId={user._id} />
          }
        </div>
      </div>
    )
  }
}
```

Here I have a component called `Profile`. I have other components like `MyOrder` and `MyDownloads` inside this component. Now I could have written all these components inline here since I am just pulling the data from the same place (`user`), Turning all these smaller components into a one giant component.

While there aren’t any hard and fast rules on when to move your code into a component, ask yourself:

*   Is your code’s functionality becoming unwieldy?
*   Does it represent its own thing?
*   Are you going to reuse your code?

If any of these question’s answer is yes, then you need to move your code into a component.

Keep in mind that the last thing anyone wants to see in your code is a giant 200–300 line component full of crazy bells and whistles.

* * *

### Component vs PureComponent vs Stateless Functional Component

It is very important for a React developer to know when to use a **Component**, **PureComponent**, and a **Stateless Functional Component** in your code.

You might have noticed in the above code snippet that instead of declaring `Profile` as a `Component`, I have instead called it as a `PureComponent`.

First, let’s check out a stateless functional component.

#### Stateless Functional Component

```
const Billboard = () => (
  <ZoneBlack>
    <Heading>React</Heading>
    <div className="billboard_product">
      <Link className="billboard_product-image" to="/">
        <img alt="#" src="#">
      </Link>
      <div className="billboard_product-details">
        <h3 className="sub">React</h3>
        <p>Lorem Ipsum</p>
      </div>
    </div>
  </ZoneBlack>
);
```

Stateless functional components are one of the most common types of components in your arsenal. They provide us with a nice and concise way to create components that are not using any kind of [**state**](https://reactjs.org/docs/faq-state.html), [**refs**](https://hackernoon.com/refs-in-react-all-you-need-to-know-fb9c9e2aeb81), or [**lifecycle methods**](https://reactjs.org/docs/state-and-lifecycle.html).

The idea with a stateless functional component is that it is state-less and just a function. So what’s great about this is that you are defining your component as a constant function that returns some data.

In simple words, stateless functional components are just functions that returns JSX.

#### [PureComponents](https://reactjs.org/docs/react-api.html#reactpurecomponent)

Usually, when a component gets a new prop into it, React will re-render that component. But sometimes, a component gets new props that haven’t really changed, but React will still trigger a re-render.

Using `PureComponent` will help you prevent this wasted re-render. For instance, if a prop is a string or boolean and it changes, a `PureComponent` is going to recognize that, but if a property within an object is changing, a `PureComponent` is not going to trigger a re-render.

So how will you know when React is triggering an unnecessary re-render? You can check out this amazing React package called [Why Did You Update](http://github.com/maicki/why-did-you-update). This package will notify you in the console when a potentially unnecessary re-render occurs.

![](https://cdn-images-1.medium.com/max/800/1*CL5jum98a0QxOWeIb9QRBg.png)

Once you have recognized an unnecessary re-render, you can use a `PureComponent` rather than a `Component` to prevent things from having an unnecessary re-render.

* * *

### Use React Dev Tools

If you are serious about becoming a pro React Developer, then using React Dev Tools should be commonplace practice in your development process.

If you have used React, there is a good chance that your console has yelled at you to use React Dev Tools.

React Dev Tools are available for all major browsers such as [Chrome](https://chrome.google.com/webstore/detail/react-developer-tools/fmkadmapgofadopljbjfkapdkoienihi?hl=en) and [Firefox](https://addons.mozilla.org/en-US/firefox/addon/react-devtools/).

React Dev Tools give you access to the entire structure of your React app and allow you to see all the props and state that are being used in the app.

React Dev Tools is an excellent way to explore our React components and helps diagnose any issues in your app.

* * *

### Use Inline Conditional Statements

This opinion might ruffle a few feathers but I have found that using Inline-Conditional Statements considerably cleans up my React code.

Take a look at this code snippet:

```
<div className="one-col">
  {isRole('affiliate', user._id) &&
    <MyAffiliateInfo userId={user._id} />
  }
</div>
```

Here I have a basic function called that checks if a person is an “affiliate”, followed by a component called `<MyAffiliateInfo/>`.

What’s great about this is that:

*   I didn’t have to write a separate function.
*   I didn’t have to write another “if” statement in my render function.
*   I didn’t have to create a “link” to somewhere else in the component.

Writing inline-conditional statements is quite simple. You begin by writing you conditional statement. You could say true and it will always show the `<MyAffiliateInfo />` component.

Next we link this conditional statement with `<MyAffiliateInfo />` using `&&`. This way, the component will only be rendered when the conditional statement returns `true`.

* * *

### Use Snippet Libraries whenever possible

Open up a code editor (I use VS Code), and create a .js file.

Inside this file when you type `rc`, you will see something like this:

![](https://cdn-images-1.medium.com/max/800/1*DKVKG5IQB2XQ4GR1uEVDUw.png)

Hitting enter, you will instantly get this:

![](https://cdn-images-1.medium.com/max/800/1*ICQlmjGkoM_27Mz8tD1ZyA.png)

What’s great about these code snippets is that not only do they help you potentially save bugs but they also help you identify the latest and greatest syntax.

There are many different snippet libraries that can be installed in your code editor. The one I use for [VS Code](https://code.visualstudio.com/) is called [ES7 React/Redux/React-Native/JS Snippets](https://marketplace.visualstudio.com/items?itemName=dsznajder.es7-react-js-snippets).

* * *

### [React Internals](http://www.mattgreer.org/articles/react-internals-part-one-basic-rendering/) — Learn how React works

React Internals is a five-part series that helped me understand the very basics of React, and eventually helped me become a better React Developer!

If you are having issues with something that you might not have understood fully, or if you understand how React works, then React Internals will help you understand the **When** and **How** to do things right in React.

This is especially helpful to those who have an idea but don’t quite know where to execute their code.

Understanding the basics of how React works will help you become a better React developer.

* * *

### Use [Bit](https://bitsrc.io) and [StoryBook](https://storybook.js.org/) for your components

[Bit](https://bitsrc.io) is a great tool for turning your UI components into building blocks which can be shared, developed and synced in your different apps.

You can also leverage Bit to organize your team’s components in a shared gallery making them more discoverable and useful, with a [live component playground](https://blog.bitsrc.io/introducing-the-live-react-component-playground-d8c281352ee7), testing in isolation and more.

- [**Bit - Share and build with code components**: Bit makes it fun and simple to build software with smaller components, share them with your team and sync them in your… bitsrc.io](https://bitsrc.io)

[Storybook](https://github.com/storybooks/storybook) is a rapid development environment for UI components which can help you to browse a component library, view the different states of each component, and interactively develop and test components.

Storybook will help you develop React components faster by adding an environment where you can actually see and showcase your components while playing with their properties, with hot-reloading on the web.

* * *

### Quick Recap

1.  Get some good linting. Use ES Lint, Airbnb’s JavaScript Style Guide, and ESLint React Plugin.
2.  Use propTypes and defaultProps.
3.  Know when to make new components.
4.  Know when to write a Component, PureComponent, and a Stateless Functional Component.
5.  Use React Dev Tools.
6.  Use inline conditional statements in your code.
7.  Use Snippet Libraries to save a ton of time that is usually wasted on boilerplate code.
8.  Learn how React works with React Internals.
9.  Use tools like Bit / StoryBook to improve your component development workflow


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
