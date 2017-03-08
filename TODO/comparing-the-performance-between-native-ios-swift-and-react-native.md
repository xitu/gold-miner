> * 原文地址：[Comparing the Performance between Native iOS (Swift) and React-Native](https://medium.com/the-react-native-log/comparing-the-performance-between-native-ios-swift-and-react-native-7b5490d363e2#.ads9p0f4n)
* 原文作者：[John A. Calderaio](https://medium.com/@jcalderaio?source=post_header_lockup)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

# Comparing the Performance between Native iOS (Swift) and React-Native #

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*e1ndrqm2zZhe7IVjA6ugpw.jpeg">

React-Native is a hybrid mobile framework that lets you build apps using only JavaScript. However, unlike other hybrid mobile technologies you are not building a “mobile Web App” (Web App wrapped in a native container). In the end, you get the real thing. Your JavaScript codebase is compiled to a mobile app indistinguishable from an iOS app built using Objective-C or an Android app using Java. This means that React-Native provides the benefits from both Native and Hybrid Mobile Apps, without any of the drawbacks.

My goal is to find out if they can deliver on exactly what they promise. To achieve this, I will need to build the same app in both Swift and React-Native; it needs to be simple enough so that I can learn both languages and complete the apps in time, but complex enough so that it allows me to compare the CPU, GPU, Memory Usage, and Power Usage of each app. The app will have four tabs. The first one will be named “Profile” and will prompt the user to login to Facebook in order to retrieve the user’s profile photo, name, and email and display them on the page. The second tab will be called “To Do List” and will be a simple to do list using NSUserDefaults (iPhone internal memory). It will have “add item and “delete item” functions. The third tab will be named “Page Viewer” and will consist of a Page View Controller. The Page View Controller will have three screens that the user can swipe through (“Green”, “Red”, and “Blue” screens). The final tab will be named “Maps” and will consist of a Map View that zooms in to the user’s current location, with a blue dot on the map representing the user’s location.

### The Swift Process ###

First up was iOS and Swift. Learning Swift was relatively easy, as it is similar to many languages I already know (Java, C++). Learning Cocoa Touch (the iOS framework), however, was a much harder task. I watched Rob Percival’s video series on *Udemy.com*, which ran me from the introduction of Swift through the completion of several apps. Even after the introductory videos, I was still having trouble understanding Cocoa Touch. Much of the “learning” in these videos involved copy/pasting code but we weren’t quite sure what it did. I got the feeling even the teacher did not know and just memorized it. I do not like not knowing what every line of my code does.

Apple’s IDE (Xcode) is without a doubt very advanced and user friendly. You can click on what is called a Storyboard and set up the app screens in the order you want, putting an arrow on the screen where the app is to begin. In the first tab (“Profile”) I was able to drag the image view, name label, and email label where I wanted. Then, I dragged it to the code and made a connection, creating a new variable in the code in the process. Then, programmatically, once the user logged in through Facebook, I would set these variable names with their corresponding Facebook values. It took 3 weeks to make it through the video series and get comfortable coding in Swift/iOS.

You can view my code for the Swift version of this app at GitHub at this link: [https://github.com/jcalderaio/swift-honors-app](https://github.com/jcalderaio/swift-honors-app)

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*2rOfHO8rCsb8S8EANfTXCg.png">

Swift Tab 1 (Facebook Login)

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*oqP5ST5jpRs-ag_WCqEXjA.png">

Swift Tab 2 (To-Do List)

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*YPb_6vT2RWm54CVDvl84WQ.png">

Swift Tab 3 (Page View)

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*S3KFEaCqOzPJ22DPvxGfRQ.png">

Swift Tab 4 (Maps)

### The React-Native Process ###

Second up was React-Native. Learning JavaScript was a bit harder than Swift but still not difficult. I tried coding the app from bits and pieces of React-Native I had learnt off of the Internet, but it wasn’t enough. I needed some video lectures. Returning to *Udemy.com*, I watched Stephen Grider’s spectacular introduction to React-Native. At first I was incredibly overwhelmed. React-Native’s structure made no sense to me whatsoever, but after only a week of watching Stephen’s lectures I was able to start coding on my own.

What I really like about React-Native is that, unlike iOS, every line of code you write makes sense — you know what each line of code does. In addition, unlike in iOS (where you had to tweak settings for each page to look good in landscape and portrait for different screen sizes), in React-Native all the tweaking is done for you. Without any setup whatsoever, I was using the app I made in landscape and it looked perfectly fine. I ran the app in a number of different iPhone sizes and they looked fine there too. Because React-Native uses flexbox (similar to CSS for HTML) it is responsive to the size of the screen the app is being displayed on.

You can view my code for the React-Native version of this app at GitHub at this link: [https://github.com/jcalderaio/react-native-honors-app](https://github.com/jcalderaio/react-native-honors-app) 

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*wvxOOPoww_9IZto4cSpXYQ.png">

React-Native Tab 1 (Facebook Login)

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*4sSsR52cS8fQ30uf0hmbWw.png">

React-Native Tab 2 (To-Do List)

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*lh7tO4NH2DHbbrLle_vZ9A.png">

React-Native Tab 3 (Page View)

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*xYt9lyH_vaT5NQTOz86e2A.png">

React-Native Tab 4 (Maps)

### The Data ###

Now comes the time to pit the apps against each other to see which one performs better. I will be using Apple Instruments (a tool packaged within Xcode, Apple’s IDE) to test the two apps across three main categories: CPU (“Time Profiler Tool”), GPU (“Core Animation Tool”), and Memory Usage (“Allocations Tool”). Apple Instruments allows me to plug my phone in, pick any running app on my phone, pick the measurement tool I want to use, then begin recording (M, Igor).

There are 4 tabs in each app and each tab has a “task” which I will be performing to measure in each category. The first (“Profile”) tab’s function will be to login through Facebook. In the code is a graph request for profile picture, email, and name to be returned to the app from Facebook’s server. The second (“To Do List”) app’s task will be to add and delete a “to do item” from the list. The third (“Page View”) tab’s task is to swipe through 3 Page View screens. The fourth (“Maps”) tab’s task is to just click on the tab, and the code will cause the GPS to zoom in on the map to my current location and put a blue, radiating blip on me.

### CPU Measurements ###

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*pSaqGVOJ8EnNgSr3i7cmwg.png">

Swift VS React-Native CPU Usage

*Let’s go over each category:*

***Profile:*** React-Native wins this tab slightly with 1.86% more efficient use of CPU. While performing the task and recording the measurements, a spike in CPU usage was observed at the exact moment I pressed the “Log in with Facebook” button.

***To Do List:*** React-Native also barely wins this tab with 1.53% more efficient use of CPU. While performing the task and recording the measurements, spikes in CPU usage were observed at the exact moment I *added *an item to the “list” and when I *deleted* it.

***Page View:*** This time, Swift beat out React-Native with 8.82% more efficient use of CPU. While performing the task and recording the measurements, spikes in CPU usage were observed at the exact moment I swiped to a different page in the page view. Once I stayed on a page, the CPU usage decreased, but if I swiped the page again the CPU usage increased.

***Maps:*** Swift wins this category again with 13.68% more efficient use of CPU. While performing the task and recording the measurements, a spike in CPU usage was observed at the exact moment I pressed the “Maps” tab, which prompted the MapView to find my current location and highlight it with a blue, pulsating dot.

Yes, Swift won two tabs and React-Native won two tabs, but overall Swift used the CPU 17.58% more efficiently. The results may have been different if I allowed myself more time in each app instead of just focusing on the one task and stopping. I did notice that CPU was not used at all when changing from tab to tab, however.

### GPU Measurements ###

The second data set we will graph are the GPU measurements. I will perform one task per tab, for each Swift and React Native and write down the measurements. The Y axis goes up to 60 frames/second. Each second, over the course of time I am performing the tab’s task, a measurement will be recorded by the “Core Animation” tool. I will take the average of these and plot it in the following chart.

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*VCrdvrBoterX_v25H9z3Pw.png">

Swift VS React-Native GPU Usage
Let’s go over each category:

***Profile:*** Swift wins this tab slightly by running at 1.7 frames/second higher than React- Native. While performing the task and recording the measurements, a spike in frames/second was observed at the exact moment I pressed the “Log in with Facebook” button.

***To Do List:*** React-Native wins this category by running at 6.25 frames/second higher than Swift. While performing the task and recording the measurements, a spike in frames/s was observed at the exact moment I *added *an item to the “list” and when I *deleted*it.

***Page View:*** Swift beat React-Native in this tab by running at 3.6 frames/second higher. While performing the task and recording the measurements, I observed that the frames/second shot up to the high 50s if I swiped through the pages fast. Once I stayed on a page, the frames/s decreased, but if I swiped the page again the frames shot up again.

***Maps:*** React-Native wins this category because it runs 3 frames/s higher than Swift. While performing the task and recording the measurements, a spike in frames/s was observed at the exact moment I pressed the “Maps” tab, which prompted the MapView to find my current location and highlight it with a blue, pulsating dot.

Once again, Swift wins two tabs and React-Native wins two tabs. However, React-Native wins this category overall by .95 frames/s. It is amazing how much juice Facebook was able to squeeze out of React-Native’s code — so far it seems as if it is holding up against native iOS (Swift).

### Memory Measurements ###

The third data set we will graph are the Memory measurements. I will perform one task per tab, for each Swift and React Native and write down the measurements. The Y axis (Memory) will go as high as my highest measurement. My sample interval for CPU usage is 1 ms. Each ms, while I am performing the task, a measurement will be recorded by the “Allocations” tool. I will take the average and plot it in the following chart.

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*zV5VBZJBc7IfX9qSMzPm1A.png">

Swift VS React-Native Memory Usage
Let’s go over each category:

***Profile:*** Swift wins this tab slightly by using 0.02 MiB less memory. While performing the task and recording the measurements, a spike in Memory usage was observed at the exact moment I pressed the “Log in with Facebook” button.

***To Do List:*** React-Native wins this tab by using 0.83 MiB less memory than its Swift counterpart. While performing the task and recording the measurements, spikes in Memory usage were observed at the exact moment I *added* an item to the “list” and the memory usage decreased when I *deleted* an item from the list.

***Page View:*** In this tab, React-Native beat out Swift by using 0.04 MiB less memory. While performing the task and recording the measurements, I noticed NO memory spikes when switching between pages in Page View. Literally nothing changed.

***Maps:*** React-Native wins this category by a huge margin by using a whopping 61.11 MiB less memory than Swift. While performing the task and recording the measurements, a spike in Memory usage was observed at the exact moment I pressed the “Maps” tab, which prompted the MapView to find my current location and highlight it with a blue, pulsating dot. In both apps, the memory kept increasing over the course of the task but eventually reached stasis.

React-Native won three tabs and Swift won one. Overall, React-Native used 61.96 MiB less memory and won the Memory category. The results may have been different if I allowed myself more time in each app instead of just focusing on the one task and stopping. I did notice in the “Maps” tab (in both apps) that when I zoomed out of the map or moved the map around, the memory used increased exponentially. “Maps” used by far the most memory in each case.

### Conclusion ###

The mobile applications I made for Swift and React-Native are almost identical in their physical appearance. As you can see from the data I collected through measuring both of the application’s CPU, GPU, and Memory during the tasks in each of the four tabs, the apps are also almost identical in how they perform. Swift won overall in the CPU category, React-Native won the GPU category (barely), and React-Native won big time in the Memory category. I can infer from this data that Swift uses the CPU of the iPhone more efficiently than React-Native, React-Native uses the GPU of the iPhone slightly more effectively than Swift, and that React-Native somehow leverages the iPhone’s memory much more effectively than Swift does. React-Native, winning two out of three categories, comes in first place as the better performing platform.

What I did not account for was Native Android. iOS is my preferred platform of choice, so it is what I cared about most. However, I may soon try the same experiment on Android for completions sake. I would be curious to see what the results are but I would be willing to bet that if React-Native can beat out native iOS performance, than it can beat out native Android performance as well.

I am now more convinced than ever that React-Native is the framework of the future — it has so many advantages and so few disadvantages. React-Native can be written in Javascript (a language so many developers already know), its codebase can be deployed to both iOS and Android platforms, it is faster and cheaper to produce apps, and developers can push updates directly to users so that users do not have to worry about downloading updates. Best of all, at only a year old, React-Native is already outperforming native iOS Swift applications.

### References ###

Abed, Robbie. “Hybrid vs Native Mobile Apps — The Answer Is Clear.” *Y Media Labs*, 10 Nov. 2016, [www.ymedialabs.com/hybrid-vs-native-mobile-apps-the-answer-](http://www.ymedialabs.com/hybrid-vs-native-mobile-apps-the-answer-) is-clear/. Accessed 5 December 2016.

M, Igor. “IOS App Performance: Instruments &Amp; Beyond.” *Medium*, 2 Feb. 2016, medium.com/@mandrigin/ios-app-performance-instruments-beyond- 48fe7b7cdf2#.6knqxp1gd. Accessed 4 Dec 2016.

“React Native | A Framework for Building Native Apps Using React.” *React Native*, facebook.github.io/react-native/releases/next/. Accessed 5 Dec 2016.
