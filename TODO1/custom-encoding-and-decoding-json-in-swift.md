> * 原文地址：[Custom encoding and decoding JSON in Swift](https://levelup.gitconnected.com/custom-encoding-and-decoding-json-in-swift-a99c80b280e7)
> * 原文作者：[Leandro Fournier](https://medium.com/@lean4nier)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/custom-encoding-and-decoding-json-in-swift.md](https://github.com/xitu/gold-miner/blob/master/TODO1/custom-encoding-and-decoding-json-in-swift.md)
> * 译者：[chaingangway](https://github.com/chaingangway)
> * 校对者：[lsvih](https://github.com/lsvih)

# 在 Swift 中对 JSON 进行自定义编码和解码的小技巧

![](https://cdn-images-1.medium.com/max/2000/0*-t2P3atrbgHMKR6P.jpg)

本文我最早发表在 [Swift Delivery](https://www.leandrofournier.com/custom-encoding-and-decoding-json/)。

在最近的 [Working with JSON in Swift series](https://levelup.gitconnected.com/working-with-json-in-swift-c5faea0b19a1) 文章中，我们学习了这些知识点：

* `Codable` 协议，它还包含另外两个协议: `Encodable` 和 `Decodable`。
* 如何将 JSON 数据对象解析成具有可读性的 Swift 结构体。
* 自定义 key 的使用。
* 自定义对象的创建。
* 数组
* 各种一级实体

通过了解这些，你能掌握 Swift 中 JSON 的基本使用。比如，你可以读取 JSON 数据（解码），创建可以被转换为 JSON 格式的对象（编码），然后把这个对象发送给 RestFul API。

首先，我们来创建一个对象，把它转换成 JSON 数据格式。

## 编码

#### 默认编码

下面的代码中定义了 Insect 结构体:

```swift
struct Insect: Codable {
    let insectId: Int
    let name: String
    let isHelpful: Bool
    
    enum CodingKeys: String, CodingKey {
        case insectId = "insect_id"
        case name
        case isHelpful = "is_helpful"
    }
}
```

结构体中一共有三个属性。**insectId** 表示昆虫的身份，**name** 表示昆虫的名称，**isHelpful** 表示昆虫是否对我们的花园有益。其中两个属性使用了自定义 key（**insectId** 和 **isHelpful**）。

现在我们新建一个昆虫实例：

```swift
let newInsect = Insect(insectId: 1006, name: "ants", isHelpful: true)
```

我们的 RESTFul API 需要接收 JSON 格式的昆虫数据，所以我们需要对它进行编码:

```swift
let encoder = JSONEncoder() 
let insectData: Data? = try? encoder.encode(newInsect)
```

这一步很简单：现在 **insectData** 已经是 `Data?` 类型。我们可能还想检查一下编码是否真的生效了（只是一个验证，你在写代码时可以不必这样）。我们用解包的方式来重构上面的代码：

```swift
let encoder = JSONEncoder()
if let insectData = try? encoder.encode(newInsect),
    let jsonString = String(data: insectData, encoding: .utf8)
    {
    print(jsonString)
}
```

1. 创建 encoder。
2. 尝试对我们创建的对象编码。
3. 进行转换，如果编码成功的话，`Data` 对象会变成 `String` 类型。

我们打印一下结果，它的格式如下：

```json
{"name":"ants","is_helpful":true,"insect_id":1006}
```

> 注意编码时的 key 不是自定义的 key（**insectId** 和 **isHelpful**），而是我们希望的 key（**insect_id** 和 **is_helpful**）。太棒了！

#### 自定义编码

假设 RESTful API 需要接受大写名称的昆虫数据。我们就需要实现自己的编码方法，来保证昆虫名称是大写的。要这样做的话，我们就必须在 **Insect** 结构体中实现 `Encodable` 协议中的 **func** encode(to encoder: Encoder) **throws** 方法。

```swift
struct Insect: Codable {
    let insectId: Int
    let name: String
    let isHelpful: Bool
    
    enum CodingKeys: String, CodingKey {
        case insectId = "insect_id"
        case name
        case isHelpful = "is_helpful"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self) // 13
        try container.encode(insectId, forKey: .insectId) // 14
        try container.encode(name.uppercased(), forKey: .name) // 15
        try container.encode(isHelpful, forKey: .isHelpful) // 16
    }
}
```

第 13 行我们创建了一个用于存储编码数据的容器。这个容器必须是 `var` 类型，它要接收这些 key，因此是可变类型的。

第 14 到 16 行是把数据进行编码后，存储到容器中。每一次存储都可能抛出异常，所以这里用到了 `try`。

现在，看第 15 行：我们没有原封不动地把数据存储，而是对其进行了大写处理。这就是我们要实现自定义编码的主要原因。

运行上面的代码后，你会发现 **Insect** 中的“ants”属性在编码转换成 JSON 字符串后，格式是下面这样的：

```
{"name":"ANTS","is_helpful":true,"insect_id":1006}
```

即使昆虫名称的初始值是小写的，现在它的名称也变成了大写。这太酷了！

## 自定义解码

目前为止，我们一直都依赖 `Decodable` 协议中默认的解码方法。下面我们来看看另外的方法：

```json
[
   {
      "insect_id":1001,
      "name":"BEES",
      "details":{
         "is_helpful":true
      }
   },
   {
      "insect_id":1002,
      "name":"LADYBUGS",
      "details":{
         "is_helpful":true
      }
   },
   {
      "insect_id":1003,
      "name":"SPIDERS",
      "details":{
         "is_helpful":true
      }
   },
   {
      "insect_id":2001,
      "name":"TOMATO HORN WORMS",
      "details":{
         "is_helpful":false
      }
   },
   {
      "insect_id":2002,
      "name":"CABBAGE WORMS",
      "details":{
         "is_helpful":false
      }
   },
   {
      "insect_id":2003,
      "name":"CABBAGE MOTHS",
      "details":{
         "is_helpful":false
      }
   }
]
```

API 获取的 **is_helpful** 属性在 **details** 实体内部。但是我们不想创建 **Details** 对象，我们只想展开它，这样就可以直接用现有的 **Insect** 对象了。

现在我们要实现 `Decodable` 协议中的 **init**(from decoder: Decoder) **throws** 方法，然后做一些额外处理。

首先，key 不一样了，**is_helpful** 不是同级的 key了，这里新的 key 是 **details**。我们这样编写代码：

```swift
enum CodingKeys: String, CodingKey {
        case insectId = "insect_id"
        case name
        case details // 4
    }
    
    enum DetailsCodingKeys: String, CodingKey { // 7
        case isHelpful = "is_helpful" // 8
    } // 9
```

第 4 行，我们用 **details** 替换了之前的 key。

第 7 行到第 9 行，我们新建了一个枚举，对应 **details** 内部的 key，在本例中，只有一个 **isHelpful**。

> 注意我们还没有接触到 **Insect** `结构体`的属性。

下面我们深入了解一下解码的初始化方法:

```swift
init(from decoder: Decoder) throws {
   let container = try decoder.container(keyedBy: CodingKeys.self) // 2
        
   insectId = try container.decode(Int.self, forKey: .insectId) // 4
   name = try container.decode(String.self, forKey: .name) // 5
   let details = try container.nestedContainer(keyedBy: DetailsCodingKeys.self, forKey: .details) // 6
   isHelpful = try details.decode(Bool.self, forKey: .isHelpful) // 7
}
```

第 2 行中我们创建了用于解析整个 JSON 结构的容器。

第 4 行和第 5 行，我们解析了 **insectId** 属性的 `Int` 数据和 **name** 属性的 `String` 数据。 

第 6 行，我们获得了 **details** key 内部的容器，容器内的 key 是通过 **DetailsCodingKeys** `枚举`创建的。

第 7 行，我们在 **details** 的容器中解析了 **isHelpful** 属性的 `Bool` 数据。

但是事情还没有做完。我们在 **CodingKeys** 中加入了 **details**，所以我们自定义的编码方法也要如下修改：

```swift
func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(insectId, forKey: .insectId)
    try container.encode(name.uppercased(), forKey: .name)
    var details = container.nestedContainer(keyedBy: DetailsCodingKeys.self, forKey: .details) // 5
    try details.encode(isHelpful, forKey: .isHelpful) // 6
}
```

我们只用修改 **isHelpful** 属性的编码方式就可以了。
 
在第 5 行中我们用 **DetailsCodingKeys** `枚举`作为 key 创建了一个内部容器，用于在 **details** 实体的内部使用。

第 6 行我们在新建的 **details** 内部容器中对 **isHelpful** 进行编码。

所以，最终的 **Insect** `结构体`是这样的：

```swift
struct Insect: Codable {
    let insectId: Int
    let name: String
    let isHelpful: Bool
    
    enum CodingKeys: String, CodingKey {
        case insectId = "insect_id"
        case name
        case details
    }
    
    enum DetailsCodingKeys: String, CodingKey {
        case isHelpful = "is_helpful"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        insectId = try container.decode(Int.self, forKey: .insectId)
        name = try container.decode(String.self, forKey: .name)
        let details = try container.nestedContainer(keyedBy: DetailsCodingKeys.self, forKey: .details)
        isHelpful = try details.decode(Bool.self, forKey: .isHelpful)
        
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(insectId, forKey: .insectId)
        try container.encode(name.uppercased(), forKey: .name)
        var details = container.nestedContainer(keyedBy: DetailsCodingKeys.self, forKey: .details)
        try details.encode(isHelpful, forKey: .isHelpful)
    }
}
```

下面开始解码：

```swift
let decoder = JSONDecoder()
if let insects = try? decoder.decode([Insect].self, from: jsonData!) {
    print(insects)
}
```

我们会得到下面的结果：

```
[__lldb_expr_54.Insect(insectId: 1001, name: "BEES", isHelpful: true), __lldb_expr_54.Insect(insectId: 1002, name: "LADYBUGS", isHelpful: true), __lldb_expr_54.Insect(insectId: 1003, name: "SPIDERS", isHelpful: true), __lldb_expr_54.Insect(insectId: 2001, name: "TOMATO HORN WORMS", isHelpful: false), __lldb_expr_54.Insect(insectId: 2002, name: "CABBAGE WORMS", isHelpful: false), __lldb_expr_54.Insect(insectId: 2003, name: "CABBAGE MOTHS", isHelpful: false)]
```

你可以看到，并没有 **details** 实体，只有 `结构体` 的属性。

编码流程也是正常的。

本文和之前的一系列文章，总结了很多在 Swift 中处理 JSON 最常见的场景。

## 更多内容

推荐 Ben Scheirman 写的 [Ultimate Guide to JSON Parsing with Swift](https://benscheirman.com/2017/06/swift-json/) 这篇文章，它是与本文主题相关最实用的资料。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
