> * 原文地址：[Intro to Swift Functional Programming with Bob](https://medium.com/ios-geek-community/intro-to-swift-functional-programming-with-bob-9c503ca14f13#.i3o0lngnq)
* 原文作者：[Bob Lee](https://medium.com/@bobleesj?source=post_header_lockup)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

# Intro to Swift Functional Programming with Bob #

## The tutorial I’d have written for my younger self. ##

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/2000/1*AHNKmNnflyMN2zfQh9Cb4Q.png">

A veteran how to use tools — so can we

### Functional programming? ###

You get it. People are talking about it. You google and look up the first 5 articles from the top. Frustrated, you notice most tutorials pull a vague Wikipedia definition like,

> “Functional Programming is a paradigm that allows you to make your code explicit. There is no state and no mutuality”

I’ve been there my friend. In fact, I still do. I give a gentle degree of a face-palm wrapped around my mouth and respond,

> Dafuq?

#### **Prerequisite** ####

Familiarity with closures. If you do not understand what comes after in and key signs such as `$0` , you are not ready for this tutorial. You may leave, and find every resource available [here](https://bobleesj.gitbooks.io/bob-s-learning-journey/content/WORK.html) to level up.

### Non-Functianal Programming ###

I’m a big fan of why. Why do we learn functional programming? Well, the best answer comes from our past. Assume you are creating an calculator app that adds an array.

```
// Somewhere in ViewController

let numbers = [1, 2, 3]
var sum = 0 

for number in numbers {
 sum += number
}
```

Okay, but what if I need to create one more?

```
// Somewhere in NextViewController 

let newNumbers = [4, 5, 6]
var newSum = 0

for newNumber in numbers {
 newSum += newNumber
}
```

It seems like we are repeating ourselves. Long, boring, and uncenessary. You have to create `sum` to track the added result. It’s just atrocious. 5 lines of code. We are probably better off creating a function instead.

```
func saveMeFromMadness(elements: [Int]) -> Int {
 var sum = 0

 for element in elements {
  sum += element
 }

 return sum
}
```

So when you need to use the `sum` feature, just call

```
// Somewhere in ViewController
saveMeFromMadness(elements: [1, 2, 3])

// Somewhere in NextViewController
saveMeFromMadness(elements: [4, 5, 6])
```

**Stop right there. That’s it. You’ve tasted a functional paradigm. A functional approach is nothing more than using functions to derive the result you need.**

### Analogy ###

On Excel or Google’s Spreadsheet, to sum up values, you select cells, and call a function most likely written in the C# language.

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*FT4PCQ2PjKkuX1KcNhk8Yw.gif">

Sum function in Excel

*Okay, that’s it. Bye. Thanks for reading.* 😂

### Declarative vs Imperative ###

Finally, now, it makes sense to come up with a detailed definition of functional programming.

#### **Declarative** ####

We often describe functional programming as **declarative**. **You don’t care how you got the answer.** For example, a human can climb up the Mt.Everest by jumping off from a plane or work from the bottom by taking ages. **You get the same result**. The user has no idea how the Excel spreadsheet’s `Sum` function is made up off. But, it just works.

The atrocious example, a.k.a non-functional programming, we saw above is often called, **imperative**. It tells you **how** you got the answer from A → B.

```
let numbers = [1, 2, 3]
var sum = 0

for number in numbers {
 sum += number
}
```

The user knows that you loop through `numbers`. **But, is it really necessary?** I don’t care how it is made. I only care about the result as long as fast and quick.

As a result, Excel and Spreadsheet incorporate a functional programming paradigm to get quick and easy answers without worrying about any implementation detail — **my father wouldn’t necessarily want to deal with it when working with his company’s financial data.**

### Other Benefits ###

In the atrocious example above, we had to arbitrarily create `var sum = 0` in order to track the added result within each view controller. But, is it really necessary? The value of `sum` constantly changes. What if I mistakenly mess around with sum? Again, as I talked about in [10 tips to become a better Swift Developer](https://medium.com/ios-geek-community/10-tips-to-become-better-swift-developer-a7c2ab6fc0c2#.rcnngphgj),

More variables → more memorization → more headache → more bugs → more life problems.

More variables → Easy to f up → Done

> **As a result, a functional paradigm ensures no mutability or no change in state when used.**

Also, as you realize or will discover more, a functional paradigm provides a modular, easy to maintain code base.

### Purpose ###

So, now you understand why we favor functional programming. So what? Well, in this tutorial, **let’s only focus on the fundamentals**. I’m not going to talk about how functional programming can be applied to user events and networking and so on. I might post tutorials how to do all those stuff using RxSwift. So stay tuned or follow me if you are new.

### Real Works ###

You might have seen things like `filter`, `map`, `reduce` and so on. Well, this is how you manipulate an array using a functional approach using **Filter only**. Make sure you are cool with generics as well.

It’s all about getting the fundamenatals. If I can teach you how to swim in the swimming pool, you probably can in the ocean, lake, pond, maybe not in the mud. In this tutorial, If you get the fundamentals, you can create your own `map` and `reduce` or any other cool functions as you wish. You may google things up. Just that you won’t get this Bob the Developer explanation from me.

### Filter ###

Assume you have an array.

```
let recentGrade = ["A", "A", "A", "A", "B", "D"] // My College Grade
```

You want to filter/bring and returns an array that only contains a “A” which used to make my mom happy. How do you go about that **imperatively**?

```
var happyGrade: [String] = []

for grade in recentGrade {
 if grade == "A" {
  happyGrade.append(grade)
 } else {
  print("Ma mama not happy")
 }
}

print(happyGrade) // ["A", "A", "A", "A"]
```

**This is mad.** I wrote this code. I do not recheck while proof reading. This is atrocious. 8 lines of code within a view controller? 🙃

> *I can’t even*.

We have to this stop this madness and save all of you who have been doing this way. Let’s create a function that does it all. Brace yourself. **We are now going to deal with closures**. Let’s try to create a filter that accomplishes the same task above. *Real shit happens now.*

### Introduction to Functional Way ###

Let’s create a function that takes a `String` array and also takes a closure whose type is `(String) -> Bool` . Last, it will return a filtered `String` array. Why? Just bear with me for another two minutes.

```
func stringFilter(array: [String], **returnBool: (String) -> Bool**) -> [String] {}
```

You might be quite distressed by the `returnBool` section. I know what you must be thinking,

> So, what are we going to pass under return**Bool** ?

You are going to create a closure that contains an else-if statement whether the array contains, “A”. If so, returns `true`.

```
// A closure for returnBool 
let mumHappy: (String) -> Bool = { grade in return grade == "A" }
```

If you want to make it real short,

```
let mamHappy: (String) -> Bool = { $0 == "A" }

mamHappy("A") // return true 
mamHappy("B") // return false
```

*If you are confused by two examples above, you are not ready for this battle field. You need to workout first and then come back. You can read revisit my articles on closures right* [*here*](https://medium.com/ios-geek-community/no-fear-closure-in-swift-3-with-bob-72a10577c564#.uzdsqd7oa).

Since we haven’t finished up the implementation of the `stringFilter`, let’s continue where we left off.

```
func stringFilter (grade: [String], returnBool: (String) -> Bool)-> [String] {

 var happyGrade: [String] = []
 for letter in grade {
  if returnBool(letter) {
   happyGrade.append(letter)
  }

 }
 return happyGrade
}
```

You must be like, “😫”. Let me explain. Within the `stringFilter` function, you pass `mamHappy` under `returnBool`. After that, you pass each grade to `mamHappy` by calling `returnBool(letter)` which is eventually `mamHappy(letter)`.

It will either return `true` or `false`. If true, append `letter` to `happyGrade` which should be only filled with “A’s.🤓 That’s what my mom felt happy about for the last 12 years.

Anyway, let’s finally run the function.

```
let myGrade = ["A", "A", "A", "A", "B", "D"]

let lovelyGrade = stringFilter(grade: myGrade, returnBool: **mamHappy**)
```

### Enter Closure Directly ###

You don’t necessarily have to create a separate closure like `mamHappy`. You may pass directly under `returnBool`.

```
stringFilter(grade: myGrade, returnBool: { grade in
 return grade == "A" })
```

I want it short.

```
stringFilter(grade: myGrade, returnBool: { $0 == “A” })
```

### The Meat and Potato ###

Congratulations, if you’ve come this far, you’ve already made it. I’m thankful for your attention. Let’s now, create a savage, a.k.a a generic filter where you can create a bunch of filters on your own. For example, you can filter a sentence that contains words you don’t like. You can filter an array that is greater 60 but smaller than 100. You can filter Bool which only contains true

The best thing — it justrequires** only one sentence. **We save lives and time. Love it. It’s okay to work hard, but let’s work smart and hard.

### Generic Code ###

*If you are not comfortable with generic code, you are not in the right place just for now. you are in a danger zone. Please go to this safe place called,* “[*Intro to generics with Bob*](https://medium.com/ios-geek-community/intro-to-generics-in-swift-with-bob-df58118a5001#.z61lki1c5) ”, *and then bring some weapons to fight back.*

I’m going to create a generic function whose type is `Bob`. You may use `T` or `U`. But, you know. It’s my article.

```
func myFilter<Bob>(array: [Bob], logic: (Bob) -> Bool) -> [Bob] {
 var result: [Bob] = []
 for element in array {
  if logic(element) {
   result.append(element)
  }
 }
 return result
}
```

Let’s try to find smart students

#### Application to School System ####

```
let AStudent = myFilter(array: Array(1...100), logic: { $0 >= 93 && $0 <= 100 })

print(AStudent) // [93, 94, 95, ... 100]
```

#### Application to vote counting ####

```
let answer = [true, false, true, false, false, false, false]

let trueAnswer = myFilter(array: answer, logic: { $0 == true })

// Trailing Closure 
let falseAnswer = myFilter(array: answer) { $0 == false }
```

### Filter from Swift ###

Fortunately, we don’t have to create `myFilter`. Swift has provided us with a default one. Let’s create an array that contains [1…100] and get only numbers that are even and smaller than 51.

```
let zeroToHund = Array(1…100)
zeroToHund.filter{ $0 % 2 == 0 }.filter { $0 <= 50 })
// [2, 4, 6, 8, 10, 12, 14, ..., 50]
```

> That’s it. [Source Code](https://bobleesj.gitbooks.io/bob-s-learning-journey/content/Content/01_Swift_3/Intro_to_Functional_Programming.html) 

### My Message ###

I’m sure in your head, you are already thinking how you can apply functional approach in your app and programs. Remember, it doesn’t matter which programming language you use.

You have to visualize how you can apply functional paradigm to many other areas. Before you Google, I recommend you to take a moment and spark some brain cells one or two.

Since you understand the principle behind “filter”, you now can easily google and see how `map`, `reduce`, and other functions are made up of. I hope you’ve learned to swim as long as it’s not burning hot or cold.

> You are only limited by your imagination. Keep thinking and Google.

### Last Remarks ###

In my biased opinion, this article is gold. This is what I needed when I was so dumbfounded by closures and functional stuff. People get too fancy for such a simple principle. If you liked my explanation, make sure please share and recommend! The more hears I receive, I get more pumped to produce great contents for everyone! Also, the more hearts means more views based on the Medium algorithm.

*Any geeks on Instagram? I post my daily what’s up and updates. Feel free to add me and say hi me! @*[*bobthedev*](https://instagram.com/bobthedev) 

### Swift Conference ###

One of my Portuguese friends [João](https://twitter.com/NSMyself) , is organizing a Swift conference at Aveiro, Portugal. Unlike many ones out there, this conference was designed to be experimental and engaging. The audience gets to interact and build along with speakers — Bring your laptops guys. It’s my first Swift conference. I’m super excited! On top of that, it is affordable as well. The event will happen on June 1–2, 2017. If you are interested in knowing more, feel free to check out its website [here](http://swiftaveiro.xyz) or Twitter below.

[SwiftAveiro (@SwiftAveiro) | Twitter](https://twitter.com/SwiftAveiro) 

### About Me ###

I give detail updates on my [Facebook Page](https://www.facebook.com/bobthedeveloper). I usually publish articles on Saturdays on 8am EST. In 2017, I dare to grow iOS Geek Community as the #1 iOS blog on Medium.
