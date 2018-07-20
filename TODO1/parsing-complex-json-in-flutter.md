> * 原文地址：[Parsing complex JSON in Flutter](https://medium.com/flutter-community/parsing-complex-json-in-flutter-747c46655f51)
> * 原文作者：[Poojã Bhaumik](https://medium.com/@poojabhaumik?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/parsing-complex-json-in-flutter.md](https://github.com/xitu/gold-miner/blob/master/TODO1/parsing-complex-json-in-flutter.md)
> * 译者：[DateBro](https://github.com/DateBro)
> * 校对者：

# 在 Flutter 中解析复杂的 JSON

![](https://cdn-images-1.medium.com/max/600/1*uyZqUA7yQuJYrHtuDv49Rw.jpeg)

我必须承认，在 Flutter / Dart 中使用 JSON 后，我一直想念 ** _gson_ ** 的 Android 世界。当我开始使用 Flutter 中的 API 时，JSON 解析真的让我很困扰。而且我敢确定，它也让很多初学者感到困惑。

我们将在这篇博客中使用内置的 `dart:convert` 库。这是最基本的解析方法，只有在你刚开始使用 Flutter 或者你正在写一个小项目时才建议使用它。不过，了解一些 Flutter 中 JSON 解析的基础知识非常重要。如果你精通这个，或者你需要写更大的项目时，可以考虑像[json_serializable](https://pub.dartlang.org/packages/json_serializable) 等代码生成器库。如果可能的话，我会在以后的文章中介绍它们。

Fork 这个 [示例项目](https://github.com/PoojaB26/ParsingJSON-Flutter)。它包含这篇博客中的所有代码，你可以对照着实践一下。

### JSON 结构 #1 : 简单的 map

让我们从一个简单的 JSON 结构开始—— [student.json](https://github.com/PoojaB26/ParsingJSON-Flutter/blob/master/assets/student.json)

```
{
  "id":"487349",
  "name":"Pooja Bhaumik",
  "score" : 1000
}
```

**规则 #1 :** **确定结构。Json 字符串将具有 Map（键值对）或 List of Maps。**

**规则 #2 : 用花括号开始？ 这是 map。用方括号开始？ 那是 List of maps。**

`student.json` 明显是 map。(比如，`id` 是 键，`487349` 是 `id` 的值)

让我们为这个 json 结构做一个 PODO（Plain Old Dart Object？）文件。你可以在示例项目的 [student_model.dart](https://github.com/PoojaB26/ParsingJSON-Flutter/blob/master/lib/model/student_model.dart) 文件中找到这段代码。

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

Perfect！
**是这样吗？** 因为 json 映射和这个 PODO 文件之间没有映射。甚至实体名称也不匹配。
**我知道我知道。** 我们还没有完成。我们必须将这些类成员映射到json对象。 为此，我们需要创建一个 `factory` 方法。 根据 Dart 文档，我们在实现一个构造函数时使用 `factory` 关键字时，这个构造函数不会总是创建其类的新实例，而这正是我们现在所需要的。

```
factory Student.fromJson(Map<String, dynamic> parsedJson){
    return Student(
      studentId: parsedJson['id'],
      studentName : parsedJson['name'],
      studentScores : parsedJson ['score']
    );
  }
```

在这里，我们创建了一个叫做 `Student.fromJson` 的工厂方法，用来简单地反序列化你的 json。

**_我是一个小菜鸡，能告诉我反序列化究竟是什么吗？_**

当然。 我们首先要向你介绍序列化和反序列化。 **序列化** 简单来讲就是把数据（可能在对象中）写成字符串，**反序列化** 正好相反。它获取原始数据并重建对象模型。在本文中，我们主要讨论反序列化部分。在第一部分中，我们从 `student.json` 反序列化 json 字符串。

所以我们的工厂方法也可以称为我们的转换器方法。

还必须注意 `fromJson` 方法中的参数。它是一个 `Map <String，dynamic>` 这意味着它将 `String` **键**映射为 `dynamic` **值**。 这正是我们需要识别它结构的原因。 如果这个 json 结构是一个映射列表，那么这个参数会有所不同。

**_但为什么选择动态呢？_** 让我们先看一下另一个 json 结构来回答你的问题。

![](https://cdn-images-1.medium.com/max/800/1*aYehHPUoXS4S-CVLWg1NCQ.png)

`name` 是一个 Map<String，String>，`majors` 是 String 和 List<String> 的 Map，`subject` 是 String 和 List<Object>的 Map。

因为键总是一个 `string` 并且值可以是任何类型，所以我们将它保持为 `dynamic` 以保证安全。

在 [这里](https://github.com/PoojaB26/ParsingJSON-Flutter/blob/master/lib/model/student_model.dart) 检查 `student_model.dart` 的完整代码。

### 访问对象

让我们写 `student_services.dart` ，它具有调用 `Student.fromJson` 的代码，能够从 `Student` 对象中获取值。

#### 片段 #1 : imports

```
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:flutter_json/student_model.dart';
```

最后导入的是你的模型文件名。

#### **片段 #2 : 加载 Json Asset (可选)**

```
Future<String> _loadAStudentAsset() async {
  return await rootBundle.loadString('assets/student.json');
}
```

在这个特定项目中，我们的 json 文件放在 assets 文件夹下，所以我们必须这样加载 json。但如果你的 json 文件放在云端，你也可以进行网络调用。**网络调用不在我们这篇文章的讨论范围内。**

#### 片段 #3 : 加载响应

```
Future loadStudent() async {
  String jsonString = await _loadAStudentAsset();
  final jsonResponse = json.decode(jsonString);
  Student student = new Student.fromJson(jsonResponse);
  print(student.studentScores);
}
```

在 `loadStudent()` 方法中，
**第一行**：从 assets 中加载原始 json 字符串。
**第二行**：解码我们得到的 json 字符串。
**第三行**：现在我们通过调用 `Student.fromJson` 方法反序列化解码的 json 响应，这样我们现在可以使用 `Student` 对象来访问我们的实体。
**第四行**：就像我们在这里做的一样，我们在 `Student` 类里打印了 `studentScores`。

**检查 Flutter 控制台以查看打印的所有值。 （在 Android Studio 中，它在运行选项下）**

瞧！你刚刚完成了第一次 JSON 解析（或没有）。
**注意：请记住这里的 3 个片段，我们将把它用于下一组 json 解析（只更改文件名和方法名），我不会在这里重复代码。但你可以在示例项目中找到所有内容**

### JSON 结构 #2 ：含有数组的简单结构

现在我们要征服一个和上面那个类似的 json 结构，但不是单一值的，它可能有一个值数组。

```
{
  "city": "Mumbai",
  "streets": [
    "address1",
    "address2"
  ]
}
```

所以在这个 [address.json](https://github.com/PoojaB26/ParsingJSON-Flutter/blob/master/assets/address.json) 中，我们有一个包含简单 `String` 值的 `city` 实体，但 `streets`  是一个 `String` 数组。
就我所知，Dart 并没有数组这种数据类型，但它有 List<datatype> 所以这里 `streets`  是一个 `List<String>`。

现在我们要检查一下 **规则#1 和 规则#2**。这绝对是一个 map，因为这是以花括号开头的。`streets` 仍然是一个 `List`，但我们稍后才会考虑这个。

所以 `address_model.dart` 一开始看起来像是这样的

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

现在它是一个 map，我们的 `Address.fromJson` 方法 仍然有一个 `Map<String, dynamic>` 参数。

```
factory Address.fromJson(Map<String, dynamic> parsedJson) {

  return new Address(
      city: parsedJson['city'],
      streets: parsedJson['streets'],
  );
}
```

现在通过添加上面提到的三个代码片段来构造 `address_services.dart`。**必须记住要放入正确的文件名和方法名。示例项目已经为您构建了_ `_address_services.dart_`。**

如果你现在运行它，你会发现一个小错误。:/

```
type 'List<dynamic>' is not a subtype of type 'List<String>'
```

我告诉你，这些错误几乎在我 Dart 开发的每一步中都会出现。你也会遇到它们。那么让我解释一下这是什么意思。我们正在请求 `List <String>` 但我们得到一个 `List <dynamic>` ，因为我们的应用程序还无法识别它的类型。

所以我们必须把这个显式地转换成 `List<String>`。

```
var streetsFromJson = parsedJson['streets'];
List<String> streetsList = new List<String>.from(streetsFromJson);
```

在这里，我们首先把变量映射到 `streetsFromJson` `streets` 实体。 `streetsFromJson` 仍然是一个 `List<dynamic>`。现在我们显式地创造了一个 `List<String> streetsList`，它包含了 **来自** `streetsFromJson`的所有元素。

在[这里](https://github.com/PoojaB26/ParsingJSON-Flutter/blob/master/lib/model/address_model.dart) 检查更新的方法。**注意现在的返回语句。**
现在你可以用 `_address_services.dart_` 来运行它，**它会完美运行。**

### Json 结构 #3 ：简单的嵌套结构

现在如果我们有一个像来自 [shape.json](https://github.com/PoojaB26/ParsingJSON-Flutter/blob/master/assets/shape.json) 的嵌套结构的话会怎样呢？

```
{
  "shape_name":"rectangle",
  "property":{
    "width":5.0,
    "breadth":10.0
  }
}
```

这里，`property`包含一个对象而不是基本的数据类型。
**那么 POOD 看起来会是怎样呢？**

好啦，让我们先休息一会。
在 `shape_model.dart` 中，让我们先为 `Property` 建一个类。

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

现在让我们为 `Shape` 创建一个类。**我将这两个类保存在同一个 Dart 文件中。**

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

注意第二个数据成员 `property` 就是我们前面 `Property` 类的对象。

**规则 #3：对于嵌套结构，首先创建类和构造函数，然后从底层添加工厂方法。**

**在底层上，我的意思是，首先我们征服 `_Property_` 类，然后我们在 `_Shape_` 类上再上一级。当然，这只是我的个人见解，不是 Flutter 规则**

```
factory Property.fromJson(Map<String, dynamic> json){
  return Property(
    width: json['width'],
    breadth: json['breadth']
  );
}
```

**这是一个简单的 map**

但是对于在 `Shape` 类中的工厂方法，我们只能这样做。

```
factory Shape.fromJson(Map<String, dynamic> parsedJson){
  return Shape(
    shapeName: parsedJson['shape_name'],
    property : parsedJson['property']
  );
}
```

`property : parsedJson['property']` 首先，它会抛出一个类型不匹配错误 —

```
type '_InternalLinkedHashMap<String, dynamic>' is not a subtype of type 'Property'
```

其次，**嘿，我们刚刚为 Property 做了了这个优雅的类，我没有看到它在任何地方使用。**

没错，我们必须在这里映射我们的 Property 类。

```
factory Shape.fromJson(Map<String, dynamic> parsedJson){
  return Shape(
    shapeName: parsedJson['shape_name'],
    property: Property.fromJson(parsedJson['property'])
  );
}
```

所以基本上，我们从 `Property` 类调用`Property.fromJson`方法，无论得到什么，我们都将它映射到 `property` 实体。简单！ 在 [he这里](https://github.com/PoojaB26/ParsingJSON-Flutter/blob/master/lib/model/shape_model.dart) 检查你的代码。

用你的 `shape_services.dart` 运行它，你会对运行结果感到满意的。

### JSON structure #4：含有 Lists 的嵌套结构

**让我们检查我们的** [_product.json_](https://github.com/PoojaB26/ParsingJSON-Flutter/blob/master/assets/product.json)

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

好的，现在我们越来越深入了。**哇哦，我在里面看到了一个对象列表。**

是的，所以这个结构有一个对象列表，但它本身仍然是一个地图。（参考**规则 ＃1 **和 **规则 ＃2 **）。现在参考 **规则 ＃3**，让我们构造我们的`product_model.dart`。

现在我们来创建 `Product` 和 `Image` 这两个类。
**注意：** `_Product_` **会有一个数据成员，它是** `_Image_` **的 List**

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

`Image` 的工厂方法会非常简单和基础。

```
factory Image.fromJson(Map<String, dynamic> parsedJson){
 return Image(
   imageId:parsedJson['id'],
   imageName:parsedJson['imageName']
 );
}
```

这里是 `Product` 的工厂方法

```
factory Product.fromJson(Map<String, dynamic> parsedJson){

  return Product(
    id: parsedJson['id'],
    name: parsedJson['name'],
    images: parsedJson['images']
  );
}
```

这里明显会抛出一个 runtime error

```
type 'List<dynamic>' is not a subtype of type 'List<Image>'
```

如果我们这样做，

```
images: Image.fromJson(parsedJson['images'])
```

这也是绝对错误的，它会立即引发错误，因为你无法将 `Image` 对象分配给 `List<Image>`。

所以我们必须创建一个 `List<Image>` 然后将它分配给 `images`

```
var list = parsedJson['images'] as List;
print(list.runtimeType); //returns List<dynamic>
List<Image> imagesList = list.map((i) => Image.fromJson(i)).toList();
```

`list` 在这里是一个 List<dynamic>。现在我们通过调用 `Image.fromJson` 遍历整个列表，并把 `list` 中的每个对象映射到 `Image` 中，然后我们将每个 map 对象放入一个带有 `toList()` 的新列表中，并将它存储在 `List <Image> imagesList`。可以在这里[这里](https://github.com/PoojaB26/ParsingJSON-Flutter/blob/master/lib/model/product_model.dart) 查看完整代码。

### JSON 结构 #5 ：map 列表

现在让我们来看一下 [photo.json](https://github.com/PoojaB26/ParsingJSON-Flutter/blob/master/assets/photo.json)

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

哦，**规则 #1 和 规则 #2** 可以看出这不是一个 map，因为这个 json 字符串以方括号开头。**所以这是一个对象列表？** 是的，这里的对象是 `Photo`（或者你想称之为的任何东西）。

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

**但它是一个 `_Photo_` 列表，所以这意味着你必须创建一个包含 `_List<Photo>_` 的类？**

是的，我建议这样。

```
class PhotosList {
  final List<Photo> photos;

  PhotosList({
    this.photos,
  });
}
```

同时请注意，这个 json 字符串是一个映射列表。因此，在我们的工厂方法中，不会有一个 `Map <String，dynamic>` 参数，因为它是一个 List。这就是为什么首先要确定结构。所以我们的新参数是 `List <dynamic>`。

```
factory PhotosList.fromJson(List<dynamic> parsedJson) {

    List<Photo> photos = new List<Photo>();

    return new PhotosList(
       photos: photos,
    );
  }
```

这样会抛出一个错误。

```
Invalid value: Valid value range is empty: 0
```

嘿，因为我们永远不能使用 `Photo.fromJson` 方法。
如果我们在列表初始化之后添加这行代码会怎样？

```
photos = parsedJson.map((i)=>Photo.fromJson(i)).toList();
```

与前面相同的概念，我们不必把它映射到 json 字符串中的任何键，因为它是 List 而不是 map。 代码在 [这里](https://github.com/PoojaB26/ParsingJSON-Flutter/blob/master/lib/model/photo_model.dart).

### JSON 结构 #6 ：复杂的嵌套结构

这是 [page.json](https://github.com/PoojaB26/ParsingJSON-Flutter/blob/master/assets/page.json).

我会要求你解决这个问题。它已包含在示例项目中。你只需要为此构建模型和服务文件。但是在给你提示之前我不会总结（如果你需要任何提示的话）。

**Rule#1** and **Rule#2** 一样使用。首先确定结构。 这是一个 map。所以 1-5 的所有 json 结构都有用。

**Rule #3** 要求你先创建类和构造函数，然后从底层添加工厂方法。不过还有一个提示，还要记得从深层/底层添加类。例如，对于这个 json 结构，首先为 `Image` 创建类，然后为 `Data` 和 `Author` 创建类，然后创建主类 `Page`。 并以相同的顺序添加工厂方法。

对于 `Image` 和 `Data` 类，参考 **Json 结构 #4**.
对于 `Author` 类，参考 **Json 结构 #3**

**给初学者的建议：在试验任何新 asset 时，请记得在 pubspec.yaml 文件中声明它。**

这就是这篇 Fluttery 文章的内容。这篇文章可能不是最好的 JSON 解析文章（因为我还在学习很多东西），但我希望它能帮助你入门。

* * *

> 我弄错了什么吗？在评论中提一下。我洗耳恭听。

> 如果你学到了一两件点知识，请尽可能多地拍手 👏 以表示你的支持！这会鼓励我写更多的文章。

> Hello World，我是 Pooja Bhaumik。一个有创意的开发人员和理性的设计师。你可以在 [Linkedin](https://www.linkedin.com/in/poojab26/) 或 [GitHub](https://github.com/PoojaB26) 或 [Twitter](https://twitter.com/pblead26) 上关注我？如果这对你来说太 social 了，如果你想和我谈论对科技的想法，请发邮件到 pbhaumik26@gmail.com。

> 祝你度过美好的一天!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
