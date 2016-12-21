# 用工厂流水线的方式来理解 RxJava 的概念

本文已授权微信公众号 AndroidDeveloper 独家发布。

>* 原文链接 : [RxJava – the production line](http://www.thedroidsonroids.com/blog/android/rxjava-production-line/)
* 原文作者 : [Mateusz Budzar]()
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [Sausure](https://github.com/Sausure)
* 校对者 : [lizhuo](https://github.com/huanglizhuo), [Rocky](https://github.com/rockzhai)

##  为什么另写一篇 RxJava 的文章?

已经有很多[ RxJava ](https://github.com/ReactiveX/RxJava)的文章通过例子阐述了什么是 RxJava 以及怎么去用，但它们大多数只有代码。虽然也会通过类比来解释，例如最出名的就是“流”。通常情况下代码能完美地让人理解（我们都是程序员，对吧？），但是 RxJava 十分不同于以往的 Android 开发。在最开始时通过代码是很难让人理解的，用“流”来类比并不足够，即使是[ marbles ](http://rxmarbles.com/)的例子也还远远不够。我可以保证自己能理解，但对于别人，老实说，难道你们不需要更多结合实际的例子？难道你们不想在脑海中举一个例子来让自己更好地理解 RxJava 吗？我做了，并且我想和你们分享。

## 工厂流水线

好吧，我说谎了。为了理解 RxJava，我在脑海里举了不仅仅一个例子。例如我尝试观察动物园笼子的动物，尝试观察河流里的鱼，也尝试去观察蝙蝠侠里的犯罪（额，这不是现实生活中的，但不失为一个很好的例子）。但我还是认为工厂流水线是最好的例子。

![](http://ww1.sinaimg.cn/large/a490147fjw1f2ty3u29rzj20sg0fx0t6.jpg)

### 需求

我们先想象下，我们需要写一款应用来展示动物们的信息，并且现在我需要在新的界面实现以下功能：

*   三份关于猫的信息
*   每份都是唯一的
*   每份都应该少于 300 字符
*   每份都配张猫的图片

### 启动流水线！

我们尝试通过流水线上的工人们的帮助实现那些功能。

1\. 首先我们需要启动产品处理进程。仅仅有流水线是不足够的 - 还需要有人去启动它。例如一个对结果感兴趣的产品经理

![](http://ww1.sinaimg.cn/large/a490147fgw1f2ty4x582tj20sg0fv0ts.jpg)

2\. 现在我们需要随机获得有关猫的信息。但怎么做呢？幸运的是这里有[ API ](http://catfacts-api.appspot.com/doc.html)能让我们很容易做到！真的是巧合么。。。？好吧，我们先通过 _GET_ 方法获取这些信息。

![](http://ww3.sinaimg.cn/large/a490147fgw1f2ty5f9qhpj20sg0fvjrz.jpg)

3\. 现在我们需要处理来自 API 的响应。它是由 HTTP 状态码和一列有关猫的信息组成。我们并不需要状态码所以我们首先去除它并将信息列表传给下一个工人。

![](http://ww3.sinaimg.cn/large/a490147fgw1f2ty67umsuj20sg0fudhh.jpg)

4\. 下一件要做的事就是将信息列表的信息一个个抽离出来。为什么要这么做？因为这样做方便下游的工人操作单个字符串（例如检查字符串是否过长）。

![](http://ww1.sinaimg.cn/large/a490147fgw1f2ty6sggq4j20sg0fuwgd.jpg)

5\. 每条信息都是唯一的。下一个工人的任务是清除重复项。

![](http://ww1.sinaimg.cn/large/a490147fgw1f2ty78qmzzj20sg0fsdhg.jpg)

6\. 每条信息都不能太长（少于 300 字符）

![](http://ww4.sinaimg.cn/large/a490147fgw1f2ty7nfx7lj20sg0ftwfm.jpg)

7\. 现在我们的信息是唯一的且长度也符合要求可数量太多了而我们仅仅需要 3 份。所以下一个工人应该清除多余的信息。

![](http://ww2.sinaimg.cn/large/a490147fgw1f2ty83zoxfj20sg0fvdgp.jpg)

8\. 每条信息都有一张随机的猫的图片。

![](http://ww1.sinaimg.cn/large/a490147fgw1f2ty8i3n9fj20sg0fwq49.jpg)

9\. 我们不应该将信息分批给产品经理，而是应该将这些信息打包成一个列表。

![](http://ww4.sinaimg.cn/large/a490147fgw1f2ty9j44v8j20sg0fvgmp.jpg)

10\. 现在产品经理可以在屏幕上显示结果了。

![](http://ww4.sinaimg.cn/large/a490147fgw1f2tya3eqinj20sg0fymya.jpg)

这就是我们要做的。我们已经通过流水线上的工人完整地实现了全部功能并最后将结果显示到了屏幕上。

### 若用 RxJava 实现这些需求该怎么做呢?

RxJava 中存在很多可观察对象（它传出的数据可以被我们观察到）和观察者（它观察并处理可观察对象传出的数据）。在我们的例子里流水线就是可观察对象而产品经理就是观察者。需要注意的是观察者启动整个流水线这个步骤是十分重要的。如果没有观察者，流水线是不会启动的。

![](http://ww3.sinaimg.cn/large/a490147fgw1f2tyb17a9wj20sg0c5mxz.jpg)

那么流水线上的工人算什么呢？在 RxJava 的世界里它们叫做操作符。它们的动作十分像工人 - 他们需要处理那些被传出的数据（例如仅仅让唯一的数据通过）

![](http://ww3.sinaimg.cn/large/a490147fgw1f2tybbvu5hj20sg0cw0td.jpg)

### 在代码世界实现流水线

很好。可这么多图片有卵用？代码终究还是代码并不是一条流水线，不是吗？
```java
    mCatFactsService.getCatFacts(100)
                    .map(catFactResponse -> catFactResponse.getFacts())
                    .flatMap(catFacts -> Observable.from(catFacts))
                    .distinct()
                    .filter(catFact -> catFact.length() <= 300)
                    .take(3)
                    .map(catFact -> new CatFactWithImage(catFact, getRandomCatImageId()))
                    .toList()
                    .subscribeOn(Schedulers.io())
                    .observeOn(AndroidSchedulers.mainThread())
                    .subscribe(mCatFactsAdapter::setCatFactWithImages, Throwable::printStackTrace);
```
这样就能通过 RxJava 实现流水线了。为了理解上面的代码你应该从上到下看一遍。每个动作都是独立运行的 - 一个接着一个。

*   **mCatFactsService.getCatFacts(100)** – 这个就是 _GET_ 方法。在响应里我们获得一个封装了 HTTP 状态码以及一列猫的信息的对象。`Observable` （即可观察对象）将这个对象（我们叫它 CatFactResponse 吧） 封装起来，现在我们就可以用 RxJava 的操作符对它进行处理。
*   **map(), flatMap(), distinct(), filter(), take(), toList()** – 这些就是操作符。它们可以修改被传出的数据 - 一个接着一个。它们就像上面例子的图片中流水线上的工人。
*   **subscribe()** – 让一个 `Observer` （即观察者）去订阅一个 `Observable`。若没有这一步整个流水线都无法启动。
*   **subscribeOn()** – 告诉 `Observable` 当 _subscribe()_ 方法被调用后它应该在哪个线程被启动。接着每个操作符都会在那个线程工作直到我们改变线程。
*   **observeOn()** – 改变下一个操作符的工作线程。每个在这个方法之后的操作符都会在它指定的新的线程里工作，直到我们通过别的 _observeOn()_ 改变线程。

现在我们再仔细分析我们用过的每个操作符
```java
    .map(new Func1<CatFactResponse, List<String>>() {
            @Override
            public List<String> call(CatFactResponse catFactResponse) {
                return catFactResponse.getFacts();
            }
    })
```
有可能你会不适应那花俏的箭头所以我将完整的实现展开了（当然我们可以通过 Java8 的 lambda 表达式实现那种语法 - 详情见[ retrolambda ](https://github.com/evant/gradle-retrolambda)）

正如你说看到的， _mCatFactsService.getCatFacts()_ 返回一串数据并被传到 _CatFactResponse_ 中，但因为现在我们不需要 HTTP 状态码，所以我们通过 **MAP** （转换）操作符将 CatFactResponse 对象转换成别的对象 - 在这个例子中是 List <string> 对象。下一个操作符将会处理这个对象。
```java
    .flatMap(new Func1<List<String>, Observable<? extends String>>() {
            @Override
            public Observable<? extends String> call(List<String> catFacts) {
                return Observable.from(catFacts);
            }
    })
```
`flatMap` 操作符接受猫的信息列表作为参数，分别取出列表的每条数据并抛给下一个操作符。所以我们拿到并抛出的数据都是 **FROM** （来自）这个列表的。
```java
    .distinct()
```
这个操作符用来处理重复项，并且它不会让任何已经通过的相同字符串再次通过。每个都是 **DISTINCT** (独特的)。
```java
    .filter(new Func1<String, Boolean>() {
            @Override
            public Boolean call(String catFact) {
                return catFact.length() <= 300;
            }
    })
```
`filter` 操作符就是个简单的对/错判断表达式。如果字符串太长，将无法通过。所以 `filter` 很显然是用来 **FILTERS** （过滤的）。
```java
    .take(3)
```
`take` 操作符 **TAKES** （取出）指定数量的信息。
```java
    .map(new Func1<String, CatFactWithImage>() {
            @Override
            public CatFactWithImage call(String catFact) {
                return new CatFactWithImage(catFact, getRandomCatImageId());
            }
    })
```
另一个 `map` 操作符。在我们打包所有字符串之前我们应该为每个字符串添加张猫的图片。
```java
    .toList()
```
现在我们可以打包所有 _CatFactWithImage_ 对象 **TO** （成）一个 **LIST** （列表）了。
```java
    .subscribe(new Observer<List<CatFactWithImage>>() {
            @Override
            public void onCompleted() {
                //no-op
            }

            @Override
            public void onError(Throwable e) {
                e.printStackTrace();
            }

            @Override
            public void onNext(List<CatFactWithImage> catFactWithImages) {
                mCatFactsAdapter.setCatFactWithImages(catFactWithImages);
            }
    });
```
然后就是简单地将 `list` 对象传给 `adapter` 对象而已。

## 结论

RxJava 是款十分强大的工具。但不幸的是如果你之前没有通过“流”的形式写过代码你可能很难理解它并学会如何去用它。因为它十分不同于以往平常的安卓开发，所以我们需要一些比代码更形象的东西去理解它。我希望这篇文章能帮助你更好地理解 RxJava 是如何工作的。
