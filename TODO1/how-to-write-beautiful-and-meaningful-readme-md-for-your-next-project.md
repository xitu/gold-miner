> * 原文地址：[How to Write Beautiful and Meaningful README.md](https://blog.bitsrc.io/how-to-write-beautiful-and-meaningful-readme-md-for-your-next-project-897045e3f991)
> * 原文作者：[Divyansh Tripathi [SilentLad]](https://medium.com/@silentlad)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-write-beautiful-and-meaningful-readme-md-for-your-next-project.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-write-beautiful-and-meaningful-readme-md-for-your-next-project.md)
> * 译者：
> * 校对者：

# How to Write Beautiful and Meaningful README.md

#### Tips for an awesome readme file (and why that’s important)

We, developers, are very good with code and all the minute details of our projects. But some of us (me included) lack in soft-skills even in the online community.

> **A developer would spend an hour adjusting the padding and margin of a single button. But wouldn’t spare 15 minutes for the project description Readme file.**

> I hope most of you already know what a readme.md file is and what it is used for. But for the newbies here I’ll try to explain what it exactly is.

#### What is a Readme.md?

README (as the name suggests: “read me”) is the first file one should read when starting a new project. It’s a set of useful information about a project and a kind of manual. It is the first file Github or any Git hosting site will show when someone opens your repository..

![](https://cdn-images-1.medium.com/max/2000/1*DZa8j46R3Rw0nNYRLewSqg.png)

As you can clearly see over here **Readme.md** file is in the root of the repository and is automatically displayed by github below the project directory.

And the`.md`extension comes from a word: **markdown**. It's a markup language for text formatting. Just like HTML it is a markup language to make our documents presentable.

Here is an example of a markdown file and how it renders on github actually. I use VSCode here for preview which shows a preview of markdown files simultaneously.

![](https://cdn-images-1.medium.com/max/2144/1*WAn_bJ_mLxOMCzBAKtu4ZQ.png)

**Here is an official**[ Github cheat sheet](https://guides.github.com/pdfs/markdown-cheatsheet-online.pdf) **for Markdown format if you need to dwell deep into the language.**

## Why spend time on your Readme?

Now let’s talk business. You spent hours on a project, you made it public on GitHub and you want people/recruiters/colleagues/(Ex?) see your project. Do you really think they would go into `root/src/app/main.js` to view that beautiful logic of yours? Seriously?

Now that I’ve got your attention, let us see how to tackle this.

## Generating documentation for your components

In addition to your project's readme, documenting your components is crucial for a comprehensible codebase. It makes it much easier to reuse components and maintain your code. Use tools like [**Bit**](https://bit.dev) ([Github](https://github.com/teambit/bit)) to auto-generate documentation for components shared on [bit.dev](https://bit.dev)

![Example: searching for components shared on Bit.dev](https://cdn-images-1.medium.com/max/2000/1*Nj2EzGOskF51B5AKuR-szw.gif)
[**Share reusable code components as a team · Bit**](https://bit.dev)

## Describe your project! (TL;DR)

Write a good description of your projects. Just for guidelines, you can format your description into the following topics:-

* Title (A Title Image too if possible…Edit them on canva.com if you are not a graphic designer.)
* Description(Describe by words and images alike)
* Demo(Images, Video links, Live Demo links)
* Technologies Used
* Special Gotchas of your projects (Problems you faced, unique elements of your project)
* Technical Description of your project like- Installation, Setup, How to contribute.

## Let’s dive deep into technicalities

I’m gonna use this one project of mine as a reference, which I think has one of the most beautiful readme files I’ve written and even came across. You can check out the code of the Readme.md file here: [**silent-lad/VueSolitaire**](https://github.com/silent-lad/VueSolitaire)

Use the pencil icon to show the markdown code:

![](https://cdn-images-1.medium.com/max/2000/1*fmypQUo2pAjk9GOCO1lPnQ.png)

## 1. ADD IMAGES! PLEASE!

You may have a photographic memory but your readers might need some actual photographs of the demo of your project.

For example, I made a solitaire project and added images as a description in the readme.

![](https://cdn-images-1.medium.com/max/2000/1*29b3hWXq4PTI1Yg2J97RyA.png)

Now you may want to add a video description of your projects too. Just like I did. BUT… Github doesn’t let you add a video to the readme… So… So what?

#### …WE USE GIFS

![HAHA… Got ya Github.](https://cdn-images-1.medium.com/max/2000/1*iP4iC4WnyEJHE9SQ7oROWQ.gif)

Gifs fall in the category of images and github lets you have them on your readme.

## 2. The Badge of Honour

Badges on your readme give the viewer some feel of authenticity. You can get custom/regularly used shields(badges) for your repository from: [**https://shields.io**](https://shields.io/)

![](https://cdn-images-1.medium.com/max/2000/1*iGaDiLE_BwCbSROvPT8XKg.png)

You can get personalised shields such as the number of stars on the repo and code percentage indicators too.

## 3. Add A Live Demo

If possible get your project hosted and set up a running demo. After that **LINK THIS DEMO TO YOUR README.** You have no idea how many people might end up playing around with your projects. And recruiter just LOVE live projects. **It shows your projects are not just a dump of code laying on github and you actually do mean business.**

![](https://cdn-images-1.medium.com/max/2000/1*LSR8M5mctiQsFsPzsH9ujQ.png)

You can use Hyperlinks in your Readme. So give a Live Demo link just below the title Image.

## 4. Use Code Formating

Markdown gives you the option to format text as code. So don’t write code as plain text instead use \` (Tilde) to wrap the code inside code formatting as such- `var a = 1;`

Github also gives you the option to **specify the language the code** is written in so that it may use the specific text highlighting to make the code more readable. To do this use

**\`\`\`{language-extension}\<space>{Code block Inside}\`\`\`**

{ \`\`\` }- Triple tilde is used for multi-line code and it also lets you specify the language of the code block.

**With Language Highlighting:**

![](https://cdn-images-1.medium.com/max/2000/1*lTbiCaBk1Y4TWG4bI1-D7A.png)

**Without Langage Highlighting:**

![](https://cdn-images-1.medium.com/max/2000/1*_w3yaD4Lhcwqxa2AU4TSrA.png)

## 5. Use of HTML

Yes, you can use HTML inside. Not all the features though. But most of it. Although you should stick to markdown only but, some features like centring images and text in the readme is only possible by HTML.

![](https://cdn-images-1.medium.com/max/2726/1*pq9WpGpyChqxmTLMz34l5A.png)

## 6. Be Creative

Now the rest is upon you, each project needs a different Readme.md and a different type of description. But remember the 15–20 minutes you spend on the readme could end up making a HUGE impact on the visitors of your github profile.

Just for your reference here are some project with a readme:

- [**silent-lad/VueSolitaire**](https://github.com/silent-lad/VueSolitaire)
- [**silent-lad/Vue2BaremetricsCalendar**](https://github.com/silent-lad/Vue2BaremetricsCalendar)

## Learn More

- [**How to Share React UI Components between Projects and Apps**](https://blog.bitsrc.io/how-to-easily-share-react-components-between-projects-3dd42149c09)
- [**13 Top React Component Libraries for 2020**](https://blog.bitsrc.io/13-top-react-component-libraries-for-2020-488cc810ca49)
- [**11 Top React Developer Tools for 2020**](https://blog.bitsrc.io/11-top-react-developer-tools-for-2020-3860f734030b)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
