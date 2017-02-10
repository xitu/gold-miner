> * 原文地址：[Essential Guide For Designing Your Android App Architecture: MVP: Part 1](https://blog.mindorks.com/essential-guide-for-designing-your-android-app-architecture-mvp-part-1-74efaf1cda40#.3lyk8t57x)
* 原文作者：[Janishar Ali](https://blog.mindorks.com/@janishar.ali?source=post_header_lockup)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

# Essential Guide For Designing Your Android App Architecture: MVP: Part 1 #

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/2000/1*__cBFEIb0Zi8QswpC1YK0w.png">

> If you make your foundations strong, then you can rise high and touch the sky.

Android framework does not advocate any specific way to design your application. That in a way, make us more powerful and vulnerable at the same time.

*Why am I even thinking about this, when I am provided with Activity and I can, in essence, write my entire implementation using few Activities?*

Over the years writing code for Android, I have realized that solving a problem or implementing a feature at that point of time is not enough. Your app goes through a lot of change cycles and features addition/removal. Incorporating these over a period of time creates havoc in your application if not designed properly with separation of concern. That is why I have come up with a guide that I follow religiously for all my architectural designs from the very single code I write for that application.

> The principles presented in the MVP philosophy is by far the best I have come across.

*What is an MVP and why should we explore it?*

Let’s take a ride into the past. Most of us started creating an Android app with Activity at the center and capable of deciding what to do and how to fetch data. Activity code over a period of time started to grow and became a collection of non-reusable components. We then started packaging those components and the Activity could use them through the exposed apis of these components. We started to take pride and began breaking codes into pieces as much as possible. Then we found ourselves in an ocean of components with hard to trace dependencies and usage. Also, we later got introduced to the concept of testability and found that regression is much safer if it’s written with tests. We felt that the jumbled code that we have developed in the above process is very tightly coupled with the Android apis, preventing us to do JVM tests and also hindering an easy design of test cases. This is the classic MVC with Activity or Fragment acting as a Controller.

So, we formulated few principles that solved most of the above-mentioned problems if implemented carefully. Those principles, we call as MVP (Model-View-Presenter) design pattern.

*What is an MVP design pattern?*

MVP design pattern is a set of guidelines that if followed, decouples the code for reusability and testability. It divides the application components based on its role, called separation of concern.

**MVP divides the application into three basic components:**

1. **Model**: It is responsible for handling the data part of the application.

2. **View**: It is responsible for laying out the views with specific data on the screen.

3. **Presenter**: It is a bridge that connects a Model and a View. It also acts as an instructor to the View.

**MVP lays few ground rules for the above mentioned components, as listed below:**

1. A View’s sole responsibility is to draw UI as instructed by the Presenter. It is a dumb part of the application.

2. View delegates all the user interactions to its Presenter.

3. The View never communicates with Model directly.

4. The Presenter is responsible for delegating View’s requirements to Model and instructing View with actions for specific events.

5. Model is responsible for fetching the data from server, database and file system.

> The above-mentioned principles can be implemented in a number of ways. Each developer will have its own vision of it. But in the nutshell, basic nuts and bolts are common with minor modification.

> With great power, comes great responsibility.

**Now, I lay down the preamble, I follow for MVP.**

1. Activity, Fragment, and a CustomView act as the View part of the application.

2. Each View has a Presenter in a one-to-one relationship.

3. View communicates with its Presenter through an interface and vice versa.

4. The Model is broken into few parts: ApiHelper, PreferenceHelper, DatabaseHelper, and FileHelper. These are all helpers to a DataManager, which in essence binds all Model parts.

5. Presenter communicates with the DataManager through an interface.

6. DataManager only serves when asked.

7. Presenter does not have access to any of the Android’s apis.

*Now, all these information can evidently be found on any blog or Android guide for MVP. Then what’s the point of this article?*

> The reason that this article is written is to solve a very important challenge with MVP. **How to actually implement it as an entire application?**

MVP appears to be very simple when explained with a simple Activity example but makes us feel lost when we try binding all the components of an application together.

> If you want to dive deep into a world of beautiful coding and be mesmerized then follow along with this article. It’s not a news article, so get involved with it, put on your shoes with your back straight and away from all distractions.

### Let’s sketch the blueprint of the architecture first. ###

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/2000/1*etZ8borFvbwOOlChGCZq1A.png">

Architecture is the first thing you should work on for any software. A carefully crafted architecture will minimize a lot of rework in future while providing the scalability ease. Most of the project today is developed in a team, hence the code readability and modularity should be taken as utmost important elements of the architecture. We also rely heavily on 3rd party libraries and we keep switching between alternatives because of use cases, bugs or support. So, our architecture should be designed with plug and play design. The interfaces for classes serves this purpose.

The blueprint of the Android architecture drawn above contains all these features and is based on the principles of MVP.

> The following contents might feel overwhelming at first but as you go through an active example in the Next part of this article, concepts will become obvious to you.

> Knowledge comes to those who crave for it.

Let’s understand each part of the sketched architecture.

- **View**: It is the part of the application which renders the UI and receives interactions from the user. Activity, Fragment, and CustomView constitute this part.

- **MvpView**: It is an interface, that is implemented by the View. It contains methods that are exposed to its Presenter for the communication.

- **Presenter**: It is the decision-making counterpart of the View and is a pure java class, with no access to Android APIs. It receives the user interactions passed on from its View and then takes the decision based on the business logic, finally instructing the View to perform specific actions. It also communicates with the DataManager for any data it needs to perform business logic.

- **MvpPresenter**: It is an interface, that is implemented by the Presenter. It contains methods that are exposed to its View for the communication.

- **AppDbHelper**: Database management and all the data handling related to a database is done in this part of the application.

- **DbHelper**: It is an interface implemented by the AppDbHelper and contains methods exposed to the application components. This layer decouples any specific implementation of the DbHelper and hence makes AppDbHelper as plug and play unit.

- **AppPreferenceHelper**: It is like AppDbHelper but is given the job to read and write the data from android shared preferences.

- **PreferenceHelper**: Interface just like DbHelper but implemented by AppPreferenceHelper.

- **AppApiHelper**: It manages the network API calls and API data handling.

- **ApiHelper**: It is an interface just like DbHelper but implemented by AppApiHelper.

- **DataManager**: It is an interface that is implemented by the AppDataManager. It contains methods, exposed for all the data handling operations. Ideally, it delegates the services provided by all the Helper classes. For this DataManager interface extends DbHelper, PreferenceHelper and ApiHelper interfaces.

- **AppDataManager**: It is the one point of contact for any data related operation in the application. DbHelper, PreferenceHelper, and ApiHelper only work for DataManager. It delegates all the operations specific to any Helper.

**Now, we are familiar with all the components and their roles in the application. We will now formulate the communication pattern within various components.**

- Application class instantiates the AppDbHelper (into DbHelper variable), AppPreferenceHelper (into PreferenceHelper variable), AppApiHelper (into ApiHelper variable) and finally AppDataManager (into DataManager variable) by passing the DbHelper, PreferenceHelper and ApiHelper reference to it.

- The View components instantiate its Presenter through the MvpPresenter reference.

- Presenter receives it View component and refers to it through MvpView. The Presenter also receives the DataManager.

- DataManager exists as a singleton instance.

**These are the basic guidelines for an application to implement MVP.**

> Just like a surgeon taught with all the surgery procedures, won’t be of any use until he actually performs and practices it. We won’t be able to comprehend the ideas and implementations until we actually do it.

In the next part, we will explore an actual working app example and hopefully be able to understand and grasp the concepts well.

[Here is the link to the second part of this article:](https://blog.mindorks.com/essential-guide-for-designing-your-android-app-architecture-mvp-part-2-b2ac6f3f9637) 

[**Essential Guide For Designing Your Android App Architecture: MVP: Part 2**](https://blog.mindorks.com/essential-guide-for-designing-your-android-app-architecture-mvp-part-2-b2ac6f3f9637)

**Thanks for reading this article. Be sure to click ❤ below to recommend this article if you found it helpful. It would let others get this article in feed and spread the knowledge.**

For more about programming, follow [**me**](https://medium.com/@janishar.ali) and [**Mindorks**](https://blog.mindorks.com/) , so you’ll get notified when we write new posts.

Coder’s Rock :)
