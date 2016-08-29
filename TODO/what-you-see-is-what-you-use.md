> * 原文地址：[What You See is What You Use](https://medium.com/the-year-of-the-looking-glass/what-you-see-is-what-you-use-5a97677a8c71?ref=uxdesignweekly#.8n33go9m6)
* 原文作者：[Julie Zhuo](https://medium.com/@joulee)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：


A few summers ago, I had the opportunity to live in two separate units of a loft building in San Francisco.

Given this was the same building, you’d expect the units to be quite similar, and they were. Both were about 1000 square feet, with a wall of large lattice windows that let in tons of light (and heat —we joked this place was like my native Texas: 90 degrees every afternoon). Both had the same corner kitchen, industrial stairs that led to an open bedroom, and annoyingly hollow doors.

The main difference was that the first place we stayed in was on the upper floor, and the second was on the ground floor. Why was this significant? Well, the upper floor apartment had a better view. And while both came with outdoor space, the ground floor apartment had an attached backyard patio, and the upper floor apartment had private space on the building’s roof.

The first place we stayed in had the roof deck. And while it wasn’t nearly as posh as this stock image below, we were thrilled when we ventured upstairs to check it out. There was a small table with some chairs and an excellent view of the city, perfect for 4:00pm wine with friends, a round of Settlers of Catan, or a good book when the fog spared us.


![](https://cdn-images-1.medium.com/max/800/1*krgFBDdD83SMH6eVcb7q5A.jpeg)

This is a pretty sick roof deck.

When we moved, we said goodbye to the roof deck and hello to a small private patio. Again, the fancy stock image below is just for illustrative purposes. Our actual patio featured no grass, but it was large enough for a couch and umbrella, some potted plants, and a grill.

![](https://cdn-images-1.medium.com/max/800/1*VCIac-3nw683O8EwhkEqvQ.jpeg)

This is a pretty sick patio.


You’d think on paper, trading the roof deck for a patio would be pretty fair. I mean, one comes with a great view, the other comes with easier access. You win some, you lose some. It evens out.

The thing is, having experienced both, I can count on one hand the number of times we used the roof deck.

In that same length of time, we were out on the patio pretty much _every (sunny) afternoon_.

I think about this all the time.

> The truth is, no roof deck, no matter how lovely or well-appointed, will get as much usage as an equivalent patio or yard.

When we lived on the ground floor apartment, we saw the patio every time we glimpsed out the window. Twenty, fifty, a hundred times a day, our eyes took in the cozy couch and the shady umbrella. _It was right there_. Without even consciously registering it, we found ourselves making excuses to go outside and enjoy the nice weather, whether we were working on our laptops, hanging out with friends, or BBQ-ing.

When we lived in the upper apartment, we could not see the roof deck in our day-to-day. It wasn’t hard to get to by any means — it took about 30 seconds to take the stairs up. _But it wasn’t in sight_. We had to remember that it existed, and then decide to go up there. The level of intentionality needed was similar to visiting the neighborhood store or park. Certainly, if we invited guests over and wanted to impress them, we’d take them to the roof deck. But we never serendipitously stumbled across the table and chairs and stunning view. It was easy to forget we had it. And so, alas, it remained largely unused.


I am often reminded of the patio and the roof deck when it comes to designing user interfaces.

We designers love our minimalism, our white space, our house stark. We love the elegant nooks and crannies where we can hide all our numerous features and options. Behind menus. In drawers. After a long-press or a swipe.

We reason, “Once people learn it once, they’ll know it forever.” We say, “People have the same choices no matter where we put them in the UI.”

It is incredibly easy to underestimate the power of visibility and of defaults.

Once, a long time ago, Facebook used a three-horizontal-line icon (deemed the “hamburger”) at the top left of the mobile app to reveal the app navigation panel. It was a clean and elegant way to access the different features of our site. (As a bonus, this navigation menu was consistent between our mobile apps and desktop site.) We popularized the notion of a sliding drawer navigation, and it is still a pattern you can find in many apps today.


![](https://cdn-images-1.medium.com/max/800/1*ArDcJETUpnajuHlnLwH3fg.png)

The hamburger icon navigation pane


Unfortunately, the hamburger menu is a roof deck. You tap it when you think to yourself, “I want to navigate to X.” It’s a classic example of o_ut of sight, out of mind_.

We changed the roof deck to a patio by adopting the standard tab bar. While it added more elements to the screen, it was a familiar pattern that was was far more effective at helping people see and navigate to our top features.

I find there are many other examples of the _roof deck_ versus _patio_ dynamic at play in discussions about UI:

*   **On entry points**: A common first step when designing a new feature is to dive straight into creating mocks that show how this feature will work. That’s like designing the layout and configuration of your outdoor space before first asking “Is it behind the house? Is it on the roof?” Start by asking “_How will people discover this feature?_” Nailing the entry point tends to be harder and more important to the success of what you’re building than debating the finer points of how that feature will work once people get there.
*   **On menus**: It’s tempting to hide a bunch of options behind menus or gestures with the assumption that people who want to find them will. Most will not unless you actively promote those options. Even if you are successful in getting people to learn the affordance, it takes a long time before it’s common knowledge. If it is important that a majority of your users know about the option, explicitly show it. If it is not important, consider getting rid of it altogether to reduce cognitive overhead.
*   **On giving people options**: When faced with a hard product decision without an obvious answer, sometimes teams will settle for “We’ll just give users a choice here.” When you do this, know that the vast majority (80 or 90%) will pick whatever you default to, so you can’t actually get away from making the hard product decision. (Not providing a default is even worse: you’ll lose a bunch of people who just won’t make a decision at all.)
*   **On contextual actions**: When people are already doing or looking at something, suggest similar things they could be doing or looking at. Reading an article about the Olympics? You may be interested in other Olympics coverage by the same publisher. Inspired by this photo of a midcentury bathroom? Check out other stunning bathroom photos for your home remodel project. Triaging your flagged e-mail? Here’s other stuff you’ve marked for follow-up that you might want to take care of right now. This remains one of the most effective paradigms in experience design.
*   **On leveraging existing channels:** The power of existing distribution channels is that they’re already where people are. Writing an article and posting it on my personal website is a roof deck play. Writing an article and sharing it on Medium, Facebook, Twitter, is the patio maneuver that will yield more traffic. This applies to the creation of any standalone space, page, app, tab, or bookmark. Ask yourself: do I need to create my own channel, or are there other channels that will more quickly help me accomplish my goal?


If you want something to be seen and used, don’t make people look for it. Put it where they’re already looking.
