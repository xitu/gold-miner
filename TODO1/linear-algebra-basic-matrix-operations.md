> * 原文地址：[Linear Algebra: Basic Matrix Operations](https://medium.com/swlh/linear-algebra-basic-matrix-operations-13a019633c15)
> * 原文作者：[Rodion Chachura](https://medium.com/@geekrodion)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/linear-algebra-basic-matrix-operations.md](https://github.com/xitu/gold-miner/blob/master/TODO1/linear-algebra-basic-matrix-operations.md)
> * 译者：
> * 校对者：

# Linear Algebra: Basic Matrix Operations

This is part of the course “[Linear Algebra with JavaScript](https://medium.com/@geekrodion/linear-algebra-with-javascript-46c289178c0)”.

![[GitHub Repository with Source Code](https://github.com/RodionChachura/linear-algebra)](https://cdn-images-1.medium.com/max/2000/1*4yaaTk2eqnmn19nyorh-HA.png)

In this part, we will cover the most of basic matrix operations. We are going add and subtract matrices, multiply them by a scalar, implement matrix-matrix multiplication, find transpose matrix and take a more deep look at determinant. We are not going to look at concepts such as inverse matrix and rank in this part, but leave them for the future.

## Addition and Subtraction

The matrix **addition** and **subtraction** operations take pairs of matrices as inputs and produce matrices as outputs. Addition and subtraction are performed component-wise and matrices must have the same dimensions to be added or subtracted.

To not repeat the same code in addition and subtraction we first write a method that receives operation, function that will do something with two components and another matrix. Then we can call it in both addition and subtraction methods with different operations.

```JavaScript
class Matrix {
  // ...
  componentWiseOperation(func, { rows }) {
    const newRows = rows.map((row, i) =>
      row.map((element, j) => func(this.rows[i][j], element))
    )
    return new Matrix(...newRows)
  }
  add(other) {
    return this.componentWiseOperation((a, b) => a + b, other)
  }
  subtract(other) {
    return this.componentWiseOperation((a, b) => a - b, other)
  }
}

const one = new Matrix(
  [1, 2],
  [3, 4]
)
const other = new Matrix(
  [5, 6],
  [7, 8]
)

console.log(one.add(other))
// Matrix { rows: [ [ 6, 8 ], [ 10, 12 ] ] }
console.log(other.subtract(one))
// Matrix { rows: [ [ 4, 4 ], [ 4, 4 ] ] }
```

## Scalar-Matrix Multiplication

Scalar multiplication of matrices is defined in a similar way as for vectors and is done by multiplying every element of the matrix by the scalar.

```JavaScript
class Matrix {
  // ...
  scaleBy(number) {
    const newRows = this.rows.map(row =>
      row.map(element => element * number)
    )
    return new Matrix(...newRows)
  }
}

const matrix = new Matrix(
  [2, 3],
  [4, 5]
)
console.log(matrix.scaleBy(2))
// Matrix { rows: [ [ 4, 6 ], [ 8, 10 ] ] }
```

## Matrix-Matrix Multiplication

We can multiply two matrices **A** and **B** provided their dimensions are **compatible**, which means the number of columns of **A** equals the number of rows of **B**. The matrix product **AB** of matrices consists of computing the dot product between each row of **A** and each column of **B**:

![matrix-matrix multiplication](https://cdn-images-1.medium.com/max/2544/0*je9iPoT0Mv1OeFzf)

```JavaScript
class Matrix {
  // ...
  multiply(other) {
    if (this.rows[0].length !== other.rows.length) {
      throw new Error('The number of columns of this matrix is not equal to the number of rows of the given matrix.')
    }
    const columns = other.columns()
    const newRows = this.rows.map(row => 
      columns.map(column => sum(row.map((element, i) => element * column[i])))
    )

    return new Matrix(...newRows)
  }
}

const one = new Matrix(
  [3, -4],
  [0, -3],
  [6, -2],
  [-1, 1]
)
const other = new Matrix(
  [3,  2, -4],
  [4, -3,  5]
)
console.log(one.multiply(other))
// Matrix {
//   rows:
//    [ [ -7, 18, -32 ],
//      [ -12, 9, -15 ],
//      [ 10, 18, -34 ],
//      [ 1, -5, 9 ] ]}
```

We can think of a result of a matrix-matrix product **AB** as a linear transformation that first applies linear transformation **B** and then **A**. To better understand this concept let’s go to the [linear-algebra-demo](https://rodionchachura.github.io/linear-algebra/) project.

Yellow shape in the picture below is the result of applying linear transformation **C** to the red square. Transformation **C** is a result of matrix-matrix multiplication. Where **A** is a reflection matrix, and **B** is a shear matrix.

![rotate than shear](https://cdn-images-1.medium.com/max/2110/1*9z2FfKuyWoDW7N4DVNUiIg.png)

If we change the order of matrices **A** and **B** in matrix-matrix multiplication, we will receive a different result, because first will be applied transformation **B** and then **A**.

![shear than rotate](https://cdn-images-1.medium.com/max/2106/1*S7XNcZbrzPq0OJbVBEs6QQ.png)

## Transpose

The **transpose** matrix **Aᵀ** is defined by the formula **aᵀᵢⱼ = aⱼᵢ**. In other words, we obtain the transpose by “flipping” the matrix through its diagonal. Note that entries on the diagonal of the matrix are not affected by the transpose operation.

```JavaScript
class Matrix {
  // ...
  transpose() {
    return new Matrix(...this.columns())
  }
}

const matrix = new Matrix(
  [0,  1,  2],
  [3,  4,  5],
  [6,  7,  8],
  [9, 10, 11]
)
console.log(matrix.transpose())
// Matrix {
//   rows: [
//     [ 0, 3, 6, 9 ],
//     [ 1, 4, 7, 10 ],
//     [ 2, 5, 8, 11 ]
//   ]
// }
```

## Determinant

The **determinant** of a matrix is a calculation that involves all the coefficients of the matrix, and whose output is a single number. The determinant describes the relative geometry of the vectors that make up the rows of the matrix. More specifically, the determinant of a matrix A tells you the volume of a box with sides given by rows of **A**. The determinant of a **2×2** matrix is:

![det(2×2 matrix)](https://cdn-images-1.medium.com/max/2000/1*XF0G3uzHulUun-Ic65p2fw.jpeg)

The determinant of a **3×3** matrix is:

![det(3×3 matrix)](https://cdn-images-1.medium.com/max/2544/0*Eizii7WkVDVC7v9l)

Our method will calculate determinant for a matrix of any size, as long as it has the same number of rows and columns.

```JavaScript
class Matrix {
  // ...
  determinant() {
    if (this.rows.length !== this.rows[0].length) {
      throw new Error('Only matrices with the same number of rows and columns are supported.')
    }
    if (this.rows.length === 2) {
      return this.rows[0][0] * this.rows[1][1] - this.rows[0][1] * this.rows[1][0]
    }

    const parts = this.rows[0].map((coef, index) => {
      const matrixRows = this.rows.slice(1).map(row => [ ...row.slice(0, index), ...row.slice(index + 1)])
      const matrix = new Matrix(...matrixRows)
      const result = coef * matrix.determinant()
      return index % 2 === 0 ? result : -result
    })

    return sum(parts)
  }
}

const matrix2 = new Matrix(
  [ 0, 3],
  [-2, 1]
)
console.log(matrix2.determinant())
// 6
const matrix3 = new Matrix(
  [2, -3,  1],
  [2,  0, -1],
  [1,  4,  5]
)
console.log(matrix3.determinant())
// 49
const matrix4 = new Matrix(
  [3, 0, 2, -1],
  [1, 2, 0, -2],
  [4, 0, 6, -3],
  [5, 0, 2,  0]
)
console.log(matrix4.determinant())
// 20
```

Determinant shows us exactly how much are things being stretched. We can think of it as the factor by which a linear transformation changes any area. To better understand this concept let’s go to the [linear-algebra-demo](https://rodionchachura.github.io/linear-algebra/) project.

In the picture below we can see that after applying the linear transformation area to red **1×1** square we get a **3×2** rectangle with area equal to **6**, exactly the same number as a determinant of the matrix.

![det(scale transformation)](https://cdn-images-1.medium.com/max/2480/1*rm55kfQk00sAHRHkXPJAHg.png)

If we apply a shear transformation, we can see that the square become parallelogram, and the area remains the same. A determinant is equal to one.

![det(shear transformation)](https://cdn-images-1.medium.com/max/2452/1*NXslmXLlNlD2Fggs-HGmzg.png)

The determinant is **negative** if after applying the linear transformation orientation of the space will be reverted. In the picture below we can see that before transformation **ĵ** is to the left of î, and after the transformation **ĵ** on the right of **î**.

![negative determinant](https://cdn-images-1.medium.com/max/2384/1*SENNf6sb4_88cofTLlGEeg.png)

The determinant of a transformation is **zero** if it squishes all of space onto a line or even on a single point. It means checking if the determinant of a given matrix is 0 will give away if computing weather or not the transformation associated with that matrix squishes everything into a smaller dimension.

![zero determinant](https://cdn-images-1.medium.com/max/2380/1*xst460qMsFeqqICnRy2SlQ.png)

In three-dimensional space, determinant tells you how much volumes get scaled.

![det(scale transformation) in 3D](https://cdn-images-1.medium.com/max/2300/1*y7Y_aqlGo-J15hwwl7NgfQ.gif)

The determinant of 0 would mean that all of space is squished onto something with 0 volume. If in two-dimensional space it would mean that result of transformation squished onto a line or point, in three-dimensional case it also can mean that objects squished onto a plane, as in the example below.

![zero determinant in 3D](https://cdn-images-1.medium.com/max/2300/1*K9o2OrhtfqWO2NNo4hK5NA.gif)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
