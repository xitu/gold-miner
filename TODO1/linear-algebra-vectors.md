> * 原文地址：[Linear Algebra: Vectors](https://medium.com/@geekrodion/linear-algebra-vectors-f7610e9a0f23)
> * 原文作者：[Rodion Chachura](https://medium.com/@geekrodion)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/linear-algebra-vectors.md](https://github.com/xitu/gold-miner/blob/master/TODO1/linear-algebra-vectors.md)
> * 译者：
> * 校对者：

# Linear Algebra: Vectors

## Linear Algebra with JavaScript: Vectors

This is part of the course “[Linear Algebra with JavaScript](https://medium.com/@geekrodion/linear-algebra-with-javascript-46c289178c0)”.

![[GitHub Repository with Source Code](https://github.com/RodionChachura/linear-algebra)](https://cdn-images-1.medium.com/max/2000/1*4yaaTk2eqnmn19nyorh-HA.png)

**Vectors** are the precise way to describe directions in space. They are built from numbers, which form the **components** of the vector. In the picture below, you can see the vector in two-dimensional space that consists of two components. In the case of three-dimensional space vector will consists of three components.

![the vector in 2D space](https://cdn-images-1.medium.com/max/2544/0*aXVg8akmNbxJo7zW)

We can write class for vector in 2D and call it **Vector2D** and then write one for 3D space and call it **Vector3D**, but what if we face a problem where vectors represent not a direction in the physical space. For example, we may need to represent color(RGBA) as a vector, that will have four components — red, green, blue and alpha channel. Or, let’s say we have vector that gives fractions of proportions out of **n** choices, for example, the vector that describes the probability of each out five horses winning the race. So we make a class that not bound to dimensions and use it like this:

```JavaScript
class Vector {
  constructor(...components) {
    this.components = components
  }
}

const direction2d = new Vector(1, 2)
const direction3d = new Vector(1, 2, 3)
const color = new Vector(0.5, 0.4, 0.7, 0.15)
const probabilities = new Vector(0.1, 0.3, 0.15, 0.25, 0.2)
```

## Vector Operations

Consider two vectors, and assume that **α ∈ R** is an arbitrary constant. The following operations are defined for these vectors:

![basic vector operations](https://cdn-images-1.medium.com/max/5808/1*kLbYie-GprAHvlQCvgY1_w.jpeg)

Visualizations of all of this operations, except of cross product you can find [here](https://rodionchachura.github.io/linear-algebra/). In [GitHub repository](https://github.com/RodionChachura/linear-algebra) alongside with library lives React project, where library we are building used to create visualizations. If you are interested in learning how these two-dimensional visualizations made with React and SVG, check out this [story](https://medium.com/@geekrodion/react-for-linear-algebra-examples-grid-and-arrows-f34c07132921).

### Addition and Subtraction

Just like numbers, you can add vectors and subtract them. Performing arithmetic calculations on vectors simply requires carrying out arithmetic operations on their components.

![vectors addition](https://cdn-images-1.medium.com/max/2000/1*XI4LEqCht3hWpDIysF99sA.png)

![vectors subtraction](https://cdn-images-1.medium.com/max/2000/1*gWvb-fsuZhFrIs_yF1Ycsw.png)

Methods for addition receives other vector and return new vectors build from sums of corresponding components. In subtraction, we are doing the same but replace plus on minus.

```JavaScript
class Vector {
  constructor(...components) {
    this.components = components
  }

  add({ components }) {
    return new Vector(
      ...components.map((component, index) => this.components[index] + component)
    )
  }
  subtract({ components }) {
    return new Vector(
      ...components.map((component, index) => this.components[index] - component)
    )
  }
}

const one = new Vector(2, 3)
const other = new Vector(2, 1)
console.log(one.add(other))
// Vector { components: [ 4, 4 ] }
console.log(one.subtract(other))
// Vector { components: [ 0, 2 ] }
```

## Scaling

We can also scale a vector by any number **α ∈ R**, where each component is multiplied by the scaling factor **α**. If **α > 1** the vector will get longer, and if **0 ≤ α \< 1** then the vector will become shorter. If α is a negative number, the scaled vector will point in the opposite direction.

![scaling vector](https://cdn-images-1.medium.com/max/2000/1*mCRgP95wHL50QzajvaB_dw.png)

In **scaleBy** method, we return a new vector with all components multiplied by a number passed as a parameter.

```JavaScript
class Vector {
  constructor(...components) {
    this.components = components
  }
  // ...

  scaleBy(number) {
    return new Vector(
      ...this.components.map(component => component * number)
    )
  }
}

const vector = new Vector(1, 2)
console.log(vector.scaleBy(2))
// Vector { components: [ 2, 4 ] }
console.log(vector.scaleBy(0.5))
// Vector { components: [ 0.5, 1 ] }
console.log(vector.scaleBy(-1))
// Vector { components: [ -1, -2 ] }
```

## Length

A vector length is obtained from Pythagoras’ theorem.

![vectors length](https://cdn-images-1.medium.com/max/2000/1*EN7SuK49mQ6ImghmR7HWxg.png)

Length method is very simple since Math already have a function we need.

```JavaScript
class Vector {
  constructor(...components) {
    this.components = components
  }
  // ...
  
  length() {
    return Math.hypot(...this.components)
  }
}

const vector = new Vector(2, 3)
console.log(vector.length())
// 3.6055512754639896
```

## Dot Product

The dot product tells us how similar two vectors are to each other. It takes two vectors as input and produces a single number as an output. The dot product between two vectors is the sum of the products of corresponding components.

![dot product](https://cdn-images-1.medium.com/max/2000/1*ZPRCCgiLSdgboxiidedH5A.png)

In the **dotProduct** method we receive another vector as a parameter and via reduce method obtain the sum of the products of corresponding components.

```JavaScript
class Vector {
  constructor(...components) {
    this.components = components
  }
  // ...
  
  dotProduct({ components }) {
    return components.reduce((acc, component, index) => acc + component * this.components[index], 0)
  }
}

const one = new Vector(1, 4)
const other = new Vector(2, 2)
console.log(one.dotProduct(other))
// 10
```

Before we look at how vectors directions relate to each other, we implement the method that will return a vector with length equal to one. Such vectors are useful in many contexts. When we want to specify a direction in space, we use a normalized vector in that direction.

```JavaScript
class Vector {
  constructor(...components) {
    this.components = components
  }
  // ...
  
  normalize() {
    return this.scaleBy(1 / this.length())
  }
}

const vector = new Vector(2, 4)
const normalized = vector.normalize()
console.log(normalized)
// Vector { components: [ 0.4472135954999579, 0.8944271909999159 ] }
console.log(normalized.length())
// 1
```

![using dot product](https://cdn-images-1.medium.com/max/2540/0*omakgizb3jmeJ2d-)

If we take the dot product of two normalized vectors and the result is equal to one it means that they have the same direction. To compare two float numbers, we will use the **areEqual** function.

```JavaScript
const EPSILON = 0.00000001

const areEqual = (one, other, epsilon = EPSILON) =>
  Math.abs(one - other) < epsilon

class Vector {
  constructor(...components) {
    this.components = components
  }
  // ...
  
  haveSameDirectionWith(other) {
    const dotProduct = this.normalize().dotProduct(other.normalize())
    return areEqual(dotProduct, 1)
  }
}

const one = new Vector(2, 4)
const other = new Vector(4, 8)
console.log(one.haveSameDirectionWith(other))
// true
```

If we take the dot product of two normalized vectors and the result is equal to minus one it means that they have exact opposite direction.

```JavaScript
class Vector {
  constructor(...components) {
    this.components = components
  }
  // ...
  haveOppositeDirectionTo(other) {
    const dotProduct = this.normalize().dotProduct(other.normalize())
    return areEqual(dotProduct, -1)
  }
}

const one = new Vector(2, 4)
const other = new Vector(-4, -8)
console.log(one.haveOppositeDirectionTo(other))
// true
```

If we take the dot product of two normalized vectors and the result is zero, it means that they are perpendicular.

```JavaScript
class Vector {
  constructor(...components) {
    this.components = components
  }
  // ...
  
  isPerpendicularTo(other) {
    const dotProduct = this.normalize().dotProduct(other.normalize())
    return areEqual(dotProduct, 0)
  }
}

const one = new Vector(-2, 2)
const other = new Vector(2, 2)
console.log(one.isPerpendicularTo(other))
// true
```

## Cross Product

The cross product is only defined for three-dimensional vectors and produces a vector that is perpendicular to both input vectors.

![](https://cdn-images-1.medium.com/max/2000/0*Q5qG6O2_tqQ0DjHA.png)

In our implementation of the cross product we assume that method used only for vectors in three-dimensional space.

```JavaScript
class Vector {
  constructor(...components) {
    this.components = components
  }
  // ...
  
  // 3D vectors only
  crossProduct({ components }) {
    return new Vector(
      this.components[1] * components[2] - this.components[2] * components[1],
      this.components[2] * components[0] - this.components[0] * components[2],
      this.components[0] * components[1] - this.components[1] * components[0]
    )
  }
}

const one = new Vector(2, 1, 1)
const other = new Vector(1, 2, 2)
console.log(one.crossProduct(other))
// Vector { components: [ 0, -3, 3 ] }
console.log(other.crossProduct(one))
// Vector { components: [ 0, 3, -3 ] }
```

## Other useful methods

In real-life applications those methods will not be enough, for example, we may want to find an angle between two vectors, negate vector, or project one to another.

Before we proceed with those methods, we need to write two functions to convert an angle from radians to degrees and back.

```JavaScript
const toDegrees = radians => (radians * 180) / Math.PI
const toRadians = degrees => (degrees * Math.PI) / 180
```

### Angle Between

```JavaScript
class Vector {
  constructor(...components) {
    this.components = components
  }
  // ...
  
  angleBetween(other) {
    return toDegrees(
      Math.acos(
        this.dotProduct(other) /
        (this.length() * other.length())
      )
    )
  }
}

const one = new Vector(0, 4)
const other = new Vector(4, 4)
console.log(one.angleBetween(other))
// 45.00000000000001
```

### Negate

To make a vector directing to the negative direction we need to scale it by minus one.

```JavaScript
class Vector {
  constructor(...components) {
    this.components = components
  }
  // ...
  
  negate() {
    return this.scaleBy(-1)
  }
}

const vector = new Vector(2, 2)
console.log(vector.negate())
// Vector { components: [ -2, -2 ] }
```

## Project On

![project v on d](https://cdn-images-1.medium.com/max/2546/0*bBy_TzPH8XoNC6hK)

```JavaScript
class Vector {
  constructor(...components) {
    this.components = components
  }
  // ...
  
  projectOn(other) {
    const normalized = other.normalize()
    return normalized.scaleBy(this.dotProduct(normalized))
  }
}

const one = new Vector(8, 4)
const other = new Vector(4, 7)
console.log(other.projectOn(one))
// Vector { components: [ 6, 3 ] }
```

### With Length

Often we may need to make our vector a specific length.

```JavaScript
class Vector {
  constructor(...components) {
    this.components = components
  }
  // ...
  withLength(newLength) {
    return this.normalize().scaleBy(newLength)
  }
}

const one = new Vector(2, 3)
console.log(one.length())
// 3.6055512754639896
const modified = one.withLength(10)
// 10
console.log(modified.length())
```

### Equal To

To check if two vectors are equal we will use **areEqual** function for all components.

```JavaScript
class Vector {
  constructor(...components) {
    this.components = components
  }
  // ...
  
  equalTo({ components }) {
    return components.every((component, index) => areEqual(component, this.components[index]))
  }
}

const one = new Vector(1, 2)
const other = new Vector(1, 2)
console.log(one.equalTo(other))
// true
const another = new Vector(2, 1)
console.log(one.equalTo(another))
// false
```

## Unit Vector and Basis

We can think of a vector as a command to “go a distance **vx** in the x-direction, a distance **vy** in the y-direction and **vz** in z-direction.” To write this set of commands more explicitly, we can use multiples of the vectors **̂i, ̂j,** and **̂k**. These are the **unit vectors** pointing in the **x**, **y**, and **z** directions, respectively:

![standard basis {**i, ̂j, ̂k}**](https://cdn-images-1.medium.com/max/2542/0*Sona4GGrMK42oWX1)

Any number multiplied by **̂i** corresponds to a vectors with that number in the first coordinate. For example:

![](https://cdn-images-1.medium.com/max/2540/0*ZDBCiT4GzaoMUMKK)

One of the most important concepts in the study of vectors is the concept of a **basis**. Consider the space of three-dimensional vectors **ℝ³**. A basis for **ℝ³** is a set of vectors **{ê₁, ê₂ , ê₃}** which can be used as a coordinate system for **ℝ³**. If the set of vectors **{ê₁, ê₂, ê₃}** is a basis then we can represent any vector **v⃗∈ℝ³** as coefficients **(v₁, v₂, v₃)** with respect to that basis:

![vector with respect to basis **{ê₁, ê₂, ê₃}**](https://cdn-images-1.medium.com/max/2538/0*dw49nY-jTmHb_63J)

The vector **v⃗** is obtained by measuring out a distance **v₁** in the **ê₁** direction, a distance **v₂** in the **ê₂** direction, and a distance **v₃** in the **ê₃** direction.

A triplet of coefficients by itself does not mean anything unless we know the basis being used. A basis is required to convert mathematical object like the triplet **(a, b, c)** into real-world ideas like colors, probabilities or locations.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
