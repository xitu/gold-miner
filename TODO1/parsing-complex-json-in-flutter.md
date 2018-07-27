> * 原文地址：[Parsing complex JSON in Flutter](https://medium.com/flutter-community/parsing-complex-json-in-flutter-747c46655f51)
> * 原文作者：[Poojã Bhaumik](https://medium.com/@poojabhaumik?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/parsing-complex-json-in-flutter.md](https://github.com/xitu/gold-miner/blob/master/TODO1/parsing-complex-json-in-flutter.md)
> * 译者：
> * 校对者：

# Parsing complex JSON in Flutter

![](https://cdn-images-1.medium.com/max/600/1*uyZqUA7yQuJYrHtuDv49Rw.jpeg)

I have to admit, I was missing the **_gson_** world of Android after working with JSON in Flutter/Dart. When I started working with APIs in Flutter, JSON parsing really had me struggle a lot. And I’m certain, it confuses a lot of you beginners.

We will be using the built in `dart:convert` library for this blog. This is the most basic parsing method and it is only recommended if you are starting with Flutter or you’re building a small project. Nevertheless, knowing the basics of JSON parsing in Flutter is pretty important. When you’re good at this, or if you need to work with a larger project, consider code generator libraries like [json_serializable](https://pub.dartlang.org/packages/json_serializable), etc. If possible, I will discover them in the future articles.

Fork this [sample project](https://github.com/PoojaB26/ParsingJSON-Flutter). It has all the code for this blog that you can experiment with.

### JSON structure #1 : Simple map

Let’s start with a simple JSON structure from [student.json](https://github.com/PoojaB26/ParsingJSON-Flutter/blob/master/assets/student.json)

```
{
  "id":"487349",
  "name":"Pooja Bhaumik",
  "score" : 1000
}
```

**Rule #1 :** **Identify the structure. Json strings will either have a Map (key-value pairs) or a List of Maps.**

**Rule #2 : Begins with curly braces? It’s a map.  
Begins with a Square bracket? That’s a List of maps.**

`student.json` is clearly a map. ( E.g like, `id` is a key, and `487349` is the value for `id`)

Let’s make a PODO (Plain Old Dart Object?) file for this json structure. You can find this code in [student_model.dart](https://github.com/PoojaB26/ParsingJSON-Flutter/blob/master/lib/model/student_model.dart) in the sample project.

```
class Student{
  String studentId;
  String studentName;
  int studentScores;

  Student({
    this.studentId,
    this.studentName,
    this.studentScores
 });
}
```

Perfect!  
_Was it? Because there was no mapping between the json maps and this PODO file. Even the entity names don’t match.  
_I know, I know. We are not done yet. We have to do the work of mapping these class members to the json object. For that, we need to create a `factory` method. According to Dart documentation, we use the `factory` keyword when implementing a constructor that doesn’t always create a new instance of its class and that’s what we need right now.

```
factory Student.fromJson(Map<String, dynamic> parsedJson){
    return Student(
      studentId: parsedJson['id'],
      studentName : parsedJson['name'],
      studentScores : parsedJson ['score']
    );
  }
```

Here, we are creating a factory method called `Student.fromJson` whose objective is to simply deserialize your json.

**_I’m a little noob, can you tell me about Deserialization?_**

Sure. Let’s tell you about Serialization and Deserialization first. **Serialization** simply means writing the data(which might be in an object) as a string, and **Deserialization** is the opposite of that. It takes the raw data and reconstructs the object model. In this article, we mostly will be dealing with the deserialization part. In this first part, we are deserializing the json string from `student.json`

So our factory method could be called as our converter method.

Also must notice the parameter in the `fromJson` method. It’s a `Map<String, dynamic>` It means it maps a `String` **key** with a `dynamic` **value**. That’s exactly why we need to identify the structure. If this json structure were a List of maps, then this parameter would have been different.

**_But why dynamic?_**Let’s look at another json structure first to answer your question.

![](https://cdn-images-1.medium.com/max/800/1*aYehHPUoXS4S-CVLWg1NCQ.png)

`name` is a Map<String, String> ,`majors` is a Map of String and List<String> and `subjects` is a Map of String and List<Object>

Since the key is always a `string` and the value can be of any type, we keep it as `dynamic` to be on the safe side.

Check the full code for `student_model.dart` [here](https://github.com/PoojaB26/ParsingJSON-Flutter/blob/master/lib/model/student_model.dart).

### Accessing the object

Let’s write `student_services.dart` which will have the code to call `Student.fromJson` and retrieve the values from the `Student` object.

#### Snippet #1 : imports

```
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:flutter_json/student_model.dart';
```

The last import will be the name of your model file.

#### **Snippet #2 : load Json Asset (optional)**

```
Future<String> _loadAStudentAsset() async {
  return await rootBundle.loadString('assets/student.json');
}
```

In this particular project, we have our json files in the assets folder, so we have to load the json in this way. But if you have your json file on the cloud, you can do a network call instead. _Network calls are out of the scope of this article._

#### Snippet #3 : load the response

```
Future loadStudent() async {
  String jsonString = await _loadAStudentAsset();
  final jsonResponse = json.decode(jsonString);
  Student student = new Student.fromJson(jsonResponse);
  print(student.studentScores);
}
```

In this `loadStudent()` method,  
**Line 1** : loading the raw json String from the assets.  
**Line 2** : Decoding this raw json String we got.  
**Line 3** : And now we are deserializing the decoded json response by calling the `Student.fromJson` method so that we can now use `Student` object to access our entities.  
**Line 4** : Like we did here, where we printed `studentScores` from `Student` class.

_Check your Flutter console to see all your print values. (In Android Studio, its under Run tab)_

And voila! You just did your first JSON parsing (or not).  
_Note: Remember the 3 snippets here, we will be using it for the next set of json parsing (only changing the filenames and method names), and I won’t be repeating the code again here. But you can find everything in the sample project anyway._

### JSON structure #2 : Simple structure with arrays

Now we conquer a json structure that is similar to the one above, but instead of just single values, it might also have an array of values.

```
{
  "city": "Mumbai",
  "streets": [
    "address1",
    "address2"
  ]
}
```

So in this [address.json](https://github.com/PoojaB26/ParsingJSON-Flutter/blob/master/assets/address.json), we have `city` entity that has a simple `String` value, but `streets` is an array of `String`.  
As far as i know, Dart doesn’t have an array data type, but instead has a List<datatype> so here `streets` will be a `List<String>`.

Now we have to check **Rule#1 and Rule#2** . This is definitely a map since this starts with a curly brace. `streets` is still a `List` though, but we will worry about that later.

So the `address_model.dart` initially will look like this

```
class Address {
  final String city;
  final List<String> streets;

  Address({
    this.city,
    this.streets
  });
}
```

Now since this is a map, our `Address.fromJson` method will still have a `Map<String, dynamic>` parameter.

```
factory Address.fromJson(Map<String, dynamic> parsedJson) {
  
  return new Address(
      city: parsedJson['city'],
      streets: parsedJson['streets'],
  );
}
```

Now construct the `address_services.dart` by adding the 3 snippets we mentioned above. _Must remember to put the proper file names and method names. Sample project already has_ `_address_services.dart_` _constructed for you._

Now when you run this, you will get a nice little error. :/

```
type 'List<dynamic>' is not a subtype of type 'List<String>'
```

I tell you, these errors have come in almost every step of my development with Dart. And you will have them too. So let me explain what this means. We are requesting a `List<String>` but we are getting a `List<dynamic>` because our application cannot identify the type yet.

So we have to explicitly convert this to a `List<String>`

```
var streetsFromJson = parsedJson['streets'];
List<String> streetsList = new List<String>.from(streetsFromJson);
```

Here, first we are mapping our variable `streetsFromJson` to the `streets` entity. `streetsFromJson` is still a `List<dynamic>`. Now we explicitly create a new `List<String> streetsList` that contains all elements **from** `streetsFromJson`.

Check the updated method [here](https://github.com/PoojaB26/ParsingJSON-Flutter/blob/master/lib/model/address_model.dart). _Notice the return statement now.  
Now you can run this with_ `_address_services.dart_` _and this will work perfectly._

### Json structure #3 : Simple Nested structures

Now what if we have a nested structure like this from [shape.json](https://github.com/PoojaB26/ParsingJSON-Flutter/blob/master/assets/shape.json)

```
{
  "shape_name":"rectangle",
  "property":{
    "width":5.0,
    "breadth":10.0
  }
}
```

Here, `property` contains an object instead of a basic primitive data-type.  
_So how will the PODO look like?_

Okay, let’s break down a little.  
In our `shape_model.dart` , let’s make a class for `Property` first.

```
class Property{
  double width;
  double breadth;

  Property({
    this.width,
    this.breadth
});
}
```

Now let’s construct the class for `Shape`. _I am keeping both classes in the same Dart file._

```
class Shape{
  String shapeName;
  Property property;

  Shape({
    this.shapeName,
    this.property
  });
}
```

Notice how the second data member `property` is basically an object of our previous class `Property`.

**Rule #3: For nested structures, make the classes and constructors first, and then add the factory methods from bottom level.**

_By bottom level, we mean, first we conquer_ `_Property_` _class, and then we go one level above to the_ `_Shape_` _class. This is just my suggestion, not a Flutter rule._

```
factory Property.fromJson(Map<String, dynamic> json){
  return Property(
    width: json['width'],
    breadth: json['breadth']
  );
}
```

_This was a simple map._

But for our factory method at `Shape` class, we cant just do this.

```
factory Shape.fromJson(Map<String, dynamic> parsedJson){
  return Shape(
    shapeName: parsedJson['shape_name'],
    property : parsedJson['property']
  );
}
```

`property : parsedJson['property']` First, this will throw the type mismatch error —

```
type '_InternalLinkedHashMap<String, dynamic>' is not a subtype of type 'Property'
```

And second, _hey we just made this nice little class for Property, I don’t see it’s usage anywhere._

Right. We must map our Property class here.

```
factory Shape.fromJson(Map<String, dynamic> parsedJson){
  return Shape(
    shapeName: parsedJson['shape_name'],
    property: Property.fromJson(parsedJson['property'])
  );
}
```

So basically, we are calling the `Property.fromJson` method from our `Property` class and whatever we get in return, we map it to the `property` entity. Simple! Check out the code [here](https://github.com/PoojaB26/ParsingJSON-Flutter/blob/master/lib/model/shape_model.dart).

Run this with your `shape_services.dart` and you are good to go.

### JSON structure #4 : Nested structures with Lists

_Let’s check our_ [_product.json_](https://github.com/PoojaB26/ParsingJSON-Flutter/blob/master/assets/product.json)

```
{
  "id":1,
  "name":"ProductName",
  "images":[
    {
      "id":11,
      "imageName":"xCh-rhy"
    },
    {
      "id":31,
      "imageName":"fjs-eun"
    }
  ]
}
```

Okay, now we are getting deeper. _I see a list of objects somewhere inside. Woah._

Yes, so this structure has a List of objects, but itself is still a map. (Refer **Rule #1**, and **Rule #2**) . Now referring to **Rule #3**, let’s construct our `product_model.dart`.

So we create two new classes `Product` and `Image`.  
_Note:_ `_Product_` _will have a data member that is a List of_ `_Image_`

```
class Product {
  final int id;
  final String name;
  final List<Image> images;

  Product({this.id, this.name, this.images});
}

class Image {
  final int imageId;
  final String imageName;

  Image({this.imageId, this.imageName});
}
```

The factory method for `Image` will be quite simple and basic.

```
factory Image.fromJson(Map<String, dynamic> parsedJson){
 return Image(
   imageId:parsedJson['id'],
   imageName:parsedJson['imageName']
 );
}
```

Now for the factory method for `Product`

```
factory Product.fromJson(Map<String, dynamic> parsedJson){

  return Product(
    id: parsedJson['id'],
    name: parsedJson['name'],
    images: parsedJson['images']
  );
}
```

This will obviously throw a runtime error

```
type 'List<dynamic>' is not a subtype of type 'List<Image>'
```

And if we do this,

```
images: Image.fromJson(parsedJson['images'])
```

This is also definitely wrong, and it will throw you an error right away because you cannot assign an `Image` object to a `List<Image>`

So we have to create a `List<Image>` and then assign it to `images`

```
var list = parsedJson['images'] as List;
print(list.runtimeType); //returns List<dynamic>
List<Image> imagesList = list.map((i) => Image.fromJson(i)).toList();
```

`list` here is a List<dynamic>. Now we iterate over the list and map each object in `list` to `Image` by calling `Image.fromJson` and then we put each map object into a new list with `toList()` and store it in `List<Image> imagesList`. Find the full code [here](https://github.com/PoojaB26/ParsingJSON-Flutter/blob/master/lib/model/product_model.dart).

### JSON structure #5 : List of maps

Now let’s head over to [photo.json](https://github.com/PoojaB26/ParsingJSON-Flutter/blob/master/assets/photo.json)

```
[
  {
    "albumId": 1,
    "id": 1,
    "title": "accusamus beatae ad facilis cum similique qui sunt",
    "url": "http://placehold.it/600/92c952",
    "thumbnailUrl": "http://placehold.it/150/92c952"
  },
  {
    "albumId": 1,
    "id": 2,
    "title": "reprehenderit est deserunt velit ipsam",
    "url": "http://placehold.it/600/771796",
    "thumbnailUrl": "http://placehold.it/150/771796"
  },
  {
    "albumId": 1,
    "id": 3,
    "title": "officia porro iure quia iusto qui ipsa ut modi",
    "url": "http://placehold.it/600/24f355",
    "thumbnailUrl": "http://placehold.it/150/24f355"
  }
]
```

Uh, oh. **Rule #1 and Rule #2** tells me this can’t be a map because the json string starts with a square bracket. _So this is a List of objects?_ Yes. The object being here is `Photo` (or whatever you’d like to call it).

```
class Photo{
  final String id;
  final String title;
  final String url;

  Photo({
    this.id,
    this.url,
    this.title
}) ;

  factory Photo.fromJson(Map<String, dynamic> json){
    return new Photo(
      id: json['id'].toString(),
      title: json['title'],
      url: json['json'],
    );
  }
}
```

_But its a list of_ `_Photo_` _, so does this mean you have to build a class that contains a_ `_List<Photo>_`_?_

Yes, I would suggest that.

```
class PhotosList {
  final List<Photo> photos;

  PhotosList({
    this.photos,
  });
}
```

Also notice, this json string is a List of maps. So, in our factory method, we won’t have a `Map<String, dynamic>` parameter, because it’s a List. And that is exactly why it’s important to identify the structure first. So our new parameter would be a `List<dynamic>`.

```
factory PhotosList.fromJson(List<dynamic> parsedJson) {

    List<Photo> photos = new List<Photo>();

    return new PhotosList(
       photos: photos,
    );
  }
```

This would throw an error

```
Invalid value: Valid value range is empty: 0
```

Hey, because we never could use the `Photo.fromJson` method.  
What if we add this line of code after our list initialization?

```
photos = parsedJson.map((i)=>Photo.fromJson(i)).toList();
```

Same concept as earlier, we just don’t have to map this to any key from the json string, because it’s a List, not a map. Code [here](https://github.com/PoojaB26/ParsingJSON-Flutter/blob/master/lib/model/photo_model.dart).

### JSON structure #6 : Complex nested structures

Here is [page.json](https://github.com/PoojaB26/ParsingJSON-Flutter/blob/master/assets/page.json).

I will request you to solve this. It is already included in the sample project. You just have to build the model and services file for this. But I won’t conclude before giving you hints and tips (if case, you need any).

**Rule#1** and **Rule#2** as usual applies. Identify the structure first. Here it is a map. So all the json structures from 1–5 will help.

**Rule #3** asks you to make the classes and constructors first, and then add the factory methods from bottom level. Just another tip. Also add the classes from the deep/bottom level. For e.g, for this json structure, make the class for `Image` first, then `Data` and `Author` and then the main class `Page`. And add the factory methods also in the same sequence.

For class `Image` and `Data` refer to **Json structure #4**.  
For class `Author` refer to **Json structure #3**

_Beginner’s tip: While experimenting with any new assets, remember to declare it in the pubspec.yaml file._

And that’s it for this Fluttery article. This article may not be the best JSON parsing article out there, (because I’m still learning a lot) but I hope it got you started.

* * *

> I got something wrong? Mention it in the comments. I would love to improve.

> If you learnt even a thing or two, clap your hands 👏 as many times as you can to show your support! This motivates me to write more.

> Hello World, I am Pooja Bhaumik. A creative developer and a logical designer. You can find me on [Linkedin](https://www.linkedin.com/in/poojab26/) or stalk me on [GitHub](https://github.com/PoojaB26) or maybe follow me on [Twitter](https://twitter.com/pblead26)? If that’s too social for you, just drop a mail to pbhaumik26@gmail.com if you wish to talk tech with me.

> Have a nice fluttery day!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
