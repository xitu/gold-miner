> * 原文地址：[Designing the new Uber App](https://medium.com/uber-design/designing-the-new-uber-app-16afcc1d3c2e#.kaoghc61m)
* 原文作者：[Didier Hilhorst](https://medium.com/@didierh)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

# Designing the new Uber App








![](https://cdn-images-1.medium.com/max/2000/1*7ocitrf1HvNFK8Hbo3FoOw.png)







A big redesign is daunting. There are a lot of variables and unknowns that tell you there will be potential failure down the road. But we knew that if we wanted to build for the future, we had to be comfortable taking that risk. This meant not only taking a big bet on how things look, but also re-imagining how things flow.

Uber’s original premise was simple. “Push a button, get a ride.” You didn’t need to set your destination, you didn’t need to select a product, you just hit a button, or two, and you were off.

As we added more features and our products became more complex, we continued to strive to keep the original simplicity and speed of a single button. But we realized that speed was about much more than minimizing taps and streamlining flows. People were selecting the wrong product when they had to catch a movie (I’m looking at you, Uber Pool). Opportunities to save time by suggesting good pick-up spots were being missed.

In a fast growing environment it can become challenging to see the way ahead. So, to move past the comfort of our beginnings we decided to design the new Uber experience with a simple twist: _“Start at the end.”_

Sometimes in order to get more quickly from point A to point B, you need to slow down, look up, and see what’s ahead of you. Where Uber originally asked you to only think about getting a ride, we now ask you “Where to?”.

Everything starts there and builds around that. Interface elements fly in from the next step and route-lines animate toward your destination. It’s a philosophy based on looking ahead that carries you forward. Each action you take propels you to the next step and each trip you complete feeds back into the experience. By the time you’re ready to enter your next destination, it’s already there.







![](https://cdn-images-1.medium.com/max/2000/1*1xHu1vhKVvIx2SY-XdiF7A.jpeg)







A key area of the experience that was showing cracks was the product selection slider. A great interface when you have, say, three to four options… not so much when that number balloons to more than eight — as our riders in Los Angeles and other cities can attest. It got even worse: when we launched a scheduling option, we simply ran out of space and dropped it pretty much in the middle of the screen.

This feature went through the most design cycles and iterations. From list views to tabular representations to paginations and pretty much everything in between. Ongoing user research and iterative prototyping played a crucial role in our process. We interviewed people each day with prototypes we built in Framer and Swift. Day by day, week over week we iterated on these prototypes until we got to the right answer. We found that people didn’t care about how many products and features we could cram in a single screen.

By knowing your destination, we can now give you opportunities to make better decisions with just the right amount of context. We display up-front fares for products so you can make a clearer and simpler choice on how to get there. For Uber Pool and UberX we show you arrival times to let you know if you’ll make your dinner reservation.







![](https://cdn-images-1.medium.com/max/2000/1*U6PKgfBbne-QQZJIWSOvew.jpeg)







And as you’re looking forward, the app is constantly working on the next step to save you time. It’s searching for the fastest pickup point while you’re selecting a product. And once you hit request we instantly give you a peek into your future by showing you which drivers you could be paired up with, giving you an estimated time sooner.

From the start we wanted to be sure to create a platform that other people could use, build upon and extend internally. It takes a village to build something, and not one populated solely by designers; engineers, product managers, operations, marketing, and many other talented members of the team were involved. Building an entire new product and a design system at the same time was a challenge, especially at this scale.

In an ideal world you would probably choose to sequence product design and platform design a little more, but at the speed we were moving, that was simply not an option. This constraint, however, proved to be a happy accident: it forced us to apply platform design decisions in near real-time to product designs, with real data — and vice-versa. It reminds me of a quote by a legendary racing driver:

> _“If everything seems under control, you’re just not going fast enough.”—Mario Andretti._

We developed standards across a number of elements from foundational parts like grid and spacing, typography, colors, content, icons, illustrations, drop shadows, status bars, animations, and action sheets to components like alerts, avatars, buttons, cards, date and time pickers, empty states, forms, headers, lists, map interfaces, loading indicators and states, selectors, and tabs. But perhaps most importantly, we created a space to interact with our riders during the trip.







![](https://cdn-images-1.medium.com/max/2000/1*t_KgpnQ5C_CPhQxuXXCEtA.png)







We used to think our job was done once you got in a car, and that the faster we got you out of our app, the better the experience. But as we looked ahead at each step, we realized we were neglecting the longest part of the journey: being on your way.

We thought about the music you might want to listen to on your way, the menu at the restaurant you’re headed to, and how you could stay connected to the people you’re going to see. We built a platform for content that will put you and your journey at the center.







![](https://cdn-images-1.medium.com/max/2000/1*uX84vBZ06pGXvKnW0MZUPw.jpeg)







The new Uber app is about you, the things you want to do, and the places you want to be. We start at the end, to get you closer to your next beginning.

Special thanks to Peter Ng, Bryant Jow, Nick Kruge and the entire team at [Uber Design](https://medium.com/u/f0f8b53891a8). But beyond design, the most rewarding part is working with an amazing team of engineers and product managers, who brought this to life. Design isn’t just the designer’s responsibility, it’s all of us. We work in an environment where we jam with engineers and product managers from the start to get to a solution that is better for the people that use our products. If this sounds like fun, we’re hiring to design many more things — we need your help. [Reach out](https://www.linkedin.com/in/dhilhorst), let’s grab a coffee, and come join us.

The new update is still gradually rolling out to stores around the world, with more features slated to ship by the end of the year. We hope you are as excited as we are. And if you’ve come this far, here’s a short video of the new app in action:





