> * 原文地址：[Discovery in the age of abundant video](https://medium.com/googleplaydev/discovery-in-the-age-of-abundant-video-294b1e3fe7c4)
> * 原文作者：[Albert Reynaud](https://medium.com/@Reynaud_10696?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/discovery-in-the-age-of-abundant-video.md](https://github.com/xitu/gold-miner/blob/master/TODO1/discovery-in-the-age-of-abundant-video.md)
> * 译者：
> * 校对者：

# Discovery in the age of abundant video

## Key aspects to consider when improving your content discovery experience

![](https://cdn-images-1.medium.com/max/1600/0*Z4o0cUjhfdNMRrOd.)

Today, people have access to more video content than ever and [the number of platforms on which this content is available has more than doubled in the past 5 years](https://www.ericsson.com/en/trends-and-insights/consumerlab/consumer-insights/reports/tv-and-media-2017). As a result, people are spending an increasing amount of time ([+13% YoY](https://www.ericsson.com/en/trends-and-insights/consumerlab/consumer-insights/reports/tv-and-media-2017)) searching for the content they want.

![](https://cdn-images-1.medium.com/max/1600/0*enf33FQyYbhzNvV2.)

With the proliferation of over-the-top (“OTT”) platforms and the emergence of new consumption habits, building retention is increasingly challenging for content distributors. The ability to keep people engaged through frictionless and contextual discovery experiences will determine the success of these platforms.

In this article, I’ll be sharing insights and best practices around content discovery that I’ve collected by working with media entertainment platforms across Europe. While Google plays an instrumental role in bringing people into your app and website, I’ll be focusing on the aspects of the discovery that take place once someone has arrived on your properties.

### Decide how you’re going to measure success

![](https://cdn-images-1.medium.com/max/1600/0*kdOZRPISbF-SyFvm.)

Let’s start talking about discovery! But wait, how do we measure success?

No need to stress the importance of choosing the right KPIs to measure the impact of your discovery experimentation. Interestingly these KPIs tend to vary significantly whether you’re a subscription video on demand (“SVOD”) service, an advertising video on demand (“AVOD”) service, or a public or commercial broadcaster. Here are examples of the most commonly used metrics to measure the performance of discovery experiences:

*   Watch time, number of video views
*   Avg. number of playbacks per week, number of video completions
*   Number of sessions, session duration
*   % sessions or playbacks coming from recommendations engines

The potential issue of such short term KPIs is that focusing on them exclusively will distract your business away from longer term objectives. As an example, you could increase video consumption by recommending low quality, sensational content, but in the longer term, this will hurt your image and audience’s loyalty.

For that reason, I recommend combining discovery KPIs with longer term KPIs such as the **number of subscribers or 30 day retention.** Although these may be more challenging to A/B test, they will ensure the experience you’re providing is fully aligned with your long-term business objectives.

### The right fuel for your recommendation engine

![](https://cdn-images-1.medium.com/max/1600/0*pXKT80eUkgEbBk-7.)

As recommendation engines get smarter, there’s no doubt they’ll play an increasingly important role in how platforms surface content to people. They’re used throughout media platforms in areas such as dynamic content ranking, semantic search, and clustering of collections.

Many in the ecosystem are using basic recommendation engines and finding some success. However, more and more content providers are looking to get more sophisticated by adding approaches to their recommendation system such as:

*   **Collaborative filtering:** predicting what people will like based on their similarity to other users
*   **Content-based filtering:** recommending items that have similar features to those that the user liked in the past

But you shouldn’t expect algorithms to do all the work for you. Finding the right balance in recommendation engines while aligning with your business objectives can be more challenging than it seems:

*   **Implicit versus explicit feedback:** How do you interpret declarative feedback? What behavior signals from your audience should be considered: click on video, completing playback? How to simplify the process of giving explicit feedback: star rating, like, etc? One example is in the recent update of Play Movies & TV. We added thumb ratings as explicit feedback which directly feed into the recommendation algorithms — check out this [video](https://www.youtube.com/watch?v=smc80kgmZ8k&feature=youtu.be&t=16s) (16s) for an example.
*   **Editorial versus automated:** How do you preserve the personality of human recommendations that constitutes your brand and positioning? Content discovery solution provider [CogniK](https://www.cognik.net/discovery-recommendations/) recommends to leverage the content lists provided by the editorial team to improve your recommendation engine. Similarly, editorial teams may have control over some parameters of your recommendation engine by attributing manually more weight to certain content or categories.
*   **Live versus on-demand:** When should you balance one over the other? How do you mix this without confusing your audience?
*   **Popularity versus novelty:** How do you suggest new and unknown content and avoid echo chamber effects? How to balance serendipity with relevance of recommendations as collaborative filtering based recommendations will typically naturally converge to popular trends if the UI doesn’t combat the trend. Some content providers tend to increase the level of serendipity of their recommendations based on how long someone has been in the platform.

### Enrich your recommendations with broader context

![](https://cdn-images-1.medium.com/max/1600/0*bSqwlsJr9xRmtE3b.)

In circumstances where personalization is either impossible (cold start: people using your platform for the first time) or insufficient, you may want to enrich your experience with other contextual input.

Taking into account aspects such as **time** (weekday vs. weekend, time of the day, etc), or **location** (highlight local news or channels, sport teams) is now pretty common among media & entertainment platforms. Similarly, providers tend to adapt the duration and category of recommended videos based on the **form factor:** people probably prefer short form videos to consume on their phone and longer content on the big screen.

More recently, I’ve seen more and more platforms tapping into **trending topics** and upcoming events in order to feed their recommendation and curation experiences (elections, breaking news, sport events, etc).

### Adapt to your audience’s expectations and mindset

![](https://cdn-images-1.medium.com/max/1600/0*mz0_hVhri9mnMHqI.)

As a media platform, you should anticipate and be prepared to serve all possible user intents.

One way to do so is to adapt your UX to the different methods for finding something to watch depending on how indecisive your audience is. Influenced by a number of external factors (who people watch content with, available time, motivation, mood, etc), your audience may take a radically different approach to access the content they’re going to watch. Based on research, the Google Play movies product team uses a framework that categorizes the way people operate when they decide what to watch in one of four different modalities: **find, select, browse, or surf**. Your experience should be able to address each modality across the **“certainty spectrum”**.

![](https://cdn-images-1.medium.com/max/1600/0*vuY5zE6OLPbnWO5G.)

Source: Google Play Movies Research

Similarly, some solutions providers like [Spideo](http://spideo.tv/en/mood-based-discovery/) are now trying to capture the **mood** of their users based on keywords and wishes in order to fit with their aspirations at a particular time.

![](https://cdn-images-1.medium.com/max/1600/0*bbcv1sLpaPG5JA-8.)

Source: [Spideo](http://spideo.tv/en/)

While it can be challenging to adapt your discovery to all possible intents, it is helpful to define your most typical user groups using **persona profiles** in order to better inform your product team**.** Using empirical data, persona profiles constitute an informed summary of the mindset, needs, and goals typically held by certain segments of your audience. [Discover further best practices for developing data-driven personas using conjoint analysis](https://research.google.com/pubs/pub44167.html).

![](https://cdn-images-1.medium.com/max/1600/0*x08S8A8z7h-BIN4B.)

Source: Luma Institute

Here are examples of possible media persona profiles I’ve come across: TV couch traditionalist, screen shifter, binge watcher, sports fan, computer centric, etc.

### Facilitating routines

![](https://cdn-images-1.medium.com/max/1600/0*XGPPuhAGqBeEKFWx.)

Instead of taking people through a complete discovery journey each time they log into your platform, you may help them improve actions of what they already frequently do.

Typically, some user segments such as football fans watching weekend highlights, morning news addicts, or Saturday nights movie fans, present behavioral patterns that can easily be supported by your platform. Some of your audience may not even be aware of their own routine and appreciate that you’re able to anticipate their preferences.

The “Discover Weekly” playlist of [Spotify](https://play.google.com/store/apps/details?id=com.spotify.music&hl=en) is another great example of a habitual user engagement. Every Monday morning, a personalized playlist is released to all users so they can discover and enjoy new content throughout the week.

### A smoother leanback experience

![](https://cdn-images-1.medium.com/max/1600/0*l41zSwlD0gkObg18.)

According to Ericsson ConsumerLab, live and scheduled linear TV still represents 58% of active viewing hours. While on-demand usage is continuously growing driven by younger audiences, people still love the serendipity and ease of linear TV and will continue looking for smoother leanback experiences.

As a result, many on-demand services are recreating these benefits by offering linear streams of personalized content that people can turn on and adjust with minimum interaction (e.g. Flow from [Deezer](https://youtu.be/ykbaMNaGLgc)). Your audience will be expecting more of these leanback experiences, unforgiving of inaccuracies, and demanding on transparency and control.

There are other ways of bringing fluidity into the discovery experience. Functionalities such as auto-play or watch next have now been adopted by most platforms. In addition, I’ve seen great adoption of functionalities like [**picture in picture**,](https://developer.android.com/guide/topics/ui/picture-in-picture.html) or “start playing when on focus”. All of the above participate in recreating the magic of linear TV within on-demand platforms.

### Assist decision making

![](https://cdn-images-1.medium.com/max/1600/0*lnTXJY_3Rgi_k8w3.)

It is tempting for product teams to associate their content with as much information as possible, thinking it’ll guide people in their decision. Title, description, genre, price, ratings, trailer, etc… very quickly, this overload of information will lead people to a state of “**decision paralysis”.**

A picture says a thousand words and, as a result, many platforms are spending more and more time optimizing the right visuals for their content. User studies can also help you distinguish the “most critical” information from “important” or “nice to have” information and prioritize accordingly.

Another common way of simplifying the experience is to dynamically display additional information only when required, when people express some kind of interest in particular content: click, mouse-over, on-focus, etc — see this [video](https://www.youtube.com/watch?v=smc80kgmZ8k&feature=youtu.be&t=37s) (at 37 seconds) for an example.

Finally, you may consider **editorializing** your titles, making them more human and relatable than simple titles. By stressing the context of a sports game, the implications of a story, the highlight of a TV show or revelation of a new episode, the discovery experience becomes more relevant for your audience.

* * *

These insights will hopefully help you define and optimize your approach to content, and better engage your audience — whether that be through better definition of your goals, optimizing to the workings of engine’s to accelerate your visibility, improved understanding of your audience, and anticipating their behaviour and what they want, where and when they want it.

### What do you think?

Do you have thoughts on content discovery for media platforms? Let us know in the comments below or tweet using **#AskPlayDev** and we’ll reply from [@GooglePlayDev](http://twitter.com/googleplaydev), where we regularly share news and tips on how to be successful on Google Play.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
