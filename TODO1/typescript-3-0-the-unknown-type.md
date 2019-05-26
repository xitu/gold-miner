# TypeScript 3.0: The unknown Type

TypeScript 3.0 introduced a new `unknown` type which is the type-safe counterpart of the `any` type.

The main difference between `unknown` and `any` is that `unknown` is much less permissive than `any`: we have to do some form of checking before performing most operations on values of type `unknown`, whereas we don't have to do any checks before performing operations on values of type `any`.

This post focuses on the practical aspects of the `unknown` type, including a comparison with the `any` type. For a comprehensive code example showing the semantics of the `unknown` type, check out Anders Hejlsberg's [original pull request](https://github.com/Microsoft/TypeScript/pull/24439).

## The `any` Type

Let's first look at the `any` type so that we can better understand the motivation behind introducing the `unknown` type.

The `any` type has been in TypeScript since the first release in 2012. It represents all possible JavaScript values --- primitives, objects, arrays, functions, errors, symbols, what have you.

In TypeScript, every type is assignable to `any`. This makes `any` a [*top type*](https://en.wikipedia.org/wiki/Top_type) (also known as a *universal supertype*) of the type system.

Here are a few examples of values that we can assign to a variable of type `any`:

```ts
let value: any;

value = true;             // OK
value = 42;               // OK
value = "Hello World";    // OK
value = [];               // OK
value = {};               // OK
value = Math.random;      // OK
value = null;             // OK
value = undefined;        // OK
value = new TypeError();  // OK
value = Symbol("type");   // OK
```

The `any` type is essentially an escape hatch from the type system. As developers, this gives us a ton of freedom: TypeScript lets us perform any operation we want on values of type `any` without having to perform any kind of checking beforehand.

In the above example, the `value` variable is typed as `any`. Because of that, TypeScript considers all of the following operations to be type-correct:

```ts
let value: any;

value.foo.bar;  // OK
value.trim();   // OK
value();        // OK
new value();    // OK
value[0][1];    // OK
```

In many cases, this is too permissive. Using the `any` type, it's easy to write code that is type-correct, but problematic at runtime. We don't get a lot of protection from TypeScript if we're opting to use `any`.

What if there were a top type that was safe by default? This is where `unknown`comes into play.

## The `unknown` Type

Just like all types are assignable to `any`, all types are assignable to `unknown`. This makes `unknown` another top type of TypeScript's type system (the other one being `any`).

Here's the same list of assignment examples we saw before, this time using a variable typed as `unknown`:

```ts
let value: unknown;

value = true;             // OK
value = 42;               // OK
value = "Hello World";    // OK
value = [];               // OK
value = {};               // OK
value = Math.random;      // OK
value = null;             // OK
value = undefined;        // OK
value = new TypeError();  // OK
value = Symbol("type");   // OK
```

All assignments to the `value` variable are considered type-correct.

What happens though when we try to assign a value of type `unknown` to variables of other types?

```ts
let value: unknown;

let value1: unknown = value;   // OK
let value2: any = value;       // OK
let value3: boolean = value;   // Error
let value4: number = value;    // Error
let value5: string = value;    // Error
let value6: object = value;    // Error
let value7: any[] = value;     // Error
let value8: Function = value;  // Error
```

The `unknown` type is only assignable to the `any` type and the `unknown` type itself. Intuitively, this makes sense: only a container that is capable of holding values of arbitrary types can hold a value of type `unknown`; after all, we don't know anything about what kind of value is stored in `value`.

Let's now see what happens when we try to perform operations on values of type `unknown`. Here are the same operations we've looked at before:

```ts
let value: unknown;

value.foo.bar;  // Error
value.trim();   // Error
value();        // Error
new value();    // Error
value[0][1];    // Error
```

With the `value` variable typed as `unknown`, none of these operations are considered type-correct anymore. By going from `any` to `unknown`, we've flipped the default from permitting everything to permitting (almost) nothing.

This is the main value proposition of the `unknown` type: TypeScript won't let us perform arbitrary operations on values of type `unknown`. Instead, we have to perform some sort of type checking first to narrow the type of the value we're working with.

## Narrowing the `unknown` Type

We can narrow the `unknown` type to a more specific type in different ways, including the `typeof` operator, the `instanceof` operator, and custom type guard functions. All of these narrowing techniques contribute to TypeScript's [control flow based type analysis](https://mariusschulz.com/blog/typescript-2-0-control-flow-based-type-analysis).

The following example illustrates how `value` has a more specific type within the two `if` statement branches:

```ts
function stringifyForLogging(value: unknown): string {
  if (typeof value === "function") {
    // Within this branch, `value` has type `Function`,
    // so we can access the function's `name` property
    const functionName = value.name || "(anonymous)";
    return `[function ${functionName}]`;
  }

  if (value instanceof Date) {
    // Within this branch, `value` has type `Date`,
    // so we can call the `toISOString` method
    return value.toISOString();
  }

  return String(value);
}
```

In addition to using the `typeof` or `instanceof` operators, we can also narrow the `unknown` type using a custom type guard function:

```ts
/**
 * A custom type guard function that determines whether
 * `value` is an array that only contains numbers.
 */
function isNumberArray(value: unknown): value is number[] {
  return (
    Array.isArray(value) &&
    value.every(element => typeof element === "number")
  );
}

const unknownValue: unknown = [15, 23, 8, 4, 42, 16];

if (isNumberArray(unknownValue)) {
  // Within this branch, `unknownValue` has type `number[]`,
  // so we can spread the numbers as arguments to `Math.max`
  const max = Math.max(...unknownValue);
  console.log(max);
}
```

Notice how `unknownValue` has type `number[]` within the `if` statement branch although it is declared to be of type `unknown`.

## Using Type Assertions with `unknown`

In the previous section, we've seen how to use `typeof`, `instanceof`, and custom type guard functions to convince the TypeScript compiler that a value has a certain type. This is the safe and recommended way to narrow values of type `unknown` to a more specific type.

If you want to force the compiler to trust you that a value of type `unknown` is of a given type, you can use a type assertion like this:

```ts
const value: unknown = "Hello World";
const someString: string = value as string;
const otherString = someString.toUpperCase();  // "HELLO WORLD"
```

Be aware that TypeScript is not performing any special checks to make sure the type assertion is actually valid. The type checker assumes that you know better and trusts that whatever type you're using in your type assertion is correct.

This can easily lead to an error being thrown at runtime if you make a mistake and specify an incorrect type:

```ts
const value: unknown = 42;
const someString: string = value as string;
const otherString = someString.toUpperCase();  // BOOM
```

The `value` variable holds a number, but we're pretending it's a string using the type assertion `value as string`. Be careful with type assertions!

## The `unknown` Type in Union Types

Let's now look at how the `unknown` type is treated within union types. In the next section, we'll also look at intersection types.

In a union type, `unknown` absorbs every type. This means that if any of the constituent types is `unknown`, the union type evaluates to `unknown`:

```ts
type UnionType1 = unknown | null;       // unknown
type UnionType2 = unknown | undefined;  // unknown
type UnionType3 = unknown | string;     // unknown
type UnionType4 = unknown | number[];   // unknown
```

The one exception to this rule is `any`. If at least one of the constituent types is `any`, the union type evaluates to `any`:

```ts
type UnionType5 = unknown | any;  // any
```

So why does `unknown` absorb every type (aside from `any`)? Let's think about the `unknown | string` example. This type represents all values that are assignable to type `unknown` plus those that are assignable to type `string`. As we've learned before, all types are assignable to `unknown`. This includes all strings, and therefore, `unknown | string` represents the same set of values as `unknown` itself. Hence, the compiler can simplify the union type to `unknown`.

## The `unknown` Type in Intersection Types

In an intersection type, every type absorbs `unknown`. This means that intersecting any type with `unknown` doesn't change the resulting type:

```ts
type IntersectionType1 = unknown & null;       // null
type IntersectionType2 = unknown & undefined;  // undefined
type IntersectionType3 = unknown & string;     // string
type IntersectionType4 = unknown & number[];   // number[]
type IntersectionType5 = unknown & any;        // any
```

Let's look at `IntersectionType3`: the `unknown & string` type represents all values that are assignable to both `unknown` and `string`. Since every type is assignable to `unknown`, including `unknown` in an intersection type does not change the result. We're left with just `string`.

## Using Operators with Values of Type `unknown`

Values of type `unknown` cannot be used as operands for most operators. This is because most operators are unlikely to produce a meaningful result if we don't know the types of the values we're working with.

The only operators you can use on values of type `unknown` are the four equality and inequality operators:

-   `===`
-   `==`
-   `!==`
-   `!=`

If you want to use any other operators on a value typed as `unknown`, you have to narrow the type first (or force the compiler to trust you using a type assertion).

## Example: Reading JSON from `localStorage`

Here's a real-world example of how we could use the `unknown` type.

Let's assume we want to write a function that reads a value from `localStorage`and deserializes it as JSON. If the item doesn't exist or isn't valid JSON, the function should return an error result; otherwise, it should deserialize and return the value.

Since we don't know what type of value we'll get after deserializing the persisted JSON string, we'll be using `unknown` as the type for the deserialized value. This means that callers of our function will have to do some form of checking before performing operations on the returned value (or resort to using type assertions).

Here's how we could implement that function:

```ts
type Result =
  | { success: true, value: unknown }
  | { success: false, error: Error };

function tryDeserializeLocalStorageItem(key: string): Result {
  const item = localStorage.getItem(key);

  if (item === null) {
    // The item does not exist, thus return an error result
    return {
      success: false,
      error: new Error(`Item with key "${key}" does not exist`)
    };
  }

  let value: unknown;

  try {
    value = JSON.parse(item);
  } catch (error) {
    // The item is not valid JSON, thus return an error result
    return {
      success: false,
      error
    };
  }

  // Everything's fine, thus return a success result
  return {
    success: true,
    value
  };
}
```

The return type `Result` is a [tagged union type](https://mariusschulz.com/blog/typescript-2-0-tagged-union-types). In other languages, it's also known as `Maybe`, `Option`, or `Optional`. We use `Result` to cleanly model a successful and unsuccessful outcome of the operation.

Callers of the `tryDeserializeLocalStorageItem` function have to inspect the `success` property before attempting to use the `value` or `error` properties:

```ts
const result = tryDeserializeLocalStorageItem("dark_mode");

if (result.success) {
  // We've narrowed the `success` property to `true`,
  // so we can access the `value` property
  const darkModeEnabled: unknown = result.value;

  if (typeof darkModeEnabled === "boolean") {
    // We've narrowed the `unknown` type to `boolean`,
    // so we can safely use `darkModeEnabled` as a boolean
    console.log("Dark mode enabled: " + darkModeEnabled);
  }
} else {
  // We've narrowed the `success` property to `false`,
  // so we can access the `error` property
  console.error(result.error);
}
```

Note that the `tryDeserializeLocalStorageItem` function can't simply return `null` to signal that the deserialization failed, for the following two reasons:

1. The value `null` is a valid JSON value. Therefore, we would not be able to distinguish whether we deserialized the value `null` or whether the entire operation failed because of a missing item or a syntax error.
2. If we were to return `null` from the function, we could not return the error at the same time. Therefore, callers of our function would not know why the operation failed.

For the sake of completeness, a more sophisticated alternative to this approach is to use [typed decoders](https://dev.to/joanllenas/decoding-json-with-typescript-1jjc) for safe JSON parsing. A decoder lets us specify the expected schema of the value we want to deserialize. If the persisted JSON turns out not to match that schema, the decoding will fail in a well-defined manner. That way, our function always returns either a valid or a failed decoding result and we could eliminate the `unknown` type altogether.
