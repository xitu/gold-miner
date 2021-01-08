> * 原文地址：[Elixir, Phoenix, Absinthe, GraphQL, React, and Apollo: an absurdly deep dive - Part 1](https://schneider.dev/blog/elixir-phoenix-absinthe-graphql-react-apollo-absurdly-deep-dive/)
> * 原文作者：[Zach Schneider](https://www.github.com/schneidmaster)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/elixir-phoenix-absinthe-graphql-react-apollo-absurdly-deep-dive-1.md](https://github.com/xitu/gold-miner/blob/master/TODO1/elixir-phoenix-absinthe-graphql-react-apollo-absurdly-deep-dive-1.md)
> * 译者：[Xuyuey](https://github.com/Xuyuey)
> * 校对者：[Fengziyin1234](https://github.com/Fengziyin1234)

# Elixir、Phoenix、Absinthe、GraphQL、React 和 Apollo：一次近乎疯狂的深度实践 —— 第一部分

不知道你是否和我一样，在本文的标题中，至少有 3 个或 4 个关键字属于“我一直想玩，但还从未接触过”的类型。React 是一个例外；在每天的工作中我都会用到它，对它已经非常熟悉了。在几年前的一个项目中我用到了 Elixir，但那已经是很早以前的事情了，而且我从未在 GraphQL 的环境中是使用过它。同样的，在另外一个项目中，我做了一小部分关于 GraphQL 的工作，该项目的后端使用的是 Node.js，前端使用的是 Relay，但我仅仅触及了 GraphQL 的皮毛，而且到目前为止我没有接触过 Apollo。我坚信学习技术的最好方法就是用它们来构建一些东西，所以我决定深入研究并构建一个包含所有这些技术的 Web 应用程序。如果你想跳到最后，代码是在 [GitHub](https://github.com/schneidmaster/socializer) 上，现场演示在[这里](https://socializer-demo.herokuapp.com)。(现场演示在免费的 Heroku dyno 上运行，所以当你访问它时可能需要 30 秒左右才能唤醒。)

## 定义我们的术语

首先，让我们来看看我在上面提到的那些组件，以及它们如何组合在一起。

* [Elixir](https://elixir-lang.org) 是一种服务端编程语言。
* [Phoenix](https://phoenixframework.org) 是 Elixir 最受欢迎的 Web 服务端框架。Ruby : Rails :: Elixir : Phoenix。
* [GraphQL](https://graphql.org) 是一种用于 API 的查询语言。
* [Absinthe](https://hexdocs.pm/absinthe/overview.html) 是最流行的 Elixir 库，用于实现 GraphQL 服务器。
* [Apollo](https://www.apollographql.com/docs/react) 是一个流行的 JavaScript 库，搭配 GraphQL API 使用。（Apollo 还有一个服务端软件包，用于在 Node.js 中实现 GraphQL 服务器，但我只使用了它的客户端配合我搭建的 Elixir GraphQL 服务端。）
* [React](https://reactjs.org) 是一个流行的 JavaScript 框架，用于构建前端用户界面。（这个你可能已经知道了。）

## 我在构建的是什么？

我决定构建一个迷你的社交网络。看起来好像很简单，可以在合理的时间内完成，但是它也足够复杂，可以让我遇到一切在真实场景下的应用程序中才会出现的挑战。我的社交网络被我创造性地称为 Socializer。用户可以在其他用户的帖子下面发帖和评论。Socializer 还有聊天功能; 用户可以与其他用户进行私人对话，每个对话可以有任意数量的用户（即群聊）。

## 为什么选择 Elixir？

Elixir 在过去几年中越来越流行。它在 Erlang VM 上运行，你可以直接在 Elixir 文件中写 Erlang 语法，但它旨在为开发人员提供更友好的语法，同时保持 Erlang 的速度和容错能力。Elixir 是动态类型的，语法与 ruby 类似。但是它比 ruby 更具功能性，并且有很多不同的惯用语法和模式。

至少对于我而言，Elixir 的主要吸引力在于 Erlang VM 的性能。坦白的说这看起来很荒谬。但使用 Erlang 使得 WhatsApp 的团队能够和[单个服务器建立 **200 万**个连接](https://blog.whatsapp.com/196/1-million-is-so-2011)。一个 Elixir/Phoenix 服务器通常可以在不到 1 毫秒的时间内提供简单的请求；看到终端日志中请求持续时间的 μ 符号真让人兴奋不已。

Elixir 还有其他好处。它的设计是容错的；你可以将 Erlang VM 视为一个节点集群，任何一个节点的宕机都可以不影响其他节点。这也使“热代码交换”成为可能，部署新代码时无需停止和重启应用程序。我发现它的[模式匹配（pattern matching）](https://elixirschool.com/en/lessons/basics/pattern-matching)和[管道操作符（pipe operator）](https://elixirschool.com/en/lessons/basics/pipe-operator)也非常有意思。令人耳目一新的是，它在编写功能强大的代码时，近乎和 ruby 一样给力，而且我发现它可以驱使我更清楚地思考代码，写更少的 bug。

## 为什么选择 GraphQL？

使用传统的 RESTful API，服务器会事先定义好它可以提供的资源和路由（通过 API 文档，或者通过一些自动化生成 API 的工具，如 Swagger），使用者必须制定正确的调用顺序来获取他们想要的数据。如果服务端有一个帖子的 API 来获取博客的帖子，一个评论的 API 用于获取帖子的评论，一个用户信息的 API 获取用户的姓名和图片，使用者可能必须发送三个单独的请求，来获取渲染一个视图所必要的信息。（对于这样一个小案例，显然 API 可能允许你一次性得到所有相关数据，但它也说明了传统 RESTful API 的缺点 —— 请求结构由服务器任意定义，而不能匹配每个使用者和页面的动态需求）。GraphQL 反转了这个原则 —— 客户端先发送一个描述所需数据的查询文档（可能跨越表关系），然后服务器在这个请求中返回所有需要的数据。拿我们的博客举例来说，一个帖子的查询请求可能会是下面这样：

```graphql
query {
  post(id: 123) {
    id
    body
    createdAt
    user {
      id
      name
      avatarUrl
    }
    comments {
      id
      body
      createdAt
      user {
        id
        name
        avatarUrl
      }
    }
  }
}
```

这个请求描述了渲染一个博客帖子页面时，使用者可能会用到的所有信息：帖子的 ID、内容以及时间戳；发布帖子的用户的 ID、姓名和头像 URL；帖子评论的 ID、内容和时间戳；以及提交每条评论的用户的 ID，名称和头像 URL。结构非常直观灵活；它非常适合构建接口，因为你可以只描述所需的数据，而不是痛苦地适应 API 提供的结构。

GraphQL 中还有两个关键概念：mutation（变更）和 subscription（订阅）。Mutation 是一种对服务器上的数据进行更改的查询; 它相当于 RESTful API 中的 POST/PATCH/PUT。语法与查询非常相似; 创建帖子的 mutation 可能是下面这样的：

```graphql
mutation {
  createPost(body: $body) {
    id
    body
    createdAt
  }
}
```

一条数据库记录的属性通过参数提供，{} 里的代码块描述了一旦 mutation 完成需要返回的数据（在我们的例子中是新帖子的 ID、内容以及时间戳）。

一个 subscription 对于 GraphQL 是相当特别的；在 RESTful API 中并没有一个直接和它对应的东西。它允许客户端在特定事件发生时从服务器接收实时更新。例如，如果我希望每次创建新帖子时都实时更新主页，我可能会写一个这样的帖子 subscription：

```graphql
subscription {
  postCreated {
    id
    body
    createdAt
    user {
      id
      name
      avatarUrl
    }
  }
}
```

正如你想知道的那样，这段代码告诉服务器在创建新帖子时向我发送实时更新，包括帖子的 ID、内容和时间戳，以及作者的 ID、姓名和头像 URL。Subscription 通常由 websockets 支持；客户端保持对服务器开放的套接字，无论什么时候只要事件发生，服务器就会向客户端发送消息。

最后一件事 —— GraphQL 有一个非常棒的开发工具，叫做 GraphiQL。它是一个带有实时编辑器的 Web 界面，你可以在其中编写查询、执行查询语句并查看结果。它包括自动补全和其他语法糖，使你可以轻松找到可用的查询语句和字段; 当你在迭代查询结构时，它表现的特别棒。你可以试试我的 web 应用程序的 [GraphiQL 界面](https://brisk-hospitable-indianelephant.gigalixirapp.com/graphiql)。试试向它发送以下的查询语句以获取具有关联数据的帖子列表（下面展示的例子是一个略微修剪的版本）：

```graphql
query {
  posts {
    id
    body
    insertedAt
    user {
      id
      name
    }
    comments {
      id
      body
      user {
        id
        name
      }
    }
  }
}
```

## 为什么选择 Apollo？

Apollo 已经成为服务器和客户端上最受欢迎的 GraphQL 库之一。上次使用 GraphQL 还是 2016 年时和 [Relay](https://facebook.github.io/relay) 一起，Relay 是另外一个客户端的 JavaScript 库。实话说，我讨厌它。我被 GraphQL 简单易写的查询语句所吸引，相比较而言，Relay 让我感觉非常复杂而且难以理解；它的文档里有很多术语，我发现很难构建一个知识基础让我理解它。公平地说，那是 Relay 的 1.0 版本；他们已经做了很大的改动来简化库（他们称之为 Relay Modern），文档也比过去好了很多。但是我想尝试新的东西，Apollo 之所以这么受欢迎，部分原因是它为构建 GraphQL 客户端应用程序提供了相对简单的开发体验。

## 服务端

我们先来构建应用程序的服务端；没有数据使用的话，客户端就没有那么有意思了。我也很好奇 GraphQL 如何能够实现在客户端编写查询语句，然后拿到所有我需要的数据。（相比之前，在没有 GraphQL 之前的实现方法中，你需要回来对服务端做一些改动）。

具体来说，我首先定义了应用程序的基本 model（模型）结构。在高层次抽象上，它看起来像这样：

```text
User
- Name
- Email
- Password hash

Post
- User ID
- Body

Comment
- User ID
- Post ID
- Body

Conversation
- Title (只是将参与者的名称反规范化为字符串)

ConversationUser（每一个 conversation 都可以有任意数量的 user）
- Conversation ID
- User ID

Message
- Conversation ID
- User ID
- Body
```

万幸这很简单明了。Phoenix 允许你编写与 Rails 非常相似的数据库迁移。以下是创建 users 表的迁移，例如：

```elixir
# socializer/priv/repo/migrations/20190414185306_create_users.exs
defmodule Socializer.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :email, :string
      add :password_hash, :string

      timestamps()
    end

    create unique_index(:users, [:email])
  end
end
```

你可以在[这里](https://github.com/schneidmaster/socializer/tree/master/priv/repo/migrations)查看所有其他表的迁移。

接下来，我实现了 model 类。Phoenix 使用一个名为 Ecto 的库作为它的 model 的实现；你可以将 Ecto 看作与 ActiveRecord 类似的东西，但它与框架的耦合程度更低。一个主要区别是 Ecto model 没有任何实例方法。Model 实例只是一个结构（就像带有预定义键的哈希）；你在 model 上定义的方法都是类的方法，它们接受一个“实例”（结构），然后用某种方式更改这个实例，再返回结果。在 Elixir 中这是一种惯用方法; 它更偏好函数式编程和不可变变量（不能二次赋值的变量）。

这是对 Post model 的分解：

```elixir
# socializer/lib/socializer/post.ex
defmodule Socializer.Post do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias Socializer.{Repo, Comment, User}

  # ...
end
```

首先，我们引入一些其他模块。在 Elixir 中，`import` 可以引入其它模块的功能（类似于 `include` ruby 中的 model）；`use` 调用特定模块上的 `__using__` 宏。宏是 Elixir 的元编程机制。`alias` 使得命名空间模块可以通过它们的基本名称被访问到（所以我可以引用一个 `User` 而不是到处使用 `Socializer.User` 类型）。

```elixir
# socializer/lib/socializer/post.ex
defmodule Socializer.Post do
  # ...

  schema "posts" do
    field :body, :string

    belongs_to :user, User
    has_many :comments, Comment

    timestamps()
  end

  # ...
end
```

接下来，我们有了一个 schema（模式）。Ecto model 必须在 schema 中显式描述 schema 中的每个属性（不同于 ActiveRecord，例如，它会对底层数据库表进行内省并为每个字段创建属性）。在上一节中我们使用 `use Ecto.Schema` 引入了 `schema` 宏。

```elixir
# socializer/lib/socializer/post.ex
defmodule Socializer.Post do
  # ...

  def all do
    Repo.all(from p in __MODULE__, order_by: [desc: p.id])
  end

  def find(id) do
    Repo.get(__MODULE__, id)
  end

  # ...
end
```

接着，我定义了一些辅助函数来从数据库中获取帖子。在 Ecto model 的帮助下，`Repo` 模块用来处理所有数据库查询；例如，`Repo.get(Post, 123)` 会使用 ID 123 查找对应的帖子。`search` 方法中的数据库查询语法由写在类顶部的 `import Ecto.Query` 提供。最后，`__MODULE__` 是对当前模块的简写（即 `Socializer.Post`）。

```elixir
# socializer/lib/socializer/post.ex
defmodule Socializer.Post do
  # ...

  def create(attrs) do
    attrs
    |> changeset()
    |> Repo.insert()
  end

  def changeset(attrs) do
    %__MODULE__{}
    |> changeset(attrs)
  end

  def changeset(post, attrs) do
    post
    |> cast(attrs, [:body, :user_id])
    |> validate_required([:body, :user_id])
    |> foreign_key_constraint(:user_id)
  end
end
```

Changeset 方法是 Ecto 提供的创建和更新记录的方法：首先是一个 `Post` 结构（来自现有的帖子或者一个空结构），“强制转换”（应用）已更改的属性，进行必要的验证，然后将其插入到数据库中。

这是我们的第一个 model。你可以在[这里](https://github.com/schneidmaster/socializer/tree/master/lib/socializer)找到其它 model。

## GraphQL schema

接下来，我连接了服务器的 GraphQL 组件。这些组件通常可以分为两类：type（类型）和 resolver（解析器）。在 type 文件中，你使用类似 DSL 的语法来声明可以查询的对象、字段和关系。Resolver 用来告诉服务器如何响应任何给定查询。

下面是帖子 type 文件的示例：

```elixir
# socializer/lib/socializer_web/schema/post_types.ex
defmodule SocializerWeb.Schema.PostTypes do
  use Absinthe.Schema.Notation
  use Absinthe.Ecto, repo: Socializer.Repo

  alias SocializerWeb.Resolvers

  @desc "A post on the site"
  object :post do
    field :id, :id
    field :body, :string
    field :inserted_at, :naive_datetime

    field :user, :user, resolve: assoc(:user)

    field :comments, list_of(:comment) do
      resolve(
        assoc(:comments, fn comments_query, _args, _context ->
          comments_query |> order_by(desc: :id)
        end)
      )
    end
  end

  # ...
end
```

在 `use` 和 `import` 之后，我们首先为 GraphQL 简单地定义了 `:post` 对象。字段 ID、内容和 inserted_at 将直接使用 `Post` 结构中的值。接下来，我们声明了一些可以在查询帖子时使用到的关联关系 —— 创建帖子的用户和帖子上的评论。我重写了评论的关联关系只是为了确保我们可以得到按照插入顺序返回的评论。注意啦：Absinthe 自动处理了请求和查询字段名称的大小写 —— Elixir 中使用 snake_case 对变量和方法命名，而 GraphQL 的查询中使用的是 camelCase。

```elixir
# socializer/lib/socializer_web/schema/post_types.ex
defmodule SocializerWeb.Schema.PostTypes do
  # ...

  object :post_queries do
    @desc "Get all posts"
    field :posts, list_of(:post) do
      resolve(&Resolvers.PostResolver.list/3)
    end

    @desc "Get a specific post"
    field :post, :post do
      arg(:id, non_null(:id))
      resolve(&Resolvers.PostResolver.show/3)
    end
  end

  # ...
end
```

接下来，我们将声明一些涉及帖子的底层查询。`posts` 允许查询网站上的所有帖子，同时 `post` 可以按照 ID 返回单个帖子。Type 文件只是简单地声明了查询语句以及它的参数和返回值类型；实际的实现都被委托给了 resolver。

```elixir
# socializer/lib/socializer_web/schema/post_types.ex
defmodule SocializerWeb.Schema.PostTypes do
  # ...

  object :post_mutations do
    @desc "Create post"
    field :create_post, :post do
      arg(:body, non_null(:string))

      resolve(&Resolvers.PostResolver.create/3)
    end
  end

  # ...
end
```

在查询之后，我们声明了一个允许在网站上创建新帖子的 mutation。与查询一样，type 文件只是声明有关  mutation 的元数据，实际操作由 resolver 完成。

```elixir
# socializer/lib/socializer_web/schema/post_types.ex
defmodule SocializerWeb.Schema.PostTypes do
  # ...

  object :post_subscriptions do
    field :post_created, :post do
      config(fn _, _ ->
        {:ok, topic: "posts"}
      end)

      trigger(:create_post,
        topic: fn _ ->
          "posts"
        end
      )
    end
  end
end
```

最后，我们声明与帖子相关的 subscription，`:post_created`。这允许客户端订阅和接收创建新帖子的更新。`config` 用于配置 subscription，同时 `trigger` 会告诉 Absinthe 应该调用哪一个 mutation。`topic` 允许你可以细分这些 subscription 的响应 —— 在这个例子中，不管是什么帖子的更新我们都希望通知客户端，在另外一些例子中，我们只想要通知某些特定的更新。例如，下面是关于评论的 subscription —— 客户端只想要知道关于某个特定帖子（而不是所有帖子）的新评论，因此它提供了一个带 `post_id` 参数的 topic。

```elixir
defmodule SocializerWeb.Schema.CommentTypes do
  # ...

  object :comment_subscriptions do
    field :comment_created, :comment do
      arg(:post_id, non_null(:id))

      config(fn args, _ ->
        {:ok, topic: args.post_id}
      end)

      trigger(:create_comment,
        topic: fn comment ->
          comment.post_id
        end
      )
    end
  end
end
```

虽然我已经将和每个 model 相关的代码按照不同的功能写在了不同的文件里，但值得注意的是，Absinthe 要求你在一个单独的 `Schema` 模块中组装所有类型的文件。如下面所示：

```elixir
defmodule SocializerWeb.Schema do
  use Absinthe.Schema
  import_types(Absinthe.Type.Custom)

  import_types(SocializerWeb.Schema.PostTypes)
  # ...other models' types

  query do
    import_fields(:post_queries)
    # ...other models' queries
  end

  mutation do
    import_fields(:post_mutations)
    # ...other models' mutations
  end

  subscription do
    import_fields(:post_subscriptions)
    # ...other models' subscriptions
  end
end
```

## Resolver（解析器）

正如我上面提到的，resolver 是 GraphQL 服务器的“粘合剂” —— 它们包含为 query 提供数据的逻辑或应用 mutation 的逻辑。让我们看一下 `post` 的 resolver：

```elixir
# lib/socializer_web/resolvers/post_resolver.ex
defmodule SocializerWeb.Resolvers.PostResolver do
  alias Socializer.Post

  def list(_parent, _args, _resolutions) do
    {:ok, Post.all()}
  end

  def show(_parent, args, _resolutions) do
    case Post.find(args[:id]) do
      nil -> {:error, "Not found"}
      post -> {:ok, post}
    end
  end

  # ...
end
```

前两个方法处理上面定义的两个查询 —— 加载所有的帖子的查询以及加载特定帖子的查询。Absinthe 希望每个 resolver 方法都返回一个元组 —— `{:ok, requested_data}` 或者 `{:error, some_error}`（这是 Elixir 方法的常见模式）。`show` 方法中的 `case` 声明是 Elixir 中一个很好的模式匹配的例子 —— 如果 `Post.find` 返回 `nil`，我们返回错误元组；否则，我们返回找到的帖子数据。

```elixir
# lib/socializer_web/resolvers/post_resolver.ex
defmodule SocializerWeb.Resolvers.PostResolver do
  # ...

  def create(_parent, args, %{
        context: %{current_user: current_user}
      }) do
    args
    |> Map.put(:user_id, current_user.id)
    |> Post.create()
    |> case do
      {:ok, post} ->
        {:ok, post}

      {:error, changeset} ->
        {:error, extract_error_msg(changeset)}
    end
  end

  def create(_parent, _args, _resolutions) do
    {:error, "Unauthenticated"}
  end

  # ...
end
```

接下来，我们有 `create` 的 resolver，其中包含创建新帖子的逻辑。这也是通过方法参数进行模式匹配的一个很好的例子 —— Elixir 允许你重载方法名称并选择第一个与声明的模式匹配的方法。在这个例子中，如果第三个参数是带有 `context` 键的映射，并且该映射中还包括一个带有 `current_user` 键值对的映射，那么就使用第一个方法；如果某个查询没有携带身份验证信息，它将匹配第二种方法并返回错误信息。

```elixir
# lib/socializer_web/resolvers/post_resolver.ex
defmodule SocializerWeb.Resolvers.PostResolver do
  # ...

  defp extract_error_msg(changeset) do
    changeset.errors
    |> Enum.map(fn {field, {error, _details}} ->
      [
        field: field,
        message: String.capitalize(error)
      ]
    end)
  end
end
```

最后，如果 post 的属性无效（例如，内容为空），我们有一个简单的辅助方法来返回错误响应。Absinthe 希望错误消息是一个字符串，一个字符串数组，或一个带有 `field` 和 `message` 键的关键字列表数组 —— 在我们的例子中，我们将每个字段的 Ecto 验证错误信息提取到这样的关键字列表中。

## 上下文（context）/认证（authentication）

我们在最后一节中来谈谈查询认证的概念 —— 在我们的例子中，简单地在请求头里的 `authorization` 属性中用了一个 `Bearer: token` 做标记。我们如何利用这个 token 获取 resolver 中 `current_user`  的上下文呢？可以使用自定义插件（plug）读取头部然后查找当前用户。在 Phoenix 中，一个插件是请求管道中的一部分 —— 你可能拥有解码 JSON 的插件，添加 CORS 头的插件，或者处理请求的任何其他可组合部分的插件。我们的插件如下所示：

```elixir
# lib/socializer_web/context.ex
defmodule SocializerWeb.Context do
  @behaviour Plug

  import Plug.Conn

  alias Socializer.{Guardian, User}

  def init(opts), do: opts

  def call(conn, _) do
    context = build_context(conn)
    Absinthe.Plug.put_options(conn, context: context)
  end

  def build_context(conn) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
         {:ok, claim} <- Guardian.decode_and_verify(token),
         user when not is_nil(user) <- User.find(claim["sub"]) do
      %{current_user: user}
    else
      _ -> %{}
    end
  end
end
```

前两个方法只是按例行事 —— 在初始化方法中没有什么有趣的事情可做（在我们的例子中，我们可能会基于配置选项利用初始化函数做一些工作），在调用插件方法中，我们只是想要在请求上下文中设置当前用户的信息。`build_context` 方法是最有趣的部分。`with` 声明在 Elixir 中是另一种模式匹配的写法；它允许你执行一系列不对称步骤并根据上一步的结果执行操作。在我们的例子中，首先去获得请求头里的 authorization 属性值；然后解码 authentication token（使用了 [Guardian](https://github.com/ueberauth/guardian) 库）；接着再去查找用户。如果所有步骤都成功了，那么我们将进入 `with` 函数块内部，返回一个包含当前用户信息的映射。如果任意一个步骤失败（例如，假设模式匹配失败第二步会返回一个 `{:error, ...}` 元组；假设用户不存在第三步会返回一个 `nil`），然后 `else` 代码块中的内容被执行，我们就不去设置当前用户。

---

- [Elixir、Phoenix、Absinthe、GraphQL、React 和 Apollo：一次近乎疯狂的深度实践 —— 第一部分](https://github.com/xitu/gold-miner/blob/master/TODO1/elixir-phoenix-absinthe-graphql-react-apollo-absurdly-deep-dive-1.md)
- [Elixir、Phoenix、Absinthe、GraphQL、React 和 Apollo：一次近乎疯狂的深度实践 —— 第二部分](https://github.com/xitu/gold-miner/blob/master/TODO1/elixir-phoenix-absinthe-graphql-react-apollo-absurdly-deep-dive-2.md)

---

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
