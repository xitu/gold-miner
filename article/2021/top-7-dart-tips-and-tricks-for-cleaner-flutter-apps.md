> * 原文地址：[Top 7 Dart Tips and Tricks for Cleaner Flutter Apps](https://betterprogramming.pub/top-7-dart-tips-and-tricks-for-cleaner-flutter-apps-562664a15826)
> * 原文作者：[The Educative Team](https://medium.com/@educative-inc)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/top-7-dart-tips-and-tricks-for-cleaner-flutter-apps.md](https://github.com/xitu/gold-miner/blob/master/article/2021/top-7-dart-tips-and-tricks-for-cleaner-flutter-apps.md)
> * 译者：
> * 校对者：

# Top 7 Dart Tips and Tricks for Cleaner Flutter Apps

![Photo by [Lucie Hošová](https://unsplash.com/@marjorylucabaxter?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) on [Unsplash](https://unsplash.com/s/photos/dart?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)](https://cdn-images-1.medium.com/max/10368/1*UkUGENyS23H0pweg_EdyNg.jpeg)

[Dart](https://www.educative.io/blog/dart-2-language-features) is a client-optimized programming language for quickly building mobile, desktop, and server apps. Dart was developed by Google to be used with their cross-platform Flutter framework. With Flutter and Dart, you can build apps with a slick UI and a native feel.

Today we offer our top seven Dart tips that will help you improve your app development. You can use these tips to write concise code and make the most of the many features that Dart has to offer.

**Tips and tricks at a glance:**

1. Use anonymous functions as arguments
2. Use the `call` method to make classes callable like a function
3. Use `.entries` to iterate through a map
4. How to use getters and setters
5. Use a `Set` for a collection of unique items
6. Make use of the inspect widget
7. Use sync and async generators

## 1. Use Anonymous Functions as Arguments

In the Dart language, functions can be passed as arguments to other functions. Dart provides anonymous functions that do not need a name and can be used directly.

Below is an example of an anonymous function in Dart. Here, we pass an anonymous cube function to a built-in method `forEach`. We are trying to get the cube for every item in a list.

```Dart
main() {
  var list = [1,2,3];
  list.forEach((item) {
   print(item*item*item);
  });
}
```

`sayHello` is passed to the `intro` function, which takes the function argument. On line 6, `String Function(String)` is a function type that returns a string from a given string argument. The anonymous function we use has the same signature, so it is passed as an argument.

## 2. Use the call Method To Make Classes Callable Like a Function

With Dart, you can create a callable class that allows that class instance to be called as a function. We do this with the `call()` method. See the syntax below.

```Dart
class class_name {
  ... // class 
  
  return_type call ( parameters ) {
    ... // call the function content
  }
  
}
```

Let’s see this in action with an example.

```Dart
class EducativeIntro { 
    
  // Defining call method 
  String call(String a, String b, String c) => 'Welcome to $a$b$c'; 
} 
  
// Main Function 
void main() { 
  var educative_input = EducativeIntro(); 
    
  // Calling the class through its instance 
  var educative_output = educative_input('our ', 'Dart ', 'tutorial'); 
    
  print(educative_output); 
}
```

> **Note:** Dart doesn’t support multiple callable methods.

## 3. Use entries To Iterate Through a Map

In Dart, you can iterate through a map in a null-safe manner using `entries`. Say we have a map that tracks the amount of money spent on different products. Typically, we’d iterate through this map with the `!` operator.

```Dart
for (var key in moneySpent.keys) {
  final value = moneySpent[key]!;
  print('$key: $value');
}
```

We can improve this code and make it more null-safe using a loop. When we iterate with the `entries` variable, we can access our key-value pairs in a null-safe manner.

```Dart
for (var entry in moneySpent.entries) {
  // do something with keys and values
  print('${entry.key}: ${entry.value}');
}
```

## 4. How To Use Getters and Setters

Getters and setters are special methods that provide read and write access to an object’s properties. Getters and setters are called similar to instance variables: a dot operator (`.`) simply followed by the function name.

Getters are functions that are used to retrieve the values of an object’s properties. We use the `get` keyword.

Below is an example where we create a getter function on line 13 that will return the value of the name of the current instance. On line 21, we call the getter function and the output should display `Sarah`.

```Dart
class Person{
  String name; 
  String gender; 
  int age; 
  
  Person(this.name, this.gender, this.age);
Person.newBorn(){
    this.age = 0;
  }
// Getter function getting the value of name
  String get personName => name;
walking() => print('$name is walking');
  talking() => print('$name is talking');
}
int main() {
  var firstPerson = Person("Sarah","Female",25);
  print(firstPerson.personName);
}
```

Setters are functions that are used to write the values of an object’s properties. We use the `set` keyword.

```Dart
class Person{
  String name; 
  String gender; 
  int age;
String get personName => name;
// Setter function for setting the value of age
  void set personAge(num val){
    if(val < 0){
      print("Age cannot be negative");
    } else {
      this.age = val;
    }
  }
walking() => print('$name is walking');
  talking() => print('$name is talking');
}
int main() {
  var firstPerson = Person();
  firstPerson.personAge = -5;
  print(firstPerson.age);
}
```

From line 9 to line 15, we create a setter function that sets the value for `age`. We also give it a condition so that we cannot input a negative age. And on line 23, we set the value of age for `firstPerson` using the `personAge` setter function.

## 5. Use a Set for a Collection of Unique Items

A list is one of the most common collection types in Dart, but lists can hold duplicate items. Sometimes we want only a collection of unique values. This is where a `Set` is useful.

```Dart
final countriesSet = {
'USA',
'India',
'Iceland',
'USA',
};
```

In a `Set`, two elements cannot be equal, so the code above will offer a warning and it won’t compile. This is also true if we use `const set`.

## 6. Make Use of the Inspect Widget

In web development, it’s common to use the Inspect element, which will tell you all the properties applied to an HTML tag. Dart provides a similar feature called the Inspect Widget that can make app development with Flutter easier. The Flutter Widget Inspector can be used to locate any widget on the screen and view the properties applied to it.

The inspector can also help you visualize Flutter widget trees to understand layouts or identify layout issues.

To use it, follow these steps:

* Click on the “Flutter inspector.”
* Click on the “Enable Select Widget Mode.”
* Select a widget on the screen to get more information on it

![](https://cdn-images-1.medium.com/max/4920/1*8HtnC_I_iMewckScC92stA.png)

## 7. Use Sync and Async Generators

In Dart, generators make it possible to produce a sequence of values. There are two generator functions:

* **Synchronous generator:** returns an iterable object
* **Asynchronous generator:** returns a Stream object

In other words, the synchronous generator returns a collection of values that can be accessed sequentially. We do this by marking the function body as `sync*`. Then, we use yield statements for the values.

```Dart
Iterable<int> count(int n) sync* {
  for (var i = 1; i <= n; i++) {
    yield i;
  }
}
```

The asynchronous generator, on the other hand, returns a Stream object. A Stream makes it possible to receive a sequence of events. We do this by marking the function body as `async*`. Then, we use yield statements for the values.

```Dart
Stream<int> countStream(int n) async* {
  for (var i = 1; i <= n; i++) {
    yield i;
  }
}
```

## Next Steps for Your Learning

We hope these tips help you make the most of Dart and all the features it offers. Flutter and Dart are a powerful pair for building apps that feel native and slick. Other advanced Dart tools to investigate next are:

* Spread operators for nested `if` statements
* Named constructors and initializer lists
* Dart libraries
* Enumerated types

Happy learning!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
