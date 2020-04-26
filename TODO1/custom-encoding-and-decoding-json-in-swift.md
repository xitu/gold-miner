> * 原文地址：[Custom encoding and decoding JSON in Swift](https://levelup.gitconnected.com/custom-encoding-and-decoding-json-in-swift-a99c80b280e7)
> * 原文作者：[Leandro Fournier](https://medium.com/@lean4nier)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/custom-encoding-and-decoding-json-in-swift.md](https://github.com/xitu/gold-miner/blob/master/TODO1/custom-encoding-and-decoding-json-in-swift.md)
> * 译者：
> * 校对者：

# Custom encoding and decoding JSON in Swift

![](https://cdn-images-1.medium.com/max/2000/0*-t2P3atrbgHMKR6P.jpg)

> This post was originally written by me at [Swift Delivery](https://www.leandrofournier.com/custom-encoding-and-decoding-json/).

In our last [Working with JSON in Swift series](https://levelup.gitconnected.com/working-with-json-in-swift-c5faea0b19a1), we explore various items:

* `Codable` protocol, which contains two other protocols: `Encodable` and `Decodable`
* How to decode a JSON data object into a readable Swift struct
* Usage of custom keys
* Custom objects creation
* Arrays
* Different top level entities

That’s enough for a basic usage of JSON in Swift, which will enable us to read JSON data (decode) and create a new object which can be converted back to JSON (encode) and send it, for instance, to a RESTFul API.

So, first things first: let’s create an object and convert it to a JSON data format.

## Encoding

#### Default encoding

Let’s assume we have the following `struct` for insects:

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

To sum up, we have three properties. **insectId** for the insect identifier, **name** for its name and **isHelpful** to specify if the insect is helpful or not to our garden. Two of these properties use custom keys (**insectId** and **isHelpful**).

Now let’s create an insect:

```swift
let newInsect = Insect(insectId: 1006, name: "ants", isHelpful: true)
```

Our RESTful API expects to receive a JSON with this new insect information. Then we have to encode it:

```swift
let encoder = JSONEncoder() 
let insectData: Data? = try? encoder.encode(newInsect)
```

That was easy: now **insectData** is an object of type `Data?`. We might want to check whether the encoding actually worked (just a check, you probably won't do this in your code). Let's rewrite the code above and use some optional unwrapping:

```swift
let encoder = JSONEncoder()
if let insectData = try? encoder.encode(newInsect),
    let jsonString = String(data: insectData, encoding: .utf8)
    {
    print(jsonString)
}
```

1. Create the encoder
2. Try to encode the object we’ve created
3. Convert, if possible, the `Data` object into a `String`

Then we print out the result which will look like this:

```json
{"name":"ants","is_helpful":true,"insect_id":1006}
```

> Note that the keys used while encoding are not the custom keys (**insectId** and **isHelpful**) but the expected keys (**insect_id** and **is_helpful**). Nice!

#### Custom encoding

Let’s suppose our RESTful API expects to receive the name of the insect uppercased. We need to create our own implementation of the encoding method so to make sure the name of the insect is sent uppercased. We must implement the method **func** encode(to encoder: Encoder) **throws** of the `Encodable` protocol inside our **Insect** `struct`.

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
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(insectId, forKey: .insectId)
        try container.encode(name.uppercased(), forKey: .name)
        try container.encode(isHelpful, forKey: .isHelpful)
    }
}
```

Line 13 is where we create a container where encoded values will be stored. The container MUST be a `var` because it's mutable and MUST receive the keys to be used.

Lines 14 to 16 are used to encode the values into the container, which is done using `try` because any of these can throw an error.

Now, look at line 15: we don’t just put the value as it is but we uppercase it, which is main reason we’re implementing a custom encoding.

If you run the code above, where we create the **Insect** “ants”, we’ll see that after encoding and converting the resulting JSON `Data` into a `String` we get the following:

```
{"name":"ANTS","is_helpful":true,"insect_id":1006}
```

As you might have seen, the name of the insect is now uppercased despite we’ve created it lowercased. How cool is that!

## Custom decoding

So far we’ve been relying on the default decoding method of the `Decodable` protocol. But let's take a look at another scenario.

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

The API is retrieving the **is_helpful** property inside a **details** entity. But we don’t want to create a **Details** object: we just want to flatten that object so we can use our existing **Insect** object.

Time to use our own implementation of the **init**(from decoder: Decoder) **throws** method of the `Decodable` protocol and some extra work. Let's get started.

First of all, coding keys has changed because **is_helpful** is not a key in the same level as before AND there’s a new one called **details**. To fix that:

```swift
enum CodingKeys: String, CodingKey {
        case insectId = "insect_id"
        case name
        case details
    }
    
    enum DetailsCodingKeys: String, CodingKey {
        case isHelpful = "is_helpful"
    }
```

In line 4 we replace the existing key with the new one, **details**.

In lines 7 and 9 we create a new set of keys, the ones that exist inside **details**, which in this case is just one, **isHelpful**.

> Note that we didn’t touch the properties of the **Insect** `struct`.

Now let’s dive into the decoder initialization:

```swift
init(from decoder: Decoder) throws {
   let container = try decoder.container(keyedBy: CodingKeys.self)
        
   insectId = try container.decode(Int.self, forKey: .insectId)
   name = try container.decode(String.self, forKey: .name)
   let details = try container.nestedContainer(keyedBy: DetailsCodingKeys.self, forKey: .details)
   isHelpful = try details.decode(Bool.self, forKey: .isHelpful)
}
```

In line 2 we create the container which decodes the whole JSON structure.

In line 4 and 5 we just decode the `Int` value for the **insectId** property and the `String` value for the **name** property.

In line 6 we grab the nested container under the **details** key which is keyed by the brand new **DetailsCodingKeys** `enum`.

In line 7 we just decode the `Bool` value for the **isHelpful** property inside our new **details** container.

BUT that’s not it. Since our **CodingKeys** has changed by adding the **details** case, our custom encoding implementation must be fixed. So let’s do that:

```swift
func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(insectId, forKey: .insectId)
    try container.encode(name.uppercased(), forKey: .name)
    var details = container.nestedContainer(keyedBy: DetailsCodingKeys.self, forKey: .details)
    try details.encode(isHelpful, forKey: .isHelpful)
}
```

We just changed the way we encode the **isHelpful** property.

In line 5 we create a new nested container, using the keys inside the **DetailsCodingKeys** `enum` and to be used inside the **details** entity inside our JSON.

In line 6 we encode **isHelpful** INSIDE the brand new **details** nested container.

So, to sum up, our **Insect** `struct` looks like this:

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

If we decode it:

```swift
let decoder = JSONDecoder()
if let insects = try? decoder.decode([Insect].self, from: jsonData!) {
    print(insects)
}
```

We’ll get something like this:

```
[__lldb_expr_54.Insect(insectId: 1001, name: "BEES", isHelpful: true), __lldb_expr_54.Insect(insectId: 1002, name: "LADYBUGS", isHelpful: true), __lldb_expr_54.Insect(insectId: 1003, name: "SPIDERS", isHelpful: true), __lldb_expr_54.Insect(insectId: 2001, name: "TOMATO HORN WORMS", isHelpful: false), __lldb_expr_54.Insect(insectId: 2002, name: "CABBAGE WORMS", isHelpful: false), __lldb_expr_54.Insect(insectId: 2003, name: "CABBAGE MOTHS", isHelpful: false)]
```

As you can see, there’s no **details** entity: just our `struct` properties.

The encoding will work as expected as well.

This post, plus the previous series, sums up pretty much the most common scenarios you may run into when working with JSON in Swift.

## Need more information?

Ben Scheirman’s [Ultimate Guide to JSON Parsing with Swift](https://benscheirman.com/2017/06/swift-json/) is the most useful source I could find for this subject.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
