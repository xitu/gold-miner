> * 原文地址：[Linear Algebra: Linear Transformation, Matrix](https://medium.com/@geekrodion/linear-algebra-linear-transformation-matrix-2f4befc3c27b)
> * 原文作者：[Rodion Chachura](https://medium.com/@geekrodion)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/linear-algebra-linear-transformation-matrix.md](https://github.com/xitu/gold-miner/blob/master/TODO1/linear-algebra-linear-transformation-matrix.md)
> * 译者：
> * 校对者：

# Linear Algebra: Linear Transformation, Matrix

## Linear Algebra with JavaScript: Linear Transformation, Matrix

This is part of the course “[Linear Algebra with JavaScript](https://medium.com/@geekrodion/linear-algebra-with-javascript-46c289178c0)”.

![[GitHub Repository with Source Code](https://github.com/RodionChachura/linear-algebra)](https://cdn-images-1.medium.com/max/2000/1*4yaaTk2eqnmn19nyorh-HA.png)

A **matrix** is a rectangular array of real numbers with **m** rows and **n** columns. For example, a **3×2** matrix looks like this:

![**3×2** matrix](https://cdn-images-1.medium.com/max/2000/1*wJjLyI2-iDRMaDqd2Sh0iw.jpeg)

Let’s go right to the code. The constructor of the **Matrix** class will receive rows as a parameter. We will access a particular element in the matrix by first taking row by row index and then element by column index.

```JavaScript
class Matrix {
  constructor(...rows) {
    this.rows = rows
  }
}

const matrix = new Matrix(
  [0, 1],
  [2, 3],
  [4, 5]
)
console.log(matrix)
// Matrix { rows: [ [ 0, 1 ], [ 2, 3 ], [ 4, 5 ] ] }
console.log(matrix.rows[1])
// [ 2, 3 ]
console.log(matrix.rows[1][1])
// 3
```

## Matrix-vector product

The **matrix-vector product** **Ax⃗** produces a linear combination of the columns of the matrix **A** with coefficients **x⃗**. For example, the product of a **3×2** matrix A and a **2D** vector **x⃗** results in a **3D** vector, which we’ll denote **y⃗: y⃗=Ax⃗**

![**y⃗=Ax⃗**](https://cdn-images-1.medium.com/max/2538/0*sa84p6WtAYoAB8u0)

Consider some set of vectors **{e⃗₁, e⃗₂}**, and a third vector **y⃗** that is a **linear combination** of the vectors **e⃗₁** and **e⃗₂: y⃗=αe⃗₁ + βe⃗₂.** The numbers **α, β ∈ R** are the coefficients in this linear combination.

The matrix-vector product is defined expressly for the purpose of studying linear combinations. We can describe the above linear combination as the following matrix vector product: **y⃗=Ex⃗**. The matrix **E** has **e⃗₁** and **e⃗₂** as columns. The dimensions of the matrix will be **n×2**, where **n** is the dimension of the vectors **e⃗₁, e⃗₂** and **y⃗**.

In the picture below we can see vector **v⃗** represented as a linear combination of vectors **î** and ĵ.

![linear combination](https://cdn-images-1.medium.com/max/2000/1*OtdjxVPrwMaGSzUyc9wzdA.png)

```JavaScript
const i = new Vector(1, 0)
const j = new Vector(0, 1)
const firstCoeff = 2
const secondCoeff = 5
const linearCombination = i.scaleBy(firstCoeff).add(j.scaleBy(secondCoeff))
console.log(linearCombination)
// Vector { components: [ 2, 5 ] }
```

## Linear Transformation

The matrix-vector product corresponds to the abstract notion of a **linear transformation**, which is one of the key notions in the study of linear algebra. Multiplication by a matrix can be thought of as computing a linear transformation that takes n-dimensional vector as an input and produces m-dimensional vector as an output. We can say matrix is a certain transformation of vector in space.

It will become more clear on examples, but first, let’s add a method to Matrix class that will return columns of the matrix.

```JavaScript
class Matrix {
  constructor(...rows) {
    this.rows = rows
  }
  columns() {
    return this.rows[0].map((_, i) => this.rows.map(r => r[i]))
  }
}

const matrix = new Matrix(
  [1, 2, 3],
  [4, 5, 6],
  [7, 8, 9]
)
console.log(matrix.columns())
// [ [ 1, 4, 7 ], [ 2, 5, 8 ], [ 3, 6, 9 ] ]
```

In the code sample below you can examples of different vector-matrix products. The dimension of the resulting vector will always be equal to the number of matrix rows. If we multiply a **2D** vector to a **3×2** matrix, we will receive a **3D** vector, and when we multiply a **3D** vector to a **2×3** matrix, we will receive a **2D** vector. If a number of columns in the matrix not equal to vector dimension, we throw an error.

```JavaScript
const sum = arr => arr.reduce((acc, value) => acc + value, 0)

class Vector {
  // ...
  transform(matrix) {
    const columns = matrix.columns()
    if(columns.length !== this.components.length) {
      throw new Error('Matrix columns length should be equal to vector components length.')
    }

    const multiplied = columns
      .map((column, i) => column.map(c => c * this.components[i]))
    const newComponents = multiplied[0].map((_, i) => sum(multiplied.map(column => column[i])))
    return new Vector(...newComponents)
  }
}

const vector2D = new Vector(3, 5)
const vector3D = new Vector(3, 5, 2)
const matrix2x2D = new Matrix(
  [1, 2],
  [3, 4]
)
const matrix2x3D = new Matrix(
  [1, 2, 3],
  [4, 5, 6]
)
const matrix3x2D = new Matrix(
  [1, 2],
  [3, 4],
  [5, 6]
)

// 2D => 2D
console.log(vector2D.transform(matrix2x2D))
// Vector { components: [ 13, 29 ] }

// 3D => 2D
console.log(vector3D.transform(matrix2x3D))
// Vector { components: [ 19, 49 ] }

// 2D => 3D
console.log(vector2D.transform(matrix3x2D))
// Vector { components: [ 13, 29, 45 ] }
console.log(vector2D.transform(matrix2x3D))
// Error: Matrix columns length should be equal to vector components length.
```

## Examples

Now let’s try to move and change the two-dimensional object by using linear transformations. First, we will create a new class — **Contour** that will receive a list of vectors in the constructor and for now, will have only one method — **transform**, that will transform all coordinates of the contour and will return a new one.

```JavaScript
class Contour {
  constructor(vectors) {
    this.vectors = vectors
  }

  transform(matrix) {
    const newVectors = this.vectors.map(v => v.transform(matrix))
    return new Contour(newVectors)
  }
}

const contour = new Contour([
  new Vector(0, 0),
  new Vector(0, 4),
  new Vector(4, 4),
  new Vector(4, 0)
])
```

Now, let’s go to the [linear-algebra-demo](https://rodionchachura.github.io/linear-algebra/) project and try out different transformation matrices. Red square is an initial contour, and the blue one is a result of applying the transformation.

![reflection](https://cdn-images-1.medium.com/max/2010/1*M60SUzpCBZIRfIZRb-QRBQ.png)

![scale](https://cdn-images-1.medium.com/max/2006/1*nuZwkcbpw0RMbl1DzuQrxQ.png)

This way we can make a matrix that will rotate a given vector on a certain angle.

```JavaScript
const angle = toRadians(45)

const matrix = new Matrix(
  [Math.cos(angle), -Math.sin(angle)],
  [Math.sin(angle), Math.cos(angle)]
)
```

![rotation](https://cdn-images-1.medium.com/max/2002/1*vZ5Sblw5oPaq8OCw07ligg.png)

![shear](https://cdn-images-1.medium.com/max/2004/1*naUftl-XYETBUtcAYujT0w.png)

Transformation works the same way for objects in 3D space, below you can see the animated transformation from the red cube, to blue parallelepiped.

![shear 3D](https://cdn-images-1.medium.com/max/2432/1*zoTrp_lm1p2HQClkaOdMOQ.gif)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
