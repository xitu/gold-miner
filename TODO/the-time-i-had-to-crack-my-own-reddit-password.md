> * 原文地址：[That time I had to crack my own Reddit password](https://medium.freecodecamp.com/the-time-i-had-to-crack-my-own-reddit-password-a6077c0a13b4)
> * 原文作者：本文已获原作者 [Haseeb Qureshi](https://medium.freecodecamp.com/@hosseeb) 授权
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：[cdpath](https://github.com/cdpath)
> * 校对者：[atuooo (oOatuo)](https://github.com/atuooo), [yzgyyang (Guangyuan (Charlie) Yang)](https://github.com/yzgyyang)

# 我是如何找回 Reddit 密码的

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/1000/1*ZAFlM8eSiuGVRo9P-8L6MQ.jpeg">

黑掉整个星球，伙计们！

我真是一点自制力都没有。

好在我对这一点颇有自知之明。我有意识地筹划生活，所以尽管我跟海洛因上瘾的小白鼠一样不成熟，偶尔还是可以搞定一些事情。

![](https://media.giphy.com/media/gOH54eiriYIwM/giphy.gif) 


嗯，简直是浪费时间！

我逛 Reddit 浪费了很多时间。如果我想拖延点事情的话，常常会开一个新标签页然后一头扎进 Reddit。但是有时我又得心无旁骛，减少干扰。比如 2015 年 —— 我专注于提升自己的编程水平，而在 Reddit 闲逛就成了负担。

我要搞个计划控制我自己。

于是我就想：让自己登陆不了账号咋样？

**我是这样做的：**

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*8Zpw3ipnu92ehqA_6T-o8w.gif">

我给账号重设了随机密码。叫朋友在某天把密码用 email 发给我。这样就可以万无一失地让自己上不了 Reddit 啦。（出于周全的考虑我还修改了找回密码用的邮箱）。

本应有效，不过......

不幸的是，事实上朋友根本扛不住社会工程学。换句话说，他们「对你太好了」，如果你「求」他们要密码，他们还是会发给你。

![](https://media.giphy.com/media/uB6rsQFg5yPzW/giphy.gif) 

不要这样子看我。

失败了几次后，我得找个更可靠的办法。谷歌搜索了一会儿，我发现了这个：

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*iMtDCzvNYVF9UOeiIbU7Ww.png">

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*7QCLp-4HnnDwgj1FSnRstw.png">

看上去不错。

完美！一个自动化且不需要朋友介入的方案！（我现在要疏远大部分朋友，所以这一点很重要。）

看上去并不完善，不过管他呢，有个办法就不错了。

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*TOUIDOIRHiVySUWt46n3mw.gif">

我这样坚持了一阵子：在工作日把密码 email 给自己，周末收到密码，在互联网垃圾信息中浪费时间，待下周开始就再锁掉账号。我印象中这一套效果不错。

终于有一天写代码实在太忙了，我完全忘了这一回事。

### 一转就是两年后

我现在在 Airbnb 工作，薪酬颇丰。而且 Airbnb 刚巧有个巨大的测试组件。也就是说等待时间颇多，而等待就意味着可以上网摸鱼。

我决定讨回旧账号并找回 Reddit 密码。

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*sAr_MYJtJVkNq6uHiVQxtQ.gif">

哦，不。这可不好。

我不记得我做过这一切，不过我当时肯定是太生自己的气了，都把自己锁到了 2018 年之后了。我还把邮件内容隐藏了，所以除非等到邮件发出去，我根本看不到内容。

我该怎么办？只能新建一个 Reddit 账号然后从头开始吗？但是这样好麻烦啊。

我完全可以给 LetterMeLater 发邮件解释自己并不是真的想这么做。但是他们回信可能要好一会儿呢。而且你们都知道了，我是个急性子。这个网站看上去也不像是有客服团队的样子。更不要提写这种邮件有多尴尬了。我开始头脑风暴精心编造理由甚至扯到了去世的亲人，试图解释为什么需要看自己的邮件。

所有的选择都不怎么靠谱。那天晚上，从公司走到家一路上我都在思考自己的尴尬处境，突然就有灵感了。

**搜索栏**

我用手机打开浏览器 App 开始尝试：

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*DvLUtm_ZGOaTGKy1bOuyYQ.gif">

嗯。

好吧。所以（邮件）标题肯定是有索引的。那（邮件）内容呢？

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*esw6gkV0G-M1JKaPAqipLA.gif">

试了几个字母，果然没错。内容也是有索引的。记住：邮件内容里面有我的密码。

**本质上这是一个执行子字符串检索的界面**。通过在搜索栏输入字符串，搜索结果会告诉我密码中是否有我输入的子字符串。

**万事俱备。**

我赶回自己的公寓，放下包，取出笔记本电脑。

算法问题：已知函数 `substring?(str)`，它会根据输入的密码是否包含任何已知的子字符串来返回 True 或 False。给定这个函数，写一个可以推导出隐含密码的算法。

### 算法

让我们好好想想。我记得我的密码有这些特征：随机字符组成的长字符串，就像这样子 `asgoihej2409g`。我很可能没有用任何大写字母（Reddit 并不要求密码中一定有大写字母），那么先假设我没用大写字母。如果我真用了大写字母，第一次尝试失败之后再将搜索范围扩大吧。

还有一个标题行，是检索的字符串的一部分。而且邮件标题就是 "password"。

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*XvaVCyWtSdqKSz59HKnNDw.png">

假设密码长度为 6，就有了 6 个空位来放字符，有些字符会出现在标题行，有些不会。所以可以取出所有没有出现在标题行的字符，逐一尝试进行搜索，肯定可以碰到一个独一无二的字母，恰好出现在密码中。就像是命运之轮游戏。

![](https://cdn-images-1.medium.com/max/800/1*LOzh--_Ujutrh_OKhjfNaw.png)

继续逐个字母进行尝试，直到命中没有出现在标题行的字符。这样就找到了。

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*fdoVAq3t5naQ5G9yARr0RA.png">

找到了第一个字母之后我仍然不知道它在字符串中的位置。不过我知道可以在它后面加一个不同的字符来构造一个更大的子字符串，直到再次命中。

有可能必需遍历字母表中每一个字符才能找到它。任何一个字母都可能是正确的，所以平均来说会命中中间位置的字母，如果字母表有 A 个字母，那么可以预计每个字母平均会落到 A/2 处（假设主题字母较少且没有超过两个字符的重复组合）。

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*GJ5xKZzTe0F5un-Iz11pXg.png">

继续构建子字符串，直到无法在末尾添加字符。

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*E9ri3Rf8LBPxUTjgs5BvPQ.png">

这还没完 — 不过接近了，我落下了字符串的前缀，因为我是随机选了个起点开始的。不过好办，只需要再重复一下之前的操作，方向反过来就好了。

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*F_n0WGRP_8RJdFtR-v0b1g.png">

搞定之后就可以着手重建密码了。总而言之，我需要搞定 `L` 个字符，每个字符平均需要猜测 `A/2` 次（`A` 是字母表长度），加起来需要猜测 `A/2 * L` 次。

准确地说，我还得再猜测 `2A` 次来确保字符串两端都到头了。所以总数是 `A/2 * L + 2A`，提取公因数就是 `A(L/2 + 2)`.

假设密码中有 20 个字符，字母表由 `a-z` 和 `0–9` 组成，总长度为 36。所以总迭代次数是 `36 * (20/2 + 2) = 36 * 12 = 432`。

可恶。

不过实际上是可行的。

![](https://media.giphy.com/media/119cVU19ICcAKc/giphy.gif) 

生活中的编程

### 实现

首先：我得写一个客户端，用代码控制搜索框执行检索。也就是我的子字符串「先知」。这个网站显然没有 API，我得直接爬网站。

搜索用的 URL 模式看来就是简单的检索字符串，`www.lettermelater.com/account.php?**qe=#{query_here}**`。简单吧。

开始写脚本吧。我会用 Faraday 这个 gem 完成网络请求，交互简单，我比较熟悉。

首先写一个 API 类。

```
require 'faraday'

class Api
  BASE_URL = 'http://www.lettermelater.com/account.php'

  def self.get(query)
    Faraday.get(BASE_URL, qe: query)
  end
end
```

当然，我可没指望这就能用了，毕竟还没有授权脚本登陆我的账号。可以看到响应返回了 302 重定向，还在 cookie 中提供了错误信息。

```
[10] pry(main)> Api.get(“foo”)
=> #<Faraday::Response:0x007fc01a5716d8
...
{“date”=>”Tue, 04 Apr 2017 15:35:07 GMT”,
“server”=>”Apache”,
“x-powered-by”=>”PHP/5.2.17",
“set-cookie”=>”msg_error=You+must+be+signed+in+to+see+this+page.”,
“location”=>”.?pg=account.php”,
“content-length”=>”0",
“connection”=>”close”,
“content-type”=>”text/html; charset=utf-8"},
status=302>
```

那怎么登陆呢？显然得在 header 中带上 [cookies](http://stackoverflow.com/questions/17769011/how-does-cookie-based-authentication-work)。有了 Chrome 的 inspector 这简直轻而易举。

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*PSxZtW4wppyzRXMdBWgGWw.gif">

（我当然不会把真的 cookie 贴在这儿。有意思的是看上去 cookie 在客户端保存了 user_id，这是个好信号。）

反复排除之后我发现需要 `code` 和 `user_id` 才能通过验证…… 哎。

所以我把这些加到脚本中。（这只是个用作示例的假 cookie）

```

require 'faraday'

class Api
  BASE_URL = 'http://www.lettermelater.com/account.php'
  COOKIE = 'code=13fa1fa011169ab29007fcad17b2ae; user_id=279789'

  def self.get(query)
    Faraday.get(BASE_URL, { qe: query }, Cookie: COOKIE).body
  end
end
```

```
[29] pry(main)> Api.get(“foo”)
=> “\n<!DOCTYPE HTML PUBLIC \”-//W3C//DTD HTML 4.01//EN\” \”[http://www.w3.org/TR/html4/strict.dtd\](http://www.w3.org/TR/html4/strict.dtd%5C) (.markup--anchor .markup--pre-anchor data-href=markup--anchor markup--pre-anchor rel=markup--anchor markup--pre-anchor target=markup--anchor markup--pre-anchor)">\n<html>\n<head>\n\t<meta http-equiv=\”content-type\” content=\”text/html; charset=UTF-8\” />\n\t<meta name=\”Description\” content=\”LetterMeLater.com allows you to send emails to anyone, with the ability to have them sent at any future date and time you choose.\” />\n\t<meta name=\”keywords\” content=\”schedule email, recurring, repeating, delayed, text messaging, delivery, later, future, reminder, date, time, capsule\” />\n\t<title>LetterMeLater.com — Account Information</title>…

[30] pry(main)> _.include?(“Haseeb”)
=> true
```

拿到我的名字了，显然登陆成功了！

爬数据搞定了，现在需要解析爬到的数据。幸运的是，这并不难 — 如果页面中出现了 e-mail 就意味着搜索命中了，所以只需要找到这种情况下才会出现的字符串就好了。“password“ 在其他搜索失败的情况下并不会出现，所以就是它了。

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*cZT37Ji9j8sm8dobFpiAWQ.png">

```
def self.include?(substring)
  get(substring).include?(‘password’)
end
```

API 类弄完了。现在完全可以用 Ruby 实现子字符串检索了。

```
[31] pry(main)> Api.include?('password')
=> true
[32] pry(main)> Api.include?('f')
=> false
[33] pry(main)> Api.include?('g')
=> true
```

这个搞定之后就要用 stub 替换掉真正的 API 来琢磨算法了。发送 HTTP 请求会非常慢，还有可能在试验的时候被限流。假设 stub API 是正确的，一旦搞定了剩下的算法部分，只要换成真正的 API 可以用了。

下面就是内置了随机密码的 stub API 了：

```
class ApiStub
  SECRET_PASSWORD = 'g420hpfjpefoj490rjgsd'

  def self.include?(substring)
    SECRET_PASSWORD.include?(substring)
  end
end
```

在测试时用 stub API 注入到类中。万事俱备后再用真实的 API 来检索真正的密码。

下面就开始用 Apistub 类吧。先在较高的层次回忆一下算法流程，主要分为三步：

1. 首先，找到第一个标题中没有，却在密码中出现的字母。拿它作起点。
2. 向前构建字符串，直到字符串尾。
3. 反向构建字符串，直到字符串头。

这样就搞定了！

先做准备工作。要注入 API，还要把当前的密码段置为空字符串。

```
class PasswordCracker
  def initialize(api)
    @api = api
    @password = ''
  end
end
```

接下来写三个方法，就按照刚才计划的做。

```
  def crack!
    find_starting_letter!
    build_forward!
    build_backward!
    @password
  end
```


完美。现在剩下的都可以在私有方法中执行。

为了找到第一个字母，需要遍历字母表中的每个字符，条件是没有出现在标题中。可以用 a-z 和 0-9 来构造字母表。用 Ruby 的范围运算符（`..`）可以轻松搞定：

```
ALPHABET = ((‘a’..’z’).to_a + (‘0’..’9').to_a).shuffle
```

我偏向于把字母表随机打乱这样可以避免密码中字母的分布造成的偏差。这种情况下算法找到每个字符平均需要检索 A/2 次，即使密码并不是随机分布的。

还可以把标题定义为一个常量。

```
SUBJECT = ‘password’
```

准备工作就是这些。下面该写 `find_starting_letter` 了。这需要遍历每个候选字母（按照字母表顺序，当然不能出现在标题中），直到第一个匹配。

```
  private

  def find_starting_letter!
    candidate_letters = ALPHABET - SUBJECT.chars
    @password = candidate_letters.find { |char| @api.include?(char) }
  end
```

在测试阶段看上去效果不错：

```
PasswordCracker.new(ApiStub).send(:find_starting_letter!) # => 'f'
```

下面是难点。

我会用递归来实现，因为结构更优雅。

```
def build_forward!
    puts "Current password: #{@password}"
    ALPHABET.each do |char|
      guess = @password + char

      if @api.include?(guess)
        @password = guess
        build_forward!
        # once I'm done building forward, jump out of all stack frames
        return
      end
    end
  end
```

上面的代码简洁明了。现在看看能不能和 stub API 工作。

```
[63] pry(main)> PasswordCracker.new(ApiStub).crack!
f
fj
fjp
fjpe
fjpef
fjpefo
fjpefoj
fjpefoj4
fjpefoj49
fjpefoj490
fjpefoj490r
fjpefoj490rj
fjpefoj490rjg
fjpefoj490rjgs
fjpefoj490rjgsd
=> “fjpefoj490rjgsd”
```

赞！有了后缀，现在需要反向构建字符串。代码应该看上去很相似。

```
def build_backward!
    puts "Current password: #{@password}"
    ALPHABET.each do |char|
      guess = char + @password

      if @api.include?(guess)
        @password = guess
        build_backward!
        return
      end
    end
```


实际上只有两行代码有异：如何构建 `guess`，以及递归调用的名字。可以重构一下。

```
def build!(forward:)
    puts "Current password: #{@password}"
    ALPHABET.each do |char|
      guess = forward ? @password + char : char + @password

      if @api.include?(guess)
        @password = guess
        build!(forward: forward)
        return
      end
    end
  end
```

现在另一个调用可以简化为：

```
  def build_forward!
    build!(forward: true)
  end

  def build_backward!
    build!(forward: false)
  end
```

来实战一下：


```
Apps-MacBook:password-recovery haseeb$ ruby letter_me_now.rb
Current password: 9
Current password: 90
Current password: 90r
Current password: 90rj
Current password: 90rjg
Current password: 90rjgs
Current password: 90rjgsd
Current password: 90rjgsd
Current password: 490rjgsd
Current password: j490rjgsd
Current password: oj490rjgsd
Current password: foj490rjgsd
Current password: efoj490rjgsd
Current password: pefoj490rjgsd
Current password: jpefoj490rjgsd
Current password: fjpefoj490rjgsd
Current password: pfjpefoj490rjgsd
Current password: hpfjpefoj490rjgsd
Current password: 0hpfjpefoj490rjgsd
Current password: 20hpfjpefoj490rjgsd
Current password: 420hpfjpefoj490rjgsd
Current password: g420hpfjpefoj490rjgsd
g420hpfjpefoj490rjgsd
```

漂亮。再加一些 print 语句和 log，`PasswordCracker` 就完成了。

```
require 'faraday'

class PasswordCracker
  ALPHABET = (('a'..'z').to_a + ('0'..'9').to_a).shuffle
  SUBJECT = 'password'

  def initialize(api)
    @api = api
    @password = ''
  end

  def crack!
    find_starting_letter!
    puts "Found first letter: #{@password}"
    puts "\nBuilding forward!\n"
    build_forward!
    puts "\nBuilding backward!\n"
    build_backward!
    puts "Done! The result is #{@password}."
    puts "We found it in #{@api.iterations} iterations"
    @password
  end

  private

  def find_starting_letter!
    candidate_letters = ALPHABET - SUBJECT.chars
    @password = candidate_letters.find { |char| @api.include?(char) }
  end

  def build_forward!
    build!(forward: true)
  end

  def build_backward!
    build!(forward: false)
  end

  def build!(forward:)
    puts "Current password: #{@password}"
    ALPHABET.each do |char|
      guess = forward ? @password + char : char + @password

      if @api.include?(guess)
        @password = guess
        build!(forward: forward)
        return
      end
    end
  end
end

class Api
  BASE_URL = 'http://www.lettermelater.com/account.php'
  COOKIE = 'code=13fa1fa011169ab29007fcad17b2ae; user_id=279789'
  @iterations = 0

  def self.get(query)
    @iterations += 1
    Faraday.get(BASE_URL, { qe: query }, Cookie: COOKIE).body
  end

  def self.include?(substring)
    get(substring).include?('password')
  end

  def self.iterations
    @iterations
  end
end

class ApiStub
  SECRET_PASSWORD = 'g420hpfjpefoj490rjgsd'
  @iterations = 0

  def self.include?(substring)
    @iterations += 1
    SECRET_PASSWORD.include?(substring)
  end
  
  def self.iterations
    @iterations
  end
end
```

接下来......就是见证奇迹的时刻。把 stub API 换成真实的 API，看看结果怎么样。

### 见证真相的时刻

上天保佑……

`PasswordCracker.new(Api).crack!`

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*NR-y9WthtHg4DVjLDwikVA.gif">

（三倍速）

Boom. 443 次迭代。

赶紧去 Reddit 试了一下，成功登录。

哇噢。

真的有效。

回忆一下原来那个计算迭代数的公式：`A(N/2 + 2)`。真正的密码长度为 22，所以公式预计需要 `36 * (22/2 + 2) = 36 * 13 = 468` 次迭代。实际上用了 443 次迭代，所以估计值和观测值的误差在 5% 以内。

**这就是数学。**

![](https://media.giphy.com/media/26xBI73gWquCBBCDe/giphy.gif) 

什么鬼 鬼什么 什鬼么

**真的有效**

不用给客服写尴尬的邮件了。重获 Reddit 休闲时光。事实证明：编程——的确是——魔法。

（不过我又得找个新办法让自己暂时无法登录了。）

有了编程之技，我又可以在互联网上挥霍时间了。感谢阅读，如果喜欢请点赞！

*—Haseeb*

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
