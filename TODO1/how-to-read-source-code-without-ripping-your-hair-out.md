> * 原文地址：[How to read code without ripping your hair out](https://medium.com/launch-school/how-to-read-source-code-without-ripping-your-hair-out-e066472bbe8d)
> * 原文作者：[Sun-Li Beatteay](https://medium.com/@SunnyB)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-read-source-code-without-ripping-your-hair-out.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-read-source-code-without-ripping-your-hair-out.md)
> * 译者：
> * 校对者：

# How to read code without ripping your hair out

![](https://cdn-images-1.medium.com/max/10944/1*Vv0HNvRhU0ihKVaBIpDUww.jpeg)

1. Write More Code
2. Read More Code
3. Repeat Daily

That was the advice given to me when I made the career switch to programming almost two years ago. Fortunately, there are plenty of courses and tutorials online for writing code. Unfortunately, there are still little-to-no resources that teach reading it.

This is a huge disparity. There’s an [increasing influx](https://www.coursereport.com/reports/2016-coding-bootcamp-market-size-research) of bootcamp grads entering the tech field. It’s more crucial than ever to emphasize reading source code. As Brandon Bloom [wrote](https://news.ycombinator.com/item?id=3769446):
> If it runs on [your] machine, it’s [your] software. [You’re] responsible for it. [You] must understand it.

![Yes, you.](https://cdn-images-1.medium.com/max/2000/1*r_K_SnPFHV6BRZMcShNiPQ.gif)

While every programmer should be reading code, [they aren’t](https://blog.codinghorror.com/learn-to-read-the-source-luke/). The reason many programmers choose to avoid it is because it’s hard, frustrating, and makes them feel stupid. I know because that’s how it made me feel.

**It doesn’t have to be that way.**

In my time of reading other peoples’ code, I’ve come up with a process that only involves three steps. Many of you may already be following these steps, but I can guarantee there are many who aren’t.

Here are my steps.

## 1. Pick a specific point of interest

![Image Source: [https://thenextweb.com/wp-content/blogs.dir/1/files/2010/04/twitter-location-300x200.jpg](https://thenextweb.com/wp-content/blogs.dir/1/files/2010/04/twitter-location-300x200.jpg)](https://cdn-images-1.medium.com/max/2000/1*1jtCApS-67hwSYHOqwsDDw.png)

The first time I tried to read code was a disaster.

I was learning Sinatra at the time and wanted to better understand what was under the hood. Yet, I had no idea where to start. I found the repo on Github and picked a file at random. No joke.

I figured I could spend the afternoon studying it and have a solid grasp on its capabilities by dinner. After all, reading my own code was easy enough, how could this be any different?

We all know where this is going. Suffice it to say, it felt like I was smacking my head against a wall of text.

![](https://cdn-images-1.medium.com/max/2000/1*RSW1LI69w3Bgb1H7ynxDjw.gif)

I had tried to learn too much at one time. ****It’s the same mistake many beginners commit when they try to read source code for the first time.

**Mental models are built piece by piece. Code should be read the same way.**

Instead of trying to stomach 1000 lines of code in a herculean effort, focus on a single topic. If it can be parsed down to a single method, even better.

Having a narrow focus will help you know what is relevant and what isn’t. No need to chase down red herrings.

However, choosing a specific topic won’t solve all your problems. There’s still the dilemma of knowing where to look in the code base to find it.

That’s where step two comes in.

## 2. Find a loose thread

![Image Source: [https://glenelmadventblog.files.wordpress.com/2012/12/loose-thread.jpg](https://glenelmadventblog.files.wordpress.com/2012/12/loose-thread.jpg)](https://cdn-images-1.medium.com/max/2000/1*suh4cGspVlBGRqF1QAVK_Q.png)

Now that you have a specific method you want to learn about, what do you do next?

Luckily for us all, programming languages come with investigative tools.

Whether you want to know the class of an object, the ancestry of a class, the stack trace, or owner of a certain method, most languages offer these features. Once you begin to unravel the tapestry that is a code library, you will find plenty of loose ends to follow.

Instead of explaining this concept in words, I’d rather show it to you in code

### Investigate

Say I want to learn more about ActiveRecord associations. I’ve narrowed my focus to the `belongs_to` method and want to understand how it affects my ActiveRecord models.

ActiveRecord is a part of [Rails](https://github.com/rails/rails), which is built in Ruby. Ruby provides plenty of research tools.

My first approach would be to use a bugging tool, such as the `pry` gem, to dissect one of my ActiveRecord models. For context, this is the code for the model I chose to debug.

```
class Comment < ActiveRecord::Base
  belongs_to :creator, foreign_key: 'user_id', class_name: 'User'
  belongs_to :post
  binding.pry
  validates :body, presence: true
end
```

Pay attention to the `binding.pry` statement. When Rails comes across this line of code, `pry` will pause the app in mid-execution and open up a command line prompt.

Below is a sample exchange I had in the pry console when I studied this `belongs_to` association.

* All my inputs are on the lines that start with `pry >`.

* `=>` shows the outputs by the console.

```
pry> class = belongs_to(:post).class
=> ActiveRecord::Reflection::AssociationReflection

pry> class.ancestors
=> [ActiveRecord::Reflection::AssociationReflection,        
    ActiveRecord::Reflection::MacroReflection,
     ...omitted for brevity ]

pry> defined? belongs_to
=> "method"

pry> method(:belongs_to).owner
=> ActiveRecord::Associations::ClassMethods
```

In case you don’t understand Ruby and this exchange confuses you, let me give the SparkNotes.

* When `belongs_to :post` runs, it returns an instance of the `AssociationReflection` class.

* `MacroReflection` is the superclass of `AssociationReflection`.

* `belongs_to` is a class method that is defined on the `ClassMethods` module that is inside of `ActiveRecord::Associations`.

Now that I have some leads, which one should I follow? Since I’m more interested in the `belongs_to` method itself and not what it returns, I’ll begin my search in the `ClassMethods` module.

## 3. Follow the trail

![](https://cdn-images-1.medium.com/max/2000/1*VP1Zze3OGAZnalmuvzJhhQ.png)

Now that you have the thread you want to follow, all that’s left is to trace it until you find your answer. This may seem like an obvious step, but this is where most beginners get tripped up.

One reason for this is that repositories don’t have a table of contents. We are at the mercy of the maintainers to organize their files in readable fashion.

On bigger projects that have many maintainers, that’s usually not an issue.

On smaller projects, you may find yourself wading through monolithic files, deciphering single name variables, and asking yourself “Where did this come from?” too often to count.

### GitHub Search

One tool that can make this task easier is GitHub search (assuming the project you’re reading is on GitHub). GitHub search is handy because it shows you all the files that match your search query. It also shows where in the file your query matches.

![](https://cdn-images-1.medium.com/max/2000/1*bgk8AkVP2Uuk-Msj_LDrPg.png)

To get the best results, you need to make your search query as specific as possible. This will require that you have an idea of what you’re looking for. Aimlessly searching GitHub with your fingers crossed is not a valid strategy.

Going back to my example from Step 2, I’m trying to find the `ClassMethods` module inside `ActiveRecord::Associations`. In layman’s terms, I’m looking for the module `ClassMethods` located inside the module`Associations` nested inside of the `ActiveRecord` module. Furthermore, I’m searching for the method `belongs_to`.

***

This was my search query.

![](https://cdn-images-1.medium.com/max/2000/1*iUg2iDC5kaqC8mbw2RZEUw.png)

The results showed me exactly what I was looking for.

![](https://cdn-images-1.medium.com/max/2000/1*XWliUt7xdo2z2WUIwnBmYw.png)

![belongs_to method inside of ClassMethods](https://cdn-images-1.medium.com/max/2000/1*PDjJRgT-JEHgIEwJb5hWkw.png)

### More research may be required

***

GitHub search will significantly narrow the scope of your search. Because of this, you will find an easy entry point to dive into the code base.

Unfortunately, finding the class or method itself is rarely the end of mystery. You may find yourself jumping from module to module until you understand the bigger picture.

In my case, the `belongs_to` class lead me to the `build` method inside the `BelongsTo` class. This took me to the `Association` super class.

![build method in BelongsTo class](https://cdn-images-1.medium.com/max/2000/1*Mjx30BZtTxjPqMkdSINoqA.png)

![build method in Association class](https://cdn-images-1.medium.com/max/2000/1*WfqZWDnjg_rUiPZfdH1jGQ.png)

In the end, I discovered that `belongs_to` causes Rails to add several instance methods to my model, including a getter and setter. It does this with an advanced programming technique known as meta-programming.

Rails also creates an instance of the `Reflection` class which is used to store information about the association.

From the Rails API [docs](http://api.rubyonrails.org/classes/ActiveRecord/Reflection/ClassMethods.html):
> Reflection enables the ability to examine the associations and aggregations of Active Record classes and objects. This information, for example, can be used in a form builder that takes an Active Record object and creates input fields for all of the attributes depending on their type and displays the associations to other objects.

Pretty neat stuff.

## Wrapping Up

While I can’t promise that interpreting someone else’s programming will be fun and enjoyable, it is worthwhile. It will add a crucial skill to your tool belt and grant an extra layer of freedom. You will no longer be dependent on thorough documentation or examples. While those are appreciated, they are not a cure-all. As Jeff Atwood wrote:
> **No matter what the documentation says, the source code is the ultimate truth, the best and most definitive and up-to-date documentation you’re likely to find.**

So take a stab at it!

There must be something you’ve been itching to learn about for some time now. Don’t let the size of the code base intimidate you. Open up the repository to your favorite framework and start digging. If you follow the steps I’ve laid out in this post, you’ll be a source code guru in no time.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
