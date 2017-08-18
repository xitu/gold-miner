
  > * 原文地址：[How I do Developer UX at Google](https://medium.com/google-design/how-i-do-developer-ux-at-google-b21646c2c4df)
  > * 原文作者：[Tao Dong](https://medium.com/@taodong)
  > * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
  > * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/how-i-do-developer-ux-at-google.md](https://github.com/xitu/gold-miner/blob/master/TODO/how-i-do-developer-ux-at-google.md)
  > * 译者：
  > * 校对者：

  # How I do Developer UX at Google

  *Explained through a user study of Flutter*

![](https://cdn-images-1.medium.com/max/1600/1*-fxLDg9RoGtL2X8zYmb2pA@2x.jpeg)

When people talk about User Experience (UX), they often talk about their beloved consumer products: a smartphone, a messaging app, or perhaps a pair of headphones.

User Experience also matters when you build something for developers. People tend to forget that developers are users too, and software development is an intrinsically human activity limited by not only how computers work, but also how programmers work. Admittedly, there are fewer developers than consumers in general, but the more usable developer tools are, the more energy developers can spend on delivering value to their users. Therefore, the UX of developer products is just as important as for consumer products. In this post, I am going to introduce the developer experience, explain one of the ways we assess it at Google, and share some lessons we learned from a specific study we conducted on [Flutter](https://flutter.io/), a new SDK for building beautiful mobile apps.

The idea of developer experience is not exactly new. Research on developer experience dates back to the early days of computing, since all users at the time were developers to some degree. “[The Psychology of Computer Programming](https://books.google.com/books?id=j_MJAQAAMAAJ&amp;q=The+Psychology+of+Computer+Programming&amp;dq=The+Psychology+of+Computer+Programming&amp;hl=en&amp;sa=X&amp;ved=0ahUKEwj2rvfNpfPUAhWJjlQKHWxBAT4Q6AEIKTAA)”, published in 1971, is a landmark book on the topic. When we talk about developer experience, especially applying the term to an SDK or library, we usually refer to three aspects of the product:

- **API Design**, which includes the naming of classes, methods and variables, the abstraction level of the API, the organization of the API, and the way the API is invoked.
- **Documentation**, which includes both the API reference and other learning resources such as tutorials, how-tos, and developer guides.
- **Tooling, **which involves both the command-line interface (CLI) and GUI tools that help editing, debugging, and testing the code. For example, [research](https://www.cl.cam.ac.uk/~mcm79/pdf/2015-PPIG.pdf) has shown that autocomplete in the IDE has a large impact on how APIs are discovered and used in programming.

These three pillars of developer experience complement one another, so they need to be designed and assessed as a package.

#### How do we observe developer experience?

![](https://cdn-images-1.medium.com/max/1200/1*4kBtrc2qTpzT89KgnBmGVA.png)

One of the research methods we use to assess developer experience is *observing* how real developers carry out a realistic programming task using our SDK and dev tools. This method, called user testing, is widely used in consumer UX research, and we adapted it to evaluate developer products. In this specific study on [Flutter](http://flutter.io), we invited 8 professional developers and asked each of them to implement the mock-up on the left.

One key technique involved in this process is the [think aloud protocol](https://en.wikipedia.org/wiki/Think_aloud_protocol). It’s a verbal reporting protocol developed by Clayton Lewis at IBM and it’s useful to understand the participant’s reasoning behind their actions. We gave our participants the following instructions:

> “As you work on the programing exercise, please ‘think aloud.’ That means verbally describing your mental process as it develops, including the doubts and questions you have, the solution strategies you consider, and the reasons that justify your decisions.”

We further reassured our participants that we were evaluating Flutter, not their programing skills:

> “Please remember that we are testing the developer experience of Flutter — it’s not a test of you. So anything you find confusing is something we need to fix.”

We started each session with a warm-up interview about the participant’s background, and then they had about 70 minutes working on the task. In the last 10 minutes of the session, we debriefed the participant about their experience. Each study session, including the participant’s computer screen, was livestreamed privately to a separate conference room watched by several engineers on the product team. To protect participants’ privacy, we’ll refer to them by identifiers (e.g., P1, P2, P3, etc) other than their names in this post.

---

So, what did we learn about developer experience from this study?

#### 1. Provide a lot of examples and present them effectively

After just a few user testing sessions, it became clear that developers expected to learn how to work with a new SDK from examples. The problem, though, wasn’t that Flutter didn’t provide enough examples — it had [tons of examples](https://github.com/flutter/flutter/tree/master/examples) in its Github repository. The problem was that those examples were not organized and presented in a way that were actually helpful to our study participants for two reasons:

First, the code samples in Flutter’s Github repository lacked screenshots. At the time, Flutter’s website provided a link to search all code examples containing a particular widget class in its Github repo, but it was hard for participants to determine which example would produce the desired result. You had to run the example code on a device or a simulator to see the widget’s appearance, which no one bothered to do.

![](https://cdn-images-1.medium.com/max/1200/1*wl0E4X5dwf8ffO5U5WB6SQ.png)

> “This is nice, linking to actual code. But it’s very difficult to choose which one you’d like to use unless you see the output.” (P4)

Second, participants expected to have sample code in the API documentation, not in a separate place. Trial and error is a common way to learn an API, and short snippets in API docs enable that method of learning.

> “I click on ‘Documentation’, but it’s APIs, not samples.” (P4)

Several engineers on the Flutter team observed study sessions over livestream, and they were struck by the challenges some participants experienced. As a result, the team has been steadily adding more sample code to Flutter’s API docs (e.g., [ListView](https://docs.flutter.io/flutter/widgets/ListView-class.html) and [Card](https://docs.flutter.io/flutter/material/Card-class.html)).

[![](https://cdn-images-1.medium.com/max/1600/0*4U5ykS-eke_6ridl.)](https://docs.flutter.io/flutter/widgets/ListView-class.html)

In addition, the team started building [a curated, visual catalog](https://flutter.io/catalog/samples/) for larger code samples. There are only a handful of samples for now, but each sample features a screenshot and self-contained code, so developers can quickly determine if a sample is useful to their problem.

[![](https://cdn-images-1.medium.com/max/1600/0*mOqhzOt9tm8Z81m5.)](https://flutter.io/catalog/samples/)

#### 2. Accommodate the cognitive abilities of developers

Programming is a cognitively intense activity. In this case, we found that writing a UI layout purely in code was difficult for some developers. In a Flutter app, building a layout involves selecting and nesting widgets in a tree. For example, to create the layout in the cafe information card, you need to organize several Row widgets and several Column widgets correctly. It didn’t look like a hard task, but three participants mixed up Row and Column when they tried to create that layout.

![](https://cdn-images-1.medium.com/max/1600/1*ZsPJlXU8Kuy1ljzQMufy8Q.png)

```
new Card(
 child: new Container(
   child: new Row(
       children: [
         titleSection,
         new Container(
           child: new Row(
               children: [
                 phoneNumber,
                 new Container(
                   child: emailWidget
                 ),
                 ]
            )
          )
        ]
     )
   )
)
```

> “Can you tell me what you expected the output to be?” (Moderator)

> [Talking through what he wanted to do] “Oh…I should have probably used a Column not a Row.” (P6)

We turned to Cognitive Psychology for explanations. It turns out that building a layout in code requires the ability to reason about the spatial relationship between objects, and it’s known to cognitive psychologists as [spatial visualization ability](https://en.wikipedia.org/wiki/Spatial_visualization_ability). It is the same ability that influences how well a person can explain driving directions or rotate a magic cube.

This finding has changed some team members’ view of the need for a visual UI builder. The team was very excited to see community-driven explorations on this front, such as this Web-based UI builder called [Flutter Studio](http://mutisya.com/).

#### 3. Promote recognition over recall

It is a well known [UX principle](https://www.nngroup.com/articles/recognition-and-recall/) that user interfaces should avoid forcing users to recall information (e.g., an arcane command or parameter). Instead, the UI should allow users to recognize possible courses of action.

How is this principle relevant to software development? An issue we observed was that it was not intuitive to understand the default layout behavior of Flutter widgets and figure out how to change their behavior. For example, P3 didn’t know why the Card, by default, shrunk to the size of the Text it contained. P3 had trouble figuring out how to make the Card fill the width of the screen.

![](https://cdn-images-1.medium.com/max/1200/1*HAbAkFXFMzPhTSRcwtpHvQ.png)

    body: new Card(
      child: new Text(
        ‘1625 Charleston Road, Mountain View, CA 94043’
      )
    ),

> “What I wanted is to have it take up the entire width of the screen.” (P3)

Of course, many programmers can figure that out eventually, but they need to *recall* how to do it the next time they face the same problem. There were no visible clues for developers to *recognize* a solution in that situation.

The team is exploring a few directions to reduce the burden of recall in building layouts:

- Summarizing the layout behaviors of widgets to make them easier to reason about.
- Offering layout samples with both code and images to turn some recall tasks into recognition tasks
- Providing a Chrome-style inspector to show “computed value” of a widget property

#### 4. Expect developers to be blind to something “right in front of them”

One feature the Flutter team is really proud of is Hot Reload. It allows the developer to apply changes to a running app within 1 second, without losing the app state. Performing a Hot Reload is as simple as clicking a button in the IntelliJ IDE or pressing ‘r’ in the console.

However, in the first few sessions of the study, the team was puzzled by some participants’ expectation of triggering Hot Reload on file save, despite the fact that the Hot Reload button was shown in an animated gif in the Getting Started instructions. How could they not see the Hot Reload button?

![](https://cdn-images-1.medium.com/max/1600/1*oE-etcL1SzjYrNWTac9RtQ.gif)

It turned out that participants who missed the Hot Reload button and expected to trigger reload on save were users of React Native. They told us that in React Native, Hot Reload was automatically performed on file save.

A developer’s pre-existing mental model can alter their perception and lead to a certain degree of “blindness” to UI elements. The team has added more visual cues to help discover the Hot Reload button. Furthermore, some engineers have been investigating a reliable way to allow reload on save for users who need it.

#### 5. Don’t assume programmers read English words as expected when they appear in code

In Flutter, [everything is a widget](https://flutter.io/technical-overview/). A user interface is primarily composed through nesting widgets. Some widgets take only one child, while others take multiple children. This distinction is indicated by the existence of either a “child” property or a “children” property on a widget class. It sounds quite straightforward, right?

We thought so, too. Yet, to some participants, the singular form of the word didn’t successfully signal that only one widget could be nested in the current widget. They doubted that “child” really meant “just one.”

> “I’m thinking the ‘child’ can be multiple ones or not. Can I pass in an array or just one is possible?” (P2)

> “So the ‘child’ will be 4 things, the first item, a separator, and two more items.” (P2)

This mis-interpretation of the semantics of the property name led to erroneous code like this:

![](https://cdn-images-1.medium.com/max/1600/0*BARfNXeq3DpabHxq.)

And the error message shown in this case, though accurate, wasn’t actionable enough to nudge the participant back on the right path:

![](https://cdn-images-1.medium.com/max/1600/0*HOBxZmDvGc_TAukH.)

It’s easy to dismiss what happened here as a beginner’s mistake. However, the team was not comfortable seeing a professional developer waste several minutes dealing with this simple issue. So a short-term fix was landed a few days after the study findings were reported. It added one of the most useful multi-child widgets, Column, to the app template you get by running the ‘flutter create’ command. The goal is to expose the difference between ‘child’ and ‘children’ to a new developer early enough, so they won’t waste time figuring that out later. In addition, some team members are investigating a longer-term solution to improving the actionability of error messages in situations like this and beyond.

### Conclusion

We can learn a lot from observing developers use APIs and apply learnings to improving the User Experience of a developer product. If you write any code or build any tool that is used by other developers, we encourage you to observe how they use it. As a Flutter engineer put it, you always learn something new from observing a user study. As software continues to drive changes in the world, let’s make sure developers are as productive and happy as possible.


  ---

  > [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
  