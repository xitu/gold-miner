> * 原文地址：[5 reasons why you should use Svelte for Front End Development in 2021](https://medium.com/javascript-in-plain-english/5-reasons-why-you-should-use-svelte-for-front-end-development-in-2021-c9e84db4f55c)
> * 原文作者：[Eric Bandara](https://medium.com/@ericbandara95)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/5-reasons-why-you-should-use-svelte-for-front-end-development-in-2021.md](https://github.com/xitu/gold-miner/blob/master/article/2020/5-reasons-why-you-should-use-svelte-for-front-end-development-in-2021.md)
> * 译者：
> * 校对者：

# 5 reasons why you should use Svelte for Front End Development in 2021

![A Photo By [Randy Fath](https://unsplash.com/@randyfath) on [Unsplash](https://unsplash.com/)](https://cdn-images-1.medium.com/max/2000/0*Ri1Sl9cP2_ry2vYJ)

Svelte is a front-end JavaScript framework that was developed by Rich Harris in 2016. Currently, it is using in many software companies as their main frontend framework because many things offer by Svelte to which make developer’s life way less complicated.

So, In this article, I’m going to be talking about 5 reasons why Svelte is the best JavaScript framework or a compiler or whatever you want to call it that.

## What is Svelte?

**It is a new kind of a JavaScript framework or rather a compiler which work behind to turn your component into awesomely optimized JavaScript.**

## Run your first App in just 2 steps

Step 1. Run the following command to create a simple project.

```bash
npx degit sveltejs/template my-startup
```

Step 2. Run the project. Here you need to go inside the project directory and install all the packages and run your project.

```bash
cd my-startup
npm install
npm run dev
```

Your Svelte app will be up on [http://localhost:5000/](http://localhost:5000/).

## Why you should use Svelte

#### 1. Performance

Svelte has fairly a high score than Angular or React. The main reason for that is it is a well-optimized framework that offers flexibility to produce high-quality code during the compile time. In other words, it is basically a compiler. This minimizes the runtime overhead that further leads to faster loading and interface navigation.

#### 2. Bundle size

The bundle's size can be said as tiny when compared to Angular like other frameworks. The bundle is what you are shipping to the client. So, it is always better to be small what you’re sending over the Internet to your client. Assume that, if someone has a slow connection. Svelte is going to make a difference and because it significantly lower in size than Vue and four times smaller than Angular.

#### 3. Lines of code

Lines of codes are what really drew most developers fall for Svelte. Because the lines of code are so low and you will see it is about half the size of Vue and it’s about half the size of React and Angular. So it is obviously making an overall better experience for the developer. Just check out the “Hello world” example.

```html
<script>
 let wish = ‘Make me a better developer’;
</script>
<h1>Good day, {wish}!</h1>
```

But what if you are going to use Angular, Vue, or react?

#### 4. Popularity

Obviously, Svelte is not the most popular in many readers' minds. But, If you look at the following survey, you can see that Svelte is in second place of developer interest and satisfaction ratio.

![Source: [https://2019.stateofjs.com/front-end-frameworks/](https://2019.stateofjs.com/front-end-frameworks/)](https://cdn-images-1.medium.com/max/4270/1*Xfe9crp6fWvzlh4AAftQsQ.png)

Other than that, there are 40k Github starts for the Svelte repository. With compared to Angular, React, and Vue it is so less. But, During 2019 Svelte had 18k stars and it has doubled in 2020. So it’s gaining a lot of attraction and I think it will get just a lot bigger with time.

#### 5. Developer Experience

So, the last part is the developer experience. Svelte is all HTML and it is just much more intuitive.

```html
<style>
 p {
  color: red;
  font-family: ‘Arial’, cursive;
  font-size: 2.3em;
}
</style>
<p>Styled paragraph!</p>
```

---

It React you have to have your class to be extended and then you got a render and return. Then you got a constructor and many things to care in one file of code. Vue is a little bit better. But, you still have all this stuff which are necessarily intuitive. But Svelte is just completely intuitive. If you already know HTML and it’s less line of code lines of code and obviously easy.

## Conclusion

So those are my 5 reasons for preferring Svelte over others. I think as it becomes more popular it will be adopted more. Finally, I think it is a great compiler framework which is so helpful.

You can use this useful link to practice and get a better idea about coding.

[Svelte examples](https://svelte.dev/examples#hello-world)

Thank you!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
