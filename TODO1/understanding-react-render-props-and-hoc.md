> * 原文地址：[Understanding React Render Props and HOC](https://blog.bitsrc.io/understanding-react-render-props-and-hoc-b37a9576e196)
> * 原文作者：[Aditya Agarwal](https://blog.bitsrc.io/@adityaa803?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/understanding-react-render-props-and-hoc.md](https://github.com/xitu/gold-miner/blob/master/TODO1/understanding-react-render-props-and-hoc.md)
> * 译者：
> * 校对者：

# Understanding React Render Props and HOC

## A detailed introduction to Render Props and Higher-Order Components in React

![](https://cdn-images-1.medium.com/max/1000/1*ORm5S_4kr4hcNSnyoXZSKQ.png)

reactjs.org

If you have been doing some [React development recently](https://blog.bitsrc.io/how-to-write-better-code-in-react-best-practices-b8ca87d462b0), you must have come across terms like HOCs and Render Props. In this article, we’ll go deep into both these pattern to understand why we need them and how we can correctly use them to build better react applications.

### Why do we need these patterns?

React offers a simple method for code reuse and that is **Components.** A component encapsulates many things ranging from content, styles and business logic. So ideally in a single component we can have a combination of html, css and js all of which have a single purpose, a [single responsibility](https://blog.bitsrc.io/solid-principles-every-developer-should-know-b3bfa96bb688).

Tip: Using [**Bit** (GitHub](https://github.com/teambit/bit)) you can organize and share **reusable components** to be discovered, shared and developed from different projects and applications. It’s faster than re-writing them or maintaining a heavy library. Give it a try :)

- [**Bit — Share and build with code components**: Bit helps you share, discover and use code components between projects and applications to build new features and...](https://bitsrc.io "https://bitsrc.io")

#### Example

Let’s suppose we are working on an E-commerce application. Like any E-commerce application, a user is shown all the products available, and the user can add any product to cart. We will fetch the products data from an API and show the product catalog as a list of cards.

In this case, the React component can be implemented like this:

![](https://cdn-images-1.medium.com/max/800/1*Y_sQCauEZZUycXS4HDs6-Q.png)

[Link](https://carbon.now.sh/?bg=rgba%28171%2C184%2C195%2C0%29&t=material&wt=none&l=jsx&ds=true&dsyoff=20px&dsblur=68px&wc=true&wa=false&pv=48px&ph=32px&ln=false&fm=Hack&fs=14px&lh=133%25&si=false&code=import%2520React%252C%2520%257B%2520Component%2520%257D%2520from%2520%2522react%2522%253B%250A%250Aclass%2520ProductList%2520extends%2520Component%2520%257B%250A%2520%2520state%2520%253D%2520%257B%250A%2520%2520%2520%2520products%253A%2520%255B%255D%250A%2520%2520%257D%253B%250A%250A%2520%2520componentDidMount%28%29%2520%257B%250A%2520%2520%2520%2520getProducts%28%29.then%28products%2520%253D%253E%2520%257B%250A%2520%2520%2520%2520%2520%2520this.setState%28%257B%250A%2520%2520%2520%2520%2520%2520%2520%2520products%250A%2520%2520%2520%2520%2520%2520%257D%29%253B%250A%2520%2520%2520%2520%257D%29%253B%250A%2520%2520%257D%250A%250A%2520%2520render%28%29%2520%257B%250A%2520%2520%2520%2520return%2520%28%250A%2520%2520%2520%2520%2520%2520%253Cul%253E%250A%2520%2520%2520%2520%2520%2520%2520%2520%257Bthis.state.products.map%28product%2520%253D%253E%2520%28%250A%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%253Cli%253E%250A%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%253Cspan%253E%257Bproduct.name%257D%253C%252Fspan%253E%250A%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%253Ca%2520href%253D%2522%2523%2522%253EAdd%2520to%2520Cart%253C%252Fa%253E%250A%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%253C%252Fli%253E%250A%2520%2520%2520%2520%2520%2520%2520%2520%29%29%257D%250A%2520%2520%2520%2520%2520%2520%253C%252Ful%253E%250A%2520%2520%2520%2520%29%253B%250A%2520%2520%257D%250A%257D%250A%250Aexport%2520%257B%2520ProductList%2520%257D%253B&es=2x&wm=false&ts=false) to Code

For our admins, there is a management portal where they can add or remove products. In this portal we fetch the products data from the same API and show the product catalog in tabular form.

This React component can be implemented like this:

![](https://cdn-images-1.medium.com/max/800/1*rbLMZdroffO_nUWVA1rpGQ.png)

[Link](https://carbon.now.sh/?bg=rgba%28171%2C184%2C195%2C0%29&t=material&wt=none&l=jsx&ds=true&dsyoff=20px&dsblur=68px&wc=true&wa=false&pv=48px&ph=32px&ln=false&fm=Hack&fs=14px&lh=133%25&si=false&code=import%2520React%252C%2520%257B%2520Component%2520%257D%2520from%2520%2522react%2522%253B%250A%250Aclass%2520ProductTable%2520extends%2520Component%2520%257B%250A%2520%2520state%2520%253D%2520%257B%250A%2520%2520%2520%2520products%253A%2520%255B%255D%250A%2520%2520%257D%253B%250A%250A%2520%2520componentDidMount%28%29%2520%257B%250A%2520%2520%2520%2520getProducts%28%29.then%28products%2520%253D%253E%2520%257B%250A%2520%2520%2520%2520%2520%2520this.setState%28%257B%250A%2520%2520%2520%2520%2520%2520%2520%2520products%250A%2520%2520%2520%2520%2520%2520%257D%29%253B%250A%2520%2520%2520%2520%257D%29%253B%250A%2520%2520%257D%250A%250A%2520%2520handleDelete%2520%253D%2520currentProduct%2520%253D%253E%2520%257B%250A%2520%2520%2520%2520const%2520remainingProducts%2520%253D%2520this.state.products.filter%28%250A%2520%2520%2520%2520%2520%2520product%2520%253D%253E%2520product.id%2520!%253D%253D%2520currentProduct.id%250A%2520%2520%2520%2520%29%253B%250A%2520%2520%2520%2520deleteProducts%28currentProduct.id%29.then%28%28%29%2520%253D%253E%2520%257B%250A%2520%2520%2520%2520%2520%2520this.setState%28%257B%250A%2520%2520%2520%2520%2520%2520%2520%2520products%253A%2520remainingProducts%250A%2520%2520%2520%2520%2520%2520%257D%29%253B%250A%2520%2520%2520%2520%257D%29%253B%250A%2520%2520%257D%253B%250A%250A%2520%2520render%28%29%2520%257B%250A%2520%2520%2520%2520return%2520%28%250A%2520%2520%2520%2520%2520%2520%253Ctable%253E%250A%2520%2520%2520%2520%2520%2520%2520%2520%253Cthead%253E%250A%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%253Ctr%253E%250A%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%253Cth%253EProduct%2520Name%253C%252Fth%253E%250A%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%253Cth%253EActions%253C%252Fth%253E%250A%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%253C%252Ftr%253E%250A%2520%2520%2520%2520%2520%2520%2520%2520%253C%252Fthead%253E%250A%2520%2520%2520%2520%2520%2520%2520%2520%253Ctbody%253E%250A%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%257Bthis.state.products.map%28product%2520%253D%253E%2520%28%250A%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%253Ctr%2520key%253D%257Bproduct.id%257D%253E%250A%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%253Ctd%253E%257Bproduct.name%257D%253C%252Ftd%253E%250A%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%253Ctd%253E%250A%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%253Cbutton%2520onClick%253D%257B%28%29%2520%253D%253E%2520this.handleDelete%28product%29%257D%253E%250A%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520Delete%250A%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%253C%252Fbutton%253E%250A%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%253C%252Ftd%253E%250A%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%253C%252Ftr%253E%250A%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%29%29%257D%250A%2520%2520%2520%2520%2520%2520%2520%2520%253C%252Ftbody%253E%250A%2520%2520%2520%2520%2520%2520%253C%252Ftable%253E%250A%2520%2520%2520%2520%29%253B%250A%2520%2520%257D%250A%257D%250A%250Aexport%2520%257B%2520ProductTable%2520%257D%253B&es=2x&wm=false&ts=false) to Code

One thing that immediately sticks out is that both the components implement the product’s data fetching logic.

Going forward these situations might arise too.

*   We have to use the products data and show it in a different manner.
*   Fetch products data from different API (useful in User’s Cart page) but show it just like we do in `ProductList` .
*   Instead of fetching data from API, we have to access it from localStorage.
*   In the tabular product catalog, instead of a delete button, have a button with a different action.

If we make a different component for each of these then we’ll be duplicating a lot of code.

Fetching data and showing data are two separate concerns. As said earlier, It is much better if one component has one responsibility.

Let’s refactor the first component. It will take products data as prop and render the product catalog as a list of cards just like before. Since we don’t need [component state and lifecycle methods](https://blog.bitsrc.io/understanding-react-v16-4-new-component-lifecycle-methods-fa7b224efd7d) we’ll convert it to a functional component.

It will look like this now:

![](https://cdn-images-1.medium.com/max/800/1*H5Bao06wMbFJX1ILLd6QJA.png)

ProductList.js ([Link](https://carbon.now.sh/?bg=rgba%28171%2C184%2C195%2C0%29&t=material&wt=none&l=jsx&ds=true&dsyoff=20px&dsblur=68px&wc=true&wa=false&pv=48px&ph=32px&ln=false&fm=Hack&fs=14px&lh=133%25&si=false&code=import%2520React%2520from%2520%2522react%2522%253B%250A%250Aconst%2520ProductList%2520%253D%2520%28%257B%2520products%2520%257D%29%2520%253D%253E%2520%257B%250A%2520%2520return%2520%28%250A%2520%2520%2520%2520%253Cul%253E%250A%2520%2520%2520%2520%2520%2520%257Bproducts.map%28product%2520%253D%253E%2520%28%250A%2520%2520%2520%2520%2520%2520%2520%2520%253Cli%2520key%253D%257Bproduct.id%257D%253E%250A%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%253Cspan%253E%257Bproduct.name%257D%253C%252Fspan%253E%250A%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%253Ca%2520href%253D%2522%2523%2522%253EAdd%2520to%2520Cart%253C%252Fa%253E%250A%2520%2520%2520%2520%2520%2520%2520%2520%253C%252Fli%253E%250A%2520%2520%2520%2520%2520%2520%29%29%257D%250A%2520%2520%2520%2520%253C%252Ful%253E%250A%2520%2520%29%253B%250A%257D%253B%250A%250Aexport%2520%257B%2520ProductList%2520%257D%253B&es=2x&wm=false&ts=false) to Code)

Just like `ProductList` , `ProductTable` will be a function component that take product data as prop and render the data as rows of table.

Now let’s make a component named `ProductsData`. It fetches the products data from API. The data fetching and state updating will be just like in the original `ProductList` component. But what should we put in the render method of this component?

![](https://cdn-images-1.medium.com/max/800/1*YUTzVts0O0Nx8JdoBt0sRw.png)

ProductData.js ([Link](https://carbon.now.sh/?bg=rgba%28171%2C184%2C195%2C0%29&t=material&wt=none&l=jsx&ds=true&dsyoff=20px&dsblur=68px&wc=true&wa=false&pv=48px&ph=32px&ln=false&fm=Hack&fs=14px&lh=133%25&si=false&code=import%2520React%252C%2520%257B%2520Component%2520%257D%2520from%2520%2522react%2522%253B%250A%250Aclass%2520ProductData%2520extends%2520Component%2520%257B%250A%2520%2520state%2520%253D%2520%257B%250A%2520%2520%2520%2520products%253A%2520%255B%255D%250A%2520%2520%257D%253B%250A%250A%2520%2520componentDidMount%28%29%2520%257B%250A%2520%2520%2520%2520getProducts%28%29.then%28products%2520%253D%253E%2520%257B%250A%2520%2520%2520%2520%2520%2520this.setState%28%257B%250A%2520%2520%2520%2520%2520%2520%2520%2520products%250A%2520%2520%2520%2520%2520%2520%257D%29%253B%250A%2520%2520%2520%2520%257D%29%253B%250A%2520%2520%257D%250A%250A%2520%2520render%28%29%2520%257B%250A%2520%2520%2520%2520return%2520%27what%2520should%2520we%2520return%2520here%253F%27%253B%250A%2520%2520%257D%250A%257D%250A%250Aexport%2520%257B%2520ProductData%2520%257D%253B%250A&es=2x&wm=false&ts=false) to Code)

If we simply put the ProductList component then we can’t reuse this component for ProductTable. Somehow, if this component can ask for what to render then the issue will be solved. At one place we will tell it to render the `ProductList` component and in the management portal we will tell it to render `ProductTable` component.

This is where render props and HOCs come into play. They are nothing but ways for a component to ask what should it render. This drives code reuse even further.

Now that we know why we need them, let’s see how to use them.

### Render Props

Understanding Render Props at a conceptual level is very easy. Let’s forget about React for a minute and look at things in context of vanilla JavaScript.

We have a function that calculates the sum of two numbers. At first we just want to log the result to console. So, we designed the function like this:

![](https://cdn-images-1.medium.com/max/800/1*3fUyzeYTNnRlxS9-A5Ic_Q.png)

However, we soon find out that the sum function is very useful and we need it in other places also. So, instead of logging it to console we want the sum function to provide the result only, and let the caller decide how it wants to use the result.

It can be done in this manner:

![](https://cdn-images-1.medium.com/max/800/1*KO9pes8Nw2CAtOoum9iOoA.png)

[Link](https://carbon.now.sh/?bg=rgba%28171%2C184%2C195%2C0%29&t=material&wt=none&l=javascript&ds=true&dsyoff=20px&dsblur=68px&wc=true&wa=false&pv=48px&ph=32px&ln=false&fm=Hack&fs=14px&lh=133%25&si=false&code=const%2520sum%2520%253D%2520%28a%252C%2520b%252C%2520fn%29%2520%253D%253E%2520%257B%250A%2520%2520const%2520result%2520%253D%2520a%2520%252B%2520b%253B%250A%2520%2520fn%28result%29%253B%250A%257D%250A%250A%250A%252F%252FUsage%250A%250Asum%281%252C%25202%252C%2520%28result%29%2520%253D%253E%2520%257B%250A%2520%2520console.log%28result%29%253B%250A%257D%29%250A%250Aconst%2520alertFn%2520%253D%2520%28result%29%2520%253D%253E%2520%257B%250A%2520%2520alert%28result%29%253B%250A%257D%250A%250Asum%283%252C%25206%252C%2520alertFn%29&es=2x&wm=false&ts=false) to Code

We pass `sum` function a callback function as argument `fn`. The `sum` function then calculates the result and calls `fn` with the result as an argument. This way the callback function gets the result and it is free to do anything with the result.

This forms the essence of render props. We will gain more clarity by using the pattern so let’s apply it to the problem we are facing right now.

Instead of a function that calculates the sum of two numbers, there is a component `ProductsData` that fetches products data. Now `ProductsData` component can be passed a function via props. The `ProductsData` component will then fetch products data and provide that data to the function that was passed as prop. The passed function can now do whatever it want with the products data.

In React, it can be implemented like this:

![](https://cdn-images-1.medium.com/max/800/1*bVc30RctgB9yecfgqJLJcg.png)

[Link](https://carbon.now.sh/?bg=rgba%28171%2C184%2C195%2C0%29&t=material&wt=none&l=jsx&ds=true&dsyoff=20px&dsblur=68px&wc=true&wa=false&pv=48px&ph=32px&ln=false&fm=Hack&fs=14px&lh=133%25&si=false&code=import%2520React%252C%2520%257B%2520Component%2520%257D%2520from%2520%2522react%2522%253B%250A%250Aclass%2520ProductData%2520extends%2520Component%2520%257B%250A%2520%2520state%2520%253D%2520%257B%250A%2520%2520%2520%2520products%253A%2520%255B%255D%250A%2520%2520%257D%253B%250A%250A%2520%2520componentDidMount%28%29%2520%257B%250A%2520%2520%2520%2520getProducts%28%29.then%28products%2520%253D%253E%2520%257B%250A%2520%2520%2520%2520%2520%2520this.setState%28%257B%250A%2520%2520%2520%2520%2520%2520%2520%2520products%250A%2520%2520%2520%2520%2520%2520%257D%29%253B%250A%2520%2520%2520%2520%257D%29%253B%250A%2520%2520%257D%250A%250A%2520%2520render%28%29%2520%257B%250A%2520%2520%2520%2520return%2520this.props.render%28%257B%250A%2520%2520%2520%2520%2520%2520products%253A%2520this.state.products%250A%2520%2520%2520%2520%257D%29%253B%250A%2520%2520%257D%250A%257D%250A%250Aexport%2520%257B%2520ProductData%2520%257D%253B%250A&es=2x&wm=false&ts=false) to Code

Just like the `fn` argument, we have a **render** prop which will be passed a function. Then the `ProductData` component calls this function with products data as argument.

We can thus use the `ProductData` component in this manner.

![](https://cdn-images-1.medium.com/max/800/1*_nSoSbkcZpgkxGrYtrea8g.png)

[Link](https://carbon.now.sh/?bg=rgba%28171%2C184%2C195%2C0%29&t=material&wt=none&l=jsx&ds=true&dsyoff=20px&dsblur=68px&wc=true&wa=false&pv=48px&ph=32px&ln=false&fm=Hack&fs=14px&lh=133%25&si=false&code=%253CProductData%250A%2520%2520render%253D%257B%28%257B%2520products%2520%257D%29%2520%253D%253E%2520%253CProductList%2520products%253D%257Bproducts%257D%2520%252F%253E%257D%250A%252F%253E%250A%250A%250A%253CProductData%250A%2520%2520render%253D%257B%28%257B%2520products%2520%257D%29%2520%253D%253E%2520%253CProductTable%2520products%253D%257Bproducts%257D%2520%252F%253E%257D%250A%252F%253E%250A%250A%250A%253CProductData%2520render%253D%257B%28%257B%2520products%2520%257D%29%2520%253D%253E%2520%28%250A%2520%2520%253Ch1%253E%250A%2520%2520%2520%2520%2520%2520Number%2520of%2520Products%253A%250A%2520%2520%2520%2520%2520%2520%253Cstrong%253E%257Bproducts.length%257D%253C%252Fstrong%253E%250A%2520%2520%253C%252Fh1%253E%250A%2520%2520%250A%29%257D%2520%252F%253E%250A&es=2x&wm=false&ts=false) to Code

As we can see **render props** is quite a versatile pattern. Most things can be accomplished in a very straight-forward manner. And this is exactly why we can shoot ourselves in the foot.

![](https://i.loli.net/2018/12/17/5c17638f6b5ad.png)

![](https://i.loli.net/2018/12/17/5c17639dc0217.png)

![](https://i.loli.net/2018/12/17/5c1763acaf846.png)

A simple way to avoid nesting is to break out the component into smaller components and keep these components in separate files. Another way is to make more components and compose them instead of having long functions inside render props.

Next we’ll look at another popular pattern called HOC.

### Higher Order Components (HOC)

In this pattern we define a function which takes a component as an argument and then returns the same component but with some added functionality.

If that sounds familiar, that’s because it is similar to decorator pattern used extensively in Mobx. Many languages like Python have decorators in-built and JavaScript is going to support decorators soon. HOCs are very much like decorators.

Understanding HOCs with code is much easier than to explain with words. So we’ll look at the code first.

![](https://cdn-images-1.medium.com/max/800/1*c9Y18PctkxW_GpUuYggojw.png)

[Link](https://carbon.now.sh/?bg=rgba%28171%2C184%2C195%2C0%29&t=material&wt=none&l=jsx&ds=true&dsyoff=20px&dsblur=68px&wc=true&wa=false&pv=48px&ph=32px&ln=false&fm=Hack&fs=14px&lh=133%25&si=false&code=import%2520React%252C%2520%257B%2520Component%2520%257D%2520from%2520%2522react%2522%253B%250A%250Aconst%2520withProductData%2520%253D%2520WrappedComponent%2520%253D%253E%250A%2520%2520class%2520ProductData%2520extends%2520Component%2520%257B%250A%2520%2520%2520%2520state%2520%253D%2520%257B%250A%2520%2520%2520%2520%2520%2520products%253A%2520%255B%255D%250A%2520%2520%2520%2520%257D%253B%250A%250A%2520%2520%2520%2520componentDidMount%28%29%2520%257B%250A%2520%2520%2520%2520%2520%2520getProducts%28%29.then%28products%2520%253D%253E%2520%257B%250A%2520%2520%2520%2520%2520%2520%2520%2520this.setState%28%257B%250A%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520products%250A%2520%2520%2520%2520%2520%2520%2520%2520%257D%29%253B%250A%2520%2520%2520%2520%2520%2520%257D%29%253B%250A%2520%2520%2520%2520%257D%250A%250A%2520%2520%2520%2520render%28%29%2520%257B%250A%2520%2520%2520%2520%2520%2520return%2520%253CWrappedComponent%2520products%253D%257Bthis.state.products%257D%2520%252F%253E%253B%250A%2520%2520%2520%2520%257D%250A%2520%2520%257D%253B%250A%250Aexport%2520%257B%2520withProductData%2520%257D%253B%250A&es=2x&wm=false&ts=false) to Code

As we can see the data fetching and state updating logic is just like what we did in render props. The only change is that the component class is inside a function. The function takes a component as argument and then inside the render method of the class we render the passed component but with additional props. Pretty simple implementation for a pattern with such a complicated name, right?

![](https://cdn-images-1.medium.com/max/800/1*k-Px1N8t5dnq0snEtdHE_g.png)

[Link](https://carbon.now.sh/?bg=rgba%28171%2C184%2C195%2C0%29&t=material&wt=none&l=jsx&ds=true&dsyoff=20px&dsblur=68px&wc=true&wa=false&pv=48px&ph=32px&ln=false&fm=Hack&fs=14px&lh=133%25&si=false&code=%252F%252F%2520Wrap%2520ProductList%252C%2520ProductTable%2520to%2520get%2520the%2520higher%2520order%2520components%250Aconst%2520ProductListWithData%2520%253D%2520withProductData%28ProductList%29%253B%250Aconst%2520ProductTableWithData%2520%253D%2520withProductData%28ProductTable%29%253B%250A%250A%250A%252F%252F%2520Use%2520the%2520higher%2520order%2520components%2520just%2520like%2520normal%2520components.%250A%250A%253Cdiv%253E%250A%2520%2520%253CProductListWithData%2520%252F%253E%250A%2520%2520%253CProductTableWithData%2520%252F%253E%250A%253C%252Fdiv%253E&es=2x&wm=false&ts=false) to Code

So now we have looked at why we need render props, HOCs and how we can implement both of them.

One question remains: how do we choose between Render Props and HOCs? There have been quite a lot of articles on this topic so I won’t talk about that now. Maybe in my next post :)

[When to NOT use Render Props](https://blog.kentcdodds.com/when-to-not-use-render-props-5397bbeff746) — Kent C. Dodds

[HOCs vs Render Props](https://www.richardkotze.com/coding/hoc-vs-render-props-react) — Richard Kotze

### Conclusion

In this article we looked at why we need these patterns, the essence of each pattern and how we can leverage these patterns to build highly reusable components. That’s all for now, hope you liked it, and please feel free to **comment and ask anything**. I’d be happy to talk 👏

> October 2018 Update : React hooks has been released in alpha. They will take away the pain of writing Class Components, HOCs and Render Props. I will be writing an explainer soon, follow me on [Twitter](https://twitter.com/dev__adi) and [Medium](https://medium.com/@adityaa803) or subscribe to [my newsletter](https://buttondown.email/itaditya) to get updates on it.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
