> * 原文地址：[In Defense of the Ternary Statement](https://css-tricks.com/in-defense-of-the-ternary-statement/)
> * 原文作者：[Burke Holland](https://css-tricks.com/author/burkeholland/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/in-defense-of-the-ternary-statement.md](https://github.com/xitu/gold-miner/blob/master/TODO1/in-defense-of-the-ternary-statement.md)
> * 译者：[ZavierTang](https://github.com/ZavierTang)
> * 校对者：[smilemuffie](https://github.com/smilemuffie), [mnikn](https://github.com/mnikn)

# 支持 JavaScript 三元运算符

几个月前，我在 Hacker News 上浏览到一篇（现已删除）关于不要使用 `if` 语句的文章。如果你像我一样对这个观点还不太了解，那值得你去看一下。只要在 Hacker News 上搜索 “if 语句”，你就会看到一篇文章说：“[你可能不需要 `if` 语句](https://hackernoon.com/you-might-not-need-if-statements-a-better-approach-to-branching-logic-59b4f877697f#.ruqzpakyw)”，或者是称 `if` 语句为 “[可疑代码](https://blog.jetbrains.com/idea/2017/09/code-smells-if-statements/)”，甚至是 “[有害代码](https://blog.deprogramandis.co.uk/2013/03/20/if-statements-considered-harmful-or-gotos-evil-twin-or-how-to-achieve-coding-happiness-using-null-objects/)” 的文章。听着，你应该知道不同的编程思想都是值得尊重的，尽管他们宣称使用 `if` 会伤害到别人。

![](https://css-tricks.com/wp-content/uploads/2019/03/s_FD4D827367230AB6A2D0F680A6D86BB8C31A84DDD157823CB9061772EC8F0BFC_1552145481604_an-if-statement.jpg)

如果这对你来说还不够，还有 “[反 `if` 运动](https://francescocirillo.com/pages/anti-if-campaign#campaign)”。如果你加入，你会在网站上看到一个漂亮的横幅，而且你的名字也会在上面。对！如果你加入的话，那会是多么的有意思。

当我第一次遇到这种奇怪的 “反对 `if`” 现象时，我觉得很有趣，但可能只不过是一些人在网上发疯了。你只需要谷歌一下，就能找到对任何事都疯狂的人。比如[这个讨厌小猫的人](https://www.cracked.com/article_19007_6-reasons-kittens-suck-learned-while-raising-them.html)。KITTENS

一段时间后，我看了 [Linus Torvald 的 TED 演讲](https://www.ted.com/talks/linus_torvalds_the_mind_behind_linux#t-858390)。在那次演讲中，他展示了两张幻灯片。第一张幻灯片贴出了他认为是 “bad taste” 的代码。

![](https://css-tricks.com/wp-content/uploads/2019/03/s_FD4D827367230AB6A2D0F680A6D86BB8C31A84DDD157823CB9061772EC8F0BFC_1552145588491_linus-bad-taste.png)

第二个是相同功能的代码，但是在 Linus 看来是 “good taste”。

![](https://css-tricks.com/wp-content/uploads/2019/03/s_FD4D827367230AB6A2D0F680A6D86BB8C31A84DDD157823CB9061772EC8F0BFC_1552145608899_linus-good-taste.png)

我意识到 Linus 是一个有点两极化的人物，你可能不同意 “good taste” 与 “bad taste” 的描述。但我认为，一般来说，第二张幻灯片对新手来说更容易理解。它简洁、逻辑分支少且不包含 `if` 语句。我希望我的代码应该是这样的。它不一定是什么高级的算法（永远不会），但我希望它是逻辑简洁的，还记得 Smashing Pumpkins 乐队的 Billy Corgan 是如何描述的：

> Cleanliness is godliness. And god is empty. Just like me.
> 
> - Billy Corgan, "Zero"

太可怕了！但[这张专辑](https://en.wikipedia.org/wiki/Mellon_Collie_and_the_Infinite_Sadness)的确很棒。

除了让代码看起来杂乱之外，`if` 语句或 “分支逻辑” 还要求你的大脑同时去计算两条独立的逻辑路径，以及这些路径上可能发生的所有事情。如果你还嵌套使用了 `if` 语句，问题就会变得更加复杂，因为你在生成和计算一个决策树时，你的大脑必须像喝醉酒的猴子一样在决策树上跳来跳去。这样会大大降低代码的可读性。记住，在编写代码时，你应该考虑在你之后要去维护它的会是哪个傻瓜。也许，就是你自己。

作为必须要去维护自己代码的傻瓜，我最近一直有意识地避免在 JavaScript 中编写 `if` 语句。我并不总是能够成功，但我注意到，至少它迫使我从一个完全不同的角度来思考解决问题的方法。它使我成为一个更好的开发人员，因为它让我动脑子思考，否则我将会悠闲地坐在豆袋上吃花生，而让 `if` 语句去完成所有的工作。

在避免**编写** `if` 语句的过程中，我发现我喜欢 JavaScript 中的三元运算符和逻辑操作符组合使用的方式。我现在想建议你的是不太受欢迎的三元运算符，你可以使用它与 `&&` 和 `||` 操作符一起编写一些非常简洁和具有可读性的代码。

### 不受欢迎的三元运算符

当我刚开始学习编程时，人们常说，“永远不要使用三元运算符”，它们太复杂了。所以我没有使用它。一直都没有。我从来没用过三元运算符也从未费心去质疑那些人的说法是否正确。

但现在，我不这么认为。

三元运算符只是去用一行代码来表示的 `if` 语句而已。绝对的说它们在任何情况下都太过复杂是不正确的。我的意思是，并不是我要特立独行，但我可以完全理解一个简单的三元运算符。当我们说要**永远**去避免使用它们的时候，我们是不是有点儿孩子气了呢？我认为一个结构良好的三元运算符是可以胜过一个 `if` 语句的。

让我们举一个简单的例子。假设我们有一个应用程序，我们想在其中检查用户的登录状态。如果已登录，我们就跳转到他们的个人主页。否则，我们将跳转到登录页面。下面是标准的 `if` 逻辑语句：

```javascript
if (isLogggedIn) {
  navigateTo('profile');
}
else {
  navigateTo('unauthorized');
}
```

用这 6 行代码来完成工作是非常简单的。**6 行**，请记住，你每运行 1 行代码，必须记住上面代码的运算结果以及它如何影响下面的代码。

下面是三元运算符的实现代码：

```javascript
isLoggedIn ? navigateTo('profile') : navigateTo('unauthorized');
```

你的大脑只需要计算这一行，而不是 6 行。你不需要在代码上下行之间移动，也不需要记住之前的内容。

不过，三元运算符的一个缺点是不能只针对一种情况进行逻辑判断。还是刚刚的例子，如果你想在用户已登录时跳转到他的个人主页，而如果没有登录，则不采取任何操作，下面的代码将不起作用：

```javascript
// !! 无法编译 !!
logggedIn ? navigateTo('profile')
```

你不得不在这里使用 `if` 语句来完成工作。但是还有没有其他方法？

当你只想处理逻辑条件的一个分支但又不想使用 `if` 语句时，可以在 JavaScript 中使用这样一个技巧。你可以利用 JavaScript 中的 `||`（或）和 `&&`（与）运算符一起工作的方式来实现这一点。

```javascript
loggedIn && navigateTo('profile');
```

这是如何实现的？

我们在这里实际是在判断：”这两个语句都是 `true` 吗？” 如果第一项为 `false`，JavaScript 引擎就不会再去执行第二项了。因为其中一个已经是 `false` 了，所以我们知道结果不是 `true`。我们利用了这个机制：如果第一项为 `false`，JavaScript 就不会去执行第二项。也就是说，“如果第一项为 `true`，那么就去执行第二项”。

如果我想换过来呢？我们只想在用户**没有**登录的情况下导航到用户主页，该怎么办呢？你可以直接在 `loggedIn` 变量前面使用 `!`，但也有另一种方法。

```javascript
loggedIn || navigateTo('profile');
```

这句代码的意思是，“这两个语句会有一个是 `true` 吗？” 如果第一项是 `false`，就**必须**对第二项进行计算才能确定。如果第一项为 `true`，就永远不会去执行第二项，因为已经知道其中一项为 `true` 了，因此整个语句的结果是 `true`。

那下面这种方式如何呢？

```javascript
if (!loggedIn) navigateTo('profile');
```

不，在这种情况下，不推荐使用。所以，一旦知道可以使用 `&&` 和 `||` 运算符来实现 `if` 语句的功能，就可以使用它们来极大地简化我们的代码。

下面是一个更复杂的例子。假设我们有一个 `login` 函数，接收一个 `user` 对象作为参数。该对象可能为空，因此我们需要检查 local storage，以查看用户是否在本地保存了会话。如果保存了，并且他是一个管理员用户，那么我们将跳转到首页。否则，我们将导航到另一个页面，该页面提示用户还未经授权。下面是一个简单的 `if` 语句的实现。

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

噢。这也许很复杂，因为我们对 `user` 对象做了很多是否为空的条件判断。我不希望我的代码太过复杂，所以让我们简化一下，因为这里有很多冗余的代码，我们需要封装一些函数。

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

`login` 函数更简单了，但实际上代码更多了，当你考虑到整个代码而不仅仅是 `login` 函数时，它并不一定是更简洁的。

我建议放弃使用 `if` 语句，而使用三元运算符，并且使用逻辑运算符，那么我们可以在两行代码中完成所有这些操作。

```javascript
function login(user) {
  user = user || getFromLocalStorage('user');
  user && (user.loggedIn && user.isAdmin) ? navigateTo('dashboard') : navigateTo('unauthorized')
}
```
就是这样。所有烦人的 `if` 语句代码块折叠后都有两行。如果第二行代码看起来有点长，并且影响阅读，那么可以对其进行换行，使它们各自独处一行。

```javascript
function login(user) {
  user = user || getFromLocalStorage("user");
  user && (user.loggedIn && user.isAdmin)
    ? navigateTo("dashboard")
    : navigateTo("unauthorized");
}
```

如果你担心别人可能不知道 `&&` 和 `||` 运算符在 JavaScript 中是如何工作的，请添加一些注释并格式化你的代码。

```javascript
function login(user) {
  // 如果 user 为空，则检查 local storage
  // 查看是否保存了 user 对象
  user = user || getFromLocalStorage("user");
  
  // 确保 user 不为空，同时
  // 是登录状态并且是管理员。否则，拒绝访问。
  user && (user.loggedIn && user.isAdmin)
    ? navigateTo("dashboard")
    : navigateTo("unauthorized");
}
```

### 其他

也许，你还可以使用一些其他技巧来处理 JavaScript 条件判断。

#### 赋值

我最喜欢的技巧之一（在上面使用过）是一个单行代码来判断一个变量是否为空，然后如果为空就重新赋值。使用 `||` 运算符来完成。

```javascript
user = user || getFromLocalStorage('user');
```

你可以一直判断下去：

```javascript
user = user || getFromLocalStorage('user') || await getFromDatabase('user') || new User();
```

这也适用于三元运算符：

```javascript
user = user ? getFromLocalStorage('user') : new User();
```

#### 组合条件

你可以为三元运算符提供多个执行语句。例如，如果我们想要同时记录用户已经登录的日志，然后跳转页面，就可以这样做，而不需要将所有这些操作封装到另一个函数中。如下，使用括号括起来，并用逗号隔开。

```javascript
isLoggedIn ? (log('Logged In'), navigateTo('dashboard')) : navigateTo('unauthorized');
```

这也适用于 `&&` 和 `||` 操作符：

```javascript
isLoggedIn && (log('Logged In'), navigateTo('dashboard'));
```

#### 嵌套三元运算符

你可以嵌套使用三元运算符。Eric Elliot 在[关于三元运算符的文章](https://medium.com/javascript-scene/nested-ternaries-are-great-361bddd0f340)中通过下面的例子说明了这一点：

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

Eric 在这里做的最有趣的一点是否定了第一个条件，这样你就不会把问号和冒号放在一起，不然就会难以阅读。我要更进一步，给代码添加一些缩进。同时我还添加了大括号和显式的返回语句，因为只有括号的话会让我以为正在调用一个函数，实际上并没有。

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

一般来说，你不应该嵌套使用三元运算符或 `if` 语句。以上任何一篇 Hacker News 的文章都会让你羞愧地得出同样的结论。虽然我不是来羞辱你的，但我只想说，如果你不再过度使用 `if` 语句，或许（只是或许）你以后会感谢你自己的。

---

这就是我对被误解的三元运算符和逻辑运算符的看法。我认为它们可以帮助你编写简洁、可读的代码，并完全避免 `if` 语句。现在，我们可以像 Linus Torvalds 一样用 “good taste” 来结束这一切了。我也可以早点退休，然后平静地度过余生。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
