
> * 原文地址：[A Primer on Android navigation](https://medium.com/google-design/a-primer-on-android-navigation-75e57d9d63fe)
> * 原文作者：[Liam Spradlin](https://medium.com/@LiamSpradlin)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/a-primer-on-android-navigation.md](https://github.com/xitu/gold-miner/blob/master/TODO/a-primer-on-android-navigation.md)
> * 译者：
> * 校对者：

# A Primer on Android navigation

> Any vehicle someone uses to move between scenes in your interface — that’s navigation

As soon as you link two screens together in an app, you have navigation. That link—whatever it may be—is the vehicle that carries users between those screens. And although creating navigation is relatively simple, creating the *right* navigation for your users isn’t always straightforward. In this post we’ll take a look at some of the most common navigation patterns used on Android, how they impact system-level navigation, and how to mix and match patterns to suit your interface and your users.

---

### ✏️ Defining navigation

Before digging into common navigation patterns, it’s worth stepping back and finding a starting point for thinking about navigation in your app.

The Material Design spec has some [great guidance](https://material.io/guidelines/patterns/navigation.html#navigation-defining-your-navigation) on how to approach defining navigation structures, but for the purposes of this post we can boil everything down to two simple points:

- Build navigation *based on* tasks and content
- Build navigation *for* people

Building navigation based on tasks and content means breaking down what tasks people will be performing, and what they’ll see along the way, and mapping out relationships between the two. Determine how tasks relate to one another — which tasks are more or less important, which tasks are siblings, which ones nest inside one another, and which tasks will be performed more or less often.

That’s where building navigation for people comes in — the people using your interface can tell you whether it’s working for them or not, and your navigation should be built around helping them succeed in your app.

Once you know how the tasks in your app work together, you can decide what content users need to see along the way and when and how to present it—this exercise should provide a good foundation for deciding which patterns best serve your app’s experience.

*📚 Find more detailed guidance on breaking down tasks and behaviors for navigation *[*in the Material spec*](https://material.io/guidelines/patterns/navigation.html)*.*

---

### 🗂 Tabs

![](https://cdn-images-1.medium.com/max/2000/1*7VP4nwgLIOSLg2W13Iz6Dg.png)

#### Definition

Tabs provide quick navigation between sibling views inside the same parent screen. They’re coplanar, meaning they can be swiped around, and they live in an extensible, identifiable tab bar.

Tabs are great for filtering, segmenting, or providing depth to related pieces of content. Unrelated pieces of content, or content with its own deep hierarchy may be better served by using other navigation patterns.

*📚 Find all the details on designing tabs *[*here*](https://material.io/guidelines/components/tabs.html#)*, and on implementing tabs *[*here*](https://developer.android.com/training/implementing-navigation/lateral.html)*.*

#### Tabs in action

![](https://cdn-images-1.medium.com/max/800/1*tgbpHME812InaPR0FW6qaw.png)

![](https://cdn-images-1.medium.com/max/800/1*BrOW6gtAXsqg4xymoOq9pQ.png)

![](https://cdn-images-1.medium.com/max/800/1*PJTRuuAemKls6g1l9YJkqQ.png)

Play Music, Google+, Play Newsstand

Play Music *(above, left)* uses tabs to add depth to the music library, organizing the same general content in different ways to accommodate different means of exploration.

Google+ *(above, center)* uses tabs to segment Collections, a single content type that leads to very heterogeneous content deeper in the app.

Play Newsstand *(above, right)* uses tabs on the Library screen to present different sets of the same information — one tab presents a holistic, multi-layered collection, while the other shows a condensed set of headlines.

#### History

Tabs exist on one level together, inside the same parent screen. So navigating between tabs should not create history either for the system back button or for the app’s up button.

---

### 🍔 Nav drawers

![](https://cdn-images-1.medium.com/max/2000/1*OlvxTeFymVd35TFE1d4QcA.png)

#### Definition

The navigation drawer is generally a vertical pane attached to the left edge of the canvas. Drawers can manifest off-screen or on, persistent or not, but they always share some common characteristics.

Typically, the nav drawer lists parent destinations that are peers or siblings with one another. A nav drawer can be used in apps with several primary destinations, and some unique supporting destinations like settings or help.

If you combine the drawer with another primary navigation component — bottom nav, for example — the drawer can contain secondary destinations, or important destinations that don’t directly follow in the hierarchy from the bottom nav.

When using the nav drawer, be aware of what *kinds* of destinations you’re presenting — adding too many destinations or destinations that represent different levels in the app’s hierarchy can get confusing.

Also be aware of visibility — the drawer can be good for reducing visibility or compacting navigation away from the main content area, but that can also be a drawback depending on how the destinations in your app need to be presented and accessed.

*📚 Get detailed guidance on nav drawer design *[*here*](https://material.io/guidelines/patterns/navigation-drawer.html)*, and implementation *[*here*](https://developer.android.com/training/implementing-navigation/nav-drawer.html)*.*

#### Nav drawers in action

![](https://cdn-images-1.medium.com/max/800/1*dFyqnTkAgdbLlFf5unYuTg.png)

![](https://cdn-images-1.medium.com/max/800/1*_3x6wIR1_bJYacP85YcSKg.png)

![](https://cdn-images-1.medium.com/max/800/1*t4KPT6fq_zgLH04hEuDsag.png)

Play Store, Google Camera, Inbox

The Play Store *(above, left)* uses the nav drawer to point to different sections of the store, each dedicated to a different type of content.

Google Camera *(above, center)* uses the drawer for supporting destinations — these are mostly destinations that augment the capture experience, plus a path to settings.

Inbox *(above, right)* has an extensible nav drawer that can get quite long. At the top are primary destinations that present different segments of your email, and below those are supporting segments called bundles.

Because the nav drawer in Inbox can get so long, the “settings” and “help & feedback” items are presented in a persistent sheet, accessible from anywhere in the drawer.

#### History

Nav drawers should generally create history for the system back button when the app has a distinct “Home” destination. In the Play Store, the home destination is the Apps & Games entry, which actually presents the user with tab navigation to see highlighted content of all types. So the Play Store creates history to get back to that destination from other areas of the app.

Google Camera likewise takes users back to the default, primary capture mode minus any augmentation.

![](https://cdn-images-1.medium.com/max/800/1*lVkPA6HXWIXX83XwkLZFuA.png)

![](https://cdn-images-1.medium.com/max/800/1*1JNy36LE4MknD-fzvblvCg.png)

![](https://cdn-images-1.medium.com/max/800/1*IsXPcy3A3NB0DcuypPqG9A.png)

The “start driving” entry augments the primary map view

The same goes for Google Maps *(above)* — any destination in the drawer is presented as either a layer on top of or an augmentation to the primary map screen, so the back button brings us back to a clean slate.

![](https://cdn-images-1.medium.com/max/800/1*cZMuV29jlk2r-SKVWOTCTw.png)

![](https://cdn-images-1.medium.com/max/800/1*-peWUuc8UOhglfOo2yzsSA.png)

![](https://cdn-images-1.medium.com/max/800/1*nq4Zb0Oc_6_pDfpCIUufGw.png)

You may notice the Play Store *(above)* doesn’t change the nav drawer indicator in the toolbar to an “up” button once you navigate to a destination. This is because the primary destinations in the drawer are on an equal level in the app’s navigation hierarchy. Since you aren’t moving deeper into the app by selecting “Movies & TV” from the drawer, you can’t go further up. You’re still at the top level, just on a parallel screen.

---

### 🚨 Bottom nav

![](https://cdn-images-1.medium.com/max/2000/1*ucVh0hZm7BLSQiI-yzet3Q.png)

#### Definition

On Android, the bottom nav component is comprised of between three and five primary destinations. Importantly, “more” is not a destination. Neither are menus nor dialogs.

Bottom navigation works best when your app has a limited number of disparate top-level destinations (bottom nav should never scroll) that need to be instantly accessible. One of the main benefits of a “bottom bar” is being able to jump from a child screen to an unrelated parent screen instantly, without navigating back up to the current parent first.

It’s important to note that while destinations in the bottom bar should all be equal in the app’s navigation hierarchy, items in the bottom bar are not coplanar the way tabs are, and shouldn’t be presented as such.

Swiping between destinations in the bottom bar suggests a relationship between destinations that doesn’t exist. Each destination should be a discrete parent, not a sibling of the other destinations. If the destinations in your app are similar or present similar content, they may be better suited for tabs.

*📚 Find more detailed design guidance for bottom nav *[*here*](https://material.io/guidelines/components/bottom-navigation.html#)*, and implementation details *[*here*](https://developer.android.com/reference/android/support/design/widget/BottomNavigationView.html)*.*

#### Bottom nav in action

![](https://cdn-images-1.medium.com/max/800/1*FCTrc2tb_5VLXSLmCGd0Qw.png)

![](https://cdn-images-1.medium.com/max/800/1*xqbx9YxgmpibQQEpXoljHQ.png)

![](https://cdn-images-1.medium.com/max/800/1*3_WrkSIhD7Y7jG9h4nCM6Q.png)

Google Photos

Bottom nav has some interesting considerations beyond its basic definition. Probably most complex is the notion of just *how* persistent the bottom bar should be. The answer, as with so many design decisions, is “it depends.”

Typically the bottom bar persists across the entire app, but there are some cases that could justify hiding the bottom bar. If the user enters a very shallow hierarchy — on single-purpose screens like message composition — or if the app wants to present a more immersive experience a step or two deep into the hierarchy, the bottom bar may be hidden.

In Google Photos *(above)*, the bottom nav disappears inside albums. Albums are presented as a secondary layer in the hierarchy, and the only further navigational action is opening a photo, which itself opens on top of the album UI. This implementation satisfies the “single-purpose” rule for hiding the bottom nav while serving the goal of creating a more immersive experience once the user gets beyond the top level.

#### Additional considerations

If the bar is persistent across the entire app, the next logical consideration would be behavior when jumping between destinations using the bar. If the user is several layers deep in a hierarchy stemming from one destination and they switch to another destination and then switch back to the first, what should they see? The parent screen, or the child screen on which they left off?

This decision should be informed by those using your app. In general, tapping an item in the bottom bar should go directly to the associated screen, not to a deeper layer of the hierarchy, but as with any guideline — *deviate with purpose.*

#### History

Bottom nav shouldn’t create history for the system back button. Going deeper into hierarchies stemming from bottom nav destinations can create history for the system back button *and* the app’s up button, but the bottom bar can serve as its own sort of historical navigation as well.

Tapping an item in bottom nav should take you straight to the associated destination, and tapping it again should navigate back to the parent level, or refresh the parent level if the user’s already there.

---

### 🕹 In-context navigation

![](https://cdn-images-1.medium.com/max/2000/1*urOlDr3ceb6JiqdQsS4GmQ.png)

#### Definition

In-context navigation is comprised of any navigational interaction outside of the components described above. This includes things like buttons, tiles, cards, and anything else that takes the user elsewhere in an app.

In-context navigation is typically less linear than explicit navigation — interactions may transport the user through a hierarchy, between different steps in discrete hierarchies, or out of the app entirely.

*📚 Look for more guidance on in-context navigation *[*here*](https://material.io/guidelines/patterns/navigation.html#navigation-combined-patterns)*.*

#### In-context navigation in action

![](https://cdn-images-1.medium.com/max/800/1*kAS321rLOPopo2wj5Pt1rQ.png)

![](https://cdn-images-1.medium.com/max/800/1*Obz9UAi5l2lFxjEA107EXA.png)

![](https://cdn-images-1.medium.com/max/800/1*Ks9Fvut3daB1khAkoB7aaQ.png)

Clock, Google, and Google Calendar

In the Clock app *(above, left)* there’s a FAB; the Google app *(above, middle) *relies primarily on information arranged inside cards; and Google Calendar *(above, right)* creates tiles for events.

![](https://cdn-images-1.medium.com/max/800/1*Ns0RzUEA6qmbQpILjMJMwA.png)

![](https://cdn-images-1.medium.com/max/800/1*OoSmQV5q6nN4gNSoVsIRNQ.png)

![](https://cdn-images-1.medium.com/max/800/1*ZWjwDWr61A5r8TprQiHCVw.png)

Activating the FAB in Clock *(above, left)* brings you to a world clock selection screen, tapping the weather card in the Google app *(above, center)* brings you to a search results page for “weather,” and tapping an event tile in Calendar *(above, right)* takes you to that event’s details.

We also see in these screenshots the different ways in-context navigation can transport the user. In the Clock app we’re down one level from the clock itself, in the Google app we’ve ended up at essentially an augmentation of the main screen, and in Calendar we’ve opened [a full-screen dialog](https://material.io/guidelines/components/dialogs.html#dialogs-full-screen-dialogs).

#### History

There’s no hard rule for creating history via in-context navigation. Whether history is created relies entirely on what kind of in-context navigation the app uses and where the user is taken. In cases where it’s not clear exactly what kind of history should be created, it’s good to know what the up and back buttons do in general.

---

### ↖️ Up, back, and close buttons

![](https://cdn-images-1.medium.com/max/2000/1*VBBwhx66_hRZApzdLzVrJA.png)

The back, up, and close buttons are all important to navigating an Android UI, but are often misunderstood. The three buttons actually have pretty simple behavior from a UX perspective, so remembering the following rules should help get you out of any perplexing situation.

- **Up **isfound in the app’s toolbar when the user has descended the app’s hierarchy. It navigates back up the hierarchy in chronological order until the user reaches a parent screen. Since the up button doesn’t appear on parent screens, it should never lead out of an app.
- **Back** is always present in the system nav bar. It navigates backward chronologically, irrespective of app hierarchy, even if the previous chronological screen was inside another app. It also dismisses temporary elements like dialogs, bottom sheets, and overlays.
- **Close **is typically used to dismiss transient layers of the interface or discard changes in a [full-screen dialog](https://material.io/guidelines/components/dialogs.html#dialogs-full-screen-dialogs). Consider the event detail screen in Google Calendar *(shown below)*. The temporary nature of the detail screen becomes even more clear on larger screens. In Inbox *(below)*, the transition from inbox to message suggests the message is a layer on top of the inbox, so the close button is appropriate. Gmail *(below) *positions the message as a distinct level of the app and uses the up button.

![](https://cdn-images-1.medium.com/max/800/1*zgH-Iq78hKbjiy-WaGl2uQ.png)

![](https://cdn-images-1.medium.com/max/800/1*BTqU6jg683KlT9cOZ98hpg.png)

![](https://cdn-images-1.medium.com/max/800/1*4NyzX3EnqcytgxgfDRuzLg.png)

Calendar, Inbox, and Gmail

*📚 Refer specifically to back vs up behavior in the Material Spec *[*here*](https://material.io/guidelines/patterns/navigation.html#navigation-up-back-buttons)*.*

### 🔄 Combining patterns

Throughout this primer we’ve seen examples of apps that successfully implement each of the various explicit navigation components. Many of these examples also succeed in combining navigation patterns to form a structure that makes sense for users. To wrap up, let’s review a couple of those examples with an eye toward mixing and matching.

![](https://cdn-images-1.medium.com/max/800/1*N_M792Hp2LBETAXjYgC3sw.png)

![](https://cdn-images-1.medium.com/max/800/1*RHPlqE4izZiFmNfXnkYSpg.png)

![](https://cdn-images-1.medium.com/max/800/1*SzghlBq-oWtLHwLaA85t1Q.png)

Google+

Maybe the most obvious example is Google+ *(above)*, which mixes all of the patterns we’ve discussed — tabs, a nav drawer, bottom nav, and in-context navigation.

To break it down, the bottom nav is the focus in G+. It provides access to four top-level destinations. Tabs augment two of those destinations by segmenting their content into sensible categories. The nav drawer contains other destinations, both primary and secondary, that might be accessed less frequently.

![](https://cdn-images-1.medium.com/max/800/1*cZMuV29jlk2r-SKVWOTCTw.png)

![](https://cdn-images-1.medium.com/max/800/1*IY9Ow4NVywiIC9YgfXlM4Q.png)

![](https://cdn-images-1.medium.com/max/800/1*GcX2vbkwoA8iGm3RwTsJVQ.png)

Play Store

The Play Store *(above)* primarily uses a nav drawer, frequently uses in-context navigation, and occasionally uses tabs.

In the shots above, we see destinations reached through the nav drawer. The drawer is still accessible on these screens because they’re all primary destinations. Just below the toolbar we see chips to navigate to filtered content selections, an example of in-context navigation. In app charts, tabs are used to sort the entire charted library into specific segments.

![](https://cdn-images-1.medium.com/max/800/1*c2rK-Zvz7W7aFThPSFqrJg.png)

![](https://cdn-images-1.medium.com/max/800/1*reXFTc6r_28x082Iyl74_A.png)

![](https://cdn-images-1.medium.com/max/800/1*ZWjwDWr61A5r8TprQiHCVw.png)

Google Calendar

Google Calendar *(above)* uses a nav drawer and in-context navigation, and uses both in really interesting ways.

The drawer in Calendar is non-standard, used mostly to augment the calendar. The calendar itself is controlled by an expanding toolbar panel, and colorful tiles lead users to event details.

📚 *Read more about combining navigation patterns *[*here*](https://material.io/guidelines/patterns/navigation.html#navigation-patterns)*.*

### 🤔 Have more questions?

Navigation is a complex topic. Hopefully this primer provides a good foundation for understanding common navigation principles on Android. If you still have questions, leave a response or catch up on our first [#AskMaterial](https://twitter.com/search?q=%23AskMaterial) session with the [Material Design](http://Material.io) & Design Relations teams on Twitter [here](https://twitter.com/i/moments/884845596145836032)!


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
