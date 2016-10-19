> * 原文地址：[Android App Optimization Using ArrayMap and SparseArray](https://medium.com/@amitshekhar/android-app-optimization-using-arraymap-and-sparsearray-f2b4e2e3dc47#.w9iubhupn)
* 原文作者：[Amit Shekhar](https://medium.com/@amitshekhar)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

# Android App Optimization Using ArrayMap and SparseArray
This article will show why and when use **ArrayMap** and **SparseArray** to optimize your Android Applications.

Whenever you need to store **key -> value**, the first data structure that comes in your mind is **HashMap**. And you start using it all places without any further thinking on its side effects.

While using HashMap, your Android Development IDE (Android Studio) gives you warning to use ArrayMap instead of HashMap, but you neglect.

Android provides you the ArrayMap which you should consider over HashMap.

Now, lets explore when and why you should consider using ArrayMap by understanding how it works internally.

#### HashMap vs ArrayMap


HashMap comes in the package : _java.util.HashMap_

ArrayMap comes in the package : _android.util.ArrayMap_ and _android.support.v4.util.ArrayMap_

It comes with support.v4 to provide support for the lower android versions.

[Here](https://www.youtube.com/watch?v=ORgucLTtTDI) is the youtube video directly from Android Developers Channel, which I highly recommend you to watch.

ArrayMap is a generic key->value mapping data structure that is designed to be more memory efficient than a traditional HashMap. It keeps its mappings in an array data structure — an integer array of hash codes for each item, and an Object array of the key/value pairs. This allows it to avoid having to create an extra object for every entry put in to the map, and it also tries to control the growth of the size of these arrays more aggressively (since growing them only requires copying the entries in the array, not rebuilding a hash map).

Note that this implementation is not intended to be appropriate for data structures that may contain large numbers of items. It is generally slower than a traditional HashMap, since lookups require a binary search and adds and removes require inserting and deleting entries in the array. For containers holding up to hundreds of items, the performance difference is not significant, less than 50%.

#### HashMap

HashMap is basically an Array of HashMap.Entry objects (Entry is an inner class of HashMap). On a high-level, the instance variables in Entry class are :

*   A non-primitive key
*   A non-primitive value
*   Hashcode of the object
*   A pointer to next Entry

What happens when an key/value is inserted in HashMap ?

*   HashCode of the key is calculated, and that value is assigned to the hashCode variable of EntryClass.
*   Then, using hashCode we get the index of the bucket where it will be stored.
*   If the bucket is having an pre-existing element, the new element is inserted with the last element pointing to new one — essentially making the bucket a LinkedList.

Now, when you query it to get the value for a key, it comes in O(1).

But most important thing is that it comes at the cost of more space(memory).

Drawbacks:

*   Autoboxing means extra objects created with each insertion. This will impact memory usage as well as Garbage Collection.
*   The HashMap.Entry objects themselves are an extra layer of objects to be created and garbage collected.
*   Buckets are rearranged each time HashMap is compacted or expanded. This is an expensive operation which grows with number of objects.

In Android, memory matter a lot when it comes to the responsive applications, because of continuous allocation and deallocation of memory, the garbage collection occurs, so there will be lag in your android application.

_Garbage Collection is a tax on performance of an application._

When garbage collection is taking place, your application in not running. Ultimately, your application lags.

#### ArrayMap

ArrayMap uses 2 arrays. The instance variables used internally are Object[ ] mArray to store the objects and the int[] mHashes to store hashCodes. When an key/value is inserted :

*   Key/Value is autoboxed.
*   Key object is inserted at the next available position in mArray[ ].
*   Value object is also inserted in the position next to key’s position in mArray[ ].
*   The hashCode of key is calculated and placed in mHashes[ ] at the next available position.

For searching a key :

*   Key’s hashCode is calculated
*   Binary search is done for this hashCode in the mHashes array. This implies time complexity increases to O(logN).
*   Once we get the index of hash, we know that key is at 2*index position in mArray and value is at 2*index+1 position.
*   Here the time complexity increases from O(1) to O(logN), but it is memory efficient. Whenever we play on dataset of around 100,   
    there will no problem of time complexity, it will be non-noticeable. As we have advantage of memory efficient application.

#### Recommended data-structure:

*   **ArrayMap in place of HashMap**
*   **ArraySet in place of HashSet**
*   **SparseArray in place of HashMap**
*   **SparseBooleanArray in place of HashMap**
*   **SparseIntArray in place of HashMap**
*   **SparseLongArray in place of HashMap**
*   **LongSparseArray in place of HashMap**
