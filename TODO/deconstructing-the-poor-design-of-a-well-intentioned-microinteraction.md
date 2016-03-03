>* 原文链接 : [Deconstructing the Poor Design of a Well-Intentioned Microinteraction](https://medium.com/ux-immersion-interactions/deconstructing-the-poor-design-of-a-well-intentioned-microinteraction-e667e022e628#.u41e59zgi)
* 原文作者 : [Jared M. Spool](https://medium.com/@jmspool)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者: 
* 状态： 认领中

The American Airlines customer stared at the message on the screen: _Your session expired._ It wasn’t there before, but now it’s there. And she didn’t know what to do about it.

A few moments earlier, after she thought she’d bought her plane tickets, she opened up another tab to book her hotel rooms for the trip. Then she rented a car. She came back to the American Airlines tab to get her confirmation number, to put that on her calendar.

Instead of the number, she found the expiration message. _Any confirmed transactions are saved, but you’ll need to restart any searches or unfinished transactions._ Was the transaction finished? She was pretty sure she’d bought tickets, but were these confirmed? She didn’t know what she was supposed to do next.

#### A Canonical Security Design Pattern

The designers at American Airlines have lots of reasons to want a session to time out. A customer who isn’t sure about a flight (or shopping around at competitors), might leave a half booked flight open, never intending to finish it. American’s designers want to return the fights to the open inventory, so another customer could book those seats.

Similarly, if someone else sits down at the machine after the customer is done, but hasn’t closed the browser, they might have access to details and capabilities the customer didn’t intend to share. Having the session expire will prevent a future messy situation.

Session time outs aren’t unique to American Airlines. Banking sites, business tools, and other applications will log someone off if they take too long to complete the transaction or leave the application without activity for a long period.

Often, the session timeout invokes a _Your session expired_ design pattern. This message pops up after some arbitrarily chosen time period. For most users, this revelation is rarely good news. Either an important function has been interrupted, or it’s just noise that’s confusing.

#### A Poor Microinteraction that’s Well Intentioned.

The _Your session expired_ design pattern is a microinteraction, an interaction in the design that’s small and functional. Microinteractions make up much of any design and suffer from lack of attention from the design team. This design pattern is no exception.

![](https://cdn-images-1.medium.com/max/600/1*h11V6a7RWk1PxpVMzp1z9A.jpeg)]

American’s designers want to protect their customers from evildoers or seat hoarders. A noble goal.

However, it seems they haven’t paid attention to the experience they’ve created by suddenly timing out the users’ session. When confronted with the message (which, is a form of error message), the user has few options on how to continue.

Session timeouts don’t happen frequently in the real world. When shopping in a grocery store, your cart doesn’t suddenly empty if you’ve stopped filling it for a long period. You don’t automatically get locked out of your house when you go for a long walk around the block. Your TV doesn’t put up a message every 15 minutes demanding you prove you are still in the room.

Session timeouts are commonplace, an artifact of how poorly our digital world integrates with our real world. If our laptops could accurately tell that someone else has sat in front of it, we could better protect our users from evildoers.

It’s a good intention. We’re protecting the needs of the business.

Design is what we do when we render our intentions in the world. The American Airlines session timeout frustrates its users, something which is likely not the intention of American Airlines’ site designers. How could they have improved that?

#### Improving Design with the Microinteractions Framework

For the last few years, Dan Saffer studied the design of microinteractions and wrote a book on the topic called (get this) _Microinteractions._ Dan breaks down microinteractions into four components: _feedback, modes and loops, triggers,_ and _rules._ We can use these four components to look at where we could improve American Airlines’ session expired microinteraction:

**Feedback** is how the user learns of the microinteraction. In this case, it’s a dialogue box informing the user their session has expired, but doesn’t tell them what that means. It does explain that “confirmed transactions are saved” without explaining what a confirmed transaction is or what it means to be saved. Is a booked flight a confirmed transaction?

Would it help users to use terminology they’re familiar with? (A message such as “_Your flight to Peoria has been ticketed and a confirmation has been sent to your email”_ would deliver more confidence that they didn’t lose their booking.)

The label on the only button says Back to Home. Is going back to the home page the likely next action the user would take? What are the likely next actions? Could the dialogue box give the user a list of things to do next (and then ask them to re-authenticate, just to ensure it’s really the same user)?

**Modes** are how the system decides what the user has access to. On the American Airlines site, they seem to use a binary authentication — either the user has access or they don’t. When the session expires, the system changes from the authenticated state to the not-authenticated state.

Depending on the likely next actions, would it make sense for the designers to think about more than two authentication modes?

**Triggers** determine when the design will invoke the microinteraction. It seems American Airlines triggers the session expiration microinteraction after 15 or so minutes have elapsed since the last page load.

Is page load the correct starting point for the clock? If the user is active at the keyboard or changing focus with the mouse, should that restart the countdown?

Why is it 15 minutes? Why not 20? Or 40? Where did 15 minutes come from and what research shows that’s the best amount of time?

Should it be the same time for inactivity after a flight is successfully booked than before the booking? After all, an un-booked flight might be holding high demand inventory, but that inventory is no longer available after it’s been booked.

Should the trigger be time based at all? Is there a better way to determine if the user has become disinterested or left the machine, creating a security threat?

What if the trigger was next action based? If the screen is left untouched, the microinteraction doesn’t fire. But if the user tries to do something after the expiration time, what if the microinteraction informs them that they need to re-authenticate or checks the inventory to see if the seats are still available?

**Rules** direct the microinteraction’s behavior. The rule for session expiration says to give the user feedback and change their mode from authenticated to not-authenticated, to prevent further access.

Do we need to tell the user their session has expired? After all, there’s not much they can do with that information. Instead, what if the design remained silent, then if the user tries to do anything that requires authenticated access, we trigger a microinteraction to log in?

#### Intentionally Designing the Microinteraction Experience

Must the needs of the business, like security enforcement and inventory management, always come at the expense of a great user experience? Session expiration solves a problem, but is the design the best it could be?

Many microinteractions, like error messages and alerts, are unintentionally designed. Often, a developer rushing to meet a deadline, creates a solution to deal with a discovered edge condition, without giving any consideration to the experience users encounter.

Teams that pay attention to these little details and ask questions will create a better experience. Dan’s framework for microinteractions help us hone in on the right questions, which, in turn, gets us to that better design.

Knowing that microinteractions are critical to building great experiences, we asked Dan Saffer to lead a one-day workshop on [_Designing the Critical Details using Microinteractions_.](https://uxi16.uie.com/workshops/designing-the-critical-details-using-microinteractions?src=workshop-desc) It’s part of the UX Immersion Conference, April 18–20 in San Diego, CA. Dan’s workshop is filled with solid data, incredible wisdom, and actionable techniques for designing rich, effective microinteractions. Don’t miss it. Details at [uxi16.com](https://uxi16.uie.com/#designing-the-critical-details-using-microinteractions).

