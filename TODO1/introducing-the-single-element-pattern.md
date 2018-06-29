> * 原文地址：[Introducing the Single Element Pattern: Rules and best practices for creating reliable building blocks with React and other component-based libraries.](https://medium.freecodecamp.org/introducing-the-single-element-pattern-dfbd2c295c5d)
> * 原文作者：[Diego Haz](https://medium.freecodecamp.org/@diegohaz)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/introducing-the-single-element-pattern.md](https://github.com/xitu/gold-miner/blob/master/TODO1/introducing-the-single-element-pattern.md)
> * 译者：
> * 校对者：

# Introducing the Single Element Pattern

## Rules and best practices for creating reliable building blocks with React and other component-based libraries.

![](https://cdn-images-1.medium.com/max/1000/1*safLOvm16NWX1Z4mPBHNCQ.png)

Back in 2002 — when I started building stuff for the web — most developers, including me, structured their layouts using `<table>` tags.

Only in 2005 did I start following [web standards](https://en.wikipedia.org/wiki/Web_standards).

> When a web site or web page is described as complying with web standards, it usually means that the site or page has valid HTML, CSS and JavaScript. The HTML should also meet accessibility and semantic guidelines.

I learned about semantics and accessibility, then started to use proper HTML tags and external CSS. I was proudly adding those [W3C Badges](https://www.w3.org/QA/Tools/Icons) to every web site I made.

![](https://cdn-images-1.medium.com/max/800/1*pFL99e3lxpYN-Fp24HfdBw.jpeg)

The HTML code we wrote was pretty much the same as the output code that went to the browser. That means that validating our output using the [W3C Validator](https://validator.w3.org/) and other tools was also teaching us how to write better code.

Time has passed. To isolate reusable parts of the front end, I've used PHP, template systems, jQuery, Polymer, Angular, and React. This latter, in particular, I have been using for the past three years.

As time went on, the code we wrote was getting more and more different from the one served to the user. Nowadays, we’re transpiling our code in many different ways (using Babel and TypeScript, for example). We write [ES2015+](https://devhints.io/es6) and [JSX](https://reactjs.org/docs/introducing-jsx.html), but the output code will be just HTML and JavaScript.

Currently, even though we can still use W3C tools to validate our web sites, they don't help us much with the code we write. We're still pursuing best practices to make our code more consistent and maintainable. And, if you're reading this article, I guess you're also looking for the same thing.

And I have something for you.

### The Single Element Pattern ([Singel](https://github.com/diegohaz/singel))

I don't know exactly how many components I've written so far. But, if I put Polymer, Angular and React together, I can safely say that this number is over a thousand.

Besides company projects, I maintain a [React boilerplate](https://github.com/diegohaz/arc) with more than 40 example components. Also, I'm working with [Raphael Thomazella](https://github.com/Thomazella), who also contributed to this idea, on a [UI toolkit](https://github.com/diegohaz/reas) with dozens more of them.

Many developers have the misconception that, if they start a project with the perfect file structure, they'll have no problems. The reality, though, is that it doesn't matter how consistent your file structure is. If your components don't follow well-defined rules, this will eventually make your project hard to maintain.

After creating and maintaining so many components, I can identify some characteristics that made them more consistent and reliable and, therefore, more enjoyable to use. The more a component resembled an HTML element, the more **reliable** it became.

> There's nothing more reliable than a `<div>`.

When using a component, you'll ask yourself one or more of these questions:

*   Question #1: What if I need to pass props to nested elements?
*   Question #2: Will this break the app for some reason?
*   Question #3: What if I want to pass `id` or another HTML attribute?
*   Question #4: Can I style it passing `className` or `style` props?
*   Question #5: What about event handlers?

**Reliability** means, in this context, not needing to open the file and look at the code to understand how it works. If you're dealing with a `<div>`, for example, you'll know the answers right away:

*   [Rule #1: Render only one element](#2249)
*   [Rule #2: Never break the app](#a129)
*   [Rule #3: Render all HTML attributes passed as props](#cbaa)
*   [Rule #4: Always merge the styles passed as props](#f168)
*   [Rule #5: Add all the event handlers passed as props](#3646)

This is the group of rules that we call [Singel](https://github.com/diegohaz/singel).

### Refactor-driven development

> Make it work, then make it better.

Of course, it's not possible to have all of your components following [Singel](https://github.com/diegohaz/singel). At some point — in fact, at many points — you'll have to break at least the first rule.

The components that should follow these rules are the most important part of your application: atoms, primitives, building blocks, elements or whatever you call your foundation components. In this article, I'm going to call them **single elements**.

Some of them are easy to abstract right away: `Button`, `Image`, `Input`. That is, those components that have a direct relationship with HTML elements. In some other cases, you'll only identify them when you start having to duplicate code. And that's fine.

Often, whenever you need to change some component, add a new feature, or fix a bug, you'll see — or start writing — duplicated styling and behavior. That's the signal to abstract it into a new single element.

The higher the percentage of single elements in your application compared to other components, the more consistent and easier to maintain it will be.

Put them into a separate folder — `elements`, `atoms`, `primitives` — so, whenever you import some component from it, you'll be sure about the rules it follows.

### A practical example

In this article I’m focussing on React. The same rules can be applied to any component-based library out there.

That said, consider that we have a `Card` component. It's composed of `Card.js` and `Card.css`, where we have styles for `.card`, `.top-bar`, `.avatar`, and other class selectors.

![](https://cdn-images-1.medium.com/max/800/1*Sm0TM1LOvrWi0WBVjVRIsA.png)

```
const Card = ({ profile, imageUrl, imageAlt, title, description }) => (
  <div className="card">
    <div className="top-bar">
      <img className="avatar" src={profile.photoUrl} alt={profile.photoAlt} />
      <div className="username">{profile.username}</div>
    </div>
    <img className="image" src={imageUrl} alt={imageAlt} />
    <div className="content">
      <h2 className="title">{title}</h2>
      <p className="description">{description}</p>
    </div>
  </div>
);
```

At some point, we have to put the avatar in another part of the application. Instead of duplicating HTML and CSS, we're going to create a new single element `Avatar` so we can reuse it.

#### Rule #1: Render only one element

It's composed by `Avatar.js` and `Avatar.css`, which has the `.avatar` style we extracted from `Card.css`. This renders just an `<img>`:

```
const Avatar = ({ profile, ...props }) => (
  <img
    className="avatar" 
    src={profile.photoSrc} 
    alt={profile.photoAlt} 
    {...props} 
  />
);
```

This is how we would use it inside `Card` and other parts of the application:

```
<Avatar profile={profile} />
```

#### Rule #2: Never break the app

An `<img>` doesn't break the app if you don't pass a `src` attribute, even though that's a required one. Our component, however, will break the whole app if we don't pass `profile`.

![](https://cdn-images-1.medium.com/max/800/1*aAB2QAEHkWxMBo-UFaCsUA.png)

React 16 provides a [new lifecycle method](https://reactjs.org/blog/2017/07/26/error-handling-in-react-16.html) called `componentDidCatch`, which can be used to gracefully handle errors inside components. Even though it's a good practice to implement error boundaries within your app, it may mask bugs inside our single element.

We must make sure that `Avatar` is reliable by itself, and assume that even required props may not be provided by a parent component. In this case, besides checking whether `profile` exists before using it, we should use `Flow`, `TypeScript`, or `PropTypes` to warn about it:

```
const Avatar = ({ profile, ...props }) => (
  <img 
    className="avatar" 
    src={profile && profile.photoUrl} 
    alt={profile && profile.photoAlt} 
    {...props}
  />
);

Avatar.propTypes = {
  profile: PropTypes.shape({
    photoUrl: PropTypes.string.isRequired,
    photoAlt: PropTypes.string.isRequired
  }).isRequired
};
```

Now we can render `<Avatar />` with no props and see on the console what it expects to receive:

![](https://cdn-images-1.medium.com/max/800/1*5Cjn18Fr2n_O1wHMGff4wQ.png)

Often, we ignore those warnings and let our console accumulate several of them. This makes `PropTypes` useless, since we'll likely never notice new warnings when they show up. So, make sure to always solve the warnings before they multiply.

#### Rule #3: Render all HTML attributes passed as props

So far, our single element was using a custom prop called `profile`. We should avoid using custom props, especially when they're mapped directly to HTML attributes. Learn more about it below, in [Suggestion #1: Avoid adding custom props](#c3e6).

We can easily accept all HTML attributes in our single elements by just passing all `props` down to the underlying element. We can solve the problem with custom props by expecting the respective HTML attributes instead:

```
const Avatar = props => <img className="avatar" {...props} />;

Avatar.propTypes = {
  src: PropTypes.string.isRequired,
  alt: PropTypes.string.isRequired
};
```

Now `Avatar` looks more like an HTML element:

```
<Avatar src={profile.photoUrl} alt={profile.photoAlt} />
```

This rule also includes rendering `children` when, of course, the underlying HTML element accepts it.

#### Rule #4: Always merge the styles passed as props

Somewhere in your application, you'll want the single element to have a slightly different style. You should be able to customize it whether by using `className` or `style` props.

The internal style of a single element is equivalent to the style that browsers apply to native HTML elements. That being said, our `Avatar`, when receiving a `className` prop, shouldn't replace the internal one — but append it.

```
const Avatar = ({ className, ...props }) => (
  <img className={`avatar ${className}`} {...props} />
);

Avatar.propTypes = {
  src: PropTypes.string.isRequired,
  alt: PropTypes.string.isRequired,
  className: PropTypes.string
};
```

If we applied an internal `style` prop to `Avatar`, it could be easily solved by using [object spread](https://github.com/tc39/proposal-object-rest-spread/blob/master/Spread.md):

```
const Avatar = ({ className, style, ...props }) => (
  <img 
    className={`avatar ${className}`}
    style={{ borderRadius: "50%", ...style }}
    {...props} 
  />
);

Avatar.propTypes = {
  src: PropTypes.string.isRequired,
  alt: PropTypes.string.isRequired,
  className: PropTypes.string,
  style: PropTypes.object
};
```

Now we can reliably apply new styles to our single element:

```
<Avatar
  className="my-avatar"
  style={{ borderWidth: 1 }}
/>
```

If you find yourself having to duplicate the new styles, don't hesitate to create another single element composing `Avatar`. It's fine — and often necessary — to create a single element that renders another single element.

#### Rule #5: Add all the event handlers passed as props

Since we're passing all `props` down, our single element is already prepared to receive any event handler. However, if we already have that event handler applied internally, what should we do?

In this case, we have two options: we can replace the internal handler with the prop altogether, or call both. That's up to you. Just make sure to **always** apply the event handler coming from the prop.

```
const callAll = (...fns) => (...args) => fns.forEach(fn => fn && fn(...args));

const internalOnLoad = () => console.log("loaded");

const Avatar = ({ className, style, onLoad, ...props }) => (
  <img 
    className={`avatar ${className}`}
    style={{ borderRadius: "50%", ...style }}
    onLoad={callAll(internalOnLoad, onLoad)}
    {...props} 
  />
);

Avatar.propTypes = {
  src: PropTypes.string.isRequired,
  alt: PropTypes.string.isRequired,
  className: PropTypes.string,
  style: PropTypes.object,
  onLoad: PropTypes.func
};
```

### Suggestions

#### Suggestion #1: Avoid adding custom props

When creating single elements — especially when developing new features in your application — you'll be tempted to add custom props in order to configure them in different ways.

Using `Avatar` as an example, by some eccentricity of the designer suppose you have some places where the avatar should be squared, and others where it should be rounded. You might think that it's a good idea to add a `rounded` prop to `Avatar`.

Unless you're creating a well-documented open source library, **resist that**. Besides introducing the need of documentation, it's not scalable and will lead to unmaintainable code. Always try to create a new single element — such as `AvatarRounded` — which renders `Avatar` and modifies it, rather than adding a custom prop.

If you keep using unique and descriptive names and building reliable components, you may have hundreds of them. It'll still be highly maintainable. Your documentation will be the names of the components.

#### Suggestion #2: Receive the underlying HTML element as a prop

Not every custom prop is evil. Often you'll want to change the underlying HTML element rendered by a single element. And adding a custom prop is the only way to achieve that.

```
const Button = ({ as: T, ...props }) => <T {...props} />;

Button.propTypes = {
  as: PropTypes.oneOfType([PropTypes.string, PropTypes.func])
};

Button.defaultProps = {
  as: "button"
};
```

A common example is rendering a `Button` as an `<a>`:

```
<Button as="a" href="https://google.com">
  Go To Google
</Button>
```

Or as another component:

```
<Button as={Link} to="/posts">
  Posts
</Button>
```

If you're interested on this feature, I recommend you to take a look at [Reas](https://github.com/diegohaz/reas), a React UI toolkit built with Singel in mind.

### Validate your single elements using Singel CLI

Finally, after reading all this, you may have wondered if there is a tool to automatically validate your elements against this pattern. I have developed such a tool, [Singel CLI](https://github.com/diegohaz/singel).

If you want to use it on an ongoing project, I suggest you create a new folder and start putting your singel elements there.

If you're using React, you can install `singel` through **npm** and run it this way:

```
$ npm install --global singel
$ singel components/*.js
```

The output will be similar to this:

![](https://cdn-images-1.medium.com/max/800/1*fE7wp8PS2EG7043OYcQhkg.png)

Another good way is to install it as a dev dependency in your project and add a script into `package.json`:

```
$ npm install --dev singel

{  
  "scripts": {  
    "singel": "singel components/*.js"  
  }  
}
```

Then, just run the **npm** script:

```
$ npm run singel
```

### Thank you for reading this!

If you like it and find it useful, here are some things you can do to show your support:

*   Hit the clap 👏 button on this article a few times (up to 50)
*   Give a star ⭐️ on GitHub: [https://github.com/diegohaz/singel](https://github.com/diegohaz/singel)
*   Follow me on GitHub: [https://github.com/diegohaz](https://github.com/diegohaz)
*   Follow me on Twitter: [https://twitter.com/diegohaz](https://twitter.com/diegohaz)

Thanks to [Raphael Thomazella](https://medium.com/@thomazella?source=post_page).

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
