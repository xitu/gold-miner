> * 原文地址：[How to build complex user interfaces without going completely insane](https://medium.freecodecamp.com/3-tips-to-keep-in-mind-while-developing-complex-ui-in-web-b56312310390)
> * 原文作者：[Illia Kolodiazhnyi](https://medium.freecodecamp.com/@iktash88)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：
> * 校对者：

# How to build complex user interfaces without going completely insane #

![](https://cdn-images-1.medium.com/max/2000/1*jwBhYQ_c_HZ_OOCE4pwbwQ.jpeg)

I recently built a web application with a complex, dynamic User Interface (UI). Along the way, I learned several valuable lessons.

Here are a few tips I wish someone had told me before I embarked on such an ambitious project. These would have saved me so much time and sanity.

### Sanity Tip #1: Use a component’s internal state for storing temporary data ###

A complex UI usually requires you to maintain some sort of application state. This tells the UI what to display and how to display it. One option is to access that state as soon as the user triggers an action on the page. However, I’ve learned there are situations where it’s beneficial to postpone the change in the application state and save this change temporarily in the current component’s internal state.

An example to illustrate this is a dialog window for the user to edit some record, such as his or her name:

![](https://cdn-images-1.medium.com/max/800/1*bFb-8Zdzf1aGPJyWpD_hsg.jpeg)

In this case, you might want to trigger a change every time the user edits a field in this dialog window. But I encourage you to maintain an internal state of this dialog with all the data displayed. Wait until the user presses the Save button. At this point, you can safely change the application state that holds the data of those records.

That way, if the user decides to discard the change and close the dialog window, you can drop the component. Then the application state stays intact. If you need to send the data to the back end, you can do it in one request. If the same list is available to other users, they won’t see the temporary values while someone is editing it.

> Your UI behavior should match the user’s mental model

When users work with a dialog box, they won’t consider the record completed until they finish editing it. The component’s functionality should work exactly like this.

*Note to those working with React/Redux:* this behavior is achievable if you keep the general data in the Redux Store and use React Component state to store temporary pieces of data.

### Sanity Tip #2: Separate model data from UI state ###

*I’m using the term* ***model*** *here referring to the classic entity from the MVC pattern.*

Modern UI in web applications can be complex in structure and behavior. This generally leads you to store the purely UI-related data in your application state. I recommend that you keep UI-related data and business data separate.

> Store models with business data and logic separately from the UI state

This approach is easier to follow and understand since it separates business logic from everything else. Your models can hold both the data as well as the methods (functions, means) to handle this data. Otherwise, your application will probably end up with business logic spread across multiple places, most likely *View* components.

For example, you have a list of to-do tasks in your application and you implement a page to add a new task to that list. You want the Save button to be disabled until there’s both a description explaining the task and a properly formatted date for the task:

![](https://cdn-images-1.medium.com/max/800/1*Cqmpew82Wo_znz_lCYz3xQ.jpeg)

The naive way would be to store the needed data somewhere in the application state and have code like `const saveButtonDisabled = !description && !date && !dateIsValid(date)` right in your *View* component. But the problem is that the Save button is disabled because there is a *business requirement* to have all records with descriptions and proper dates.

So in this case the logic for disabling the button should be put in the *model* for the to-do task. That model can look like this:

```
{
    description: 'Save Gotham',
    date: 'NOW',
    notes: 'Speak with deep voice',
    dateIsValid: () => this.date === 'NOW',
    isValid: () => this.description !== '' && this.dateIsValid()
}
```

And now you can use this for your UI logic `const saveButtonDisabled = !task.isValid()` in the *View* component.

As you can see, this tip is basically about keeping your *Models* separate from *Views* in the MVC pattern.

### Sanity Tip #3: Prioritize integration testing over unit testing ###

This is not an issue if you’re lucky enough to work in an environment where you have time to write multiple tests for every feature. But I’m sure this is not the case for most of us. Usually you have to decide which kind of testing to use. **The majority of time I would consider integration testing more valuable than unit testing**.

![](https://cdn-images-1.medium.com/max/800/1*dsj6MNERxdJtcr5-I7W2vQ.jpeg)

In my experience, I’ve learned that the codebase with good unit test coverage is generally more error-prone than the one with good integration test coverage. I noticed that the majority of bugs introduced with developing work are [regression bugs](https://en.wikipedia.org/wiki/Software_regression). And unit tests are usually not very good in catching those.

When you are fixing a problem in the code, I would encourage you to follow these simple steps:

1. Write a test that fails due to the existing problem. If it can be done with a unit test, great. Otherwise, make the test touch as many code modules as necessary.
2. Fix the problem in the codebase.
3. Verify that the test is not failing anymore.

This simple practice ensures that the problem is fixed and it won’t occur again, as the test will verify it.

Modern web applications present many challenges to developers and UI development is one of them. I hope this article helps you to avoid mistakes or give you a good topic to think about and discuss.

I would highly appreciate reading your thoughts and discoveries in the comments.

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
