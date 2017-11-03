
> * 原文地址：[Ultimate Guide to JSON Parsing With Swift 4](http://benscheirman.com/2017/06/ultimate-guide-to-json-parsing-with-swift-4/)
> * 原文作者：[Ben Scheirman](http://benscheirman.com/about-me/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/ultimate-guide-to-json-parsing-with-swift-4.md](https://github.com/xitu/gold-miner/blob/master/TODO/ultimate-guide-to-json-parsing-with-swift-4.md)
> * 译者：
> * 校对者：

# Ultimate Guide to JSON Parsing With Swift 4

![](http://benpublic.s3.amazonaws.com/blog/swift-json/swift-json@2x.png)

    This guide is now permalinked at **http://swiftjson.guide**

Swift 4 and Foundation has finally answered the question of how to parse JSON with Swift.

There has been a number of great libraries for this, but it is quite refreshing to see a fully-supported solution that is easy to adopt but also provides the customization you need to encode and decode complex scenarios.

It’s worth noting that everything discussed here applies to any `Encoder`/`Decoder` implementation, including `PropertyListEncoder`, for instance. You can also create a custom implementations of these if you need something different like XML. The rest of this blog post will focus on JSON parsing because that is the most relevant to most iOS developers.

## The Basics

If your JSON structure and objects have similar structure, then your work is really easy.

Here’s an example JSON document for a beer:

```
{
    "name": "Endeavor",
    "abv": 8.9,
    "brewery": "Saint Arnold",
    "style": "ipa"
}
```

Our Swift data structure could look like this:

```
enum BeerStyle : String {
    case ipa
    case stout
    case kolsch
    // ...
}

struct Beer {
    let name: String
    let brewery: String
    let style: BeerStyle
}
```

To convert this JSON string to a `Beer` instance, we’ll mark our types as `Codable`.

`Codable` is actually a union type consisting of `Encodable & Decodable`, so if you only care about unidirectional conversion you can just adopt the appropriate protocol. This is a new feature of Swift 4.

`Codable` comes with a default implementation, so for many cases you can just adopt this protocol and get useful default behavior **for free**.

```
enum BeerStyle : String, Codable {
   // ...
}

struct Beer : Codable {
   // ...
}
```

Next we just need to create a decoder:

```
let jsonData = jsonString.data(encoding: .utf8)!
let decoder = JSONDecoder()
let beer = try! decoder.decode(Beer.self, for: jsonData)
```

And that’s it! We’ve parsed our JSON document into a beer instance. It didn’t require any customization since the key names and types matched each other.

Worth noting here is that we’re using `try!` for the sake of an example, but in your app you should catch any errors and handle them intelligently. More on handling errors later on…

So in our contrived example things lined up perfectly. But what if the types don’t match up?

## Customizing Key Names

It is often the case that API’s use snake-case for naming keys, and this style does not match the naming guidelines for Swift properties.

To customize this we need to peer into the default implementation of `Codable` for a second.

Keys are handled automatically by a compiler-generated “`CodingKeys`” enumeration. This enum conforms to `CodingKey`, which defines how we can connect a property to a value in the encoded format.

To customize the keys we’ll have to write our own implementation of this. For the cases that diverge from the swift naming, we can provide a string value for the key:

```
struct Beer : Codable {
      // ...
      enum CodingKeys : String, CodingKey {
          case name
          case abv = "alcohol_by_volume"
          case brewery = "brewery_name"
          case style
    }
}
```

If we take our beer instance and try to encode it as JSON, we can see this new format in action:

```
let encoder = JSONEncoder()
let data = try! encoder.encode(beer)
print(String(data: data, encoding: .utf8)!)
```

This outputs:

```
{"style":"ipa","name":"Endeavor","alcohol_by_volume":8.8999996185302734,"brewery_name":"Saint Arnold"}
The formatting here isn’t very human-friendly. We can customize the output formatting of the `JSONEncoder` to make it a little nicer with the `outputFormatting` property.
```

The formatting here isn’t very human-friendly. We can customize the output formatting of the JSONEncoder to make it a little nicer with the outputFormatting property.

The default value is `.compact`, which produces the output above. We can change it to `.prettyPrinted` to get more readable output.

```
encoder.outputFormatting = .prettyPrinted
{
  "style" : "ipa",
  "name" : "Endeavor",
  "alcohol_by_volume" : 8.8999996185302734,
  "brewery_name" : "Saint Arnold"
}
```

`JSONEncoder` and `JSONDecoder` both have more options for customizing their behavior. One of the more common requirements is customizing how dates are parsed.

## Handling Dates

JSON has no data type to represent dates, so these are serialized into some representation that the client and server have to agree on. Typically this is done with [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) date formatting and then serialized as a string.

> Pro tip: [nsdateformatter.com](http://nsdateformatter.com) is a great place to snag the format string for various formats, including ISO 8601 format.

Other formats might be the number of seconds (or milliseconds) since a reference date, which would be serialized as a Number in the JSON document.

In the past we’d have to handle this ourselves, providing perhaps a string field on our data type and then using our own `DateFormatter` instance to marshal dates from string values and vice-versa.

With the `JSONEncoder` and `JSONDecoder` this is all done for us. Check it out. By default, these will use `.deferToDate` as the style for handling dates, which looks like this:

```
struct Foo : Encodable {
    let date: Date
}

let foo = Foo(date: Date())
try! encoder.encode(foo)
{
  "date" : 519751611.12542897
}
```

We can change this to `.iso8601` formatting:

```
encoder.dateEncodingStrategy = .iso8601
{
  "date" : "2017-06-21T15:29:32Z"
}
```

The other JSON date encoding strategies available are:

- `.formatted(DateFormatter)`  – for when you have a non-standard date format string you need to support. Supply your own date formatter instance.
- `.custom( (Date, Encoder) throws -> Void )` – for when you have something *really* custom, you can pass a block here that will encode the date into the provided encoder.
- `.millisecondsSince1970` and `.secondsSince1970`, which aren’t very common in APIs. It is not really recommended to use a format like this as time zone information is completely absent from the encoded representation, which makes it easier for someone to make the wrong assumption.

Decoding dates have essentially the same options, but for `.custom` it takes the shape of `.custom( (Decoder) throws -> Date )`, so we are given a decoder and we are responsible for hydrating that into a date from whatever might be in the decoder.

## Handling Floats

Floats and are another area where JSON doesn’t quite match up with Swift’s `Float` type. What happens if the server returns an invalid `“NaN”` as a string? What about positive or negative `Infinity`? These do not map to any specific values in Swift.

The default implementation is `.throw`, meaning if the decoder encounters these values then an error will be raised, but we can provide a mapping if we need to handle this:

```
{
   "a": "NaN",
   "b": "+Infinity",
   "c": "-Infinity"
}
struct Numbers : Decodable {
  let a: Float
  let b: Float
  let c: Float
}
decoder.nonConformingFloatDecodingStrategy =
  .convertFromString(
      positiveInfinity: "+Infinity",
      negativeInfinity: "-Infinity",
      nan: "NaN")

let numbers = try! decoder.decode(Numbers.self, from: jsonData)
dump(numbers)
```

This gives us:

```
▿ __lldb_expr_71.Numbers
  - a: inf
  - b: -inf
  - c: nan
```

You can do the reverse with `JSONEncoder`’s `nonConformingFloatEncodingStrategy` as well.

This is not likely something you’ll need in the majority case, but one day it might come in handy.

## Handling Data

Sometimes you’ll find APIs that send small bits of data as base64 encoded strings.

To handle this automatically, you can give `JSONEncoder` one of these encoding strategies:

- `.base64`
- `.custom( (Data, Encoder) throws -> Void)`

To decode it, you can provide `JSONDecoder` with a decoding strategy:

- `.base64`
- `.custom( (Decoder) throws -> Data)`

Obviously `.base64` will be the common choice here, but if you need to do anything
custom you can use on of the block-based strategies.

## Wrapper Keys

Often times APIs will include wrapper key names so that the top level JSON entity is always an object.

Something like this:

```
{
  "beers": [ {...} ]
}
```

To represent this in Swift, we can create a new type for this response:

```
struct BeerList : Codable {
    let beers: [Beer]
}
```

That’s actually it! Since our key name matches up and `Beer` is already `Codable` it just works.

## Root Level Arrays

If the API is returning an array as the *root* element, parsing the response looks like this:

```
let decoder = JSONDecoder()
let beers = try decoder.decode([Beer].self, from: data)

```

Note that we’re using the Array as the type here. `Array<T>` is decodable as long
as `T` is decodable.

## Dealing with Object Wrapping Keys

Here’s another scenario you might run across: an array response where each object
in the array is wrapped with a key.

```
[
  {
    "beer" : {
      "id": "uuid12459078214",
      "name": "Endeavor",
      "abv": 8.9,
      "brewery": "Saint Arnold",
      "style": "ipa"
    }
  }
]
```

You could use the wrapping type approach above to capture this key, but an easier
approach would be to recognize that this structure is already made of of strongly
typed decodable implemetations.

Do you see it?

```
[[String:Beer]]
```

Or perhaps more readable in this case:

```
Array<Dictionary<String, Beer>>
```

Just like `Array<T>` is decodable, so is `Dictionary<K,T>` if both `K` and `T`
are decodable.

```
let decoder = JSONDecoder()
let beers = try decoder.decode([[String:Beer]].self, from: data)
dump(beers)
▿ 1 element
  ▿ 1 key/value pair
    ▿ (2 elements)
      - key: "beer"
      ▿ value: __lldb_expr_37.Beer
        - name: "Endeavor"
        - brewery: "Saint Arnold"
        - abv: 8.89999962
        - style: __lldb_expr_37.BeerStyle.ipa
```

## More Complex Nested Response

Sometimes our API responses aren’t that simple. Maybe at the top level it’s not
simply a key defining the objects in the response, but often times you’ll receive
multiple collections, or perhaps paging information.

For example:

```
{
    "meta": {
        "page": 1,
        "total_pages": 4,
        "per_page": 10,
        "total_records": 38
    },
    "breweries": [
        {
            "id": 1234,
            "name": "Saint Arnold"
        },
        {
            "id": 52892,
            "name": "Buffalo Bayou"
        }
    ]
}
```

We can actually nest types in Swift and have that structure present when we
encode/decode json.

```
struct PagedBreweries : Codable {
    struct Meta : Codable {
        let page: Int
        let totalPages: Int
        let perPage: Int
        let totalRecords: Int
        enum CodingKeys : String, CodingKey {
            case page
            case totalPages = "total_pages"
            case perPage = "per_page"
            case totalRecords = "total_records"
        }
    }

    struct Brewery : Codable {
        let id: Int
        let name: String
    }

    let meta: Meta
    let breweries: [Brewery]
}
```

One huge benefit of this approach is you can have variations of different responses
for the same type of object (perhaps in this case a `"brewery"` has only `id` and
`name` in a list response like this, but has more attributes if you select the brewery
by itself). Because the `Brewery` type here is nested, we can have a different `Brewery`
type elsewhere that decodes and encodes a different structure.

## Deeper Customization

So far we’ve still relied on the default implementations of `Encodable` and `Decodable` to do the heavy lifting for us.

This will handle the majority of cases, but eventually you’ll have to drop down and do things yourself to have more control over how encoding and decoding happens.

### Custom Encoding

To start, we’ll implement custom versions of what the compiler was giving us for free. We’ll start with encoding.

```
extension Beer {
    func encode(to encoder: Encoder) throws {

    }
}
```

I also want to add a couple of new fields to our beer type, just to round out the example:

```
struct Beer : Coding {
    // ...
    let createdAt: Date
    let bottleSizes: [Float]
    let comments: String?

    enum CodingKeys: String, CodingKey {
        // ...
        case createdAt = "created_at",
        case bottleSizes = "bottle_sizes"
        case comments
    }
}
```

In this method we need to take the encoder, get a “container” and encode values into it.

### What is a container?

A container can be one of a few different types:

- **Keyed Container** – provides values by keys. This is essentially a dictionary.
- **Unkeyed Container** – this provides ordered values without keys. In the JSONEncoder, this means an array.
- **Single Value Container** – this outputs the raw value without any kind of containing element.

In order to encode any of our properties we’ll first need to get a container. Looking at the JSON structure we started with at the top of this post, it’s clear we need a *keyed* container:

```
var container = encoder.container(keyedBy: CodingKeys.self)
```

Two things to note here:

- The container has to be a mutable property, since we’ll be writing to it, so the variable must be declared with `var`
- We have to specify the keys (and thus the property/key mapping) so it knows what keys we can encode into this container

That latter point turns out to be super powerful, as we’ll see.

Next we need to encode values into the container. Any of these calls might throw errors, so we’ll start each line with `try`:

```
try container.encode(name, forKey: .name)
try container.encode(abv, forKey: .abv)
try container.encode(brewery, forKey: .brewery)
try container.encode(style, forKey: .style)
try container.encode(createdAt, forKey: .createdAt)
try container.encode(comments, forKey: .comments)
try container.encode(bottleSizes, forKey: .bottleSizes)
```

For the comments field, the default implementation of `Encodable` uses `encodeIfPresent` on optional values. This means keys will be missing from the encoded representation if they are `nil`. This is generally not a great solution for APIs, so it is a best practice to include keys even if they have a null value. Here we force the output to include this key by using `encode(_:forKey:)` instead of `encodeIfPresent(_:forKey:)`.

Our `bottleSizes` value was encoded automatically as well, but if we needed to customize this for some reason, we have to create our own container. Here we are processing each item (by rounding the float) and adding it to the container in order:

```
var sizes = container.nestedUnkeyedContainer(
      forKey: .bottleSizes)

try bottleSizes.forEach {
      try sizes.encode($0.rounded())
}
```

And we’re done! Note that nothing in here talks about float conforming strategies or date formatting. In fact, this method is entirely JSON agnostic, which is part of the design. Encoding and Decoding types is a generic feature, and the format is easily specified by interested parties.

Our encoded JSON now looks like this:

```
{
  "comments" : null,
  "style" : "ipa",
  "brewery_name" : "Saint Arnold",
  "created_at" : "2016-05-01T12:00:00Z",
  "alcohol_by_volume" : 8.8999996185302734,
  "bottle_sizes" : [
    12,
    16
  ],
  "name" : "Endeavor"
}
```

> Worth noting here is the floating point value that we started with in the original JSON document was 8.9, but due to the way floats are represented in memory, it is not the same number you passed in. If you require specific numeric precision, you might want to format this manually each time with a NumberFormatter. In particular, APIs that deal with currency often send the number of cents as an integer value (that can be rounded safely) and then you divide this by 100.0 to get the dollar value.

Now we can do the reverse. Let’s write the implementation of the Decodable protocol requirement:

### Custom Decoding

Decoding essentially means writing another initializer.

```
extension Beer {
    init(from decoder: Decoder) throws {

    }
}
```

Again, we need to get a container from the decoder:

```
let container = try decoder.container(keyedBy: CodingKeys.self)

```

We can decode all of the basic properties. In each case we have to specify the type to expect. If the type does not match, a `DecodingError.TypeMismatch` will be throw and have information we can use to figure out what happened.

```
let name = try container.decode(String.self, forKey: .name)
let abv = try container.decode(Float.self, forKey: .abv)
let brewery = try container.decode(String.self,
      forKey: .brewery)
let style = try container.decode(BeerStyle.self,
      forKey: .style)
let createdAt = try container.decode(Date.self,
      forKey: .createdAt)
let comments = try container.decodeIfPresent(String.self,
      forKey: .comments)
```

We can use the same method for our `bottleSizes` array, but we can also process each value on the way in in a similar manner. Here we round values before storing them in the new instance:

```
var bottleSizesArray = try container.nestedUnkeyedContainer(forKey: .bottleSizes)
var bottleSizes: [Float] = []
while (!bottleSizesArray.isAtEnd) {
    let size = try bottleSizesArray.decode(Float.self)
    bottleSizes.append(size.rounded())
}
```

We’ll keep decoding values from the container until the container has no more elements.

With all of these variables now defined, we have all the answers to call our default initializer:

```
self.init(name: name,
              brewery: brewery,
              abv: abv,
              style: style,
              createdAt: createdAt,
              bottleSizes: bottleSizes,
              comments: comments)
```

With custom implementations of `encode(to encoder:)` and `init(from decoder:)` we have much more control over how the resulting JSON maps to our types.

## Flattening Objects

Let’s say the JSON has a level of nesting that we don’t care about. Modifying the above example, let’s say `abv` and `style` are represented as such:

```
{
   "name": "Lawnmower",
   "info": {
     "style": "kolsch",
     "abv": 4.9
   }
   // ...
}
```

To work with this structure we’ll have to customize both the encoding and decoding implementations.

We’ll start by defining an enum for those nested keys (and removing them from the main `CodingKeys` enum:

```
struct Beer : Codable {
  enum CodingKeys: String, CodingKey {
      case name
      case brewery
      case createdAt = "created_at"
      case bottleSizes = "bottle_sizes"
      case comments
      case info // <-- NEW
  }

  case InfoCodingKeys: String, CodingKey {
      case abv
      case style
  }
}
```


When we’re encoding the value, we’ll need to first get a reference to the `info` container, (which if you recall is a *keyed* container).

```
func encode(to encoder: Encoder) throws {
      var container = encoder.container(
          keyedBy: CodingKeys.self)

      var info = try encoder.nestedContainer(
          keyedBy: InfoCodingKeys.self)
      try info.encode(abv, forKey: .abv)
      try info.encode(style, forKey: .style)

    // ...
```

For the decodable implementation, we can do the reverse:

```
init(from decoder: Decoder) throws {
    let container = try decoder.container(
          keyedBy: CodingKeys.self)

    let info = try decoder.nestedContainer(
          keyedBy: InfoCodingKeys.self)
    let abv = try info.decode(Float.self, forKey: .abv)
    let style = try info.decode(BeerStyle.self,
          forKey: .style)

    // ...
}
```

Now we can have a nested structure in the encoded format, but flatten that out in our object.

## Creating Child Objects

Let’s say that brewery is passed as a simple string instead, but we want to keep our separate `Brewery` type.

```
{
  "name": "Endeavor",
  "brewery": "Saint Arnold",
  // ...
}
```

In this case, we again have to provide custom implementations of implementations of `encode(to encoder:)` and `init(from decoder:)`.

```
func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy:
          CodingKeys.self)

      try encoder.encode(brewery.name, forKey: .brewery)

      // ...     
}

init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy:
          CodingKeys.self)
      let breweryName = try decoder.decode(String.self,
          forKey: .brewery)
      let brewery = Brewery(name: breweryName)

    // ...
}
```

## Inheritance

Let’s say we have the following classes:

```
class Person : Codable {
    var name: String?
}

class Employee : Person {
    var employeeID: String?
}
```

We get the `Codable` conformance by inheriting from the `Person` class, but what happens if we try to encode an instance of `Employee`?

```
let employee = Employee()
employee.employeeID = "emp123"
employee.name = "Joe"

let encoder = JSONEncoder()
encoder.outputFormatting = .prettyPrinted
let data = try! encoder.encode(employee)
print(String(data: data, encoding: .utf8)!)
{
  "name" : "Joe"
}
```

Well that’s not what we wanted. As it turns out the auto-generated implementation doesn’t quite work with subclasses. So we’ll have to customize the encode/decode methods again.

```
class Person : Codable {
    var name: String?

    private enum CodingKeys : String, CodingKey {
        case name
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
    }
}
```

We’ll do the same for the subclass:

```
class Employee : Person {
    var employeeID: String?

    private enum CodingKeys : String, CodingKey {
        case employeeID = "emp_id"
    }

    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(employeeID, forKey: .employeeID)
    }
}
```

This gives us:

```
{
  "emp_id" : "emp123"
}
```

Well that’s not right either. We have to flow through to the super class implementation of `encode(to:)`.

You might be tempted to just call super and pass in the encoder. This *should* work, but as of the current snapshot this causes an `EXC_BAD_ACCESS`. I think this is a bug and will probably work in future snapshots.

If we did the above we’d get a merged set of attributes under the same container. However, the Swift team has this to say about re-using the same container for multiple types:

> If a shared container is desired, it is still possible to call super.encode(to: encoder) and
> super.init(from: decoder), but we recommend the safer containerized option.

The reason is that the superclass could overwrite values we’ve set and we wouldn’t know about it.

Instead, we can use a special method to get a super-class ready encoder that already has a container attached to it:

```
try super.encode(to: container.superEncoder())
```

Which gives us:

```
{
  "super" : {
    "name" : "Joe"
  },
  "emp_id" : "emp123"
}
```

This produces the super-class encoding underneath this new key: `”super”`. We can customize this key name if we want:

```
enum CodingKeys : String, CodingKey {
  case employeeID = "emp_id"
  case person
}

override func encode(to encoder: Encoder) throws {
   // ...
   try super.encode(to:
      container.superEncoder(forKey: .person))
}
```

Which results in:

```
{
  "person" : {
    "name" : "Joe"
  },
  "emp_id" : "emp123"
}
```

Having access to common structure in a superclass can simplify JSON parsing and reduce code duplication in some cases.

## UserInfo

User Info can be passed along during encoding and decoding if you need some custom data to be present in order to alter behavior or provide necessary context to objects during encoding or decoding.

For instance, let’s say we had a legacy v1 version of an API that produced this JSON for a customer:

```
{
  "customer_name": "Acme, Inc",   // old key name
  "migration_date": "Oct-24-1995", // different date format?
  "created_at": "1991-05-12T12:00:00Z"
}
```

Here we have a `migration_date` field that has a different date format than the `created_at` field. Let’s also assume that the name property has since been changed to just `name`.

This is obviously not an ideal situation, but real-life happens and sometimes you inherit a messy API.

Let’s define a special user info struct that will hold some important values for us:

```
struct CustomerCodingOptions {
  enum ApiVersion {
      case v1
      case v2
  }
  let apiVersion = ApiVersion.v2
  let legacyDateFormatter: DateFormatter

  static let key = CodingUserInfoKey(rawValue: "com.mycompany.customercodingoptions")!
}
```

We can now create an instance of this struct and pass it to an encoder or decoder:

```
let formatter = DateFormatter()
formatter.dateFormat = "MMM-dd-yyyy"
let options = CustomerCodingOptions(apiVersion: .v1, legacyDateFormatter: formatter)

encoder.userInfo = [ CustomerCodingOptions.key : options ]

// ...
```

Inside the encode method:

```
func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)

    // here we can require this be present...
    if let options = encoder.userInfo[CustomerCodingOptions.key] as? CustomerCodingOptions {

        // encode the right key for the customer name
        switch options.apiVersion {
        case .v1:
            try container.encode(name, forKey: .legacyCustomerName)
        case .v2:
            try container.encode(name, forKey: .name)
        }

        // use the provided formatter for the date
        if let migrationDate = legacyMigrationDate {
            let legacyDateString = options.legacyDateFormatter.string(from: migrationDate)
            try container.encode(legacyDateString, forKey: .legacyMigrationDate)
        }

    } else {
        fatalError("We require options")
    }


    try container.encode(createdAt, forKey: .createdAt)
}
```

We can do exactly the same things for the decode initializer.

Providing options from the outside is a great way to have more control over the parsing, as well as reusing potentially expensive-to-create objects like `DateFormatter`.

## Dynamic Coding Keys

So far in this guide we’ve used an `enum` to represent coding keys when they diverge
from the Swift naming. Sometimes this won’t be possible. Consider this case:

```
{
  "kolsh" : {
    "description" : "First only brewed in Köln, Germany, now many American brewpubs..."
  },
  "stout" : {
    "description" : "As mysterious as they look, stouts are typically dark brown to pitch black in color..."
  }
}
```

This is a listing of beer styles, but the keys are actually the name of the style.
We could not represent *every possible case* with an enum as it could change or grow over time.

Instead, we can create a more dynamic implementation of `CodingKey` for this.

```
struct BeerStyles : Codable {
  struct BeerStyleKey : CodingKey {
    var stringValue: String
    init?(stringValue: String)? {
      self.stringValue = stringValue
    }
    var intValue: Int? { return nil }
    init?(intValue: Int) { return nil }

    static let description = BeerStyleKey(stringValue: "description")!
  }

  struct BeerStyle : Codable {
    let name: String
    let description: String
  }

  let beerStyles : [BeerStyle]
}
```

`CodingKey` requires both `String` and `Int` value properties and initializers,
but in this case we don’t need to support integer keys. We also have defined a
static key for the static `"description"` attribute, which won’t change.

Let’s start with decoding.

```
init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: BeerStyleKey.self)

    var styles: [BeerStyle] = []
    for key in container.allKeys {
        let nested = try container.nestedContainer(keyedBy: BeerStyleKey.self,
            forKey: key)
        let description = try nested.decode(String.self,
            forKey: .description)
        styles.append(BeerStyle(name: key.stringValue,
            description: description))
    }

    self.beerStyles = styles
}
```

Here we dynamically loop over all keys found in the container, grab a reference
to the container under that key, then we extract the description from it.

Using both `name` and `description` we can manually create a `BeeryStyle` instance
and add it to the array.

How about encoding?

```
func encode(to encoder: Encoder) throws {
    var container = try encoder.container(keyedBy: BeerStyleKey.self)
    for style in beerStyles {
        let key = BeerStyleKey(stringValue: style.name)!
        var nested = try container.nestedContainer(keyedBy: BeerStyleKey.self,
            forKey: key)
        try nested.encode(style.description, forKey: .description)
    }
}
```

Here we loop over all the styles in our array, create a key for the name of
the style, and create a container at that key. Then we just need to encode the
description into that container and we’re done.

As you can see, creating a custom `CodingKey` gives us a lot of flexibility over
the types of responses we can handle.

## Handling Errors

So far we haven’t handled any errors.  These are some of the errors we might run into. Each provides some associated values (like `DecodingError.Context` which provides a useful debug description of what when wrong).

- `DecodingError.dataCorrupted(Context)` – the data is corrupted (i.e. it doesn’t look at all like what we expect). This would be the case if the `data` you fed to the decoder wasn’t JSON at all, but perhaps an HTML error page from a failed API call.
- `DecodingError.keyNotFound(CodingKey, Context)` – a required key was not found. This passes the key in question and the context gives useful information about where and why this happened. You could catch this and provide a fallback value for some keys if appropriate.
- `DecodingError.typeMismatch(Any.Type, Context)` – expected one type but found another.  Perhaps the data format changed from one version of an API to another. You could catch this error and attempt to retrieve the value using a different type instead.

The errors raised by the encoder and decoder are very useful in diagnosing problems and give you the flexibility to dynamically adapt to certain situations and handle them appropriately.

One such place is migrating responses from older versions of an API.  Say for instance you encoded a version of your object in order to put in a persistent cache on disk somewhere. Later you changed the format, but this disk representation still exists. When you try to load it, it would raise these errors and you could handle them to cleanly migrate to the new data format.

## Further Reading

- [Codable.swift](https://github.com/apple/swift/blob/master/stdlib/public/core/Codable.swift) –
One of the great things about Swift being open source is we can just look at how these things are implemented.
Definitely take a look!
- [Using JSON with Custom Types](https://developer.apple.com/documentation/foundation/archives_and_serialization/using_json_with_custom_types) – A sample playground from Apple that shows some more complex JSON parsing scenarios.

## Conclusion

This was a whirlwind tour of how to use the new Swift 4 Codable API. Have anything to add? Leave a comment below.

Like this stuff? I think you’ll love [NSScreencast](http://nsscreencast.com) as well.

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
