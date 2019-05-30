> * 原文地址：[In Defense of the Ternary Statement](https://css-tricks.com/in-defense-of-the-ternary-statement/)
> * 原文作者：[Burke Holland](https://css-tricks.com/author/burkeholland/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/in-defense-of-the-ternary-statement.md](https://github.com/xitu/gold-miner/blob/master/TODO1/in-defense-of-the-ternary-statement.md)
> * 译者：
> * 校对者：

# In Defense of the Ternary Statement

Some months ago I was on Hacker News (as one does) and I ran across a (now deleted) article about not using `if` statements. If you’re new to this idea (like I was), you’re in a for a real treat. Just search for "if statements" on Hacker News. You'll get articles proposing that [you might not need them](https://hackernoon.com/you-might-not-need-if-statements-a-better-approach-to-branching-logic-59b4f877697f#.ruqzpakyw), articles that refer to them as a [code smell](https://blog.jetbrains.com/idea/2017/09/code-smells-if-statements/) and even the quintessential ["considered harmful](https://blog.deprogramandis.co.uk/2013/03/20/if-statements-considered-harmful-or-gotos-evil-twin-or-how-to-achieve-coding-happiness-using-null-objects/)." Listen, you know a programming concept is legit when people start suggesting that using it is actually gonna hurt somebody.

![](https://css-tricks.com/wp-content/uploads/2019/03/s_FD4D827367230AB6A2D0F680A6D86BB8C31A84DDD157823CB9061772EC8F0BFC_1552145481604_an-if-statement.jpg)

And if that's not enough for you, there is always the "[Anti-If Campaign](https://francescocirillo.com/pages/anti-if-campaign#campaign)." If you join, you get a nifty banner and your name on the website. IF you join. Oh the sweet, sweet irony.

The first time that I ran across this bizarre "if anathema" phenomenon, I thought it was interesting, but probably just more people mad on the internet. You are always one Google search away from finding someone who is mad about anything. Like [this person who hates kittens](http://www.cracked.com/article_19007_6-reasons-kittens-suck-learned-while-raising-them.html). KITTENS.

Some time later, I was watching [Linus Torvald's TED interview](https://www.ted.com/talks/linus_torvalds_the_mind_behind_linux#t-858390). In that interview, he shows two slides. The first slide contains code that he deems is "bad taste."

![](https://css-tricks.com/wp-content/uploads/2019/03/s_FD4D827367230AB6A2D0F680A6D86BB8C31A84DDD157823CB9061772EC8F0BFC_1552145588491_linus-bad-taste.png)

And the second is that same code, but in what Linus would consider, "good taste."

![](https://css-tricks.com/wp-content/uploads/2019/03/s_FD4D827367230AB6A2D0F680A6D86BB8C31A84DDD157823CB9061772EC8F0BFC_1552145608899_linus-good-taste.png)

I realize that Linus is a bit of a polarizing figure, and you might not agree with the "good taste" vs. "bad taste" phrasing. But I think we can universally agree that the second slide is just easier on the old eye balls. It's concise, has fewer logical paths to follow, and contains no `if` statement. I want my code to look like that. It doesn't have to be some genius algorithm (it never will be), but I think it can be clean, and remember what Billy Corgan of Smashing Pumpkins said about cleanliness...

> Cleanliness is godliness. And god is empty. Just like me.
> 
> \- Billy Corgan, "Zero"

So dark! But what an [amazing album](https://en.wikipedia.org/wiki/Mellon_Collie_and_the_Infinite_Sadness).

Aside from making your code look cluttered, `if` statements, or "branching logic," requires your brain to hold and evaluate two separate paths at one time along with all of the things that might occur on those paths. If you nest `if` statements, the problem intensifies because you are creating and tracking a decision tree and your brain has to bounce around all over that tree like a drunk monkey. This kind of thing is what makes code hard to read. And remember, you should write your code thinking of the moron who comes after you that is going to have to maintain it. And that moron is probably you.

As my own favorite moron, I've been making a conscious effort lately to avoid writing `if` statements in my JavaScript. I don't always succeed, but what I've noticed is that at the very least, it forces me to think about solving the problem from an entirely different angle. It makes me a better developer because it compels me to engage a part of my brain that is otherwise sitting on a beanbag eating peanut M&M's while the `if` statement does all the work.

In the process of **not** writing `if` statements, I’ve discovered my love for the way JavaScript lets you compose conditional logic with ternary statements and logical operators. What I would like to propose to you now is that ternary has gotten a bad rap, and you can use it along with the `&&` and `||` operators to write some pretty concise and readable code.

### The much maligned ternary

When I first started as a programmer, people used to say, "Never use a ternary. They are too complex." So I didn’t use them. Ever. I never used a ternary. I never even bothered to question whether or not those people were right.

I don't think they were.

Ternaries are just one-line `if` statements. Suggesting that they are implicitly too complicated in any form is just... not true. I mean, I'm not the frostiest donut in the box, but I have no problems at all understanding a simple ternary. Is it possible that we are infantilizing ourselves here just a tad when we say to **always** avoid them. I think that a well-structured ternary beats an `if` statement every time.

Let’s take a simple example. Say we have an application where we want to test and see if the user is logged in. If they are, we send them to their profile page. Otherwise, we send them to the home page. Here is the standard `if` statement to do that...

```javascript
if (isLogggedIn) {
  navigateTo('profile');
}
else {
  navigateTo('unauthorized');
}
```

That's a damn simple operation to split out over six lines. SIX LINES. Remember that every time you move through a line of code, you have to remember the code that came above it and how it affects the code below it.

Now the ternary version...

```javascript
isLoggedIn ? navigateTo('profile') : navigateTo('unauthorized');
```

Your brain only has to evaluate one line here, not six. You don’t have to move between lines, remembering what was on the line before.

One of the drawbacks to the ternary, though, is that you cannot evaluate for only one condition. Working from the previous example, if you wanted to navigate to the profile page if the user was logged in, but take no action at all if they weren't, this won't work...

```javascript
// !! Doesn't Compile !!
logggedIn ? navigateTo('profile')
```

You would have to write out an actual `if` statement here. Or would you?

There is a trick that you can use in JavaScript when you only want to evaluate one side of the condition and you don't want to use an `if` statement. You do this by leveraging the way JavaScript works with the `||` (or) and `&&` (and) operators.

```javascript
loggedIn && navigateTo('profile');
```

How does that work!?

What we're doing here is asking JavaScript, "Are both of these things true?" If the first item is false, there is no reason for the JavaScript virtual machine to execute the second. We already know that both of them aren't true because one of them is false. We're exploiting the fact that JavaScript won't bother to evaluate the second item if the first one is false. This is the equivalent of saying, "If the first condition is true, execute the second."

Now what if we wanted to flip this around? What if we wanted to navigate to the profile page only if the user is **not** logged in? You could just slap a `!` in front of the `loggedIn` variable, but there is another way.

```javascript
loggedIn || navigateTo('profile');
```

What this says is, "Are either of these things true?" If the first one is false, it **has** to evaluate the second to know for sure. If the first one is true though, it will never execute the second because it already knows that one of them is true; therefore the whole statement is true.

Now, is that better than just doing this?

```javascript
if (!loggedIn) navigateTo('profile');
```

No. In that form, it is not. But here’s the thing: once you know that you can use the `&&` and `||` operators to evaluate equality outside of `if` statements, you can use them to vastly simplify your code.

Here is a more complex example. Say we have a login function where we pass a user object. That object may be null, so we need to check local storage to see if the user has a saved session there. If they do, and they are an admin user, then we direct them to a dashboard. Otherwise, we send them to a page that tells them they are unauthorized. Here is what that looks like as a straight-up `if` statement.

```javascript
function login(user) {
  if (!user) {
    user = getFromLocalStorage('user');
  }
  if (user) {
    if (user.loggedIn && user.isAdmin) {
      navigateTo('dashboard');
    }
    else {
      navigateTo('unauthorized');
    }
  }
  else {
    navigateTo('unauthorized');
  }
}
```

Ouch. This is complicated because we're doing a lot of null condition checking on the `user` object. I don't want this post to be too strawman-y, so let's simplify this down since there is a lot of redundant code here that we would likely refactor into other functions.

```javascript
function checkUser(user) {
  if (!user) {
    user = getFromLocalStorage('user');
  }
  return user;
}

function checkAdmin(user) {
  if (user.isLoggedIn && user.isAdmin) {
    navigateTo('dashboard');
  }
  else {
    navigateTo('unauthorized');
  }
}

function login(user) {
  if (checkUser(user)) {
    checkAdmin(user);
  }
  else {
    navigateTo('unauthorized');
  }
}
```

The main login function is simpler, but that's actually more code and not necessarily “cleaner” when you consider the whole and not just the `login` function.

I would like to propose that we can do all of this in two lines if we forgo the `if` statements, embrace the ternary, and use logical operators to determine equality.

```javascript
function login(user) {
  user = user || getFromLocalStorage('user');
  user && (user.loggedIn && user.isAdmin) ? navigateTo('dashboard') : navigateTo('unauthorized')
}
```

That's it. All of that noise generated by `if` statements collapses down into two lines. If the second line feels a bit long and unreadable to you, wrap it so that the conditions are on their own line.

```javascript
function login(user) {
  user = user || getFromLocalStorage("user");
  user && (user.loggedIn && user.isAdmin)
    ? navigateTo("dashboard")
    : navigateTo("unauthorized");
}
```

If you are worried that maybe the next person won't know about how the `&&` and `||` operators work in JavaScript, add some comments, a little white space and a happy tree. Unleash your inner Bob Ross.

```javascript
function login(user) {
  // if the user is null, check local storage to
  // see if there is a saved user object there
  user = user || getFromLocalStorage("user");
  
  // Make sure the user is not null, and is also
  // both logged in and an admin. Otherwise, DENIED. &#x1f332;
  user && (user.loggedIn && user.isAdmin)
    ? navigateTo("dashboard")
    : navigateTo("unauthorized");
}
```

### Other things you can do

While we’re at it, here are some other tricks you can play with JavaScript conditionals.

#### Assignment

One of my favorite tricks (which I used above), is a one-liner to check if an item is null and then reassign it if it is. You do this with an `||` operator.

```javascript
user = user || getFromLocalStorage('user');
```

And you can go on forever like this...

```javascript
user = user || getFromLocalStorage('user') || await getFromDatabase('user') || new User();
```

This also works with the ternary...

```javascript
user = user ? getFromLocalStorage('user') : new User();
```

#### Multiple conditions

You can provide multiple conditions to a ternary. For instance, if we want to log that the user has logged in and then navigate, we can do that without needing to abstract all of that into another function. Wrap it in some parentheses and provide a comma.

```javascript
isLoggedIn ? (log('Logged In'), navigateTo('dashboard')) : navigateTo('unauthorized');
```

This also works with your `&&` and `||` operators...

```javascript
isLoggedIn && (log('Logged In'), navigateTo('dashboard'));
```

#### Nesting ternary expressions

You can nest your ternary expressions. In his [excellent article on the ternary](https://medium.com/javascript-scene/nested-ternaries-are-great-361bddd0f340), Eric Elliot demonstrates that with the following example...

```javascript
const withTernary = ({
  conditionA, conditionB
}) => (
  (!conditionA)
    ? valueC
    : (conditionB)
    ? valueA
    : valueB
);
```

The most interesting thing Eric is doing there is negating the first condition so that you don’t end up with the question marks and colons together, which makes it harder to read. I would take this a step further and add a little indentation. I also added the curly braces and an explicit return because seeing one parenthesis and then immediately another makes my brain start to anticipate a function invocation that is never coming.

```javascript
const withTernary = ({ conditionA, conditionB }) => {
  return (
    (!conditionA)
      ? valueC  
      : (conditionB)
        ? valueA
        : valueB
  )
}
```

As a general rule, I think that you should consider not nesting ternaries or `if` statements. Any of the above articles on Hacker News will shame you into the same conclusion. Although I’m not here to shame you, only to suggest that perhaps (and just maybe) you will thank yourself later if you don’t.

---

That’s my pitch on the misunderstood ternary and logical operators. I think that they help you write clean, readable code and avoid `if` statements entirely. Now if only we could get Linus Torvalds to sign off on all this as being “good taste.” I could retire early and and live the rest of my life in peace.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
