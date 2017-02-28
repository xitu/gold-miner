> * 原文地址：[Mastering Swift: essential details about strings](https://rainsoft.io/mastering-swift-essential-details-about-strings/)
* 原文作者：[Dmitri Pavlutin](https://rainsoft.io/author/dmitri-pavlutin/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：


# Mastering Swift: essential details about strings #

String type is an important component of any programming language. The most useful information that user reads from the window of an iOS application is pure text.  

To reach a higher number of users, the iOS application must be internationalised and support a lot of modern languages. The Unicode standard solves this problem, but creates additional complexity when working with strings.  

On one hand, the language should provide a good balance between the Unicode complexity and the performance when processing strings. On the other hand, it should provide developer with comfortable structures to handle strings.  

In my opinion, Swift does a great job on both hands.  

Fortunately Swift's string is not a simple sequence of UTF-16 code units, like in JavaScript or Java. 

In case of a sequence of UTF-16 code units it's a pain to do Unicode-aware string manipulations: you might break a surrogate pair or combining character sequence.  

Swift implements a better approach. The string itself is not a collection, instead it provides views over the string content that may be applied according to situation. And one particular view, `String.CharacterView`, is fully Unicode-aware.  

For `let myStr = "Hello, world"` you can access the following string views:  

- `myStr.characters` is `String.CharacterView`. Valuable to access graphemes, that visually are rendered as a single symbol. The most used view.
- `myStr.unicodeScalars` is `String.UnicodeScalarView`. Valuable to access the Unicode code point numbers as 21-bit integers
- `myStr.utf16` is `String.UTF16View`. Useful to access the code unit values encoded in UTF16
- `myStr.utf8` is `String.UTF8View`. Valuable to access the code unit values encoded in UTF8

![CharacterView, UnicodeScalarView, UTF16View, UTF8View of strings in Swift](/content/images/2016/10/Swift-strings--3-.png)

Most of the time developer deals with simple string characters, without diving into details like encoding or code units.  

`CharacterView` works nice for most of the string related tasks: iteration over the characters, counting the number of characters, verify substring existence, access by index, different manipulations and so on. 

Let's see in more details how these tasks are accomplished in Swift.  

# 1. Character and CharacterView structures #

`String.CharacterView` structure is a view over string content that is a collection of `Character`.  

To access the view from a string, use `characters` string property:

[Try in Swift sandbox](http://swiftlang.ng.bluemix.net/#/repl/57ff7e018ef62b25bcea2ab1)

```
let message ="Hello, world"
let characters = message.characters  
print(type(of: characters))// => "CharacterView"  
```

`message.characters` returns the `CharacterView` structure.  

The character view is a collection of `Character` structures. For example, let's access the first character in a string view:

[Try in Swift sandbox](http://swiftlang.ng.bluemix.net/#/repl/57ff7e188ef62b25bcea2ab2)

```
let message = "Hello, world"  
let firstCharacter = message.characters.first!  
print(firstCharacter)           // => "H"  
print(type(of: firstCharacter)) // => "Character"

let capitalHCharacter: Character = "H"  
print(capitalHCharacter == firstCharacter) // => true
```

`message.characters.first` returns an optional that is the first character `"H"`. 

The character instance represents a single symbol `H`. 

In Unicode terms `H` is *Latin Capital letter H*, `U+0048` code point. 

Let's go beyond ASCII and see how Swift handles composite symbols. Such characters are rendered as a single visual symbol, but are composed from a sequence of two or more [Unicode scalars](http://unicode.org/glossary/#unicode_scalar_value). Strictly such characters are named **grapheme clusters**.  

*Important*: `CharacterView` is a collection of grapheme clusters of the string.  

Let's take a closer look at `ç` grapheme. It may be represented in two ways: 

- Using `U+00E7` *LATIN SMALL LETTER C WITH CEDILLA*: rendered as `ç`
- Or using a combining character sequence: `U+0063`*LATIN SMALL LETTER C* plus the combining mark `U+0327` *COMBINING CEDILLA*. The grapheme is composite: `c` + `◌̧` = `ç`

Let's pick the second option and see how Swift handles it:

[Try in Swift sandbox](http://swiftlang.ng.bluemix.net/#/repl/57f3466012fc531b0551b918)

```
let message = "c\u{0327}a va bien" // => "ça va bien"  
let firstCharacter = message.characters.first!  
print(firstCharacter) // => "ç"

let combiningCharacter: Character = "c\u{0327}"  
print(combiningCharacter == firstCharacter) // => true  
```

`firstCharacter` contains a single grapheme `ç` that is rendered using two Unicode scalars `U+0063` and `U+0327`.

`Character` structure accepts multiple Unicode scalars as long as they create a single grapheme. If you try to add more graphemes into a single `Character`, Swift triggers an error:

[Try in Swift sandbox](http://swiftlang.ng.bluemix.net/#/repl/57f3510212fc531b0551b91c) 

```
let singleGrapheme: Character = "c\u{0327}\u{0301}" // Works  
print(singleGrapheme) // => "ḉ"

let multipleGraphemes: Character = "ab" // Error!  
```

Even if `singleGrapheme` is composed of 3 Unicode scalars, it creates a single grapheme `ḉ`. 
`multipleGraphemes` tries to create a `Character` from 2 Unicode scalars. This creates 2 separated graphemes `a` and `b` in a single `Character` structure, which is not allowed.  

# 2. Iterating over characters in a string #

`CharacterView` collection conforms to `Sequence` protocol. This allows to iterate over the view characters in a `for-in` loop:

[Try in Swift sandbox](http://swiftlang.ng.bluemix.net/#/repl/57f4bc8f27a61152fe7c7410)

```
let weather ="rain"for char in weather.characters {print(char)}// => "r" // => "a" // => "i" // => "n"
```

Each character from `weather.characters` is accessed using `for-in` loop. On every iteration `char` variable is assigned with a character from `weather` string: `"r"`, `"a"`, `"i"` and `"n"`.  

As an alternative, you can iterate over the characters using `forEach(_:)` method, indicating a closure as the first argument:  

[Try in Swift sandbox](http://swiftlang.ng.bluemix.net/#/repl/57f4bca927a61152fe7c7411)

```
let weather = "rain"  
for char in weather.characters {  
  print(char)
}
// => "r" 
// => "a" 
// => "i" 
// => "n"

```

The iteration using `forEach(_:)` method is almost the same as `for-in`, only that you cannot use `continue` or `break` statements.  

To access the index of the current character in the loop, `CharacterView` provides the `enumerated()` method. The method returns a sequence of tuples `(index, character)`:

[Try in Swift sandbox](http://swiftlang.ng.bluemix.net/#/repl/57f4bcd127a61152fe7c7412)

```
let weather = "rain"  
for (index, char) in weather.characters.enumerated() {  
  print("index: \(index), char: \(char)")
}
// => "index: 0, char: r" 
// => "index: 1, char: a" 
// => "index: 2, char: i" 
// => "index: 3, char: n" 
```

`enumerated()` method on each iteration returns tuples `(index, char)`. 
`index` variable contains the character index at the current loop step. Correspondingly `char` variable contains the character.  

# 3. Counting characters #

Simply use `count` property of the `CharacterView` to get the number of characters:

[Try in Swift sandbox](http://swiftlang.ng.bluemix.net/#/repl/57f4bcf327a61152fe7c7413) 

```
let weather ="sunny"print(weather.characters.count)// => 5  
```

`weather.characters.count` contains the number of characters in the string.  

Each character in the view holds a grapheme. When an adjacent character (for example a [combining mark](http://unicode.org/glossary/#combining_character)) is appended to string, you may find that `count` property is not increased.  

It happens because an adjacent character does not create a new grapheme in the string, instead it modifies an existing [base Unicode character](http://unicode.org/glossary/#base_character). Let's see an example:

[Try in Swift sandbox](http://swiftlang.ng.bluemix.net/#/repl/57f4bd0927a61152fe7c7414)

```
var drink = "cafe"  
print(drink.characters.count) // => 4  
drink += "\u{0301}"  
print(drink)                  // => "café"  
print(drink.characters.count) // => 4  
```

Initially `drink` has 4 characters. 

When the combining mark `U+0301`*COMBINING ACUTE ACCENT* is appended to string, it modifies the previous base character `e` and creates a new grapheme `é`. The property `count` is not increased, because the number of graphemes is still the same.  

# 4. Accessing character by index #

Swift doesn't know about the characters count in the string view until it actually evaluates the graphemes in it. As result a subscript that allows to access the character by an integer index directly does not exist. 

You can access the characters by a special type `String.Index`.

If you need to access the first or last characters in the string, the character view structure has `first` and `last` properties:

[Try in Swift sandbox](http://swiftlang.ng.bluemix.net/#/repl/57f4bd2027a61152fe7c7415) 

```
let season = "summer"  
print(season.characters.first!) // => "s"  
print(season.characters.last!)  // => "r"  
let empty = ""  
print(empty.characters.first == nil) // => true  
print(empty.characters.last == nil)  // => true  

```

Notice that `first` and `last` properties are optional type `Character?`. 

In the empty string `empty` these properties are `nil`.

![String indexes in Swift](/content/images/2016/10/Swift-strings--2--1.png)

To get a character at specific position, you have to use `String.Index` type (actually an alias of `String.CharacterView.Index`). String offers a subscript that accepts `String.Index` to access the character, as well as pre-defined indexes `myString.startIndex` and `myString.endIndex`.  

Using string index type, let's access the first and last characters:  

[Try in Swift sandbox](http://swiftlang.ng.bluemix.net/#/repl/57f4bd3627a61152fe7c7416)

```
let color = "green"  
let startIndex = color.startIndex  
let beforeEndIndex = color.index(before: color.endIndex)  
print(color[startIndex])     // => "g"  
print(color[beforeEndIndex]) // => "n" 
```

`color.startIndex` is the first character index, so `color[startIndex]` evaluates to `g`. 
`color.endIndex` indicates the *past the end* position, or simply the position one greater than the last valid subscript argument. To access the last character, you must calculate the index right before string's end index: `color.index(before: color.endIndex)`.  

To access characters at position by an offset, use the `offsetBy` argument of `index(theIndex, offsetBy: theOffset)` method:

[Try in Swift sandbox](http://swiftlang.ng.bluemix.net/#/repl/57f4bd4d27a61152fe7c7417) 

```
let color = "green"  
let secondCharIndex = color.index(color.startIndex, offsetBy: 1)  
let thirdCharIndex = color.index(color.startIndex, offsetBy: 2)  
print(color[secondCharIndex]) // => "r"  
print(color[thirdCharIndex])  // => "e"   
```

Indicating the `offsetBy` argument, you can access the character at specific offset. 

Of course `offsetBy` argument is jumping over string graphemes, i.e. the offset applies over `Character` instances of string's `CharacterView`.  

If the index is out of range, Swift generates an error:

[Try in Swift sandbox](http://swiftlang.ng.bluemix.net/#/repl/57f4bd7227a61152fe7c7418) 

```
let color ="green"
let oops = color.index(color.startIndex, offsetBy:100)// Error!  
```

To prevent such situations, indicate an additional argument `limitedBy`  to limit the offset: `index(theIndex, offsetBy: theOffset, limitedBy: theLimit)`. The function returns an optional, which is `nil` for out of bounds index:  

[Try in Swift sandbox](http://swiftlang.ng.bluemix.net/#/repl/57f4bd8d27a61152fe7c7419) 

```
let color = "green"  
let oops = color.index(color.startIndex, offsetBy: 100,  
   limitedBy: color.endIndex)
if let charIndex = oops {  
  print("Correct index")
} else {
  print("Incorrect index")
}
// => "Incorrect index"
```

`oops` is an optional `String.Index?`. The optional unwrap verifies whether the index didn't jump out of the string.  

# 5. Checking substring existence #

The simplest way to verify the substring existence is to call `contains(_ other: String)` string method:

[Try in Swift sandbox](http://swiftlang.ng.bluemix.net/#/repl/57f4bda427a61152fe7c741a)

```
importFoundationlet animal ="white rabbit"print(animal.contains("rabbit"))// => true  print(animal.contains("cat"))// => false  
```

`animal.contains("rabbit")` returns `true` because `animal` contains `"rabbit"` substring. 

Correspondingly `animal.contains("cat")` evaluates to `false` for a non-existing substring.  

To verify whether the string has specific prefix or suffix, the methods `hasPrefix(_:)` and  `hasSuffix(_:)` are available. Let's use them in an example:

[Try in Swift sandbox](http://swiftlang.ng.bluemix.net/#/repl/57f4bdb627a61152fe7c741b) 

```
importFoundationlet 
animal ="white rabbit"
print(animal.hasPrefix("white"))// => true  print(animal.hasSuffix("rabbit"))// => true  
```

`"white"` is a prefix and `"rabbit"` is a suffix of `"white rabbit"`. So the corresponding method calls `animal.hasPrefix("white")` and `animal.hasSuffix("rabbit")` return `true`.  

When you need to search for a particular character, it makes sense to query directly the character view. For example:

[Try in Swift sandbox](http://swiftlang.ng.bluemix.net/#/repl/57f4bdc827a61152fe7c741c) 

```
let animal = "white rabbit"  
let aChar: Character = "a"  
let bChar: Character = "b"  
print(animal.characters.contains(aChar)) // => true  
print(animal.characters.contains {  
  $0 == aChar || $0 == bChar
}) // => true
```

`contains(_:)` verifies whether the character view has a particular character. 

The second function form accepts a closure: `contains(where predicate: (Character) -> Bool)` and performs the same verification.  

# 6. String manipulation #

The string in Swift is a *value type*. Whether you pass a string as an argument on function call, assign it to a variable or constant - every time a *copy* of the original string is created.  

A mutating method call changes the string in place.  

This chapter covers the common manipulations over strings.  

#### Append to string a character or another string ####

The simplest way to append to string is `+=` operator. You can append an entire string to original one:  

[Try in Swift sandbox](http://swiftlang.ng.bluemix.net/#/repl/57f4bddf27a61152fe7c741d) 

```
var bird ="pigeon"  
bird +=" sparrow"
print(bird)// => "pigeon sparrow"  
```

String structure provides a mutating method `append()`. The method accepts a string, a character or even a sequence of characters, and appends it to the original string. For instance:

[Try in Swift sandbox](http://swiftlang.ng.bluemix.net/#/repl/57f4bdff27a61152fe7c741e) 

```
var bird = "pigeon"  
let sChar: Character = "s"  
bird.append(sChar)  
print(bird) // => "pigeons"  
bird.append(" and sparrows")  
print(bird) // => "pigeons and sparrows"  
bird.append(contentsOf: " fly".characters)  
print(bird) // => "pigeons and sparrows fly" 
```

#### Extract a substring from string ####

The method `substring()` allows to extract substrings:

- from a specific index up to the end of string
- from the the start up to a specific index 
- or based on a range of indexes. 

Let's see how it works:

[Try in Swift sandbox](http://swiftlang.ng.bluemix.net/#/repl/57f4be1527a61152fe7c741f) 

```

let plant = "red flower"  
let strIndex = plant.index(plant.startIndex, offsetBy: 4)  
print(plant.substring(from: strIndex)) // => "flower"  
print(plant.substring(to: strIndex))   // => "red "

if let index = plant.characters.index(of: "f") {  
  let flowerRange = index..<plant.endIndex
  print(plant.substring(with: flowerRange)) // => "flower"   
}
```

The string subscript accepts a range or closed range of string indexes. This helps extracting substrings based on ranges of indexes:

[Try in Swift sandbox](http://swiftlang.ng.bluemix.net/#/repl/57f4be3127a61152fe7c7420) (target=undefined)

```
let plant ="green tree"let excludeFirstRange =  
  plant.index(plant.startIndex, offsetBy:1)..<plant.endIndex
print(plant[excludeFirstRange])// => "reen tree"  let lastTwoRange =  
  plant.index(plant.endIndex, offsetBy:-2)..<plant.endIndex
print(plant[lastTwoRange])// => "ee"  
```

#### Insert into string ####

The string type provides the mutating method `insert()`. The method allows to insert a character or a sequence of characters at specific index.  

The new character or sequence is inserted before the element currently at the specified index.  

See the following sample:

[Try in Swift sandbox](http://swiftlang.ng.bluemix.net/#/repl/57f4be4a27a61152fe7c7421)

```
var plant = "green tree"  
plant.insert("s", at: plant.endIndex)  
print(plant) // => "green trees"  
plant.insert(contentsOf: "nice ".characters, at: plant.startIndex)  
print(plant) // => "nice green trees" 
```

#### Remove from string ####

The mutating method `remove(at:)` removes the character at an index:

[Try in Swift sandbox](http://swiftlang.ng.bluemix.net/#/repl/57f4be6527a61152fe7c7422)

```
var weather = "sunny day"  
if let index = weather.characters.index(of: " ") {  
  weather.remove(at: index)
  print(weather) // => "sunnyday"
}
```

You can remove characters in the string that are in a range of indexes using `removeSubrange(_:)`:

[Try in Swift sandbox](http://swiftlang.ng.bluemix.net/#/repl/57f4be7b27a61152fe7c7423)

```
var weather = "sunny day"  
let index = weather.index(weather.startIndex, offsetBy: 6)  
let range = index..<weather.endIndex  
weather.removeSubrange(range)  
print(weather) // => "sunny"   
```

#### Replace in string ####

The method `replaceSubrange(_:with:)` accepts a range of indexes that should be replaced with a particular string. The method is mutating the string.

Let's see a sample:

[Try in Swift sandbox](http://swiftlang.ng.bluemix.net/#/repl/57f4be9327a61152fe7c7424)

```
var weather = "sunny day"  
if let index = weather.characters.index(of: " ") {  
  let range = weather.startIndex..<index
  weather.replaceSubrange(range, with: "rainy")
  print(weather) // => "rainy day"
}
```

#### The character view mutation alternative ####

Many of string manipulations described above may be applied directly on string's character view. 

It is a good alternative if you find more comfortable to work directly with a collection of characters.

For example you can remove characters at specific index, or directly the first or last characters:

[Try in Swift sandbox](http://swiftlang.ng.bluemix.net/#/repl/57f4bea927a61152fe7c7425)

```
var fruit = "apple"  
fruit.characters.remove(at: fruit.startIndex)  
print(fruit) // => "pple"  
fruit.characters.removeFirst()  
print(fruit) // => "ple"  
fruit.characters.removeLast()  
print(fruit) // => "pl"  
```

To reverse a word use `reversed()` method of the character view:

[Try in Swift sandbox](http://swiftlang.ng.bluemix.net/#/repl/57f4bebf27a61152fe7c7426)
```
var fruit ="peach"
var reversed =String(fruit.characters.reversed())
print(reversed)// => "hcaep"  
```

You can easily filter the string:

[Try in Swift sandbox](http://swiftlang.ng.bluemix.net/#/repl/57f4beea27a61152fe7c7427) 

```
let fruit = "or*an*ge"  
let filtered = fruit.characters.filter { char in  
  return char != "*"
}
print(String(filtered)) // => "orange"  
```

Map the string content by applying a transformer closure:

[Try in Swift sandbox](http://swiftlang.ng.bluemix.net/#/repl/57f4befd27a61152fe7c7428) 

```
let fruit = "or*an*ge"  
let mapped = fruit.characters.map { char -> Character in  
  if char == "*" {
      return "+"
  }
  return char
}
print(String(mapped)) // => "or+an+ge"   
```

Or reduce the string content to an accumulator value:

[Try in Swift sandbox](http://swiftlang.ng.bluemix.net/#/repl/57f4bf1d27a61152fe7c7429) (target=undefined)

```
let fruit = "or*an*ge"  
let numberOfStars = fruit.characters.reduce(0) { countStars, char in  
    if (char == "*") {
        return countStarts + 1
    }
    return countStars
} 
print(numberOfStars) // => 2  
```

# 7. Final words #

At first sight, the idea of different types of views over string's content may seem overcomplicated.  

In my opinion it is a great implementation. Strings can be viewed in different angles: as a collection of graphemes, UTF-8 or UTF-16 code units or simple Unicode scalars.  

Just pick the view depending on your task. In most of the cases it is `CharacterView`.

The character view deals with graphemes that may be compound from one or more Unicode scalars. As result the string cannot be integer indexed (like arrays). Instead a special type of index is applicable: `String.Index`.  

Special index type adds a bit of complexity when accessing individual characters or manipulating strings. I agree to pay this price, because having truly Unicode-aware operations on strings is awesome! 

*Do you find string views comfortable to use? Write a comment bellow and let's discuss!*

**P.S.** You might be interested to read my [detailed overview of array and dictionary literals in Swift](https://rainsoft.io/concise-initialization-of-collections-in-swift/).

[Twitter](https://twitter.com/share?text=Mastering Swift: essential details about strings&amp;url=https://rainsoft.io/mastering-swift-essential-details-about-strings/) [Facebook](https://www.facebook.com/sharer/sharer.php?u=https://rainsoft.io/mastering-swift-essential-details-about-strings/) [Google+](https://plus.google.com/share?url=https://rainsoft.io/mastering-swift-essential-details-about-strings/) 
[swift](/tag/swift/)[string](/tag/string/)[unicode](/tag/unicode/)[characterview](/tag/characterview/)[for-in](/tag/for-in/)![Dmitri Pavlutin](//www.gravatar.com/avatar/0d57a57d8807ebc70e24b46f6d9e3a36?s=250&amp;d=mm&amp;r=x)

#### [Dmitri Pavlutin](/author/dmitri-pavlutin/) ####

Web & mobile iOS developer. Swift and JavaScript languages fan. My routine is coding, blogging, learning, open sourcing and solving problems. [About me](/about-me/)
