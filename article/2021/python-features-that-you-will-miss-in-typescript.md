> * 原文地址：[Python features that you will miss in TypeScript](https://levelup.gitconnected.com/python-features-that-you-will-miss-in-typescript-78ecc440b8bc)
> * 原文作者：[Lucas Sonnabend](https://medium.com/@lucas_sonnabend)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/python-features-that-you-will-miss-in-typescript.md](https://github.com/xitu/gold-miner/blob/master/article/2021/python-features-that-you-will-miss-in-typescript.md)
> * 译者：
> * 校对者：

# Python features that you will miss in TypeScript

![Photo by [Alex Chumak](https://unsplash.com/@ralexnder?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/6758/0*G6G1IweBv411ufK9)

Recently I switched from python and django as the main backend language to node.js with TypeScript. After an initial learning period, I can say that I enjoyed the switch. Seeing how different languages and frameworks address similar problems is always fun. As you understand where they agree or differ in their approach, you gain a better understanding of programming itself.

In many ways TypeScript/JavaScript and python are similar. They both

* … have a modern syntax
* … are best left as a single-threaded application
* … started off as dynamic languages with static type checking added later
* … have a large ecosystem with lots of modules/packages
* … support asynchronous programming with promises and async/await
* … release new versions quite frequently (for a language)

But there are of course some differences in the languages, and sometimes it takes a bit of distance to fully appreciate the features that python and its ecosystem provided. While I enjoy coding in TypeScript in general, sometimes I come across problems where I know that they could be solved very elegantly in python. Most of the time TypeScript/JavaScript provides a similarly elegant solution, but sometimes I find myself out of luck, and I end up with something that I know could have been so much easier in python. Here is my list of features that are easy to take for granted while you are using python, but will be missed when you have to code without them: Context managers, first-order support for types, database frameworks, pytest fixtures, and dictionary generators.

## Context managers

Context managers in python have lots of use-cases, like opening and closing files, protecting your code with a lock, or custom resource management with set-up and tear-down. I really started to miss them when I worked on our backend, and we needed database transactions. In python, this is quite elegantly solved. In fact, a lot of libraries, like [django](https://docs.djangoproject.com/en/3.2/topics/db/transactions/), already provide a context manager for this!

```Python
# in the code
with db_client.transaction():
    db_client.query("UPDATE ...")
    # ....
    db_client.query("UPDATE ...")
    

# in you db client code
from contextlib import contextmanager

class DBClient:
    # ....
    @contextmanager
    def transaction(*args, **kwds):
    try:
        self.connection.query("BEGIN")
        yield
    except:
        self.connection.query("ROLLBACK")
        raise
    self.connection.query("COMMIT")
```

With TypeScript, we were using [node-postgres](https://node-postgres.com/features/transactions), and the solution closest to context managers in python involves callbacks.

```TypeScript

// in your code
await transaction(dbClient, async () => {
    dbClient.query("UPDATE ...");
    // ...
    dbClient.query("UPDATE ...");
});

// in your db client code
export const transaction = async (
    dbClient: DBClient,
    callback: async () => Promise<void>,
): Promise<void> => {
    await dbClient.query("BEGIN");
    try {
        await callback();
    } catch (err) {
        await dbClient.query("ROLLBACK");
        throw err;
    }
    await dbClient.query("COMMIT");
}

```

While this is not the worst implementation ever, but not as clean as pythons. It might trigger PTSD if you have been to the [callback hell](https://www.geeksforgeeks.org/what-is-callback-hell-in-node-js/) of JavaScript in the days before async/await. Libraries don’t provide this interface, so you have to implement it yourself, or you end up with lots of try/catch blogs for your transactions. I got those wrong at least once, which caused a bug that I luckily caught before it made it to production.

---

## First-order support for types

In python, I typically use a `dataclass` to define the schema of messages, with TypeScript I declare a `type`. At runtime python still allows me to inspect the `dataclass` class and the type of its fields. With TypeScript, there is no way to do that, as all the type information has been lost when it is compiled down to JavaScript.

Now, where is this actually useful? I am a big fan of property-based testing and generating test cases for better coverage. Python has a pretty good testing framework for this called [hypothesis](https://hypothesis.works/). It allows you to create testing strategies from a `dataclass` with type annotation, and these strategies will generate test cases.

```Python
@dataclass(frozen=True)
class AddUserEvent:
    firstName: str
    lastName: str
    dateOfBirth: date
    
# hypothesis strategy can infer the fields and their  types from 
# the type annotations of the dataclass
@given(st.builds(AddUserEvent))
def test_deserialise_is_inverse_of_serialise(addUserEvent):
    assert addUserEvent == deserialise(serialise(addUserEvent))


```

Typescript/Javascript has its own framework, [fast-check](https://github.com/dubzzz/fast-check), and for most parts, it is very similar to hypothesis. One thing it cannot do is generate testing strategies. You have to repeat the schema of your object in the type and in the testing strategy. Every change to the type has to be repeated in the testing strategy. It’s not the end of the world, because if you forget to update one, the compiler will remind you. It is still annoying, and not very DRY.

```TypeScript
type AddUserEvent = {
  firstName: string;
  lastName: string;
  dateOfBirth: Date;
};

const arbitraryAddUser: fc.Arbitrary<AddUserEvent> = fc.record({
  firstName: fc.string(),
  lastName: fc.string(),
  dateOfBirth: fc.date(),
});

test("deserialise is inverse of serialise", () => {
  fc.assert(
    fc.property(arbitraryAddUser, (addUser) => {
      expect(deserialise(serialise(addUser))).toEqual(addUser);
    }),
  );
});

```

---

## Database frameworks

I have to talk a bit more about database wrappers. I am mainly looking at libraries for SQL databases, PostgreSQL in particular. Most of the time, a simple SQL database will be sufficient for a project. Python has some pretty mature solutions with [SQLAlchemy](https://www.sqlalchemy.org/) or the ORM that comes with Django. TypeScript/JavaScript is not far behind, with TypeORM being the most popular. Those libraries allow you to evolve your schema over time, a practice coined as [evolutionary database design](https://martinfowler.com/articles/evodb.html). (A more practical example with SQLAlchemy is [here](https://benchling.engineering/move-fast-and-migrate-things-how-we-automated-migrations-in-postgres-d60aba0fc3d4), and [here](https://betterprogramming.pub/typeorm-migrations-explained-fdb4f27cb1b3) is one with TypeORM). With mature solutions in both languages, I still came across a case where the python solution, in my case Django, is more feature-rich than anything I have seen for JavaScript.

After a year or two of active development, you will have created a lot of migrations. I have worked on a Django project where at some point I was confident that the majority of fields and tables added during migrations were also either altered or removed in a later migration. Django actually provides a solution to [squash migrations](https://docs.djangoproject.com/en/3.2/topics/migrations/#squashing-migrations), to keep the total number of migrations low. You can only squash migrations that have already been applied to all production environments, so squashing is more of a clean-up to keep your code-base tidy, and making it easier to set up a development or testing database from scratch. I have not seen any TypeScript/JavaScript package that even attempts to squash migrations, and without some guard rails, I would not attempt this.

---

## Pytest fixtures

When I write tests, I try to minimise the amount of set-up and tear down each test requires, but sometimes it is inevitable, and sometimes you want to share the setup between tests. P[ytest fixtures](https://docs.pytest.org/en/6.2.x/fixture.html) are my preferred tool for this. It allows you to set up and tear down objects, either per test, shared across a module, or even all tests.

```Python
import pytest

@pytest.fixture()
def mock_client():
    # set-up
    client = mockClient()
    yield client
    # potential tear-down

def test_with_client(mock_client):
    # ...
    mock_client.send("test payload")
    # ...
```

Of course, JavaScript has a way to run set-up and tear-down code for tests. With jest, this is [beforeAll](https://jestjs.io/docs/api#beforeallfn-timeout)/[beforeEach](https://jestjs.io/docs/api#beforeeachfn-timeout) which does almost the same, with one exception: You cannot pass the object from the fixture into the test! The common way around it is to use a variable that is shared between the tests and the setup/tear-down functions.

```JavaScript
describe("Database access function", () => {
  let mockDBClient = null;
  beforeEach(async () => {
    // set-up
    mockDBClient = await setupTestingDB();
  });
  afterEach(async () => {
    // tear-down
    await mockDBClient.teardown();
  });

  it("can create a new user", async () => {
    const newUser = await createUser(mockDBClient, { name: "Paul" });
    expect(newUser).toBeDefined();
  });
});
```

This is common practice, but it is also annoying. Once you have several tests that share the same set-up/tear-down code they will all access the same global and mutable variable. This is where my alarm bells start to ring. Tests should be self-contained, without any shared state between them. And because the setup is run before every single test, they don’t actually share the same object. It is just a pity that this cannot be properly expressed in code.

There are other popular testing frameworks for TypeScript/JavaScript, like [Mocha](https://mochajs.org/), but to the best of my knowledge, they tend to provide the same [beforeAll/beforeEach hooks](https://mochajs.org/#root-hook-plugins).

---

## Dictionary generators

I often find myself with the following operation in code: I have a collection of objects, and I want to look them up according to a certain object field, usually their ID. Python has a very functional and elegant syntax for this: generators.

```Python
lookup = {elem.id: elem for elem in my_collection}
lookup2 = {
  key_func(elem.id): value_func(elem)
  for elem in my_collection
}
```

In JavaScript, you can also achieve this with little code, thanks to the [lodash](https://lodash.com/docs/#keyBy) module.

```TypeScript
import _ from "lodash"
const lookup = _.keyBy(myCollection, 'id')
const lookup2 = _.keyBy(myCollection, keyFunc).mapValues(valueFunc)
```

On their own, both solutions are clean, functional, and fast. But in comparison to the python generator lodash feels a bit clunky. It does not give you a clear visual mapping of`key: value`. When the lookup is more complicated, with functions modifying the key and value, readability degrades much more.

---

## Do those differences matter?

I have ranted about edge cases where python is more elegant than TypeScript. But focusing on the big picture, I still enjoy coding in TypeScript. There are features where TypeScript is better than python. For example, I found it easier to write more and more accurate types with TypeScript than I do with python and MyPy.

![Photo by [Piret Ilver](https://unsplash.com/@saltsup?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/6400/0*wnH40qHfyRl6dnbo)

Do those differences matter? They clearly matter to me, otherwise, I would not have written this article. Writing code means expressing what you want a computer to do concisely and legibly. It should be about the “what” as much as possible, and not the “how” it is done in a particular technology. It makes code easier to read, write and maintain, which in the end leads to fewer bugs. In the examples I gave python does a slightly better job than TypeScript.

## Final Thoughts

Does this mean I would choose python over TypeScript for the backend if I had to start all over? Definitely not. In the end, both languages have more similarities than differences. Other factors are more important, such as the expertise in your team. In our case just the fact that my team would be developing both the frontend and backend at the same time made TypeScript a favourite for us.

If you were looking for a more general comparison between the two languages, then thanks for still reading through this all the way. Hackernoon has a couple of good articles [here](https://medium.com/hackernoon/could-pythons-popularity-outperform-javascript-in-the-next-five-years-abed4e307224) and [here](https://medium.com/hackernoon/javascript-vs-python-in-2017-d31efbb641b4).

#### Resources

* [pythons hypothesis for property-based testing](https://hypothesis.works/)
* [JavaScripts fast-check for property-based testing](https://github.com/dubzzz/fast-check)
* [JavaScripts lodash module for efficient list and object manipulation](https://lodash.com/)
* [pytest fixtures](https://docs.pytest.org/en/6.2.x/fixture.html)
* [jest JavaScript testing framework](https://jestjs.io/)
* [evolutionary database design](https://martinfowler.com/articles/evodb.html)
* [working example of evolutionary database design with SQAlchemy](https://benchling.engineering/move-fast-and-migrate-things-how-we-automated-migrations-in-postgres-d60aba0fc3d4)
* [working example of evolutionary database design with TypeORM](https://betterprogramming.pub/typeorm-migrations-explained-fdb4f27cb1b3)
* [squashing migrations with Django](https://docs.djangoproject.com/en/3.2/topics/migrations/#squashing-migrations)
* [python vs javascript article #1](https://medium.com/hackernoon/could-pythons-popularity-outperform-javascript-in-the-next-five-years-abed4e307224)
* [python vs JavaScript article #2](https://medium.com/hackernoon/javascript-vs-python-in-2017-d31efbb641b4)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
