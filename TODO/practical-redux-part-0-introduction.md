> * 原文地址：[Practical Redux, Part 0: Introduction](http://blog.isquaredsoftware.com/2016/10/practical-redux-part-0-introduction/)
* 原文作者：[Mark Erikson](https://twitter.com/acemarke)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

# Practical Redux, Part 0: Introduction


_First in a series covering Redux techniques based on my own experience_

#### Series Table of Contents

*   **Part 0: Series Introduction**
*   **[Part 1: Redux-ORM Basics](/2016/10/practical-redux-part-1-redux-orm-basics/)**
*   **[Part 2: Redux-ORM Concepts and Techniques](/2016/10/practical-redux-part-2-redux-orm-concepts-and-techniques/)**

I’ve spent a lot of time learning about Redux, from many different sources. Much of my early learning came from reading the docs, searching for tutorials online, and lurking in the Reactiflux chat channels. As I grew more comfortable, I gained experience answering questions and doing research to help others in Reactiflux, Stack Overflow, and Reddit. In the course of maintaining my [React/Redux links list](https://github.com/markerikson/react-redux-links) and [Redux addons catalog](https://github.com/markerikson/redux-ecosystem-links), I’ve tried to find in-depth articles that dive into some of the complexities and issues involved in building real-world applications, and libraries that help make writing Redux apps better. Finally, I’ve also pored through numerous issues and discussions in the Redux repo (and even more so now that I’m officially a Redux maintainer).

In addition to all that research, I’ve also spent much of the last year using Redux in my own application at work. As I’ve worked on that app, I’ve run into a variety of challenges, and I’ve developed a number of interesting tools and techniques in the process. Since I’ve learned so much from what others have written, I’d like to start giving back, and sharing what I’ve learned from my own experience.

**This series of posts on “Practical Redux” will cover some of the tips, techniques, and concepts I’ve come up with while building my own application**. Since I can’t actually share the specific details of what I’ve built at work, I’ll be making up example scenarios to help demonstrate the ideas. I’ll be basing the examples on concepts from the [Battletech game universe](http://bg.battletech.com/):

*   A [Battlemech](http://www.sarna.net/wiki/BattleMech) is a piloted walking robot, armed with various weapons like missiles, lasers, and autocannons. A Battlemech has one pilot.
*   There are different types of Battlemechs. Each type can have a different size and set of statistics, including what weapons and other equipment it carries.
*   Battlemechs are organized into groups of four mechs, called a [“Lance”](http://www.sarna.net/wiki/Inner_Sphere_Military_Structure#Lance). Three lances make up a “Company”.

As the series progresses, I’m hoping to actually start building a small app to show off some of the examples in an actual working environment. The tentative plan is to build an application that tracks the pilots and mechs in a fictional combat force, like a miniature version of the existing [MekHQ game campaign tracker application](http://megamek.info/mekhq). These screenshots from MekHQ illustrate some of the concepts and UI that I’m aiming to imitate:

*   [MekHQ: List of available pilots and details on selected pilot](https://sourceforge.net/p/mekhq/screenshot/Screen%20Shot%202012-09-25%20at%2012.19.38%20PM.png)
*   [MekHQ: Organization tree of mechs and pilots in the force](https://sourceforge.net/p/mekhq/screenshot/Screen%20Shot%202012-09-25%20at%2012.16.47%20PM.png)
*   [MekHQ: Details and statistics for a Battlemech](https://sourceforge.net/p/mekhq/screenshot/Screen%20Shot%202012-09-25%20at%2012.23.30%20PM.png)

I definitely do _not_ intend to seriously rebuild all of MekHQ’s functionality, but it should serve as a useful inspiration and source of ideas to base my examples on.

The first couple posts will discuss ways to use the Redux-ORM library to help manage normalized state. From there, I hope to cover topics such as ways to manage “draft” data while editing items, building a treeview, form input handling, and more. I also plan to cover some non-Redux-specific topics as well.

Feedback is always appreciated, whether it be in the comments, on Twitter, in Reactiflux, or elsewhere!

