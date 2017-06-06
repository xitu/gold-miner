> * 原文地址：[UX Review and Redesign of the CocaCola Freestyle Kiosk Interface](https://medium.com/@vedantha/ux-review-and-redesign-of-the-cocacola-freestyle-kiosk-interface-f77fc087c09)
> * 原文作者：[Ved](https://medium.com/@vedantha)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：
> * 校对者：

# UX Review and Redesign of the CocaCola Freestyle Kiosk Interface #

![](https://cdn-images-1.medium.com/max/800/1*ZydJMy1NI8CJ2Uwc0ocewA.jpeg)

A CocaCola Freestyle Kiosk Interface

### **Objectives** ###

- Understand the Kiosk and its UX
- Identify pain points and UX obstacles
- Improve UX/UI of the CocaCola Freestyle Kiosk Interface

### Design Process ###

![](https://cdn-images-1.medium.com/max/800/1*Jo9PS6PGeSzVPIJpSlnrLQ.png)

Design process followed for this project

I followed a simple design process for this redesign project.

I’d never used the machine myself before. So I needed to understand how it worked, and its context of use. Observing how the machine was used in different restaurants and a movie theater provided the necessary context.

Later I conducted some quick users tests and asked the users to think aloud as they were getting their drink. I made notes of what I observed and user quotes, and analyzed this data to make sense of it. This later drove the redesign presented in this post.

### **Observation** ###

I visited popular restaurants around my area where the machine is located. The main objective here was to understand the audience, environment, and contexts. I also found out about rush hours by speaking to the staff of the place.

**Context**

- The Kiosk is placed mainly in Restaurants and places of leisure such as movie theaters.
- These places are rushed on weekends, holidays and certain times during the day.
- There is usually a queue during rush hours.

**End Users**

The end users of the machine include

- Age group: teens and above (excluding those unable to reach or operate the screen)
- People with different calorie and caffeine preferences.

### **Quick User Tests** ###

- Number of participants: 4
- Familiarity: 2 first time users, 2 returning users
- Time: 8–9 minutes overall

**Notes from user tests:**

- Returning users knew exactly what drink they wanted. They were quick to pick the categories and were familiar with the UI.
- The new users took longer to make a choice, and there was some back and forth between the different kind of main drink categories.
- The new users were also confused about the “Push” button under the screen.
- Some users wanted to “try” new flavors and mixes before filling up their cup with their preferred one. Due to this, there was a lot of back and forth as well.

**Some user quotes**

> “Woah, so many options!”

> “My drink is usually over here <navigates to the drink’s button>”

> “Do I need to hold the ‘Push’ button?”

### Analysis ###

The user tests gave me some good insight into the different issues with the interface, and user flows. To understand more about this, lets consider the current user flow. From the time a user stand before the Kiosk, to getting a drink, the process looks as shown below.

#### Current user flow (using just the Kiosk) ####

![](https://cdn-images-1.medium.com/max/800/1*zsd3Jch6qnl0JaerA700-g.png)

User flow for getting drinks or creating mixes

This is a best case user flow and applicable for most users. While it seems quite simple at the outset, the major obstacle to a smooth flow here is a cognitive overload if the user does not already have a drink in mind. **Each screen has anywhere between 8 to 15 drink options to choose from. Making a decision is quite taxing in such a scenario, and the existing design does not help with that.** This process is repeated taking up more time if the user wants to create a mix.

#### Current user flow with mobile app ####

![](https://cdn-images-1.medium.com/max/800/1*iOMdvGQAE33q_HYoXZZn1Q.png)

User flow with the mobile app

Using the app simplifies the process on the kiosk slightly. It saves time by having mixes ready for the users, so they don’t have to navigate and pick each time.

#### Pain points ####

From user tests and comments from [many users online](https://www.facebook.com/IHateTheCocaColaFreestyleDrinkMachine/), these are the pain points I discovered

![](https://cdn-images-1.medium.com/max/800/1*rJ48-RHDEqtJJNfqK0kgSw.jpeg)

A screen showing 15 drink options!
- Cognitive overload from too many options ([according to Hick’s Law](https://en.wikipedia.org/wiki/Hick%27s_law))
- Lots of back and forth for new users and for users wanting to mix flavors
- Initial confusion with push button
- Screen timeout too short — creates a sense of urgency
- Filters are either caffeine free or low calorie, but not both
- Takes too long to get some of the regular flavors such as Coke or Sprite

### Redesign ###

Based on the findings in the previous stage, the UX can be refined as shown below. The companion mobile app has also been considered for the redesign. First lets look at some goals, constraints and assumptions made for the redesign.

#### Goals for redesign ####

- Reduce the number of steps to get a drink for most people
- Reduce cognitive load
- Make it easier to create mixes
- Make navigation easier

#### **Constraints** ####

- The main constraint is the touchscreen. It is resistive touch, and works well for tap interactions, but not well suited for more advanced gestures.

#### Assumptions ####

- The Kiosk provides data back to CocaCola (or the maintaining company).
- CocaCola and partners maintain and make use of this data for analysis and product enhancement.

#### Sketches ####

Sketches are very powerful in generating quick ideas. I arrived at the final redesign from these initial sketches.

![](https://cdn-images-1.medium.com/max/800/1*YUdZ1df6gR97Ntz1jHVs_w.jpeg)

Exploring some initial concepts

![](https://cdn-images-1.medium.com/max/800/1*5Gab6nhVVNOHvP-kLBCY1Q.jpeg)

Some drink mixing concepts

#### Low-Fi screens ####

These initial prototypes were made with Balsamiq. (These come after a lot of quick sketches)

![](https://cdn-images-1.medium.com/max/1000/1*zBNUTKoV3u_vAM-i2ItgvA.png) 

Left: Start screen || Right: after the user selects a drink

Consider the screens above.

Left: The start screen consists of the most popular drink products. Notice that the “low calorie” and “caffeine free” are filters. The user can select both, narrowing down the choices in subsequent screens.

Right: After the user has made a drink choice, the system “recommends” 4 popular flavors for the selected main drink. Also notice that there are a total of 8 drink choices displayed here.

How is this better? Well, using data backed recommendations, the design **makes it easier to select the 48 most popular drinks out of around a 100 total**.

![](https://cdn-images-1.medium.com/max/1000/1*248PiUK1TkFRxuk2hvzQSw.png)

Left: After selected drink has been finalized || Right: When the user is pouring the drink

The above two screens show the flow for pouring a selected drink. Notice that the description reads “Press & Hold” addressing a user’s earlier confusion with the system. As a part of improving microinteractions, it also responds to the button press on the UI.

Another important thing to notice — **the row of circles. These are drink recommendations that go well with the current drink.** The user can quickly press one of these options and add it to the drink mix. Again, **these are data backed recommendations.**

![](https://cdn-images-1.medium.com/max/800/1*wje3sg8WTiqT0IGdXH6hXA.png)

After the user selects the second drink to mix

Other key points:

- The design makes it easy to navigate. The pagination is an easy back and forth, and gives an idea of the total options available.
- For mixing, the user can also always go back and select a different drink. The design makes an attempt to ease the process, but also gives the user flexibility to go back or start over.

#### How this changes user flow ####

Lets consider how this would change the user flow* for most people when backed by data driven insights.*

![](https://cdn-images-1.medium.com/max/800/1*cyjjSL2T-qXC7uocWjDK8g.png)

User flow with the redesign

#### How the mobile app could further improve experience ####

The mobile app already makes the experience better. But it could further be improved. Lets take a look at how we can currently choose drinks on the mobile app, and how it can be improved.

![](https://cdn-images-1.medium.com/max/800/1*XG8SU63vMnjNmmsE1UAPzw.png)

Left: Current screen to choose drink || Right: A design with pull down to search

#### Hi-Fi screens ####

Now lets take a look at some hi-fidelity designs. Based on some user feedback, there are some small changes compared to the low-fi version.

![](https://cdn-images-1.medium.com/max/1000/1*dyJzBQnzaKCw1hFwONe-Nw.png)

Left: The start screen. The interface shows the top 6 popular drinks on first page. || Right: Once the user taps on a drink, its variants appear as shown.

One change on the start screen is the water icon has been moved to the top-right for more visibility, and the button also takes a circular shape to be in line with the drink icon shapes.

![](https://cdn-images-1.medium.com/max/1000/1*tka8iXFvRQNEaDVwvYBz6g.png)

Left: Once the user taps on a drink variant, its time to pour it into the cup. || Right: UI feedback when the user presses the “PUSH” button.

These screens are a slight change from the low-fi designs. There is an additional column in the final version — “For other choices” beside mix drink recommendations. This communicates the users’ choices more clearly. If the users want a different drink or flavor from the recommended choices, it guides them to the next steps.

![](https://cdn-images-1.medium.com/max/1000/1*65IQM2cIqVpx421UaZtrjQ.png)

Left: Once the user taps on a recommended second drink to mix, this screen is shown. || Right: From the start screen (screen 1), clicking on the “Fruit Flavors” lead to this screen.

The screen numbered 6 shows the “Fruit Flavors” selection. The 5 most popular flavors are show right on top and highlighted. Less popular flavors are displayed right below. There are 3 “mixed” flavors on the Kiosk, and these are listed under mix flavors. Selecting one f these options will display options similar to screen 2.

A click through prototype:

[![](https://marvelapp-live.storage.googleapis.com/serve/2017/5/18854dfb4ab14e5ba0da5aa0eb69942a.png)](https://marvelapp.com/28f7gbe?emb=1&referrer=https%3A%2F%2Fmedium.com%2Fmedia%2F1dba6e6eec95ce7b8611343aef3c1237%3FpostId%3Df77fc087c09)

### Limitations of the design ###

Even though the redesign addresses some key points, there are some limitations.

- The design prioritizes the most popular options over the less common ones. It might take a few extra taps if the user has a less common option in mind.
- If the users want to create a mix with flavors other than the recommended ones, they need to start over or head to the flavors scree and pick another drink.

*Tools used for prototypes: Balsamiq, Sketch.*

*Fruit icons are made by [*Freepik*](http://www.freepik.com) and [*Madebyoliver*](http://www.flaticon.com/authors/madebyoliver).*


*If you liked this post, please click the little green heart below. It helps others discover the post, and puts a big smile on my face :)*


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
