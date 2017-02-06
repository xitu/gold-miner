> * 原文地址：[A 5-minute Intro to Styled Components](https://medium.freecodecamp.com/a-5-minute-intro-to-styled-components-41f40eb7cd55#.z1nrxe1zr)
* 原文作者：[Sacha Greif](https://medium.freecodecamp.com/@sachagreif)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

# A 5-minute Intro to Styled Components

![](https://cdn-images-1.medium.com/max/2000/1*DIFji4ZmJa4_H3EpbG2XAw.png)

CSS is weird. You can learn the basics of it in 15 minutes. But it can take years before you figure out a good way to organize your styles.

Part of this is just due to the quirks of the language itself. Out of the box, CSS is quite limited, with no variables, loops, or functions. At the same time, it’s quite permissive in that you can style elements, classes, IDs, or any combination of these.

### Chaotic Style Sheets

As you’ve probably experienced for yourself, this is often a recipe for chaos. And while preprocessors like SASS and LESS add a lot of useful features, they don’t really do much to stop CSS anarchy.

That organizational job was left to methodologies like [BEM](http://getbem.com/), which — while useful — is entirely optional, and can’t be enforced at the language or tooling level.

### The New Wave Of CSS

Fast forward a couple years, and a new wave of JavaScript-based tools are trying to solve these issues at their root, by changing the way you write CSS.

[Styled Components](https://github.com/styled-components/styled-components) is one of these libraries, and it has quickly attracted a lot of attention due to its mix of innovation and familiarity. So if you use React (and if you don’t, [check out my JavaScript study plan](https://medium.freecodecamp.com/a-study-plan-to-cure-javascript-fatigue-8ad3a54f2eb1) and my [intro to React](https://medium.freecodecamp.com/the-5-things-you-need-to-know-to-understand-react-a1dbd5d114a3)), it’s definitely worth taking a look at this new CSS alternative.

I recently used it to [redesign my personal site](http://sachagreif.com/), and today I wanted to share a few things I learned in the process.

### Components, Styled

The main thing you need to understand about Styled Components is that its name should be taken quite literally. You are no longer styling HTML elements or components based on their class or HTML element:

    <h1 className="title">Hello World</h1>

    h1.title{
      font-size: 1.5em;
      color: purple;
    }

Instead, you’re defining **styled components** that possesses their own encapsulated styles. Then you’re using these freely throughout your codebase:

    import styled from 'styled-components';

    const Title = styled.h1`
      font-size: 1.5em;
      color: purple;
    `;

    <Title>Hello World</Title>

This might seem like a minor difference, and in fact both syntaxes are very similar. But they key difference is that styles are now **part of **their component.

In other words, we’re getting rid of CSS classes as an intermediary step between the component and its styles.

As styled-components co-creator Max Stoiber says:

*“The basic idea of*`styled-components`*is to enforce best practices by removing the mapping between styles and components.”*

### Offloading Complexity

This will seem counter-intuitive at first, since the whole point of using CSS instead of directly styling HTML elements (remember the `<font>` tag?) is to decouple styles and markup by introducing this intermediary class layer.

But that decoupling also creates a lot of complexity, and there’s an argument to be made that compared to CSS, a “real” programming language like JavaScript is much better equipped to handle that complexity.

### Props Over Classes

In keeping with this no-classes philosophy, styled-components makes use of props over classes when it comes to customizing the behavior of a component. So instead of:

    <h1 className="title primary">Hello World</h1> // will be blue

    h1.title{
      font-size: 1.5em;
      color: purple;

      &.primary{
        color: blue;
      }
    }

You’d write:

    const Title = styled.h1`
      font-size: 1.5em;
      color: ${props => props.primary ? 'blue' : 'purple'};
    `;

    <Title primary>Hello World</Title> // will be blue

As you can see, styled-components let you clean up your React components by keeping all CSS and HTML-related implementation details out of them.

That said, styled-components CSS is still CSS. So things like this are also totally valid (although slightly non-idiomatic) code:

    const Title = styled.h1`
      font-size: 1.5em;
      color: purple;

      &.primary{
        color: blue;
      }
    `;

    <Title className="primary">Hello World</Title> // will be blue

This is one feature that makes styled-components very easy to get into: when it doubt, you can always fall back to what you know!

### Caveats

It’s also important to mention that styled-components is still a young project, and that some features aren’t yet fully supported. For example, if you want to [style a child component from a parent](https://github.com/styled-components/styled-components/issues/142), you’ll have to rely on using CSS classes for now (at least until styled-components v2 comes out).

There’s also no “official” way to [pre-render your CSS on the server](https://github.com/styled-components/styled-components/issues/124) yet, although it’s definitely possible by injecting the styles manually.

And the fact that styled-components generates its own randomized class names can make it hard to use your browser’s dev tools to figure out where your styles are originally defined.

But what’s very encouraging is that the styled-components core team is aware of all these issues, and is hard at work on fixing them one by one. [Version 2 is coming soon](https://github.com/styled-components/styled-components/tree/v2), and I’m really looking forward to it!

### Learn More

My goal here is not to explain in detail how styled-components works, but more to give you a small glimpse so you can decide for yourself if it’s worth checking out.

If I’ve managed to make you curious, here some places where you can learn more about styled-components:

- Max Stoiber recently wrote an article about the reason for styled-components for [Smashing Magazine](https://www.smashingmagazine.com/2017/01/styled-components-enforcing-best-practices-component-based-systems/).
- The [styled-components repo](https://github.com/styled-components/styled-components) itself has a extensive documentation.
- [This article by Jamie Dixon](https://medium.com/@jamiedixon/styled-components-production-patterns-c22e24b1d896#.tfxr5bws2) outlines a few benefits of switching to styled-components.
- If you want to learn more about how the library is actually implemented, check out [this article](http://mxstbr.blog/2016/11/styled-components-magic-explained/) by Max.

And if you want to go even further, you can also check out [Glamor](https://github.com/threepointone/glamor), a different take on new-wave CSS!
