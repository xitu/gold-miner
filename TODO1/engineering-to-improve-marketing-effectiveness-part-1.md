> * 原文地址：[Engineering to Improve Marketing Effectiveness (Part 1)](https://medium.com/netflix-techblog/engineering-to-improve-marketing-effectiveness-part-1-a6dd5d02bab7)
> * 原文作者：[Netflix Technology Blog](https://medium.com/@NetflixTechBlog?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/engineering-to-improve-marketing-effectiveness-part-1.md](https://github.com/xitu/gold-miner/blob/master/TODO1/engineering-to-improve-marketing-effectiveness-part-1.md)
> * 译者：
> * 校对者：

# Engineering to Improve Marketing Effectiveness (Part 1)

Authored by — [Subir Parulekar](https://www.linkedin.com/in/subir-parulekar-19ab403/), [Gopal Krishnan](https://www.linkedin.com/in/gopal-krishnan-9057a7/)

_“Make people so excited about our content that they sign up and watch”_

- Kelly Bennett, Netflix Chief Marketing Officer

This statement has become the driving force on our Advertising Technology (AdTech) team. With a slate of great original content to promote, Netflix has a unique opportunity to use both earned and paid media to create the excitement among people all over the world. Netflix is now available in 190 countries and advertises globally in dozens of languages, for hundreds of pieces of content, using millions of promotional assets.

The AdTech team’s charter is to help make it easy for our marketing partners to spend their time and money wisely through experimentation and automation. This involves deep partnership with marketing, operations, finance, science and analytics groups to drive improvements across the board. This is the first in a series of blog posts where we share all the ways we partner with our marketing team all the way from collaborative asset creation and assembly of advertisements to optimizing campaigns on programmatic channels.

**Context and Culture:**

The Netflix marketing team believes the best ways to create demand for Netflix is to promote high quality, exclusive content that can only be watched on Netflix. If we are successful at creating demand for our original content, new members will sign up. As part of this process, we are more successful if we create and collect on this demand (acquisition marketing) in about the right proportion by market.

Choosing which titles and markets to support remains a mix of art and science, with our creative teams working hand in hand with our technology teams to create winning formulas. Marketing makes top level strategy decisions on the set of markets to advertise in, the set of titles that need attention, and the creative behind the title in partnership with the director/showrunner.

The AdTech team helps our marketing partners execute against that strategy in the following ways:

1.  Creating technology to streamline workflows to improve assets for marketing. This frees up the marketing team to be more focused on creative aspects and less on the mundane.
2.  Creating a unified internal platform for creating ads and campaigns across all our promotional canvases and channels. E.g. Facebook, Youtube, Instagram, TV, out of home, etc.
3.  Enabling technology that allows us to measure and optimize the effectiveness of our marketing campaigns — be it via online programmatic channels or via offline channels. For example, we do this through various algorithms on Facebook and YouTube that help us better understand impact and improve our spend efficiency.

We are proud of Netflix’s data driven culture, as you can read about [here](https://medium.com/netflix-techblog/its-all-a-bout-testing-the-netflix-experimentation-platform-4e1ca458c15) and [here](https://ieondemand.com/presentations/quasi-experimentation-at-netflix-beyond-a-b-testing). Just as we improve our Netflix product through A/B testing, our marketing team embraces experimentation to help guide and improve human judgement. The more we can create tools and processes that streamline our approach, the more our talented teams can focus on helping great stories reach the right audiences. Our philosophy is “_every dollar we spend is a dollar we can learn from”_. The AdTech team ultimately seeks to create technology that will enable our partners to spend more of their time on strategic and creative decisions, while we use experimentation to guide Netflix’s instincts on the best tactical path forward.

**Optimizing for Incrementality**

Netflix aims to use paid media to drive incremental effectiveness. Some cohorts of people are likely to sign up for Netflix anyway (e.g. due to a friend’s recommendation) and we would rather not show ads to them to the extent we are able to control for it. Instead, what we are most interested in is having our marketing focus on people who have not yet made up their mind about Netflix. This overall strategy has heavily shaped our philosophy and work as you will find in subsequent blog posts.

At a high level, we can model the marketing lifecycle at Netflix to these four steps:

![](https://cdn-images-1.medium.com/max/800/0*f_bkj3H4z6gSA5ja.)

This article will go in details on first step of Creative Development & Localization. We will give an overview of the work to support our operations team who helps create millions of assets (trailers, artwork, etc.) that are used in Netflix marketing.

**Creative Development & Localization at Scale**

The rate at which Netflix is growing, marketing all of the Netflix Original titles in dozens of languages, with many concepts & message types will ultimately result in millions of marketing assets. We need our marketing, social & PR teams to come together to scale our content campaigns globally around the world. This will only be possible when we build a streamlined, robust asset creation & delivery pipeline to automate all the processes involved. This is where the Digital Marketing Infrastructure team enters! Our charter is to create applications and services that help Netflix Marketing optimize and automate their processes and scale their operations to deliver a large number of video, digital and print assets for all Netflix marketing campaigns being worked on across the globe.

To put it in simple words — any Netflix trailers and digital artwork that you see on YouTube, Facebook, Snapchat, Instagram, Twitter and other social media platforms or on TV are created and localized using tools built by the team. We even touch some of those physical billboards and posters you see at various freeways and traffic lights and on buses and trains all over the world.

![](https://cdn-images-1.medium.com/max/400/0*6vxzgYQuNvpUils5.)

![](https://cdn-images-1.medium.com/max/400/0*0qic6MBXAXNzAHLp.)

![](https://cdn-images-1.medium.com/max/400/0*BmrA1SFkZ0jKx_Dk.)

Netflix posters on subways (New York), elevators (Colombia) and billboards (Mumbai)

**So how are these trailers created?**

In the Audio Visual (AV) world, it all starts with the Marketing Creative team working with external agencies to create a set of trailers for a particular title. A title can be a Series like [Stranger Things](https://www.netflix.com/title/80057281) or a movie like [Bright](https://www.netflix.com/title/80119234), or a Stand up Comedy like [Dave Chappelle’s](https://www.netflix.com/title/80171965) or a Documentary like [13th](https://www.netflix.com/title/80091741). After a few rounds of creative review and feedback, the trailer is finalized for the original language of the title. Regions then need this trailer in various combinations of subtitles, dubs, ratings card, Netflix logo in specific locations on the screen, etc. Here is an example showing these various combinations for a frame from [Ozark](https://www.netflix.com/title/80117552).

![](https://cdn-images-1.medium.com/max/800/0*RKKQ86KDXyAfTgZK.)

The Marketing team works with multiple partner agencies to build these localized video files for these trailers. The assets are then encoded to specifications (file type, resolution, encoding) of the social platform where they will be delivered.

To give an insight into the numbers, the following graphic gives an idea on the number of video assets that were created for marketing [Bright](https://www.netflix.com/title/80119234). We ended up with a total of over 5000 different files covering different languages and various ad formats.

![](https://cdn-images-1.medium.com/max/800/0*25v1WBwYoFBb3Qyf.)

Our Marketing team spends a lot of time creating, producing, testing, and sometimes redelivering these assets due to video, subtitle, dubbing issues. We also incur expenses for getting these done by external agencies to help scale out this operation today. Moving forward, we would love to be able to gather metrics during the marketing campaign to identify bottlenecks, be able to compare campaigns for various titles and provide much needed visibility across global teams.

**How do we help?**

We started our work by looking through the Marketing workflow and identifying key automation points in the process and started building applications/services to help optimize. We are building:

*  **Digital Asset Management**: We are building a Digital Asset Management (DAM) system that provides a user interface to our partners and external agencies to upload/download/share these digital assets. We support uploading up to terabytes of data and millions of files from video/photo shoots in a single upload. We have leveraged Amazon S3 to store the physical assets, but store the metadata for the assets in the DAM. We have built collaboration features on top of the system and are continuing to invest in building out more features to essentially build something that will be a DAM + Dropbox + Google docs and will have the benefit of being connected with the Netflix ecosystem of tools.

*  **Video Clipping in the Cloud**: We are rebuilding a video clipping tool that our agency partners can use to clip short video clips from footage to create the trailers/teasers.

*  **Video assembly for marketing assets**: We are actively working on a first of its kind video assembly tool. At the click of a button, this tool will automate creation of localized versions of the trailer given all the inputs such as the master trailer file along with the subtitles, dubbing and other relevant information for a language/region. We are excited to continue innovating with the assembly as we are confident of seeing huge benefits by reducing time, effort and expenses that are incurred today to create these localized assets in various languages. What takes hours and days today will just take seconds and minutes to get done!

*  **Encoding in the cloud**: We are leveraging the [Netflix Encoding Service](https://medium.com/netflix-techblog/high-quality-video-encoding-at-scale-d159db052746) to encode the assets as per platform specifications. However, the Marketing teams do not need to know the specific encoding details needed by the social media platforms and so we are providing an abstraction layer on top of the encoding service where the teams only need to specify the platforms and the layer converts that to the encoding specs. We are providing this as a service for other tools in Netflix to use.

*  **Campaign management oversight**: We are creating a global campaign management lifecycle application to provide insights into the health of the marketing campaigns. This follows the campaign over several months & provides visibility into all of the work being done, including metrics, bottlenecks & modeling the workflow through which the assets move from inception to delivery. This application will be the central hub used by various sub-teams within Marketing to collaborate and gain visibility into the asset creation and production workflow.

As we make progress on each of these tools individually, the real value will be realized when all of these tools start interacting with each other and doing automated handoffs for the assets from one tool to another minimizing human involvement for lower order decisions. Here is how it will all come together.

![](https://cdn-images-1.medium.com/max/800/0*e_uEt-JxxMTwxHaY.)

We have set ourselves with the goal of making 2018 the year when all the moving pieces start to work together and we expect to see tremendous gains on the operations side in terms of time, effort and resources.

The team is growing fast and rightly so, as the benefit of automating and optimizing most of these workflows will save us a lot of manual hours and expense. That is the only way forward for us to scale. We are hiring for several [open positions](https://sites.google.com/netflix.com/adtechjobs) in the AdTech team to help us architect and build these systems. A chance to make an impact of this magnitude is rare. If you are interested in working on these complex challenges to disrupt the entertainment industry and shape its future, we would love for you to be a part of the team!

As mentioned earlier, Creative Development & Localization is just the first stage in the Marketing Asset Creation and Delivery pipeline. There are a lot of interesting opportunities and challenges in the whole process.

Our follow up articles will go in depth on the next stages of the marketing lifecycle. So stay tuned!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
