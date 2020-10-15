> * 原文地址：[A Comprehensive Guide to Slices in Golang](https://codeburst.io/a-comprehensive-guide-to-slices-in-golang-bacebfe46669)
> * 原文作者：[Radhakishan Surwase](https://medium.com/@rksurwase)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/a-comprehensive-guide-to-slices-in-golang.md](https://github.com/xitu/gold-miner/blob/master/article/2020/a-comprehensive-guide-to-slices-in-golang.md)
> * 译者：[JalanJiang](http://jalan.space/)
> * 校对者：[Emin](https://github.com/Eminlin)，[Samuel Jie](https://github.com/suhanyujie)

# Golang 切片综合指南

![由于 [Paweł Czerwiński](https://unsplash.com/@pawel_czerwinski) 拍摄于 [Unsplash](https://unsplash.com/s/photos/array)](https://cdn-images-1.medium.com/max/12000/1*i7lsjZyVnJxDEIg8Qibdlw.jpeg)

在这篇文章中，我们将复习「切片」的概念，它是 Golang 中一个重要的数据结构，这一数据结构为你提供了处理与管理数据集合的方法。切片是围绕着动态数组的概念构建的，它与动态数组相似，可以根据你的需要而伸缩。

* 就增长而言，切片是**动态**的，因为它们有自己的内置函数 **append**，可以快速高效地增长切片。
* 你还可以通过切割底层内存来减少切片的大小。
* 在底层内存中切片是在连续的块上分配的，因此切片为你提供的便利之处包括：索引、迭代与垃圾回收优化。

#### 切片的表示

* 切片不存储任何数据，它仅描述底层数组的一部分。
* 切片使用一个包含三个字段的结构表示：指向底层数组的指针（pointer）、长度（length）与容量（capacity）。
* 这个数据结构类似于切片的描述符。

![图 1：切片的表示](https://cdn-images-1.medium.com/max/2000/1*PW4Y8P0_gTspgYwcxfDrtQ.png)

* **指针（Pointer）：**指针用于指向数组的第一个元素，这个元素可以通过切片进行访问。在这里，指向的元素不必是数组的第一个元素。
* **长度（Length）：**长度代表数组中所有元素的总数。
* **容量（Capacity）：**容量表示切片可扩展的最大大小。 

#### 使用长度声明一个切片

在声明切片过程中，当你仅指定长度（Length）时，容量（Capacity）值与长度（Length）值相同。

![图 2：使用长度声明一个切片。](https://cdn-images-1.medium.com/max/2000/1*5ssbGNTliiFWF_rcxN6RRg.png)

```Go
// 使用长度声明一个切片。创建一个整型切片。
// 长度和容量均为 5。
slice := make([]int, 5)
fmt.Println(len(slice)) // 打印结果 5
fmt.Println(cap(slice)) // 打印结果 5
```

#### 使用长度和容量声明一个切片

在声明切片过程中，当你分别指定长度（Length）和容量（Capacity）时，这将初始化一段无法访问的底层数组来创建一个具有可用容量的切片。

```Go
/* 
 使用长度和容量声明一个切片
 创建一个整型切片。
 长度为 3，容量为 5 。
*/
slice := make([]int, 3, 5)
fmt.Println(len(slice)) // 打印结果 3
fmt.Println(cap(slice)) // 打印结果 5
```

![图 3：使用长度和容量声明一个切片。](https://cdn-images-1.medium.com/max/2000/1*6OLPqO2Z2x-QKPU_9EDA2A.png)

但请注意，尝试创建容量小于长度的切片是不允许的。

#### 使用切片字面量创建切片

创建**切片**的惯用方法是使用**切片字面量**。它与创建数组相似，只是它不需要在 [ ] 操作符中指定值。你初始化切片时所用元素的数量将决定切片的初始长度与容量。

```Go
// 创建字符串类型切片。
// 长度与容量均为 5。
slice := []string{"Red", "Blue", "Green", "Yellow", "Pink"} 
fmt.Println(len(slice)) // 打印结果 5
fmt.Println(cap(slice)) // 打印结果 5
// 创建一个整型切片。
// 长度与容量均为 3。
intSlice:= []int{10, 20, 30}
fmt.Println(len(intSlice)) // 打印结果 3
fmt.Println(cap(intSlice)) // 打印结果 3
```

#### 声明一个带有索引位置的切片

当使用切片**字面量**时，你可以初始化切片的**长度**与**容量**。你所需要做的就是初始化表示所需长度和容量的**索引**。下面的语法将创建一个长度和容量均为 100 的切片。

```Go
// 创建字符串类型切片。
// 用空字符串初始化第 100 个元素。
slice := []int{99: 88}
fmt.Println(len(slice)) 
// 打印结果 100
fmt.Println(cap(slice)) 
// 打印结果 100
```

![图 4: 声明一个带有索引位置的切片。](https://cdn-images-1.medium.com/max/2000/1*nG722TP5WDx3hZOHBpcFyQ.png)

#### 声明数组与切片的区别

* 如果你使用 [ ] 操作符中指定一个值，那么你在创建一个数组。
* 如果你不在 [ ] 中指定值，则创建一个切片。

```Go
// 创建一个包含 3 个整数的数组。
array := [3]int{10, 20, 30} 

// 创建一个长度和容量均为 3 的整型切片。
slice := []int{10, 20, 30}

```

#### 声明一个 nil 切片

* 切片用 `nil` 代表零值。
* 一个 nil 切片的长度和容量等于 0，且没有底层数组。

```Go
// 创建一个整型 nil 切片。
var slice []int32
fmt.Println(slice == nil) 
// 此行将打印 true
fmt.Println(len(slice))   
// 此行将打印 0
fmt.Println(cap(slice))
// 此行将打印 0
```

![图 5：声明 nil 切片。](https://cdn-images-1.medium.com/max/2000/1*2KWa4gM4_M_47eBcKISK9w.png)

#### 声明一个空切片

还可以通过初始化声明切片创建一个空切片。

```Go
// 使用 make 来创建一个整型空切片。
sliceOne := make([]int, 0)
// 使用切片字面量创建一个整型空切片。
sliceTwo := []int{}
fmt.Println(sliceOne == nil) // 这将打印 false
fmt.Println(len(sliceOne))   // 这将打印 0 
fmt.Println(cap(sliceOne))   // 这将打印 0
fmt.Println(sliceTwo == nil) // 这将打印 false
fmt.Println(len(sliceTwo))   // 这将打印 0
fmt.Println(cap(sliceTwo))   // 这将打印 0
```

![图 6：声明一个空切片。](https://cdn-images-1.medium.com/max/2000/1*x3dfcqD71X5M0G2F4D7QoQ.png)

#### 为任何特定索引赋值

要修改单个元素的值，请使用 [ ] 操作符。

```Go
// 创建一个整型切片。
// 包含 4 个元素的长度和容量。
slice := []int{10, 20, 30, 40}
fmt.Println(slice) // 这将打印 [10 20 30 40]
slice[1] = 25 // 改变索引 1 的值。
fmt.Println(slice) // 这将打印 [10 25 30 40]
```

![图 7：为任何特定索引赋值。](https://cdn-images-1.medium.com/max/2000/1*E-LTi2XYMjW0m5RGwzfktQ.png)

#### 对切片进行切片

我们之所以称呼切片为切片，是因为你可以通过对底层数组的一部分进行切片来创建一个新的切片。

```Go
/* 创建一个整型切片。
长度和容量均为 5。*/
slice := []int{10, 20, 30, 40, 50}
fmt.Println(slice)  // 打印 [10 20 30 40 50]
fmt.Println(len(slice)) // 打印 5
fmt.Println(cap(slice)) // 打印 5
/* 创建一个新切片。
长度为 2，容量为 4。*/
newSlice := slice[1:3]
fmt.Println(slice)  // 打印 [10 20 30 40 50]
fmt.Println(len(newSlice))  // 打印 2
fmt.Println(cap(newSlice))  // 打印 4
```

![图 8：对切片进行切片。](https://cdn-images-1.medium.com/max/2000/1*7g5CJ002CXIEo9iQn-Dp6A.png)

在执行切片操作之后，我们拥有两个共享同一底层数组的切片。然而，这两个切片以不同的方式查看底层数组。原始切片认为底层数组的容量为 5，但 newSlice 与之不同，对 newSlice 而言，底层数组的容量为 4。newSlice 无法访问位于其指针之前的底层数组元素。就 newSlice 而言，这些元素甚至并不存在。使用下面的方式可以为任意切片后的 newSlice 计算长度和容量。

#### 切片的长度与容量如何计算？

> 切片 **slice[i:j]** 的**底层数组容量为 k** 
长度（Length）：j - i 
容量（Capacity）：k - i

**计算新的长度和容量**

> 切片 **slice[1:3]** 的**底层数组容量为 5** 
长度（Length）：3 - 1 = 2 
容量（Capacity）：5 - 1 = 4

#### 对一个切片进行更改的结果

一个切片对底层数组的共享部分所做的更改可以被另一个切片看到。

```Go
// 创建一个整型切片。
// 长度和容量均为 5。
slice := []int{10, 20, 30, 40, 50}
// 创建一个新的切片。
// 长度为 2，容量为 4。
newSlice := slice[1:3]
// 变更新切片索引 1 位置的元素。
// 改变了原切片索引 2 位置的元素。
newSlice[1] = 35
```

将数值 35 分配给 newSlice 的第二个元素后，该更改也可以在原始切片的元素中被看到。

#### 运行时错误显示索引超出范围

一个切片只能访问它长度以内的索引位。尝试访问超出长度的索引位元素将引发一个运行时错误。与切片容量相关联的元素只能用于切片增长。

```Go
// 创建一个整型切片。
// 长度和容量均为 5。
slice := []int{10, 20, 30, 40, 50}
// 创建一个新的切片。
// 长度为 2，容量为 4。
newSlice := slice[1:3]
// 变更 newSlice 索引 3 位置的元素。
// 对于 newSlice 而言，该元素不存在。
newSlice[3] = 45

/*
Runtime Exception:
panic: runtime error: index out of range
*/
```

#### 切片增长

与使用数组相比，使用切片的优势之一是：你可以根据需要增加切片的容量。当你使用内置函数 「append」 时，Golang 会负责处理所有操作细节。

* 使用 append 前，你需要一个源**切片**和一个要追加的值。
* 当你的 append 调用并返回时，它将为你提供一个更改后的新切片。 
* **append** 函数总会增加新切片的长度。
* 另一方面，容量可能会受到影响，也可能不会受到影响，这取决于源切片的可用容量。

#### 使用 append 向切片追加元素

```Go
/* 创建一个整型切片。
 长度和容量均为 5。 */
slice := []int{10, 20, 30, 40, 50}

/* 创建一个新切片。
 长度为 2，容量为 4。*/
newSlice := slice[1:3]
fmt.Println(len(newSlice)) // 打印 2
fmt.Println(cap(newSlice)) // 打印 4

/* 向容量空间分配新元素。
 将值 60 分配给新元素。 */
newSlice = append(newSlice, 60)
fmt.Println(len(newSlice)) // 打印 3
fmt.Println(cap(newSlice)) // 打印 4
```

当切片的底层数组没有可用容量时，append 函数将创建一个新的底层数组，拷贝正在引用的现有值，然后再分配新值。

#### 使用 append 增加切片的长度和容量

```Go
// 创建一个整型切片。
// 长度和容量均为 4。
slice := []int{10, 20, 30, 40}
fmt.Println(len(slice)) // 打印 4
fmt.Println(cap(slice)) // 打印 4

// 向切片追加新元素。
// 将值 50 分配给新元素。
newSlice= append(slice, 50)
fmt.Println(len(newSlice)) // 打印 5
fmt.Println(cap(newSlice)) // 打印 8
```

![图 9：增加切片的长度和容量](https://cdn-images-1.medium.com/max/2000/1*GeiklLBspOlv_qxzw5GCVA.png)

在 append 操作后，newSlice 被给予一个自有的底层数组，该底层数组的容量是原底层数组容量的两倍。在增加底层数组容量时，append 操作十分聪明。举个例子，当切片的容量低于 1,000 个元素时，容量增长总是翻倍的。一旦元素的数量超过 1,000 个，容量就会增长 1.25 倍，即 25%。随着时间的推移，这种增长算法可能会在 Golang 中发生变化。

更改新切片不会对旧切片产生任何影响，因为新切片现在有一个不同的底层数组，它的指针指向一个新分配的数组。

#### 将一个切片追加到另一个切片中

内置函数 **append** 还是一个 **可变参数** 函数。这意味着你可以传递多个值来追加到单个切片中。如果你使用 … 运算符，可以将一个切片的所有元素追加到另一个切片中。

```Go
// 创建两个切片，使用两个整型元素初始化每个切片。
slice1:= []int{1, 2}
slice2 := []int{3, 4}
// 合并两个切片并打印结果。
fmt.Println(append(slice1, slice2...))
// 输出：[1 2 3 4]
```

#### 对切片执行索引

* 通过指定一个下限和一个上限来形成切片，例如：`a[low:high]`。这将选择一个半开范围，其中包含切片的第一个元素，但不包含切片的最后一个元素。
* 你可以省略上限或下限，这将使用它们的默认值。下限的默认值是 0，上限的默认值是切片的长度。

```Go
a := [...]int{0, 1, 2, 3} 
// 一个数组
s := a[1:3]               
// s == []int{1, 2}        
// cap(s) == 3
s = a[:2]                 
// s == []int{0, 1}        
// cap(s) == 4
s = a[2:]                 
// s == []int{2, 3}        
// cap(s) == 2
s = a[:]                  
// s == []int{0, 1, 2, 3}  
// cap(s) == 4
```

#### 遍历切片

Go 有一个特殊的关键字 **range**，你可以使用该关键字对切片进行遍历。

```Go
// 创建一个整型切片。
// 长度和容量均为 4。
slice := []int{10, 20, 30, 40}
// 遍历每个元素并打印值。
for index, value := range slice {
   fmt.Printf("Index: %d Value: %d\n", index, value)
}
/*
输出：
Index: 0 Value: 10
Index: 1 Value: 20
Index: 2 Value: 30
Index: 3 Value: 40
*/
```

* 在遍历切片时，关键字 range 将返回两个值。
* 第一个值是索引下标，第二个值是索引位中值的副本。
* 一定要知道 range 是在复制值，而不是返回值的引用。

```Go
/*
 创建一个整型切片。
 长度与容量均为 4。
*/
slice := []int{10, 20, 30, 40}
/*
 遍历每个元素并打印
 元素的值和地址。
*/
for index, value := range slice {
   fmt.Printf("Value: %d Value-Addr: %X ElemAddr: %X\n",
   value, &value, &slice[index])
}
/*
Output:
Value: 10 Value-Addr: 10500168 ElemAddr: 1052E100
Value: 20 Value-Addr: 10500168 ElemAddr: 1052E104
Value: 30 Value-Addr: 10500168 ElemAddr: 1052E108
Value: 40 Value-Addr: 10500168 ElemAddr: 1052E10C
*/
```

**range** 关键字提供元素的拷贝。

如果你不需要下标值，你可以使用下划线字符丢弃该值。

```Go
// Create a slice of integers.
// Contains a length and capacity of 4 elements.
slice := []int{10, 20, 30, 40}
// Iterate over each element and display each value.
for _, value := range slice {
   fmt.Printf("Value: %d\n", value)
}
/*
Output:
Value: 10
Value: 20
Value: 30
Value: 40
*/
```

关键字 **range** 总是从开始处遍历一个切片。如果你需要对切片的迭代进行更多的控制，你可以使用传统的 **for** 循环。

```Go
// 创建一个整型切片。
// 长度和容量均为 4。
slice := []int{10, 20, 30, 40}
// 从元素 30 开始遍历每个元素。
for index := 2; index < len(slice); index++ {
   fmt.Printf("Index: %d Value: %d\n", index, slice[index])
}
/* 
输出：
Index: 2 Value: 30
Index: 3 Value: 40
*/
```

#### 总结

在本文中，我们深入探讨了切片的概念。我们了解到，切片并不存储任何数据，而是描述了底层数组的一部分。我们还看到，切片可以在底层数组的范围内增长和收缩，并配合索引可作为数组使用；切片的零值是 nil；函数 **len**、**cap** 和 **append** 都将 **nil** 看作一个长度和容量都为 0 的**空切片**；你可以通过**切片字面量**或调用 **make** 函数（将长度和容量作为参数）来创建切片。希望这些对你有所帮助！

**免责声明**

我参考了各种博客、书籍和媒体故事来撰写这篇文章。如有任何疑问，请在评论中与我联系。

**到此为止……开心编码……快乐学习😃**

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
