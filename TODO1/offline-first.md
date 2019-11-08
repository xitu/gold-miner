> * 原文地址：[]()
> * 原文作者：[]()
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/.md](https://github.com/xitu/gold-miner/blob/master/TODO1/.md)
> * 译者：
> * 校对者：

# Designing Offline-First Web Apps

![](https://alistapart.com/wp-content/uploads/2013/12/ALA386_designoffline_300.png)

When it comes to building apps, we often assume our users are very much like us. We picture them with the latest devices, the most recent software, and the fastest connections. And while we may maintain a veritable zoo of older devices and browsers for testing, we spend most of our time building from the comfort of our modern, always-online desktop devices.

For us, a connection failure or slow service is a temporary problem that warrants nothing more than an error message. From this perspective, it is tempting to think of connectivity, mobile or otherwise, as something that will solve itself over time, as we get more network coverage and faster service. And that works, as long as our users stay above ground in large, well-developed—but not overly crowded—cities.

But what happens once they descend into the subway, board a plane, travel over land a bit, or go live in the countryside? Or when they stand in the wrong corner of a room or simply find themselves part of a huge crowd? Our carefully constructed app experiences become sources of frustration, because we rely so fully on that ephemeral link back to the servers.

This reliance ignores a fundamental truth: Offline is simply a fact of life. If you’re mobile, you’ll be offline at some point. It’s okay, though. There are ways to deal with it.

## Taking stock

Web apps used to be completely dependent on the server: it did all the work, and the client just displayed the result. Any disruption in your connection was a major problem: if you were offline, you couldn’t use your app.

That problem is solved, in part, by richer clients, where more of the application logic runs in the browser—like Google Docs, for example. But for a proper offline-first experience, you also want to store the data in the front end, and you want it to sync to the server’s data store. Happily, in-browser databases are maturing, and there are an increasing number of solutions for this—like [derby.js](http://derbyjs.com/#introduction_to_racer), [Lawnchair](http://brian.io/lawnchair/), [Hoodie](http://hood.ie), [Firebase](http://firebase.com), [remotestorage.io](http://remotestorage.io/), [Sencha touch](http://www.sencha.com/learn/taking-sencha-touch-apps-offline/), and others—so solving the technical aspects is getting easier.

But we have bigger, and much weirder, fish to fry: designing apps and their interfaces for intermittent connectivity leads to an abundance of new scenarios and problems.

There are of course a few precedents for offline-first UX, and one of them is especially prevalent: your email inbox and outbox. Emails go into your outbox, even when you’re offline. Once you’re online, they get sent. It’s simple and unobtrusive, and it just works.

For incoming email, the experience is similarly smooth: once you reconnect, new emails from the server appear at the top of your inbox. In between, you’ve got a more or less complete local copy of all your emails up to this point, so you’re never stuck with an empty app. All three scenarios (client push fails, client pull/server push fails, availability of local data when offline) are well handled.

Emails, as it turns out, are easy. They’re un-editable, easily listable, text-based, and conflict-free, and the notion of having local copies is already well established with email users. But there are so many more possibilities. How do we handle these scenarios, for example, in a collaborative drawing app? What if we’re not dealing with immutable items like email, but map markers with changing attributes, midi tracks, issues, tasks, or actions? The browser is the new application runtime of choice, and if we take [Atwood’s Law](http://www.codinghorror.com/blog/2007/07/the-principle-of-least-power.html) into account (“Any application that can be written in JavaScript, will eventually be written in JavaScript”), what other previously unheard-of things will we be doing in browsers in a couple years? Do we really still want to treat offline as an edge case and resort to failing features, irritatingly empty templates, and panicky error messages?

The experience of using a website or app when offline should be a lot better, less frustrating, and more empowering. We need the UX equivalent of responsive web design: a strong catalog of guides and patterns for a disconnected, multi-device world.

## The connectivity lifecycle

Most web apps have two connectivity-related points of failure: client push and client pull/server push. Depending on what your app does, you might want to

* communicate or explicitly hide the connectivity state and its changes (for instance, a chat client would inform users that any new messages typed are not sent immediately);
* enable client-side creation and editing features even when offline, and reassure users that their data is safe and will eventually make it to the server (think of a photo sharing app that lets you take and post pictures under any circumstances); and
* disable, modify, or possibly even hide features that cannot work offline, instead of letting people fail at using them (imagine a “send” button that knows when to turn into a “send later, when online” button).

Other issues arise when the connectivity state changes during use, e.g., the server wants to push a change to the object or view that the user is currently looking at, or even editing. This would require you to

* notify the user that newer, possibly conflicting data is available; and
* give the user a pleasant conflict-resolution tool, if necessary.

Let’s take a look at some real-world examples.

## Problematic connectivity scenarios

### Losing local data

Going offline while using Google Docs in a browser other than Chrome can be quite frustrating: you can’t edit your document. And while reading is still possible, copying parts of it isn’t. You can’t do anything with your text or spreadsheet—not even copy it to another program to continue working there. And yet, this is actually an improvement over past versions, where a large overlay would notify you of the offline state and prevent you from even seeing your work.

This is a common occurrence in both native and web apps: data you’ve only just accessed suddenly becomes unavailable when you lose your connection. If possible, apps should retain their last state and make their data available, even if it can’t be modified. This requires keeping local data to fall back to if the server can’t be reached, so your users are never stranded with an empty app.

### Treating offline like an error

Stop treating a lack of connectivity like an error. Your app should be able to handle disconnections and get on with business as gracefully as possible. Don’t show views you can’t fill with data, and make sure error messages hit the right tone. Take Instagram: when a person can’t post a photo, Instagram calls it a failure—instead of reassuring the user that the image isn’t lost, it’s just going to be posted later. No big deal. You might even want to reword your interface depending on the app’s connection state, such as turning “save” into “save locally.”

You might sometimes need to block whole features completely, but more often, you won’t need to. For example:

* If you can’t update a feed, show the old feed and a corresponding message. Don’t throw out the old data, then attempt to fetch the new data, fail, and end up with an empty, useless view.
* If your app lets users create data locally, let them do so, and inform them it will be saved and sent later. Optionally, ping them for confirmation before you do send it. Again, Instagram comes to mind: it knows where a photo was taken, but, when offline, can’t ask Foursquare what the place is called. Instagram could, however, ask users to come back to a picture and pick the Foursquare location once they’re online.

### Handling conflicts

If your app offers collaborative editing or some other form of simultaneous use on multiple devices, you will likely create conflicting versions of objects at some point. We can’t prevent this, but we can provide easily usable conflict-resolution UIs for people who might not even understand what a sync conflict is.

Take Evernote, whose business is heavily based on syncing notes: conflicts are resolved by simply concatenating both versions of the note. On anything longer than a couple of lines, this requires an inordinate amount of cognitive effort and subsequent editing.

[Draft](http://draftin.com), on the other hand, has managed to make conflict resolution between collaborators simple and beautiful. It shows both versions and their differences in three separate columns, and each difference has an “accept” and an “ignore” button. Intuitive and visually appealing conflict resolution, at least for text, is definitely possible.

Detailed change-by-change resolution isn’t always necessary. In many cases you just need to provide a nice interface for highlighting differences and allowing the user to choose which version wins in this specific conflict.

There are other types of conflicts awaiting us, however, and many of them won’t be text based: disputed map marker positions, bar chart colors, lines in a drawing, and endless other things we haven’t even thought of yet.

But not all technical problems need technical solutions. Consider two waiters with wireless ordering devices in a large, multi-story restaurant. One is connected to the restaurant’s server. The other is on the very top floor, where his connection fails temporarily. Both wait tables that order the same bottle of rare, expensive wine. The offline waiter’s device cannot know about this conflict. What it can do, however, is be aware of the risk of conflict (low stock number, its own offline state) and advise the waiter to give an appropriate reply to the table (“Oh, exquisite choice. Let me see if that’s still available”).

### Preempting users’ needs

In some cases, apps can preemptively take low-overhead action to give users a better experience later. When Google Maps detects I’m on wifi in a different country than usual, it could quickly cache my surroundings for the likely case of later offline or roaming use.

In many cases, however, content is too large to preemptively cache it—for example, a video from a news site. In these cases, users must make the explicit decision to locally sync, which would require them to download the video to their device and view it in a different application. Any context that video had online—like related information or relevant comment threads—is now lost, as is the opportunity for users themselves to comment.

### Refreshing chronological data

All of these examples were client push, but there’s the server push aspect as well: what can we do when the server updates a user’s active view, and pushes data that can’t conveniently be added to the top of a list? Chronological data often causes this problem.

For example, if you use iMessage on several devices, messages are sometimes displayed out of chronological order when syncing. iMessage **could** sort them in the correct order—they are timestamped, after all—but instead it shows them in the order in which they arrived on the device. This makes them highly noticeable, but is also terribly confusing.

Imagine the more intuitive way of doing it: messages are always shown in chronological order, regardless of when they arrive. This sounds more sensible at first, but means you may have to scroll back in time to read a message that just arrived, because it was sent in response to something much older. Worse, you might not even notice it, since it pops into existence somewhere you’re probably not looking.

If you display data chronologically and the sequence of the data itself is meaningful, like in a chat (as opposed to email, which can be threaded), offline capabilities pose a problem: the most recently transmitted data is not necessarily the newest, and may therefore appear somewhere users won’t expect it. You could maintain context and sequence, but your interface also needs to let users know **where in time** the new content is.

### Preparing for diverse data types

Many of these examples are text based, and even if they aren’t (like a map marker), some of them could conceivably have a text-based helper (like a list of map markers next to the map), which can simplify sync-related updates and notifications.

However, we know the amount, diversity and complexity of web applications will continue to increase, as will the types of data that are handled by their users. Some will be collaborative, most will be usable on multiple devices, and many will introduce new and exciting syncing issues. It makes sense to study them, and to develop a common vocabulary for offline scenarios and their solutions.

## Offliners Anonymous

As we started asking developers from all over the world about these issues, we were surprised at how many people suddenly opened up about their tales of offline woe—realizing they’d had similar problems in the past, but never spoken to others about them. Most battled it out alone, gave up, or put it off, but all secretly wished they had somewhere to turn for offline app advice.

We don’t need to be anonymous, though. We can look to [John Allsopp’s call](/article/dao), 13 years ago, to embrace the web as a fluid medium full of unknowns, and to “accept the ebb and flow of things.” Today we realize this extends beyond screen sizes and aspect ratios, feature support and rendering implementations, and holds true even for our work’s very connection to the web itself.

In this even more fluid and somewhat more daunting reality, we’ll all need each other’s help. We should make sure that we, and those who follow us, are equipped with reliable tools and patterns for the uncertainties of the increasingly mobile world—both for the sake of our users and for our own. Web development is complicated enough without wasting extra time reinventing wheels.

To help each other and future generations of designers, developers, and user interface experts, we are inviting you to join the discussion at [offlinefirst.org](http://offlinefirst.org). Our eventual goal is to create an offline handbook that includes UX patterns and anti-patterns, technology options, and research on user’s mental models—creating a repository of knowledge to draw from and contribute to, so our collective efforts and experiences don’t go to waste.

For now, we need to hear from you: about your experiences in this field, your knowledge of tools, your tips and tricks, or even just your challenges. Solving them won’t be easy, but it will improve our users’ experiences—wherever and whenever they need our services. Isn’t that why we’re here?

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
