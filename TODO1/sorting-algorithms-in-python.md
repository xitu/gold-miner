> * 原文地址：[Sorting Algorithms in Python](https://stackabuse.com/sorting-algorithms-in-python/)
> * 原文作者：[Marcus Sanatan](https://stackabuse.com/author/marcus/) 
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/sorting-algorithms-in-python.md](https://github.com/xitu/gold-miner/blob/master/TODO1/sorting-algorithms-in-python.md)
> * 译者：[fireairforce](https://github.com/fireairforce)
> * 校对者：[JalanJiang](https://github.com/JalanJiang), [csming1995](https://github.com/csming1995)

# Python 实现排序算法

## 简介

有时，我们在应用程序中存储或检索的数据有可能是乱序的。如果想要正确处理或者有效使用数据，我们可能需要对数据重新排序。多年来，计算机科学家创造了许多排序算法来处理数据。

在本文中，我们将了解一些流行的排序算法，了解它们是如何工作的，并用 Python 来实现它们。们还将会比较它们对列表中的元素排序的速度。

为了简单起见，这些算法将对列表中的数字都进行升序排序。当然，你可以根据自己的需要来自由调整。

## 冒泡排序

这个简单的排序算法会通过迭代列表成对的比较列表中的元素，并且交换它们，直到较大的元素“冒泡”到列表的末尾，较小的元素保持在“底部”。

### 介绍

我们首先比较列表的前两个元素。如果第一个元素大于第二个元素，我们交换它们。如果它们已经排好序，我们将它们保持原样。然后我们移动到下一对元素，比较它们的值，并根据需要交换。这个过程将持续到列表中的最后一对元素。

当到达列表的末尾时，它会对每对元素重复此过程。但是，这个过程是很低效的。如果我们只需要在数组里面进行一次交换怎么办？为什么我们仍然会迭代 *n^2* 次，即使数组已经排好序了？

显然，为了优化算法，我们需要在完成排序时停止它。

那我们怎么知道已经完成了排序？如果元素是有序的，那我们就不必继续交换。因此，每当交换值时，我们会将一个标志值设置为 `True` 以重复排序过程。如果没有发生交换，标志值将保持为 `False`，算法将停止。

### 实现

优化之后，我们可以通过以下的 Python 代码来实现冒泡排序：

```python
def bubble_sort(nums):
    # 我们将标志值 swapped 设为 True，以便循环能够执行至少一次
    swapped = True
    while swapped:
        swapped = False
        for i in range(len(nums) - 1):
            if nums[i] > nums[i + 1]:
                # 交换元素
                nums[i], nums[i + 1] = nums[i + 1], nums[i]
                # 把标志值设为 True 以便我们能再次循环
                swapped = True

# 检查是否能够正确执行
random_list_of_nums = [5, 2, 1, 8, 4]
bubble_sort(random_list_of_nums)
print(random_list_of_nums)
```

这个算法在一个 `while` 循环里面运行，仅当没有元素能够交换时才会跳出循环。我们在开始时将 `swapped` 设为 `True`，以确保算法至少可以执行一次。

### 时间复杂度

在最坏的情况下（当列表处于相反的顺序时），该算法必须交换数组的每个项。每次迭代的时候，标志值 `swapped` 都会被设置为 `True`。因此，如果我们在列表中有 *n* 个元素，我们将对每个元素迭代 *n* 次，因此冒泡排序的时间复杂度为 O(n^2)。

## 选择排序

该算法将列表分为两部分：已排序部分和未排序部分。我们不断地删除列表中未排序部分的最小元素，并将其添加到已排序部分中。

### 介绍

实际上，我们并不需要为已排序的元素创建一个新的列表，我们要做的是将列表最左边的部分作为已排序部分。然后我们搜索整个列表中最小的元素，并将其与第一个元素交换。

现在我们知道列表的第一个元素是有序的，我们将继续搜索剩余元素中最小的元素，并将其与第二个元素交换。这将迭代到待检查元素是剩余列表的最后一项时。

### 实现

```python
def selection_sort(nums):
    # i 的值对应于已排序值的数量
    for i in range(len(nums)):
        # 我们假设未排序部分的第一项是最小的
        lowest_value_index = i
        # 这个循环用来迭代未排序的项
        for j in range(i + 1, len(nums)):
            if nums[j] < nums[lowest_value_index]:
                lowest_value_index = j
        # 将未排序元素的最小的值与第一个未排序的元素的值相交换
        nums[i], nums[lowest_value_index] = nums[lowest_value_index], nums[i]

# 检验算法是否正确
random_list_of_nums = [12, 8, 3, 20, 11]
selection_sort(random_list_of_nums)
print(random_list_of_nums)
```

可以看到随着 `i` 的增加，我们需要检查的元素越来越少。

### 时间复杂度

在选择排序算法中，我们可以通过检查 `for` 循环次数来轻松得到时间复杂度。对于一个有 *n* 个元素的列表，外层循环会迭代 *n* 次。当 *i* 的值为 1 时，内层循环会迭代 *n-1* 次，*i* 值为 2 时迭代 *n-2* 次然后依此类推。

算法比较的次数和为 `(n - 1) + (n - 2) + ... + 1`，由此可得选择排序算法的时间复杂度为 O(n^2)。

## 插入排序

与选择排序一样，该算法将列表分为已排序部分和未排序部分。它会通过迭代未排序的部分将遍历到的元素插入到排序列表中的正确位置。

### 介绍

我们假设列表的第一个元素已排序。然后我们遍历到下一个元素，我们称之为 `x`。如果 `x` 值大于第一个元素，我们将继续遍历。如果 `x` 值较小，我们将第一个元素的值复制到第二个位置，然后将第一个元素值设置为 `x`。

当我们处理未排序部分的其他元素时，我们不断地将已排序部分中较大的元素向上移动，直到遇到小于 `x` 的元素或到达已排序部末尾的元素，然后将 `x` 放在正确的位置。

### 实现

```python
def insertion_sort(nums):
    # 我们假设第一个元素已经排好序，然后从第二个元素开始遍历
    for i in range(1, len(nums)):
        item_to_insert = nums[i]
        # 同时保留上一个元素的下标的索引
        j = i - 1
        # 如果排序段的所有项大于要插入的项，则将其向前移动
        while j >= 0 and nums[j] > item_to_insert:
            nums[j + 1] = nums[j]
            j -= 1
        # 插入的元素
        nums[j + 1] = item_to_insert

# 验证算法是否正确
random_list_of_nums = [9, 1, 15, 28, 6]
insertion_sort(random_list_of_nums)
print(random_list_of_nums)
```

### 时间复杂度

在最坏的情况下，数组将按相反的顺序排序。插入排序函数中外层的 `for` 循环总是会迭代 *n-1* 次。

在最坏的情况下，内部 `for` 循环将交换一次，然后交换两次，依此类推。交换的数量将是 `1 + 2 + ... + (n - 3) + (n - 2) + (n - 1)`，这使得插入排序具有 O(n^2) 的时间复杂度。

## 堆排序

这种流行的排序算法，像插入排序和选择排序一样，将列表分为已排序部分和未排序部分。它将列表的未排序段转换为数据结构堆，以便我们能有效地确定最大的元素。

### 介绍

我们首先将列表转换成一个最大堆 —— 一种最大元素为根节点的二叉树。然后把我们把这个节点放在列表的尾部。然后我们重建这个少了一个值的**最大堆**，将新的最大值放在列表的最后一项之前。

然后我们重复这个构建堆的过程，直到删除所有节点。

### 实现

我们创建一个辅助函数 `heapify` 来帮助实现这个算法：

```python
def heapify(nums, heap_size, root_index):
    # 设最大元素索引为根节点索引
    largest = root_index
    left_child = (2 * root_index) + 1
    right_child = (2 * root_index) + 2

    # 如果根节点的左子节点是有效索引，并且元素大于当前最大元素，则更新最大元素
    if left_child < heap_size and nums[left_child] > nums[largest]:
        largest = left_child

    # 对根节点的右子节点执行相同的操作
    if right_child < heap_size and nums[right_child] > nums[largest]:
        largest = right_child

    # 如果最大的元素不再是根元素，则交换它们
    if largest != root_index:
        nums[root_index], nums[largest] = nums[largest], nums[root_index]
        # 调整堆以确保新的根节点元素是最大元素
        heapify(nums, heap_size, largest)

def heap_sort(nums):
    n = len(nums)

    # 利用列表创建一个最大堆
    # range 的第二个参数表示我们将停在索引值为 -1 的元素之前，即列表中的第一个元素
    # range 的第三个参数表示我们朝反方向迭代
    # 将 i 的值减少1
    for i in range(n, -1, -1):
        heapify(nums, n, i)

    # 将最大堆的根元素移动到列表末尾
    for i in range(n - 1, 0, -1):
        nums[i], nums[0] = nums[0], nums[i]
        heapify(nums, i, 0)

# 验证算法是否正确
random_list_of_nums = [35, 12, 43, 8, 51]
heap_sort(random_list_of_nums)
print(random_list_of_nums)
```

### 时间复杂度

让我们先看看 `heapify` 函数的时间复杂度。在最坏的情况下，最大元素永远不是根元素，这会导致递归调用 `heapify` 函数。虽然递归调用可能看起来非常损耗性能，但请记住，我们这里使用的是二叉树。

可视化一个包含 3 个元素的二叉树，它的高度为 2。现在可视化一个包含 7 个元素的二叉树，它的高度为 3。这棵树按对数方式增长到 *n*。`heapify` 函数在 O(log(n)) 时间遍历该树。

`heap_sort` 函数迭代数组 *n* 次。因此，堆排序算法的总时间复杂度为 O(nlog(n))。

## 归并排序

这种分而治之的算法将一个列表分成两部分，并一直将剩下的列表分别一分为二直到列表中只剩下一个元素为止。

相邻元素成为排序对，然后合并排序对并和其它排序对进行排序。这个过程将一直持续到我们得到一个对未排序输入列表中所有元素排序的排序列表为止。

### 介绍

我们递归地将列表分成两半，直到得到长度为 1 的列表。然后我们合并被分割出的每一部分，在这个过程中对它们进行排序。

排序是通过比较每一半的最小元素来完成的。每个列表的第一个元素是第一个要比较的元素。如果前半部分以较小的值开头，那么我们将其添加到排序列表中。然后我们比较前半部分的第二个最小值和后半部分的第一个最小值。

每次我们在半段的开头选择较小的值时，我们都会移动需要比较的项目。

### 简介

```python
def merge(left_list, right_list):
    sorted_list = []
    left_list_index = right_list_index = 0

    # 我们经常使用列表长度，因此将它创建为变量方便使用
    left_list_length, right_list_length = len(left_list), len(right_list)

    for _ in range(left_list_length + right_list_length):
        if left_list_index < left_list_length and right_list_index < right_list_length:
            # 我们检查每个列表开头的哪个值较小
            # 如果左列表开头的项较小，将它添加到已排序列表
            if left_list[left_list_index] <= right_list[right_list_index]:
                sorted_list.append(left_list[left_list_index])
                left_list_index += 1
            # 如果右列表开头的项较小，将它添加到已排序列表
            else:
                sorted_list.append(right_list[right_list_index])
                right_list_index += 1

        # 如果已到达左列表的末尾，则添加右列表中的元素
        elif left_list_index == left_list_length:
            sorted_list.append(right_list[right_list_index])
            right_list_index += 1
        # 如果已到达右列表的末尾，则添加左列表中的元素
        elif right_list_index == right_list_length:
            sorted_list.append(left_list[left_list_index])
            left_list_index += 1

    return sorted_list

def merge_sort(nums):
    # 如果列表中只有一个元素，则返回它
    if len(nums) <= 1:
        return nums

    # 使用向下取整获取中点，索引必须是整数
    mid = len(nums) // 2

    # 对每一半进行排序和合并
    left_list = merge_sort(nums[:mid])
    right_list = merge_sort(nums[mid:])

    # 将已排序的列表合并为新列表
    return merge(left_list, right_list)

# 验证算法是否正确
random_list_of_nums = [120, 45, 68, 250, 176]
random_list_of_nums = merge_sort(random_list_of_nums)
print(random_list_of_nums)
```

请注意，`merge_sort()` 函数与以前的排序算法不同，它返回一个已排序的新列表，而不是对现有列表进行排序。

因此，归并排序需要空间来创建和输入列表大小相同的新列表。

### 时间复杂度

我们首先看看 `merge` 函数。它需要两个列表，并迭代 *n* 次，其中 *n* 是两个列表合并后的大小。`merge_sort` 函数将给定数组拆分为 2 个，并递归地对子数组进行排序。由于递归的输入是给定数组的一半，就像二叉树一样，这使得处理所需的时间以对数方式增长到 *n*。

因此，归并排序算法的总体时间复杂性是 O(nlog(n))。

## 快速排序

这种分而治之的算法是本文中最常用的排序算法。如果合理地使用，那么它将具有很高的效率，并且不需要像归并排序一样使用额外的空间。我们围绕一个基准值对列表进行分区，并对基准值周围的元素进行排序。

### 介绍

快速排序首先对列表进行分区 —— 选择待排序列表的第一个值。该值被称为基准值。所有小于基准值的元素都将被移到其左侧。

此时基准值在正确的位置，我们递归地对基准值周围的元素进行排序，直到整个列表有序。

### 实现
```python
# 快速排序分区有不同的方法，下面实现了 Hoare 的分区方案。Tony Hoare 还创建了快速排序算法。
def partition(nums, low, high):
    # 我们选择中间元素作为基准值。
    # 有些实现方法选择第一个元素或最后一个元素作为基准值。 
    # 有时将中间元素或一个随机元素作为基准值。
    # 还有很多可以选择或创建的方法。
    pivot = nums[(low + high) // 2]
    i = low - 1
    j = high + 1
    while True:
        i += 1
        while nums[i] < pivot:
            i += 1

        j -= 1
        while nums[j] > pivot:
            j -= 1

        if i >= j:
            return j

        # 如果 i 处的元素（在基准值左侧）大于 j 处的元素（在基准值右侧），则交换它们。
        nums[i], nums[j] = nums[j], nums[i]

def quick_sort(nums):
    # 创建一个辅助函数来进行递归调用
    def _quick_sort(items, low, high):
        if low < high:
            # 这是基准元素后的索引，我们的列表在这里被拆分
            split_index = partition(items, low, high)
            _quick_sort(items, low, split_index)
            _quick_sort(items, split_index + 1, high)

    _quick_sort(nums, 0, len(nums) - 1)

# 检验算法是否正确
random_list_of_nums = [22, 5, 1, 18, 99]
quick_sort(random_list_of_nums)
print(random_list_of_nums)
```

### 时间复杂度

最坏的情况是始终选择最小或最大元素作为基准值。这将创建一个大小为 *n-1* 的分区，导致递归调用 *n-1* 次。这导致在最坏情况下的时间复杂度为 O(n^2)。

虽然最坏的情况比较糟糕，但快速排序仍然被大量使用，因为它的平均时间复杂度比其他排序算法快得多。虽然 `partition` 函数使用嵌套的 while 循环，但它会对数组的所有元素进行比较以进行交换。因此，它的时间复杂度只有 O(n)。

如果选择一个好的基准值，快速排序函数将把数组分成两部分，这两部分将随 *n* 呈对数增长。因此，快速排序算法的平均时间复杂度为 O(nlog(n))。

### Python 的内置排序函数

虽然理解这些排序算法是有益的，但在大多数 Python 项目中，你可能会使用语言中已经提供的排序函数。

我们可以更改列表，使其内容按 `sort()` 方法排序：

```python
apples_eaten_a_day = [2, 1, 1, 3, 1, 2, 2]
apples_eaten_a_day.sort()
print(apples_eaten_a_day) # [1, 1, 1, 2, 2, 2, 3]
```

或者我们可以使用 `sorted()` 函数创建新的排序列表：

```python
apples_eaten_a_day_2 = [2, 1, 1, 3, 1, 2, 2]
sorted_apples = sorted(apples_eaten_a_day_2)
print(sorted_apples) # [1, 1, 1, 2, 2, 2, 3]
```

它们都是按升序排序的，但你可以通过将 `reverse` 标志设置为 `True` 来轻松按降序排序：

```python
# 对列表进行反向排序
apples_eaten_a_day.sort(reverse=True)
print(apples_eaten_a_day) # [3, 2, 2, 2, 1, 1, 1]

# 反向排序以获取新列表
sorted_apples_desc = sorted(apples_eaten_a_day_2, reverse=True)
print(sorted_apples_desc) # [3, 2, 2, 2, 1, 1, 1]
```

与我们创建的排序算法函数不同，这两个函数都可以对元组和类的列表进行排序。`sorted()` 函数可以对任何可迭代对象进行排序，其中包括了 —— 你可以创建的列表，字符串，元组，字典，集合，和自定义[迭代器](https://stackabuse.com/introduction-to-python-iterators/)。

这些排序函数实现了 [Tim Sort](https://en.wikipedia.org/wiki/Timsort) 算法，这是一种受归并排序和插入排序启发的算法。

## 速度比较

为了了解它们的执行速度，我们生成了一个介于 0 到 1000 之间的 5000 个数字的列表。然后我们计算每个算法完成所需的时间。每个算法运行 10 次，以便我们建立更可靠的性能模型。

下面是结果，时间以秒为单位：

| Run | 冒泡 | 选择 | 插入 | 堆 | 归并 | 快速 |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | 5.53188 | 1.23152 | 1.60355 | 0.04006 | 0.02619 | 0.01639 |
| 2 | 4.92176 | 1.24728 | 1.59103 | 0.03999 | 0.02584 | 0.01661 |
| 3 | 4.91642 | 1.22440 | 1.59362 | 0.04407 | 0.02862 | 0.01646 |
| 4 | 5.15470 | 1.25053 | 1.63463 | 0.04128 | 0.02882 | 0.01860 |
| 5 | 4.95522 | 1.28987 | 1.61759 | 0.04515 | 0.03314 | 0.01885 |
| 6 | 5.04907 | 1.25466 | 1.62515 | 0.04257 | 0.02595 | 0.01628 |
| 7 | 5.05591 | 1.24911 | 1.61981 | 0.04028 | 0.02733 | 0.01760 |
| 8 | 5.08799 | 1.25808 | 1.62603 | 0.04264 | 0.02633 | 0.01705 |
| 9 | 5.03289 | 1.24915 | 1.61446 | 0.04302 | 0.03293 | 0.01762 |
| 10 | 5.14292 | 1.22021 | 1.57273 | 0.03966 | 0.02572 | 0.01606 |
| 平均 | 5.08488 | 1.24748 | 1.60986 | 0.04187 | 0.02809 | 0.01715 |

如果你自己进行测试，你会得到不同的值，但是观察到的性能模型应该是相同或相似的。冒泡排序是所有算法中执行速度最慢、表现最差的。虽然它作为排序和算法的介绍很有用，但不适合实际使用。

我们还注意到快速排序非常快，它的速度几乎是归并排序的两倍，而且它在运行时不需要额外的空间。回想一下，我们的分区是基于列表的中间元素，不同的分区方法可能会有不同的结果。

由于插入排序执行的比较要比选择排序少得多，因此插入排序的实现通常更快，但在我们的测试中，选择排序会稍微快一些。

插入排序比选择排序交换元素的次数更多。如果交换值比比较值占用更多的时间，那么这个“相反”的结果是可信的。

选择排序算法时要注意使用场景，因为它会影响性能。

## 总结

排序算法为我们提供了许多排序数据的方法。我们研究了 6 种不同的算法——冒泡排序、选择排序、插入排序、归并排序、堆排序、快速排序 —— 以及它们在 Python 中的实现。。

算法执行的比较和交换量以及代码运行的环境是决定性能的关键因素。在实际的 Python 应用程序中，建议我们坚持使用内置的 Python 排序函数，因为它们在输入和速度上具有灵活性。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
