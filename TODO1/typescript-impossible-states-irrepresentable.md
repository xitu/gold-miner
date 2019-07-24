> * 原文地址：[Using Typescript to make invalid states irrepresentable](http://www.javiercasas.com/articles/typescript-impossible-states-irrepresentable)
> * 原文作者：[Javier Casas](http://www.javiercasas.com)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/typescript-impossible-states-irrepresentable.md](https://github.com/xitu/gold-miner/blob/master/TODO1/typescript-impossible-states-irrepresentable.md)
> * 译者：
> * 校对者：

# Using Typescript to make invalid states irrepresentable

One of the principles of good Haskell, and in general good Typed Functional Programming, is the principle of making invalid states irrepresentable. What does this mean? We use the typesystem to craft types that impose constraints on our data and our state, so that it's impossible to represent these states that should not exist. Now that, at the type level, we managed to banish invalid states, the typesystem will step in and give us trouble every time we try to construct an invalid state. If we can't construct an invalid state, it's very hard for our program to end up in an invalid state, because in order to reach that invalid state the program should have followed a chain of actions that construct the invalid state. But such program would be invalid at the type level, and the typechecker would happily step in and tell us we are doing something wrong. This is great, because the typesystem will happily remember for us the constraints our data has, so we don't have to trust our flaky memory to remember them.

Fortunately, many of the results of this technique can be adapted to other programming languages, and today we are going to experiment with it in Typescript.

## A sample problem

Let's work on a sample problem so we can try to understand how we can use this. We are going to constraint a type for a function using Algebraic Data Types, so that we can prevent invalid parameters to it. Our toy problem is as follows:

* We have a function that accepts a single parameter: an object with potentially two fields, called `field1` and `field2`.
* The object may not have neither of the two fields.
* The object may have only `field1`, and not `field2`.
* Only if the object has `field1`, then it can have `field2`.
* Therefore, an object with `field2`, but not `field1`, is invalid.
* For simplicity, when `field1` or `field2` exist, they will be of type `string`, but they could be of any type.

### Naive solution

Let's start with the simplest approach. Because both `field1` and `field2` can exist, or not, we just make them optional.

```typescript
interface Fields {
  field1?: string;
  field2?: string;
};

function receiver(f: Fields) {
  if (f.field1 === undefined && f.field2 !== undefined) {
    throw new Error("Oh noes, this should be impossible!");
  }
  // do stuff
}
```

Unfortunately, this doesn't prevent anything at compile time, and requires checking for that possible error at runtime.

```typescript
// This will not raise any errors at compile time
// so we will have to find at runtime that it's broken
receiver({field2: "Hahaha, I didn't put a field1!"})
```

### Basic ADT solution

So we called `receiver` with the wrong fields several times in a row, our application exploded in flames, and we are not happy. Time to do something about it. Let's enumerate the cases again, so that we can see if we can make a type with the right shape:

* The object may not have neither of the two fields.
* The object may have only `field1`, and not `field2`.
* Only if the object has `field1`, then it can have `field2`. Therefore, in this case, the object has both `field1` and `field2`.
* An object with `field2`, but not `field1`, is invalid.

Let's transcribe this into types:

```typescript
interface NoFields {};

interface Field1Only {
  field1: string;
};

interface BothField1AndField2 {
  field1: string;
  field2: string;
};

interface InvalidObject {
  field2: string;
};
```

We decided to also include here `InvalidObject`, but it's a bit silly writing it, because we don't want it to really exist. We may keep it around as documentation, or we may remove it so that to affirm even more that it is not supposed to exist. Now let's write a type for `Fields`:

```typescript
type Fields = NoFields | Field1Only | BothField1AndField2;  // I deliberately forgot to put here InvalidObject
```

With this disposition, it's harder to send to `receiver` an `InvalidObject`:

```typescript
receiver({field2: "Hahaha, I didn't put a field1!"});  // Type error! This object doesn't match the type `Fields`
```

We also need to tweak the `receiver` function a little bit, mostly because the fields may not exist now, and the typechecker now requires proof that you are going to read fields that actually exist:

```typescript
function receiver(f: Fields) {
  if ("field1" in f) {
    if ("field2" in f) {
      // do something with f.field1 and f.field2
    } else {
      // do something with f.field1, but f.field2 doesn't exist
    }
  } else {
    // f is an empty Fields
  }
}
```

#### Limitations of structural typing

Unfortunately, for good or for bad, Typescript is a structural type system, and this allows us to bypass some of the safety if we are not careful. The `NoFields` type (empty object, `{}`), in Typescript, means something totally different to what we want it to do. Actually when we write:

```typescript
interface Foo {
  field: string;
};
```

Typescript understands that any `object` with a `field` of type `string` is good, except for the case where we create a new object, like:

```typescript
const myFoo : Foo = { field: "asdf" };  // In this case we can't add more fields
```

But, on assignment, Typescript tests using structural typing, and that means our objects may end with more fields that what we would like them to have:

```typescript
const getReady = { field: "asdf", unexpectedField: "hehehe" };
const myFoo : Foo = getReady;  // This is not an error
```

So, when we extend this idea to the empty object `{}`, turns out that on assignment, Typescript will accept any value as long as that value is an object, and has all the fields demanded. Because the type demands no fields, this second condition succeeds trivially for any `object`, which is totally not what we wanted it to do.

### Banning unexpected fields

Let's try to make a type for objects with no fields, so that we actually have to go out of our way to fool the typechecker. We already know `never`, the type that can never be satisfied. Now we need another ingredient to say "every possible field". And this ingredient is: `[key: string]: type`. With these two we can construct the object with no fields:

```typescript
type NoFields = {
  [key: string]: never;
};
```

This type means: this is an object, whose fields are of type `never`. Because you can't construct a `never`, there is no way to make valid values for the fields of this object. Therefore, the only solution is an object with no fields. Now, we have to be more deliberate to break the types:

```typescript
type NoFields = {
  [key: string]: never;
};

interface Field1Only {
  field1: string;
};

interface BothField1AndField2 {
  field1: string;
  field2: string;
};

type Fields = NoFields | Field1Only | BothField1AndField2;

const broken = {field2: "asdf"};

// Bypass1: go through an empty object type
// Empty object is a well known code smell in Typescript
const bypass1 : {} = broken;
const brokenThroughBypass1 : Fields = bypass1;

// Bypass2: use the `any` escape hatch
// any is another well known code smell in Typescript
const bypass2 : any = broken;
const brokenThroughBypass2 : Fields = bypass2;
```

It looks like now we need two very specific steps to break the system, so it will be definitely quite harder to do it, and we should notice something wrong if we have to go to such deep ways to construct a program.

## Conclusion

Today we saw an approach to the great promise of program correctness through types, applied to a more mainstream language: Typescript. Although Typescript can't promise the same level of safety as Haskell, that doesn't prevent us from applying a few ideas from Haskell to Typescript.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
