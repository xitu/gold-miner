> * 原文地址：[Benchmarks for the Top Server-Side Swift Frameworks vs. Node.js](https://medium.com/@rymcol/benchmarks-for-the-top-server-side-swift-frameworks-vs-node-js-24460cfe0beb)
* 原文作者：[Ryan Collins](https://medium.com/@rymcol?source=post_header_lockup)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：







### Introduction

Recently I was working in Server-Side Swift, and I was asked the question:

> “Can Server-Side Swift beat Node.js?”

Swift as a primary language for everything, including the server, has been intriguing since it was first open sourced and ported to Linux. Many of you are assuredly as curious as I am, so I’m very pleased to share the results of my study here.

#### The Top Server-Side Swift Frameworks

At the time of writing, the top Server-Side Swift Frameworks (Listed in order of Stars on GitHub) are:

*   [Perfect](https://github.com/perfectlySoft/Perfect) ⭐️7,956
*   [Vapor](https://github.com/vapor/Vapor) ⭐️5,183
*   [Kitura](https://github.com/ibm-swift/kitura) ⭐️4,017
*   [Zewo](https://github.com/zewo/Zewo) ⭐️1,186

#### Organization of this Post

This document is laid out in the following manner:

*   This quick intro
*   Results Summary
*   Methodology
*   Detailed Results
*   Conclusion & Final Notes

### Results Summary

The following is a quick summary of the primary benchmarks, and I will say this here:

> **No matter the individual rankings, all of these frameworks performed incredibly well, Swift consistently beat Node.js, and they were all a lot of fun to work with.**



![](https://cdn-images-1.medium.com/max/2000/1*-J6071Zqsic7zY521MXUHg.png)



This image was updated September 1st, 2016 with a correction



### Methodology & Notes

#### Why Use Blogs & JSON?

Most simply, blogs are more than returning “Hello, world!”, and JSON is a very common use case. Good benchmarks need a similar load on each framework, and it needed to be a bit more load that printing two words to the screen.

#### Keeping Things the Same

One of the major themes I tried to stick to was keeping all of the blogs as similar to one another as possible, while still developing in the style and syntax of each framework. Many of the structs, like content generation, are repeated throughout verbatim, so that each framework has the same data models to work with, but facets like URL routing are sometimes starkly different to fit with the syntax and style of each framework.

#### Subtle differences

There are some subtle differences to note between the Server-Side Swift Frameworks.

*   Both Kitura and Zewo have issues building if there are any spaces in their absolute file paths. Xcode also has issues building with spaces in absolute file paths in any framework.
*   Zewo is using the 05–09-a Swift snapshot, which means that it has trouble building in release mode and has to be run in debug mode. All Zewo tests were performed with Zewo built and running in debug mode (without release optimizations) for this reason.
*   Static file handling is a point of debate amongst Server-Side Swift Frameworks. Vapor and Zewo both recommend using Nginx as a proxy for static file handling, then putting the framework behind that as the processing power for the backend. Perfect suggests using their built in handler, and I have not seen any comments on IBM regarding their own views on the subject. As this study was not about how well frameworks work with established server applications like Nginx, static file handling was used natively with each framework. You may be able to achieve better performance in both Vapor and Zewo if you choose to build with this in mind. This is also a secondary reason that I included JSON testing.
*   [Added September 1st with updated results] Zewo is a single threaded application. You can get extra performance out of it by running one instance of the application per available CPU, as they follow a concurrent, rather than multi-threaded model. For the purposes of this study, only one instance of each application was run.
*   Toolchains. Each framework is building off a different development snapshot toolchain from Apple. At the time of final testing they were/are: 
    ```
    _- DEVELOPMENT-SNAPSHOT-2016-08–24-a for Perfect
    - DEVELOPMENT-SNAPSHOT-2016-07–25-a for Vapor & Kitura
    - DEVELOPMENT-SNAPSHOT-2016-05–09-a for Zewo_
    ```
*   Vapor has a special syntax for running releases. If you simply execute the binary, you’re going to get some extra console logging that is meant to help with the development and debugging process. That has a little overhead. To run Vapor in release mode you need to add

    `--env=production`

to the executable. i.e.

    `.build/release/App --env=production`

*   [Added September 1st with updated results] When working with Zewo, even though you cannot build with swift in release mode on the 05–09-a toolchain, you can add some release mode optimizations by passing these arguments:

    `swift build -Xswiftc -O`

*   Node.js/Express does not build, nor does it differentiate between debug/release
*   Static file handling is included in Vapor’s default middleware. If you are not using static files and want to optimize for speed, you must include (as I did in VaporJSON):

    `drop.middleware = []`

#### Why Node.js/Express?

I decided to include a variation of the blog using the Express framework in Node.js. This is a good comparison because it has a very similar syntax to Server-Side Swift and is widely used. It helps establish a good baseline to show just how impressive Swift can be.

#### Developing the Blogs

At some point I started to call this “chasing the bouncing ball”. The current Server-Side Swift frameworks are under very active development, as is Swift 3, and each has a ton of changes from its previous versions. This became amplified by the frequent releases from all the Server-Side Swift Frameworks, as well as the Swift team at Apple. None of them were particularly complete in their documentation at this point, so I’m very thankful to members of the framework teams and the Server-Side Swift community at large for their contributions. I’m also grateful for the help that countless community members and framework teams gave me along the way. It was a ton of fun, and I would do it again without thinking.

As a side note, even though attribution was not required by the license, I feel it is nice to note that all the random royalty-free pictures included in the sources are from [Pixbay](https://pixabay.com/), and were selected by me at random. Sources like this make demo projects much easier.

#### Hosting & Environment

To minimize any differences in the environment, I took a 2012 Mac Mini and gave it a clean install of El Capitan (10.11.6). After that, I downloaded and installed Xcode 8 beta 6, and set my command line tools to Xcode 8\. From there I installed swiftenv, installed the necessary snapshots, cloned the repos, and cleanly build each of the blogs, again in release mode where possible. I never ran more than one at a time, and each was stopped and restarted in between tests. The test server specs are:

![](https://cdn-images-1.medium.com/max/1600/1*vH5SdlsoPeIBYsy2mU-lkw.png)

For development, I use a 2015 rMBP. I ran the build time tests here, as this is my real-life development machine and it made the most sense. I used wrk to get the benchmarks, and I did this over a thunderbolt bridge using a thunderbolt 2 cable between the machines. Using a thunderbolt bridge makes sure that you have an incredible amount of bandwidth and that you are not benchmarking the limitations of your router, instead of the task at hand. It’s also more reliable to serve the blogs on one machine, and to use a separate, more powerful machine to generate the load, ensuring you are capable of overpowering the server, so that you can be certain this is not a limitation. This also gives you a consistent testing environment, so I can say that each blog was run on the same hardware and in the same conditions. For the curious, the specs of my machine are:

![](https://cdn-images-1.medium.com/max/1600/1*7QYZK-_cmb7231lnchJpuQ.png)

#### Benchmarking Notes

For benchmarking, I decided to use a ten minute test with four threads, each carrying 20 connections. Four seconds is not test. Ten minutes is a reasonable timeframe to get plenty of data, and running 20 connections on four threads is a hefty load for the blogs, but not a breaking load.

#### Source Code

If you would like to explore the source code for the projects or do any of your own testing, I consolidated the code used for testing into one repository, found at:

[https://github.com/rymcol/Server-Side-Swift-Benchmarking](https://github.com/rymcol/Server-Side-Swift-Benchmarking)

### Detailed Results

#### Build Time

I thought it would be fun to first take a look at build times. Build time can play a big role in day to day development, and while it has little to do with a framework’s performance, I thought it might be fun to explore real numbers vs. how long things felt while I was waiting.

#### What was run

For each framework,

    swift build --clean=dist

and then

    time swift build

were run, followed by a second test of

    swift build --clean

then:

    time swift build

This factors both a full build including pulling dependencies with SPM, as well as a regular, clean build with dependencies already downloaded.

#### How it was run

This was run on my local 2015 rMBP and the builds were all done in debug mode, because this is the normal process when developing Swift software.

#### Build Time Results

![](https://cdn-images-1.medium.com/max/1600/1*lhhh_8CgevyvpgfnGnVxXA.png) ![](https://cdn-images-1.medium.com/max/1600/1*wAWMcltJR7B9FP-x2NhzDQ.png)



* * *







#### Memory Usage

The second thing I looked at was the memory footprint of each framework under load.

#### What was Run

1st — starting memory footprint (just stared the process) 2nd — Peak Memory Usage of the process on my test server using:

    wrk -d 1m -t 4 -c 10

3rd — A repeat of the second test using:

    wrk -d 1m -t 8 -c 100

#### How it was Run

This test was run on a clean Mac mini dedicated as a test server. Each framework was built in release mode where possible. Only one framework was run from the command line at a time, and it was restarted between tests. The only other open window at the time of testing was activity monitor, which was used by me to visualize peak memory usage. As each framework was run, I simply noted the highest value that appeared in the activity monitor window.

#### Memory Usage Results

![](https://cdn-images-1.medium.com/max/1600/1*8cG8cHnkdhTzVM9Aj0QV9Q.png)



![](https://cdn-images-1.medium.com/max/1600/1*WhQcrT9d5OJI_J9n_XvZOA.png) ![](https://cdn-images-1.medium.com/max/1600/1*NY3syLPSPdGN25-3G7EC1g.png)



* * *







#### Thread Usage

The third thing I looked at was the thread usage of each framework under load.

#### What was Run

1st — starting threads (just stared the process) 2nd — Peak Thread Usage of the process on my test server using:

    wrk -d 1m -t 4 -c 10

#### How it was Run

This test was run on a clean Mac mini dedicated as a test server. Each framework was built in release mode where possible (more on that is in the methodology section). Only one framework was run from the command line at a time, and it was restarted between tests. The only other open window at the time of testing was activity monitor, which was used by me to visualize thread usage. As each framework was run, I simply noted the highest value that appeared in the activity monitor window while the test was running.

#### A Note About These Results

There is no “winning” in this category. Many applications treat threads differently, and these frameworks are no exception. For example, Zewo is a single threaded application, and it will never use more than one (edit: without your intervention to run it on each CPU in a concurrent configuration). Perfect, on the other hand, will use one per available CPU. Vapor will use one per connection model. As such, this graph was designed so that the spikes in threads under load are easily visible, as they are in the same order in both graphs.

#### Thread Usage Results

![](https://cdn-images-1.medium.com/max/1600/1*aLuf-9gs4Xd4ZtnwgNNgcA.png)



![](https://cdn-images-1.medium.com/max/1600/1*QwPMAL7EEOm9L8cIEelT3w.png)



* * *







#### Blog Benchmarks

The first benchmark is the /blog route in each, which is a page that returns 5 random images and fake blog posts for each request.

#### What was Run

    wrk -d 10m -t 4 -c 20 http://169.254.237.101:(PORT)/blog

was run for each blog from my rMBP over my thunderbolt bridge.

#### How it was Run

As with the memory testing, each framework was run in release mode where possible, and was stopped and restarted before each test. Only one framework was running at any given time on the server. All activity was made to be a minimum on both machines during the testing to keep the environment as similar as possible.

#### Results

![](https://cdn-images-1.medium.com/max/1600/1*T4iNJjI2pCUt1n-tZnWSnw.png)



This image was updated September 1st, 2016 with a correction

![](https://cdn-images-1.medium.com/max/1600/1*ddAC0BWrOBpvST0QQfpN7Q.png)

This image was updated September 1st, 2016 with a correction



* * *







#### JSON Benchmarks

Due to some complications of how everyone handles static files, it felt more fair to run the same tests over again using a more simple interface, so I added versions of each application that are sandboxed to a /json route that returns ten random numbers within 0–1000\. They’re separate to make sure that the static file handlers and middleware do not interfere with the results.

#### What was Run

    wrk -d 10m -t 4 -c 20 http://169.254.237.101:(PORT)/json

was run for each JSON project.

#### How it was Run

As with the other tests, each framework was run in release mode where possible, and was stopped and restarted before each test. Only one framework was running at any given time on the server. All activity was made to be a minimum on both machines during the testing to keep the environment as similar as possible.

#### Results

![](https://cdn-images-1.medium.com/max/1600/1*sb8WpWPKtUAO4hTTKr46Tg.png)



This image was updated September 1st, 2016 with a correction

![](https://cdn-images-1.medium.com/max/1600/1*NFq7qLFZaGpStZlyEdjfmA.png)

This image was updated September 1st, 2016 with a correction

### Conclusions

My question was answered with an overwhelming **YES**. Swift is more than capable of taking on the established server side frameworks. Not only that, but all of the Server-Side Swift Frameworks performed incredibly well, and Node.js was beaten by at least two of them in every test.

Given Server-Side Swift can save an insane amount of time sharing its codebase with your other Swift apps, the feature sets of the various Server-Side Swift Frameworks, and the results here, I would say that Server-Side Swift is well on its way to being a very big contender in the programming arena. I’m personally programming as much as possible in Swift, especially on the server-side, and I cannot wait to see all the incredible projects that will spring up out of the community!

### Get Involved

If you are interested in Server-Side Swift, now is the time to get involved! There is still a lot of work to be done on the frameworks, their documentation, and getting some really cool applications out there as examples, open or closed source. You can learn more about each framework and get involved here:

Perfect: [Website](http://perfect.org/) | [Github](https://github.com/PerfectlySoft/Perfect/) | [Slack](http://perfect.ly/) | [Gitter](https://gitter.im/PerfectlySoft/Perfect?utm_source=rymcol) Vapor: [Website](http://vapor.codes/) | [Github](https://github.com/vapor/Vapor/) | [Slack](http://vapor.team/) Kitura: [Website](https://developer.ibm.com/swift/kitura/) | [Github](https://github.com/IBM-Swift/Kitura/) | [Gitter](https://gitter.im/IBM-Swift/Kitura?utm_source=rymcol) Zewo: [Website](http://www.zewo.io/) | [Github](https://github.com/Zewo/Zewo/) | [Slack](http://slack.zewo.io/)

#### Get in Touch

If you want to connect, you can reach out to me [@rymcol](http://twitter.ryanmcollins.com/) on Twitter.

> Disclosures I felt were necessary: Edits were added September 1st, 2016 to correct some data after release optimizations were made for Zewo using a method alternate to `swift build -c release`. PerfectlySoft Inc. agreed to fund this study for me, to promote the power of Swift. I’m also on the github teams for Perfect & Vapor, though I am not an employee of either, nor do my opinions reflect theirs. I’ve done my absolute best to remain impartial, as I develop in all four platforms, and I was genuinely curious to see the results. [All the code is publically available for this study](https://github.com/rymcol/Server-Side-Swift-Benchmarking), please feel free to check it out or repeat some of the tests and verify it for yourself!

