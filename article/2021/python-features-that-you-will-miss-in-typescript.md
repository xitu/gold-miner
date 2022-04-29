> * 原文地址：[Python features that you will miss in TypeScript](https://levelup.gitconnected.com/python-features-that-you-will-miss-in-typescript-78ecc440b8bc)
> * 原文作者：[Lucas Sonnabend](https://medium.com/@lucas_sonnabend)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/python-features-that-you-will-miss-in-typescript.md](https://github.com/xitu/gold-miner/blob/master/article/2021/python-features-that-you-will-miss-in-typescript.md)
> * 译者：[没事儿](https://github.com/Tong-H)
> * 校对者：[nia3y](https://github.com/nia3y) [greycodee](https://github.com/greycodee)

# 使用 TypeScript 时你会想念的 Python 特性

![图片来自 [Alex Chumak](https://unsplash.com/@ralexnder?utm_source=medium&utm_medium=referral) 发布于 [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/6758/0*G6G1IweBv411ufK9)

最近我把主要使用的后端语言从 Python 和 Django 切换到了 Node.js 和 TypeScript。在经过一段初始学习期后，我可以说我很享受这次切换。了解不同的语言和框架如何处理相似的问题总是很有趣。当你理解它们方法之间的一致或差异时，你也会对编程本身有更好的理解。

TypeScript/JavaScript 和 Python 在很多地方都很相似。它们都

* … 包含现代语法
* … 最好作为一个单线程应用
* … 一开始是动态语言，而后添加静态类型检查
* … 拥有一个庞大生态圈，包含大量模块/包
* … 支持使用 promises 和 async/await 异步编程
* … 很频繁地发布新版本（对于一种语言而言）

当然它们在语言上也存在一些差异，有时候需要拉开距离才能完全体会到 Python 及其生态圈所提供的特性。虽然总体来说我很喜欢使用 TypeScript 编码，但有时候我会遇到一些问题，而这些问题我知道在  Python 中可以很优雅的解决。大部分时候 TypeScript/JavaScript 都能提供一个类似且优雅的解决方案，但有时候我发现自己运气不好，最终我知道有些情况用 Python 会简单很多。这里是一个特性列表，当你使用 Python 时你会认为是理所当然，但如果编码时没有它们你会想念的：上下文管理器（Context managers），对类型的一阶支持（first-order support for types），数据库框架（database frameworks），单元测试框架（pytest fixtures），以及字典生成器（dictionary generators）。

## 上下文管理器

Python 中的上下文管理器有很多用例，比如打开和关闭文件，用锁保护你的代码，或者通过 set-up 和 tear-down 来自定义资源管理。当我写我们的后端时我真的开始想念它们，而我们需要数据库事务（database transactions）。在 Python 中，这个可以完美解决。实际上，有很多库比如 [django](https://docs.djangoproject.com/en/3.2/topics/db/transactions/)，都提供上下文管理器来解决这个。

```Python
# 在你的代码中
with db_client.transaction():
    db_client.query("UPDATE ...")
    # ....
    db_client.query("UPDATE ...")
    

# 在你的数据库客户端代码中
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

在 TypeScript 中，我们使用 [node-postgres](https://node-postgres.com/features/transactions)，最接近于 Python 的上下文管理器的解决方案，涉及回调函数。

```TypeScript

// 在你的代码中
await transaction(dbClient, async () => {
    dbClient.query("UPDATE ...");
    // ...
    dbClient.query("UPDATE ...");
});

// 在你的数据库客户端代码中
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

虽然这并不是最糟糕的实现，但并不如 Python 干净简洁。如果你曾见识过在 async/await 出现之前 JavaScript 的[回调地狱](https://www.geeksforgeeks.org/what-is-callback-hell-in-node-js/), 那这可能会引发你的 PTSD（创伤后应激障碍）。库不提供这个接口，所以你需要自己实现，或者最终在事务中使用大量的 try/catch。这些导致 bug 的错误我至少犯过一次，但幸运的是我在它发生在生产环境前发现了。

## 对类型的一阶支持

在 Python 中，我通常使用一个 `dataclass` 来定义消息的模型（schema）；在 TypeScript 中，我会声明一个 `type`。在 Python 运行时，我依然可以去检查 `dataclass` 类及其字段类型。而在 TypeScript 中无法这样做，因为所有的类型信息都会在编译为 JavaScript 时丢失。

现在这个特性真正有用的地方是哪里呢？我非常喜欢基于属性的测试及生成测试用例以求更好的覆盖范围，对此 Python 有一个非常棒的测试框架 [hypothesis](https://hypothesis.works/)。它可以从带有类型注解的 `dataclass` 生成测试策略，而这些策略将会生成测试用例。

```Python
@dataclass(frozen=True)
class AddUserEvent:
    firstName: str
    lastName: str
    dateOfBirth: date
    
# 假设策略可以从 dataclass 的类型注解中推断出字段及其类型
dataclass 的类型注释
@given(st.builds(AddUserEvent))
def test_deserialise_is_inverse_of_serialise(addUserEvent):
    assert addUserEvent == deserialise(serialise(addUserEvent))
```

Typescript/Javascript 有自己的框架 [fast-check](https://github.com/dubzzz/fast-check)，在很多部分与 hypothesis 非常相似。但它无法生成测试策略。你必须在类型以及测试策略中重复对象的模型（schema）。类型的每个改变都必须在测试策略中重复。这还没有结束，如果有一个你忘了更新，编译器就会提醒你。这依然恼人，而且代码复用率并不高。

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

## 数据库框架

关于封装数据库的库，我必须得说多一点。我主要寻找有关 SQL 数据库的库，特别是 PostgreSQL。通常一个简单的 SQL 数据对于一个项目来说已经足够了。Python 有一些非常成熟的方案 [SQLAlchemy](https://www.sqlalchemy.org/) 或者 Django 的 ORM。TypeScript/JavaScript 也并不差，最流行的是 TypeORM。这些库能够对数据库模型进行增量改进，称之为[渐进式数据库设计（evolutionary database design）](https://martinfowler.com/articles/evodb.html)。（一个更实用的 [SQLAlchemy 例子](https://benchling.engineering/move-fast-and-migrate-things-how-we-automated-migrations-in-postgres-d60aba0fc3d4)，以及 [TypeORM 的例子](https://betterprogramming.pub/typeorm-migrations-explained-fdb4f27cb1b3)）。尽管两种语言都有成熟的方案，但我依然遇到过这样的情况，Python 解决方案在我的 Django 项目中展现的特性比我在 JavaScript 中见过的更丰富。

经过一两年积极的开发后，你会创建很多的迁移。我曾在一个 Django 项目中工作过，某些时候，我确信迁移过程中添加的大部分字段和表在以后迁移时要么被修改要么被删。而实际上 Django 提供了一个解决方案 [squash migrations（压缩迁移）](https://docs.djangoproject.com/en/3.2/topics/migrations/#squashing-migrations)，用以保持较低的迁移数量。你只能压缩那些已应用于所有产品环境的迁移，所以压缩更多是为了保持整洁的代码基础而做的清理，也使得从零开始开发和测试数据库更容易。我还没有见过 TypeScript/JavaScript 有类似的包，甚至尝试去压缩迁移的包，如果没有防护措施，我不会去尝试。

## Pytest fixtures

在我写测试时，我尽量减少每个测试所需的初始化 set-up（初始化）和 tear-down（拆毁）的数量，但有时却是必须的，而有时你想在测试之间分享 set-up。对此，我首选 [Pytest fixtures](https://docs.pytest.org/en/6.2.x/fixture.html)，它使你 set-up 以及 tear-down 对象，既是用于单个测试，又可以跨模块共享，甚至运用于所有的测试中。

```Python
import pytest

@pytest.fixture()
def mock_client():
    # set-up
    client = mockClient()
    yield client
    # 潜在的 tear-down

def test_with_client(mock_client):
    # ...
    mock_client.send("test payload")
    # ...
```

当然，JavaScript 也有办法运行 set-up 和 tear-down。在 jest 中，[beforeAll](https://jestjs.io/docs/api#beforeallfn-timeout)/[beforeEach](https://jestjs.io/docs/api#beforeeachfn-timeout) 和 set-up/tear-down 几乎是一样的，只有一个例外：无法从 fixture（测试前准备、测试后清理的固定代码，即上面提到的 set-up/tear-down）传递对象到测试用例！通常的做法是在测试用例以及 set-up/tear-down 函数之间分享变量。

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

这是普遍的做法，但依然有点恼人。一旦你有几个测试共享相同的 set-up/tear-down 代码，那它们都会访问相同的全局对象和变量。这是我的警铃开始响起的地方。测试之间应该是彼此独立的，不应该有任何共享的状态。因为 set-up 运行于每个测试之前，所以它们实际上并不共享相同的对象。很遗憾的是不能恰当的表现在代码中。

TypeScript/JavaScript 还有其他流行的测试框架，比如 [Mocha](https://mochajs.org/)，但据我所知，它们往往提供相同的 [beforeAll/beforeEach 钩子](https://mochajs.org/#root-hook-plugins)。

## 字典生成器

我经常发现自己在代码中有这个操作：我有一个对象集合，然后我想根据对象的一个字段（通常是它们的 ID）查找他们。对此，Python 有一个非常实用和优雅的语法 generators。

```Python
lookup = {elem.id: elem for elem in my_collection}
lookup2 = {
  key_func(elem.id): value_func(elem)
  for elem in my_collection
}
```

在 JavaScript，感谢 [lodash](https://lodash.com/docs/#keyBy) 模块，你也可以使用很少的代码实现这样的功能。

```TypeScript
import _ from "lodash"
const lookup = _.keyBy(myCollection, 'id')
const lookup2 = _.keyBy(myCollection, keyFunc).mapValues(valueFunc)
```

就本身而言，两种方法都很干净且快速有效。但相比于 Python 的 generator，lodash 没有给你一个清晰的 `key: value` 视觉映射，会感觉有一点笨重。当查找变得更复杂时，通过函数修改键值，可读性会下降很多。

## 这些差异重要吗？

我抱怨过在边缘情况下 Python 比 TypeScript 更优雅。但总体来说，我依然很享受使用 TypeScript 编码。在某些功能上，TypeScript 比 Python 更好，比如使用 TypeScript 编写精确的类型比我使用 Python 和 MyPy 更容易。

![图片来自 [Piret Ilver](https://unsplash.com/@saltsup?utm_source=medium&utm_medium=referral) 发布于 [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/6400/0*wnH40qHfyRl6dnbo)

这些差异重要吗？对我来说无疑是重要的，否则我就不会写这篇文章了。写代码意味着简洁清晰的表达出你想要电脑去做什么。这个着重点应该尽可能的是“做的内容”，而不是“如何”用某种技术完成的。这会使代码更易读、编写及维护，最终减少 bug 数量。在我给出的例子中，Python 做得比 TypeScript 稍微好些。

## 结语

如果我需要重新开始，这是否意味着我将选择 Python 作为后端而不是 TypeScript ？肯定不是。总的来说，这两种语言的相似之处多于差异。而相比起这些差异，其他因素更重要，比如你的团队更擅长哪一个。我的团队需要同时开发前端和后端，而这一事实使得 TypeScript 最适合我们。

如果你在寻找这两种语言之间更综合的比较，那么感谢你仍然阅读这篇文章。Hackernoon 有两篇不错的文章 [这里](https://medium.com/hackernoon/could-pythons-popularity-outperform-javascript-in-the-next-five-years-abed4e307224) 和 [这里](https://medium.com/hackernoon/javascript-vs-python-in-2017-d31efbb641b4)。

## 资源

- [Python hypothesis：基于属性的测试（property-based testing）](https://hypothesis.works/)
- [JavaScript fast-check：基于属性的测试（property-based testing](https://github.com/dubzzz/fast-check)
- [JavaScripts lodash：高效的列表及对象操作](https://lodash.com/)
* [pytest fixtures](https://docs.pytest.org/en/6.2.x/fixture.html)
- [jest JavaScript 测试框架](https://jestjs.io/)
- [渐进式数据库设计](https://martinfowler.com/articles/evodb.html)
- [使用 SQAlchemy 渐进式数据库设计的案例](https://benchling.engineering/move-fast-and-migrate-things-how-we-automated-migrations-in-postgres-d60aba0fc3d4)
- [使用 TypeORM 渐进式数据库设计的案例](https://betterprogramming.pub/typeorm-migrations-explained-fdb4f27cb1b3)
- [Django 的 squashing migrations ](https://docs.djangoproject.com/en/3.2/topics/migrations/#squashing-migrations)
- [Python vs JavaScript 文章 #1](https://medium.com/hackernoon/could-pythons-popularity-outperform-javascript-in-the-next-five-years-abed4e307224)
- [Python vs JavaScript 文章 #2](https://medium.com/hackernoon/javascript-vs-python-in-2017-d31efbb641b4)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
