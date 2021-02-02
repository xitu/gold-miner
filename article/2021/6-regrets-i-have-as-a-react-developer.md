> * 原文地址：[6 Regrets I Have As a React Developer](https://medium.com/better-programming/6-regrets-i-have-as-a-react-developer-52e95a8ff8a4)
> * 原文作者：[Mohammad Faisal](https://medium.com/@56faisal)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/6-regrets-i-have-as-a-react-developer.md](https://github.com/xitu/gold-miner/blob/master/article/2021/6-regrets-i-have-as-a-react-developer.md)
> * 译者：
> * 校对者：

# 6 Regrets I Have As a React Developer

#### Things I wish I did earlier

![Photo by [Francisco Gonzalez](https://unsplash.com/@franciscoegonzalez?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) on [Unsplash](https://unsplash.com/s/photos/sadness?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)](https://cdn-images-1.medium.com/max/8396/1*b_I4LDS0bICAcnC1bdOM2g.jpeg)

React is a great tool to learn. It allows us to do things in our own way. It's both powerful and limiting at the same time.

For new developers, there’s no clear guideline on which tool is best for which use case, and as a result there are multiple solutions to every problem. And sure enough, I also fell into this mistake and was late to adopt some best practices.

Today I am sharing the top 6 things that I should have started doing earlier in my React development journey.

---

## 1. Testing

For a long time testing was my weakness. I didn’t write tests for my components and, as expected, often I had to debug typos.

But as daunting as it may look, testing in React is really easy (For most use-cases).

Adding a very basic test that takes two minutes to write can save hours in the long run. Here’s a test that checks if the `Title` component will render correctly:

```
it('checks if the title component is in the document', () => {
    expect(screen.getByText('Title')).toBeInTheDocument()
})
```

If you are using `create-react-app` you already have the testing setup in place. Just start writing tests as much (and as early) as possible.

---

## 2. Using the Correct Folder Structure

I think as a beginner in React my biggest mistake was not using the correct folder structure. Essentially what I did was group files according to their type:

```
|-store

  |--actions
    |---UserAction.js
    |---ProductAction.js
    |---OrderAction.js

  |--reducers
    |---UserReducer.js
    |---ProductReducer.js
    |---OrderReducer.js
```

But as the project grew bigger it was getting tougher to find any file.

So finally I started to organize my files by feature. That means all the similar files are now put in the same folder:

```
|-store

  |--user
    |---UserAction.js
    |---UserReducer.js

  |--product    
    |---ProductAction.js
    |---ProductReducer.js

  |--order    
    |---OrderAction.js
    |---OrderReducer.js
```

Now it’s much easier for me to navigate through the file system to find anything.

---

## 3. Using Styled Components

I started using `css` files at the beginning to style my components but as time went on it got really messy.

After some time I learned `sass` and it was great! But although it provided some syntactic sugar over vanilla `css` it was really hard to style any component. Reusing any style was especially hard as I often forgot that a particular style was already there.

```null
// inside jsx
<button className="btn-submit">

<button/>


// inside css files
.btn-submit {

}
```

Also, personally, I don’t like using `className` property inside `JSX`.

After some time I found a library called `styled-components` which rescued for me. Now I just declare my styles as separate components and my code is more clean and easy to the eye.

Also `styled-components` accepts `props`, which helped me to reduce conditional styling in my components by a lot!

```null
const Button = styled.button`
  font-size: 1em;
  margin: 1em;
  padding: 0.25em 1em;
  border-radius: 3px;
`;
```

---

## 4. Switching to Functional Components Early

In the beginning, I was introduced to React through `class-components` and for around a year I **only** worked with class components.

After I switched to functional components their enormous benefits became clear. I think `react-hooks` is the single best thing that’s happened since React has been in the picture.

There are very few reasons that anyone in 2021 would try to use class-based components.

Now I’m trying to rewrite all my components to functional components.

---

## 5. Using a Form Handling Library

The handling form is maybe one of the most common features of any application. I used the vanilla `onChange` method for a good amount of time. Handling data and validation was big pain!

**Until I discovered `Formik` and `react-hook-form`.**

Using these two libraries, form handling has become so much easier and cleaner. On top of that, form validation is now declarative and easy for me.

---

## 6. Using a Linter and Formatter

For a long time formatting my code manually was a great hassle. I like my code tidy and clean so every time I needed to:

* Remove an unused variable
* Remove an unused function
* Remove unused imports
* Use proper indentation

I had to do it manually. Until I came across `Eslint` and `Prettier` — two libraries that make the painful work of formatting easy!

So, those are the top 6 libraries I wish I started using earlier in my career. What about you?

Have a nice day!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
