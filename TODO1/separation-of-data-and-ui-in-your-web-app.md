> * 原文地址：[Separation of Data and Ui in your Web App](https://medium.com/front-end-weekly/separation-of-data-and-ui-in-your-web-app-2c3f1cc3fbda)
> * 原文作者：[Georgy Glezer](https://medium.com/@georgyglezer)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/separation-of-data-and-ui-in-your-web-app.md](https://github.com/xitu/gold-miner/blob/master/TODO1/separation-of-data-and-ui-in-your-web-app.md)
> * 译者：
> * 校对者：

# Separation of Data and Ui in your Web App

Hello everyone, My name is Georgy and I’m a Full-stack developer at **[Bringg](http://bringg.com/)** and ****this is the first article I'm writing. 😅

So today I want to focus on the concept of separation of data and UI while building you web app, how it can help you build much cleaner, easier to maintain and more awesome web apps, and a small example of how I was able to render 4 different UI/frameworks libraries with the same consistent. 😄

Usually, in any web app, you have 2 main parts:

* Data
* UI

So you go and choose a framework/UI library like React, Angular, Vue, etc… and then you go on and decide what state manager to use or how to manage your data maybe without state manager.

You start writing your first feature, let's take for example a users list, and you have a checkbox to select users, And then you need to decide where to keep your current selected users.

> Do you keep them in your react component state ? or do you keep them in your redux store ? or do you keep them in your angular service or controller ?
> Is selected users is something related do your Data somehow ? or is just pure View indicator ?

Okay, so I gonna share with you the mindset, or thoughts you should have while writing features that can help you make the separation more clear through the above example.

Users is our data in our application, we can add user, we can modify user data, and we can remove the user, we can derive information from the users we have like who is online and how many users total we have an so on.

When we show a user list, we just represent our data in a more visible way to the user, like a list for him to see. We allow him to select users and unselect users which is the current state of the view, the selected users on the page, This have no relation to the data at all and should be separated.

By having this separation we are developing javascript applications as plain javascript applications and then choose however we want to represent our data. This can allow us maximum flexibility like using whatever UI library we want to each purpose, this set of components I want to represent with react and the other few I want to represent with web components, I can do that easily now with that separation.

> # Here is an example I made to show this cool concept:

I choose [MobX](https://github.com/mobxjs/mobx) to manage my state in my application and to help me with the rendering across different frameworks/UI libraries. It has a cool reactivity system which allows you to respond automatically to events you want.

My model here is **Template,** it’s really simple it just have a name and setter(MobX action) to it, I keep a list of all the templates in the project and I have a store for it `TemplateList` and this is all my **Data.**

![](https://cdn-images-1.medium.com/max/2424/1*sUeiUDg6QXbe08GrEyZNfg.png)

![](https://cdn-images-1.medium.com/max/2508/1*Klb2cKUIoGzbYmjxOFwcuA.png)

So I have already my app running as a javascript application, I can add templates and update its text but I still don’t have a UI for this, So let's add React as our first UI here.

For react I used **[mobx-react](https://github.com/mobxjs/mobx-react)** which is a library connecting to MobX and uses its abilities to render in react.

![](https://cdn-images-1.medium.com/max/3328/1*_jHARXfsu4DPvfK6G55lFg.png)

Then I choose another library, Vue JS and I keep almost same Html, and CSS classes, I just render with Vue,

I used MobX `autorun`(https://mobx.js.org/refguide/autorun.html) and on each new template addition, or removal I re-render the view.

![](https://cdn-images-1.medium.com/max/2168/1*k5ArS-smHdbb6rJlc2WMKQ.png)

and now we have another UI represent with different library but with the same store without changing 1 line of our data management in the app.

![](https://cdn-images-1.medium.com/max/3376/1*tGpOEofa1jIjxrwDQxqjLg.png)

So now we had a bit more space on screen so we need to choose more 2 libraries so let's go for AngularJS this time.

AngularJS was a bit more annoying to render because its `ng-model` was messing with the model so I had to save the texts of the templates in an object and apply re-render on new templates.

![](https://cdn-images-1.medium.com/max/2620/1*rMgQ3As1LMKkb7GWLmn9Lg.png)

![](https://cdn-images-1.medium.com/max/3344/1*Z2M5mSR8Vc4TRQKCzkySDw.png)

So for our last library I choose [Preact](https://preactjs.com), it’s really similar to React, Here again, I used `autorun` to update my UI.

![](https://cdn-images-1.medium.com/max/2372/1*lqV2noA23HzDulsXr4OKLQ.png)

Here I also had to update the template itself on each change(similar to what mobx-react does).

![](https://cdn-images-1.medium.com/max/2112/1*gzHJHBLK-ImmilyTK2FXIA.png)

And that’s it now we have 4 different UI/framework libraries showing the same data exactly on the same screen.

![](https://cdn-images-1.medium.com/max/6716/1*_Dccz9ks746qQAs4P20vYQ.png)

I really love this separation, It makes the code in a much cleaner as it just needs to manage the UI state or even just represent the data without any games, it helps the code to be more maintainable and easier to scale.

Hope you liked the concept and if anyone has any question or would just like to discuss, or give me any points to improve is more than welcome to talk to me on [Facebook](https://www.facebook.com/gglezer), or by mail stolenng@gmail.com.

Here is a link to the repository and a website:

[**stolenng/mobx-cross-data-example**](https://github.com/stolenng/mobx-cross-data-example)

[http://mobx-cross-data.georgy-glezer.com/](http://mobx-cross-data.georgy-glezer.com/)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
