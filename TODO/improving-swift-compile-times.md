> * 原文地址：[Improving Swift compile times](https://medium.com/@johnsundell/improving-swift-compile-times-ee1d52fb9bd#.hfqaeq76p)
* 原文作者：[John Sundell](https://medium.com/@johnsundell?source=post_header_lockup)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[Deepmissea](http://deepmissea.blue)
* 校对者：[atuooo](http://atuo.xyz)，[1992chenlu](https://github.com/1992chenlu)

# 优化 Swift 的编译时间

在 Swift 所有的特性中，有一件事有时会相当恼人，那就是在用 Swift 编写更大规模的项目时，它**一般**会编译多久。尽管 Swift 编译器在保证运行时安全方面做的更多，但是它的编译时间要比 Objective-C 编译时间长很多。（所以）我想研究一下，是否我们可以帮助编译器让他工作的更快。

所以，上周我投身于 [Hyper](http://www.hyper.no) 上的一个较大的 Swift 项目。它大概有 350 个源文件以及 30,000 行的代码。最后我设法将这个项目的平均构建时间减少了 [20%](https://twitter.com/johnsundell/status/837318595973611521)。所以我想在我这周的博客上详细的介绍我是怎么做的。

现在，在我们开始之前，我只想说**我不想这篇文章以任何形式的方式来批判 Swift 或它的团队工作**。我知道 Swift 编译器的开发者，包含 Apple 公司和开源社区，都在持续地对编译器速度、功能和稳定性做出重大改进。希望这篇博文能随着时间的流逝而显得多余，但在那之前，我只是想提供一些我发现可以提升编译速度的实用技巧。

#### Step 1: 采集数据

在开始优化工作之前，建立一个能衡量你改进的基准总是好的。我是通过在 Xcode 里，给应用的 target 添加两个简单的脚本作为**运行脚本阶段**来实现的。

在**编译源文件**之前，添加下面的脚本：

```
echo "$(date +%s)" > "buildtimes.log"
```

在最后，添加这个脚本：

```
startime=$(<buildtimes.log)
endtime=$(date +%s)
deltatime=$((endtime-startime))
newline=$'\n'

echo "[Start] $startime$newline[End] $endtime$newline[Delta] $deltatime" > "buildtimes.log"
```

现在，这个脚本只会测算编译器编译**应用自己的源文件**的时间（为了测量出整个引用的编译时间，你可以使用 Xcode 的特性来挂载(hook)到 **Build Starts** 和 **Build Succeeds** 上）。由于编译时间非常依赖于编译它的设备，所以我也 **git ignored 了 buildtimes.log 文件**。

接下来，我想突出哪些个别代码块耗费了额外的长时间来编译，以便识别瓶颈，这样我就可以修复它。要做到这个，只需要通过向 Xcode 中 Build Setting 里的 **Other Swift Flags** 传递下面的参数给 Swift 编译器来设置一个临界值：

```
-Xfrontend -warn-long-function-bodies=500
```

使用上面的参数后，在你的项目中，如果有任何函数耗费了超过 500 毫秒的编译时间，你就会得到一个警告。这是我开始设置的临界值（并且随着我对更多瓶颈的修复，这个值在不断的降低）。

#### Step 2: 消除所有的警告

在设置了函数编译时间过长的警告之后，你可能会在项目中开始发现一些。最开始，你会觉得编译时间过长的函数是随机的，但是很快模式（patterns）就开始出现了。这里我注意到了两个使 Swift 3.0 编译器编译函数时间过长的常见模式：

**自定义运算符（特别是带有通用参数的重载）**

当 Swift 出现时，对于大多数 iOS 和 macOS 开发者来说，运算符重载是全新的概念之一，但就像许多新鲜事物一样，我们很兴奋的使用它们。现在，我不打算在这讨论自定义或重载运算符是好是坏，但它们的确对编译时间有很大影响，尤其是如果使用更加复杂的表达式。

思考下面的运算符，它将两个 **IntegerConvertible** 类型的数字加起来，构成了自定义的数字类型：

```
func +<A: IntegerConvertible,
       B: IntegerConvertible>(lhs: A, rhs: B) -> CustomNumber {
    return CustomNumber(int: lhs.int + rhs.int)
}
```

然后我们用它来让几个数字相加：

```
func addNumbers() -> CustomNumber {
    return CustomNumber(int: 1) +
           CustomNumber(int: 2) +
           CustomNumber(int: 3) +
           CustomNumber(int: 4) +
           CustomNumber(int: 5)
}
```

看上去很简单，但是上面的 **addNumbers()** 函数会花费很长一段时间来编译（在我 2013 年的 MBP 上超过 **300 ms**）。对比一下，如果我们用协议扩展来实现相同逻辑：

```
extension IntegerConvertible {
    func add<T: IntegerConvertible>(_ number: T) -> CustomNumber {
        return CustomNumber(int: int + number.int)
    }
}

func addNumbers() -> CustomNumber {
    return CustomNumber(int: 1).add(CustomNumber(int: 2))
                               .add(CustomNumber(int: 3))
                               .add(CustomNumber(int: 4))
                               .add(CustomNumber(int: 5))
}
```

通过这个改变，我们的 **addNumbers()** 函数现在编译时间**不到 1 ms**。**这快了 300 倍！**

所以，如果你大量的使用了自定义/重载运算符，特别是带有通用参数的（或者如果你使用的第三方库来做这些，比如许多自动布局的库），考虑一下用普通函数、协议扩展或其他的技术来重写吧。

**集合字面量**

另一个我发现的编译时间瓶颈是使用集合字面量，特别是编译器需要做很多工作来推断那些字面量的类型。让我们假设你有一个函数，它要把模型转换成一个类似 JSON 的字典，像这样：

```
extension User {
    func toJSON() -> [String : Any] 
        return [
            "firstName": firstName,
            "lastName": lastName,
            "age": age,
            "friends": friends.map { $0.toJSON() },
            "coworkers": coworkers.map { $0.toJSON() },
            "favorites": favorites.map { $0.toJSON() },
            "messages": messages.map { $0.toJSON() },
            "notes": notes.map { $0.toJSON() },
            "tasks": tasks.map { $0.toJSON() },
            "imageURLs": imageURLs.map { $0.absoluteString },
            "groups": groups.map { $0.toJSON() }
        ]
    }
}
```

上面 **toJSON()** 函数在我的电脑上大概要 **500 ms** 的时间来编译。现在让我们试着逐行重构这个像字典的东西来代替字面量：

```
extension User {
    func toJSON() -> [String : Any] {
        var json = [String : Any]()
        json["firstName"] = firstName
        json["lastName"] = lastName
        json["age"] = age
        json["friends"] = friends.map { $0.toJSON() }
        json["coworkers"] = coworkers.map { $0.toJSON() }
        json["favorites"] = favorites.map { $0.toJSON() }
        json["messages"] = messages.map { $0.toJSON() }
        json["notes"] = notes.map { $0.toJSON() }
        json["tasks"] = tasks.map { $0.toJSON() }
        json["imageURLs"] = imageURLs.map { $0.absoluteString }
        json["groups"] = groups.map { $0.toJSON() }
        return json
    }
}
```

它现在编译时间大概在 **5 ms** 左右，**提高了 100 倍！**

#### Step 3: 结论 ####

上面的两个例子非常清晰的说明了 Swift 编译器的一些新特性，比如类型推演和重载，都是付出了时间开销。如果我们仔细思考一下，也很符合逻辑。由于编译器不得不做更多的工作来执行推演，所以花费了更多的时间。但是我们也看到了，如果我们稍微调整一下我们的代码，帮助编译器更简单的解决表达式，我们就可以很大程度的加快编译时间。

现在，我不是说你要一直让编译时间来决定你写代码的方式。有时可以让它做更多的工作，让你的代码更加清晰并且容易理解。但是在大型的项目中，每个函数要用 300-500 ms 范围（或更多）的时间来编译的编码技术可能很快就会成为一个问题。我的建议是对你的编译时间保持监控，使用上面的编译标记设置一个合理的临界值，并在发现问题的时候解决问题。

我确信上面的例子肯定没有涵盖所有潜在的编译时间改进的方法，所有我很愿意听到你的意见。如果你有任何有用的改进大型 Swift 项目编译时间的其他的技术，你可以写在 Medium 上回复，或者在 [**Twitter @johnsundell**](https://twitter.com/johnsundell) 上联系我。

感谢阅读！🚀
