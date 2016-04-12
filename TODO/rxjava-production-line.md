>* 原文链接 : [RxJava – the production line](http://www.thedroidsonroids.com/blog/android/rxjava-production-line/)
* 原文作者 : [Mateusz Budzar]()
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者:



## Why another RxJava example?

There are a lot of [RxJava](https://github.com/ReactiveX/RxJava) articles with examples which explains what it is and how to use it. But mostly there is just a code. Even if there is also an explanation through the analogy, the most popular word is a ‘stream’. Usually the code example is just perfect (we are programmers, right?), but RxJava is very different from what we do daily during Android development. The code is not enough in the beginning to understand it. Stream is not enough. Even [marbles](http://rxmarbles.com/) examples are not enough. I can speak for my own, but guys, to be honest, didn’t you need more examples by analogy i.e. to some kind of reality? Didn’t you create one in your head to understand the RxJava way better? I did and I want to share it with you.

## The production line

I lied. I created more than one example in my head to understand RxJava. I tried with ZOO and I observed animals in cages. I tried with river and I observed fishes. I also tried with Batman and I observed crimes (yeah… it’s not a reality, but it’s still a good one). But I guess that production line is the best analogy.

![](http://ww1.sinaimg.cn/large/a490147fjw1f2ty3u29rzj20sg0fx0t6.jpg)

### App functionalities

Let’s imagine that we write an app which displays information about animals and we’ve got request to implement new screen with following functionalities:

*   3 random facts about cats.
*   Each should be unique.
*   Each should be less than 300 characters.
*   Image with cat should be included to each fact.

### Start the production!

Let’s try to implement those functionalities in production line with the help of some workers.

1\. First of all we should start a production process. Production line itself is not enough – someone has to run it. For example a Production Manager who is interested with the result.

![](http://ww1.sinaimg.cn/large/a490147fgw1f2ty4x582tj20sg0fv0ts.jpg)

2\. Now we should get these random cat facts. But how? We are lucky because there is an [API](http://catfacts-api.appspot.com/doc.html) for it! Coincidence…? So let’s GET the facts.

![](http://ww3.sinaimg.cn/large/a490147fgw1f2ty5f9qhpj20sg0fvjrz.jpg)

3\. We should handle the response from API. It consists of HTTP status code and list of cat facts. We don’t need the status so the first worker at the line simply removes it and pass only the facts list.

![](http://ww3.sinaimg.cn/large/a490147fgw1f2ty67umsuj20sg0fudhh.jpg)

4\. Next thing to do is to separate each fact from the list. Why? Because it will be more convenient for other workers to operate on a single String (i.e. to check if it’s not too long).

![](http://ww1.sinaimg.cn/large/a490147fgw1f2ty6sggq4j20sg0fuwgd.jpg)

5\. Each fact should be unique. Next worker eliminates each repetition.

![](http://ww1.sinaimg.cn/large/a490147fgw1f2ty78qmzzj20sg0fsdhg.jpg)

6\. Facts should not be too long (less than 300 characters).

![](http://ww4.sinaimg.cn/large/a490147fgw1f2ty7nfx7lj20sg0ftwfm.jpg)

7\. We have got now unique and not too long facts but they are too many. We just need only 3\. Next worker will not pass more than that.

![](http://ww2.sinaimg.cn/large/a490147fgw1f2ty83zoxfj20sg0fvdgp.jpg)

8\. Each fact should also have some random image with cat.

![](http://ww1.sinaimg.cn/large/a490147fgw1f2ty8i3n9fj20sg0fwq49.jpg)

9\. We won’t give the Production Manager each fact separately. We should pack they first to one list.

![](http://ww4.sinaimg.cn/large/a490147fgw1f2ty9j44v8j20sg0fvgmp.jpg)

10\. Now the Production Manager can display the results on a screen.

![](http://ww4.sinaimg.cn/large/a490147fgw1f2tya3eqinj20sg0fymya.jpg)

And that’s it. We’ve just implemented whole functionalities and display the result on the screen with the use of production line and some workers.

### What does this have to do with RxJava?

A lot. RxJava generally consists of Observable (which emits the data which we can observe) and Observer (which observes emitted data and handles it). In our example the production line is an Observable and Production Manager is an Observer. It is very important to notice that Observer starts the production line. If there is no observer the production line isn’t working.

![](http://ww3.sinaimg.cn/large/a490147fgw1f2tyb17a9wj20sg0c5mxz.jpg)

What about workers who are working at the line? In RxJava world they are called Operators. They act exactly the same as the workers – they should do something with the emitted data (i.e. pass only the unique ones).

![](http://ww3.sinaimg.cn/large/a490147fgw1f2tybbvu5hj20sg0cw0td.jpg)

### Production line in code

Great. Couple of images and so what? Code is code but not a production line… isn’t it?

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

In fact RxJava code is. To understand that you should look at above code from up to bottom. Every action is run sequentially – one after another.

*   **mCatFactsService.getCatFacts(100)** – this is the GET. In response we get HTTP status with cat facts list and put these to some object. That object (let’s call it CatFactResponse) is wrapped in Observable and now we can run some RxJava operations on it thanks to Operators.
*   **map(), flatMap(), distinct(), filter(), take(), toList()** – these are Operators. They modify emitted data – one after another. They do exactly the same work as workers on the production line in above example images.
*   **subscribe()** – subscribes an Observer to Observable. Without this Operator the code above it won’t start working.
*   **subscribeOn()** – tells Observable on which thread it should starts after we call _subsctibe()_. Also each Operator will do it’s work on that thread until we change this thread to another.
*   **observeOn()** – change the thread for next Operators below. Each operator which is called after this one will do it’s work in that new thread until we change it with calling another _observeOn()_.

Let’s look close on each Operator that we used.

    .map(new Func1<CatFactResponse, List<String>>() {
            @Override
            public List<String> call(CatFactResponse catFactResponse) {
                return catFactResponse.getFacts();
            }
    })

I expanded the whole implementation in case that you feel uncomfortable with this fancy arrows (we are able to pretend that we use Java 8 lambdas – see [retrolambda](https://github.com/evant/gradle-retrolambda)).

As you can see _mCatFactsService.getCatFacts()_ returned some data and it was put to _CatFactResponse_, but we don’t need HTTP status code in this case, so we **MAP** CatFactResponse object to another object – List <string>with the cat facts. Next Operator will be working with that list.</string>

    .flatMap(new Func1<List<String>, Observable<? extends String>>() {
            @Override
            public Observable<? extends String> call(List<String> catFacts) {
                return Observable.from(catFacts);
            }
    })

FlatMap Operator gets cat facts list, take each fact separately from that list and ‘throws’ it down to the next operator. So we take and ‘throw’ each fact **FROM** the list.

    .distinct()

This operator handles repetitions and won’t pass any String that has already occurred. Each one should be **DISTINCT**.

    .filter(new Func1<String, Boolean>() {
            @Override
            public Boolean call(String catFact) {
                return catFact.length() <= 300;
            }
    })

Filter is just simply a true/false expression. If String is too long, it won’t pass. So filter (obviously) **FILTERS**.

    .take(3)

Take operator **TAKES **given number of facts.

    .map(new Func1<String, CatFactWithImage>() {
            @Override
            public CatFactWithImage call(String catFact) {
                return new CatFactWithImage(catFact, getRandomCatImageId());
            }
    })

Another map Operator. Before we pack all the Strings we should add to each of them a picture with cat.

    .toList()

Now we can pack all _CatFactWithImage_ objects **TO** one **LIST**.

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

And that list just pass to adapter. That’s it.

## Conclusion

RxJava is a powerful tool. Unfortunately it’s not that easy to understand it and understand how to use it if we have never been writing in a ‘stream’ way before. This way is very different from what an Android Developer do daily so I needed something more than code to understand it. I hope that this article helped you to understand better of how RxJava is working.

