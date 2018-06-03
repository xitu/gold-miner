> * 原文地址：[Swift + Keywords (V 3.0.1)](https://medium.com/the-traveled-ios-developers-guide/swift-keywords-v-3-0-1-f59783bf26c#.jyslid67n)
* 原文作者：[Jordan Morgan](https://medium.com/@JordanMorgan10?source=post_header_lockup)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[Deepmissea](http://deepmissea.blue)
* 校对者：[ylq167](http://www.11167.xyz)，[oOatuo](http://atuo.xyz)

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/1000/1*377To6hCTuE51ZzrVQMBfw.jpeg">

Macbook + 纸张。致命组合

# Swift + 关键字（V 3.0.1）
## A Tell All ##

有句话以前说过，现在我要再次提一下，一个优秀的匠人，他（她）的工具同样优秀。当我们一丝不苟地去使用这些工具时，它们就会带我们到想去的地方，或者完成我们的梦寐以求的作品。

我并没有贬义的意思，因为总是有很多东西要学。所以今天，[我们来看看 Swift 中的**每一个关键字**](https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/LexicalStructure.html)(v 3.0.1)，看看它为我们每个人提供的代码，我们每个人预定的工具的名字。

有一些是很简单的，有一些是晦涩难懂的，也有一些是有点能认出来的。但是他们都很值得阅读和学习，这会很漫长，准备好了吗？

现在，让我们嗨起来~

#### 声明关键字

**associatedtype**：通常作为协议的一部分，为一种类型提供一个占位符。在协议未被遵守之前，这个类型都是未知的。

```
protocol Entertainment
{
    associatedtype MediaType
}

class Foo : Entertainment
{
    typealias MediaType = String // 可以是任何符合需求的类型？
}
```

**class**：一个构建程序代码的通用且灵活的基础结构。和 struct 有些相似，除了：

- 继承。允许一个类继承另一个类的特性。
- 类型转换。允许你在运行时检查并解释一个类的实例的类型。
- 析构器。允许一个类的实例释放它分配的任何资源。
- 引用计数。允许类的实例有多个引用。

```
class Person
{
    var name:String
    var age:Int
    var gender:String
}
```

**deinit**：在类的实例被释放前马上调用。

```
class Person
{
    var name:String
    var age:Int
    var gender:String

    deinit
    {
        // 从堆里释放，在这里卸货。
    }
}
```

**enum**：为一组相关值定义通用类型，并使你能够在代码中以类型安全的方式使用这些值。在 Swift 中，它们属于第一类类型，并且可以使用一些特性，这些特性在其他语言里往往只有类才支持。

```
enum Gender
{
    case male
    case female
}
```

**extension**：允许为现有的类、结构体、枚举或协议添加新的功能。

```
class Person
{
    var name:String = ""
    var age:Int = 0
    var gender:String = ""
}

extension Person
{
    func printInfo()
    {
        print("My name is \(name), I'm \(age) years old and I'm a \(gender).")
    }
}
```

**fileprivate**：访问控制结构，将作用域限制在源文件。

```
class Person
{
    fileprivate var jobTitle:String = ""
}

extension Person
{

    // 如果使用 "private" 声明，将不会通过编译。
    func printJobTitle()
    {
        print("My job is \(jobTitle)")
    }
}
```

**func** : 执行一个特定的自包含的代码块。

```
func addNumbers(num1:Int, num2:Int) -> Int
{
    return num1+num2
}
```

**import**：将一个已构建的框架或应用，作为一个单元暴露给指定的二进制文件。


```
import UIKit

// 现在，所有 UIKit 的代码都可以调用
class Foo {}
```

**init** : 构造一个类、结构体或枚举的实例的过程。

```
class Person 
{
    init()
    {
        // 在这设置默认的值等等。
    }
}
```

**inout**：传递给函数一个值，然后修改它，它会被传回原来的位置来代替原始值。适用于引用类型和值类型。

```
func dangerousOp(_ error:inout NSError?)
{
    error = NSError(domain: "", code: 0, userInfo: ["":""])
}

var potentialError:NSError?

dangerousOp(&potentialError)

// 现在 potentialError 被初始化了，不再是 nil 了
```

**internal**：访问控制结构，允许实体在它定义模块的任何源文件中使用，但不能在其外部的源文件中使用。

```
class Person
{
    internal var jobTitle:String = ""
}

let aPerson = Person()
aPerson.jobTitle = "This can set anywhere in the application"
```

**let**：定义一个不可变的变量。

```
let constantString = "This cannot be mutated going forward"
```

**open**：访问控制结构，允许对象在定义的模块之外被访问或子类化。对于成员，外部模块也是可以访问和覆盖的。

```
open var foo:String? // 应用的内外都可以访问或覆盖，编写框架时，是很常用的访问控制符

```

**operator**：一个用来检查、更改或合并值的特殊符号或短语。

```
// “-” 一元运算符，减少目标的值
let foo = 5
let anotherFoo = -foo // anotherFoo 现在是 -5 了

// ”+“ 组合两个值
let box = 5 + 3


// ”&&“ 逻辑运算符，用来组合两个布尔值
if didPassCheckOne && didPassCheckTwo


// 三元运算符，包含三个值？
let isLegalDrinkingAgeInUS:Bool = age >= 21 ? true : false
```

**private**：访问控制结构，把实体的作用域限制在声明的位置。

```
class Person
{
    private var jobTitle:String = ""
}

extension Person
{
    // 不会被编译，jobTitle 的作用域只在 Person 类里
    func printJobTitle()
    {
        print("My job is \(jobTitle)")
    }
}
```
**protocol**：定义适合特定任务或部分功能的类、属性和其他需求的蓝图。

```
protocol Blog
{
    var wordCount:Int { get set }
    func printReaderStats()
}

class TTIDGPost : Blog
{
    var wordCount:Int

    init(wordCount:Int)
    {
        self.wordCount = wordCount
    }

    func printReaderStats()
    {
        // 打印一些统计信息
    }
}
```

**public**：访问控制结构，允许对象在被定义的模块内部访问或子类化，对于成员，也只可以在定义的模块内部可以访问和覆盖。

```
public var foo:String? // 在程序内部的任何地方都可以被覆盖或重写，但是外部不行。
```

**static**：定义该类型自己的调用方法。也用于定义其静态成员。

```
class Person
{
    var jobTitle:String?

    static func assignRandomName(_ aPerson:Person)
    {
        aPerson.jobTitle = "Some random job"
    }
}

let somePerson = Person()
Person.assignRandomName(somePerson)
//somePerson.jobTitle is now "Some random job"
```

**struct**：一个构建程序代码的通用且灵活的基础结构，也提供了成员的初始化方法。和 `class` 不同，他们在代码中被传递的时候，永远复制，而不会启动自动引用计数。另外，他们也不能：

- 使用继承。
- 在运行时进行类型转换。
- 拥有或者使用析构器。

```
struct Person
{
    var name:String
    var age:Int
    var gender:String
}
```

**subscript**：访问集合、列表或者序列的快捷方式。

```
var postMetrics = ["Likes":422, "ReadPercentage":0.58, "Views":3409]
let postLikes = postMetrics["Likes"]
```

**typealias**：将现有的类型的命名作为别名。

```
typealias JSONDictionary = [String: AnyObject]

func parseJSON(_ deserializedData:JSONDictionary){}
```

**var**：定义一个可变的变量。

```
var mutableString = ""
mutableString = "Mutated"
```

#### 语句中的关键字 ####

**break**：在结束一个循环，或者在 `if`、`switch` 中使用。

```
for idx in 0...3
{
    if idx % 2 == 0
    {
        //Exits the loop on the first even value
        break
    }
}
```
**case**：求值，然后和 `switch` 提供的类型来比较的语句。

```
let box = 1

switch box
{
case 0:
    print("Box equals 0")
case 1:
    print("Box equals 1")
default:
    print("Box doesn't equal 0 or 1")
}
```

**continue**：结束循环语句的当前迭代，但是不终止循环语句的继续执行。

```
for idx in 0...3
{
    if idx % 2 == 0
    {
        //Immediately begins the next iteration of the loop
        continue
    }

    print("This code never fires on even numbers")
}
```

**default**：用来覆盖在 `case` 结构中未被明确定义的值。

```
let box = 1

switch box
{
case 0:
    print("Box equals 0")
case 1:
    print("Box equals 1")
default:
    print("Covers any scenario that doesn't get addressed above.")
}
```

**defer**：用来执行在程序控制转移到作用域之外之前的代码。

```
func cleanUpIO()
{
    defer
    {
        print("This is called right before exiting scope")
    }

    //Close out file streams,etc.
}
```

**do**：一个前置语句，用来处理一块代码运行的错误。

```
do
{
    try expression
    //statements
}
catch someError ex
{
    //Handle error
}
```

**else**：与 `if` 语句联合使用，当条件为真时执行代码的一部分，当相同的条件为假的时候执行另一部分。

```
if 1 > val
{
    print("val is greater than 1")
}
else
{
    print("val is not greater than 1")
}
```

**fallthrough**：在 `switch` 语句中，明确允许一个 case 执行完继续执行下一个。

```
let box = 1

switch box
{
case 0:
    print("Box equals 0")
    fallthrough
case 1:
    print("Box equals 0 or 1")
default:
    print("Box doesn't equal 0 or 1")
}
```

**for**：对序列进行迭代，例如数字的范围、数组中的项或字符串里的字符。**和 `in` 关键字配对**

```
for _ in 0..<3 { print ("This prints 3 times") }
```

**guard**：在不满足一个或多个条件的情况下，将程序控制转移到作用域之外，同时还可以拆包任何可选类型。

```
private func printRecordFromLastName(userLastName: String?) 
{
    guard let name = userLastName, userLastName != "Null" else
    {
        //Sorry Bill Null, find a new job
        return
    }

    //Party on
    print(dataStore.findByLastName(name))
}
```

**if**：根据一个或者多个条件的值来执行代码。

```
if 1 > 2
{
    print("This will never execute")
}
```

**in**：对序列进行迭代，例如数字的范围、数组中的项或字符串里的字符。**和 `for` 关键字配对**

```
for _ in 0..<3 { print ("This prints 3 times") }
```

**repeat**：在考虑循环条件**之前**，执行一次循环里的内容。

```
repeat
{
    print("Always executes at least once before the condition is considered")
}
while 1 > 2
```

**return**：立即打断当前上下文的控制流，另外返回一个得到的值（如果存在的话）。

```
func doNothing()
{
    return //Immediately leaves the context

    let anInt = 0
    print("This never prints \(anInt)")
}
```

and

```
func returnName() -> String?
{
    return self.userName //Returns the value of userName
}
```

**switch**：考虑一个值，并与几种可能的匹配模式进行比较。然后根据成功匹配的第一个模式，执行合适的代码块。

```
let box = 1

switch box
{
case 0:
    print("Box equals 0")
    fallthrough
case 1:
    print("Box equals 0 or 1")
default:
    print("Box doesn't equal 0 or 1")
}
```

**where**：要求关联的类型必须符合一个特定的协议，或者和某些特定的参数类型相同。它也用于提供一个额外的控制条件，来判断一个模式是否符合控制表达式。**where 子句可以在多个上下文中使用，这些例子是 where 作为从句和模式匹配的主要用途。**

```
protocol Nameable
{
    var name:String {get set}
}

func createdFormattedName<T:Nameable>(_ namedEntity:T) -> String where T:Equatable
{
    //Only entities that conform to Nameable which also conform to equatable can call this function
    return "This things name is " + namedEntity.name
}
```

以及

```
for i in 0…3 where i % 2 == 0
{
    print(i) //Prints 0 and 2
}
```

**while**：执行一组语句，直到条件变为 `false'。

```
while foo != bar
{
    print("Keeps going until the foo == bar")
}
```

#### 表达式和类型关键字 ####

**Any**：可以用来表示任何类型的实例，包括函数类型。

```
var anything = [Any]()

anything.append("Any Swift type can be added")
anything.append(0)
anything.append({(foo: String) -> String in "Passed in \(foo)"})
```

**as**：类型转换运算符，用于尝试将值转换成不同的、预期的和特定的类型。

```
var anything = [Any]()

anything.append("Any Swift type can be added")
anything.append(0)
anything.append({(foo: String) -> String in "Passed in \(foo)" })

let intInstance = anything[1] as? Int
```

或

```
var anything = [Any]()

anything.append("Any Swift type can be added")
anything.append(0)
anything.append({(foo: String) -> String in "Passed in \(foo)" })

for thing in anything
{
    switch thing
    {
    case 0 as Int:
        print("It's zero and an Int type")
    case let someInt as Int:
        print("It's an Int that's not zero but \(someInt)")
    default:
        print("Who knows what it is")
    }
}
```

**catch**：如果一个错误在 `do` 从句中被抛出，它会根据 `catch` 从句来匹配错误会如何被处理。[**摘自我之前的一篇关于 Swift 的错误处理文章。**](https://medium.com/the-traveled-ios-developers-guide/swift-error-handling-2ccc1e305f3f#.tkyggy7cw)

```
do
{
    try haveAWeekend(4)
}
catch WeekendError.Overtime(let hoursWorked)
{
    print(“You worked \(hoursWorked) more than you should have”)
}
catch WeekendError.WorkAllWeekend
{
    print(“You worked 48 hours :-0“)
}
catch
{
    print(“Gulping the weekend exception”)
}
```

**false**：Swift 中用于表示逻辑类型 — 布尔类型的两个值之一，代表非真。

```
let alwaysFalse = false
let alwaysTrue = true

if alwaysFalse { print("Won't print, alwaysFalse is false 😉")} 
```

**is**：类型检查运算符，用来识别一个实例是否是特定的类型。

```
class Person {}
class Programmer : Person {}
class Nurse : Person {}

let people = [Programmer(), Nurse()]

for aPerson in people
{
    if aPerson is Programmer
    {
        print("This person is a dev")
    }
    else if aPerson is Nurse
    {
        print("This person is a nurse")
    }
}
```

**nil**：表示 Swift 中任何类型的无状态的值。**和 Objective-C 的 nil 不同，它是一个指向不存在对象的指针。**

```
class Person{}
struct Place{}

//Literally any Swift type or instance can be nil
var statelessPerson:Person? = nil
var statelessPlace:Place? = nil
var statelessInt:Int? = nil
var statelessString:String? = nil
```

**rethrows**：表明仅当该函数的一个函数类型的参数抛出错误时，该函数才抛出错误。

```
func networkCall(onComplete:() throws -> Void) rethrows
{
    do
    {
        try onComplete()
    }
    catch
    {
        throw SomeError.error
    }
}
```

**super**：公开的访问父类属性、方法或别名。

```
class Person
{
    func printName()
    {
        print("Printing a name. ")
    }
}

class Programmer : Person
{
    override func printName()
    {
        super.printName()
        print("Hello World!")
    }
}

let aDev = Programmer()
aDev.printName() //"Printing a name. Hello World!"
```

**self**：每个类型实例的隐含属性，它完全等于实例本身。在区别函数参数名和属性名时非常有用。

```
class Person
{
    func printSelf()
    {
        print("This is me: \(self)")
    }
}

let aPerson = Person()
aPerson.printSelf() //"This is me: Person"
```

**Self**：在协议里，代表最终符合给定协议的类型。

```
protocol Printable
{
    func printTypeTwice(otherMe:Self)
}

struct Foo : Printable
{
    func printTypeTwice(otherMe: Foo)
    {
        print("I am me plus \(otherMe)")
    }
}

let aFoo = Foo()
let anotherFoo = Foo()

aFoo.printTypeTwice(otherMe: anotherFoo) //I am me plus Foo()
```

**throw**：从当前上下文直接抛出一个错误。

```
enum WeekendError: Error
{
    case Overtime
    case WorkAllWeekend
}

func workOvertime () throws
{
    throw WeekendError.Overtime
}
```

**throws**：表示一个函数、方法或初始化方法可能会抛出一个错误。

```
enum WeekendError: Error
{
    case Overtime
    case WorkAllWeekend
}

func workOvertime () throws
{
    throw WeekendError.Overtime
}

//"throws" indicates in the function's signature that I need use try, try? or try!
try workOvertime()
```

**true**：Swift 中用于表示逻辑类型 — 布尔类型的两个值之一，代表真。

```
let alwaysFalse = false
let alwaysTrue = true

if alwaysTrue { print("Always prints")}
```

**try**：表示接下来的函数可能会抛出一个错误。有三种不同的用法：try、try? 和 try!。

```
let aResult = try dangerousFunction() //Handle it, or propagate it
let aResult = try! dangerousFunction() //This could trap
if let aResult = try? dangerousFunction() //Unwrap the optional
```

#### 关键字中使用模式 ####

**_**：通配符，匹配并忽略任何值。

```
for _ in 0..<3
{
    print("Just loop 3 times, index has no meaning")
}
```

another use

```
let _ = Singleton() //Ignore value or unused variable
```

#### 关键字中使用 # 

**#available**：`if`、`while` 和 `guard` 语句的条件，根据特定的平台，来在运行时查询 API 的可用性。

```
if #available(iOS 10, *)
{
    print("iOS 10 APIs are available")
}
```

**#colorLiteral**：playground 字面量，返回一个可交互的颜色选择器来赋值给一个变量。

```
let aColor = #colorLiteral //Brings up color picker
```

**#column**：特殊的文字表达式，返回它开始位置的列数。

```
class Person
{
    func printInfo()
    {
        print("Some person info - on column \(#column)") 
    }
}

let aPerson = Person()
aPerson.printInfo() //Some person info - on column 53
```

**#else**：编译条件控制语句，允许程序条件编译一些指定的代码。与 `＃if` 语句结合使用，当条件为真时执行代码的一部分，当相同的条件为假时执行另一部分。

```
#if os(iOS)
    print("Compiled for an iOS device")
#else
    print("Not on an iOS device")
#endif
```

**#elseif**：条件编译控制语句，允许程序条件编译一些指定的代码。与 `＃if` 语句结合使用，在给出的条件为真时，执行这部分的代码。

```
#if os(iOS)
    print("Compiled for an iOS device")
#elseif os(macOS)
    print("Compiled on a mac computer")
#endif
```

**#endif**：条件编译控制语句，允许程序条件编译一些指定的代码。用于标记结束需要条件编译的代码。

```
#if os(iOS)
    print("Compiled for an iOS device")
#endif
```

**#file**：特殊的文字表达式，返回这个文件的名称。

```
class Person
{
    func printInfo()
    {
        print("Some person info - inside file \(#file)") 
    }
}

let aPerson = Person()
aPerson.printInfo() //Some person info - inside file /*file path to the Playground file I wrote it in*/
```

**#fileReference**：playground 字面量，返回一个选择器来选择文件，然后作为一个 `NSURL` 实例返回。

```
let fontFilePath = #fileReference //Brings up file picker
```

**#function**：特殊的文字表达式，用来返回一个函数的名称，如果在方法里，它返回方法名，如果在属性的 getter 或者 setter 里，它返回属性的名称，如果在特殊的成员，比如 `init` 或者 `subscript`里，它返回关键字，如果在文件的顶部，那它返回当前模块的名称。

```
class Person
{
    func printInfo()
    {
        print("Some person info - inside function \(#function)") 
    }
}

let aPerson = Person()
aPerson.printInfo() //Some person info - inside function printInfo()
```

**#if**：条件编译控制语句，允许程序条件编译一些指定的代码。根据一个或多个条件来判断是否执行代码。

```
#if os(iOS)
    print("Compiled for an iOS device")
#endif
```

**#imageLiteral**：playground 字面量，返回一个选择器来选择图片，然后作为一个 `UIImage` 实例返回。

```
let anImage = #imageLiteral //Brings up a picker to select an image inside the playground file
```

**#line**：特殊的文字表达式，返回它所在位置的行数。

```
class Person
{
    func printInfo()
    {
        print("Some person info - on line number \(#line)") 
    }
}

let aPerson = Person()
aPerson.printInfo() //Some person info - on line number 5
```

**#selector**：构成 Objective-C 选择器的表达式，它使用静态检查来确保该方法存在，并且它也暴露给 Objective-C。

```
//Static checking occurs to make sure doAnObjCMethod exists
control.sendAction(#selector(doAnObjCMethod), to: target, forEvent: event)
```

**#sourceLocation**：用于指定行数和文件名的行控制语句，该行数和文件名可能和正在编译的源代码的行数和文件名不同。适用于诊断和调试时，更改源代码的位置。

```
#sourceLocation(file:"foo.swift", line:6)

//Reports new values
print(#file)
print(#line)

//This resets the source code location back to the default values numbering and filename
#sourceLocation()

print(#file)
print(#line)
```

#### 在特定上下文中的关键字 ####

- **如果这些关键字在它们各自的上下文之外使用，则它们实际上可以作为标识符**

**associativity**：指定如何在没有使用 `left`、`right` 或 `none` 分组括号的情况下，将具有相同优先级级别的运算符组合在一起。

```
infix operator ~ { associativity right precedence 140 }
4 ~ 8
```

**convenience**：类中的辅助初始化器，最终会把实例的初始化委托给特定的初始化器。

```
class Person
{
    var name:String


    init(_ name:String)
    {
        self.name = name
    }


    convenience init()
    {
        self.init("No Name")
    }
}

let me = Person()
print(me.name)//Prints "No Name"
```

**dynamic**：表示对该成员或函数的访问从未被编译器内联或虚拟化，这意味着对该成员的访问始终使用 Objective-C 运行时来动态（而非静态）派发。

```
class Person
{
    //Implicitly has the "objc" attribute now too
    //This is helpful for interop with libs or
    //Frameworks that rely on or are built
    //Around Obj-C "magic" (i.e. some KVO/KVC/Swizzling)
    dynamic var name:String?
}
```

**didSet**：属性观察，在属性存入一个值后立即调用。

```
var data = [1,2,3]
{
    didSet
    {
        tableView.reloadData()
    }
}
```

**final**：阻止方法、属性或者下标被继承。

```
final class Person {}
class Programmer : Person {} //Compile time error
```

**get**：返回成员给定的值。也用于计算属性，可以间接地获取其他属性和值。

```
class Person
{
    var name:String
    {
        get { return self.name }
        set { self.name = newValue}
    }

    var indirectSetName:String
    {
        get
        {
            if let aFullTitle = self.fullTitle
            {
                return aFullTitle
            }
            return ""
        }

        set (newTitle)
        {
            //If newTitle was absent, newValue could be used
            self.fullTitle = "\(self.name) :\(newTitle)"
        }

    }
}
```

**infix**：用于两个目标之间的特定运算符。如果一个新的全局运算符被定义为中置运算符，那它还需要成员之间的优先级组。

```
let twoIntsAdded = 2 + 3
```

**indirect**：表示枚举将另一个枚举的实例作为一个或多个枚举的关联值。

```
indirect enum Entertainment
{
    case eventType(String)
    case oneEvent(Entertainment)
    case twoEvents(Entertainment, Entertainment)
}

let dinner = Entertainment.eventType("Dinner")
let movie = Entertainment.eventType("Movie")

let dateNight = Entertainment.twoEvents(dinner, movie)
```

**lazy**：属性的初始值在第一次使用时再计算。

```
class Person
{
    lazy var personalityTraits = {
        //Some crazy expensive database  hit
        return ["Nice", "Funny"]
    }()
}

let aPerson = Person()
aPerson.personalityTraits //Database hit only happens now once it's accessed for the first time
```

**left**：指定操作符的关联顺序为从左到右，这样在没有分组括号的情况下，相同优先级的也会被正确的分到一组。

```
//The "-" operator's associativity is left to right
10-2-4 //Logically grouped as (10-2) - 4
```

**mutating**：允许在特定的方法中，对结构体或枚举的属性进行修改。

```
struct Person
{
    var job = ""

    mutating func assignJob(newJob:String)
    {
        self = Person(job: newJob)
    }
}

var aPerson = Person()
aPerson.job //""

aPerson.assignJob(newJob: "iOS Engineer at Buffer")
aPerson.job //iOS Engineer at Buffer
```

**none**：运算符没有提供任何关联性，这限制了相同优先级运算符的出现间隔。

```
//The "<" operator is a nonassociative operator
1 < 2 < 3 //Won't compile
```

**nonmutating**：指定成员的 setter 不会修改它包含的实例，但是可以有其他的目的。

```
enum Paygrade
{
    case Junior, Middle, Senior, Master

    var experiencePay:String?
    {
        get
        {
            database.payForGrade(String(describing:self))
        }

        nonmutating set
        {
            if let newPay = newValue
            {
                database.editPayForGrade(String(describing:self), newSalary:newPay)
            }
        }
    }
}

let currentPay = Paygrade.Middle

//Updates Middle range pay to 45k, but doesn't mutate experiencePay
currentPay.experiencePay = "$45,000"
```

**optional**：用于描述协议中的可选方法。这些方法不必由符合协议的类型来实现。

```
@objc protocol Foo
{
    func requiredFunction()
    @objc optional func optionalFunction()
}

class Person : Foo
{
    func requiredFunction()
    {
        print("Conformance is now valid")
    }
}
```

**override**：表示子类将提供自己的实例方法、类方法、实例属性，类属性或下标的自定义实现，否则它将从父类继承。

```
class Person
{
    func printInfo()
    {
        print("I'm just a person!")
    }
}


class Programmer : Person
{
    override func printInfo()
    {
        print("I'm a person who is a dev!")
    }
}


let aPerson = Person()
let aDev = Programmer()


aPerson.printInfo() //I'm just a person!
aDev.printInfo() //I'm a person who is a dev!
```

**postfix**：指定操作符在它操作的目标之后。

```
var optionalStr:String? = "Optional"
print(optionalStr!)
```

**precedence**：表示一个操作符的优先级高于其他，所以这些运行符先被应用。

```
infix operator ~ { associativity right precedence 140 }
4 ~ 8
```

**prefix**：指定操作符在它的操作的目标之前。

```
var anInt = 2
anInt = -anInt //anInt now equals -2
```

**required**：强制编译器确保每个子类都必须实现给定的初始化器。

```
class Person
{
    var name:String?


    required init(_ name:String)
    {
        self.name = name
    }
}


class Programmer : Person
{
    //Excluding this init(name:String) would be a compiler error
    required init(_ name: String)
    {
        super.init(name)
    }
}
```

**right**：指定操作符的关联顺序为从右到左，这样在没有分组括号的情况下，相同优先级的也会被正确的分到一组。

```
//The "??" operator's associativity is right to left
var box:Int?
var sol:Int? = 2


let foo:Int = box ?? sol ?? 0 //Foo equals 2
```

**set**：获取成员的值来作为它的新值。也可用于计算属性，间接地设置其他属性和值。如果一个计算属性的 setter 没有定义一个名字来代表要设置的新值，那么默认新值的名字为 `newValue`。 

```
class Person
{
    var name:String
    {
        get { return self.name }
        set { self.name = newValue}
    }


    var indirectSetName:String
    {
        get
        {
            if let aFullTitle = self.fullTitle
            {
                return aFullTitle
            }
            return ""
        }


        set (newTitle)
        {
            //If newTitle was absent, newValue could be used
            self.fullTitle = "\(self.name) :\(newTitle)"
        }
    }
}
```

**Type**：代指任何类型的类型，包括类的类型、结构体的类型、枚举类型和协议类型。

```
class Person {}
class Programmer : Person {}


let aDev:Programmer.Type = Programmer.self
```

**unowned**：在循环引用中，一个实例引用另一个实例，在另一个实例具有相同的生命周期或更长的生命周期时，不会对它强持有。

```
class Person
{
    var occupation:Job?
}


//Here, a job never exists without a Person instance, and thus never outlives the Person who holds it.
class Job
{
    unowned let employee:Person


    init(with employee:Person)
    {
        self.employee = employee
    }
}
```

**weak**：在循环引用中，一个实例引用另一个实例，在另一个实例具有较短生命周期时，不会对它强持有。

```
class Person
{
    var residence:House?
}


class House
{
    weak var occupant:Person?
}


var me:Person? = Person()
var myHome:House? = House()


me!.residence = myHome
myHome!.occupant = me


me = nil
myHome!.occupant //Is now nil
```

**willSet**：属性观察，在属性即将存入一个值之前调用。

```
class Person
{
    var name:String?
    {
        willSet(newValue) {print("I've got a new name, it's \(newValue)!")}
    }
}


let aPerson = Person()
aPerson.name = "Jordan" //Prints out "I've got a new name, it's Jordan!" right before name is assigned to
```

#### 最后的思考 ####

呼!

这是一个有趣的创作。我选了一些我以前没有真正仔细思考的东西写，但是我认为这些技巧是**不需要**像要考试的列表一样记住的。

更好的是，随时带着这个列表。让它随时的刺激着你的脑波，这样在你需要使用一些特定的关键字的时候，你就会知道它，然后使用它。

下次再见 — 感谢阅读 ✌️。
