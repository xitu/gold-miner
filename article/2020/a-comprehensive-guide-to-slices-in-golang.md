> * 原文地址：[A Comprehensive Guide to Slices in Golang](https://codeburst.io/a-comprehensive-guide-to-slices-in-golang-bacebfe46669)
> * 原文作者：[Radhakishan Surwase](https://medium.com/@rksurwase)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/a-comprehensive-guide-to-slices-in-golang.md](https://github.com/xitu/gold-miner/blob/master/article/2020/a-comprehensive-guide-to-slices-in-golang.md)
> * 译者：[JalanJiang](http://jalan.space/)
> * 校对者：

# Golang 切片综合指南

![由于 [Paweł Czerwiński](https://unsplash.com/@pawel_czerwinski) 拍摄于 [Unsplash](https://unsplash.com/s/photos/array)](https://cdn-images-1.medium.com/max/12000/1*i7lsjZyVnJxDEIg8Qibdlw.jpeg)

在这篇文章中，我们将复习「切片」的概念，它是 Golang 中一个重要的数据结构，这一数据结构为你提供了处理与管理数据集合的方法。切片是围绕着动态数组的概念构建的，它与动态数组相似，可以根据你的需要而伸缩。

* 就增长而言，切片是**动态**的，因为它们有自己的内置函数 **`append`**，可以快速高效地增长切片。
* 你还可以通过切割底层内存来减少切片的大小。
* 在底层内存中切片是在连续的块上分配的，因此切片为你提供的便利之处包括索引、迭代与垃圾回收优化。

#### Slice representation
#### 切片的表示

* 切片不存储任何数据，它仅描述底层数组的一部分。
* The slice is represented using a three filed structure name pointer to the underlying array, length, and capacity.
* 切片使用一个包含三个字段的结构表示：指向底层数组的指针（pointer）、长度（length）与容量（capacity）。
* 这个数据结构类似于切片的描述符。

![图 1：切片的表示](https://cdn-images-1.medium.com/max/2000/1*PW4Y8P0_gTspgYwcxfDrtQ.png)

* **指针（Pointer）：**指针用于指向数组的第一个元素，这个元素可以通过切片进行访问。在此处，指向的元素不必是数组的第一个元素。
* **长度（Length）：**长度代表数组中所有元素的总数。
* **容量（Capacity）：**容量表示切片可扩展的最大大小。 

#### 使用长度声明一个切片

在声明切片过程中，当你仅指定长度（Length）时，容量（Capacity）值与长度（Length）值相同。

![图 2：使用长度声明一个切片。](https://cdn-images-1.medium.com/max/2000/1*5ssbGNTliiFWF_rcxN6RRg.png)

```Go
// 使用长度声明一个切片。创建一个整型切片。
// 包含 5 个元素的长度和容量。
slice := make([]int, 5)
fmt.Println(len(slice)) // 打印结果 5
fmt.Println(cap(slice)) // 打印结果 5
```

#### 使用长度和容量声明一个切片

在声明切片过程中，当你分别指定长度（Length）和容量（Capacity）时，可以使用底层数组中最初无法访问的可用容量创建一个切片。

```Go
/* 
 使用长度和容量声明一个切片
 创建一个整型切片。
 包含长度为 3 容量为 5 的元素。
*/
slice := make([]int, 3, 5)
fmt.Println(len(slice)) // 打印结果 3
fmt.Println(cap(slice)) // 打印结果 5
```

![图 3：使用长度和容量声明一个切片。](https://cdn-images-1.medium.com/max/2000/1*6OLPqO2Z2x-QKPU_9EDA2A.png)

但请注意，尝试创建容量小于长度的切片是不允许的。

#### 使用切片字面量创建切片

创建**切片**的惯用方法是使用**切片字面量**。它与创建数组相似，只是它不需要在 `[ ]` 操作符中指定值。你初始化切片时所用元素数量将决定切片的初始长度与容量。

```Go
// 创建字符串类型切片。
// 包含 5 个元素的长度与容量。
slice := []string{"Red", "Blue", "Green", "Yellow", "Pink"} 
fmt.Println(len(slice)) // 打印结果 5
fmt.Println(cap(slice)) // 打印结果 5
// 创建蒸型切片。
// 包含 3 个元素的长度与容量。
intSlice:= []int{10, 20, 30}
fmt.Println(len(intSlice)) // 打印结果 3
fmt.Println(cap(intSlice)) // 打印结果 3
```

#### 声明一个带有索引位置的切片

When using a slice **literal**, you can set the initial **length** and **capacity**. All you need to do is initialize the **index** that represents the length and capacity you need. The following syntax will create a slice with a length and capacity of 100 elements.
当使用切片**字面量**时，你可以初始化切片的**长度**与**容量**。你所需要做的就是初始化表示所需长度和容量的**索引**。下面的语法将创建一个长度和容量都为 100 个元素的切片。

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

#### 数组与切片声明的区别

* 如果你使用 `[ ]` 操作符中指定一个值，那么你在创建一个数组。
* 如果你不在 `[ ]` 中指定值，则创建一个切片。

```Go
// 创建一个包含三个整数的数组。
array := [3]int{10, 20, 30} 

// 创建一个长度和容量均为 3 的整型切片。
slice := []int{10, 20, 30}

```

#### 声明一个 nil 切片

* 切片用 `nil` 代表零值。
* 一个空切片的长度和容量等于 0，且没有底层数组。

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

要修改单个元素的值，请使用 `[ ]` 操作符。

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

Slices are called such because you can slice a portion of the underlying array to create a new slice.
之所以这样称呼切片，是因为你可以通过对底层数组的一部分进行切片来创建一个新的切片。

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

在执行切片操作之后，我们拥有两个共享同一底层数组的切片。然而，这两个切片以不同的方式查看底层数组。原始切片认为底层数组的容量为 5，但 `newSlice` 与之不同，对 `newSlice` 而言，底层数组的容量为 4。`newSlice` 无法访问位于其指针之前的底层数组元素。就 `newSlice` 而言，这些元素甚至并不存在。下面我们将介绍计算新切片长度和容量的公式。

#### 切片的长度与容量如何计算？

> 切片 **slice[i:j]** 的**底层数组容量为 k** 
长度（Length）：j - i 
容量（Capacity）：k - i

**计算新的长度和容量**

> 切片 **slice[1:3]** 的**底层数组容量为 5** 
长度（Length）：3 - 1 = 2 
容量（Capacity）：5 - 1 = 4

#### The consequences of making changes to a slice

Changes made to the shared section of the underlying array by one slice can be seen by the other slice.

```Go
// Create a slice of integers.
// Contains a length and capacity of 5 elements.
slice := []int{10, 20, 30, 40, 50}
// Create a new slice.
// Contains a length of 2 and capacity of 4 elements.
newSlice := slice[1:3]
// Change index 1 of newSlice.
// Change index 2 of the original slice.
newSlice[1] = 35
```

After the number 35 is assigned to the second element of newSlice, that change can also be seen by the original slice in the element.

#### Run time error showing index out of range

A slice can only access indexes up to its length. Trying to access an element outside of its length will cause a run-time exception. The elements associated with a slice’s capacity are only available for growth.

```Go
// Create a slice of integers.
// Contains a length and capacity of 5 elements.
slice := []int{10, 20, 30, 40, 50}
// Create a new slice.
// Contains a length of 2 and capacity of 4 elements.
newSlice := slice[1:3]
// Change index 3 of newSlice.
// This element does not exist for newSlice.
newSlice[3] = 45

/*
Runtime Exception:
panic: runtime error: index out of range
*/
```

#### Growing slices

One of the advantages of using a slice over using an array is that you can grow the capacity of your slice as needed. Golang takes care of all the operational details when you use the built-in function “append”.

* To use append, you need a source **slice** and a value that is to be appended.
* When your append call returns, it provides you a new slice with the changes.
* The **append** function will always increase the length of the new slice.
* The capacity, on the other hand, may or may not be affected, depending on the available capacity of the source slice.

#### Use append to add an element to a slice

```Go
/*  Create a slice of integers.
  Contains a length and capacity of 5 elements.*/
slice := []int{10, 20, 30, 40, 50}

/* Create a new slice.
 Contains a length of 2 and capacity of 4 elements.*/
newSlice := slice[1:3]
fmt.Println(len(newSlice)) // Print 2
fmt.Println(cap(newSlice)) // Print 4

/* Allocate a new element from capacity.
 Assign the value of 60 to the new element.*/
newSlice = append(newSlice, 60)
fmt.Println(len(newSlice)) // Print 3
fmt.Println(cap(newSlice)) // Print 4
```

When there’s no available capacity in the underlying array for a slice, the append function will create a new underlying array, copy the existing values that are being referenced, and assign the new value.

#### Use append to increase the length and capacity of a slice

```Go
// Create a slice of integers.
// Contains a length and capacity of 4 elements.
slice := []int{10, 20, 30, 40}
fmt.Println(len(slice)) // Print 4
fmt.Println(cap(slice)) // Print 4

// Append a new value to the slice.
// Assign the value of 50 to the new element.
newSlice= append(slice, 50)
fmt.Println(len(newSlice)) //Print 5
fmt.Println(cap(newSlice)) //Print 8
```

![Image 9: Increase the length and capacity of a slice.](https://cdn-images-1.medium.com/max/2000/1*GeiklLBspOlv_qxzw5GCVA.png)

After this append operation, newSlice is given its own underlying array, and the capacity of the array is doubled from its original size. The append operation is clever when growing the capacity of the underlying array. For example, the capacity is always doubled when the existing capacity of the slice is under 1,000 elements. Once the number of elements goes over 1,000, the capacity is grown by a factor of 1.25, or 25%. This growth algorithm may change in the language over time.

Changing to a new slice will not have any impact on the old slice since the new slice now has a different underlying array and its pointer is pointing to a newly allocated array.

#### Append to a slice from another slice

The built-in function **append** is also a **variadic** function. This means you can pass multiple values to be appended in a single slice call. If you use the … operator, you can append all the elements of one slice into another.

```Go
// Create two slices each initialized with two integers.
slice1:= []int{1, 2}
slice2 := []int{3, 4}
// Append the two slices together and display the results.
fmt.Println(append(slice1, slice2...))
//Output: [1 2 3 4]
```

#### Perform index orations on slices

* A slice is formed by specifying a low bound and a high bound: `a[low:high]`. This selects a half-open range which includes the first element but excludes the last.
* You may omit the high or low bounds to use their defaults instead. The default is zero for the low bound and the length of the slice for the high bound.

```Go
a := [...]int{0, 1, 2, 3} 
// an array
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

#### Iterate over slices

Go has a special keyword called **range** that you use in conjunction with the keyword to iterate over slices.

```Go
// Create a slice of integers.
// Contains a length and capacity of 4 elements.
slice := []int{10, 20, 30, 40}
// Iterate over each element and display each value.
for index, value := range slice {
   fmt.Printf("Index: %d Value: %d\n", index, value)
}
/*
Output:
Index: 0 Value: 10
Index: 1 Value: 20
Index: 2 Value: 30
Index: 3 Value: 40
*/
```

* The keyword range, when iterating over a slice, will return two values.
* The first value is the index position and the second value is a copy of the value in that index position.
* It’s important to know that range is making a copy of the value, not returning a reference.

```Go
/*
 Create a slice of integers.Contains 
 a length and capacity of 4 elements.
*/
slice := []int{10, 20, 30, 40}
/*
 Iterate over each element and display 
 the value and addresses.
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

The **range** provides a copy of each element

If you don’t need the index value, you can use the underscore character to discard the value.

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

The keyword **range** will always start iterating over a slice from the beginning. If you need more control iterating over a slice, you can always use a traditional **for** loop.

```Go
// Create a slice of integers.
// Contains a length and capacity of 4 elements.
slice := []int{10, 20, 30, 40}
// Iterate over each element starting at element 3.
for index := 2; index < len(slice); index++ {
   fmt.Printf("Index: %d Value: %d\n", index, slice[index])
}
/* 
Output:
Index: 2 Value: 30
Index: 3 Value: 40
*/
```

#### Conclusions

Over the course of this article, we dove into the concept of slices and discovered a lot about them. We learned that a slice doesn’t store any data — rather it describes a section of an underlying array. We also saw that a slice can grow and shrink within the bounds of the underlying array and used with the index as an array; that the default zero value of a slice is nil; the functions **len**, **cap** and **append** all regard **nil** as an **empty slice** with 0 capacity; and that you create a slice either by a **slice literal** or a call to the **make** function (which takes the length and an optional capacity as arguments). I hope you have found this helpful!

**Disclaimer**

I have referenced various blogs, books, and medium stories to materialize this article. For any queries please contact me in the comments.

**That’s all for now …. Happy Coding …. Happy Learning 😃**

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
