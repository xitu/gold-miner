> * 原文地址：[Understanding Tensorflow using Go](https://pgaleone.eu/tensorflow/go/2017/05/29/understanding-tensorflow-using-go/)
> * 原文作者：[Paolo Galeone](https://pgaleone.eu/about/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：
> * 校对者：

# Understanding Tensorflow using Go

Tensorflow is not a Machine Learning specific library, instead, is a general purpose computation library that represents computations with graphs.
Its core is implemented in C++ and there are also bindings for different languages. The bindings for the Go programming language, differently from the Python ones, are a useful tool not only for using Tensorflow in Go but also for understanding how Tensorflow is implemented under the hood.

## The bindings

Officially, the Tensorflow’s developers released:

- The C++ source code: the real Tensorflow core where the high & low level operations are concretely implemented.
- The Python bindings & the Python library: the bindings are automatically generated from the C++ implementation, in this way we can use Python to invoke C++ functions: that’s how, for instance, the core of numpy is implemented.
The library, moreover, combines calls to the bindings in order to define the higher level API that everyone’s using Tensorflow knows well.
- The Java bindings
- The Go binding

Being a Gopher and not a Java lover, I started looking at the Go bindings in order to understand what kind of tasks they were created for.

## The Go bindings

![Tensorflow &amp; Go](https://pgaleone.eu/images/tensorflow_go/tensorgologo.png)

The Gopher (created by Takuya Ueda ([@tenntenn](https://twitter.com/tenntenn)). Licensed under the Creative Commons 3.0 Attributions license)

overlapping the Tensorflow Logo.

---

The first thing to note is that the Go API, for admission of the maintainers itself, lacks the `Variable` support: this API is designed to **use** trained models and **not for training** models from scratch.
This is clearly stated in the [Installing Tensorflow for Go](https://www.tensorflow.org/versions/master/install/install_go):

> TensorFlow provides APIs for use in Go programs. These APIs are particularly well-suited to loading models created in Python and executing them within a Go application.

If we’re not interested in training ML models: hooray!
If, instead, you’re interested in training models here’s an advice:

> Be a real gopher, keep it simple! Use Python to define & train models; you can always load trained models and using them with Go later!

In short: the go bindings can be used to **import and define** constants graphs; where constant, in this context, means that there’s no training process involved and thus no trainable variables.

Let’s now start diving into Tensorflow using Go: let’s create our first application.

In the following, I suppose that the reader has its Go environment ready and the Tensorflow bindings compiled and installed as explained in the [README](https://github.com/tensorflow/tensorflow/blob/master/tensorflow/go/README.md).

## Understand Tensorflow structure

Let’s repeat what Tensorflow is (kept from the [Tensorflow website](https://www.tensorflow.org/), the emphasis is mine):

> TensorFlow™ is an open source software library for numerical computation using data flow graphs. Nodes in the graph **represent** mathematical operations, while the graph edges **represent** the multidimensional data arrays (tensors) communicated between them.

We can think of Tensorflow as a descriptive language, a bit like SQL, in which you describe what you want and let the underlying engine (the database) parse your query, check for syntactic and semantic errors, convert it to its private representation, optimize it and compute the results: all this to give you the correct results.

Therefore, what we really do when we use any of the available APIs is to describe a graph: the evaluation of the graph starts when we place it into a `Session` and explicitly decide to `Run` the graph within the Session.

Knowing this, let’s try to define a computational graph and evaluate it within a `Session`.
The [API documentation](https://godoc.org/github.com/tensorflow/tensorflow/tensorflow/go) gives us a pretty clear list of the available methods within the packages `tensorflow` (shorthanded `tf`) & `op`.

As we can see, these two packages contains everything we need to define and evaluate a graph.

The former contains the functions to construct the basic “empty” structures like the `Graph` itself, the latter is the most important package that contains the bindings automatically generated from the C++ implementation.

However, suppose that we want to compute the matrix multiplication between AAA and xxx where

![](https://ws2.sinaimg.cn/large/006tNc79gy1fg9itnbsc7j31au06274m.jpg)

I suppose that the reader is already familiar with the tensorflow graph definition idea and knows what placeholders are and how they work.
The code below is the first attempt that a Tensorflow Python bindings user would make. Let’s call this file `attempt1.go`

```
package main

import (
	"fmt"
	tf "github.com/tensorflow/tensorflow/tensorflow/go"
	"github.com/tensorflow/tensorflow/tensorflow/go/op"
)

func main() {
	// Let's describe what we want: create the graph

	// We want to define two placeholder to fill at runtime
	// the first placeholder A will be a [2, 2] tensor of integers
	// the second placeholder x will be a [2, 1] tensor of intergers

	// Then we want to compute Y = Ax

	// Create the first node of the graph: an empty node, the root of our graph
	root := op.NewScope()

	// Define the 2 placeholders
	A := op.Placeholder(root, tf.Int64, op.PlaceholderShape(tf.MakeShape(2, 2)))
	x := op.Placeholder(root, tf.Int64, op.PlaceholderShape(tf.MakeShape(2, 1)))

	// Define the operation node that accepts A & x as inputs
	product := op.MatMul(root, A, x)

	// Every time we passed a `Scope` to an operation, we placed that
	// operation **under** that scope.
	// As you can see, we have an empty scope (created with NewScope): the empty scope
	// is the root of our graph and thus we denote it with "/".

	// Now we ask tensorflow to build the graph from our definition.
	// The concrete graph is created from the "abstract" graph we defined
	// using the combination of scope and op.

	graph, err := root.Finalize()
	if err != nil {
		// It's useless trying to handle this error in any way:
		// if we defined the graph wrongly we have to manually fix the definition.

		// It's like a SQL query: if the query is not syntactically valid
		// we have to rewrite it
		panic(err.Error())
	}

	// If here: our graph is syntatically valid.
	// We can now place it within a Session and execute it.

	var sess *tf.Session
	sess, err = tf.NewSession(graph, &tf.SessionOptions{})
	if err != nil {
		panic(err.Error())
	}

	// In order to use placeholders, we have to create the Tensors
	// containing the values to feed into the network
	var matrix, column *tf.Tensor

	// A = [ [1, 2], [-1, -2] ]
	if matrix, err = tf.NewTensor([2][2]int64{ {1, 2}, {-1, -2} }); err != nil {
		panic(err.Error())
	}
	// x = [ [10], [100] ]
	if column, err = tf.NewTensor([2][1]int64{ {10}, {100} }); err != nil {
		panic(err.Error())
	}

	var results []*tf.Tensor
	if results, err = sess.Run(map[tf.Output]*tf.Tensor{
		A: matrix,
		x: column,
	}, []tf.Output{product}, nil); err != nil {
		panic(err.Error())
	}
	for _, result := range results {
		fmt.Println(result.Value().([][]int64))
	}
}
```

The code is completely commented and I invite the reader to read every single comment.

Now, the Tensorflow-Python user expects that this code compiles and works fine. Let’s see if he’s right:

`go run attempt1.go`

Here’s what he got:

`panic: failed to add operation "Placeholder": Duplicate node name in graph: 'Placeholder'`

wait: what’s going on here?
Apparently, there are 2 operations “Placeholder” with the same name “Placeholder”.

## Lesson 1: node IDs

**The Python API generates different nodes everytime we invoke a method to define an operation**, no matter if this has been already called before.
In fact, the following code returns 3 without problems.

```
import tensorflow as tf
a = tf.placeholder(tf.int32, shape=())
b = tf.placeholder(tf.int32, shape=())
add = tf.add(a,b)
sess = tf.InteractiveSession()
print(sess.run(add, feed_dict={a: 1,b: 2}))
```

We can verify that this program creates two different nodes printing the placeholder names: `print(a.name, b.name)` produces `Placeholder:0 Placeholder_1:0`.
Thus, the `b` placeholder is `Placeholder_1:0` whilst the `a` placeholder is `Placeholder:0`.

In Go, instead, the previous program fails because `A` and `x` are both called `Placeholder`. We can conclude that:

**The Go API does not automatically generate new names every time we invoke a function that defnines an operation**: the operation name is thus fixed and we can’t change it.

#### Question time:

- What do we have learned about the Tensorflow architecture? *Every node in a graph must have a unique name. Every node is identified by its name.*
- Is the name of the node the same of the operation that defined it? *Yes, or better, not completely, it’s just its last part*

To clarify the second answer, let’s fix the duplicate node name problem.

## Lesson 2: Scoping

As we just saw, the Python API automatically creates a new name every time an operation is defined. Under the hood, the Python API invokes the C++ method `WithOpName` of the class `Scope`.
Here are the method documentation and its signature, kept from [scope.h](https://github.com/tensorflow/tensorflow/blob/a5b1fb8e56ceda0ee2794ee05f5a7642157875c5/tensorflow/cc/framework/scope.h):

```
/// Return a new scope. All ops created within the returned scope will have
/// names of the form <name>/<op_name>[_<suffix].
Scope WithOpName(const string& op_name) const;
```

We can note that this method, used to name the nodes returns a `Scope`, thus a node name is, in reality, a `Scope`.
A `Scope` is a **complete path** from the root `/` (empty graph) to the `op_name`.

The method `WithOpName` adds a suffix `_<suffix>` (where `<suffix>` is a counter) when we try to add a node that has the same path from `/` to `op_name` and thus it would be a duplicate node under the same scope.

Knowing this, to solve the issue of duplicated node names we expect to find the method `WithOpName` in the `type Scope`. Sadly, this method is not present.

Instead, looking at the [documentation of the type Scope](https://godoc.org/github.com/tensorflow/tensorflow/tensorflow/go/op#Scope) we can see that the only method that returns a new `Scope` is `SubScope(namespace string)`.

Quoting the documentation:

> SubScope returns a new Scope which will cause all operations added to the graph to be namespaced with ‘namespace’. If namespace collides with an existing namespace within the scope, then a suffix will be added.

The collision management using a suffix is **different** from the C++ `WithOpName`: `WithOpName` adds the `suffix`**after the operation name**, within the same scope (thus `Placeholder` becomes `Placeholder_1`) while the Go `SubScope` adds the `suffix`**after the scope name**.

This difference generates completely different graphs, but although different (nodes are placed under different scopes) they’re equivalent computationally speaking.

Let’s change the placeholder definitions in order to define two different nodes, moreover, let’s Print the `Scope` name.

Let’s create the file `attempt2.go` changing the lines

```
A := op.Placeholder(root, tf.Int64, op.PlaceholderShape(tf.MakeShape(2, 2)))
x := op.Placeholder(root, tf.Int64, op.PlaceholderShape(tf.MakeShape(2, 1)))
```

to

```
// define 2 subscopes of the root subscopes, called "input". In this
// way we expect to have a input/ and a input_1/ scope under the root scope
A := op.Placeholder(root.SubScope("input"), tf.Int64, op.PlaceholderShape(tf.MakeShape(2, 2)))
x := op.Placeholder(root.SubScope("input"), tf.Int64, op.PlaceholderShape(tf.MakeShape(2, 1)))
fmt.Println(A.Op.Name(), x.Op.Name())
```

Usual compile & run: `go run attempt2.go`. Results:

```
input/Placeholder input_1/Placeholder
```


#### Question time:

What do we have learned about the Tensorflow architecture? *A node is completely identified by the Scope in which it is defined. The scope is the path that we have to follow from the root of the graph to reach the node. There are 2 way of defining nodes that execute the same operation: define the operation in a different Scope (Go style) or change the operation name (how Python automatically do or how we can do in C++)*

We solved the problem of the duplicate node names but another problem landed on our terminal.

    panic: failed to add operation "MatMul": Value for attr 'T' of int64 is not in the list of allowed values: half, float, double, int32, complex64, complex128


Why the `MatMul` node definition panics? We just want to multiply two `tf.int64` matrices! It looks like that `int64` is the only type that `MatMul` does not accept.

> Value for attr ‘T’ of int64 is not in the list of allowed values: half, float, double, int32, complex64, complex128

What’s this list? Why can we multiply 2 matrices of `int32` but not of `int64`?

Let’s go solve this understanding what’s going on.

## Lesson 3: Tensorflow typing system

Let’s dig into the [source code](https://github.com/tensorflow/tensorflow/blob/r1.2/tensorflow/core/ops/math_ops.cc#L1048) looking for the C++ declaration of the `MatMul` operation:

```
REGISTER_OP("MatMul")
    .Input("a: T")
    .Input("b: T")
    .Output("product: T")
    .Attr("transpose_a: bool = false")
    .Attr("transpose_b: bool = false")
    .Attr("T: {half, float, double, int32, complex64, complex128}")
    .SetShapeFn(shape_inference::MatMulShape)
    .Doc(R"doc(
Multiply the matrix "a" by the matrix "b".
The inputs must be two-dimensional matrices and the inner dimension of
"a" (after being transposed if transpose_a is true) must match the
outer dimension of "b" (after being transposed if transposed_b is
true).
*Note*: The default kernel implementation for MatMul on GPUs uses
cublas.
transpose_a: If true, "a" is transposed before multiplication.
transpose_b: If true, "b" is transposed before multiplication.
```

This line defines an interface for the `MatMul` operation: in particular, we can see that using the `REGISTER_OP` macro we’re declaring the op’s:

- Name: `MatMul`
- Parameters: `a`, `b`
- Attributes (optional parameters): `transpose_a`, `transpose_b`
- Supported types for the template `T`: `half, float, double, int32, complex64, complex128`
- Output Shape: automatically inferred
- Documentation

This macro call doesn’t contain any C++ code, but it tells us that **when defining an operation, even though it uses a template, we have to specify the list of the supported type for the specified type `T`** (or attribute).
In practice, the attribute `.Attr("T: {half, float, double, int32, complex64, complex128}")` constraints the type `T` to be one value of that list.

As we can read from [the tutorial](https://www.tensorflow.org/extend/adding_an_op) even when using a Template `T` we have to explicitly register the kernel for every supported overload. The kernel is the CUDA-way for referring to C/C++ functions that will be executed in parallel.

The `MatMul` author, thus, decided to support only the previously listed types and to not support the `int64`. There are 2 possible reasons:

1. Oversight: it’s possible, the Tensorflow’s authors are humans!
2. Supporting devices where `int64` operations are not fully supported, thus this specific implementation of the kernel wouldn’t be general enough to run on every supported hardware.

Coming back to our panic: the fix is obvious. We have to pass parameters of a supported type to `MatMul`.

Let’s create `attempt3.go` changing every line that refers to an `int64` with an `int32`.

There’s just a thing to note: **the Go bindings have their own set of types, with a 1:1 mapping (almost complete) with the Go types. When we feed values into the graph we have to respect the mapping (for instance feed `int32` when defining `tf.Int32` placeholders). The same thing has to be done when fetching values from the graph.**
The `*tf.Tensor` type returned from a Tensor evaluation, has the `Value()` method that returns an `interface{}` that must be converted to the correct type (that **we know** from the graph construction).

Usual `go run attempt3.go`. Results

```
input/Placeholder input_1/Placeholder
[[210] [-210]]
```
Hooray!

Here’s a Gist with the complete code of `attempt3` in case you’d like too build and run it (also remember that’s a Gist, you can contribute if you see something that can be improved!)

```
package main                                        

import (                                            
        "fmt"                                       
        tf "github.com/tensorflow/tensorflow/tensorflow/go"                                              
        "github.com/tensorflow/tensorflow/tensorflow/go/op"                                              
)                                                   

func main() {                                       
        // Let's describe what we want: create the graph                                                 

        // We want to define two placeholder to fill at runtime                                          
        // the first placeholder A will be a [2, 2] tensor of integers                                   
        // the second placeholder x will be a [2, 1] tensor of intergers                                 

        // Then we want to compute Y = Ax           

        // Create the first node of the graph: an empty node, the root of our graph                      
        root := op.NewScope()                       

        // Define the 2 placeholders                
        // define 2 subscopes of the root subscopes, called "input". In this                             
        // way we expect the have a input/ and a input_1/ scope under the root scope                     
        A := op.Placeholder(root.SubScope("input"), tf.Int32, op.PlaceholderShape(tf.MakeShape(2, 2)))   
        x := op.Placeholder(root.SubScope("input"), tf.Int32, op.PlaceholderShape(tf.MakeShape(2, 1)))   
        fmt.Println(A.Op.Name(), x.Op.Name())       

        // Define the operation node that accepts A & x as inputs                                        
        product := op.MatMul(root, A, x)            

        // Every time we passed a `Scope` to an operation, we placed that operation **under**            
        // that scope.                              
        // As you can see, we have an empty scope (created with NewScope): the empty scope               
        // is the root of our graph and thus we denote it with "/".                                      

        // Now we ask tensorflow to build the graph from our definition.                                 
        // The concrete graph is created from the "abstract" graph we defined using the combination      
        // of scope and op.                         

        graph, err := root.Finalize()               
        if err != nil {                             
                // It's useless trying to handle this error in any way:                                  
                // if we defined the graph wrongly we have to manually fix the definition.               

                // It's like a SQL query: if the query is not syntactically valid we have to rewrite it  
                panic(err.Error())                  
        }                                           

        // If here: our graph is syntatically valid.
        // We can now place it within a Session and execute it.

        var sess *tf.Session                        
        sess, err = tf.NewSession(graph, &tf.SessionOptions{})                                           
        if err != nil {                             
                panic(err.Error())                  
        }                                           

        // In order to use placeholders, we have to create the Tensors containing the values to feed into                                                                                                          
        // the network                              
        var matrix, column *tf.Tensor               

        // A = [ [1, 2], [-1, -2] ]                 
        if matrix, err = tf.NewTensor([2][2]int32{{1, 2}, {-1, -2}}); err != nil {                       
                panic(err.Error())                  
        }                                           
        // x = [ [10], [100] ]                      
        if column, err = tf.NewTensor([2][1]int32{{10}, {100}}); err != nil {                            
                panic(err.Error())                  
        }                                           

        var results []*tf.Tensor                    
        if results, err = sess.Run(map[tf.Output]*tf.Tensor{                                             
                A: matrix,                          
                x: column,                          
        }, []tf.Output{product}, nil); err != nil {
                panic(err.Error())                  
        }                                           
        for _, result := range results {            
                fmt.Println(result.Value().([][]int32))                                                  
        }                                           
}
```

#### Question time

What do we have learned about the Tensorflow architecture? *Every operation has its own set of kernel associated. Tensorflow, seen as a descriptive language, is a strong typed language. It not only has to respect the C++ typing rules, but it also has the capability of implementing only certain types that are specified during the op regisration phase.*

# Conclusions

Using Go for defining and executing a graph gave us the opportunity for a better understanding of the underlying Tensorflow structure. Using a trial-and-error approach we solved this simple problem and step by step we learned something new about the graph, its nodes and the typing system.

If you find this article useful, feel free to share it using the buttons below!

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
