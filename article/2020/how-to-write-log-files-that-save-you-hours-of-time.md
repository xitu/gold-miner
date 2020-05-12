> * 原文地址：[How to Write Log Files That Save You Hours of Time](https://medium.com/better-programming/how-to-write-log-files-that-save-you-hours-of-time-1ff0cd9ae2ed)
> * 原文作者：[keypressingmonkey](https://medium.com/@keypressingmonkey)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/how-to-write-log-files-that-save-you-hours-of-time.md](https://github.com/xitu/gold-miner/blob/master/article/2020/how-to-write-log-files-that-save-you-hours-of-time.md)
> * 译者：
> * 校对者：

# How to Write Log Files That Save You Hours of Time

![Photo by [Pietro Jeng](https://unsplash.com/@pietrozj?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral).](https://cdn-images-1.medium.com/max/11232/0*iqdOil183vfy81IT)

I need to rant a bit here: The program I maintain at work has many cute quirks. “An error has occurred” is not one of them. This is not just how that error message starts. It’s also how it **ends.**

Or how about “Information about the error is stored in the server logs,” but there’s no indication of which server actually threw that exception?

This article is about how to write log and error messages that don’t suck.

## Do You Really Need This?

Most of this article will be about giving **more** information. But just for a moment, let’s look at some log messages that can be safely cut. Why? Well, when you have to read through a mile-long log file, you’ll be thankful for everything that doesn’t consume your sanity and focus.

* “All is good” log entries for every single iteration in a loop. As long as I know the program started alright and is maybe now about to enter that loop, all I really care about are errors.
* Random performance logs when I’m not performance testing.
* Logs on every step of a function/calculation. You don’t really need to log “a” and “b” when you’re already logging “a+b=c.”

As I said, it’s better to have more information than you need than too little in most cases, but it’s still worth keeping in mind to avoid falling off the other end.

## Please Tell Me What the Error Is

Most exceptions we deal with in daily life aren’t explicitly handled, meaning we often get a stack traceback that tells us exactly what happened, where, and when. That’s fine. It’s not particularly readable, but at least you can follow down to the source.

If, however, you were to catch an exception and use that catch block to then print “Something don’t work yo” to the console without even printing it into the log file, just please don’t. If you write a custom exception handler, then just take the extra minute to explain what the error is. Is it a wrong database entry, like an incorrectly formatted name? Nice, now I don’t have to clone the repo and debug and can just fix that entry on the database right away.

## Please Tell Me Where the Error Originated

This is my biggest pain point while bug fixing: We get daily monitoring of error messages, but the best-written error message won’t get me far when I don’t even know where it originated from. Just write something like:

```
fatal error: invalid cast at serverIWouldLikeToSlaughter
```

And I’m much happier.

## Give Me Some Extra Parameters to Work With

Sticking with the previous example, you probably have all the information on hand right at that moment when you wrote the error message, so why don’t you give it to me? Just print out the customer ID, the billing number, the email address that you can’t deserialize.

```
Fatal error: Invalid cast type Boolean to Integer numberOfSwearwords at serverIWouldLikeToSlaughter 
```

---

## Only Overload the Specific Exceptions

If you want to throw an exception for wrong data types or something like that, you should hook into the `invalidCastException` or something like that — not the “exception." This way, the most common error will have a great error message with a speaking name and description. But when anything out of the ordinary happens, you still log the full stack trace and it won’t get lost.

```
Try{thisOrthat();}
Catch castEx as InvalidCastException{
  log.error("detailed description of erro");
}
Catch ex as Exception{
  log.error(ex.stacktrace);
}
```

## Let’s Look at Some Log File Examples, Shall We?

Here are just some randomly selected samples of what I would consider useful log entries — stuff that makes it that much easier to understand where the error originated and how to fix it:

```
-booting up server1 application4 
-Connecting to otherServer at Port 1337…ok
-Checking database Connection to databaseServer5 Error 400:Of course it doesn’t work, your credentials are outdated but not even the database admins have a clue what the new one are.
-program shut down at 00:34 pm, 1234 files processed successfully, 23 unsuccessful, 45 skipped
-Can't access file asdfadsfa.txt because the file is open in another process
-error updating database table tb_xyz, maximum column length of 50 exceeded at column "name"
-processing HTML text box failed, this is often caused by formatting issues on the database side. Check with database admins, the following value was retrieved from DB: <a\">helloworld\"</a>
```

Each of these error messages would save me half an hour just looking for a specific bug compared to either not logging it at all or logging it in an ineffective way.

## Takeaway

A minute of your time can save you hours down the road.

I hope you found this article interesting. It’s an issue that seems quite small and pedantic until you’ve been repairing and fixing bugs for a couple of years and have seen all the ways in which logging can go wrong.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
