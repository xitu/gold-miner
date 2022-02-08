> * 原文地址：[Github Copilot: Review After 3 Months of Usage with Examples](https://javascript.plainenglish.io/github-copilot-review-after-3-months-of-usage-with-examples-74335cd45478)
> * 原文作者：[Volodymyr Golosay](https://medium.com/@golosay)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2022/github-copilot-review-after-3-months-of-usage-with-examples.md](https://github.com/xitu/gold-miner/blob/master/article/2022/github-copilot-review-after-3-months-of-usage-with-examples.md)
> * 译者：
> * 校对者：

# Github Copilot: Review After 3 Months of Usage with Examples

![Purchased on Shutterstock, edited by me 😊](https://cdn-images-1.medium.com/max/2000/1*XADRDVUDatfS1oSAn_Cn8A.png)

Three months ago, I was allowed to use Github Copilot with my private Github account, and since then, I can use this tool during my day-to-day programming. During this period, I had a chance to test it with Angular, web components based on LitElement, Node.js (TS), and VanillaJS projects. So, let’s see how AI for pair-programming assists us, and does it really help?

## What exactly is GitHub Copilot?

GitHub Copilot is an AI tool created by GitHub and OpenAI to help programmers write code using autocompletion. Visual Studio Code, Neovim, and JetBrains users already can use the plugin.

GitHub Copilot is powered by the OpenAI Codex model, trained on natural language and billions of public source code lines, including GitHub projects.

The Copilot tool on GitHub can write the code or offer an alternative. The service supports all programming languages but works best with Python, JavaScript, TypeScript, Ruby, Java, and Go.

According to their data, 50% of developers on GitHub continued to use the service after the trial period in July 2021.

## How to use it?

Copilot is currently under Technical Preview. The Technical Preview is open to a limited number of testers. To join the waitlist, visit [copilot.github.com](https://copilot.github.com/).

To use GitHub Copilot, you first need to install the Visual Studio Code extension.

1. Visit the [GitHub Copilot extension](https://marketplace.visualstudio.com/items?itemName=GitHub.copilot) page on the Visual Studio Code Marketplace (or JetBrains marketplace) and install the extension.
2. Open Visual Studio Code. You will be prompted to authorize the extension by signing in to GitHub.
3. After you have authorized the extension, Github will return you to Visual Studio Code.

After installation, you need to open or create a new file for the supported language and start typing your code.

For example:

1. Create a new JavaScript (.js) file.
2. Start to declare any function and wait for the magic.

![A function declaration with Github Copilot](https://cdn-images-1.medium.com/max/2816/1*zEgoTPGdZVZ3hd5HmZJ9jg.gif)

That’s it. If you don’t like the proposed code, you can switch between options with keyboard shortcuts.

![Picture from [copilot.github.com](https://copilot.github.com/) documentation](https://cdn-images-1.medium.com/max/4028/1*rp702SwCtPU2qYj91ZrQnQ.png)

## Usability

I will start from negative points because there are not many topics, and it’s always more pleasant to finish on a positive note.

### What can be improved

First of all, I want to highlight on the GIF above how I have to remove a redundant parenthesis after Copilot. During these three months, I used to do it all the time. Especially when you write conditions or new functions.

The second issue for me was HTML. I know it’s not listed as a supported language, but Copilot, by default, proposes code all the time. Maybe I was writing a super unpredictable layout, or perhaps I’m not lucky enough, but I literally never received acceptable code autocompletion.

That’s it. Now I want to talk only about positive things because it makes real magic.

### What was good

The most significant value of Github Copilot is saving your time reading the documentation. For example, do you remember the key codes of arrow buttons to handle clicks on them? I don’t know either. Luckily with Copilot, **you don’t have to keep in mind key codes** or search it in google. Instead, just type the comment what do you want.

![Keyboard events handling with Copilot](https://cdn-images-1.medium.com/max/3060/1*kVU6LD8_Ze7Qr8PbV21K3g.gif)

Also, you even don’t need to search for **formulas**. For example, **how to convert Fahrenheit to Celsius degrees**.

![Convert Fahrenheit to Celsius degrees with Copilot](https://cdn-images-1.medium.com/max/2532/1*xPZF0vI-C5IUwJ1rEFO8Hg.gif)

Awesome, right?

---

But it works great not only with popular functions. It perfectly recognizes the context of your file and tries to write the code instead of you reusing existing variables and functions.

Let me show you **how to write an API service class** using GitHub Copilot.

![Writing API service with Copilot.](https://cdn-images-1.medium.com/max/3516/1*XyCPuRbbpfWnqI6I4GTVZQ.gif)

Did you see that? From the beginning, it proposed even the entire class with methods. But when I changed the constructor and added host and JWT strings, it adopted and suggested writing get and post methods using my variables.

Also, it recognized a JWT variable name and understood how to use it. It added a header to requests: “Authorization”: “Bearer “ + this.jwt.

---

Last but not least is how it works between classes. For example, Copilot can analyze imports or existing methods and reuse them. Even if they are in other classes or objects.

![Reusing service methods in another classes with Copilot](https://cdn-images-1.medium.com/max/3520/1*fMoUv9i4QC_vN1Q5MeHTPA.gif)

## How does it work compering with Tabnine?

Topics like Github Copilot VS Tabnine are popular, and there is even a comparison page on the Tabnine site.

![Comparison from Tabnine site](https://cdn-images-1.medium.com/max/4848/1*-fWg81zsA37J-jsU6_humQ.png)

> Yes, it’s a significant minus for Copilot that your code goes somewhere to the cloud for analyzing because it can be a huge security issue for large companies. So make sure before using, you are allowed to do it.

For this reason, I didn’t risk working with projects from my primary job. Tabnine works locally and keeps your privacy. Also, Tabnine works offline.

But I don’t see any reasons to compare the other things because you can ideally use them together. I have to remove redundant brackets from time to time, but this happens even with standard VS Code IntelliSense.

You can start to type something. First, Tabnine will suggest some methods, and then Copilot will write the rest of the code 🤖.

---

There is one more pitfall for the companies. During interviews, companies often ask candidates for the test task. For example, to write an algorithm or implement a polyfill.

If the candidate does his task on his own laptop with installed Copilot, he can simply type his task as a comment, and Copilot will do the rest. I have already had a chance to meet such a “smart” candidate in an actual interview.

---

Like many other new technologies, Copilot brings not only lots of life improvements but also issues with policies and procedures. Anyway, I really like it and will use it for my projects.

Thanks for reading! And make sure you are allowed in your company to use the Copilot extension.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
