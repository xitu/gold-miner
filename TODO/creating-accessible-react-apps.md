> * 原文地址：[Creating accessible React apps](http://simplyaccessible.com/article/react-a11y/)
> * 原文作者：[Scott Vinkle](http://simplyaccessible.com/article/author/scott/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/creating-accessible-react-apps.md](https://github.com/xitu/gold-miner/blob/master/TODO/creating-accessible-react-apps.md)
> * 译者：
> * 校对者：

# Creating accessible React apps

The React JavaScript library is a great way to create reusable modular components that can be shared among projects. But how do you ensure your React apps are usable by all kinds of people? Scott takes us through a detailed and timely tutorial on creating accessible React apps.

## Learning React

![](http://simplyaccessible.com/wordpress/wp-content/uploads/2017/10/creating-accessible-react-apps-1.jpg)

Way back in February 2017, I took a train from Kingston, Canada to downtown Toronto. Why was I making this two-hour trek? To learn about the [React](https://reactjs.org/) JavaScript library.

By the end of the day-long course, we each developed a fully working application. One of the things that really excited me about React was how it forces you to think modular. Each component does one task, and it does this one thing really well. When building components this way, it helps you focus all your thought and energy into ensuring you get the task right—not just for your current project but for future projects, too. React components are reusable and, if well constructed, can be shared among projects. It’s just a matter of finding the correct Lego brick in the pile to piece together what you need in order to create a great user experience.

However, when I got back from the trip, I started wondering if the app I created that day was accessible. Could it be made to be accessible? After loading up the project on my laptop I set out to conduct some basic testing with my keyboard and VoiceOver screen reader.

There were some minor, quick-win type issues, such as using `ul` + `li` elements for the homepage link list instead of the current offering of `div` elements. Another quick win: adding an empty `alt` attribute for the callout containers with decorative images.

There were also some more challenging issues to overcome. With each new page load, the `title` element text didn’t change to reflect the new content. Not only that, but keyboard focus was very poorly managed, which would block keyboard-only users from using the app. When a new page loaded, the focus would remain on the previous page view!

> Were there any techniques to use in order to fix these more challenging accessibility issues?

After spending time reading the [React docs](https://reactjs.org/docs/hello-world.html) and trying out some of the techniques acquired during the course, I was able to make the app much more accessible. In this post, I’ll walk you through the most pressing accessibility issues and how to address them, including:

* React reserved words;
* updating the page title;
* managing keyboard focus;
* creating a live messaging component;
* code linting, plus a few more thoughts on creating accessible React apps.

## Demo app

If seeing code in action is more your style, checkout this post’s accompanying React demo app: [TV-Db](https://simplyaccessible.github.io/tv-db/).

[![Screen capture of the TV-Db demo app on an iPad. Text in the middle of the screen reads, "Search TV-Db for your favourite TV shows!" A search form is below, along with a few quick links to TV show info pages.](http://simplyaccessible.com/wordpress/wp-content/uploads/2017/10/creating-accessible-react-apps-ipad-1.png)](https://simplyaccessible.github.io/tv-db/)

You can also follow along when reading this post by following the in-line links to the [source code of the demo app](https://github.com/simplyaccessible/tv-db).

Ready to make sure your React apps are more inclusive for people with disabilities and all kinds of users? Let’s go!

## HTML attributes and reserved words

One thing to keep in mind when writing HTML in React components is that HTML attributes need to be written in `camelCase`. This took me by surprise at first, but I quickly got used to it. If you do end up inserting an all `lowercase` attribute by accident, you’ll receive a friendly warning in the JavaScript console to adjust to `camelCase`.

For example, the `tabindex` attribute needs to be written as `tabIndex` (notice the capitalized ‘I’ character.) The exception to this rule is any `data-*` or `aria-*` attributes are still written as you’d expect.

There are also a few [reserved words in JavaScript](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Lexical_grammar#Reserved_keywords_as_of_ECMAScript_2015) which match specific HTML attribute names. These cannot be written in the same manner you’d expect:

* `for` is a reserved word in JavaScript which is used to loop through items. When creating `label` elements in React components, you must use the `htmlFor` attribute instead to set the explicit `label` + `input` relationship.
* `class` is also a reserved word in JavaScript. When assigning a `class` attribute on an HTML element for styling, it must be written as `className` instead.

There are likely more attributes to watch for, but so far these are the only conflicts I’ve found when it comes to JavaScript reserved words and HTML attributes. Have you come across any other conflicts? Post that in the comments, and we’ll publish a follow-up post with the whole list!

## Setting the page title

Since React apps are SPAs ([single page apps](https://simplyaccessible.com/article/spangular-accessibility/)) the `title` element will display the same content set throughout the browsing session; this isn’t ideal.

> The page `title` element is usually the first piece of content announced by screen readers on page load.

It’s essential that the title reflects the content on the page, so people who depend on that and encounter that content first will know what to expect.

In React apps, the content for the `title` element is set in the `public/index.html` file, and then never touched again.

We can get around this issue by dynamically setting the `title` element content in our parent components, or “pages” as required, by assigning a value to the global `document.title` property. Where we set this is within React’s `componentWillMount()` [lifecycle method](https://reactjs.org/docs/react-component.html#the-component-lifecycle). This is a function you use to run snippets of code when the page loads.

For example, if the page is a “Contact us” page with contact information or a contact form, we could call the `componentWillMount()` lifecycle method like so `{[Home.js:23](https://github.com/simplyaccessible/tv-db/blob/master/src/pages/Home.js#L23)}`:

```
componentWillMount() {
  document.title = ‘Contact us | Site Name';
}
```

When this component “page” loads, watch as the value in the browser tab updates to “Contact us | Site Name.” Just make sure to add the same code above in order to update the `title` element for all your page components.

## Focus management, part one

Let’s discuss focus management, a large factor in ensuring your app is both accessible and a successful user experience. If your customers are trying to fill out a multi “page” form, and you don’t manage the focus with each view, it’s likely to cause confusion, and if they are using assistive technologies, it may be too difficult for them to continue to complete the form. You could lose them as customers entirely.

In order to set keyboard focus onto a specific element within a component, you need to create what’s called a “function ref,” or `ref` for short. If you’re just starting out learning React, you can think of a `ref` in the same light as selecting an HTML element in the DOM with jQuery and caching it in a variable, such as:

```
var myBtn = $('#myBtn');
```

One unique thing when creating the `ref` is that it can be named anything (hopefully something that makes sense to you and the other devs on the team) and doesn’t rely on an `id` or `class` for a selector.

For example, if you have a loading screen, it would be ideal to send focus to the “loading” message container in order for a screen reader to announce the current app state. In your loading component, you could create a `ref` to point to the loading container `{[Loader.js:29](https://github.com/simplyaccessible/tv-db/blob/master/src/components/Loader.js#L29)}`:

```
<div tabIndex="-1" ref="{(loadingContainer) => {this.loadingContainer = loadingContainer}}">
    <p>Loading…</p>
</div>
```

When this component is rendered, the `function ref` fires and creates a “reference” to the element by creating a new class property. In this case, we create a reference to the `div` called “loadingContainer” and we pass it to a new class property via `this.loadingContainer = loadingContainer` assignment statement.

We use the `ref` in the `componentDidMount()` lifecycle hook to explicitly set focus to the “loading” container when the component loads `{[Loader.js:12](https://github.com/simplyaccessible/tv-db/blob/master/src/components/Loader.js#L12)}`:

```
componentDidMount() {
    this.loadingContainer.focus();
}
```

At the point when the loading component is removed from view, you could use a different `ref` to shift focus elsewhere.

It really can’t be overstated how important it is to manage focus _to_ an element and to manage focus _from_ an element to another one. This is one of the biggest challenges when building single page apps to get accessibility right.

## Live messaging

Live messaging is a great way to announce state changes in your app. For example, when data has been added to the page it’s helpful to inform people with certain kinds of assistive technologies, like screen readers, that this occurrence has taken place, along with how many items are now available.

Let’s go through and create a way to handle live announcements by creating a new component. We’re going to call this new component: `Announcements`.

When the component is rendered, the `this.props.message` value will be injected into the `aria-live` element and then this allows it to be announced by screen readers.

The component looks something like `{[Announcements.js:12](https://github.com/simplyaccessible/tv-db/blob/master/src/components/Announcements.js#L12)}`:

```
import React from 'react';

class Announcements extends React.Component {
    render() {
        return (
            <div className="visuallyhidden" aria-live="polite" aria-atomic="true">
                {this.props.message}
            </div>
        );
    }
}

export default Announcements;
```

This component simply creates a `div` element with some choice accessibility-related attributes: `aria-live` and `aria-atomic`. Screen readers will read these attributes and announce any text in the `div` out loud for the person using your app to hear. The `aria-live` attribute is pretty powerful, so use it judiciously.

Additionally, it’s important to always render the `Announcement` component in the template as some browser/screen reader technologies will not announce content when the `aria-live` element is dynamically added to the DOM. As a result, this component should always be included in any parent components in your app.

You’d include the `Announcement` component like so `{[Results.js:91](https://github.com/simplyaccessible/tv-db/blob/master/src/pages/Results.js#L91)}`:

```
<Announcements message={this.state.announcementMessage} />
```

In order to pass the message to the Announcements component, create a state property in the parent component that will be used to contain the message text `{[Results.js:22](https://github.com/simplyaccessible/tv-db/blob/master/src/pages/Results.js#L22)}`:

```
this.state = {
    announcementMessage: null
};
```

Then, update the state as required `{[Results.js:62](https://github.com/simplyaccessible/tv-db/blob/master/src/pages/Results.js#L62)}`:

```
this.setState({announcementMessage: `Total results found: ${data.length}`});
```

## Focus management, part two

We’ve already learned about managing focus using `ref`s, the React concept of creating a variable which points to an element in the DOM. Now, let’s take a look at another very important example using the same concept.

When linking to other pages of your app, you can use the HTML `a` element. In doing so, this will cause a full page reload as one would expected. However, if you’re using [React Router](https://reacttraining.com/react-router/) in your app, you have access to the `Link` component. The `Link` component actually replaces the tried and true `a` element in React apps.

Why would you use `Link` instead of _actual_ HTML anchor links, you ask? While it’s perfectly fine to use HTML links in React components, using the `Link` component from React Router allows your app to take advantage of React’s virtual DOM. Using the `Link` component helps to load “pages” much faster as the browser doesn’t need to refresh on a `Link` click, but they come with a catch.

> When using `Link` components, you need to be aware of where the keyboard focus is placed, and where it will go when the next “page” appears.

This is where our friend `ref` comes in to to help out.

### Link components

A typical Link component looks something like this:

```
<Link to='/home'>Home</Link>
```

The syntax should look familiar as it’s quite similar to an HTML `a` element; swap the `a` for `Link` and `href` with `to` and you’re set.

As I already mentioned, using `Link` components instead of HTML links doesn’t refresh the browser. Instead, React Router loads the next component as described in the `to` prop.

Let’s look at how we can ensure the keyboard focus moves to an appropriate place.

### Adjusting keyboard focus

When a new page loads, keyboard focus needs to be explicitly set. Otherwise, focus remains on the previous page, and who knows where focus could end up when someone starts to navigate next? How do we explicitly set focus? Our dear friend `ref`.

#### Setting up the ref

To decide where the focus should go, you’ll need to examine how your components have been set up and which widgets are in use. For example, if you have “page” components with child components making up the rest of the page content, you may want to shift focus to the outermost parent element of the page, most likely a `div` element. From here, someone could navigate through the rest of the page content, much like if there was a full browser refresh.

Let’s create a `ref` called `contentContainer` on the outermost parent `div`, like so `{[Details.js:84](https://github.com/simplyaccessible/tv-db/blob/master/src/pages/Details.js#L84)}`:

```
<div ref={(contentContainer) => { this.contentContainer = contentContainer; }} tabIndex="-1" aria-labelledby="pageHeading">
```

You may have noticed the inclusion of `tabIndex` and `aria-labelledby` attributes. The `tabIndex` with its value set to `-1` will allow the normally non-focusable `div` element to receive keyboard focus, programmatically via `ref`.

> Tip: Just like focus management, use `tabIndex="-1"` intentionally and according to an explicit plan.

The `aria-labelledby` attribute value will programmatically associate the heading of the page (perhaps an `h1` or `h2` element with the id of “pageHeading”) to help describe the current context of where the keyboard is currently focused.

Now that we have the `ref` created, let’s see how we use it to _actually_ shift focus.

#### Using the ref

We learned earlier about the `componentDidMount()` lifecycle method. We can use this again to shift keyboard focus when the page loads inside React’s virtual DOM, using the `contentContainer` `ref` we created earlier in the component `{[Home.js:26](https://github.com/simplyaccessible/tv-db/blob/master/src/pages/Home.js#L26)}`:

```
componentDidMount() {
    this.contentContainer.focus();
}
```

The above code tells React, “on component load, shift keyboard focus to the container element.” From this point on, navigation will begin at the top of the page and content will be discoverable as if a full page refresh had occurred.

## React’s accessibility code linter

I couldn’t write a React post about accessibility without mentioning the incredible open-source project that is [`eslint-plugin-jsx-a11y`](https://github.com/evcohen/eslint-plugin-jsx-a11y). This is an [ESLint](https://eslint.org/) plugin, specifically for JSX and React, that watches for and reports any potential accessibility issues with your code. It comes baked in when you create a new React project, so you don’t need to worry about any setup.

For example, if you included an image in your component without an `alt` attribute, you’d see this in your browser developer tools console:

[![Screen capture of Chrome’s developer tools console. A warning message states, “img elements must have an alt prop, either with meaningful text, or an empty string for decorative images. (jsx-a11y/alt-text)”](http://simplyaccessible.com/wordpress/wp-content/uploads/2017/10/creating-accessible-react-apps-console.png)](http://simplyaccessible.com/wordpress/wp-content/uploads/2017/10/creating-accessible-react-apps-console.png)

Messages like these are really helpful when developing an app. Although, wouldn’t it be great to see these types of messages in your own code editor, before anything even gets to the browser? Here’s how to install and setup `eslint-plugin-jsx-a11y` for use with your editing environment.

### Install the ESLint plugin

First you’ll need the ESLint plugin installed for your editor. Search your editor’s plugin repositories for “eslint”–chances are there will be something available for you to install.

Here are some quick links for:

* [Atom](https://atom.io/packages/linter-eslint)
* [Sublime Text](https://packagecontrol.io/packages/SublimeLinter-contrib-eslint)
* [VS Code](https://marketplace.visualstudio.com/items?itemName=MadsKristensen.WebAnalyzer)

### Install eslint-plugin-jsx-a11y

The next step is installing `eslint-plugin-jsx-a11y` via `npm`. Just issue the following command to install it and ESLint for use within your editor:

```
npm install eslint eslint-plugin-jsx-a11y --save-dev
```

After this has finished running, update the project `.eslintrc` file so ESLint can use the `eslint-plugin-jsx-a11y` plugin.

### Update the ESLint configuration

If there’s no `.eslintrc` file in the root directory of your project, you can simply create a new file with this as the file name. Check out [how to set up the `.eslintrc` file](https://eslint.org/docs/user-guide/configuring) and some of the [rules](https://eslint.org/docs/rules/) you can add to configure ESLint to satisfy your project’s requirements.

With the `.eslintrc` file in place, open it up for editing and add the following to the “plugins” section `{[.eslintrc:43](https://github.com/simplyaccessible/tv-db/blob/master/.eslintrc#L43)}`:

```
"plugins": [
    "jsx-a11y"
]
```

This tells our local instance of ESLint to use the `jsx-a11y` plugin when linting your project files.

In order for ESLint to look for specific accessibility related errors in our code, we also need to specify the ruleset for ESLint to use. You can configure your own rules, but I recommend using the default set, at least to get started.

Add the following to the “extends” section of the `.eslintrc` file `{[.eslintrc:47](https://github.com/simplyaccessible/tv-db/blob/master/.eslintrc#L47)}`:

```
"extends": [
    "plugin:jsx-a11y/recommended"
]
```

This one line tells ESLint to use the default, recommended rule set, which I find very useful.

After making these edits and restarting your editor, you should now see something like the following when there are accessibility related issues:

[![Screen capture of Atom text editor. A warning message appears overtop of some code with the following message, “img elements must have an alt prop, either with meaningful text, or an empty string for decorative images. (jsx-a11y/alt-text)”](http://simplyaccessible.com/wordpress/wp-content/uploads/2017/10/creating-accessible-react-apps-atom.png)](http://simplyaccessible.com/wordpress/wp-content/uploads/2017/10/creating-accessible-react-apps-atom.png)

## Continue writing semantic HTML

In the [“Thinking in React” help doc](https://reactjs.org/docs/thinking-in-react.html), readers are encouraged to create component modules, or component-driven development; tiny, reusable snippets of code. The benefit of this is being able to reuse code from project to project. Imagine, creating an accessible widget for one site, then if the another site requires the same widget, being able to copy and paste the code!

From here, you build up your UI using modules within modules to create larger components, and eventually a “page” comes together. This might pose a bit of a learning curve at first, but after awhile you get used to this way of thinking and might end up enjoying the breakdown process when writing your HTML.

> Since React uses [ES6 classes](https://developer.mozilla.org/en/docs/Web/JavaScript/Reference/Classes) to make up its components, it’s up to you to continue to write good, clean, semantic HTML.

As we touched on earlier in the article, there are a few reserved words to watch out for, such as `htmlFor` and `className`, but other than this, it’s still your responsibility as a developer to write and test your HTML UI as you normally would.

Also, take advantage of being able to write JavaScript inside your HTML via JSX, when appropriate. It greatly helps to make your app that much more dynamic and accessible.

## Conclusion

You’re now fully equipped to make React apps more accessible! You possess the knowledge to:

* update the page `title` so people stay oriented within your app and understand the purpose of each view’s content;
* manage keyboard focus so they can move smoothly through dynamic content without getting lost or confused about what just happened;
* create a live messaging component to alert people of any important changes in state; and
* add code linting to your project so you can catch accessibility errors as you work.

And perhaps the best accessibility tip to share with anyone developing for the web: [write semantic HTML](https://simplyaccessible.com/article/listening-web-part-two-semantics/) in your templates, as you would for any static, CMS, or framework-based website. React doesn’t get in your way when it comes to choosing which elements to create for your user interfaces. It’s up to you, dear developer, to ensure that what you create is usable and accessible for as many people as possible.

Have you discovered any other ways to create more accessible React apps? I’d love to hear about it in the comments!


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
