> * 原文地址：[A Comprehensive Guide to Slices in Golang](https://codeburst.io/a-comprehensive-guide-to-slices-in-golang-bacebfe46669)
> * 原文作者：[Radhakishan Surwase](https://medium.com/@rksurwase)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/a-comprehensive-guide-to-slices-in-golang.md](https://github.com/xitu/gold-miner/blob/master/article/2020/a-comprehensive-guide-to-slices-in-golang.md)
> * 译者：
> * 校对者：

# A Comprehensive Guide to Slices in Golang

#### Slices in Golang

![Photo by [Paweł Czerwiński](https://unsplash.com/@pawel_czerwinski) on [Unsplash](https://unsplash.com/s/photos/array)](https://cdn-images-1.medium.com/max/12000/1*i7lsjZyVnJxDEIg8Qibdlw.jpeg)

In this article, we will go over the concept of a “slice” which is an important data structure used in Golang. A slice is a data structure that provides a way for you to work with — and manage collections of — data. Slices are built around the concept of dynamic arrays that can grow and shrink as you see fit.

* Slices are **dynamic** in terms of growth because they have their own built-in function called **append** which can grow a slice quickly and efficiently.
* You can also reduce the size of a slice by slicing out a part of the underlying memory.
* Slices give you all the benefits of indexing, iteration, and garbage collection optimizations because the underlying memory is allocated in contiguous blocks.

#### Slice representation

* A slice doesn’t store any data; it just describes a section of an underlying array.
* The slice is represented using a three filed structure name pointer to the underlying array, length, and capacity.
* This data structure works like a descriptor of the slice.

![Image 1: Slice representation](https://cdn-images-1.medium.com/max/2000/1*PW4Y8P0_gTspgYwcxfDrtQ.png)

* **Pointer:** The pointer is used to point to the first element of the array that is accessible through the slice. Here, it is not necessary that the pointed element is the first element of the array.
* **Length:** The length is the total number of elements present in the array.
* **Capacity:** The capacity represents the maximum size up to which it can expand.

#### Declare a slice using the length

When you just specify the length, the capacity of the slice is the same.

![Image 2: Declare a slice using the length.](https://cdn-images-1.medium.com/max/2000/1*5ssbGNTliiFWF_rcxN6RRg.png)

```Go
// Declaring a slice by length. Create a slice of int. 
// Contains a length and capacity of 5 elements. 
slice := make([]int, 5)
fmt.Println(len(slice)) // Print 5
fmt.Println(cap(slice)) // Print 5
```

#### Declare a slice with length and capacity

When you specify the length and capacity separately, you can create a slice with the capacity available in the underlying array that you didn’t have access to initially.

```Go
/* 
 Declaring a slice by length and capacity
 Create a slice of integers. 
 Contains a length of 3 and has a capacity of 5 elements.
*/
slice := make([]int, 3, 5)
fmt.Println(len(slice)) // Print 3
fmt.Println(cap(slice)) // Print 5
```

![Image 3: Declare a slice with length and capacity.](https://cdn-images-1.medium.com/max/2000/1*6OLPqO2Z2x-QKPU_9EDA2A.png)

Please note, however, that trying to create a slice with a capacity that’s smaller than the length is not allowed.

#### Create a slice with a slice literal

An idiomatic way of creating a **slice** is to use a **slice literal**. It’s similar to creating an array, except you don’t specify a value inside of the [ ] operator. The initial length and capacity will be based on the number of elements you initialize.

```Go
// Create a slice of strings. 
// Contains a length and capacity of 5 elements. 
slice := []string{"Red", "Blue", "Green", "Yellow", "Pink"} 
fmt.Println(len(slice)) //Print 5
fmt.Println(cap(slice)) //Print 5
// Create a slice of integers. 
// Contains a length and capacity of 3 elements. 
intSlice:= []int{10, 20, 30}
fmt.Println(len(intSlice)) //Print 3
fmt.Println(cap(intSlice)) //Print 3
```

#### Declare a slice with index positions

When using a slice **literal**, you can set the initial **length** and **capacity**. All you need to do is initialize the **index** that represents the length and capacity you need. The following syntax will create a slice with a length and capacity of 100 elements.

```Go
// Create a slice of strings.
// Initialize the 100th element with an empty string.
slice := []int{99: 88}
fmt.Println(len(slice)) 
// Print 100
fmt.Println(cap(slice)) 
// Print 100
```

![Image 4: Declare a slice with index positions.](https://cdn-images-1.medium.com/max/2000/1*nG722TP5WDx3hZOHBpcFyQ.png)

#### Differences between the declaration of arrays and slices

* If you specify a value inside the [ ] operator, you’re creating an array.
* If you don’t specify a value, you’re creating a slice.

```Go
// Create an array of three integers. 
array := [3]int{10, 20, 30} 

//Create a slice of integers with a length and capacity of three.
slice := []int{10, 20, 30}

```

#### Declare a nil slice

* The zero value of a slice is `nil`.
* A nil slice has a length and capacity of 0 and has no underlying array.

```Go
// Create a nil slice of integers. 
var slice []int32
fmt.Println(slice == nil) 
//This line will print true
fmt.Println(len(slice))   
// This line will print 0
fmt.Println(cap(slice))
// This line will print 0
```

![Image 5: Declare a nil slice.](https://cdn-images-1.medium.com/max/2000/1*2KWa4gM4_M_47eBcKISK9w.png)

#### Declare an empty slice

You can also create an empty slice by declaring a slice with initialization.

```Go
// Use make to create an empty slice of integers.
sliceOne := make([]int, 0)
// Use a slice literal to create an empty slice of integers.
sliceTwo := []int{}
fmt.Println(sliceOne == nil) // This will print false
fmt.Println(len(sliceOne))   // This will print 0 
fmt.Println(cap(sliceOne))   // This will print 0
fmt.Println(sliceTwo == nil) // This will print false
fmt.Println(len(sliceTwo))   // This will print 0
fmt.Println(cap(sliceTwo))   // This will print 0
```

![Image 6: Declare an empty slice.](https://cdn-images-1.medium.com/max/2000/1*x3dfcqD71X5M0G2F4D7QoQ.png)

#### Assign a value to any specific index

To change the value of an individual element, use the [ ] operator.

```Go
// Create a slice of integers.
// Contains a length and capacity of 4 elements.
slice := []int{10, 20, 30, 40}
fmt.Println(slice) //This will print [10 20 30 40]
slice[1] = 25 // Change the value of index 1.
fmt.Println(slice) // This will print [10 25 30 40]
```

![Image 7: Assign a value to any specific index.](https://cdn-images-1.medium.com/max/2000/1*E-LTi2XYMjW0m5RGwzfktQ.png)

#### Take a slice of a slice

Slices are called such because you can slice a portion of the underlying array to create a new slice.

```Go
/* Create a slice of integers. Contains a 
length and capacity of 5 elements.*/
slice := []int{10, 20, 30, 40, 50}
fmt.Println(slice)  // Print [10 20 30 40 50]
fmt.Println(len(slice)) // Print  5
fmt.Println(cap(slice)) // Print  5
/* Create a new slice.Contains a length 
of 2 and capacity of 4 elements.*/
newSlice := slice[1:3]
fmt.Println(slice)  //Print [10 20 30 40 50]
fmt.Println(len(newSlice))  //Print 2
fmt.Println(cap(newSlice))  //Print 4
```

![Image 8: Take a slice of a slice.](https://cdn-images-1.medium.com/max/2000/1*7g5CJ002CXIEo9iQn-Dp6A.png)

After the slicing operation is performed, we have two slices that are sharing the same underlying array. However, each slice views the underlying array in a different way. The original slice views the underlying array as having a capacity of five elements, but the view of newSlice is different. For newSlice, the underlying array has a capacity of four elements. newSlice can’t access the elements of the underlying array that are prior to its pointer. As far as newSlice is concerned, those elements don’t even exist. Calculating the length and capacity for any newSlice is performed using the following formula.

#### How is the length and capacity calculated?

> For **slice[i:j]** with an **underlying array of capacity k** 
Length : j - i 
Capacity : k - i

**Calculating the new length and capacity**

> For **slice[1:3]** with an **underlying array of capacity 5** 
Length : 3 - 1 = 2 
Capacity : 5 - 1 = 4

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

Over the course of this article, we dove into the concept of slices and discovered a lot about them. We learned that a slice ****doesn’t store any data — rather it describes a section of an underlying array. We also saw that a slice can grow and shrink within the bounds of the underlying array and used with the index as an array; that the default zero value of a slice is nil; the functions **len**, **cap** and **append** ****all regard** nil **as an** empty slice **with 0 capacity; and that you create a slice either by a** slice literal **or a call to the** make ******function (which takes the length and an optional capacity as arguments). I hope you have found this helpful!

**Disclaimer**

I have referenced various blogs, books, and medium stories to materialize this article. For any queries please contact me in the comments.

**That’s all for now …. Happy Coding …. Happy Learning 😃**

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
