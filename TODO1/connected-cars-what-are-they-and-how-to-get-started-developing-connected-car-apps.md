> * 原文地址：[Connected cars 🏎 — what are they and how to get started developing connected car apps](https://hackernoon.com/connected-cars-what-are-they-and-how-to-get-started-developing-connected-car-apps-5c6fbbf1f157)
> * 原文作者：[Indrek Lasn](https://hackernoon.com/@wesharehoodies?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/connected-cars-what-are-they-and-how-to-get-started-developing-connected-car-apps.md](https://github.com/xitu/gold-miner/blob/master/TODO1/connected-cars-what-are-they-and-how-to-get-started-developing-connected-car-apps.md)
> * 译者：
> * 校对者：

# Connected cars 🏎 — what are they and how to get started developing connected **car** apps

![](https://cdn-images-1.medium.com/max/2000/1*12wBTceui8136CzD6OiIvQ.png)

New generation cars are extremely handy — from turning the engine on with your phone, opening the car doors when you’re nearby, to actually giving you notifications when you’re too tired to drive safely.

What exactly are connected cars? Well, according to Wikipedia:

> A **connected car** is a [car](https://en.wikipedia.org/wiki/Car "Car") that is equipped with [Internet](https://en.wikipedia.org/wiki/Internet "Internet") access, and usually also with a [wireless local area network](https://en.wikipedia.org/wiki/Wireless_local_area_network "Wireless local area network").[[1]](https://en.wikipedia.org/wiki/Connected_car#cite_note-1)[[2]](https://en.wikipedia.org/wiki/Connected_car#cite_note-2) This allows the car to share internet access with other devices both inside as well as outside the vehicle

There’s hardly any doubt these days that the future of automotive is going to be connected and electric — illustrated by top tier car brands such as Tesla and Porsche with their offering of excellent connected electric cars like Tesla Model S and Porsche Mission E.

![](https://cdn-images-1.medium.com/max/800/1*rg5RTZz36b3uDlNFyO-ZLw.jpeg)

We’re quite literally living in the future — how cool is that?

![](https://cdn-images-1.medium.com/max/800/1*IKj1zBUxGRi8KJyZRDttQg.png)

The interior of Porsche ME.

![](https://cdn-images-1.medium.com/max/800/1*IcHcbtfttiloO0g79oxuDQ.jpeg)

Tesla S charging.

![](https://cdn-images-1.medium.com/max/800/1*b5UsurrQR5r0WfmQdzCJ8w.png)

Tesla S interior.

I don’t know much about cars, but saving lives, creating a more eco and geo friendly environment, and making traffic more safe is something we can all benefit from thanks to connected cars.

With connected cars we can finally browse our favorite subreddits on our phones without putting anyone at risk.

### Getting started developing connected apps

We will be using the [Porsche workspace](http://www.porsche-next-oi-competition.com/) since it’s the most advanced software development kit _(SDK)_ I know of — please feel free to comment below your favorite connected car software development kit. 🙂

* * *

![](https://cdn-images-1.medium.com/max/800/1*WGgGSvhOqtub4c9A5gL2Zg.jpeg)

Signing up for the Porsche workspace.

Why is it the most advanced? What makes the Porsche SDK so awesome is they’re going to standardize the API’s between all connected cars.

Right now each platform has unilateral API’s, meaning you have to learn each platform and API separately — not so much with the new standards!

After pressing register you should see a quick form, if you would like to follow our example, please fill it in.

![](https://cdn-images-1.medium.com/max/800/1*VDeaEEOZkcJNdc10iO2Wlw.png)

After successfully making a user and login in, this is what you should see

![](https://cdn-images-1.medium.com/max/800/1*nixNnTtGS0rpma2uFY3R0g.png)

Let’s create a project. What we need are the following:

*   A project (we will link the application to the project)
*   An application (a project can have multiple apps)
*   A vehicle (we link vehicles to applications)

In a nutshell, we create a project, the app and the vehicle. We link the app to the project, and then link the vehicle to the app. The logic is the following;

_Project_ **⟵** _App_ **⟵** _Vehicle_

![](https://cdn-images-1.medium.com/max/800/1*44xqjBlq7MV1PLTZNaVAEw.png)

Creating a Mario cart project.

After successfully creating the project, we should see our dashboard.

![](https://cdn-images-1.medium.com/max/800/1*rsmN2x0l8OIbG9CcAatMzQ.png)

Next, let’s create a vehicle.

![](https://cdn-images-1.medium.com/max/800/1*ubLnPZ9W1yiFhcUMeue8Aw.png)

![](https://cdn-images-1.medium.com/max/800/1*Vf1MotKtmqOgEf0p-8IGZA.gif)

I have to say, the UI looks very slick and intuitive. We now have the project, the vehicle, what’s left to do is create an app.

Let’s create an app for the project now.

![](https://cdn-images-1.medium.com/max/800/1*dS-UFNGRQcCj-GUgk-WAcg.png)

We can use the API to build an Android, iOS or web app. We will be sticking to the good old web.

![](https://cdn-images-1.medium.com/max/800/1*9_uRbNTWH__yTd8I3S_i7Q.gif)

Creating an application and linking it to the vehicle.

_Don’t forget to link the vehicle to the application._

Alrighty — let’s launch the emulator finally.

![](https://cdn-images-1.medium.com/max/800/1*oVCeK-HBPpmxicN2PC_EHQ.gif)

Web UI of the emulator.

That’s one fancy web emulator. We finally got through the scaffolding to the meat and bones. We can talk with the emulator through an API.

### Getting started with interacting with the emulator API

Let’s grab this [example repository](https://github.com/highmobility/hm-node-scaffold) as our boilerplate and open with our favorite text editor. Make sure you have Node +8.4 installed.

```
git clone git@github.com:highmobility/hm-node-scaffold.git && hm-node-scaffold && yarn install
```

Let’s open `src/app.js` — we should see a useful comment. We need to provide the credentials.

![](https://cdn-images-1.medium.com/max/800/1*PKp-FNVP041G28CufYLKvA.png)

We have done all of this. All we need is the credentials. It’s under develop → project → client certificate.

![](https://cdn-images-1.medium.com/max/800/1*wJzxuWTrg8dL6BQU7r6GLA.gif)

![](https://cdn-images-1.medium.com/max/400/1*lfirzUldQrZht-pjIaH_5Q.png)

Client certificate.

And finally we need the access token. Lots of scaffolding but keep in mind this is the _“alpha”_ phase. In the future you probably will just run a command like `yarn run unpack connectedcar-kit`

![](https://cdn-images-1.medium.com/max/800/1*tDU6p4cs2Cgg2m3rhdM1rw.gif)

Access token.

Alright, let’s turn on our engine by running `yarn run start`

![](https://cdn-images-1.medium.com/max/800/1*d7-z0M6os0CLUgro0BwZ4g.gif)

Turning the simulators engine on via the API.

There you go! What a great time to be alive! [Here are the docs in case you’re interested learning more](https://workspace.porsche-next-oi-competition.com/#/learn/tutorials/sdk/node-js/))

### Where to go from here?

If the topic peaked your interest, there are many roads to go from here but I’d recommend playing around and creating a couple of apps using the emulator. Here are some app ideas — who knows, you might even win some of the 100k prize for one of these in the competition!

*   App which displays the forbidden and paid parking spots. The forbidden spots should display red, and paid parking spots orange on the dashboard.
*   App helping to find the nearest charger.
*   App which gives driver quick access to Google Maps, messaging apps, music apps, and other utilities quickly.

Thanks for reading and making it to the end — you’re awesome! ❤


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
